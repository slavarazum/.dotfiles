CREATE USER 'valet'@'localhost' IDENTIFIED WITH mysql_native_password BY 'secret';
GRANT ALL PRIVILEGES ON *.* TO 'valet'@'localhost';
FLUSH PRIVILEGES;
