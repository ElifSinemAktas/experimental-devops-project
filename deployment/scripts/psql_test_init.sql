CREATE DATABASE us_test_db;
CREATE USER us_test_user WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE us_test_db TO us_test_user;
\c us_test_db
GRANT ALL PRIVILEGES ON SCHEMA public TO us_test_user;