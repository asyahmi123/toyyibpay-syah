<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>E-Sumbangan - MMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --green-main: #0b8a83;
                --green-dark: #056d67;
                --green-gradient: linear-gradient(135deg, #0b8a83 0%, #056d67 100%);
                --green-light: #e6f7f6;
                --gold: #f59e0b;
                --text-dark: #1f2937;
                --text-mid: #4b5563;
                --text-light: #9ca3af;
                --bg: #f3f4f6;
                --white: #ffffff;
                --border: #e5e7eb;
            }
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Poppins', sans-serif;
                background: var(--bg);
                color: var(--text-dark);
            }

            /* NAVBAR */
            .navbar {
                position: sticky;
                top: 0;
                z-index: 200;
                background: rgba(255,255,255,0.95);
                backdrop-filter: blur(20px);
                border-bottom: 1px solid var(--border);
                box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            }
            .nav-inner {
                max-width: 1280px;
                margin: 0 auto;
                padding: 0 5%;
                height: 66px;
                display: flex;
                align-items: center;
                gap: 24px;
            }
            .nav-brand {
                display: flex;
                align-items: center;
                gap: 10px;
                text-decoration: none;
                font-weight: 800;
                font-size: 19px;
                color: var(--green-main);
                flex-shrink: 0;
            }
            .nav-logo {
                width: 36px;
                height: 36px;
                background: var(--green-gradient);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 16px;
                box-shadow: 0 4px 12px rgba(11,138,131,0.3);
            }
            .nav-links {
                display: flex;
                align-items: center;
                gap: 4px;
                flex: 1;
            }
            .nav-links a {
                padding: 7px 13px;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 500;
                color: var(--text-mid);
                text-decoration: none;
                transition: all 0.2s;
            }
            .nav-links a:hover, .nav-links a.active {
                color: var(--green-main);
                background: var(--green-light);
                font-weight: 600;
            }
            .nav-right {
                display: flex;
                align-items: center;
                gap: 12px;
                flex-shrink: 0;
            }
            .nav-user {
                display: flex;
                align-items: center;
                gap: 9px;
            }
            .user-avatar {
                width: 34px;
                height: 34px;
                background: var(--green-gradient);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 13px;
                font-weight: 700;
            }
            .user-name {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                max-width: 120px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .btn-logout {
                display: flex;
                align-items: center;
                gap: 7px;
                padding: 8px 14px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                color: #ef4444;
                text-decoration: none;
                border: 1.5px solid #fee2e2;
                background: #fff5f5;
                transition: all 0.2s;
            }
            .btn-logout:hover {
                background: #fecaca;
            }
            .hamburger {
                display: none;
                flex-direction: column;
                gap: 5px;
                background: none;
                border: none;
                cursor: pointer;
                padding: 4px;
                margin-left: auto;
            }
            .hamburger span {
                display: block;
                width: 22px;
                height: 2px;
                background: var(--text-dark);
                border-radius: 2px;
                transition: all 0.3s;
            }
            .hamburger.open span:nth-child(1) {
                transform: rotate(45deg) translate(5px,5px);
            }
            .hamburger.open span:nth-child(2) {
                opacity: 0;
            }
            .hamburger.open span:nth-child(3) {
                transform: rotate(-45deg) translate(5px,-5px);
            }
            .mobile-nav {
                display: none;
                flex-direction: column;
                padding: 8px 5% 16px;
                border-top: 1px solid var(--border);
                background: white;
                gap: 2px;
            }
            .mobile-nav.open {
                display: flex;
            }
            .mobile-nav a {
                padding: 10px 14px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                color: var(--text-mid);
                text-decoration: none;
            }
            .mobile-nav a:hover {
                background: var(--green-light);
                color: var(--green-main);
            }
            .mobile-logout {
                color: #ef4444 !important;
                margin-top: 6px;
            }

            /* PAGE HEADER */
            .page-header {
                background: var(--green-gradient);
                padding: 48px 5% 56px;
                text-align: center;
                position: relative;
                overflow: hidden;
            }
            .page-header::before {
                content: '';
                position: absolute;
                inset: 0;
                background-image: radial-gradient(rgba(255,255,255,0.07) 1px, transparent 1px);
                background-size: 24px 24px;
            }
            .page-header-content {
                position: relative;
                z-index: 2;
            }
            .page-header-icon {
                width: 60px;
                height: 60px;
                background: rgba(255,255,255,0.15);
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 26px;
                margin: 0 auto 16px;
                border: 1.5px solid rgba(255,255,255,0.2);
            }
            .page-header h1 {
                font-size: clamp(1.6rem, 3vw, 2.2rem);
                font-weight: 800;
                color: white;
                margin-bottom: 8px;
            }
            .page-header p {
                font-size: 15px;
                color: rgba(255,255,255,0.8);
            }

            /* MAIN */
            .main-content {
                max-width: 1000px;
                margin: -28px auto 60px;
                padding: 0 5%;
                position: relative;
                z-index: 3;
            }

            /* ALERTS */
            .alert-success {
                background: #d1fae5;
                color: #065f46;
                padding: 14px 18px;
                border-radius: 12px;
                border: 1px solid #6ee7b7;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
                font-weight: 500;
            }
            .alert-error {
                background: #fef2f2;
                color: #991b1b;
                padding: 14px 18px;
                border-radius: 12px;
                border: 1px solid #fca5a5;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
                font-weight: 500;
            }

            /* LAYOUT */
            .donation-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
            }
            .card {
                background: white;
                border-radius: 20px;
                padding: 28px;
                border: 1px solid var(--border);
                box-shadow: 0 4px 16px rgba(0,0,0,0.05);
            }
            .card-title {
                font-size: 16px;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                padding-bottom: 14px;
                border-bottom: 1px solid var(--border);
            }
            .card-title i {
                color: var(--green-main);
            }

            /* FORM */
            .form-group {
                margin-bottom: 16px;
            }
            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 6px;
            }
            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 11px 14px;
                border-radius: 10px;
                border: 1.5px solid var(--border);
                font-size: 14px;
                font-family: 'Poppins', sans-serif;
                background: #f9fafb;
                color: var(--text-dark);
                transition: all 0.2s;
            }
            .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
                outline: none;
                background: white;
                border-color: var(--green-main);
                box-shadow: 0 0 0 3px rgba(11,138,131,0.1);
            }
            .form-group textarea {
                resize: vertical;
                min-height: 80px;
            }

            /* Amount pills */
            .amount-pills {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                margin-bottom: 10px;
            }
            .amount-pill {
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 600;
                border: 1.5px solid var(--border);
                background: white;
                cursor: pointer;
                color: var(--text-mid);
                transition: all 0.2s;
            }
            .amount-pill:hover, .amount-pill.active {
                border-color: var(--green-main);
                background: var(--green-light);
                color: var(--green-main);
            }

            .btn-submit {
                width: 100%;
                padding: 13px;
                background: var(--green-gradient);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 15px;
                font-weight: 700;
                cursor: pointer;
                font-family: 'Poppins', sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                box-shadow: 0 4px 16px rgba(11,138,131,0.3);
                transition: all 0.2s;
                margin-top: 4px;
            }
            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(11,138,131,0.4);
            }

            /* QR */
            .qr-wrapper {
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 14px;
            }
            .qr-frame {
                padding: 16px;
                border-radius: 16px;
                background: white;
                border: 2px solid var(--green-light);
                box-shadow: 0 8px 32px rgba(11,138,131,0.12);
            }
            .qr-label {
                font-size: 13px;
                font-weight: 600;
                color: var(--green-main);
                display: flex;
                align-items: center;
                gap: 7px;
            }
            .pulse {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: var(--green-main);
                animation: pulse 1.5s infinite;
                display: inline-block;
            }
            @keyframes pulse {
                0%,100%{
                    opacity:1;
                    transform:scale(1)
                }
                50%{
                    opacity:0.4;
                    transform:scale(1.4)
                }
            }
            .bank-box {
                background: var(--green-light);
                border-radius: 12px;
                padding: 14px 16px;
                border: 1px solid rgba(11,138,131,0.2);
                width: 100%;
                text-align: center;
            }
            .bank-box p {
                font-size: 13px;
                font-weight: 700;
                color: var(--green-dark);
                margin-bottom: 4px;
            }
            .bank-box small {
                font-size: 12px;
                color: var(--text-mid);
                display: block;
                line-height: 1.6;
            }

            /* Info list */
            .info-list {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .info-row {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px;
                border-radius: 10px;
                background: #f9fafb;
                border: 1px solid var(--border);
            }
            .info-icon {
                width: 36px;
                height: 36px;
                border-radius: 9px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 15px;
                flex-shrink: 0;
            }
            .info-row p {
                font-size: 13px;
                font-weight: 600;
                color: var(--text-dark);
                margin: 0;
            }
            .info-row small {
                font-size: 11px;
                color: var(--text-light);
            }

            @media (max-width: 768px) {
                .nav-links, .nav-right {
                    display: none;
                }
                .hamburger {
                    display: flex;
                }
                .donation-layout {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <!-- NAVBAR -->
        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div>
                    <span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/user/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity.jsp">Aktiviti</a>
                    <a href="${pageContext.request.contextPath}/donation.jsp" class="active">Sumbangan</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                </nav>
                <div class="nav-right">
                    <div class="nav-user">
                        <div class="user-avatar">${currentUser.name.substring(0,1).toUpperCase()}</div>
                        <span class="user-name">${currentUser.name}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                        <i class="fa-solid fa-power-off"></i> <span>Keluar</span>
                    </a>
                </div>
                <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
            </div>
            <div class="mobile-nav" id="mobileNav">
                <a href="${pageContext.request.contextPath}/home">Utama</a>
                <a href="${pageContext.request.contextPath}/user/bookings">Tempahan</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                <a href="${pageContext.request.contextPath}/activity.jsp">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mobile-logout"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </div>
        </header>

        <!-- PAGE HEADER -->
        <div class="page-header">
            <div class="page-header-content">
                <div class="page-header-icon"><i class="fa-solid fa-hand-holding-heart"></i></div>
                <h1>E-Sumbangan Masjid</h1>
                <p>Setiap sumbangan anda adalah amal jariah yang berterusan</p>
            </div>
        </div>

        <!-- MAIN -->
        <main class="main-content">

            <c:if test="${not empty success}">
                <div class="alert-success"><i class="fa-solid fa-circle-check"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
            </c:if>

            <div class="donation-layout">

                <!-- Borang -->
                <div class="card">
                    <div class="card-title"><i class="fa-solid fa-pen-to-square"></i> Borang Sumbangan</div>
                    <form action="${pageContext.request.contextPath}/donation" method="post">

                        <div class="form-group">
                            <label>Nama Penderma</label>
                            <input type="text" name="donor_name" value="${currentUser.name}" required>
                        </div>

                        <div class="form-group">
                            <label>Jumlah Sumbangan (RM)</label>
                            <div class="amount-pills">
                                <span class="amount-pill" onclick="setAmount(10, this)">RM 10</span>
                                <span class="amount-pill" onclick="setAmount(20, this)">RM 20</span>
                                <span class="amount-pill" onclick="setAmount(50, this)">RM 50</span>
                                <span class="amount-pill" onclick="setAmount(100, this)">RM 100</span>
                                <span class="amount-pill" onclick="setAmount(200, this)">RM 200</span>
                            </div>
                            <input type="number" name="amount" id="amountInput" placeholder="Atau masukkan jumlah lain..." min="1" step="0.01" required>
                        </div>

                        <div class="form-group">
                            <label>Jenis Tabung</label>
                            <select name="donation_type" required>
                                <option value="">-- Pilih Jenis Tabung --</option>
                                <option value="Tabung Umum">Tabung Umum</option>
                                <option value="Tabung Pembangunan">Tabung Pembangunan</option>
                                <option value="Tabung Asnaf">Tabung Asnaf</option>
                                <option value="Program Ilmu">Program Ilmu</option>
                                <option value="Tabung Wakaf">Tabung Wakaf</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Kaedah Pembayaran</label>
                            <select name="payment_method" required>
                                <option value="">-- Pilih Kaedah --</option>
                                <option value="QR Code">QR Code / DuitNow</option>
                                <option value="Tunai">Tunai</option>
                                <option value="Pindahan Bank">Pindahan Bank</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Catatan (Pilihan)</label>
                            <textarea name="notes" placeholder="Contoh: Untuk nama arwah, hadiah pahala..."></textarea>
                        </div>

                        <button type="submit" class="btn-submit">
                            <i class="fa-solid fa-heart"></i> Sahkan Sumbangan
                        </button>
                    </form>
                </div>

                <!-- QR + Info -->
                <div style="display:flex; flex-direction:column; gap:20px;">
                    <div class="card">
                        <div class="card-title"><i class="fa-solid fa-qrcode"></i> Imbas QR untuk Bayar</div>
                        <div class="qr-wrapper">
                            <div class="qr-frame">
                                <div id="qrcode"></div>
                            </div>
                            <div class="qr-label"><span class="pulse"></span> Imbas dengan banking app anda</div>
                            <div class="bank-box">
                                <p><i class="fa-solid fa-building-columns"></i> Maybank Islamic</p>
                                <small>No. Akaun: <b>5621 4892 1234</b></small>
                                <small>Tabung Masjid Al-Aman</small>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-title"><i class="fa-solid fa-circle-info"></i> Manfaat Sumbangan</div>
                        <div class="info-list">
                            <div class="info-row">
                                <div class="info-icon" style="background:#e6f7f6;color:#0b8a83;"><i class="fa-solid fa-wrench"></i></div>
                                <div><p>Penyelenggaraan Fasiliti</p><small>Jaga kebersihan & kemudahan masjid</small></div>
                            </div>
                            <div class="info-row">
                                <div class="info-icon" style="background:#fef3c7;color:#d97706;"><i class="fa-solid fa-book-open"></i></div>
                                <div><p>Program Ilmu & Pengajian</p><small>Kelas fardhu ain, tahfiz, ceramah</small></div>
                            </div>
                            <div class="info-row">
                                <div class="info-icon" style="background:#fff1f4;color:#e11d48;"><i class="fa-solid fa-heart"></i></div>
                                <div><p>Bantuan Asnaf & Yatim</p><small>Menyantuni golongan yang memerlukan</small></div>
                            </div>
                            <div class="info-row">
                                <div class="info-icon" style="background:#eff6ff;color:#2563eb;"><i class="fa-solid fa-people-group"></i></div>
                                <div><p>Aktiviti Komuniti</p><small>Program kemasyarakatan setempat</small></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
        <script>
                                    window.addEventListener('scroll', () => {
                                        document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 10);
                                    });
                                    document.getElementById('hamburger').addEventListener('click', function () {
                                        this.classList.toggle('open');
                                        document.getElementById('mobileNav').classList.toggle('open');
                                    });

                                    new QRCode(document.getElementById("qrcode"), {
                                        text: "https://maybankpay.maybank2u.com.my/masjid-al-aman",
                                        width: 180, height: 180,
                                        colorDark: "#0b8a83", colorLight: "#ffffff",
                                        correctLevel: QRCode.CorrectLevel.H
                                    });

                                    function setAmount(val, el) {
                                        document.getElementById('amountInput').value = val;
                                        document.querySelectorAll('.amount-pill').forEach(p => p.classList.remove('active'));
                                        el.classList.add('active');
                                    }
        </script>
    </body>
</html>
