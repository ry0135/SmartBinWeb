package com.example.listener;
import com.example.model.Bin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

import javax.persistence.*;

@Component
public class BinEntityListener {

    private static SimpMessagingTemplate template;

    @Autowired
    public void init(SimpMessagingTemplate template) {
        BinEntityListener.template = template;
    }

    @PostPersist
    @PostUpdate
    public void afterAnyUpdate(Bin bin) {
        if (template != null) {
            template.convertAndSend("/topic/binUpdates", bin);
            System.out.println("📡 Sent update to WebSocket for BinID = " + bin.getBinID());
        }
    }

    @PostRemove
    public void afterDelete(Bin bin) {
        if (template != null) {
            template.convertAndSend("/topic/binRemoved", bin);
            System.out.println("🗑 Bin removed: " + bin.getBinID());
        }
    }
}
