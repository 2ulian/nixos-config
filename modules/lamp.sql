-- create user maria
DROP USER IF EXISTS 'maria'@'localhost';
CREATE USER 'maria'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON monsite.* TO 'maria'@'localhost';
FLUSH PRIVILEGES;

--create database monsite
CREATE DATABASE monsite CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON monsite.* TO 'maria'@'localhost';
FLUSH PRIVILEGES;
EXIT;
