---------------------------------------------------------PACKAGE MERCHANDISE---------------------------------
set serveroutput on;
CREATE OR REPLACE PACKAGE merchandise_mgmt AS
    PROCEDURE INSERT_MERCHANDISE(
        p_item_no        VARCHAR2 DEFAULT NULL,
        p_club_id        VARCHAR2 DEFAULT NULL,
        p_item_name      VARCHAR2 DEFAULT NULL,
        p_buyer_name     VARCHAR2 DEFAULT NULL,
        p_category       VARCHAR2 DEFAULT NULL,
        p_price          NUMBER DEFAULT NULL
    );

    PROCEDURE UpdateMerchandise(
        p_item_no        VARCHAR2 DEFAULT NULL,
        p_club_id        VARCHAR2 DEFAULT NULL,
        p_item_name      VARCHAR2 DEFAULT NULL,
        p_buyer_name     VARCHAR2 DEFAULT NULL,
        p_category       VARCHAR2 DEFAULT NULL,
        p_price          NUMBER DEFAULT NULL
    );

    PROCEDURE delete_merchandise(
        p_item_no        VARCHAR2 DEFAULT NULL
    );

END merchandise_mgmt;
/

CREATE OR REPLACE PACKAGE BODY merchandise_mgmt AS
    invalid_item_no EXCEPTION;
    invalid_club_id EXCEPTION;
    null_value_found EXCEPTION;
    duplicate_primary_key EXCEPTION;
    invalid_foreign_key EXCEPTION;
    out_of_range_exception EXCEPTION;
    invalid_data_type EXCEPTION;

    PROCEDURE INSERT_MERCHANDISE(
        p_item_no        VARCHAR2 DEFAULT NULL,
        p_club_id        VARCHAR2 DEFAULT NULL,
        p_item_name      VARCHAR2 DEFAULT NULL,
        p_buyer_name     VARCHAR2 DEFAULT NULL,
        p_category       VARCHAR2 DEFAULT NULL,
        p_price          NUMBER DEFAULT NULL
    ) AS
        v_count NUMBER;
    BEGIN
        -- Check for null values
        IF p_item_no IS NULL OR p_club_id IS NULL OR p_item_name IS NULL OR 
           p_buyer_name IS NULL OR p_category IS NULL OR p_price IS NULL THEN
            RAISE null_value_found;
        END IF;
        
         -- Check for valid input formats using regular expressions
        IF (NOT REGEXP_LIKE(p_item_no, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(p_club_id, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(p_item_name, '^[a-zA-Z]*$') OR
                NOT REGEXP_LIKE(p_buyer_name, '^[a-zA-Z]*$') OR
                NOT REGEXP_LIKE(p_category, '^[a-zA-Z]*$')) THEN
            RAISE invalid_data_type;
        END IF;
        
        -- Check for min and max range for p_price
        IF p_price <= 0 OR p_price > 500000 THEN
            RAISE out_of_range_exception;
        END IF;
        
        -- Check for invalid foreign key
        SELECT COUNT(*) INTO v_count FROM app_admin.club WHERE club_id = p_club_id;
        IF v_count = 0 THEN
            RAISE invalid_foreign_key;
        END IF;

        -- Check for duplicate primary key
        BEGIN
            INSERT INTO app_admin.merchandise (item_no, club_id, item_name, buyer_name, category, price)
            VALUES (p_item_no, p_club_id, p_item_name, p_buyer_name, p_category, p_price);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                RAISE duplicate_primary_key;
        END;
        
    EXCEPTION
        WHEN null_value_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: One or more required fields are null.');
        WHEN out_of_range_exception THEN
            DBMS_OUTPUT.PUT_LINE('Error: Price is out of range.');
        WHEN duplicate_primary_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Duplicate primary key found.');
        WHEN invalid_foreign_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid foreign key constraint.');
        WHEN invalid_data_type THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid data type.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END INSERT_MERCHANDISE;

PROCEDURE UpdateMerchandise(
    p_item_no        VARCHAR2 DEFAULT NULL,
    p_club_id        VARCHAR2 DEFAULT NULL,
    p_item_name      VARCHAR2 DEFAULT NULL,
    p_buyer_name     VARCHAR2 DEFAULT NULL,
    p_category       VARCHAR2 DEFAULT NULL,
    p_price          NUMBER DEFAULT NULL
) AS
    v_count NUMBER;
BEGIN
    -- Check if item_no is NULL
        IF p_item_no IS NULL THEN
            RAISE invalid_item_no;
        END IF;

     -- Check for valid input formats using regular expressions
        IF ((p_item_no IS NOT NULL AND NOT REGEXP_LIKE(p_item_no, '^[a-zA-Z0-9]*$')) OR
                (p_club_id IS NOT NULL AND NOT REGEXP_LIKE(p_club_id, '^[a-zA-Z0-9]*$')) OR
                (p_item_name IS NOT NULL AND NOT REGEXP_LIKE(p_item_name, '^[a-zA-Z0-9]*$')) OR
                (p_buyer_name IS NOT NULL AND NOT REGEXP_LIKE(p_buyer_name, '^[a-zA-Z]*$')) OR
                (p_category IS NOT NULL AND NOT REGEXP_LIKE(p_category, '^[a-zA-Z]*$'))) THEN
            RAISE invalid_data_type;
        END IF;
    
    -- Check for min and max range for p_price
    IF p_price IS NOT NULL AND (p_price <= 0 OR p_price > 500000) THEN
        RAISE out_of_range_exception;
    END IF;
    
    -- Check for invalid foreign key (assuming club_id is a foreign key)
    BEGIN
        SELECT COUNT(*) INTO v_count FROM app_admin.club WHERE club_id = COALESCE(p_club_id, club_id);
        IF v_count = 0 THEN
            RAISE invalid_foreign_key;
        END IF;
    END;

    -- Check for duplicate primary key
    BEGIN
        SELECT COUNT(*) INTO v_count FROM app_admin.merchandise WHERE item_no = COALESCE(p_item_no, item_no);
        IF v_count = 0 THEN
            RAISE invalid_item_no;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE invalid_item_no;
    END;

    -- Update merchandise
    UPDATE app_admin.merchandise
    SET club_id = COALESCE(p_club_id, club_id),
        item_name = COALESCE(p_item_name, item_name),
        buyer_name = COALESCE(p_buyer_name, buyer_name),
        category = COALESCE(p_category, category),
        price = COALESCE(p_price, price)
    WHERE item_no = p_item_no;

EXCEPTION
    WHEN null_value_found THEN
        DBMS_OUTPUT.PUT_LINE('Error: One or more required fields are null.');
    WHEN out_of_range_exception THEN
        DBMS_OUTPUT.PUT_LINE('Error: Price must be greater than or equal to 0.');
    WHEN invalid_item_no THEN
        DBMS_OUTPUT.PUT_LINE('Error: Merchandise with item number ' || p_item_no || ' not found.');
    WHEN invalid_foreign_key THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid foreign key constraint.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
END UpdateMerchandise;

    PROCEDURE delete_merchandise(
        p_item_no        VARCHAR2 DEFAULT NULL
    ) AS
    BEGIN
        -- Check for null values
        IF p_item_no IS NULL THEN
            RAISE null_value_found;
        END IF;

        -- Delete merchandise
        DELETE FROM app_admin.merchandise WHERE item_no = p_item_no;

        -- Check if any row was deleted
        IF SQL%ROWCOUNT = 0 THEN
            RAISE invalid_item_no;
        END IF;

    EXCEPTION
        WHEN null_value_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: Item number must be provided.');
        WHEN invalid_item_no THEN
            DBMS_OUTPUT.PUT_LINE('Error: Merchandise with item number ' || p_item_no || ' not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END delete_merchandise;

END merchandise_mgmt;
/

GRANT EXECUTE ON merchandise_mgmt TO revenue_manager;

-- Ticket Management

-- package declaration
CREATE OR REPLACE PACKAGE ticket_mgmt AS
    PROCEDURE add_ticket(
         p_ticket_id        VARCHAR2 DEFAULT NULL,
        p_stadium_id       VARCHAR2 DEFAULT NULL,
        p_ticket_price     NUMBER DEFAULT NULL,
        p_seat_number      NUMBER DEFAULT NULL,
        p_ticket_type      VARCHAR2 DEFAULT NULL,
        p_sale_date        DATE DEFAULT NULL,
        p_ticket_status    VARCHAR2 DEFAULT NULL,
        p_payment_method   VARCHAR2 DEFAULT NULL,
        p_buyer_name       VARCHAR2 DEFAULT NULL,
        p_match_id         VARCHAR2 DEFAULT NULL
    );

    PROCEDURE update_ticket(
        p_ticket_id        VARCHAR2 DEFAULT NULL,
        p_stadium_id       VARCHAR2 DEFAULT NULL,
        p_ticket_price     NUMBER DEFAULT NULL,
        p_seat_number      NUMBER DEFAULT NULL,
        p_ticket_type      VARCHAR2 DEFAULT NULL,
        p_sale_date        DATE DEFAULT NULL,
        p_ticket_status    VARCHAR2 DEFAULT NULL,
        p_payment_method   VARCHAR2 DEFAULT NULL,
        p_buyer_name       VARCHAR2 DEFAULT NULL,
        p_match_id         VARCHAR2 DEFAULT NULL
    );

    PROCEDURE delete_ticket(
        p_ticket_id        VARCHAR2 DEFAULT NULL
    );
END ticket_mgmt;
/

-- package body definition
CREATE OR REPLACE PACKAGE BODY ticket_mgmt AS
    -- Custom exceptions
    null_value_found EXCEPTION;
    invalid_match_id EXCEPTION;
    invalid_stadium_id EXCEPTION;
    argument_mismatch EXCEPTION;
    invalid_data_type EXCEPTION;
    out_of_range EXCEPTION;
    duplicate_key EXCEPTION;
    invalid_foreign_key EXCEPTION;
    no_ticket_found EXCEPTION;
    price_invalid EXCEPTION;
    seat_number_invalid EXCEPTION;
    sale_date_invalid EXCEPTION;
    duplicate_entry EXCEPTION;
    ticket_type_invalid EXCEPTION;
    ticket_status_invalid EXCEPTION;

    --binding the custom exceptions with common predefined exception ORA codes
    PRAGMA EXCEPTION_INIT(argument_mismatch, -06550);
    PRAGMA EXCEPTION_INIT(invalid_data_type, -6502);
    PRAGMA EXCEPTION_INIT(out_of_range, -1438);
    PRAGMA EXCEPTION_INIT(duplicate_key, -1);
    PRAGMA EXCEPTION_INIT(invalid_foreign_key, -2291);

    -- add_ticket procedure definition
    PROCEDURE add_ticket(
        p_ticket_id        VARCHAR2 DEFAULT NULL,
        p_stadium_id       VARCHAR2 DEFAULT NULL,
        p_ticket_price     NUMBER DEFAULT NULL,
        p_seat_number      NUMBER DEFAULT NULL,
        p_ticket_type      VARCHAR2 DEFAULT NULL,
        p_sale_date        DATE DEFAULT NULL,
        p_ticket_status    VARCHAR2 DEFAULT NULL,
        p_payment_method   VARCHAR2 DEFAULT NULL,
        p_buyer_name       VARCHAR2 DEFAULT NULL,
        p_match_id         VARCHAR2 DEFAULT NULL
    ) AS
        v_count NUMBER;
        v_match_date DATE;
    BEGIN
        -- Check for null values in parameters
        IF p_ticket_id IS NULL OR p_stadium_id IS NULL OR p_ticket_price IS NULL OR
           p_seat_number IS NULL OR p_ticket_type IS NULL OR p_sale_date IS NULL OR
           p_ticket_status IS NULL OR p_payment_method IS NULL OR p_buyer_name IS NULL OR
           p_match_id IS NULL THEN
            RAISE null_value_found;
        END IF;
        
        -- Check for valid input formats using regular expressions
        IF (NOT REGEXP_LIKE(p_ticket_id, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(p_stadium_id, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(p_ticket_type, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(p_ticket_status, '^[a-zA-Z]*$') OR
                NOT REGEXP_LIKE(p_payment_method, '^[a-zA-Z]*$') OR
                NOT REGEXP_LIKE(p_buyer_name, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(p_match_id, '^[a-zA-Z0-9]*$')) THEN
            RAISE invalid_data_type;
        END IF;
        
        -- Validate ticket price
        IF p_ticket_price <= 0 OR p_ticket_price > 500000 THEN
            RAISE price_invalid;
        END IF;
        
        -- Validate ticket price and seat number
        IF p_seat_number <= 0 OR p_seat_number > 200000 THEN
            RAISE seat_number_invalid;
        END IF;

        -- Check for valid date
        IF NOT TO_CHAR(p_sale_date, 'YYYY-MM-DD') IS NOT NULL THEN
            RAISE invalid_data_type;
        END IF;
        
        -- Validate sale date should not be after the match date
        SELECT match_date INTO v_match_date FROM app_admin.match WHERE match_id = p_match_id;
        IF p_sale_date > v_match_date THEN
            RAISE sale_date_invalid;
        END IF;
        
        -- Validate ticket type
        IF p_ticket_type IS NOT NULL AND p_ticket_type NOT IN ('VIP', 'Standard', 'Premium', 'Regular') THEN
            RAISE ticket_type_invalid;
        END IF;

        -- Validate ticket status
        IF p_ticket_status IS NOT NULL AND p_ticket_status NOT IN ('Sold', 'Available') THEN
            RAISE ticket_status_invalid;
        END IF;
        
        -- Ensure uniqueness for stadium_id, seat_number, and match_id
        SELECT COUNT(*) INTO v_count FROM app_admin.ticket WHERE stadium_id = p_stadium_id AND
                                                      seat_number = p_seat_number AND
                                                      match_id = p_match_id;
        IF v_count > 0 THEN
            RAISE duplicate_entry;
        END IF;

        -- Check if the match ID exists
        SELECT COUNT(*) INTO v_count FROM app_admin.match WHERE match_id = p_match_id;
        IF v_count = 0 THEN
            RAISE invalid_match_id;
        END IF;
        
        -- Check if the stadium ID exists
        SELECT COUNT(*) INTO v_count FROM app_admin.stadium WHERE stadium_id = p_stadium_id;
        IF v_count = 0 THEN
            RAISE invalid_stadium_id;
        END IF;

        -- Insert into ticket table
        INSERT INTO app_admin.ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id)
        VALUES (p_ticket_id, p_stadium_id, p_ticket_price, p_seat_number, p_ticket_type, p_sale_date, p_ticket_status, p_payment_method, p_buyer_name, p_match_id);

    EXCEPTION
        WHEN null_value_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: One or more required fields are null.');
        WHEN invalid_match_id THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid match ID provided.');
        WHEN invalid_stadium_id THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid stadium ID provided.');
        WHEN argument_mismatch THEN
            DBMS_OUTPUT.PUT_LINE('Error: Number of arguments does not match expected count.');
        WHEN invalid_data_type THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid data type provided for one or more arguments.');
        WHEN out_of_range THEN
            DBMS_OUTPUT.PUT_LINE('Error: One or more arguments are out of allowed range.');
        WHEN duplicate_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Duplicate primary key value encountered.');
        WHEN invalid_foreign_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid foreign key reference.');
        WHEN price_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Price number is out of range.');
        WHEN seat_number_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Seat number is out of range.');
        WHEN sale_date_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Sale date cannot be greater than the match date.');
        WHEN duplicate_entry THEN
            DBMS_OUTPUT.PUT_LINE('Error: Duplicate seat booking for a given match and stadium.');
        WHEN ticket_type_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Ticket type is invalid.');
        WHEN ticket_status_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Ticket status is invalid.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END add_ticket;

    -- update_ticket procedure definition
    PROCEDURE update_ticket(
        p_ticket_id        VARCHAR2 DEFAULT NULL,
        p_stadium_id       VARCHAR2 DEFAULT NULL,
        p_ticket_price     NUMBER DEFAULT NULL,
        p_seat_number      NUMBER DEFAULT NULL,
        p_ticket_type      VARCHAR2 DEFAULT NULL,
        p_sale_date        DATE DEFAULT NULL,
        p_ticket_status    VARCHAR2 DEFAULT NULL,
        p_payment_method   VARCHAR2 DEFAULT NULL,
        p_buyer_name       VARCHAR2 DEFAULT NULL,
        p_match_id         VARCHAR2 DEFAULT NULL
    ) AS
        v_count NUMBER;
        v_ticket_not_found EXCEPTION;
        v_match_date DATE;
    BEGIN
        -- Check if ticket_id is NULL
        IF p_ticket_id IS NULL THEN
            RAISE v_ticket_not_found;
        END IF;
        
        -- Check for valid input formats using regular expressions
        IF ((p_ticket_id IS NOT NULL AND NOT REGEXP_LIKE(p_ticket_id, '^[a-zA-Z0-9]*$')) OR
                (p_stadium_id IS NOT NULL AND NOT REGEXP_LIKE(p_stadium_id, '^[a-zA-Z0-9]*$')) OR
                (p_ticket_type IS NOT NULL AND NOT REGEXP_LIKE(p_ticket_type, '^[a-zA-Z0-9]*$')) OR
                (p_ticket_status IS NOT NULL AND NOT REGEXP_LIKE(p_ticket_status, '^[a-zA-Z]*$')) OR
                (p_payment_method IS NOT NULL AND NOT REGEXP_LIKE(p_payment_method, '^[a-zA-Z]*$')) OR
                (p_buyer_name IS NOT NULL AND NOT REGEXP_LIKE(p_buyer_name, '^[a-zA-Z0-9]*$')) OR
                (p_match_id IS NOT NULL AND NOT REGEXP_LIKE(p_match_id, '^[a-zA-Z0-9]*$'))) THEN
            RAISE invalid_data_type;
        END IF;
        
        -- Validate ticket price
        IF p_ticket_price IS NOT NULL AND (p_ticket_price <= 0 OR p_ticket_price > 500000) THEN
            RAISE price_invalid;
        END IF;
        
        -- Validate ticket price and seat number
        IF p_seat_number IS NOT NULL AND (p_seat_number <= 0 OR p_seat_number > 200000) THEN
            RAISE seat_number_invalid;
        END IF;
        
        -- Check for valid date
        IF NOT (p_sale_date IS NULL OR TO_CHAR(p_sale_date, 'YYYY-MM-DD') IS NOT NULL) THEN
            RAISE invalid_data_type;
        END IF;
        
        
        
        -- Validate sale date should not be after the match date
        SELECT match_date INTO v_match_date FROM app_admin.match WHERE match_id = p_match_id;
        IF p_match_id IS NOT NULL AND (p_sale_date > v_match_date) THEN
            RAISE sale_date_invalid;
        END IF;
        
        -- Validate ticket type
        IF p_ticket_type IS NOT NULL AND p_ticket_type NOT IN ('VIP', 'Standard', 'Premium', 'Regular') THEN
            RAISE ticket_type_invalid;
        END IF;

        -- Validate ticket status
        IF p_ticket_status IS NOT NULL AND p_ticket_status NOT IN ('Sold', 'Available') THEN
            RAISE ticket_status_invalid;
        END IF;
        
        -- Ensure uniqueness for stadium_id, seat_number, and match_id
        SELECT COUNT(*) INTO v_count FROM app_admin.ticket WHERE stadium_id = p_stadium_id AND
                                                      seat_number = p_seat_number AND
                                                      match_id = p_match_id;
        IF p_stadium_id IS NOT NULL AND 
            p_seat_number IS NOT NULL AND 
            p_match_id IS NOT NULL AND 
            v_count > 0 THEN
            RAISE duplicate_entry;
        END IF;
        
        -- Check if the match ID exists
        SELECT COUNT(*) INTO v_count FROM app_admin.match WHERE match_id = COALESCE(p_match_id, match_id);
        IF v_count = 0 THEN
            RAISE invalid_match_id;
        END IF;

        -- Check if the stadium ID exists
        SELECT COUNT(*) INTO v_count FROM app_admin.stadium WHERE stadium_id = COALESCE(p_stadium_id, stadium_id);
        IF v_count = 0 THEN
            RAISE invalid_stadium_id;
        END IF;

        -- Update the ticket with only non-null values provided
        UPDATE app_admin.ticket SET
            stadium_id = COALESCE(p_stadium_id, stadium_id),
            ticket_price = COALESCE(p_ticket_price, ticket_price),
            seat_number = COALESCE(p_seat_number, seat_number),
            ticket_type = COALESCE(p_ticket_type, ticket_type),
            sale_date = COALESCE(p_sale_date, sale_date),
            ticket_status = COALESCE(p_ticket_status, ticket_status),
            payment_method = COALESCE(p_payment_method, payment_method),
            buyer_name = COALESCE(p_buyer_name, buyer_name),
            match_id = COALESCE(p_match_id, match_id)
        WHERE ticket_id = p_ticket_id;

        -- Check if any row was updated
        IF SQL%ROWCOUNT = 0 THEN
            RAISE v_ticket_not_found;
        END IF;

    EXCEPTION
        WHEN v_ticket_not_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: No ticket found with the provided ID or ID is NULL.');
        WHEN invalid_match_id THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid match ID provided.');
        WHEN invalid_stadium_id THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid stadium ID provided.');
        WHEN argument_mismatch THEN
            DBMS_OUTPUT.PUT_LINE('Error: Number of arguments does not match expected count.');
        WHEN invalid_data_type THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid data type provided for one or more arguments.');
        WHEN out_of_range THEN
            DBMS_OUTPUT.PUT_LINE('Error: One or more arguments are out of allowed range.');
        WHEN duplicate_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Duplicate primary key value encountered.');
        WHEN invalid_foreign_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid foreign key reference.');
        WHEN price_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Price number is out of range.');
        WHEN seat_number_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Seat number is out of range.');
        WHEN sale_date_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Sale date cannot be greater than the match date.');
        WHEN duplicate_entry THEN
            DBMS_OUTPUT.PUT_LINE('Error: Duplicate seat booking for a given match and stadium.');
        WHEN ticket_type_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Ticket type is invalid.');
        WHEN ticket_status_invalid THEN
            DBMS_OUTPUT.PUT_LINE('Error: Ticket status is invalid.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END update_ticket;

    -- delete_ticket procedure definition
    PROCEDURE delete_ticket(
        p_ticket_id        VARCHAR2 DEFAULT NULL
    ) AS
    BEGIN
        -- Check if ticket_id is NULL
        IF p_ticket_id IS NULL THEN
            RAISE no_ticket_found;
        END IF;
        
        DELETE FROM app_admin.ticket WHERE ticket_id = p_ticket_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE no_ticket_found;
        END IF;

    EXCEPTION
        WHEN no_ticket_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: No ticket found with the provided ID to delete.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END delete_ticket;
END ticket_mgmt;
/

GRANT EXECUTE ON ticket_mgmt TO revenue_manager;


CREATE OR REPLACE PACKAGE Consolidated_Player_Management AS
    PROCEDURE add_player (
        pv_player_id VARCHAR2 DEFAULT NULL,
        pv_club_id  VARCHAR2 DEFAULT NULL,
        pv_first_name VARCHAR2 DEFAULT NULL,
        pv_last_name VARCHAR2 DEFAULT NULL,
        pv_jersey_number NUMBER DEFAULT NULL,
        pv_player_type VARCHAR2 DEFAULT NULL,
        pv_birth_date DATE DEFAULT NULL,
        pv_number_of_matches NUMBER DEFAULT NULL,
        pv_number_of_goals NUMBER DEFAULT NULL,
        pv_number_of_assists NUMBER DEFAULT NULL,
        pv_number_of_cards NUMBER DEFAULT NULL,
        pv_wages NUMBER DEFAULT NULL
    );
    PROCEDURE update_player (
        pv_player_id VARCHAR2 DEFAULT NULL,
        pv_club_id  VARCHAR2 DEFAULT NULL,
        pv_first_name VARCHAR2 DEFAULT NULL,
        pv_last_name VARCHAR2 DEFAULT NULL,
        pv_jersey_number NUMBER DEFAULT NULL,
        pv_player_type VARCHAR2 DEFAULT NULL,
        pv_birth_date DATE DEFAULT NULL,
        pv_number_of_matches NUMBER DEFAULT NULL,
        pv_number_of_goals NUMBER DEFAULT NULL,
        pv_number_of_assists NUMBER DEFAULT NULL,
        pv_number_of_cards NUMBER DEFAULT NULL,
        pv_wages NUMBER DEFAULT NULL
    );
 
    PROCEDURE delete_player (
        pv_player_id VARCHAR2 DEFAULT NULL
    );
 
END Consolidated_Player_Management;
/
 
 CREATE OR REPLACE PACKAGE BODY Consolidated_Player_Management AS
    -- Identified Custom exceptions
    null_value_found EXCEPTION;
    invalid_player_id EXCEPTION;
    invalid_club_id EXCEPTION;
    argument_mismatch EXCEPTION;
    invalid_data_type EXCEPTION;
    out_of_range EXCEPTION;
    duplicate_key EXCEPTION;
    invalid_foreign_key EXCEPTION;
    no_player_found EXCEPTION;
 
    --binding the custom exceptions with common predefined exception ORA codes
    PRAGMA EXCEPTION_INIT(argument_mismatch, -6550);
    PRAGMA EXCEPTION_INIT(invalid_data_type, -6502);
    PRAGMA EXCEPTION_INIT(out_of_range, -1438);
    PRAGMA EXCEPTION_INIT(duplicate_key, -1);
    PRAGMA EXCEPTION_INIT(invalid_foreign_key, -2291);
 
    PROCEDURE add_player (
        pv_player_id VARCHAR2 DEFAULT NULL,
        pv_club_id  VARCHAR2 DEFAULT NULL,
        pv_first_name VARCHAR2 DEFAULT NULL,
        pv_last_name VARCHAR2 DEFAULT NULL,
        pv_jersey_number NUMBER DEFAULT NULL,
        pv_player_type VARCHAR2 DEFAULT NULL,
        pv_birth_date DATE DEFAULT NULL,
        pv_number_of_matches NUMBER DEFAULT NULL,
        pv_number_of_goals NUMBER DEFAULT NULL,
        pv_number_of_assists NUMBER DEFAULT NULL,
        pv_number_of_cards NUMBER DEFAULT NULL,
        pv_wages NUMBER DEFAULT NULL
    ) AS
        pv_count NUMBER;
 
BEGIN

        --INSERTION INTO TABLE
        INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)
        values(pv_player_id, pv_club_id, pv_player_type, pv_number_of_matches, pv_number_of_goals, pv_birth_date, pv_first_name, pv_last_name, pv_jersey_number,  pv_wages,  pv_number_of_assists);
 
    EXCEPTION
        WHEN null_value_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: One or more required fields are null.');
        WHEN invalid_player_id THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid player ID provided.');
        WHEN invalid_club_id THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid club ID provided.');
        WHEN argument_mismatch THEN
            DBMS_OUTPUT.PUT_LINE('Error: Number of arguments does not match expected count.');
        WHEN invalid_data_type THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid data type provided for one or more arguments.');
        WHEN out_of_range THEN
            DBMS_OUTPUT.PUT_LINE('Error: One or more arguments are out of allowed range.');
        WHEN duplicate_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Duplicate primary key value encountered.');
        WHEN invalid_foreign_key THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid foreign key reference.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END add_player;
 
 
 
  PROCEDURE update_player (
        pv_player_id VARCHAR2 DEFAULT NULL,
        pv_club_id  VARCHAR2 DEFAULT NULL,
        pv_first_name VARCHAR2 DEFAULT NULL,
        pv_last_name VARCHAR2 DEFAULT NULL,
        pv_jersey_number NUMBER DEFAULT NULL,
        pv_player_type VARCHAR2 DEFAULT NULL,
        pv_birth_date DATE DEFAULT NULL,
        pv_number_of_matches NUMBER DEFAULT NULL,
        pv_number_of_goals NUMBER DEFAULT NULL,
        pv_number_of_assists NUMBER DEFAULT NULL,
         pv_number_of_cards NUMBER DEFAULT NULL,
        pv_wages NUMBER DEFAULT NULL
    ) AS
        pv_count NUMBER;
        pv_player_not_found EXCEPTION;
        
    BEGIN
        -- Check if PLAYER_ID is NULL
        IF pv_player_id IS NULL THEN
            RAISE pv_player_not_found;
        END IF;
 
        -- Check for valid input formats using regular expressions
        IF (NOT REGEXP_LIKE(pv_player_id, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(pv_club_id, '^[a-zA-Z0-9]*$') OR
                NOT REGEXP_LIKE(pv_player_type, '^[a-zA-Z0-9\s]*$') OR
                NOT REGEXP_LIKE(pv_first_name, '^[a-zA-Z0-9\s]*$') OR
                NOT REGEXP_LIKE(pv_last_name, '^[a-zA-Z0-9\s]*$')) THEN
            RAISE invalid_data_type;
        END IF;
 
        -- Check for numeric fields
        IF NOT (REGEXP_LIKE(TO_CHAR(pv_wages), '^\d+(\.\d+)?$') OR
                REGEXP_LIKE(TO_CHAR(pv_jersey_number), '^\d*$')) THEN
            RAISE invalid_data_type;
        END IF;
 
        -- Check for valid date
        IF NOT TO_CHAR(pv_birth_date, 'YYYY-MM-DD') IS NOT NULL THEN
            RAISE invalid_data_type;
        END IF;
 
        -- Check if the Player ID exists from PLAYER Table
        SELECT COUNT(*) INTO pv_count FROM player WHERE player_id = pv_player_id;
        IF pv_count = 0 THEN
            RAISE invalid_player_id;
        END IF;
 
        -- Check if the CLUB ID is valid or not from CLUB Entity
        SELECT COUNT(*) INTO pv_count FROM club WHERE club_id = pv_club_id;
        IF pv_count = 0 THEN
            RAISE invalid_club_id;
        END IF;
        
 
        -- Update the player with only non-null values provided
        UPDATE player SET
            player_id = COALESCE(pv_player_id, player_id),
            club_id = COALESCE(pv_club_id, club_id),
            jersey_number = COALESCE(pv_jersey_number, jersey_number),
            player_type = COALESCE(pv_player_type, player_type),
            birth_date = COALESCE(pv_birth_date, birth_date),
            first_name = COALESCE(pv_first_name, first_name),
            last_name = COALESCE(pv_last_name,last_name),
            number_of_matches = COALESCE(pv_number_of_matches, number_of_matches),
            number_of_goals = COALESCE(pv_number_of_goals,number_of_goals),
            number_of_assists = COALESCE(pv_number_of_assists,number_of_assists),
            wages = COALESCE(pv_wages,wages)
        WHERE player_id = pv_player_id;
 
        -- Check if any row was updated
        IF SQL%ROWCOUNT = 0 THEN
            RAISE pv_player_not_found;
        END IF;
 
    EXCEPTION
        WHEN pv_player_not_found THEN
          DBMS_OUTPUT.PUT_LINE('Error: No player found with provided player ID');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END update_player;
 
    PROCEDURE delete_player(
        pv_player_id        VARCHAR2 DEFAULT NULL
    ) AS
    BEGIN
        -- Check if player ID is NULL
        IF pv_player_id IS NULL THEN
            RAISE no_player_found;
        END IF;
        DELETE FROM player WHERE player_id = pv_player_id;
 
        IF SQL%ROWCOUNT = 0 THEN
            RAISE no_player_found;
        END IF;
 
    EXCEPTION
        WHEN no_player_found THEN
            DBMS_OUTPUT.PUT_LINE('Error: No player found with the provided ID to delete.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || LTRIM(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 1)));
    END delete_player;
 
END Consolidated_Player_Management;
/

GRANT EXECUTE ON Consolidated_Player_Management TO revenue_manager;

