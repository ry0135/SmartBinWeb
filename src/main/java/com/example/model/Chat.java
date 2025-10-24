package com.example.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Chats")
public class Chat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ChatID")
    private int chatId;

    @ManyToOne
    @JoinColumn(name = "SenderID", nullable = false)
    private Account sender;

    @ManyToOne
    @JoinColumn(name = "ReceiverID", nullable = false)
    private Account receiver;

    @Column(name = "Message", length = 1000, nullable = false)
    private String message;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "SentAt", nullable = false)
    private Date sentAt = new Date();

    @Column(name = "IsRead")
    private boolean isRead = false;

    // ====== Constructors ======
    public Chat() {}

    public Chat(Account sender, Account receiver, String message) {
        this.sender = sender;
        this.receiver = receiver;
        this.message = message;
        this.sentAt = new Date();
        this.isRead = false;
    }

    // ====== Getters & Setters ======
    public int getChatId() {
        return chatId;
    }

    public Account getSender() {
        return sender;
    }

    public void setSender(Account sender) {
        this.sender = sender;
    }

    public Account getReceiver() {
        return receiver;
    }

    public void setReceiver(Account receiver) {
        this.receiver = receiver;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Date getSentAt() {
        return sentAt;
    }

    public void setSentAt(Date sentAt) {
        this.sentAt = sentAt;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }
}
