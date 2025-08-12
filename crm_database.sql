DROP DATABASE IF EXISTS crm_db;
CREATE DATABASE crm_db;
USE crm_db;

-- Countries and States

CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE states (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE CASCADE,
    UNIQUE(state_name, country_id)
);

-- Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) CHECK (phone REGEXP '^[0-9+()-]{7,20}$'),
    company_name VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(50),
    state_id INT,
    country_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    FOREIGN KEY (state_id) REFERENCES states(state_id) ON DELETE SET NULL,
    FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE SET NULL
);
-- Sales Team
CREATE TABLE sales_team (
    salesperson_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role ENUM('Manager','Salesperson') NOT NULL DEFAULT 'Salesperson',
    join_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Leads
CREATE TABLE leads (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    lead_source ENUM('Website','Referral','Social Media','Email','Cold Call','Other'),
    status ENUM('New','Contacted','Qualified','Lost') DEFAULT 'New',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (salesperson_id) REFERENCES sales_team(salesperson_id) ON DELETE CASCADE
);
-- Opportunities
CREATE TABLE opportunities (
    opportunity_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    expected_revenue DECIMAL(12,2) CHECK (expected_revenue >= 0),
    probability DECIMAL(5,2) CHECK (probability >= 0 AND probability <= 100),
    status ENUM('Open','Won','Lost') DEFAULT 'Open',
    closing_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id) ON DELETE CASCADE,
    FOREIGN KEY (salesperson_id) REFERENCES sales_team(salesperson_id) ON DELETE CASCADE
);
CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    opportunity_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL CHECK (amount>=0),
    sale_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(opportunity_id) ON DELETE CASCADE
);
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    task_description TEXT,
    due_date DATE,
    status ENUM('Pending', 'Completed', 'Overdue') DEFAULT 'Pending',
    priority ENUM('High', 'Medium', 'Low') DEFAULT 'Medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id) ON DELETE CASCADE,
    FOREIGN KEY (salesperson_id) REFERENCES sales_team(salesperson_id) ON DELETE CASCADE
);
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_lead_status ON leads(status);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_opportunity_status ON opportunities(status);

