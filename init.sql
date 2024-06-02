CREATE DATABASE IF NOT EXISTS testdb;
USE testdb;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO users (name, email) VALUES ('Max rim', 'max.rim@example.com');
INSERT INTO users (name, email) VALUES ('Nik rim', 'nik.rim@example.com');
