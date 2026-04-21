<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="currentUser" scope="session" type="model.User" />
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Aktiviti Masjid - MMS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root{
                --green:#0b8a83;
                --green-dark:#056d67;
                --grad:linear-gradient(135deg,#0b8a83,#056d67);
                --green-light:#e6f7f6;
                --gold:#f59e0b;
                --text:#1f2937;
                --mid:#4b5563;
                --light:#9ca3af;
                --bg:#f3f4f6;
                --white:#fff;
                --border:#e5e7eb;
            }
            *{
                box-sizing:border-box;
                margin:0;
                padding:0;
            }
            body{
                font-family:'Poppins',sans-serif;
                background:var(--bg);
                color:var(--text);
            }
            /* NAVBAR */
            .navbar{
                position:sticky;
                top:0;
                z-index:200;
                background:rgba(255,255,255,.95);
                backdrop-filter:blur(20px);
                border-bottom:1px solid var(--border);
                box-shadow:0 2px 12px rgba(0,0,0,.05);
            }
            .nav-inner{
                max-width:1280px;
                margin:0 auto;
                padding:0 5%;
                height:66px;
                display:flex;
                align-items:center;
                gap:24px;
            }
            .nav-brand{
                display:flex;
                align-items:center;
                gap:10px;
                text-decoration:none;
                font-weight:800;
                font-size:19px;
                color:var(--green);
                flex-shrink:0;
            }
            .nav-logo{
                width:36px;
                height:36px;
                background:var(--grad);
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:16px;
                box-shadow:0 4px 12px rgba(11,138,131,.3);
            }
            .nav-links{
                display:flex;
                align-items:center;
                gap:4px;
                flex:1;
            }
            .nav-links a{
                padding:7px 13px;
                border-radius:8px;
                font-size:13.5px;
                font-weight:500;
                color:var(--mid);
                text-decoration:none;
                transition:all .2s;
            }
            .nav-links a:hover,.nav-links a.active{
                color:var(--green);
                background:var(--green-light);
                font-weight:600;
            }
            .nav-right{
                display:flex;
                align-items:center;
                gap:12px;
                flex-shrink:0;
            }
            .nav-user{
                display:flex;
                align-items:center;
                gap:9px;
            }
            .user-av{
                width:34px;
                height:34px;
                background:var(--grad);
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:13px;
                font-weight:700;
            }
            .user-nm{
                font-size:13px;
                font-weight:600;
                color:var(--text);
                max-width:120px;
                overflow:hidden;
                text-overflow:ellipsis;
                white-space:nowrap;
            }
            .btn-out{
                display:flex;
                align-items:center;
                gap:7px;
                padding:8px 14px;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                color:#ef4444;
                text-decoration:none;
                border:1.5px solid #fee2e2;
                background:#fff5f5;
                transition:all .2s;
            }
            .btn-out:hover{
                background:#fecaca;
            }
            .hamburger{
                display:none;
                flex-direction:column;
                gap:5px;
                background:none;
                border:none;
                cursor:pointer;
                padding:4px;
                margin-left:auto;
            }
            .hamburger span{
                display:block;
                width:22px;
                height:2px;
                background:var(--text);
                border-radius:2px;
                transition:all .3s;
            }
            .hamburger.open span:nth-child(1){
                transform:rotate(45deg) translate(5px,5px);
            }
            .hamburger.open span:nth-child(2){
                opacity:0;
            }
            .hamburger.open span:nth-child(3){
                transform:rotate(-45deg) translate(5px,-5px);
            }
            .mob-nav{
                display:none;
                flex-direction:column;
                padding:8px 5% 16px;
                border-top:1px solid var(--border);
                background:#fff;
                gap:2px;
            }
            .mob-nav.open{
                display:flex;
            }
            .mob-nav a{
                padding:10px 14px;
                border-radius:8px;
                font-size:14px;
                font-weight:500;
                color:var(--mid);
                text-decoration:none;
            }
            .mob-nav a:hover{
                background:var(--green-light);
                color:var(--green);
            }
            .mob-out{
                color:#ef4444!important;
                margin-top:6px;
            }
            /* PAGE HEADER */
            .ph{
                background:var(--grad);
                padding:44px 5% 52px;
                text-align:center;
                position:relative;
                overflow:hidden;
            }
            .ph::before{
                content:'';
                position:absolute;
                inset:0;
                background-image:radial-gradient(rgba(255,255,255,.07) 1px,transparent 1px);
                background-size:24px 24px;
            }
            .orb{
                position:absolute;
                border-radius:50%;
                filter:blur(60px);
                pointer-events:none;
            }
            .o1{
                width:300px;
                height:300px;
                background:rgba(255,255,255,.08);
                top:-80px;
                right:-60px;
            }
            .o2{
                width:200px;
                height:200px;
                background:rgba(5,109,103,.5);
                bottom:-60px;
                left:5%;
            }
            .ph-content{
                position:relative;
                z-index:2;
            }
            .ph-icon{
                width:58px;
                height:58px;
                background:rgba(255,255,255,.15);
                border-radius:16px;
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:24px;
                margin:0 auto 14px;
                border:1.5px solid rgba(255,255,255,.2);
            }
            .ph h1{
                font-size:clamp(1.6rem,3vw,2.1rem);
                font-weight:800;
                color:#fff;
                margin-bottom:6px;
            }
            .ph p{
                font-size:14px;
                color:rgba(255,255,255,.8);
            }
            /* MAIN */
            .main{
                max-width:1200px;
                margin:-26px auto 60px;
                padding:0 5%;
                position:relative;
                z-index:3;
            }
            /* ALERTS */
            .alert{
                padding:14px 18px;
                border-radius:12px;
                margin-bottom:20px;
                display:flex;
                align-items:center;
                gap:10px;
                font-size:14px;
                font-weight:500;
                animation:fadeUp .4s ease;
            }
            .a-ok{
                background:#d1fae5;
                color:#065f46;
                border:1px solid #6ee7b7;
            }
            .a-err{
                background:#fef2f2;
                color:#991b1b;
                border:1px solid #fca5a5;
            }
            .a-info{
                background:#fef3c7;
                color:#92400e;
                border:1px solid #fde68a;
            }
            @keyframes fadeUp{
                from{
                    opacity:0;
                    transform:translateY(10px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }
            /* STATS */
            .stats{
                display:flex;
                gap:14px;
                flex-wrap:wrap;
                margin-bottom:22px;
            }
            .s-card{
                flex:1;
                min-width:130px;
                background:#fff;
                border-radius:14px;
                padding:16px 18px;
                border:1px solid var(--border);
                box-shadow:0 2px 8px rgba(0,0,0,.05);
                display:flex;
                align-items:center;
                gap:12px;
            }
            .s-ic{
                width:40px;
                height:40px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:16px;
                flex-shrink:0;
            }
            .s-card b{
                display:block;
                font-size:20px;
                font-weight:800;
                color:var(--text);
            }
            .s-card span{
                font-size:11px;
                color:var(--light);
            }
            /* SECTION TITLE */
            .sec-title{
                font-size:16px;
                font-weight:700;
                color:var(--text);
                display:flex;
                align-items:center;
                gap:9px;
                margin-bottom:18px;
                margin-top:28px;
            }
            .sec-title i{
                color:var(--green);
            }
            .sec-title .cnt{
                font-size:12px;
                color:var(--light);
                background:var(--bg);
                padding:3px 10px;
                border-radius:20px;
                border:1px solid var(--border);
                margin-left:auto;
            }
            /* EVENT GRID */
            .ev-grid{
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(290px,1fr));
                gap:18px;
                margin-bottom:24px;
            }
            /* EVENT CARD */
            .ev-card{
                background:#fff;
                border-radius:16px;
                border:1.5px solid var(--border);
                overflow:hidden;
                transition:all .3s;
                box-shadow:0 2px 8px rgba(0,0,0,.05);
                display:flex;
                flex-direction:column;
            }
            .ev-card:hover{
                transform:translateY(-4px);
                box-shadow:0 14px 36px rgba(0,0,0,.1);
                border-color:var(--green);
            }
            .ev-card-top{
                padding:18px 18px 0;
            }
            .ev-row{
                display:flex;
                align-items:center;
                justify-content:space-between;
                margin-bottom:12px;
            }
            .badge{
                padding:4px 10px;
                border-radius:20px;
                font-size:11px;
                font-weight:700;
            }
            .b-up{
                background:var(--green-light);
                color:var(--green-dark);
            }
            .b-on{
                background:#fef3c7;
                color:#92400e;
            }
            .b-done{
                background:#f3f4f6;
                color:#6b7280;
            }
            .b-pend{
                background:#eff6ff;
                color:#1e40af;
            }
            .b-rej{
                background:#fef2f2;
                color:#991b1b;
            }
            .ev-icon{
                width:40px;
                height:40px;
                border-radius:10px;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:18px;
            }
            .ic-up{
                background:var(--green-light);
                color:var(--green);
            }
            .ic-on{
                background:#fef3c7;
                color:#d97706;
            }
            .ic-done{
                background:#f3f4f6;
                color:#6b7280;
            }
            .ic-pend{
                background:#eff6ff;
                color:#1e40af;
            }
            .ev-name{
                font-size:15px;
                font-weight:700;
                color:var(--text);
                margin-bottom:9px;
            }
            .ev-meta{
                display:flex;
                flex-direction:column;
                gap:5px;
                margin-bottom:12px;
            }
            .ev-meta-row{
                display:flex;
                align-items:center;
                gap:8px;
                font-size:12px;
                color:var(--mid);
            }
            .ev-meta-row i{
                color:var(--green);
                width:14px;
                text-align:center;
                font-size:11px;
            }
            .ev-desc{
                font-size:12.5px;
                color:var(--light);
                line-height:1.6;
                padding:0 18px 14px;
                flex:1;
            }
            .ev-actions{
                display:flex;
                gap:7px;
                padding:12px 18px;
                border-top:1px solid #f3f4f6;
                background:#fafafa;
            }
            .btn-act{
                flex:1;
                padding:7px;
                border-radius:7px;
                font-size:12px;
                font-weight:600;
                border:none;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:5px;
                transition:all .2s;
            }
            .btn-ed{
                background:#dbeafe;
                color:#1e40af;
            }
            .btn-ed:hover{
                background:#bfdbfe;
            }
            .btn-del{
                background:#fee2e2;
                color:#991b1b;
            }
            .btn-del:hover{
                background:#fecaca;
            }
            /* EMPTY */
            .empty{
                text-align:center;
                padding:48px 20px;
                background:#fff;
                border-radius:16px;
                border:1px solid var(--border);
            }
            .empty i{
                font-size:46px;
                color:var(--light);
                margin-bottom:12px;
                display:block;
                opacity:.4;
            }
            .empty p{
                font-size:14px;
                color:var(--light);
            }
            /* REQUEST FORM */
            .req-card{
                background:#fff;
                border-radius:18px;
                padding:22px 26px;
                border:1px solid var(--border);
                box-shadow:0 4px 16px rgba(0,0,0,.05);
                margin-bottom:24px;
            }
            .req-card-title{
                font-size:14px;
                font-weight:700;
                color:var(--text);
                margin-bottom:16px;
                display:flex;
                align-items:center;
                gap:8px;
                padding-bottom:12px;
                border-bottom:1px solid var(--border);
            }
            .req-card-title i{
                color:var(--green);
            }
            .fg{
                margin-bottom:14px;
            }
            .fg label{
                display:block;
                font-size:12px;
                font-weight:600;
                color:var(--mid);
                margin-bottom:5px;
            }
            .fg input,.fg textarea,.fg select{
                width:100%;
                padding:9px 12px;
                border-radius:8px;
                border:1.5px solid var(--border);
                font-size:13px;
                font-family:'Poppins',sans-serif;
                background:#f9fafb;
                color:var(--text);
                transition:all .2s;
            }
            .fg input:focus,.fg textarea:focus{
                outline:none;
                border-color:var(--green);
                background:#fff;
                box-shadow:0 0 0 3px rgba(11,138,131,.1);
            }
            .fg textarea{
                resize:vertical;
                min-height:65px;
            }
            .fg.full{
                grid-column:1/-1;
            }
            .fg-grid{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(170px,1fr));
                gap:12px;
            }
            .btn-req{
                padding:10px 20px;
                background:var(--grad);
                color:#fff;
                border:none;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
                display:flex;
                align-items:center;
                gap:7px;
                transition:all .2s;
                margin-top:6px;
            }
            .btn-req:hover{
                transform:translateY(-1px);
                box-shadow:0 4px 12px rgba(11,138,131,.3);
            }
            /* MODAL */
            .modal-ov{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.5);
                z-index:999;
                align-items:center;
                justify-content:center;
                padding:20px;
            }
            .modal-ov.open{
                display:flex;
            }
            .modal{
                background:#fff;
                border-radius:18px;
                padding:26px;
                width:100%;
                max-width:500px;
                box-shadow:0 20px 60px rgba(0,0,0,.2);
                max-height:90vh;
                overflow-y:auto;
            }
            .modal-title{
                font-size:15px;
                font-weight:700;
                color:var(--text);
                margin-bottom:18px;
                display:flex;
                align-items:center;
                gap:8px;
                padding-bottom:12px;
                border-bottom:1px solid var(--border);
            }
            .modal-title i{
                color:var(--green);
            }
            .modal-acts{
                display:flex;
                gap:10px;
                margin-top:18px;
                justify-content:flex-end;
            }
            .btn-cl{
                padding:9px 18px;
                background:#f3f4f6;
                color:var(--mid);
                border:none;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
            }
            .btn-sv{
                padding:9px 18px;
                background:var(--grad);
                color:#fff;
                border:none;
                border-radius:8px;
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:'Poppins',sans-serif;
                display:flex;
                align-items:center;
                gap:6px;
            }
            @media(max-width:768px){
                .nav-links,.nav-right{
                    display:none;
                }
                .hamburger{
                    display:flex;
                }
                .ev-grid{
                    grid-template-columns:1fr;
                }
                .stats{
                    gap:10px;
                }
            }
        </style>
    </head>
    <body>
        <!-- NAVBAR -->
        <header class="navbar" id="navbar">
            <div class="nav-inner">
                <a href="${pageContext.request.contextPath}/home" class="nav-brand">
                    <div class="nav-logo"><i class="fa-solid fa-mosque"></i></div><span>MMS</span>
                </a>
                <nav class="nav-links">
                    <a href="${pageContext.request.contextPath}/home">Utama</a>
                    <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                    <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                    <a href="${pageContext.request.contextPath}/activity" class="active">Aktiviti</a>
                    <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                </nav>
                <div class="nav-right">
                    <div class="nav-user">
                        <div class="user-av">${currentUser.name.substring(0,1).toUpperCase()}</div>
                        <span class="user-nm">${currentUser.name}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-out"><i class="fa-solid fa-power-off"></i> <span>Keluar</span></a>
                </div>
                <button class="hamburger" id="hamburger"><span></span><span></span><span></span></button>
            </div>
            <div class="mob-nav" id="mobNav">
                <a href="${pageContext.request.contextPath}/home">Utama</a>
                <a href="${pageContext.request.contextPath}/bookings">Tempahan</a>
                <a href="${pageContext.request.contextPath}/profile.jsp">Profil AJK</a>
                <a href="${pageContext.request.contextPath}/activity">Aktiviti</a>
                <a href="${pageContext.request.contextPath}/donation.jsp">Sumbangan</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Hubungi</a>
                <a href="${pageContext.request.contextPath}/logout" class="mob-out"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </div>
        </header>

        <!-- PAGE HEADER -->
        <div class="ph">
            <div class="orb o1"></div><div class="orb o2"></div>
            <div class="ph-content">
                <div class="ph-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <h1>Aktiviti Masjid</h1>
                <p>Jadual program & aktiviti komuniti masjid</p>
            </div>
        </div>

        <!-- MAIN -->
        <main class="main">

            <!-- ALERTS -->
            <c:if test="${not empty success}"><div class="alert a-ok"><i class="fa-solid fa-circle-check"></i> ${success}</div></c:if>
            <c:if test="${not empty error}"><div class="alert a-err"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div></c:if>
            <c:if test="${param.msg == 'deleted'}"><div class="alert a-info"><i class="fa-solid fa-trash"></i> Permohonan aktiviti telah dipadamkan.</div></c:if>

                <!-- STATS -->
                <div class="stats">
                    <div class="s-card">
                        <div class="s-ic" style="background:#e6f7f6;color:#0b8a83;"><i class="fa-solid fa-calendar-check"></i></div>
                        <div><b>${countUpcoming}</b><span>Aktiviti Akan Datang</span></div>
                </div>
                <div class="s-card">
                    <div class="s-ic" style="background:#d1fae5;color:#065f46;"><i class="fa-solid fa-list-check"></i></div>
                    <div><b>${approvedEvents.size()}</b><span>Jumlah Aktiviti</span></div>
                </div>
                <div class="s-card">
                    <div class="s-ic" style="background:#eff6ff;color:#2563eb;"><i class="fa-solid fa-paper-plane"></i></div>
                    <div><b>${myEvents.size()}</b><span>Permohonan Saya</span></div>
                </div>
            </div>

            <!-- ===== SENARAI AKTIVITI YANG DILULUSKAN ===== -->
            <div class="sec-title">
                <i class="fa-solid fa-list-check"></i> Senarai Aktiviti Masjid
                <span class="cnt">${approvedEvents.size()} aktiviti</span>
            </div>

            <c:choose>
                <c:when test="${empty approvedEvents}">
                    <div class="empty" style="margin-bottom:24px;">
                        <i class="fa-solid fa-calendar-xmark"></i>
                        <p>Belum ada aktiviti yang dijadualkan.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ev-grid">
                        <c:forEach items="${approvedEvents}" var="ev">
                            <div class="ev-card">
                                <div class="ev-card-top">
                                    <div class="ev-row">
                                        <c:choose>
                                            <c:when test="${ev.status=='ONGOING'}">
                                                <span class="badge b-on"><i class="fa-solid fa-circle" style="font-size:7px;"></i> Berlangsung</span>
                                                <div class="ev-icon ic-on"><i class="fa-solid fa-spinner"></i></div>
                                                </c:when>
                                                <c:when test="${ev.status=='COMPLETED'}">
                                                <span class="badge b-done"><i class="fa-solid fa-circle" style="font-size:7px;"></i> Selesai</span>
                                                <div class="ev-icon ic-done"><i class="fa-solid fa-circle-check"></i></div>
                                                </c:when>
                                                <c:otherwise>
                                                <span class="badge b-up"><i class="fa-solid fa-circle" style="font-size:7px;"></i> Akan Datang</span>
                                                <div class="ev-icon ic-up"><i class="fa-solid fa-calendar-days"></i></div>
                                                </c:otherwise>
                                            </c:choose>
                                    </div>
                                    <div class="ev-name">${ev.name}</div>
                                    <div class="ev-meta">
                                        <div class="ev-meta-row"><i class="fa-solid fa-calendar"></i><span>${ev.date}</span></div>
                                                <c:if test="${ev.time != null}">
                                            <div class="ev-meta-row"><i class="fa-regular fa-clock"></i><span>${ev.time}</span></div>
                                                </c:if>
                                                <c:if test="${not empty ev.location}">
                                            <div class="ev-meta-row"><i class="fa-solid fa-location-dot"></i><span>${ev.location}</span></div>
                                                </c:if>
                                    </div>
                                </div>
                                <c:if test="${not empty ev.description}">
                                    <p class="ev-desc">${ev.description}</p>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- ===== BORANG MOHON AKTIVITI ===== -->
            <div class="sec-title"><i class="fa-solid fa-paper-plane"></i> Mohon Aktiviti Baharu</div>

            <div class="req-card">
                <div class="req-card-title">
                    <i class="fa-solid fa-circle-info"></i>
                    Isi borang untuk memohon aktiviti. Permohonan akan disemak oleh Koordinator (min. 3 hari sebelum tarikh).
                </div>
                <form action="${pageContext.request.contextPath}/activity" method="post">
                    <input type="hidden" name="action" value="request">
                    <div class="fg-grid">
                        <div class="fg">
                            <label>Nama Aktiviti *</label>
                            <input type="text" name="name" placeholder="Contoh: Majlis Ilmu" required>
                        </div>
                        <div class="fg">
                            <label>Tarikh * <small style="color:#ef4444;">(Min 3 hari dari hari ini)</small></label>
                            <input type="date" name="date" min="${minDate}" required>
                        </div>
                        <div class="fg">
                            <label>Masa</label>
                            <input type="time" name="time">
                        </div>
                        <div class="fg">
                            <label>Lokasi</label>
                            <input type="text" name="location" placeholder="Contoh: Dewan Solat Utama">
                        </div>
                        <div class="fg full">
                            <label>Penerangan</label>
                            <textarea name="description" placeholder="Huraian ringkas aktiviti..."></textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn-req"><i class="fa-solid fa-paper-plane"></i> Hantar Permohonan</button>
                </form>
            </div>

            <!-- ===== PERMOHONAN SAYA ===== -->
            <div class="sec-title">
                <i class="fa-solid fa-user-clock"></i> Permohonan Saya
                <span class="cnt">${myEvents.size()} permohonan</span>
            </div>

            <c:choose>
                <c:when test="${empty myEvents}">
                    <div class="empty">
                        <i class="fa-solid fa-inbox"></i>
                        <p>Anda belum membuat sebarang permohonan aktiviti.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ev-grid">
                        <c:forEach items="${myEvents}" var="ev">
                            <div class="ev-card">
                                <div class="ev-card-top">
                                    <div class="ev-row">
                                        <c:choose>
                                            <c:when test="${ev.requestStatus=='PENDING_APPROVAL'}">
                                                <span class="badge b-pend"><i class="fa-solid fa-hourglass-half" style="font-size:9px;"></i> Menunggu Kelulusan</span>
                                                <div class="ev-icon ic-pend"><i class="fa-solid fa-clock"></i></div>
                                                </c:when>
                                                <c:when test="${ev.requestStatus=='APPROVED'}">
                                                <span class="badge b-up"><i class="fa-solid fa-circle-check" style="font-size:9px;"></i> Diluluskan</span>
                                                <div class="ev-icon ic-up"><i class="fa-solid fa-calendar-check"></i></div>
                                                </c:when>
                                                <c:otherwise>
                                                <span class="badge b-rej"><i class="fa-solid fa-circle-xmark" style="font-size:9px;"></i> Ditolak</span>
                                                <div class="ev-icon ic-done"><i class="fa-solid fa-circle-xmark"></i></div>
                                                </c:otherwise>
                                            </c:choose>
                                    </div>
                                    <div class="ev-name">${ev.name}</div>
                                    <div class="ev-meta">
                                        <div class="ev-meta-row"><i class="fa-solid fa-calendar"></i><span>${ev.date}</span></div>
                                                <c:if test="${ev.time != null}">
                                            <div class="ev-meta-row"><i class="fa-regular fa-clock"></i><span>${ev.time}</span></div>
                                                </c:if>
                                                <c:if test="${not empty ev.location}">
                                            <div class="ev-meta-row"><i class="fa-solid fa-location-dot"></i><span>${ev.location}</span></div>
                                                </c:if>
                                    </div>
                                </div>
                                <c:if test="${not empty ev.description}">
                                    <p class="ev-desc">${ev.description}</p>
                                </c:if>
                                <%-- User boleh edit/delete permohonan yg PENDING atau REJECTED sahaja --%>
                                <c:if test="${ev.requestStatus == 'PENDING_APPROVAL' || ev.requestStatus == 'REJECTED'}">
                                    <div class="ev-actions">
                                        <button class="btn-act btn-ed"
                                                onclick="openEdit(${ev.eventId}, '${ev.name}', '${ev.date}', '${ev.time != null ? ev.time : ''}', '${ev.location}', '${ev.description}')">
                                            <i class="fa-solid fa-pen"></i> Edit
                                        </button>
                                        <form action="${pageContext.request.contextPath}/activity" method="post" style="flex:1;" onsubmit="return confirm('Padam permohonan ini?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="event_id" value="${ev.eventId}">
                                            <button type="submit" class="btn-act btn-del" style="width:100%;"><i class="fa-solid fa-trash"></i> Padam</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </main>

        <!-- MODAL EDIT (untuk permohonan user sendiri) -->
        <div class="modal-ov" id="editModal">
            <div class="modal">
                <div class="modal-title"><i class="fa-solid fa-pen"></i> Kemaskini Permohonan</div>
                <form action="${pageContext.request.contextPath}/activity" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="event_id" id="editId">
                    <div class="fg-grid">
                        <div class="fg">
                            <label>Nama Aktiviti *</label>
                            <input type="text" name="name" id="editName" required>
                        </div>
                        <div class="fg">
                            <label>Tarikh * <small style="color:#ef4444;">(Min 3 hari)</small></label>
                            <input type="date" name="date" id="editDate" min="${minDate}" required>
                        </div>
                        <div class="fg">
                            <label>Masa</label>
                            <input type="time" name="time" id="editTime">
                        </div>
                        <div class="fg">
                            <label>Lokasi</label>
                            <input type="text" name="location" id="editLoc">
                        </div>
                        <div class="fg full">
                            <label>Penerangan</label>
                            <textarea name="description" id="editDesc"></textarea>
                        </div>
                    </div>
                    <div class="modal-acts">
                        <button type="button" class="btn-cl" onclick="closeEdit()">Batal</button>
                        <button type="submit" class="btn-sv"><i class="fa-solid fa-floppy-disk"></i> Simpan</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            window.addEventListener('scroll', () => document.getElementById('navbar').classList.toggle('scrolled', scrollY > 10));
            document.getElementById('hamburger').addEventListener('click', function () {
                this.classList.toggle('open');
                document.getElementById('mobNav').classList.toggle('open');
            });

            function openEdit(id, name, date, time, loc, desc) {
                document.getElementById('editId').value = id;
                document.getElementById('editName').value = name;
                document.getElementById('editDate').value = date;
                document.getElementById('editTime').value = time;
                document.getElementById('editLoc').value = loc;
                document.getElementById('editDesc').value = desc;
                document.getElementById('editModal').classList.add('open');
            }
            function closeEdit() {
                document.getElementById('editModal').classList.remove('open');
            }
            document.getElementById('editModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeEdit();
            });
        </script>
    </body>
</html>
