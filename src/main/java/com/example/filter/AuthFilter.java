package com.example.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();

        // Các trang KHÔNG cần login
        boolean isPublic =
                path.endsWith("login.jsp") ||
                        path.contains("/login") ||
                        path.contains("/auth") ||
                        path.contains("/assets") ||
                        path.contains("/css") ||
                        path.contains("/js");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu chưa login → redirect về login
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Nếu đã login → cho đi tiếp
        chain.doFilter(request, response);
    }
}
