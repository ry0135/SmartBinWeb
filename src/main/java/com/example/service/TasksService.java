package com.example.service;

import com.example.model.Account;
import com.example.model.Bin;
import com.example.model.Tasks;
import com.example.repository.AccountRepository;
import com.example.repository.BinRepository;
import com.example.repository.TasksRepository;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class TasksService {

    @Autowired
    private TasksRepository taskRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private BinRepository binRepository;

    @Autowired
    private WardRepository wardRepository; // Thêm repository này
    // Sửa từ String ward thành int wardID
    public List<Account> getAvailableWorkers(int wardID) {
        List<Account> workers = accountRepository.findWorkersByWard(wardID);

        Map<Integer, Integer> workerTaskCount = new HashMap<>();
        for (Account w : workers) {
            int count = taskRepository.countOpenTasksByWorker(w.getAccountId());
            workerTaskCount.put(w.getAccountId(), count);
            w.setTaskCount(count); // Set task count
        }

        workers.sort(Comparator.comparingInt(Account::getTaskCount));
        return workers;
    }

    public Tasks assignTask(int binId, int workerId, String taskType, int priority, String notes) {
        Bin bin = binRepository.findById(binId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy bin với ID = " + binId));

        Account worker = accountRepository.findById(workerId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy worker với ID = " + workerId));

        Tasks task = new Tasks();
        task.setBin(bin);
        task.setAssignedTo(worker);
        task.setTaskType(taskType);
        task.setPriority(priority);
        task.setStatus("OPEN");
        task.setNotes(notes);
        task.setCreatedAt(new Date());

        return taskRepository.save(task);
    }

    public int countOpenTasksByWorker(int workerId) {
        return taskRepository.countOpenTasksByWorker(workerId);
    }

    public boolean hasOpenTask(int binId) {
        return taskRepository.countOpenTasksByBin(binId) > 0;
    }
}