-- Data
INSERT INTO countries (country_name) VALUES 
('USA'), 
('India'),
('Canada');
INSERT INTO states (state_name, country_id) VALUES
('New York', 1), 
('California', 1), 
('Delhi', 2), 
('Karnataka', 2),
('Ontario', 3);
INSERT INTO sales_team (first_name, last_name, email, phone, role, join_date)
VALUES
('Alice', 'Brown', 'alice@example.com', '1112223333', 'Manager', '2023-01-15'),
('Bob', 'White', 'bob@example.com', '4445556666', 'Salesperson', '2023-03-01'),
('Charlie', 'Black', 'charlie@example.com', '7778889999', 'Salesperson', '2023-05-20'),
('David', 'Green', 'david@example.com', '5557779999', 'Salesperson', '2023-07-10');
INSERT INTO customers (first_name, last_name, email, phone, company_name, city, state_id, country_id)
VALUES
('John', 'Doe', 'john@example.com', '1234567890', 'TechCorp', 'New York', 1, 1),
('Jane', 'Smith', 'jane@example.com', '0987654321', 'BizSoft', 'Los Angeles', 2, 1),
('Raj', 'Kumar', 'raj@example.com', '9988776655', 'AgroTech', 'Delhi', 3, 2),
('Priya', 'Mehta', 'priya@example.com', '8877665544', 'HealthPlus', 'Bangalore', 4, 2),
('Michael', 'Scott', 'michael@example.com', '9998887777', 'PaperCo', 'Toronto', 5, 3),
('Sarah', 'Lee', 'sarah@example.com', '7776665555', 'EcoHome', 'San Francisco', 2, 1);
INSERT INTO leads (customer_id, salesperson_id, lead_source, status, notes)
VALUES
(1, 2, 'Website', 'New', 'Interested in cloud solutions'),
(2, 3, 'Referral', 'Contacted', 'Requested price quotation'),
(3, 2, 'Social Media', 'Qualified', 'High potential lead'),
(4, 4, 'Email', 'New', 'Requested a demo for healthcare software'),
(5, 2, 'Website', 'Contacted', 'Follow up in one week'),
(6, 3, 'Cold Call', 'Lost', 'Not interested at the moment'),
(1, 4, 'Referral', 'New', 'Looking for additional services'),
(2, 2, 'Social Media', 'Qualified', 'Budget approved'),
(4, 3, 'Website', 'Contacted', 'Discussed basic package');
INSERT INTO tasks (lead_id, salesperson_id, task_description, due_date, status, priority)
VALUES
(1, 2, 'Call customer to discuss product demo', '2024-08-20', 'Pending', 'High'),
(2, 3, 'Send proposal via email', '2024-08-18', 'Completed', 'Medium'),
(3, 2, 'Prepare presentation for client', '2024-08-25', 'Pending', 'High'),
(4, 4, 'Email healthcare software brochure', '2024-08-22', 'Pending', 'Medium'),
(5, 2, 'Follow up call', '2024-08-28', 'Pending', 'Low'),
(6, 3, 'Send case study PDF', '2024-08-15', 'Completed', 'Low'),
(7, 4, 'Book meeting with client', '2024-08-30', 'Pending', 'High'),
(8, 2, 'Prepare proposal', '2024-09-05', 'Pending', 'High'),
(9, 3, 'Call to confirm interest', '2024-09-10', 'Pending', 'Medium');
INSERT INTO opportunities (lead_id, salesperson_id, expected_revenue, probability, status, closing_date)
VALUES
(3, 2, 15000.00, 75.00, 'Open', '2024-09-15'),
(5, 2, 12000.00, 50.00, 'Open', '2024-09-20'),
(2, 3, 8000.00, 40.00, 'Lost', '2024-08-12'),
(4, 4, 20000.00, 60.00, 'Open', '2024-10-05'),
(8, 2, 25000.00, 80.00, 'Open', '2024-09-28'),
(1, 4, 18000.00, 70.00, 'Won', '2024-08-22'),
(7, 4, 22000.00, 85.00, 'Open', '2024-09-30');
INSERT INTO sales (opportunity_id, amount, sale_date)
VALUES
(1, 15000.00, '2024-09-16'),
(6, 18000.00, '2024-08-23'),
(5, 25000.00, '2024-09-29'),
(4, 20000.00, '2024-10-06'),
(7, 22000.00, '2024-09-30');

DELIMITER $$
CREATE TRIGGER trg_update_lead_status
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    UPDATE leads
    SET status='Qualified'
    WHERE lead_id = (SELECT lead_id FROM opportunities WHERE opportunity_id = NEW.opportunity_id);
END$$
DELIMITER ;
SELECT st.salesperson_id, CONCAT(st.first_name, ' ', st.last_name) AS salesperson,
       SUM(s.amount) AS total_sales, DATE_FORMAT(s.sale_date, '%Y-%m') AS month
FROM sales s
JOIN opportunities o ON s.opportunity_id = o.opportunity_id
JOIN sales_team st ON o.salesperson_id = st.salesperson_id
GROUP BY st.salesperson_id, month;

SELECT c.first_name, c.last_name, SUM(s.amount) AS revenue
FROM sales s
JOIN opportunities o ON s.opportunity_id = o.opportunity_id
JOIN leads l ON o.lead_id = l.lead_id
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY revenue DESC
LIMIT 5;

DELIMITER $$
CREATE TRIGGER trg_mark_overdue_tasks
BEFORE UPDATE ON tasks
FOR EACH ROW
BEGIN
    IF NEW.due_date < CURDATE() AND NEW.status = 'Pending' THEN
        SET NEW.status = 'Overdue';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_auto_insert_sale
