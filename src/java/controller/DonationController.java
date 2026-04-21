package controller;

import dao.DonationDAO;
import model.Donation;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;

// Controller untuk user buat sumbangan
// GET  /donation  -> tunjuk form sumbangan
// POST /donation  -> proses sumbangan
//   - Kalau payment_method = "Tunai" atau "Pindahan Bank" -> simpan terus dalam DB
//   - Kalau payment_method = "QR Code" / "Online"        -> redirect ke ToyyibPay
@WebServlet(name = "DonationController", urlPatterns = {"/donation"})
public class DonationController extends HttpServlet {

    private DonationDAO donationDAO;

    @Override
    public void init() {
        donationDAO = new DonationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/donation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        String donorName = req.getParameter("donor_name");
        String amountStr = req.getParameter("amount");
        String donationType = req.getParameter("donation_type");
        String paymentMethod = req.getParameter("payment_method");
        String notes = req.getParameter("notes");

        // ── Validate ──────────────────────────────────────────────
        if (donorName == null || donorName.trim().isEmpty()
                || amountStr == null || amountStr.trim().isEmpty()
                || donationType == null || donationType.trim().isEmpty()) {
            req.setAttribute("error", "Sila isi semua maklumat yang diperlukan.");
            req.getRequestDispatcher("/donation.jsp").forward(req, resp);
            return;
        }

        BigDecimal amount;
        try {
            amount = new BigDecimal(amountStr);
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                req.setAttribute("error", "Jumlah sumbangan mestilah lebih dari RM 0.");
                req.getRequestDispatcher("/donation.jsp").forward(req, resp);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Jumlah tidak sah. Sila masukkan nombor sahaja.");
            req.getRequestDispatcher("/donation.jsp").forward(req, resp);
            return;
        }

        if (paymentMethod == null || paymentMethod.isEmpty()) {
            paymentMethod = "Tunai";
        }

        // ── Simpan rekod donation dalam DB dulu (semua method) ────
        Donation d = new Donation();
        d.setUserId(currentUser.getUserId());
        d.setDonorName(donorName.trim());
        d.setAmount(amount);
        d.setDonationType(donationType.trim());
        d.setPaymentMethod(paymentMethod);
        d.setDate(new Date(System.currentTimeMillis()));
        d.setNotes(notes != null ? notes.trim() : "");

        int donationId = donationDAO.addDonationReturnId(d);

        if (donationId <= 0) {
            req.setAttribute("error", "Maaf, berlaku masalah semasa merekod sumbangan. Sila cuba lagi.");
            req.getRequestDispatcher("/donation.jsp").forward(req, resp);
            return;
        }

        // ── Pilih aliran pembayaran ────────────────────────────────
        boolean isOnlinePayment = "QR Code".equals(paymentMethod)
                || "Online".equals(paymentMethod)
                || "Kad Kredit/Debit".equals(paymentMethod);

        if (isOnlinePayment) {
            // Redirect ke ToyyibPay — hantar semua info yang diperlukan
            String email = currentUser.getEmail() != null ? currentUser.getEmail() : "";
            String phone = currentUser.getPhone() != null ? currentUser.getPhone() : "";
            String url = req.getContextPath() + "/payment/createBill"
                    + "?donationId=" + donationId
                    + "&amount=" + amount.toPlainString()
                    + "&donorName=" + java.net.URLEncoder.encode(donorName.trim(), "UTF-8")
                    + "&donorEmail=" + java.net.URLEncoder.encode(email, "UTF-8")
                    + "&donorPhone=" + java.net.URLEncoder.encode(phone, "UTF-8");

            // Simpan mesej dalam session supaya boleh tunjuk selepas return dari ToyyibPay
            session.setAttribute("pendingDonation", "RM " + amount + " — " + donationType);
            resp.sendRedirect(url);
        } else {
            // Tunai / Pindahan Bank — selesai terus
            req.setAttribute("success", "Terima kasih! Sumbangan RM " + amount
                    + " anda telah berjaya direkodkan. Semoga Allah memberkati.");
            req.getRequestDispatcher("/donation.jsp").forward(req, resp);
        }
    }
}
