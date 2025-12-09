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

        // Tổng số batch
        batchStats.put("totalBatches", (long) allBatchIds.size());

        // Đếm batch theo từng trạng thái
        long openBatches = 0;
        long doingBatches = 0;
        long completedBatches = 0;
        long cancelBatches = 0;

        for (String batchId : allBatchIds) {
            List<Task> batchTasks = taskRepository.findByBatchId(batchId);
            if (!batchTasks.isEmpty()) {
                // Đếm số lượng task theo từng trạng thái trong batch
                long openCount = batchTasks.stream().filter(t -> "OPEN".equals(t.getStatus())).count();
                long doingCount = batchTasks.stream().filter(t -> "DOING".equals(t.getStatus())).count();
                long completedCount = batchTasks.stream().filter(t -> "COMPLETED".equals(t.getStatus())).count();
                long cancelCount = batchTasks.stream().filter(t -> "CANCEL".equals(t.getStatus())).count();
                long totalTasks = batchTasks.size();

                // Logic xác định trạng thái batch
                if (cancelCount > 0) {
                    // Nếu có task bị cancel, batch là CANCEL
                    cancelBatches++;
                } else if (doingCount > 0) {
                    // Nếu có ít nhất 1 task đang DOING, batch là DOING (ưu tiên cao nhất)
                    doingBatches++;
                } else if (completedCount == totalTasks) {
                    // Chỉ khi TẤT CẢ task đều COMPLETED, batch mới là COMPLETED
                    completedBatches++;
                } else if (openCount > 0) {
                    // Nếu có task OPEN và không có task nào DOING/CANCEL
                    openBatches++;
                }
            }
        }

        batchStats.put("openBatches", openBatches);
        batchStats.put("doingBatches", doingBatches);
        batchStats.put("completedBatches", completedBatches);
        batchStats.put("cancelBatches", cancelBatches);

        return batchStats;
    }

    // Thêm phương thức để lấy trạng thái của một batch cụ thể
    public String getBatchStatus(String batchId) {
        List<Task> batchTasks = taskRepository.findByBatchId(batchId);
        if (batchTasks.isEmpty()) {
            return "UNKNOWN";
        }

        // Đếm số lượng task theo từng trạng thái
        long openCount = batchTasks.stream().filter(t -> "OPEN".equals(t.getStatus())).count();
        long doingCount = batchTasks.stream().filter(t -> "DOING".equals(t.getStatus())).count();
        long completedCount = batchTasks.stream().filter(t -> "COMPLETED".equals(t.getStatus())).count();
        long cancelCount = batchTasks.stream().filter(t -> "CANCEL".equals(t.getStatus())).count();
        long totalTasks = batchTasks.size();

        // Logic xác định trạng thái batch
        if (cancelCount > 0) {
            return "CANCEL";
        } else if (doingCount > 0) {
            return "DOING";
        } else if (completedCount == totalTasks) {
            return "COMPLETED";
        } else if (openCount > 0) {
            return "OPEN";
        } else {
            return "UNKNOWN";
        }
    }
}
