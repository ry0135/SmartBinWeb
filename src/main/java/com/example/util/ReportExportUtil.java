
package com.example.util;
import com.example.model.Report;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.xhtmlrenderer.pdf.ITextRenderer;

import javax.servlet.ServletContext;
import java.io.OutputStream;
import java.security.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

public class ReportExportUtil {

    // ---------- EXCEL ----------
    public static void writeReportsToExcel(List<Report> reports, OutputStream os) throws Exception {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Reports");

            // Header
            Row header = sheet.createRow(0);
            String[] cols = {"ID", "BinID", "AccountID", "ReportType", "Description", "Status", "AssignedTo", "CreatedAt", "UpdatedAt", "ResolvedAt"};
            CellStyle headerStyle = workbook.createCellStyle();
            Font hFont = workbook.createFont();
            hFont.setBold(true);
            headerStyle.setFont(hFont);

            for (int i = 0; i < cols.length; i++) {
                Cell c = header.createCell(i);
                c.setCellValue(cols[i]);
                c.setCellStyle(headerStyle);
            }



            // Date style
            CreationHelper createHelper = workbook.getCreationHelper();
            CellStyle dateStyle = workbook.createCellStyle();
            dateStyle.setDataFormat(createHelper.createDataFormat().getFormat("yyyy-mm-dd HH:mm:ss"));

            // Rows
            int r = 1;
            for (Report rep : reports) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(rep.getReportId());
                row.createCell(1).setCellValue(rep.getBinId());
                row.createCell(2).setCellValue(rep.getAccountId());
                row.createCell(3).setCellValue(rep.getReportType() == null ? "" : rep.getReportType());
                row.createCell(4).setCellValue(rep.getDescription() == null ? "" : rep.getDescription());
                row.createCell(5).setCellValue(rep.getStatus() == null ? "" : rep.getStatus());
                // assignedTo could be an ID or object -> adapt to your model
                row.createCell(6).setCellValue(rep.getAssignedTo() == null ? "" : String.valueOf(rep.getAssignedTo()));
                if (rep.getCreatedAt() != null) {
                    Cell c = row.createCell(7);
                    c.setCellValue(rep.getCreatedAt());
                    c.setCellStyle(dateStyle);
                }
                if (rep.getUpdatedAt() != null) {
                    Cell c = row.createCell(8);
                    c.setCellValue(rep.getUpdatedAt());
                    c.setCellStyle(dateStyle);
                }
                if (rep.getResolvedAt() != null) {
                    Cell c = row.createCell(9);
                    c.setCellValue(rep.getResolvedAt());
                    c.setCellStyle(dateStyle);
                }
            }

            // Auto-size
            for (int i = 0; i < cols.length; i++) sheet.autoSizeColumn(i);

            workbook.write(os);
            os.flush();
        }
    }

    // ---------- PDF (dùng Flying Saucer để render HTML -> PDF) ----------
    // fontPath: optional - đường dẫn tới ttf nếu bạn muốn hiển thị tiếng Việt chính xác
    public static void writeReportsToPdf(List<Report> reports, OutputStream os, String fontPath) throws Exception {
        String html = buildHtmlForReports(reports);

        ITextRenderer renderer = new ITextRenderer();

        // Nếu cần font hỗ trợ tiếng Việt, add font:
        if (fontPath != null && !fontPath.isEmpty()) {
            renderer.getFontResolver().addFont(fontPath, true);
        }

        renderer.setDocumentFromString(html);
        renderer.layout();
        renderer.createPDF(os);
        os.flush();
    }

    private static String buildHtmlForReports(List<Report> reports) {
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        StringBuilder sb = new StringBuilder();

        sb.append("<html><head><meta charset='utf-8' />");
        sb.append("<style>body{font-family: Arial, Helvetica, sans-serif;} table{border-collapse:collapse;width:100%} th,td{border:1px solid #ccc;padding:8px;text-align:left;} th{background:#f2f2f2;}</style>");
        sb.append("</head><body>");
        sb.append("<h2>Danh sách báo cáo</h2>");
        sb.append("<table>");
        sb.append("<thead><tr><th>ID</th><th>BinCode</th><th>Tên</th><th>Loại</th><th>Mô tả</th><th>Trạng thái</th><th>Người xử lý</th><th>Ngày tạo</th><th>Ngày cập nhật</th><th>Ngày hoàn thành</th></tr></thead>");
        sb.append("<tbody>");

        for (Report r : reports) {
            sb.append("<tr>");
            sb.append("<td>").append(r.getReportId()).append("</td>");
            sb.append("<td>").append(r.getBin().getBinCode()).append("</td>");
            sb.append("<td>").append(r.getAccount().getFullName()).append("</td>");
            sb.append("<td>").append(escapeHtml(r.getReportType())).append("</td>");
            sb.append("<td>").append(escapeHtml(r.getDescription())).append("</td>");
            sb.append("<td>").append(escapeHtml(r.getStatus())).append("</td>");
            sb.append("<td>").append(r.getAssignedTo() == null ? "" : r.getAssignedTo()).append("</td>");

            sb.append("<td>").append(formatDate(r.getCreatedAt(), fmt, dtf)).append("</td>");
            sb.append("<td>").append(formatDate(r.getUpdatedAt(), fmt, dtf)).append("</td>");
            sb.append("<td>").append(formatDate(r.getResolvedAt(), fmt, dtf)).append("</td>");
            sb.append("</tr>");
        }

        sb.append("</tbody></table></body></html>");
        return sb.toString();
    }

    private static String formatDate(Object dateObj, SimpleDateFormat sdf, DateTimeFormatter dtf) {
        if (dateObj == null) return "";
        try {
            if (dateObj instanceof java.util.Date)
                return sdf.format((Date) dateObj);
            else if (dateObj instanceof java.time.LocalDateTime)
                return ((LocalDateTime) dateObj).format(dtf);
            else
                return dateObj.toString(); // fallback nếu là String
        } catch (Exception e) {
            return dateObj.toString();
        }
    }


    private static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"","&quot;");
    }


}