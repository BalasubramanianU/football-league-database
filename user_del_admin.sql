-- Revoke privileges granted to app_admin
REVOKE CREATE SESSION, CREATE TABLE, CREATE VIEW, ALTER ANY TABLE, DROP ANY TABLE, 
INSERT ANY TABLE, UPDATE ANY TABLE, SELECT ANY TABLE, DELETE ANY TABLE, CREATE ANY INDEX, 
DROP ANY INDEX, ALTER ANY INDEX FROM app_admin;

-- Drop the app_admin user
DROP USER app_admin CASCADE;

-- Drop the analyst user
DROP USER app_analyst CASCADE;

-- Drop the customer_access user
DROP USER revenue_manager CASCADE;
