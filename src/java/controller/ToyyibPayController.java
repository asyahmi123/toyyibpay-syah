package controller;

import dao.BookingDAO;
import model.Booking;
import util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "ToyyibPayController", urlPatterns = {"/payment/createBill", "/payment/return"})
public class ToyyibPayController extends HttpServlet {

    // ===== CREDENTIALS (LIVE/BIRU) =====
    private static final String SECRET_KEY   = getEnvOrDefault("TOYYIBPAY_SECRET_KEY", "");
    private static final String CAT_BOOKING  = getEnvOrDefault("TOYYIBPAY_CAT_BOOKING", "nrp9me01");
    private static final String CAT_DONATION = getEnvOrDefault("TOYYIBPAY_CAT_DONATION", "d6hgyn2q");

    // PENTING: Menggunakan URL Live kerana dashboard anda berwarna biru
    private static final String TOYYIBPAY_URL = normalizeBaseUrl(getEnvOrDefault("TOYYIBPAY_BASE_URL", "https://toyyibpay.com/"));

    // ===== NGROK URL =====
    // Kemaskini link ngrok baru di sini setiap kali anda restart ngrok
    private static final String NGROK_URL = "https://reactor-gush-overboard.ngrok-free.dev";

    private static final String APP_CONTEXT = "/S70632_Masjid_Management_System";

    private BookingDAO bookingDAO;

