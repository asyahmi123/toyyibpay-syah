# S70632 Masjid Management System

## Running (NetBeans / Tomcat)

1. Open the project folder in NetBeans.
2. Configure your MySQL database and update `src/java/util/DBConnection.java` if needed.
3. Run the project on Tomcat.

## ToyyibPay configuration

This project supports overriding ToyyibPay settings via environment variables:

- `TOYYIBPAY_SECRET_KEY`
- `TOYYIBPAY_CAT_BOOKING`
- `TOYYIBPAY_CAT_DONATION`
- `TOYYIBPAY_BASE_URL` (default `https://toyyibpay.com/`)
- `MMS_PUBLIC_BASE_URL` (your public base URL, e.g. current ngrok URL)

Note: Avoid committing real payment secrets to GitHub (prefer a private repo, and/or store secrets outside source code).

