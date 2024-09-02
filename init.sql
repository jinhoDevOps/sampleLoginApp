CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, email) VALUES
('admin', 'password', 'admin@example.com'),
('alice_williams', 'pass123', 'alice@example.com'),
('bob_johnson', 'secret', 'bob@example.com'),
('charlie_smith', 'secure', 'charlie@example.com'),
('diana_brown', 'p@ssw0rd', 'diana@example.com'),
('edward_davis', 'secretcode654','edward@example.com');