    @Override
    public void init() { bookingDAO = new BookingDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/payment/return".equals(path)) {
            handleReturn(req, resp);
            return;
        }
        if ("/payment/createBill".equals(path)) {
            handleCreateBill(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/payment/return".equals(path)) {
            handleReturn(req, resp);
            return;
        }
        if ("/payment/createBill".equals(path)) {
            handleCreateBill(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void handleCreateBill(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingIdParam  = req.getParameter("bookingId");
        String donationIdParam = req.getParameter("donationId");
        String amountParam     = req.getParameter("amount");
        String donorName       = req.getParameter("donorName");
        String donorEmail      = req.getParameter("donorEmail");
        String donorPhone      = req.getParameter("donorPhone");

        if (donationIdParam != null && !donationIdParam.isEmpty()) {
            handleDonationBill(req, resp, donationIdParam, amountParam, donorName, donorEmail, donorPhone);
            return;
        }

        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/bookings");
            return;
        }

        handleBookingBill(req, resp, Integer.parseInt(bookingIdParam));
    }

    // ===== BOOKING PAYMENT =====
    private void handleBookingBill(HttpServletRequest req, HttpServletResponse resp, int bookingId)
            throws IOException, ServletException {
        try {
            Booking booking = bookingDAO.getById(bookingId);

            if (booking == null || !"APPROVED".equalsIgnoreCase(booking.getStatus())) {
                req.getSession().setAttribute("payError", "Tempahan belum diluluskan.");
                resp.sendRedirect(req.getContextPath() + "/bookings");
                return;
            }

            long amountSen   = Math.round(booking.getTotalAmount() * 100);
            String returnUrl = buildReturnUrl("booking", bookingId);

            System.out.println("=== ToyyibPay Booking ===");
            System.out.println("Booking ID  : " + bookingId);
            System.out.println("API URL     : " + TOYYIBPAY_URL + "index.php/api/createBill");

            String billCode = createBill(
                CAT_BOOKING,
                "Tempahan Masjid #" + bookingId,
                "Bayaran bagi " + (booking.getFacilityName() != null ? booking.getFacilityName() : "Fasiliti"),
                amountSen, returnUrl, "MMS-B-" + bookingId,
                booking.getEmail()    != null ? booking.getEmail()    : "",
                booking.getPhone()    != null ? booking.getPhone()    : "",
                booking.getUserName() != null ? booking.getUserName() : "Pengguna"
            );

            System.out.println("BillCode Received: " + billCode);

            if (billCode != null && !billCode.isEmpty()) {
                savePaymentRecord(bookingId, booking.getTotalAmount(), billCode);
                
                // PEMBETULAN: Menggunakan path runBill yang betul untuk melompat ke bank
                String redirectUrl = TOYYIBPAY_URL + "index.php/api/runBill/" + billCode;
                System.out.println("Redirecting to: " + redirectUrl);
                resp.sendRedirect(redirectUrl);
            } else {
                req.setAttribute("booking", booking);
                req.setAttribute("simMode", true);
                req.getRequestDispatcher("/payment.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            System.out.println("ToyyibPay error: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/bookings");
        }
    }

    // ===== DONATION PAYMENT =====
    private void handleDonationBill(HttpServletRequest req, HttpServletResponse resp,
                                     String donationIdParam, String amountParam,
                                     String donorName, String donorEmail, String donorPhone)
            throws IOException, ServletException {
        try {
            if (amountParam == null || amountParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/donation");
                return;
            }

            double amount     = Double.parseDouble(amountParam);
            int    donationId = Integer.parseInt(donationIdParam);
            long   amountSen  = Math.round(amount * 100);
            String returnUrl  = buildReturnUrl("donation", donationId);

            String billCode = createBill(
                CAT_DONATION,
                "Sumbangan Masjid #" + donationId,
                "Sumbangan kepada masjid",
                amountSen, returnUrl, "MMS-D-" + donationId,
                donorEmail != null ? donorEmail : "",
                donorPhone != null ? donorPhone : "",
                donorName  != null ? donorName  : "Penderma"
            );

            if (billCode != null && !billCode.isEmpty()) {
                // PEMBETULAN: Menggunakan path runBill yang betul
                resp.sendRedirect(TOYYIBPAY_URL + "index.php/api/runBill/" + billCode);
            } else {
                req.setAttribute("simMode", true);
                req.getRequestDispatcher("/payment.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            System.out.println("Donation error: " + e.getMessage());
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        }
    }

    // ===== CALL TOYYIBPAY API =====
    private String createBill(String categoryCode, String billName, String billDesc,
                               long amountSen, String returnUrl, String refNo,
                               String email, String phone, String toName) throws IOException {

        if (SECRET_KEY == null || SECRET_KEY.trim().isEmpty()) {
            System.out.println("ToyyibPay config missing: TOYYIBPAY_SECRET_KEY");
            return null;
        }

        URL url = new URL(TOYYIBPAY_URL + "index.php/api/createBill");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String safeName = billName.length() > 30 ? billName.substring(0, 30) : billName;

        String data = "userSecretKey="   + URLEncoder.encode(SECRET_KEY,   "UTF-8")
            + "&categoryCode="           + URLEncoder.encode(categoryCode,  "UTF-8")
            + "&billName="               + URLEncoder.encode(safeName,      "UTF-8")
            + "&billDescription="        + URLEncoder.encode(billDesc,      "UTF-8")
            + "&billPriceSetting=1"
            + "&billPayorInfo=1"
            + "&billAmount="             + amountSen
            + "&billReturnUrl="          + URLEncoder.encode(returnUrl,     "UTF-8")
            + "&billCallbackUrl="        + URLEncoder.encode(returnUrl,     "UTF-8")
            + "&billExternalReferenceNo=" + URLEncoder.encode(refNo,        "UTF-8")
            + "&billTo="                 + URLEncoder.encode(toName,        "UTF-8")
            + "&billEmail="              + URLEncoder.encode(email,         "UTF-8")
            + "&billPhone="              + URLEncoder.encode(phone,         "UTF-8")
            + "&billSplitPayment=0"
            + "&billPaymentChannel=0";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(data.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode >= 200 && responseCode < 300)
                ? conn.getInputStream() : conn.getErrorStream();

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) response.append(line);
        }

        System.out.println("ToyyibPay HTTP Status: " + responseCode);
        System.out.println("ToyyibPay Response: " + response);
        return parseBillCode(response.toString());
    }

    private void handleReturn(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String statusId = req.getParameter("status_id");
        String billCode = req.getParameter("billcode");
        String refNo    = req.getParameter("order_id");

        boolean success = "1".equals(statusId);

        if (success && refNo != null && refNo.startsWith("MMS-B-")) {
            try {
                int bookingId = Integer.parseInt(refNo.replace("MMS-B-", ""));
                updatePaymentStatus(bookingId, "SUCCESS");
            } catch (Exception e) {
                System.out.println("Status update error: " + e.getMessage());
            }
        }

        req.setAttribute("paySuccess", success);
        req.setAttribute("billCode",   billCode);
        req.setAttribute("refNo",      refNo);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }

    private String buildReturnUrl(String type, int id) {
        return getPublicBaseUrl() + APP_CONTEXT + "/payment/return?type=" + type + "&id=" + id;
    }

    private static String getPublicBaseUrl() {
        String env = System.getenv("MMS_PUBLIC_BASE_URL");
        if (env == null) {
            return NGROK_URL;
        }
        String trimmed = env.trim();
        if (trimmed.isEmpty()) {
            return NGROK_URL;
        }
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed.isEmpty() ? NGROK_URL : trimmed;
    }

    private static String getEnvOrDefault(String name, String fallback) {
        String value = System.getenv(name);
        if (value == null) {
            return fallback;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? fallback : trimmed;
    }

    private static String normalizeBaseUrl(String url) {
        String trimmed = url == null ? "" : url.trim();
        if (trimmed.isEmpty()) {
            return "";
        }
        return trimmed.endsWith("/") ? trimmed : (trimmed + "/");
    }

    private void savePaymentRecord(int bookingId, double amount, String billCode) throws SQLException {
        String sql = "INSERT INTO payment (booking_id, amount, method, status, bill_code, gateway) "
                   + "VALUES (?,?,?,?,?,?) "
                   + "ON DUPLICATE KEY UPDATE bill_code=VALUES(bill_code), status='PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId); ps.setDouble(2, amount);
            ps.setString(3, "TOYYIBPAY"); ps.setString(4, "PENDING");
            ps.setString(5, billCode); ps.setString(6, "TOYYIBPAY");
            ps.executeUpdate();
        }
    }

    private void updatePaymentStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE payment SET status=?, paid_at=NOW() WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }

    private String parseBillCode(String json) {
        try {
            if (json == null || json.trim().isEmpty()) return null;
            int idx = json.indexOf("BillCode");
            if (idx == -1) return null;
            int colon = json.indexOf(":", idx);
            int q1    = json.indexOf("\"", colon + 1);
            int q2    = json.indexOf("\"", q1 + 1);
            return json.substring(q1 + 1, q2).trim();
        } catch (Exception e) {
            return null;
        }
    }
}
