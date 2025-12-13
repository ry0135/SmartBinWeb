package com.example.service;

import com.example.model.Task;
import com.example.repository.TasksRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class TaskSchedulerService {

    @Autowired
    private TasksRepository tasksRepository;

    @Scheduled(fixedRate = 5 * 60 * 1000) // mỗi 5 phút
    public void autoMarkTaskAsIssue() {
        List<Task> tasks = tasksRepository.findDoingTasksNotCompleted();
        Date now = new Date();

        for (Task task : tasks) {
            Date updatedAt = task.getUpdatedAt();
            if (updatedAt == null) continue;

            long diffMillis = now.getTime() - updatedAt.getTime();
            long diffHours = diffMillis / (1000 * 60 * 60);

            if (diffHours >= 8) {
                task.setStatus("ISSUE");
                task.setIssueReason("Quá thời gian mà không nhận nhiệm vụ");
                tasksRepository.save(task);
            }
        }
    }
}
