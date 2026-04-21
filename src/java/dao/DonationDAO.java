package dao;

import model.Donation;
import util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DonationDAO {

    // ===== Tambah donation dan return boolean =====
    public boolean addDonation(Donation d) {
        return addDonationReturnId(d) > 0;
    }

    // ===== Tambah donation dan return ID baru (untuk ToyyibPay redirect) =====
    public int addDonationReturnId(Donation d) {
        String sql = "INSERT INTO donation (user_id,donor_name,amount,donation_type,payment_method,date,notes) "
                + "VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, d.getUserId());
            ps.setString(2, d.getDonorName());
            ps.setBigDecimal(3, d.getAmount());
            ps.setString(4, d.getDonationType());
            ps.setString(5, d.getPaymentMethod());
            ps.setDate(6, d.getDate() != null ? d.getDate() : new java.sql.Date(System.currentTimeMillis()));
            ps.setString(7, d.getNotes());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1); // return generated ID
                }
            }
        } catch (SQLException e) {
            System.out.println("addDonationReturnId: " + e.getMessage());
        }
        return -1;
    }

    // ===== Ambil semua donation =====
    public List<Donation> getAllDonations() {
        List<Donation> list = new ArrayList<>();
        String sql = "SELECT * FROM donation ORDER BY date DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Donation d = new Donation();
                d.setDonationId(rs.getInt("donation_id"));
                d.setUserId(rs.getInt("user_id"));
                d.setDonorName(rs.getString("donor_name"));
                d.setAmount(rs.getBigDecimal("amount"));
                d.setDonationType(rs.getString("donation_type"));
                d.setPaymentMethod(rs.getString("payment_method"));
                d.setDate(rs.getDate("date"));
                d.setNotes(rs.getString("notes"));
                list.add(d);
            }
        } catch (SQLException e) {
            System.out.println("getAllDonations: " + e.getMessage());
        }
        return list;
    }

    // ===== Edit donation =====
    public boolean editDonation(int id, String name, BigDecimal amt,
            String type, String method, String notes) {
        String sql = "UPDATE donation SET donor_name=?,amount=?,donation_type=?,payment_method=?,notes=? "
                + "WHERE donation_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setBigDecimal(2, amt);
            ps.setString(3, type);
            ps.setString(4, method);
            ps.setString(5, notes);
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("editDonation: " + e.getMessage());
            return false;
        }
    }

    // ===== Padam donation =====
    public boolean deleteDonation(int id) {
        String sql = "DELETE FROM donation WHERE donation_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteDonation: " + e.getMessage());
            return false;
        }
    }

    // ===== Stats =====
    public BigDecimal getTotalAmount() {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COALESCE(SUM(amount),0) FROM donation")) {
            if (r.next()) {
                BigDecimal t = r.getBigDecimal(1);
                return t != null ? t : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getMonthAmount() {
        String sql = "SELECT COALESCE(SUM(amount),0) FROM donation "
                + "WHERE MONTH(date)=MONTH(NOW()) AND YEAR(date)=YEAR(NOW())";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            if (r.next()) {
                BigDecimal t = r.getBigDecimal(1);
                return t != null ? t : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int getTotalRecords() {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery("SELECT COUNT(*) FROM donation")) {
            if (r.next()) {
                return r.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    // ===== CHART DATA =====
    public Map<String, BigDecimal> getAmountByType() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT COALESCE(donation_type,'Lain-lain') as t, COALESCE(SUM(amount),0) as total "
                + "FROM donation GROUP BY donation_type ORDER BY total DESC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("t"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByType: " + e.getMessage());
        }
        return map;
    }

    public Map<String, BigDecimal> getAmountByMonth() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(date,'%b %Y') as lbl, COALESCE(SUM(amount),0) as total "
                + "FROM donation WHERE date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) "
                + "GROUP BY YEAR(date), MONTH(date), lbl ORDER BY YEAR(date) ASC, MONTH(date) ASC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("lbl"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByMonth: " + e.getMessage());
        }
        return map;
    }

    public Map<String, Integer> getCountByPaymentMethod() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT COALESCE(payment_method,'Lain-lain') as m, COUNT(*) as cnt "
                + "FROM donation GROUP BY payment_method";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("m"), r.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.out.println("getCountByPaymentMethod: " + e.getMessage());
        }
        return map;
    }
}
