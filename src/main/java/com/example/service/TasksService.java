package com.example.service;

import com.example.dto.TaskSummaryDTO;
import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Task;
import com.example.repository.AccountRepository;
import com.example.repository.BinRepository;
import com.example.repository.TasksRepository;
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
    private AccountService accountService;


    @Autowired
    private FcmService fcmService;
    @Autowired
    private BinRepository binRepository;

    // Giao nhiều task cùng lúc
    @Transactional
    public List<Task> assignMultipleTasks(List<Integer> binIds, int workerId,
                                          String taskType, int priority, String notes) throws Exception {

        Account worker = accountRepository.findById(workerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy worker với ID = " + workerId));

        // Tạo batch ID duy nhất
        String batchId = "BATCH_" + System.currentTimeMillis() + "_" + new Random().nextInt(1000);

        List<Task> assignedTasks = new ArrayList<>();

        for (Integer binId : binIds) {
            Bin bin = binRepository.findById(binId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy bin với ID = " + binId));

            // Kiểm tra nếu bin đã có task đang mở
            if (taskRepository.countOpenTasksByBin(binId) > 0) {
                continue; // Bỏ qua bin này
            }

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
            String token = accountService.getFcmTokenByWorkerId(workerId);
            if (token != null && !token.isEmpty()) {
                String title = "Nhiệm vụ mới được giao";
                String body = notes;

                fcmService.sendNotification(token, title, body,batchId);
            }
        }

        return assignedTasks;
    }

    // Giao task đơn lẻ (giữ lại cho tương thích)
    public Task assignTask(int binId, int workerId, String taskType, int priority, String notes) throws Exception {
        List<Integer> binIds = Collections.singletonList(binId);
        List<Task> tasks = assignMultipleTasks(binIds, workerId, taskType, priority, notes);
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
        List<Account> workers = accountRepository.findWorkersByWardandrole4(wardID);

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

    public String completeTask(Integer taskId, Double lat, Double lng, MultipartFile image) throws IOException {
        Optional<Task> optionalTask = taskRepository.findById(taskId);

        Task task = optionalTask.get();

        //  Upload ảnh lên Firebase
        String imageUrl = firebaseStorageService.uploadFile(image, "/task/collect");

        //  Cập nhật thông tin task
        task.setAfterImage(imageUrl);
        task.setCompletedAt(new Date());
        task.setCompletedLat(lat);
        task.setCompletedLng(lng);
        task.setStatus("COMPLETED");
        taskRepository.save(task);

        return " Hoàn thành nhiệm vụ thành công!";
    }
}