-- Revoke privileges granted to 'analyst'
REVOKE SELECT ON ticket_sales_match_wise FROM app_analyst;
REVOKE SELECT ON match_summary_view FROM app_analyst;
REVOKE SELECT ON revenue_of_the_club_through_merchandise FROM app_analyst;
REVOKE SELECT ON player_Performance_View FROM app_analyst;
REVOKE SELECT ON Merchandise_Items_View FROM app_analyst;
REVOKE SELECT ON MerchandisePriceRange FROM app_analyst;
REVOKE SELECT ON team_Roaster FROM app_analyst;

REVOKE EXECUTE ON ticket_mgmt FROM revenue_manager;
REVOKE EXECUTE ON merchandise_mgmt FROM revenue_manager;

-- Drop all the tables
drop table club cascade constraints;
drop table club_data;
drop table commentator cascade constraints;
drop table manager cascade constraints;
drop table match cascade constraints;
drop table match_club cascade constraints;
drop table match_commentator cascade constraints;
drop table match_refree cascade constraints;
drop table match_stat cascade constraints;
drop table merchandise cascade constraints;
drop table owner cascade constraints;
drop table player cascade constraints;
drop table points_table cascade constraints;
drop table refree cascade constraints;
drop table stadium cascade constraints;
drop table ticket cascade constraints;

-- Drop all the views
DROP VIEW ticket_sales_match_wise;
DROP VIEW match_summary_view;
DROP VIEW revenue_of_the_club_through_merchandise;
DROP VIEW player_Performance_View;
DROP VIEW Merchandise_Items_View;
DROP VIEW MerchandisePriceRange;

DROP PACKAGE ticket_mgmt;

DROP PACKAGE merchandise_mgmt;

