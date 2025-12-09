package com.example.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
            "/login",
            "/login.jsp",
            "/auth",
            "/api",
            "/api/",
            "/ws-bin",
            "/ws-bin/",
            "/uploads",
            "/assets",
            "/css",
            "/js",
            "/fonts"
    );

    private boolean isStaticResource(String path) {
        return path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg")
                || path.endsWith(".gif") || path.endsWith(".svg") || path.endsWith(".pbf")
                || path.endsWith(".css") || path.endsWith(".js");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String context = req.getContextPath();          // /SmartBinWeb_war
        String uri = req.getRequestURI();               // /SmartBinWeb_war/login
        String path = uri.substring(context.length());  // /login

        System.out.println("👉 FILTER PATH: " + path);

        // 1️⃣ Static files → cho qua
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2️⃣ Kiểm tra path public (login, api…)
        for (String p : EXCLUDED_PATHS) {
            if (path.startsWith(p)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // 3️⃣ Kiểm tra session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(context + "/login");
            return;
        }

        // 4️⃣ OK → cho qua
        chain.doFilter(request, response);
    }
}
