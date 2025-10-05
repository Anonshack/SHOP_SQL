# Online Shop SQL Project

## Description
This project is a **fully-featured online shop database** implemented purely with **SQL**.  
It covers all essential functionalities for an e-commerce platform, including:

- **Users**: Registration, passwords (hashed), and constraints.
- **Products & Categories**: Product catalog with categories, prices, discounts.
- **Orders & Order Items**: Users can place multiple orders with multiple products per order.
- **Payments**: Automatic payment records and status tracking.
- **Status Tracking**: Orders and payments can have different statuses (paid, pending, shipped, etc.).
- **Triggers & Functions**:  
  - Log product price changes automatically.  
  - Calculate total order amount.  
  - Apply discounts for VIP users.  
  - Ensure transactional consistency (ROLLBACK if any part fails).
- **Analytics Queries**:  
  - Top users by total orders and spending.  
  - Most sold products.  
  - Revenue comparison before and after discounts.  

This project is **SQL-only**, suitable for practicing **PostgreSQL**, writing **stored procedures**, **triggers**, and **complex queries** for an e-commerce backend.

---

## Setup Instructions

1. **Install Docker & Docker Compose** (optional for easy setup).  
2. Clone the repository:
```bash
git clone https://github.com/Anonshack/SHOP_SQL.git
cd SHOP_SQL