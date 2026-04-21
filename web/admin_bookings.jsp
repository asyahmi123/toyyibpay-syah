<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ms">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - MMS</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/admin_bookings.css">
    </head>
    <body>

        <header class="top-bar">
            <div class="logo">
                <div class="logo-circle"><i class="fa-solid fa-mosque"></i></div>
                <span>MMS ADMIN</span>
            </div>
            <nav>
                <span class="admin-badge" style="background:red; color:white; padding:2px 5px; border-radius:4px; font-size:10px;">ADMIN</span>
                <a href="${pageContext.request.contextPath}/admin/bookings" class="active">Tempahan</a>
                <a href="${pageContext.request.contextPath}/admin/report">Laporan</a> 
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fa-solid fa-power-off"></i> Keluar</a>
            </nav>
        </header>

        <main class="admin-container">
            <div class="admin-header">
                <div class="header-text">
                    <h1>Dashboard Koordinator</h1>
                    <p>Senarai permohonan tempahan fasiliti masjid.</p>
                </div>
            </div>

            <div class="table-card">
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th width="5%">ID</th>
                                <th width="20%">Pemohon</th>
                                <th width="20%">Fasiliti (Tempat)</th> <th width="20%">Tarikh</th>
                                <th width="10%">Jumlah</th>
                                <th width="10%">Status</th>
                                <th width="15%" style="text-align: center;">Tindakan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${bookings}">
                                <tr>
                                    <td><span style="font-weight:bold;">#${b.bookingId}</span></td>

                                    <td>
                                        <div style="font-weight:600; color:#111827;">${b.userName != null ? b.userName : 'Unknown'}</div>
                                        <div style="font-size:12px; color:#6b7280;">ID User: #${b.userId}</div>
                                    </td>

                                    <td style="font-weight:600; color:#0369a1;">${b.facilityName}</td>

                                    <td>
                                        <div>Mula: ${b.startDate}</div>
                                        <div>Tamat: ${b.endDate}</div>
                                    </td>

                                    <td style="font-weight: 500;">RM ${b.totalAmount}</td>

                                    <td>
                                        <span style="padding: 3px 8px; border-radius: 10px; font-size: 11px; font-weight: bold; 
                                            background: ${b.status == 'APPROVED' ? '#dcfce7' : (b.status == 'REJECTED' ? '#fee2e2' : '#fef9c3')}; 
                                            color: ${b.status == 'APPROVED' ? '#166534' : (b.status == 'REJECTED' ? '#991b1b' : '#854d0e')};">
                                            ${b.status}
                                        </span>
                                    </td>

                                    <td style="text-align: center;">
                                        <c:if test="${b.status == 'PENDING'}">
                                            <div style="display:flex; gap:5px; justify-content:center;">
                                                <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <input type="hidden" name="status" value="APPROVED">
                                                    <button type="submit" style="background:none; border:none; cursor:pointer; color:green; font-size:18px;" title="Luluskan">
                                                        <i class="fa-solid fa-check-circle"></i>
                                                    </button>
                                                </form>

                                                <form action="${pageContext.request.contextPath}/admin/booking/updateStatus" method="post">
                                                    <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                    <input type="hidden" name="status" value="REJECTED">
                                                    <button type="submit" style="background:none; border:none; cursor:pointer; color:red; font-size:18px;" title="Tolak">
                                                        <i class="fa-solid fa-circle-xmark"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <c:if test="${b.status != 'PENDING'}">
                                            <span style="color:gray; font-size:12px;">Selesai</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty bookings}">
                                <tr>
                                    <td colspan="7" style="text-align:center; padding:20px;">Tiada permohonan.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </body>
</html>