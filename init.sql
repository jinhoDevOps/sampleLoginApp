CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, email) VALUES
('admin', 'password', 'admin@example.com'),
('john_doe', 'pass123', 'john@example.com'),
('jane_smith', 'secret', 'jane@example.com'),
('bob_johnson', 'secure', 'bob@example.com'),
('alice_williams', 'p@ssw0rd', 'alice@example.com');