-- MySQL Initialization
USE nifi_demo;

CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    city VARCHAR(100),
    country VARCHAR(100) DEFAULT 'China',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_updated (updated_at)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50) NOT NULL UNIQUE,
    product_name VARCHAR(255),
    category VARCHAR(100),
    price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_updated (updated_at)
);

-- Insert sample data
INSERT INTO customers (customer_id, first_name, last_name, email, city) VALUES
('CUST001', 'Wei', 'Zhang', 'wei.zhang@example.com', 'Shanghai'),
('CUST002', 'Na', 'Li', 'na.li@example.com', 'Beijing'),
('CUST003', 'Fang', 'Wang', 'fang.wang@example.com', 'Guangzhou'),
('CUST004', 'Yang', 'Liu', 'yang.liu@example.com', 'Shenzhen'),
('CUST005', 'Jie', 'Chen', 'jie.chen@example.com', 'Hangzhou');

INSERT INTO products (product_id, product_name, category, price, stock_quantity) VALUES
('PROD001', 'Laptop Pro 15', 'Electronics', 8999.00, 100),
('PROD002', 'Wireless Mouse', 'Electronics', 199.00, 500),
('PROD003', 'USB-C Hub', 'Electronics', 299.00, 300),
('PROD004', 'Mechanical Keyboard', 'Electronics', 599.00, 200),
('PROD005', 'Monitor 27"', 'Electronics', 2499.00, 80);

GRANT SELECT ON nifi_demo.* TO 'nifi_user'@'%';
