package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

@Service
public class EmailService {
    String linkweb = "http://www.smartbin.com";
    String supportEmail = "support@smartbin.com";
    String hotline = "098-765-4321";

    @Autowired
    private JavaMailSender mailSender;

    public void sendCodeToEmail(String email, String code) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject("🔑 Mã Xác Minh Tài Khoản SmartBin");

            String content = "<p>Xin chào,</p>"
                    + "<p>💡 Đây là mã xác minh của bạn: <b>" + code + "</b></p>"
                    + "<p>Vui lòng nhập mã này vào trang xác minh để hoàn tất quá trình đăng ký hoặc khôi phục tài khoản. ✅</p>"
                    + "<p>Nếu bạn không yêu cầu mã này, hãy bỏ qua email này.</p>"
                    + "<p>Trân trọng,</p>"
                    + "<p><b>🌟 Đội ngũ SmartBin</b><br>"
                    + "🌐 <a href='" + linkweb + "'>Website</a><br>"
                    + "📧 Email hỗ trợ: " + supportEmail + "<br>"
                    + "📞 Hotline: " + hotline + "</p>";

            helper.setText(content, true);
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi email mã xác minh thành công.");
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi khi gửi email: " + e.getMessage());
        }
    }

    public void sendCodeToEmailResendCode(String email, String code) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject("🔄 Mã Xác Minh Đã Được Gửi Lại");

            String content = "<p>Xin chào,</p>"
                    + "<p>🔄 Chúng tôi đã gửi lại mã xác minh của bạn: <b>" + code + "</b></p>"
                    + "<p>Vui lòng nhập mã này vào trang xác minh để hoàn tất quá trình đăng ký hoặc khôi phục tài khoản. ✅</p>"
                    + "<p>Nếu bạn không yêu cầu mã này, hãy bỏ qua email này.</p>"
                    + "<p>Trân trọng,</p>"
                    + "<p><b>🌟 Đội ngũ SmartBin</b><br>"
                    + "🌐 <a href='" + linkweb + "'>Website</a><br>"
                    + "📧 Email hỗ trợ: " + supportEmail + "<br>"
                    + "📞 Hotline: " + hotline + "</p>";

            helper.setText(content, true);
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi lại email mã xác minh thành công.");
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi khi gửi email: " + e.getMessage());
        }
    }

    public void sendVerifyCodeAndUpdatePassword(String email, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Mã xác minh đặt lại mật khẩu SmartBin");
        message.setText("Xin chào,\n\n"
                + "Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản SmartBin của mình. "
                + "Mã xác minh của bạn là: " + code + "\n\n"
                + "Vui lòng nhập mã này trên trang đặt lại mật khẩu để tiếp tục. "
                + "Nếu bạn không yêu cầu hành động này, hãy bỏ qua email này.\n\n"
                + "Trân trọng,\n"
                + "Đội ngũ hỗ trợ SmartBin");
        mailSender.send(message);
        System.out.println("✅ Đã gửi email mã xác minh thành công.");
    }



    public void sendReportEmail(String email, String subject, String reportHtml) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject(subject);

            // Nội dung HTML báo cáo
            String content = "<h2 style='color:#1E90FF;'>📋 Chi tiết báo cáo SmartBin</h2>"
                    + reportHtml
                    + "<hr>"
                    + "<p>Trân trọng,<br>"
                    + "<b>🌟 Đội ngũ SmartBin</b><br>"
                    + "🌐 <a href='" + linkweb + "'>" + linkweb + "</a><br>"
                    + "📧 " + supportEmail + "<br>"
                    + "📞 " + hotline + "</p>";

            helper.setText(content, true);
            mailSender.send(mimeMessage);

            System.out.println("✅ Đã gửi báo cáo thành công đến: " + email);
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi khi gửi báo cáo: " + e.getMessage());
        }
    }

}
