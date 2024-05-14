# Football league management

Steps to setup the database:

1. Download all the mandatory project script files (all the .sql files) for EPL database creation.
2. Firstly, run the `user_creation_admin.sql` script as default `ADMIN` user (DBA).
3. Create a new connection in Oracle SQL Developer, with username as `app_admin` and password as `Team17dmddproject#`
4. After successful `app_admin` user creation, execute the `DDL_DML_VIEWS_GRANTS_app_admin.sql` script as `app_admin` user
5. Once step 4 is executed completely, all the DDL, DML, Views, Users and grants commands will be executed for our project.

Steps to re-run these scripts:

6. Suppose, if you want to RE-RUN these scripts, you should run the below clean-up scripts (Data_del_App_Admin_Management.sql, user_del_admin.sql).
7. Execute the `Data_del_App_Admin_Management.sql` script as `app_admin` user.
8. Now, disconnect the `app_admin` user connection from the left pane.
9. And then, run the `user_del_admin.sql` as default `ADMIN` user (DBA).
10. Follow from step 2 and repeat all the steps.

    Note: While re-running, for step 3 - You can reconnect the existing `app_admin` user, you don't need to create a new connection for `app_admin` user again.