AFTER UPDATE ON opportunities
FOR EACH ROW
BEGIN
    IF NEW.status = 'Won' AND OLD.status != 'Won' THEN
        INSERT INTO sales(opportunity_id, amount, sale_date)
        VALUES (NEW.opportunity_id, NEW.expected_revenue, CURDATE());
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_prevent_salesperson_delete
BEFORE DELETE ON sales_team
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM opportunities WHERE salesperson_id = OLD.salesperson_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete salesperson with active opportunities.';
    END IF;
END$$
DELIMITER ;

CREATE VIEW vw_monthly_revenue AS
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month,
       SUM(s.amount) AS total_revenue
FROM sales s
GROUP BY month
ORDER BY month;

CREATE VIEW vw_salesperson_performance AS
SELECT st.salesperson_id,
       CONCAT(st.first_name, ' ', st.last_name) AS salesperson,
       SUM(s.amount) AS total_sales,
       RANK() OVER (ORDER BY SUM(s.amount) DESC) AS rank_position
FROM sales s
JOIN opportunities o ON s.opportunity_id = o.opportunity_id
JOIN sales_team st ON o.salesperson_id = st.salesperson_id
GROUP BY st.salesperson_id;

CREATE VIEW vw_revenue_by_source AS
SELECT l.lead_source,
       SUM(s.amount) AS total_revenue
FROM sales s
JOIN opportunities o ON s.opportunity_id = o.opportunity_id
JOIN leads l ON o.lead_id = l.lead_id
GROUP BY l.lead_source
ORDER BY total_revenue DESC;

CREATE VIEW vw_pipeline_value AS
SELECT st.salesperson_id,
       CONCAT(st.first_name, ' ', st.last_name) AS salesperson,
       SUM(o.expected_revenue) AS pipeline_value
FROM opportunities o
JOIN sales_team st ON o.salesperson_id = st.salesperson_id
WHERE o.status = 'Open'
GROUP BY st.salesperson_id;

SELECT 
    status,
    COUNT(*) AS total,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM opportunities) * 100, 2) AS percentage
FROM opportunities
WHERE status IN ('Won', 'Lost')
GROUP BY status;

DELIMITER $$

CREATE PROCEDURE sp_add_new_lead(
    IN p_first_name  VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_salesperson_id  INT,
    IN p_lead_source VARCHAR(50),
    IN p_status VARCHAR(20),
    IN p_notes TEXT
)
BEGIN
    DECLARE new_customer_id INT;
    INSERT INTO customers (first_name, last_name, email, phone, created_at)
    VALUES (p_first_name, p_last_name, p_email, p_phone, NOW());
    SET new_customer_id = LAST_INSERT_ID();
    INSERT INTO leads (customer_id, salesperson_id, lead_source, status, notes, created_at, updated_at)
    VALUES (new_customer_id, p_salesperson_id, p_lead_source, p_status, p_notes, NOW(), NOW());
END$$
DELIMITER ;

SELECT st.salesperson_id,
       CONCAT(st.first_name, ' ', st.last_name) AS salesperson,
       ROUND(AVG(s.amount), 2) AS avg_deal_size
FROM sales s
JOIN opportunities o ON s.opportunity_id=o.opportunity_id
JOIN sales_team st ON o.salesperson_id = st.salesperson_id
GROUP BY st.salesperson_id
ORDER BY avg_deal_size DESC;

SELECT st.salesperson_id,
       CONCAT(st.first_name, ' ', st.last_name) AS salesperson,
       ROUND(SUM(CASE WHEN o.status = 'Won' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS win_rate
FROM opportunities o
JOIN sales_team st ON o.salesperson_id = st.salesperson_id
GROUP BY st.salesperson_id
ORDER BY win_rate DESC;

SELECT t.task_id, t.task_description, t.due_date,
       CONCAT(st.first_name, ' ', st.last_name) AS assigned_to
FROM tasks t
JOIN sales_team st ON t.salesperson_id = st.salesperson_id
WHERE t.due_date < CURDATE()
  AND t.status != 'Completed'
ORDER BY t.due_date ASC;



