CREATE USER 'username'@'localhost' IDENTIFIED WITH mysql_native_password BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
