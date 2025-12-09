package com.example.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.TimeZone;

public class TimezoneListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        System.out.println(">>> WebApp TimeZone = " + TimeZone.getDefault());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // nothing
    }
}
