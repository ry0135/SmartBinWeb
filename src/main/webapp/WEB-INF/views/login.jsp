<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - SmartBin</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root{
            --purple-1:#2b0e5a;
            --purple-2:#40107a;
            --purple-3:#6a23b7;
            --card-bg:rgba(255,255,255,.08);
            --card-br:rgba(255,255,255,.25);
            --text:#e9e9ff;
            --muted:#cfc8ffb3;
            --btn:#8b5cf6;
            --btn-hover:#7c3aed;
        }
        *{box-sizing:border-box}
        html,body{height:100%}
        body{
            margin:0;
            font-family:Poppins,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;
            color:var(--text);
            overflow:hidden; /* như mockup */
            background: radial-gradient(1200px 480px at 50% -10%, #7d49ff55 0%, #0000 60%),
            linear-gradient(180deg, #3a0a7a 0%, #1a0b44 50%, #120a2b 100%);
        }

        /* ======= BACKGROUND LAYERS (stars + mountains + trees) ======= */
        .sky{
            position:fixed; inset:0; z-index:0;
            background:
                /* little stars */
                    radial-gradient(1px 1px at 10% 15%, #ffffffd9 99%, #0000 100%) repeat,
                    radial-gradient(1px 1px at 30% 25%, #ffffffd9 99%, #0000 100%) repeat,
                    radial-gradient(1.5px 1.5px at 70% 18%, #ffffffcc 99%, #0000 100%) repeat,
                    radial-gradient(1px 1px at 85% 35%, #ffffffd9 99%, #0000 100%) repeat,
                    radial-gradient(1px 1px at 55% 8%,  #ffffffd9 99%, #0000 100%) repeat,
                    radial-gradient(1px 1px at 45% 30%, #ffffffd9 99%, #0000 100%) repeat;
            background-size: 200px 200px, 260px 260px, 240px 240px, 300px 300px, 280px 280px, 320px 320px;
        }
        /* distant mountains */
        .mountains-1, .mountains-2, .trees{
            position:fixed; left:0; right:0;
            background-repeat:repeat-x;
            pointer-events:none;
        }
        .mountains-1{
            bottom:22vh; height:28vh; z-index:1;
            opacity:.6;
            background-image: url("data:image/svg+xml;utf8,\
<svg xmlns='http://www.w3.org/2000/svg' width='1200' height='300' viewBox='0 0 1200 300'>\
<defs><linearGradient id='g' x1='0' y1='0' x2='0' y2='1'>\
<stop offset='0' stop-color='%235e37b7'/><stop offset='1' stop-color='%23311469'/></linearGradient></defs>\
<path fill='url(%23g)' d='M0,220 L120,180 L220,210 L320,160 L420,210 L520,170 L620,210 L720,150 L820,210 L920,170 L1020,205 L1120,180 L1200,210 L1200,300 L0,300 Z'/>\
</svg>");
            background-size:1200px 300px;
        }
        .mountains-2{
            bottom:14vh; height:30vh; z-index:2;
            opacity:.8;
            background-image: url("data:image/svg+xml;utf8,\
<svg xmlns='http://www.w3.org/2000/svg' width='1200' height='320' viewBox='0 0 1200 320'>\
<path fill='%23331a6b' d='M0,260 L100,230 L180,255 L260,210 L350,250 L460,220 L560,255 L660,205 L760,255 L880,225 L980,250 L1080,230 L1200,260 L1200,320 L0,320 Z'/>\
</svg>");
            background-size:1200px 320px;
        }
        /* near trees silhouette */
        .trees{
            bottom:-2vh; height:40vh; z-index:3;
            background-image: url("data:image/svg+xml;utf8,\
<svg xmlns='http://www.w3.org/2000/svg' width='1200' height='400' viewBox='0 0 1200 400'>\
<rect width='1200' height='400' fill='%2310082a'/>\
<g fill='%23120b33'>\
<path d='M30 320 l40 -120 l40 120 z'/>\
<path d='M120 340 l50 -150 l50 150 z'/>\
<path d='M230 330 l40 -130 l40 130 z'/>\
<path d='M320 350 l55 -170 l55 170 z'/>\
<path d='M430 335 l45 -140 l45 140 z'/>\
<path d='M520 345 l48 -150 l48 150 z'/>\
<path d='M620 330 l42 -135 l42 135 z'/>\
<path d='M710 350 l55 -170 l55 170 z'/>\
<path d='M830 335 l45 -140 l45 140 z'/>\
<path d='M920 345 l48 -150 l48 150 z'/>\
<path d='M1020 330 l42 -135 l42 135 z'/>\
<path d='M1110 350 l55 -170 l55 170 z'/>\
</g></svg>");
            background-size:1200px 400px;
        }

        /* ======= CENTERED GLASS CARD ======= */
        .auth-wrap{
            position:relative; z-index:4;
            height:100vh; width:100%;
            display:grid; place-items:center;
            padding:24px;
        }
        .login-card{
            width:min(92vw,520px);
            border-radius:22px;
            padding:28px 26px 22px;
            background: var(--card-bg);
            border:1px solid var(--card-br);
            box-shadow:0 10px 40px rgba(0,0,0,.45), inset 0 1px 0 rgba(255,255,255,.2);
            backdrop-filter: blur(12px) saturate(120%);
            -webkit-backdrop-filter: blur(12px) saturate(120%);
        }
        .login-title{
            font-weight:700; font-size:28px; text-align:center; margin-bottom:18px;
        }
        .input-group-text{
            background:rgba(255,255,255,.10); border-color:rgba(255,255,255,.25); color:var(--text)
        }
        .form-control{
            background:rgba(255,255,255,.10);
            border:1px solid rgba(255,255,255,.25);
            color:#fff;
        }
        .form-control::placeholder{ color:#e9e9ff99 }
        .form-control:focus{
            background:rgba(255,255,255,.14);
            border-color:#b19cff;
            box-shadow:0 0 0 .2rem rgba(177,156,255,.25);
            color:#fff;
        }
        .helper-row{
            display:flex; align-items:center; justify-content:space-between;
            gap:12px; font-size:.92rem; color:var(--muted);
        }
        .form-check-input{
            background:transparent; border-color:#c9bcff66
        }
        .form-check-input:checked{ background-color:#b19cff; border-color:#b19cff }
        .btn-login{
            display:block; width:100%; border:none;
            background:linear-gradient(180deg,var(--btn),#6d28d9);
            color:#fff; padding:12px 16px; margin-top:12px;
            border-radius:999px; font-weight:600; letter-spacing:.2px;
            box-shadow:0 6px 18px rgba(124,58,237,.45);
        }
        .btn-login:hover{ background:linear-gradient(180deg,var(--btn-hover),#5b21b6) }
        .muted-link{ color:var(--muted); text-decoration:none }
        .muted-link:hover{ color:#ffffff }

        .divider{border-top:1px solid rgba(255,255,255,.2); margin:16px 0}

        .brand{
            text-align:center; margin-bottom:8px; color:#fff; letter-spacing:.5px;
        }
        .brand i{ margin-right:6px }
        .bottom-note{ text-align:center; color:var(--muted); font-size:.95rem }
        .bottom-note a{ color:#fff; font-weight:600; text-decoration:none }
        .alert{ font-size:.95rem }
    </style>
</head>
<body>

<!-- Background layers -->
<div class="sky"></div>
<div class="mountains-1"></div>
<div class="mountains-2"></div>
<div class="trees"></div>

<!-- Centered card -->
<div class="auth-wrap">
    <div class="login-card">
        <div class="brand">
            <i class="bi bi-trash2-fill"></i> SMARTBIN
        </div>
        <div class="login-title">Login</div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Lỗi:</strong> ${error}
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" autocomplete="on">
            <!-- Username -->
            <div class="mb-3">
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" name="email" id="email" placeholder="Username" required>
                </div>
            </div>

            <!-- Password -->
            <div class="mb-2">
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                </div>
            </div>

            <!-- Helper row -->
            <div class="helper-row mb-2">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="true" id="rememberMe" name="rememberMe">
                    <label class="form-check-label" for="rememberMe">Remember me</label>
                </div>
                <a class="muted-link" href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
            </div>

            <button type="submit" class="btn-login">
                <i class="bi bi-box-arrow-in-right me-1"></i> Login
            </button>

            <div class="divider"></div>

            <p class="bottom-note">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </p>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
