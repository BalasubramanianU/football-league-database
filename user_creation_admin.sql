-- Create the 'app_admin' user
CREATE USER app_admin IDENTIFIED BY Team17dmddproject#;

-- Grant CONNECT privilege to allow the user to connect to the database
GRANT CONNECT TO app_admin;

-- Grant RESOURCE privilege to allow the creation of session, table, view, etc.
GRANT RESOURCE TO app_admin;

-- Grant Table space privilege
GRANT UNLIMITED TABLESPACE TO app_admin;

-- Additionally, grant specific privileges needed for operations
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, ALTER ANY TABLE, DROP ANY TABLE, 
INSERT ANY TABLE, UPDATE ANY TABLE, SELECT ANY TABLE, DELETE ANY TABLE, CREATE ANY INDEX, 
DROP ANY INDEX, ALTER ANY INDEX TO app_admin;

-- Create the 'app_analyst' user
CREATE USER app_analyst IDENTIFIED BY Dmddprojectuser1#;
GRANT CREATE SESSION TO app_analyst;

-- Create the 'revenue_manager' user
CREATE USER revenue_manager IDENTIFIED BY Dmddprojectuser2#;
GRANT CREATE SESSION TO revenue_manager;
