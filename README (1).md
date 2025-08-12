# CRM Database Management System

## 📌 Project Overview
This project implements a **Customer Relationship Management (CRM) Database** in **MySQL**.
It is designed to manage customers, leads, opportunities, sales, sales teams, and tasks while providing insights through **views, triggers, procedures, and reports**.

The database supports **sales tracking, lead management, pipeline forecasting, and performance analysis** for sales teams.

---

## 🚀 Features

### **Database Structure**
- **Countries & States** – Stores geographical data for customers.
- **Customers** – Stores client information and contact details.
- **Sales Team** – Records details of managers and salespersons.
- **Leads** – Tracks potential clients with sources and status.
- **Opportunities** – Stores potential deals, expected revenue, probability, and closing date.
- **Sales** – Records successful deals and revenue.
- **Tasks** – Assigns and tracks activities for leads.

### **Constraints & Validations**
- Unique constraints on emails.
- Phone number format validation using `CHECK` and regex.
- Foreign key relationships with `ON DELETE` rules.
- Probability and revenue checks to ensure valid values.

---

## ⚙️ Advanced SQL Implementations

### **Indexes**
- `idx_customer_email` – Fast lookup for customers.
- `idx_lead_status` – Quick filtering of leads by status.
- `idx_sales_date` – Efficient sales date queries.
- `idx_opportunity_status` – Easy tracking of opportunity stages.

### **Triggers**
- **`trg_update_lead_status`** – Updates lead status when a sale is recorded.
- **`trg_mark_overdue_tasks`** – Marks pending tasks as overdue when past due date.
- **`trg_auto_insert_sale`** – Automatically inserts a sale when an opportunity is marked as 'Won'.
- **`trg_prevent_salesperson_delete`** – Prevents deleting salespeople with active opportunities.

### **Views**
- **`vw_monthly_revenue`** – Monthly total sales revenue.
- **`vw_salesperson_performance`** – Ranks salespeople by revenue.
- **`vw_revenue_by_source`** – Revenue grouped by lead source.
- **`vw_pipeline_value`** – Current open deal values per salesperson.

### **Stored Procedure**
- **`sp_add_new_lead`** – Adds a new customer and their lead in one call.

---

## 📊 Example Reports
- **Monthly sales performance by salesperson**
- **Top 5 customers by revenue**
- **Pipeline value by salesperson**
- **Win rate (%) by salesperson**
- **Overdue tasks list**
- **Status breakdown (Won/Lost) with percentage**
- **Average deal size per salesperson**

---

## 🛠️ Technologies Used
- **Database**: MySQL 8+
- **Language**: SQL (DDL, DML, DCL, TCL)
- **Indexes**: B-Tree indexing for performance
- **Constraints**: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`
- **Procedures & Triggers**: For automation and data integrity

---

## 📂 Installation & Setup
1. **Clone this repository**
```bash
git clone https://github.com/yourusername/crm-database.git
```
2. **Open MySQL Workbench / CLI**

3. **Run the SQL script**
```sql
SOURCE crm_database.sql;
```

4. **Verify tables**
```sql
SHOW TABLES;
```

---

## 📈 Usage Examples

**1. Get monthly sales revenue:**
```sql
SELECT * FROM vw_monthly_revenue;
```

**2. Add a new lead using stored procedure:**
```sql
CALL sp_add_new_lead('Tom', 'Harris', 'tom@example.com', '9876543210', 2, 'Referral', 'New', 'Interested in automation software');
```

**3. View top customers by revenue:**
```sql
SELECT c.first_name, c.last_name, SUM(s.amount) AS revenue
FROM sales s
JOIN opportunities o ON s.opportunity_id = o.opportunity_id
JOIN leads l ON o.lead_id = l.lead_id
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY revenue DESC
LIMIT 5;
```

---

## 📜 License
This project is open-source and free to use for learning and development purposes.
