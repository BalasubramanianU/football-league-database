-- TICKET INSERT
-- valid ticket insertion
SET SERVEROUTPUT ON;

BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id =>  'PLR0010',
        p_stadium_id => 'STD001',
        p_ticket_price => 80,
        p_seat_number => 108,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/
        
-- invalid data type
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id =>  '---',
        p_stadium_id => 'STD001',
        p_ticket_price => 75,
        p_seat_number => 1099,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- null values
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0011',
        p_stadium_id => 'STD001',
        p_ticket_price => 75,
        --p_seat_number => 108,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- price invalid
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0016',
        p_stadium_id => 'STD002',
        p_ticket_price => -60,
        p_seat_number => 111,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('03-30-2024', 'MM-DD-YYYY'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'check2',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- seat number invalid
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0017',
        p_stadium_id => 'STD002',
        p_ticket_price => 75,
        p_seat_number => -111,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('03-30-2024', 'MM-DD-YYYY'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'check2',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- sale date is invalid
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0018',
        p_stadium_id => 'STD002',
        p_ticket_price => 75,
        p_seat_number => 111,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('04-30-2024', 'MM-DD-YYYY'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'check2',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- ticket type invalid
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0018',
        p_stadium_id => 'STD002',
        p_ticket_price => 75,
        p_seat_number => 111,
        p_ticket_type => 'Regul',
        p_sale_date => TO_DATE('03-30-2024', 'MM-DD-YYYY'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'check2',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- ticket status invalid
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0018',
        p_stadium_id => 'STD002',
        p_ticket_price => 75,
        p_seat_number => 111,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('03-30-2024', 'MM-DD-YYYY'),
        p_ticket_status => 'invalid',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'check2',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- duplicate ticket combination
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0012',
        p_stadium_id => 'STD001',
        p_ticket_price => 80,
        p_seat_number => 108,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- invalid match id
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0021',
        p_stadium_id => 'STD002',
        p_ticket_price => 75,
        p_seat_number => 108,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT009'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--invalid stadium id
BEGIN
    app_admin.ticket_mgmt.add_ticket(
        p_ticket_id => 'TCK0011',
        p_stadium_id => 'STD0011',
        p_ticket_price => 75,
        p_seat_number => 108,
        p_ticket_type => 'Regular',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Available',
        p_payment_method => 'CreditCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT002'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--updating ticket details using the stored procedure
BEGIN
    app_admin.ticket_mgmt.update_ticket(
        p_ticket_id => 'TCK0011',
        p_stadium_id => 'STD001',
        p_ticket_price => 80,
        p_seat_number => 127,
        p_ticket_type => 'VIP',
        p_sale_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        p_ticket_status => 'Sold',
        p_payment_method => 'DebitCard',
        p_buyer_name => 'Check1',
        p_match_id => 'MAT001'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- deleting ticket details using the stored procedure
BEGIN
    app_admin.ticket_mgmt.delete_ticket(
        p_ticket_id => 'TCK0011'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- merchandise INSERT
--  Inserting a merchandise with valid data
BEGIN
    app_admin.merchandise_mgmt.INSERT_MERCHANDISE(
        p_item_no    => 'item001',
        p_club_id    => 'CLB001',
        p_item_name  => 'TestItem',
        p_buyer_name => 'TestBuyer',
        p_category   => 'TestCategory',
        p_price      => 50.00
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Inserting a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- duplicate primary key
BEGIN
    app_admin.merchandise_mgmt.INSERT_MERCHANDISE(
        p_item_no    => 'item001',
        p_club_id    => 'CLB001',
        p_item_name  => 'TestItem',
        p_buyer_name => 'TestBuyer',
        p_category   => 'TestCategory',
        p_price      => 50.00
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Inserting a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- null value
BEGIN
    app_admin.merchandise_mgmt.INSERT_MERCHANDISE(
        p_item_no    => 'item001',
        --p_club_id    => 'CLB001',
        p_item_name  => 'TestItem',
        p_buyer_name => 'TestBuyer',
        p_category   => 'TestCategory',
        p_price      => 50.00
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Inserting a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--price invalid
BEGIN
    app_admin.merchandise_mgmt.INSERT_MERCHANDISE(
        p_item_no    => 'item003',
        p_club_id    => 'CLB001',
        p_item_name  => 'TestItem',
        p_buyer_name => 'TestBuyer',
        p_category   => 'TestCategory',
        p_price      => -50
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Inserting a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--duplicate foreign key
BEGIN
    app_admin.merchandise_mgmt.INSERT_MERCHANDISE(
        p_item_no    => 'item004',
        p_club_id    => 'CLB0011',
        p_item_name  => 'TestItem',
        p_buyer_name => 'TestBuyer',
        p_category   => 'TestCategory',
        p_price      => 50
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Inserting a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--  Updating a merchandise with valid data
BEGIN
    app_admin.merchandise_mgmt.UpdateMerchandise(
        p_item_no    => 'item001',
        p_club_id    => 'CLB001',
        p_item_name  => 'UpdatedItemName',
        p_buyer_name => 'UpdatedBuyerName',
        p_category   => 'UpdatedCategory',
        p_price      => 60.00
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Updating a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--  Updating a merchandise with valid data and null values
BEGIN
    app_admin.merchandise_mgmt.UpdateMerchandise(
        p_item_no    => 'item001',
        --p_club_id    => 'CLB001',
        p_item_name  => 'UpdatedItemName',
        p_buyer_name => 'UpdatedBuyerName',
        p_category   => 'UpdatedCategory',
        p_price      => 70.00
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Updating a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

--  Deleting a merchandise with valid data
BEGIN
    app_admin.merchandise_mgmt.delete_merchandise(
        p_item_no    => 'item001'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(' Deleting a merchandise with valid data - FAILED. Error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- add player
BEGIN
    app_admin.Consolidated_Player_Management.add_player(
        pv_player_id => 'PLR010',
        pv_club_id => 'CLB001' ,
        pv_first_name => 'Rog',
        pv_last_name => 'Thoery',
        pv_jersey_number => 7,
        pv_player_type => 'Attacker',
        pv_birth_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        pv_number_of_matches => 290,
        pv_number_of_goals => 190,
        pv_number_of_assists => 160,
        pv_number_of_cards => 20,
        pv_wages => 1000
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- update player
BEGIN
    app_admin.Consolidated_Player_Management.update_player(
        pv_player_id => 'PLR010',
        pv_club_id => 'CLB001',
        pv_first_name => 'Henry',
        pv_last_name => 'Thoery',
        pv_jersey_number => 10,
        pv_player_type => 'Attacker',
        pv_birth_date => TO_DATE('2024-03-30', 'YYYY-MM-DD'),
        pv_number_of_matches => 290,
        pv_number_of_goals => 190,
        pv_number_of_assists => 160,
        pv_number_of_cards => 20,
        pv_wages => 999
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/

-- delete player
BEGIN
    app_admin.Consolidated_Player_Management.delete_player(
        pv_player_id => 'PLR010'
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END;
/
