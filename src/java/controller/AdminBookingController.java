package controller;

import dao.BookingDAO;
import dao.DonationDAO;
import dao.EventDAO;
import model.Booking;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminBookingController", urlPatterns = {
    "/admin/bookings", "/admin/booking/updateStatus", "/admin/report"
})
public class AdminBookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private DonationDAO donationDAO;
    private EventDAO eventDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        donationDAO = new DonationDAO();
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null || !"COORDINATOR".equalsIgnoreCase(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        try {
            if ("/admin/bookings".equals(path)) {
                // Redirect ke report page (satu page sekarang)
                resp.sendRedirect(req.getContextPath() + "/admin/report");
            } else if ("/admin/report".equals(path)) {
                loadDashboard(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null || !"COORDINATOR".equalsIgnoreCase(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if ("/admin/booking/updateStatus".equals(req.getServletPath())) {
            handleUpdateStatus(req, resp);
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            String status = req.getParameter("status");
            bookingDAO.updateStatus(bookingId, status);
            resp.sendRedirect(req.getContextPath() + "/admin/report");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void loadDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {

        // ===== ALL DATA dari database =====
        List<Booking> allBookings = bookingDAO.getAll();

        // Stats
        req.setAttribute("allBookings", allBookings);
        req.setAttribute("totalBookings", allBookings.size());
        req.setAttribute("pendingBookings", bookingDAO.countByStatus("PENDING"));
        req.setAttribute("approvedBookings", bookingDAO.countByStatus("APPROVED"));
        req.setAttribute("rejectedBookings", bookingDAO.countByStatus("REJECTED"));
        req.setAttribute("totalRevenue", bookingDAO.getTotalRevenue());
        req.setAttribute("monthRevenue", bookingDAO.getMonthRevenue());

        // Activity stats
        req.setAttribute("allEvents", eventDAO.getAllEvents());
        req.setAttribute("totalEvents", eventDAO.getAllEvents().size());
        req.setAttribute("pendingEvents", eventDAO.countPending());
        req.setAttribute("approvedEvents", eventDAO.countApproved());

        // Donation data (view only untuk coordinator)
        req.setAttribute("allDonations", donationDAO.getAllDonations());
        req.setAttribute("totalDonation", donationDAO.getTotalAmount());
        req.setAttribute("totalDonationRecords", donationDAO.getTotalRecords());

        // ===== CHART DATA =====
        Map<String, Integer> bookingByMonth = bookingDAO.getBookingCountByMonth();
        Map<String, Double> revenueByMonth = bookingDAO.getRevenueByMonth();
        Map<String, Object> donByMonthRaw = new java.util.LinkedHashMap<>();

        // Convert donation map to compatible format
        Map<String, java.math.BigDecimal> donByMonth = donationDAO.getAmountByMonth();

        req.setAttribute("bookingMonthLabels", toJson(bookingByMonth.keySet().toArray()));
        req.setAttribute("bookingMonthData", toJson(bookingByMonth.values().toArray()));
        req.setAttribute("revenueMonthLabels", toJson(revenueByMonth.keySet().toArray()));
        req.setAttribute("revenueMonthData", toJson(revenueByMonth.values().toArray()));
        req.setAttribute("donMonthLabels", toJson(donByMonth.keySet().toArray()));
        req.setAttribute("donMonthData", toJson(donByMonth.values().toArray()));

        // Pie status data
        req.setAttribute("statusData", "["
                + bookingDAO.countByStatus("PENDING") + ","
                + bookingDAO.countByStatus("APPROVED") + ","
                + bookingDAO.countByStatus("REJECTED") + ","
                + bookingDAO.countByStatus("CANCELED") + "]");

        // ===== FILTER by date (optional) =====
        String startParam = req.getParameter("startDate");
        String endParam = req.getParameter("endDate");
        if (startParam != null && !startParam.isEmpty() && endParam != null && !endParam.isEmpty()) {
            LocalDate start = LocalDate.parse(startParam);
            LocalDate end = LocalDate.parse(endParam);
            List<Booking> filtered = bookingDAO.getReportByDate(start, end);
            double filteredRev = filtered.stream().mapToDouble(Booking::getTotalAmount).sum();
            req.setAttribute("filteredBookings", filtered);
            req.setAttribute("filteredRevenue", filteredRev);
            req.setAttribute("startDate", startParam);
            req.setAttribute("endDate", endParam);
        }

        req.getRequestDispatcher("/admin_report.jsp").forward(req, resp);
    }

    // Convert array to JSON string  ["a","b"] or [1,2,3]
    private String toJson(Object[] arr) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] instanceof String) {
                sb.append("\"").append(arr[i].toString().replace("\"", "\\\"")).append("\"");
            } else {
                sb.append(arr[i]);
            }
            if (i < arr.length - 1) {
                sb.append(",");
            }
        }
        return sb.append("]").toString();
    }
}
