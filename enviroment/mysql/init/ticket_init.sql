CREATE DATABASE IF NOT EXISTS vetautet
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- 1. ticket table
CREATE TABLE IF NOT EXISTS `vetautet`.`ticket` (
                                                   `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `name` VARCHAR(50) NOT NULL COMMENT 'Ticket name',
    `desc` TEXT COMMENT 'Ticket description',
    `start_time` DATETIME NOT NULL COMMENT 'Ticket sale start time',
    `end_time` DATETIME NOT NULL COMMENT 'Ticket sale end time',
    `status` INT(11) NOT NULL DEFAULT 0 COMMENT 'Ticket sale activity status', -- 0: deactive, 1: activity
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Last update time',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    PRIMARY KEY (`id`),
    KEY `idx_end_time` (`end_time`), -- Very high query runtime
    KEY `idx_start_time` (`start_time`), -- Very high query runtime
    KEY `idx_status` (`status`) -- Very high query runtime
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'ticket table';

-- 2. ticket detail (item) table
CREATE TABLE IF NOT EXISTS `vetautet`.`ticket_item` (
                                                        `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Primary key',
    `name` VARCHAR(50) NOT NULL COMMENT 'Ticket title',
    `description` TEXT COMMENT 'Ticket description',
    `stock_initial` INT(11) NOT NULL DEFAULT 0 COMMENT 'Initial stock quantity (e.g., 1000 tickets)',
    `stock_available` INT(11) NOT NULL DEFAULT 0 COMMENT 'Current available stock (e.g., 900 tickets)',
    `is_stock_prepared` BOOLEAN NOT NULL DEFAULT 0 COMMENT 'Indicates if stock is pre-warmed (0/1)', -- warm up cache
    `price_original` BIGINT(20) NOT NULL COMMENT 'Original ticket price', -- Giá gốc: ví dụ 100k/ticket
    `price_flash` BIGINT(20) NOT NULL COMMENT 'Discounted price during flash sale', -- Giảm giá khung giờ vàng
    `sale_start_time` DATETIME NOT NULL COMMENT 'Flash sale start time',
    `sale_end_time` DATETIME NOT NULL COMMENT 'Flash sale end time',
    `status` INT(11) NOT NULL DEFAULT 0 COMMENT 'Ticket status (e.g., active/inactive)', -- Trạng thái của vé (ví dụ: 0/1)
    `activity_id` BIGINT(20) NOT NULL COMMENT 'ID of associated activity', -- ID của hoạt động liên quan đến vé
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of the last update',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    PRIMARY KEY (`id`),
    KEY `idx_end_time` (`sale_end_time`),
    KEY `idx_start_time` (`sale_start_time`),
    KEY `idx_status` (`status`)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Table for ticket details';

-- INSERT MOCK DATA

-- Insert data into `ticket` table
INSERT INTO `vetautet`.`ticket` (`name`, `desc`, `start_time`, `end_time`, `status`, `updated_at`, `created_at`)
VALUES
    ('Đợt Mở Bán Vé Ngày 12/12', 'Sự kiện mở bán vé đặc biệt cho ngày 12/12', '2024-12-12 00:00:00', NULL, 1, DEFAULT, DEFAULT),
    ('Đợt Mở Bán Vé Ngày 01/01', 'Sự kiện mở bán vé cho ngày đầu năm mới 01/01', '2025-01-01 00:00:00', NULL, 1, DEFAULT, DEFAULT);

-- Insert data into `ticket_item` table corresponding to each event in `ticket` table
INSERT INTO `vetautet`.`ticket_item` (`name`, `description`, `stock_initial`, `stock_available`, `is_stock_prepared`, `price_original`, `price_flash`, `sale_start_time`, `sale_end_time`, `status`, `activity_id`, `updated_at`, `created_at`)
VALUES
    -- Ticket items for the 12/12 event
    ('Vé Sự Kiện 12/12 – Hạng Phổ Thông', 'Vé phổ thông cho sự kiện ngày 12/12', 1000, 1000, 1, 100000, 80000, '2024-12-12 08:00:00', '2024-12-12 10:00:00', 1, 1, DEFAULT, DEFAULT),
    ('Vé Sự Kiện 12/12 – Hạng VIP', 'Vé VIP cho sự kiện ngày 12/12', 500, 500, 1, 200000, 150000, '2024-12-12 08:00:00', '2024-12-12 10:00:00', 1, 1, DEFAULT, DEFAULT),
    -- Ticket items for the 01/01 event
    ('Vé Sự Kiện 01/01 – Hạng Phổ Thông', 'Vé phổ thông cho sự kiện ngày 01/01', 2000, 2000, 1, 120000, 90000, '2025-01-01 09:00:00', '2025-01-01 11:00:00', 1, 2, DEFAULT, DEFAULT),
    ('Vé Sự Kiện 01/01 – Hạng VIP', 'Vé VIP cho sự kiện ngày 01/01', 1000, 1000, 1, 250000, 180000, '2025-01-01 09:00:00', '2025-01-01 11:00:00', 1, 2, DEFAULT, DEFAULT);
