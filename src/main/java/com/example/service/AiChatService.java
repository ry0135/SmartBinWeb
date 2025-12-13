package com.example.service;

import com.google.gson.*;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class AiChatService {

    @Value("${openai.api.key}")
    private String openAiApiKey;

    @Value("${openai.model:gpt-4o-mini}")
    private String openAiModel;

    @Value("${chroma.url}")
    private String chromaUrl;

    @Value("${chroma.collection-name:smartbin_docs}")
    private String chromaCollectionName;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final OkHttpClient client = new OkHttpClient();
    private final Gson gson = new Gson();

    // ================== PUBLIC ENTRY ==================
    public String ask(String question) {

        try {
            String mode = classifyQuestion(question); // SQL / DOC / GENERAL

            switch (mode) {
                case "SQL":
                    return answerWithSql(question);
                case "DOC":
                    return answerWithDocs(question);
                default:
                    return answerGeneral(question);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có vấn đề ở bước phân loại thì fallback
            return answerGeneral(question);
        }
    }

    // ================== 1. PHÂN LOẠI CÂU HỎI ==================
    private String classifyQuestion(String question) {
        String system = "Bạn là bộ phân loại câu hỏi cho trợ lý SmartBin.\n" +
                "Hãy đọc câu hỏi và trả về MỘT trong các nhãn sau (chỉ in chữ cái, không giải thích):\n" +
                "- SQL: nếu câu hỏi cần truy vấn dữ liệu thời gian thực từ database SmartBin, " +
                "ví dụ hỏi về danh sách thùng, task, cảnh báo, số lượng, thống kê, phần trăm độ đầy, ...\n" +
                "- DOC: nếu câu hỏi mang tính mô tả, khái niệm, quy trình, tài liệu (sử dụng tài liệu đã nhúng lên Chroma).\n" +
                "- GENERAL: chào hỏi, small talk, câu hỏi không liên quan dữ liệu nội bộ.\n" +
                "Chỉ trả về: SQL hoặc DOC hoặc GENERAL.";

        String result = callOpenAi(system, question);

        if (result == null) return "GENERAL";

        result = result.trim().toUpperCase(Locale.ROOT);

        if (result.contains("SQL")) return "SQL";
        if (result.contains("DOC")) return "DOC";
        return "GENERAL";
    }

    // ================== 2. TRẢ LỜI THƯỜNG (GENERAL) ==================
    private String answerGeneral(String question) {
        String system = "Bạn là trợ lý SmartBin thân thiện, trả lời ngắn gọn, dễ hiểu bằng tiếng Việt. " +
                "Nếu câu hỏi liên quan đến SmartBin nhưng không cần số liệu thời gian thực, cứ trả lời bình thường.";
        return callOpenAi(system, question);
    }

    // ================== 3. RAG DOC: CHROMADB ==================
    private String answerWithDocs(String question) {
        String ctx = queryChroma(question);

        if (ctx == null || ctx.trim().isEmpty()) {
            // Nếu không có context, trả lời thường
            return answerGeneral(question);
        }

        String system = "Bạn là trợ lý SmartBin. Dưới đây là các đoạn tài liệu liên quan đến hệ thống SmartBin.\n" +
                "Chỉ dựa trên tài liệu này để trả lời, nếu không đủ thông tin thì hãy nói bạn không chắc chắn.\n" +
                "Trả lời bằng tiếng Việt, rõ ràng, dễ hiểu.";

        String userMsg = "Tài liệu liên quan:\n" + ctx +
                "\n\nCâu hỏi của người dùng: " + question;

        return callOpenAi(system, userMsg);
    }

    private String queryChroma(String question) {
        try {
            JsonObject body = new JsonObject();
            body.add("query_texts", gson.toJsonTree(new String[]{question}));
            body.addProperty("n_results", 5);

            String url = chromaUrl + "/api/v1/collections/" + chromaCollectionName + "/query";

            Request request = new Request.Builder()
                    .url(url)
                    .post(RequestBody.create(
                            MediaType.parse("application/json; charset=utf-8"),
                            body.toString()
                    ))
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful()) {
                    System.err.println("Chroma query HTTP " + response.code() + " - " + response.message());
                    return "";
                }

                String json = response.body().string();
                JsonObject root = JsonParser.parseString(json).getAsJsonObject();

                JsonArray docsArray = root.getAsJsonArray("documents");
                if (docsArray == null || docsArray.size() == 0) return "";

                JsonArray docs = docsArray.get(0).getAsJsonArray();
                StringBuilder sb = new StringBuilder();
                for (JsonElement e : docs) {
                    sb.append("- ").append(e.getAsString()).append("\n");
                }
                return sb.toString();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    // ================== 4. SQL RAG: GPT SINH SQL + QUERY DB ==================
    private String answerWithSql(String question) {
        try {
            String schemaHint = getSchemaHint();

            String sql = generateSqlFromQuestion(question, schemaHint);
            if (sql == null || sql.trim().isEmpty()) {
                return "Mình không tạo được câu lệnh SQL phù hợp cho câu hỏi này. " +
                        "Bạn có thể hỏi lại theo cách khác hoặc cụ thể hơn được không?";
            }

            System.out.println(">>> SQL AI sinh:\n" + sql);

            String tableText;
            try {
                tableText = runSqlAndFormat(sql);
            } catch (Exception ex) {
                ex.printStackTrace();
                return "Câu lệnh SQL bị lỗi: " + ex.getMessage();
            }

            if (tableText == null || tableText.trim().isEmpty()) {
                return "Không tìm thấy dữ liệu phù hợp với câu hỏi này trong database.";
            }

            String system = "Bạn là trợ lý SmartBin. Bạn vừa truy vấn database hệ thống và nhận được kết quả dạng bảng.\n" +
                    "Hãy dựa trên bảng dữ liệu để trả lời câu hỏi của người dùng bằng tiếng Việt, ngắn gọn, dễ hiểu.\n" +
                    "Đừng liệt kê lại toàn bộ bảng nếu không cần thiết, chỉ tóm tắt thông tin chính.";

            String userMsg = "Câu hỏi của người dùng: " + question +
                    "\n\nKết quả truy vấn (bảng dữ liệu):\n" + tableText;

            return callOpenAi(system, userMsg);

        } catch (Exception e) {
            e.printStackTrace();
            return "Có lỗi khi dùng chế độ SQL. Mình sẽ thử trả lời bình thường:\n\n" + answerGeneral(question);
        }
    }

    /**
     * Gợi ý schema THẬT của SmartBinDB để GPT sinh SQL đúng.
     * (ĐÃ SỬA cho khớp với dump bạn gửi)
     */
    private String getSchemaHint() {
        return "Database SmartBinDB (SQL Server) có một số bảng chính:\n" +
                "\n" +
                "1. Bins:\n" +
                "   - Bins(BinID int PRIMARY KEY IDENTITY,\n" +
                "         BinCode nvarchar(50),\n" +
                "         Latitude float,\n" +
                "         Longitude float,\n" +
                "         Street nvarchar(50),\n" +
                "         WardID int,\n" +
                "         Capacity float,\n" +
                "         CurrentFill float,\n" +
                "         Status int, -- 1 = đang hoạt động, 2 = bảo trì/ngưng hoạt động\n" +
                "         LastUpdated datetime)\n" +
                "\n" +
                "2. Wards:\n" +
                "   - Wards(WardID int PRIMARY KEY,\n" +
                "           WardName nvarchar(100),\n" +
                "           ProvinceID int)\n" +
                "\n" +
                "3. Provinces:\n" +
                "   - Provinces(ProvinceID int PRIMARY KEY,\n" +
                "              ProvinceName nvarchar(100))\n" +
                "\n" +
                "4. Accounts:\n" +
                "   - Accounts(AccountID int PRIMARY KEY IDENTITY,\n" +
                "              FullName nvarchar(100),\n" +
                "              Email nvarchar(255),\n" +
                "              Password nvarchar(255),\n" +
                "              Phone nvarchar(20),\n" +
                "              Role int,   -- ví dụ: 1=Admin, 2=Manager, 3=Citizen, 4=Worker, 5=Bao Tri (tuỳ hệ thống quy ước)\n" +
                "              Status int,\n" +
                "              Code nvarchar(20),\n" +
                "              CreatedAt datetime,\n" +
                "              IsVerified nvarchar(5) NULL,\n" +
                "              AddressDetail nvarchar(255) NULL,\n" +
                "              WardID int NULL,\n" +
                "              fcm_token nvarchar(max) NULL,\n" +
                "              AvatarUrl nvarchar(max) NULL)\n" +
                "\n" +
                "5. Tasks:\n" +
                "   - Tasks(TaskID int PRIMARY KEY IDENTITY,\n" +
                "           BinID int,          -- khoá ngoại tới Bins.BinID\n" +
                "           AssignedTo int,     -- AccountID của nhân viên/worker được giao nhiệm vụ\n" +
                "           TaskType nvarchar(50),  -- ví dụ: 'COLLECTION', 'MAINTENANCE'\n" +
                "           Priority int,\n" +
                "           Status nvarchar(20),    -- GIÁ TRỊ CHUỖI, ví dụ: 'OPEN', 'DOING', 'COMPLETED', 'CANCEL'\n" +
                "           Notes nvarchar(max) NULL,\n" +
                "           BatchID nvarchar(100) NULL,\n" +
                "           CreatedAt datetime,\n" +
                "           UpdatedAt datetime NULL,\n" +
                "           CompletedAt datetime NULL,\n" +
                "           afterImage nvarchar(max) NULL,\n" +
                "           CompletedLat float NULL,\n" +
                "           CompletedLng float NULL,\n" +
                "           dueAt datetime NULL,\n" +
                "           collectedVolume float NULL)\n" +
                "\n" +
                "-- Lưu ý QUAN TRỌNG:\n" +
                "-- * Trong bảng Tasks KHÔNG có cột WorkerID, chỉ có cột AssignedTo.\n" +
                "-- * Trong bảng Tasks, Status là NVARCHAR, KHÔNG phải số. Không được viết Status = 1.\n" +
                "--   Hãy dùng cụ thể: Status = 'OPEN', 'DOING', 'COMPLETED' hoặc 'CANCEL'.\n" +
                "-- * 'đang thực hiện', 'đang làm', 'đang nhận task' thường tương ứng Status IN ('OPEN', 'DOING').\n" +
                "-- * 'đã hoàn thành' tương ứng Status = 'COMPLETED'.\n" +
                "-- * 'bị huỷ' tương ứng Status = 'CANCEL'.\n" +
                "\n" +
                "-- Một số liên kết thường dùng:\n" +
                "-- - Bins.WardID -> Wards.WardID -> Wards.ProvinceID -> Provinces.ProvinceID\n" +
                "-- - Tasks.BinID -> Bins.BinID\n" +
                "-- - Tasks.AssignedTo -> Accounts.AccountID\n";
    }

    private String generateSqlFromQuestion(String question, String schemaHint) {
        String system = "Bạn là trợ lý sinh SQL cho Microsoft SQL Server (T-SQL) trong hệ thống SmartBin.\n" +
                "Nhiệm vụ của bạn:\n" +
                "1. Đọc mô tả schema database.\n" +
                "2. Đọc câu hỏi tiếng Việt.\n" +
                "3. Sinh ra MỘT câu lệnh SQL SELECT DUY NHẤT, không giải thích gì thêm.\n" +
                "4. KHÔNG dùng JOIN với bảng không có trong schema.\n" +
                "5. KHÔNG dùng cột không tồn tại.\n" +
                "   - ĐẶC BIỆT: Trong bảng Tasks, KHÔNG dùng cột WorkerID vì cột này KHÔNG TỒN TẠI.\n" +
                "     Hãy dùng cột AssignedTo để chỉ nhân viên/worker được giao nhiệm vụ.\n" +
                "6. KHÔNG viết nhiều lệnh, KHÔNG dùng GO.\n" +
                "7. Không bao giờ dùng DDL/DML (CREATE/UPDATE/DELETE/INSERT/ALTER/DROP/TRUNCATE/MERGE). Chỉ SELECT.\n" +
                "8. Trong bảng Tasks, cột Status là NVARCHAR với các giá trị: 'OPEN', 'DOING', 'COMPLETED', 'CANCEL'.\n" +
                "   - KHÔNG được so sánh Status với số (không được viết Status = 1).\n" +
                "   - Nếu người dùng hỏi 'đang thực hiện', 'đang nhận task', hãy coi là Status IN ('OPEN', 'DOING').\n" +
                "   - Nếu hỏi 'đã hoàn thành', dùng Status = 'COMPLETED'.\n" +
                "\n" +
                "Hãy chỉ trả về duy nhất câu lệnh SELECT hợp lệ.";

        String userMsg = "Schema database:\n" + schemaHint +
                "\n\nCâu hỏi của người dùng: " + question +
                "\n\nHãy trả về DUY NHẤT câu lệnh SQL SELECT.";

        String sql = callOpenAi(system, userMsg);
        if (sql == null) return null;

        // Bỏ ```sql ... ```
        sql = sql.replace("```sql", "")
                .replace("```SQL", "")
                .replace("```", "")
                .trim();

        // Chỉ lấy tới dấu chấm phẩy đầu tiên nếu có nhiều câu
        int idx = sql.indexOf(";");
        if (idx > 0) {
            sql = sql.substring(0, idx + 1);
        }

        // ================== LỚP BẢO VỆ AN TOÀN ==================
        String upper = sql.toUpperCase(Locale.ROOT);

        // Chỉ cho phép SELECT
        if (!upper.startsWith("SELECT")) {
            System.err.println("[BLOCK] SQL không bắt đầu bằng SELECT: " + sql);
            return null;
        }

        // Chặn các từ khoá nguy hiểm (phòng GPT phá luật)
        String[] forbidden = new String[]{
                " UPDATE ", " DELETE ", " INSERT ",
                " ALTER ", " DROP ", " TRUNCATE ", " MERGE ", " EXEC ", " EXECUTE "
        };
        for (String bad : forbidden) {
            if (upper.contains(bad)) {
                System.err.println("[BLOCK] Phát hiện từ khoá cấm '" + bad.trim() + "' trong SQL: " + sql);
                return null;
            }
        }

        // Chặn nếu vẫn lỡ dùng WorkerID
        if (upper.contains("WORKERID")) {
            System.err.println("[BLOCK] SQL sử dụng cột WorkerID (không tồn tại): " + sql);
            return null;
        }

        return sql;
    }

    private String runSqlAndFormat(String sql) throws SQLException {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
        if (rows == null || rows.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        // Header
        Map<String, Object> firstRow = rows.get(0);
        sb.append("|");
        for (String col : firstRow.keySet()) {
            sb.append(" ").append(col).append(" |");
        }
        sb.append("\n|");
        for (int i = 0; i < firstRow.keySet().size(); i++) {
            sb.append("----|");
        }
        sb.append("\n");

        // Rows
        for (Map<String, Object> row : rows) {
            sb.append("|");
            for (Object val : row.values()) {
                sb.append(" ").append(val == null ? "NULL" : val.toString()).append(" |");
            }
            sb.append("\n");
        }

        return sb.toString();
    }

    // ================== 5. HÀM GỌI OPENAI CHUNG ==================
    private String callOpenAi(String systemMsg, String userMsg) {
        try {
            JsonObject body = new JsonObject();
            body.addProperty("model", openAiModel);

            JsonArray messages = new JsonArray();

            JsonObject sys = new JsonObject();
            sys.addProperty("role", "system");
            sys.addProperty("content", systemMsg);
            messages.add(sys);

            JsonObject usr = new JsonObject();
            usr.addProperty("role", "user");
            usr.addProperty("content", userMsg);
            messages.add(usr);

            body.add("messages", messages);

            Request request = new Request.Builder()
                    .url("https://api.openai.com/v1/chat/completions")
                    .addHeader("Authorization", "Bearer " + openAiApiKey)
                    .post(RequestBody.create(
                            MediaType.parse("application/json; charset=utf-8"),
                            body.toString()
                    ))
                    .build();

            try (Response response = client.newCall(request).execute()) {
                if (!response.isSuccessful()) {
                    System.err.println("OpenAI HTTP " + response.code() + " - " + response.message());
                    return "Lỗi gọi OpenAI: HTTP " + response.code() + " - " + response.message();
                }

                String json = response.body().string();
                JsonObject root = JsonParser.parseString(json).getAsJsonObject();

                JsonArray choices = root.getAsJsonArray("choices");
                if (choices == null || choices.size() == 0) {
                    return "OpenAI không trả về kết quả.";
                }

                JsonObject msgObj = choices.get(0).getAsJsonObject().getAsJsonObject("message");
                if (msgObj == null || !msgObj.has("content")) {
                    return "OpenAI không có message.content.";
                }

                return msgObj.get("content").getAsString().trim();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi gọi OpenAI: " + e.getClass().getSimpleName() + " - " + e.getMessage();
        }
    }
}
