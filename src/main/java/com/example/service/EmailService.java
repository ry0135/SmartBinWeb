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
    String hotline = "033-8080-524";

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


    public void sendForgotPasswordCode(String email, String code) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setTo(email);
            helper.setSubject(" Khôi Phục Mật Khẩu - SmartBin");

            String content = "<html><body style='font-family:Arial,sans-serif; line-height:1.6;'>"
                    + "<h2 style='color:#4CAF50;'>Yêu cầu đặt lại mật khẩu</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Bạn vừa yêu cầu <b>đặt lại mật khẩu</b> cho tài khoản SmartBin của mình.</p>"
                    + "<p>🔑 Mã xác minh của bạn là: <b style='color:#d32f2f;font-size:18px;'>" + code + "</b></p>"
                    + "Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>"
                    + "<hr style='margin:20px 0;border:none;border-top:1px solid #eee;'>"
                    + "<p>🌱 <b>Đội ngũ SmartBin</b><br>"
                    + "🌐 <a href='" + linkweb + "'>Website SmartBin</a><br>"
                    + "📧 Email hỗ trợ: " + supportEmail + "<br>"
                    + "📞 Hotline: " + hotline + "</p>"
                    + "</body></html>";

            helper.setText(content, true);
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi email mã khôi phục mật khẩu thành công đến: " + email);
        } catch (MessagingException e) {
            System.err.println("❌ Lỗi khi gửi email khôi phục mật khẩu: " + e.getMessage());
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

    // ===================== ADD-ON =====================
    // Gửi email khi Admin APPROVE ứng viên Manager: kèm account hệ thống
    public void sendManagerApprovedEmail(String toPersonalEmail,
                                         String fullName,
                                         String systemEmail,
                                         String tempPassword,
                                         String wardName) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            helper.setTo(toPersonalEmail);
            helper.setSubject("Chào mừng bạn gia nhập SmartBin (Manager)");

            // Nội dung HTML, đảm bảo encoding UTF-8
            String content = ""
                    + "<p>Xin chào <b>" + fullName + "</b>,</p>"
                    + "<p>Chúc mừng! Đơn đăng ký Manager của bạn đã được chấp nhận.</p>"
                    + "<p><b>Thông tin đăng nhập:</b><br>"
                    + "- Website: <a href='https://smartbin.com/login'>https://smartbin.com/login</a><br>"
                    + "- Email: " + systemEmail + "<br>"
                    + "- Mật khẩu tạm thời: <b>" + tempPassword + "</b><br>"
                    + "- Phường quản lý: " + (wardName != null ? wardName : "") + "</p>"
                    + "<p>Vui lòng đăng nhập và đổi mật khẩu trong lần đầu sử dụng.</p>"
                    + "<hr>"
                    + "<p>🌐 <a href='" + linkweb + "'>" + linkweb + "</a><br>"
                    + "📧 Hỗ trợ: " + supportEmail + "<br>"
                    + "📞 Hotline: " + hotline + "</p>"
                    + "<p>Trân trọng,<br>Đội ngũ SmartBin</p>";

            helper.setText(content, true); // true = HTML
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi email APPROVE Manager (UTF-8).");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // Gửi email khi Admin REJECT ứng viên Manager
    public void sendManagerRejectedEmail(String toPersonalEmail,
                                         String fullName,
                                         String reason) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            helper.setTo(toPersonalEmail);
            helper.setSubject("Kết quả xét duyệt đăng ký Manager - SmartBin");

            String content = ""
                    + "<p>Xin chào <b>" + fullName + "</b>,</p>"
                    + "<p style='color:red;'>Rất tiếc, đơn đăng ký Manager của bạn đã bị từ chối.</p>"
                    + "<p><b>Lý do:</b> " + (reason != null ? reason : "Không xác định") + "</p>"
                    + "<p>Bạn có thể chỉnh sửa hồ sơ và nộp lại trong tương lai.</p>"
                    + "<hr>"
                    + "<p>🌐 <a href='" + linkweb + "'>Website</a><br>"
                    + "📧 Hỗ trợ: " + supportEmail + "<br>"
                    + "📞 Hotline: " + hotline + "</p>";

            helper.setText(content, true); // true = HTML
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi email REJECT Manager (UTF-8).");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    // ===================== BAN / UNBAN ACCOUNT =====================

    /**
     * Gửi email khi tài khoản bị tạm khóa.
     * Plain text UTF-8, tránh emoji để không lỗi font ở client cũ.
     */
    public void sendAccountBannedEmail(String to, String fullName, String reason) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "UTF-8");

            helper.setTo(to);
            helper.setSubject("[SmartBin] Tài khoản của bạn đã bị tạm khóa");

            String name = (fullName == null || fullName.trim().isEmpty()) ? "bạn" : fullName.trim();
            String rs = (reason == null || reason.trim().isEmpty()) ? "Không có lý do cụ thể." : reason.trim();

            String content =
                    "Xin chào " + name + ",\n\n" +
                            "Tài khoản SmartBin của bạn đã bị tạm khóa bởi quản trị viên.\n" +
                            "Lý do: " + rs + "\n\n" +
                            "Nếu bạn cần hỗ trợ, vui lòng liên hệ:\n" +
                            "- Website: " + linkweb + "\n" +
                            "- Email hỗ trợ: " + supportEmail + "\n" +
                            "- Hotline: " + hotline + "\n\n" +
                            "Trân trọng,\n" +
                            "Đội ngũ SmartBin";

            helper.setText(content, false); // false = text/plain
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi email BAN account.");
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi gửi email BAN: " + e.getMessage());
        }
    }

    /**
     * Gửi email khi tài khoản được mở khóa.
     * Plain text UTF-8, tránh emoji để không lỗi font ở client cũ.
     */
    public void sendAccountReactivatedEmail(String to, String fullName) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "UTF-8");

            helper.setTo(to);
            helper.setSubject("[SmartBin] Tài khoản của bạn đã được mở khóa");

            String name = (fullName == null || fullName.trim().isEmpty()) ? "bạn" : fullName.trim();

            String content =
                    "Xin chào " + name + ",\n\n" +
                            "Tài khoản SmartBin của bạn đã được mở khóa và có thể sử dụng bình thường.\n\n" +
                            "Nếu bạn gặp bất kỳ vấn đề nào, vui lòng liên hệ:\n" +
                            "- Website: " + linkweb + "\n" +
                            "- Email hỗ trợ: " + supportEmail + "\n" +
                            "- Hotline: " + hotline + "\n\n" +
                            "Trân trọng,\n" +
                            "Đội ngũ SmartBin";

            helper.setText(content, false); // false = text/plain
            mailSender.send(mimeMessage);
            System.out.println("✅ Đã gửi email UNBAN account.");
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi gửi email UNBAN: " + e.getMessage());
        }
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
