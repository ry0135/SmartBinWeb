package com.example.service;

import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Task;
import com.example.repository.AccountRepository;
import com.example.repository.BinRepository;
import com.example.repository.TasksRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class TasksService {

    @Autowired
    private TasksRepository taskRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private BinRepository binRepository;

    // Giao nhiều task cùng lúc
    @Transactional
    public List<Task> assignMultipleTasks(List<Integer> binIds, int workerId,
                                          String taskType, int priority, String notes) {

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

        return assignedTasks;
    }

    // Giao task đơn lẻ (giữ lại cho tương thích)
    public Task assignTask(int binId, int workerId, String taskType, int priority, String notes) {
        List<Integer> binIds = Collections.singletonList(binId);
        List<Task> tasks = assignMultipleTasks(binIds, workerId, taskType, priority, notes);
        return tasks.isEmpty() ? null : tasks.get(0);
    }

    // Lấy danh sách task theo batch
    public List<Task> getTasksByBatch(String batchId) {
        return taskRepository.findByBatchId(batchId);
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

    public int countOpenTasksByWorker(int workerId) {
        return taskRepository.countOpenTasksByWorker(workerId);
    }

    public boolean hasOpenTask(int binId) {
        return taskRepository.countOpenTasksByBin(binId) > 0;
    }
    public boolean hasRestrictedTask(int binId) {
        return taskRepository.countTasksByBinExclude(binId) > 0;
    }

}