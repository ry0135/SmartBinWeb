package com.example.service;

import com.example.dto.TaskSummaryDTO;
import com.example.model.*;
import com.example.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class TasksService {

    @Autowired
    private TasksRepository taskRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private NotificationRepository notificationRepository;
    @Autowired
    private AccountService accountService;

    @Autowired
    private WardService wardService;

    @Autowired
    private FcmService fcmService;
    @Autowired
    private BinRepository binRepository;

    @Autowired
    private ReportRepository reportRepository;

    // Giao nhiều task cùng lúc
    @Transactional
    public List<Task> assignMultipleTasks(List<Integer> binIds, int workerId,
                                          String taskType, int priority, String notes,
                                          int senderId) throws Exception {

        Account worker = accountRepository.findById(workerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy worker với ID = " + workerId));
        List<Report> reports = reportRepository.findFullOrOverloadReports(binIds);

        if (!reports.isEmpty()) {
            List<Integer> reportIds = reports.stream()
                    .map(Report::getReportId)
                    .collect(Collectors.toList());

            // 2) chuyển sang IN_PROGRESS
            reportRepository.updateReportsToInProgress(reportIds,workerId);
        }
        String batchId = "BATCH_" + System.currentTimeMillis() + "_" + new Random().nextInt(1000);
        List<Task> assignedTasks = new ArrayList<>();

        for (Integer binId : binIds) {
            Bin bin = binRepository.findById(binId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bin ID = " + binId));

            if (taskRepository.countOpenTasksByBin(binId) > 0) continue;

            Task task = new Task();
            task.setBin(bin);
            task.setAssignedTo(worker);
            task.setTaskType(taskType);
            task.setPriority(priority);
            task.setStatus("OPEN");
            task.setNotes(notes);
            task.setBatchId(batchId);

            assignedTasks.add(taskRepository.save(task));
        }


        if (!assignedTasks.isEmpty()) {

            int count = assignedTasks.size();

            Notification noti = new Notification();
            noti.setReceiverId(workerId);
            noti.setSenderId(senderId);
            noti.setTitle("Bạn có nhiệm vụ mới");
            noti.setMessage("Bạn được giao nhiệm vụ:  " + notes );
            noti.setType("TASK");
            noti.setRead(false);
            noti.setCreatedAt(LocalDateTime.now());

            notificationRepository.save(noti);


            String token = accountService.getFcmTokenByWorkerId(workerId);
            if (token != null && !token.isEmpty()) {
                String body = "Bạn được giao nhiệm vụ thu gom " + count + " thùng.";
                fcmService.sendNotification(token, "Nhiệm vụ mới", body, batchId);
            }
        }

        return assignedTasks;
    }


    // Giao task đơn lẻ (giữ lại cho tương thích)
    public Task assignTask(int binId, int workerId, String taskType, int priority, String notes, int senderID) throws Exception {
        List<Integer> binIds = Collections.singletonList(binId);
        List<Task> tasks = assignMultipleTasks(binIds, workerId, taskType, priority, notes,senderID);
        return tasks.isEmpty() ? null : tasks.get(0);
    }

    // Lấy danh sách task theo batch
    public List<Task> getTasksByBatch(String batchId) {
        return taskRepository.findByBatchId(batchId);
    }
    public List<Task> getTasksByBatchOpen(String batchId) {
        return taskRepository.findByBatchIdOpen(batchId);
    }
    public List<Task> getTasksByBatchDoing(String batchId) {
        return taskRepository.findByBatchIdDoing(batchId);
    }
    public List<Task> getTasksByBatchComplete(String batchId) {
        return taskRepository.findByBatchIdCompeleted(batchId);
    }
    public List<Task> getTasksByBatchCancel(String batchId) {
        return taskRepository.findByBatchIdCancel(batchId);
    }

    // Lấy danh sách nhân viên có thể giao task
    public List<Account> getAvailableWorkers(int wardID) {
        List<Account> workers = accountRepository.findWorkersByWard(wardID);

        Map<Integer, Integer> workerTaskCount = new HashMap<>();
        for (Account w : workers) {
            int count = taskRepository.countOpenTasksByWorker(w.getAccountId());
            workerTaskCount.put(w.getAccountId(), count);
            w.setTaskCount(count);
        }

        workers.sort(Comparator.comparingInt(Account::getTaskCount));
        return workers;
    }
    public List<Account> getAvailableWorkersMaintenance(int wardID) {
        int provinceId = wardService.getProvinceId(wardID);
        List<Account> workers = accountRepository.findWorkersByWardAndProvince(wardID,provinceId);
        workers.sort((a, b) -> {
            boolean aMatch = a.getWardID() == wardID;
            boolean bMatch = b.getWardID() == wardID;
            return Boolean.compare(!aMatch, !bMatch); // ưu tiên ward ở trên
        });
        Map<Integer, Integer> workerTaskCount = new HashMap<>();
        for (Account w : workers) {
            int count = taskRepository.countOpenTasksByWorker(w.getAccountId());
            workerTaskCount.put(w.getAccountId(), count);
            w.setTaskCount(count);
        }

        workers.sort(Comparator.comparingInt(Account::getTaskCount));
        return workers;
    }

    public int countOpenTasksByWorker(int workerId) {
        return taskRepository.countOpenTasksByWorker(workerId);
    }

    public boolean hasOpenTask(int binId) {
        return taskRepository.countOpenTasksByBin(binId) > 0;
    }
    public boolean hasRestrictedTask(int binId) {
        return taskRepository.countTasksByBinExclude(binId) > 0;
    }

    // Lấy danh sách batch tóm tắt theo worker
    public List<TaskSummaryDTO> getTaskSummaryByAssignedTo(int workerId) {
        return taskRepository.findTaskSummaryByAssignedTo(workerId);
    }

    // Lấy chi tiết task trong batch
    public List<Task> getTasksInBatch(int workerId, String batchId) {
        return taskRepository.findByAssignedTo_AccountIdAndBatchIdOrderByPriorityAsc(workerId, batchId);
    }
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }
    public List<Task> getAllTasksDoing() {
        return taskRepository.findAll();
    }
// Thêm vào TasksService.java

    public void deleteBatch(String batchId) {
        List<Task> batchTasks = taskRepository.findByBatchId(batchId);
        taskRepository.deleteAll(batchTasks);
    }

    public void updateBatchStatus(String batchId, String status) {
        List<Task> batchTasks = taskRepository.findByBatchId(batchId);
        for (Task task : batchTasks) {
            task.setStatus(status);
            if ("COMPLETED".equals(status)) {
                task.setCompletedAt(new Date());
            }
            taskRepository.save(task);
        }
    }

    public void deleteTask(int taskId) {
        taskRepository.deleteById(taskId);
    }

    // Thêm phương thức để lấy thông tin batch summary
    public Map<String, Object> getBatchSummary(String batchId) {
        List<Task> batchTasks = taskRepository.findByBatchId(batchId);
        if (batchTasks.isEmpty()) {
            return null;
        }

        Task firstTask = batchTasks.get(0);
        Map<String, Object> summary = new HashMap<>();
        summary.put("batchId", batchId);
        summary.put("totalTasks", batchTasks.size());
        summary.put("assignedTo", firstTask.getAssignedTo().getFullName());
        summary.put("taskType", firstTask.getTaskType());
        summary.put("createdAt", firstTask.getCreatedAt());

        // Thống kê status
        Map<String, Long> statusCount = batchTasks.stream()
                .collect(Collectors.groupingBy(Task::getStatus, Collectors.counting()));
        summary.put("statusCount", statusCount);

        return summary;
    }

    // Thêm vào TasksService.java
    public void updateTaskStatus(int taskId, String status) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy task với ID = " + taskId));
        task.setStatus(status);
        if ("COMPLETED".equals(status)) {
            task.setCompletedAt(new Date());
        }
        taskRepository.save(task);
    }

    // Trong TasksService.java
    public List<Task> getDoingTasks() {
        return taskRepository.findDoingTasks();
    }
    public List<Task> getOpenTasks() {
        return taskRepository.findOpenTasks();
    }
    public List<Task> getCompletedTasks() {
        return taskRepository.findCompletedTasks();
    }
    public List<Task> getCancelTasks() {
        return taskRepository.findCancelTasks();
    }
    public List<Task> getDoingTasksByWorker(int workerId) {
        return taskRepository.findDoingTasksByWorker(workerId);
    }

    public List<Task> getDoingTasksByBatch(String batchId) {
        return taskRepository.findDoingTasksByBatch(batchId);
    }

    // Lấy danh sách batch đang có task DOING
    public Map<String, List<Task>> getDoingTasksGroupedByBatch() {
        List<Task> doingTasks = taskRepository.findDoingTasks();

        // Nhóm task theo batchId
        Map<String, List<Task>> tasksByBatch = doingTasks.stream()
                .filter(task -> task.getBatchId() != null && !task.getBatchId().isEmpty())
                .collect(Collectors.groupingBy(Task::getBatchId));

        return tasksByBatch;
    }


    // Thống kê doing tasks
    public Map<String, Object> getDoingTasksStats() {
        List<Task> doingTasks = taskRepository.findDoingTasks();

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalDoingTasks", doingTasks.size());

        // Thống kê theo loại task
        Map<String, Long> typeStats = doingTasks.stream()
                .collect(Collectors.groupingBy(Task::getTaskType, Collectors.counting()));
        stats.put("tasksByType", typeStats);

        // Thống kê theo độ ưu tiên
        Map<Integer, Long> priorityStats = doingTasks.stream()
                .collect(Collectors.groupingBy(Task::getPriority, Collectors.counting()));
        stats.put("tasksByPriority", priorityStats);

        // Thống kê theo worker
        Map<String, Long> workerStats = doingTasks.stream()
                .filter(task -> task.getAssignedTo() != null)
                .collect(Collectors.groupingBy(
                        task -> task.getAssignedTo().getFullName(),
                        Collectors.counting()
                ));
        stats.put("tasksByWorker", workerStats);

        return stats;
    }


    @Autowired
    private FirebaseStorageService firebaseStorageService;

    public String completeTask(Integer taskId, Double lat, Double lng, MultipartFile image, double collectedVolume) throws IOException {
        Optional<Task> optionalTask = taskRepository.findById(taskId);

        Task task = optionalTask.get();
        int binId = task.getBin().getBinID();

        //  Upload ảnh lên Firebase
        String imageUrl = firebaseStorageService.uploadFile(image, "task/collect");

        //  Cập nhật thông tin task
        task.setAfterImage(imageUrl);
        task.setCompletedAt(new Date());
        task.setCompletedLat(lat);
        task.setCompletedLng(lng);
        task.setCollectedVolume(collectedVolume);
        task.setStatus("COMPLETED");
        taskRepository.save(task);


        reportRepository.resolveReportsByBin(
                task.getBin().getBinID(),
                task.getAssignedTo().getAccountId(),
                task.getTaskID()
        );

        return " Hoàn thành nhiệm vụ thành công!";
    }
    // Cập nhật batch - đơn giản như insert
    // Cập nhật batch - đơn giản
    @Transactional
    public void updateBatch(String batchId, int workerId, int priority, String notes) throws Exception {

        List<Task> batchTasks = taskRepository.findByBatchId(batchId);
        if (batchTasks.isEmpty()) {
            throw new RuntimeException("Batch không tồn tại");
        }

        Account worker = accountRepository.findById(workerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy worker với ID = " + workerId));

        // Cập nhật tất cả task trong batch
        for (Task task : batchTasks) {
            task.setAssignedTo(worker);
            task.setPriority(priority);
            task.setNotes(notes);
            taskRepository.save(task);
        }

        // Gửi thông báo cho worker
        String token = accountService.getFcmTokenByWorkerId(workerId);
        if (token != null && !token.isEmpty()) {
            String title = "Batch được cập nhật";
            String body = "Batch " + batchId + " đã được cập nhật thông tin";
            fcmService.sendNotification(token, title, body, batchId);
        }
    }
    // Thêm vào TasksService.java
    public Map<String, Long> getBatchStats() {
        List<Task> allTasks = taskRepository.findAll();

        Map<String, Long> batchStats = new HashMap<>();

        // Lấy tất cả batch ID duy nhất
        List<String> allBatchIds = allTasks.stream()
                .filter(task -> task.getBatchId() != null && !task.getBatchId().isEmpty())
                .map(Task::getBatchId)
                .distinct()
                .collect(Collectors.toList());

        batchStats.put("totalBatches", (long) allBatchIds.size());

        long openBatches = 0;
        long doingBatches = 0;
        long completedBatches = 0;
        long cancelBatches = 0;
        long issueBatches = 0;

        for (String batchId : allBatchIds) {

            List<Task> batchTasks = taskRepository.findByBatchId(batchId);
            if (batchTasks.isEmpty()) continue;

            long total = batchTasks.size();
            long openCount = batchTasks.stream().filter(t -> "OPEN".equals(t.getStatus())).count();
            long doingCount = batchTasks.stream().filter(t -> "DOING".equals(t.getStatus())).count();
            long completedCount = batchTasks.stream().filter(t -> "COMPLETED".equals(t.getStatus())).count();
            long cancelCount = batchTasks.stream().filter(t -> "CANCEL".equals(t.getStatus())).count();
            long issueCount = batchTasks.stream().filter(t -> "ISSUE".equals(t.getStatus())).count();

            // ================== ÁP DỤNG LOGIC MỚI ==================

            // ⚠️ 1. Ưu tiên ISSUE
            if (issueCount > 0) {
                issueBatches++;
                continue;
            }

            // 🔄 2. Nếu có task đang làm → DOING
            if (doingCount > 0) {
                doingBatches++;
                continue;
            }

            // 🟡 3. Nếu còn task OPEN → OPEN
            if (openCount > 0) {
                openBatches++;
                continue;
            }

            // ⭐ 4. Nếu tất cả task là COMPLETED hoặc CANCEL → COMPLETED
            if (completedCount + cancelCount == total && completedCount > 0) {
                completedBatches++;
                continue;
            }

            // ❌ 5. Nếu tất cả đều CANCEL → CANCEL
            if (cancelCount == total) {
                cancelBatches++;
                continue;
            }

            // Nếu không thuộc loại nào (trường hợp hiếm)
            // → có thể đưa vào CANCEL hoặc UNKNOWN tùy nghiệp vụ
            cancelBatches++;
        }

        batchStats.put("openBatches", openBatches);
        batchStats.put("doingBatches", doingBatches);
        batchStats.put("completedBatches", completedBatches);
        batchStats.put("cancelBatches", cancelBatches);
        batchStats.put("issueBatches", issueBatches);

        return batchStats;
    }

    // Thêm phương thức để lấy trạng thái của một batch cụ thể
    public String getBatchStatus(String batchId) {
        List<Task> batchTasks = taskRepository.findByBatchId(batchId);

        if (batchTasks.isEmpty()) {
            return "UNKNOWN";
        }

        long totalTasks = batchTasks.size();

        long openCount = batchTasks.stream().filter(t -> "OPEN".equals(t.getStatus())).count();
        long doingCount = batchTasks.stream().filter(t -> "DOING".equals(t.getStatus())).count();
        long completedCount = batchTasks.stream().filter(t -> "COMPLETED".equals(t.getStatus())).count();
        long cancelCount = batchTasks.stream().filter(t -> "CANCEL".equals(t.getStatus())).count();
        long issueCount = batchTasks.stream().filter(t -> "ISSUE".equals(t.getStatus())).count();

        // ⚠️ Ưu tiên ISSUE
        if (issueCount > 0) {
            return "ISSUE";
        }

        // 🔄 Ưu tiên DOING
        if (doingCount > 0) {
            return "DOING";
        }

        // 🟡 Nếu có OPEN → OPEN
        if (openCount > 0) {
            return "OPEN";
        }

        // ⭐ Trường hợp bạn yêu cầu:
        // Nếu tất cả task là COMPLETED hoặc CANCEL → vẫn xem batch là COMPLETED
        if (completedCount + cancelCount == totalTasks && completedCount > 0) {
            return "COMPLETED";
        }

        // Nếu tất cả đều CANCEL → CANCEL
        if (cancelCount == totalTasks) {
            return "CANCEL";
        }

        return "UNKNOWN";
    }

    public List<Task> getIssueTasks() {
        return taskRepository.findIssueTasks();
    }

    public List<Task> getIssueTasksByBatch(String batchId) {
        return taskRepository.findIssueTasksByBatch(batchId);
    }

    public List<Task> getTasksByIds(List<Integer> ids) {
        return taskRepository.findAllById(ids);
    }

    @Transactional
    public void retryBatch(String batchId, int newWorkerId, String notes) throws Exception {

        List<Task> oldTasks = taskRepository.findByBatchId(batchId);

        if (oldTasks.isEmpty()) {
            throw new RuntimeException("Batch không tồn tại");
        }

        // 🔴 CHỈ LẤY NHỮNG TASK CÓ TRẠNG THÁI "ISSUE" (bỏ qua COMPLETED)
        List<Task> issueTasks = oldTasks.stream()
                .filter(task -> "ISSUE".equals(task.getStatus()))
                .collect(Collectors.toList());

        if (issueTasks.isEmpty()) {
            throw new RuntimeException("Không có task ISSUE nào trong batch này để giao lại");
        }

        // Kiểm tra xem có task COMPLETED không
        boolean hasCompletedTasks = oldTasks.stream()
                .anyMatch(task -> "COMPLETED".equals(task.getStatus()));

        Account worker = accountRepository.findById(newWorkerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhân viên"));

        // Tạo batch mới
        String newBatchId = "RETRY_" + batchId + "_" + System.currentTimeMillis();

        // 1. Đánh dấu task ISSUE cũ là CANCELLED
        for (Task issueTask : issueTasks) {
            issueTask.setStatus("CANCEL");
            issueTask.setNotes("Đã giao lại task lỗi - " +
                    (notes != null ? notes : "Giao lại tự động"));
            taskRepository.save(issueTask);
        }

        // 2. Tạo task mới từ các task ISSUE
        List<Task> newTasks = new ArrayList<>();
        for (Task oldTask : issueTasks) {
            Task newTask = new Task();
            newTask.setBin(oldTask.getBin());
            newTask.setAssignedTo(worker);
            newTask.setTaskType(oldTask.getTaskType());
            newTask.setPriority(oldTask.getPriority());
            newTask.setNotes(notes == null ?
                    "Giao lại từ task lỗi #" + oldTask.getTaskID() +
                            (hasCompletedTasks ? " (Một số task khác đã hoàn thành)" : "")
                    : notes);
            newTask.setBatchId(newBatchId);
            newTask.setStatus("OPEN");
            newTask.setCreatedAt(new Date());

            newTasks.add(taskRepository.save(newTask));
        }

        // 3. Gửi thông báo FCM
        String token = accountService.getFcmTokenByWorkerId(newWorkerId);
        if (token != null && !token.isEmpty()) {
            fcmService.sendNotification(token,
                    "Giao lại nhiệm vụ",
                    "Bạn được giao " + newTasks.size() + " nhiệm vụ từ batch " + batchId +
                            (hasCompletedTasks ? " (Một số task đã hoàn thành)" : ""),
                    newBatchId);
        }

        // 4. Gửi thông báo trong hệ thống
        Notification noti = new Notification();
        noti.setReceiverId(newWorkerId);
        noti.setSenderId(1); // ID của admin/hệ thống
        noti.setTitle("Giao lại batch lỗi");
        noti.setMessage("Bạn được giao lại " + newTasks.size() + " nhiệm vụ chưa hoàn thành từ batch " + batchId);
        noti.setType("TASK_RETRY");
        noti.setRead(false);
        noti.setCreatedAt(LocalDateTime.now());

        notificationRepository.save(noti);
    }

}
