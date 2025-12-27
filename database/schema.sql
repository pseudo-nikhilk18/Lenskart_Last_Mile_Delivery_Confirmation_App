-- Database Schema

CREATE DATABASE IF NOT EXISTS last_mile_delivery;
USE last_mile_delivery;

-- table
CREATE TABLE IF NOT EXISTS shipments (
    id INT AUTO_INCREMENT PRIMARY KEY,

    shipment_id VARCHAR(50) NOT NULL UNIQUE COMMENT 'Public tracking ID used by delivery agent',

    customer_name VARCHAR(100) NOT NULL COMMENT 'Customer name',
    
    otp_code VARCHAR(10) NOT NULL COMMENT 'Pre-generated OTP for verification',
    
    status ENUM('Pending', 'In-Transit', 'Delivered') NOT NULL DEFAULT 'Pending' COMMENT 'Current delivery status',
    
    delivered_at TIMESTAMP NULL DEFAULT NULL COMMENT 'Timestamp when delivery was confirmed (NULL until delivered)',
    
    delivered_by VARCHAR(100) NULL DEFAULT NULL COMMENT 'Name/ID of the delivery agent who marked delivery',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Record creation timestamp',
    
    INDEX idx_shipment_id (shipment_id)
    
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores shipment records and delivery confirmation data';

