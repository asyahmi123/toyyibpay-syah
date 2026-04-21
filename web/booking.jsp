<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Borang Tempahan - MMS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --green-main:#0b8a83;--green-dark:#056d67;--green-gradient:linear-gradient(135deg,#0b8a83 0%,#056d67 100%);--green-light:#e6f7f6;--text-dark:#1f2937;--text-mid:#4b5563;--text-light:#9ca3af;--bg:#f3f4f6;--white:#ffffff;--border:#e5e7eb; }
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Poppins',sans-serif;background:var(--bg);color:var(--text-dark);}
        .navbar{position:sticky;top:0;z-index:200;background:rgba(255,255,255,0.95);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);box-shadow:0 2px 12px rgba(0,0,0,0.05);}
        .nav-inner{max-width:1280px;margin:0 auto;padding:0 5%;height:66px;display:flex;align-items:center;gap:24px;}
        .nav-brand{display:flex;align-items:center;gap:10px;text-decoration:none;font-weight:800;font-size:19px;color:var(--green-main);flex-shrink:0;}
        .nav-logo{width:36px;height:36px;background:var(--green-gradient);border-radius:10px;display:flex;align-items:center;justify-content:center;color:white;font-size:16px;box-shadow:0 4px 12px rgba(11,138,131,0.3);}
        .nav-links{display:flex;align-items:center;gap:4px;flex:1;}
        .nav-links a{padding:7px 13px;border-radius:8px;font-size:13.5px;font-weight:500;color:var(--text-mid);text-decoration:none;transition:all 0.2s;}
        .nav-links a:hover,.nav-links a.active{color:var(--green-main);background:var(--green-light);font-weight:600;}
        .nav-right{display:flex;align-items:center;gap:12px;flex-shrink:0;}
        .nav-user{display:flex;align-items:center;gap:9px;}
        .user-avatar{width:34px;height:34px;background:var(--green-gradient);border-radius:50%;display:flex;align-items:center;justify-content:center;color:white;font-size:13px;font-weight:700;}
        .user-name{font-size:13px;font-weight:600;color:var(--text-dark);max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .btn-logout{display:flex;align-items:center;gap:7px;padding:8px 14px;border-radius:8px;font-size:13px;font-weight:600;color:#ef4444;text-decoration:none;border:1.5px solid #fee2e2;background:#fff5f5;transition:all 0.2s;}
        .btn-logout:hover{background:#fecaca;}
        .hamburger{display:none;flex-direction:column;gap:5px;background:none;border:none;cursor:pointer;padding:4px;margin-left:auto;}
        .hamburger span{display:block;width:22px;height:2px;background:var(--text-dark);border-radius:2px;transition:all 0.3s;}
        .hamburger.open span:nth-child(1){transform:rotate(45deg) translate(5px,5px);}
        .hamburger.open span:nth-child(2){opacity:0;}
        .hamburger.open span:nth-child(3){transform:rotate(-45deg) translate(5px,-5px);}
        .mobile-nav{display:none;flex-direction:column;padding:8px 5% 16px;border-top:1px solid var(--border);background:white;gap:2px;}
        .mobile-nav.open{display:flex;}
        .mobile-nav a{padding:10px 14px;border-radius:8px;font-size:14px;font-weight:500;color:var(--text-mid);text-decoration:none;}
        .mobile-nav a:hover{background:var(--green-light);color:var(--green-main);}
        .mobile-logout{color:#ef4444 !important;margin-top:6px;}
        .page-header{background:var(--green-gradient);padding:40px 5% 52px;text-align:center;position:relative;overflow:hidden;}
        .page-header::before{content:'';position:absolute;inset:0;background-image:radial-gradient(rgba(255,255,255,0.07) 1px,transparent 1px);background-size:24px 24px;}
        .page-header-content{position:relative;z-index:2;max-width:760px;margin:0 auto;}
        .page-header-icon{width:56px;height:56px;background:rgba(255,255,255,0.15);border-radius:16px;display:flex;align-items:center;justify-content:center;color:white;font-size:24px;margin:0 auto 14px;border:1.5px solid rgba(255,255,255,0.2);}
        .page-header h1{font-size:clamp(1.5rem,3vw,2rem);font-weight:800;color:white;margin-bottom:6px;}
        .page-header p{font-size:14px;color:rgba(255,255,255,0.8);}
        .main-content{max-width:760px;margin:-28px auto 60px;padding:0 5%;position:relative;z-index:3;}
        .alert-error{background:#fef2f2;color:#991b1b;padding:14px 18px;border-radius:10px;border:1px solid #fca5a5;margin-bottom:20px;display:flex;align-items:center;gap:10px;font-size:14px;}
        .alert-info{background:#fef3c7;color:#92400e;padding:14px 18px;border-radius:10px;border:1px solid #fde68a;margin-bottom:20px;display:flex;align-items:flex-start;gap:10px;font-size:13px;line-height:1.7;}
        .form-card{background:white;border-radius:20px;padding:32px 36px;border:1px solid var(--border);box-shadow:0 8px 32px rgba(0,0,0,0.08);}
        .section-label{font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;letter-spacing:0.8px;margin-bottom:14px;margin-top:24px;display:flex;align-items:center;gap:8px;padding-top:16px;border-top:1px solid var(--border);}
        .section-label:first-child{margin-top:0;padding-top:0;border-top:none;}
        .section-label i{color:var(--green-main);}
        .user-bar{display:flex;align-items:center;gap:12px;padding:14px 16px;background:var(--green-light);border-radius:12px;margin-bottom:20px;border:1px solid rgba(11,138,131,0.2);}
        .user-bar-avatar{width:36px;height:36px;background:var(--green-gradient);border-radius:50%;display:flex;align-items:center;justify-content:center;color:white;font-size:14px;font-weight:700;flex-shrink:0;}
        .user-bar p{font-size:13px;font-weight:600;color:var(--green-dark);}
        .user-bar small{font-size:12px;color:var(--text-mid);}
        .form-group{margin-bottom:16px;}
        .form-group label{display:block;font-size:13px;font-weight:600;color:var(--text-dark);margin-bottom:6px;}
        .form-group input,.form-group select{width:100%;padding:11px 14px;border-radius:10px;border:1.5px solid var(--border);font-size:14px;font-family:'Poppins',sans-serif;background:#f9fafb;color:var(--text-dark);transition:all 0.2s;}
        .form-group input:focus,.form-group select:focus{outline:none;border-color:var(--green-main);background:white;box-shadow:0 0 0 3px rgba(11,138,131,0.1);}
        .grid-2{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
        /* Session cards */
        .session-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:16px;}
        .session-option{display:none;}
        .session-label{display:flex;flex-direction:column;align-items:center;padding:16px;border-radius:12px;border:1.5px solid var(--border);background:#f9fafb;cursor:pointer;transition:all 0.2s;text-align:center;}
        .session-label:hover{border-color:var(--green-main);background:var(--green-light);}
        .session-option:checked+.session-label{border-color:var(--green-main);background:var(--green-light);box-shadow:0 0 0 3px rgba(11,138,131,0.1);}
        .session-label i{font-size:24px;color:var(--green-main);margin-bottom:8px;}
        .session-label strong{font-size:14px;font-weight:700;color:var(--text-dark);}
        .session-label span{font-size:12px;color:var(--text-light);margin-top:3px;}
        /* Price preview */
        .price-box{background:var(--green-light);border-radius:12px;padding:16px 20px;border:1px solid rgba(11,138,131,0.2);margin:20px 0;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;}
        .price-box .label{font-size:13px;font-weight:600;color:var(--green-dark);}
        .price-box .note{font-size:11px;color:var(--text-mid);margin-top:3px;}
        .price-box .amount{font-size:24px;font-weight:800;color:var(--green-main);}
        .btn-submit{width:100%;padding:14px;background:var(--green-gradient);color:white;border:none;border-radius:12px;font-size:15px;font-weight:700;cursor:pointer;font-family:'Poppins',sans-serif;display:flex;align-items:center;justify-content:center;gap:10px;box-shadow:0 4px 16px rgba(11,138,131,0.3);transition:all 0.2s;}
        .btn-submit:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(11,138,131,0.4);}
        @media(max-width:768px){.nav-links,.nav-right{display:none;}.hamburger{display:flex;}.grid-2,.session-grid{grid-template-columns:1fr;}.form-card{padding:24px 20px;}}
    </style>
</head>
<body>
<header class="navbar" id="navbar">
    <div class="nav-inner">
        <a href="${pageContext.request.contextPath}/home" class="nav-brand">
            <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div><span>MMS</span>
        </a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Utama</a>
            <a href="${pageContext.request.contextPath}/bookings" class="active">Tempahan</a>
            <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
            <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
            <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
        </nav>
        <div class="nav-right">
            <div class="nav-user">
                <div class="user-avatar">${currentUser.name.substring(0,1).toUpperCase()}</div>
                <span class="user-name">${currentUser.name}</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fa-solid fa-power-off"></i> <span>Keluar</span></a>
        </div>
        <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
    </div>
    <div class="mobile-nav" id="mobileNav">
        <a href="${pageContext.request.contextPath}/home">Utama</a>
        <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
        <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
        <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
        <a href="${pageContext.request.contextPath}/logout" class="mobile-logout"><i class="fa-solid fa-power-off"></i> Keluar</a>
    </div>
</header>

<div class="page-header">
    <div class="page-header-content">
        <div class="page-header-icon"><i class="fa-solid fa-calendar-plus"></i></div>
        <h1>Borang Tempahan Fasiliti</h1>
        <p>Lengkapkan maklumat untuk permohonan tempahan fasiliti masjid</p>
    </div>
</div>

<main class="main-content">
    <div class="alert-info">
        <i class="fa-solid fa-circle-info" style="margin-top:2px;flex-shrink:0;"></i>
        <div>
            <strong>Syarat Penting:</strong><br>
            • Permohonan mesti dibuat <strong>sekurang-kurangnya 3 hari</strong> sebelum tarikh mula<br>
            • Bayaran hanya boleh dibuat selepas permohonan <strong>diluluskan</strong> oleh Koordinator<br>
            • Diskaun <strong>20%</strong> untuk tempahan 3 hari atau lebih
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
    </c:if>

    <div class="form-card">
        <div class="user-bar">
            <div class="user-bar-avatar">${currentUser.name.substring(0,1).toUpperCase()}</div>
            <div><p>${currentUser.name}</p><small>${currentUser.email} • ${currentUser.phone}</small></div>
        </div>

        <form action="${pageContext.request.contextPath}/booking/save" method="post">

            <div class="section-label"><i class="fa-solid fa-mosque"></i> Maklumat Fasiliti</div>
            <div class="form-group">
                <label>Pilih Fasiliti *</label>
                <select name="facilityId" id="facilitySelect" required onchange="updatePrice()">
                    <option value="">-- Sila Pilih Fasiliti --</option>
                    <c:forEach var="f" items="${facilities}">
                        <option value="${f.facilityId}" data-full="${f.ratePerDay}" data-half="${f.halfDayRate}">
                            ${f.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="section-label"><i class="fa-solid fa-clock"></i> Jenis Sesi</div>
            <div class="session-grid">
                <div>
                    <input type="radio" name="sessionType" id="fullDay" value="FULL_DAY" class="session-option" checked onchange="updatePrice()">
                    <label for="fullDay" class="session-label">
                        <i class="fa-solid fa-sun"></i>
                        <strong>Sehari Penuh</strong>
                        <span id="fullDayPrice">Pilih fasiliti dulu</span>
                    </label>
                </div>
                <div>
                    <input type="radio" name="sessionType" id="halfDay" value="HALF_DAY" class="session-option" onchange="updatePrice()">
                    <label for="halfDay" class="session-label">
                        <i class="fa-solid fa-cloud-sun"></i>
                        <strong>Separuh Hari</strong>
                        <span id="halfDayPrice">Pilih fasiliti dulu</span>
                    </label>
                </div>
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label>Masa Mula</label>
                    <input type="time" name="startTime">
                </div>
                <div class="form-group">
                    <label>Masa Tamat</label>
                    <input type="time" name="endTime">
                </div>
            </div>

            <div class="section-label"><i class="fa-solid fa-calendar"></i> Tarikh</div>
            <div class="grid-2">
                <div class="form-group">
                    <label>Tarikh Mula * <small style="color:#ef4444;font-weight:normal;">(Min 3 hari dari hari ini)</small></label>
                    <input type="date" name="startDate" id="startDate" min="${minDate}" required onchange="updateEndMin(); updatePrice();">
                </div>
                <div class="form-group">
                    <label>Tarikh Tamat *</label>
                    <input type="date" name="endDate" id="endDate" min="${minDate}" required onchange="updatePrice()">
                </div>
            </div>

            <div class="section-label"><i class="fa-solid fa-file-lines"></i> Maklumat Pemohon</div>
            <div class="form-group">
                <label>Tujuan Tempahan *</label>
                <select name="bookingType" required>
                    <option value="">-- Sila Pilih Tujuan --</option>
                    <option value="Kenduri">Kenduri / Walimatulurus</option>
                    <option value="Majlis Ilmu">Majlis Ilmu / Ceramah</option>
                    <option value="Mesyuarat">Mesyuarat</option>
                    <option value="Sukan">Sukan / Riadah</option>
                    <option value="Lain-lain">Lain-lain</option>
                </select>
            </div>
            <div class="form-group">
                <label>Alamat Penuh *</label>
                <input type="text" name="address" placeholder="Masukkan alamat penuh anda" required>
            </div>

            <!-- Price preview -->
            <div class="price-box" id="priceBox" style="display:none;">
                <div>
                    <div class="label">Anggaran Jumlah Bayaran</div>
                    <div class="note" id="priceNote"></div>
                </div>
                <div class="amount" id="priceAmount">RM 0.00</div>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fa-solid fa-paper-plane"></i> Hantar Permohonan
            </button>
        </form>
    </div>
</main>

<script>
    window.addEventListener('scroll',()=>{document.getElementById('navbar').classList.toggle('scrolled',window.scrollY>10);});
    document.getElementById('hamburger').addEventListener('click',function(){this.classList.toggle('open');document.getElementById('mobileNav').classList.toggle('open');});

    function updateEndMin() {
        const startVal = document.getElementById('startDate').value;
        if (startVal) document.getElementById('endDate').min = startVal;
    }

    function updatePrice() {
        const sel = document.getElementById('facilitySelect');
        const opt = sel.options[sel.selectedIndex];
        const fullRate = parseFloat(opt.getAttribute('data-full')) || 0;
        const halfRate = parseFloat(opt.getAttribute('data-half')) || (fullRate / 2);
        const isHalf = document.getElementById('halfDay').checked;
        const startVal = document.getElementById('startDate').value;
        const endVal = document.getElementById('endDate').value;

        document.getElementById('fullDayPrice').textContent = fullRate > 0 ? 'RM ' + fullRate.toFixed(0) + '/hari' : '—';
        document.getElementById('halfDayPrice').textContent = halfRate > 0 ? 'RM ' + halfRate.toFixed(0) + '/hari' : '—';

        if (!startVal || !endVal || !sel.value) { document.getElementById('priceBox').style.display = 'none'; return; }

        const start = new Date(startVal), end = new Date(endVal);
        if (end < start) return;

        const days = Math.round((end - start) / 86400000) + 1;
        const rate = isHalf ? halfRate : fullRate;
        let total = rate * days;
        let note = days + ' hari × RM ' + rate.toFixed(0);

        if (days >= 3) {
            total *= 0.80;
            note += ' — Diskaun 20% dikenakan 🎉';
        }

        document.getElementById('priceAmount').textContent = 'RM ' + total.toFixed(2);
        document.getElementById('priceNote').textContent = note;
        document.getElementById('priceBox').style.display = 'flex';
    }
</script>
</body>
</html>
