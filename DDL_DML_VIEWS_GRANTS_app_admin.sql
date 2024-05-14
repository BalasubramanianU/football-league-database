CREATE TABLE club (
    club_id            VARCHAR2(10) NOT NULL,
    owner_id           VARCHAR2(10),
    club_name          VARCHAR2(255),
    number_of_players  NUMBER,
    manager_id         VARCHAR2(10)
);

CREATE UNIQUE INDEX club__idx ON
    club (
        manager_id
    ASC );

ALTER TABLE club ADD CONSTRAINT club_pk PRIMARY KEY ( club_id );

ALTER TABLE club ADD CONSTRAINT club_owner_id_un UNIQUE ( owner_id );

ALTER TABLE club ADD CONSTRAINT club_manager_id_un UNIQUE ( manager_id );

CREATE TABLE club_data (
    club_id                     VARCHAR2(10) NOT NULL,
    number_of_trophies          NUMBER,
    number_of_wins              NUMBER,
    number_of_players_purchased NUMBER,
    number_of_players_sold      NUMBER,
    club_budget                 NUMBER
);

CREATE UNIQUE INDEX club_data__idx ON
    club_data (
        club_id
    ASC );

ALTER TABLE club_data ADD CONSTRAINT club_data_pk PRIMARY KEY ( club_id );

CREATE TABLE commentator (
    commentator_id                VARCHAR2(10) NOT NULL,
    number_of_matches_commentated NUMBER,
    language                      VARCHAR2(20),
    first_name                    VARCHAR2(255),
    last_name                     VARCHAR2(255)
);

ALTER TABLE commentator ADD CONSTRAINT commentator_pk PRIMARY KEY ( commentator_id );

CREATE TABLE manager (
    manager_id              VARCHAR2(10) NOT NULL,
    first_name              VARCHAR2(255),
    last_name               VARCHAR2(255),
    number_of_coaches       NUMBER,
    number_of_clubs_managed NUMBER
);

ALTER TABLE manager ADD CONSTRAINT manager_pk PRIMARY KEY ( manager_id );

CREATE TABLE match (
    match_id           VARCHAR2(10) NOT NULL,
    match_date         DATE,
    result             VARCHAR2(20),
    stadium_id         VARCHAR2(10),
    time               NUMBER
);

ALTER TABLE match ADD CONSTRAINT match_pk PRIMARY KEY ( match_id );

CREATE TABLE match_club (
    mat_club_id    VARCHAR2(20) NOT NULL,
    match_id       VARCHAR2(10),
    club_id        VARCHAR2(10)
);

ALTER TABLE match_club ADD CONSTRAINT match_club_pk PRIMARY KEY ( mat_club_id );

ALTER TABLE match_club ADD CONSTRAINT match_club_match_club_id_un UNIQUE (match_id, club_id);

CREATE TABLE match_commentator (
    mat_com_id                 VARCHAR2(20) NOT NULL,
    match_id                   VARCHAR2(10),
    commentator_id             VARCHAR2(10)
);

ALTER TABLE match_commentator ADD CONSTRAINT match_commentator_pk PRIMARY KEY ( mat_com_id );

ALTER TABLE match_commentator ADD CONSTRAINT match_commentator_match_id_un UNIQUE (match_id, commentator_id);

CREATE TABLE match_refree (
    mat_ref_sk       VARCHAR2(20) NOT NULL,
    match_id         VARCHAR2(10),
    refree_id        VARCHAR2(10)
);

ALTER TABLE match_refree ADD CONSTRAINT match_refree_pk PRIMARY KEY ( mat_ref_sk );

ALTER TABLE match_refree ADD CONSTRAINT match_refree_refree_id_un UNIQUE (match_id, refree_id);

CREATE TABLE match_stat (
    match_id        VARCHAR2(10) NOT NULL,
    match_goals     NUMBER,
    match_penalties NUMBER,
    match_fouls     NUMBER
);

CREATE UNIQUE INDEX match_stat__idx ON
    match_stat (
        match_id
    ASC );

ALTER TABLE match_stat ADD CONSTRAINT match_stat_pk PRIMARY KEY ( match_id );

CREATE TABLE merchandise (
    item_no      VARCHAR2(10) NOT NULL,
    club_id      VARCHAR2(10),
    item_name    VARCHAR2(255),
    buyer_name   VARCHAR(255),
    category     VARCHAR2(255),
    price        NUMBER
);

ALTER TABLE merchandise ADD CONSTRAINT merchandise_pk PRIMARY KEY ( item_no );

CREATE TABLE owner (
    owner_id           VARCHAR2(10) NOT NULL,
    net_worth          NUMBER,
    investment_in_club NUMBER,
    first_name         VARCHAR2(255),
    last_name          VARCHAR2(255)
);

CREATE UNIQUE INDEX owner__idx ON
    owner (
        owner_id
    ASC );

ALTER TABLE owner ADD CONSTRAINT owner_pk PRIMARY KEY ( owner_id );

CREATE TABLE player (

    player_id            VARCHAR2(10) NOT NULL,

    club_id           VARCHAR2(10),

    player_type        VARCHAR2(20) NOT NULL,    

    number_of_matches NUMBER,

    number_of_goals   NUMBER,

    birth_date         date,

    first_name        VARCHAR2(255),

    last_name         VARCHAR2(255),

    jersey_number     NUMBER,

    wages             NUMBER,

    number_of_assists NUMBER

);

ALTER TABLE player ADD CONSTRAINT player_pk PRIMARY KEY ( player_id );

CREATE TABLE points_table (
    club_id        VARCHAR2(10) NOT NULL,
    rank           NUMBER NOT NULL,
    matches_played NUMBER,
    matches_won    NUMBER,
    matches_lost   NUMBER,
    matches_drawn  NUMBER,
    no_result      NUMBER,
    season_club_sk VARCHAR2(20) NOT NULL,
    season         VARCHAR2(10)
);

ALTER TABLE points_table ADD CONSTRAINT points_table_pk PRIMARY KEY ( season_club_sk );

ALTER TABLE points_table ADD CONSTRAINT pts_table_un UNIQUE (club_id, season);

CREATE TABLE refree (
    refree_id                  VARCHAR2(10) NOT NULL,
    first_name                 VARCHAR2(255),
    last_name                  VARCHAR2(255),
    years_of_experience        NUMBER,
    number_of_games_officiated NUMBER,
    number_of_red_cards        NUMBER
);

ALTER TABLE refree ADD CONSTRAINT refree_pk PRIMARY KEY ( refree_id );

CREATE TABLE stadium (
    stadium_id   VARCHAR2(10) NOT NULL,
    stadium_name VARCHAR2(100),
    city         VARCHAR2(100),
    capacity     NUMBER,
    "SIZE"       NUMBER,
    attendance   NUMBER
);

ALTER TABLE stadium ADD CONSTRAINT stadium_pk PRIMARY KEY ( stadium_id );

CREATE TABLE ticket (
    ticket_id          VARCHAR2(10) NOT NULL,
    stadium_id         VARCHAR2(10),
    ticket_price       NUMBER,
    seat_number        NUMBER,
    ticket_type        VARCHAR2(10),
    sale_date          DATE,
    ticket_status      VARCHAR2(20),
    payment_method     VARCHAR2(20),
    buyer_name         VARCHAR2(255),
    match_id           VARCHAR2(10)
);

ALTER TABLE ticket ADD CONSTRAINT ticket_pk PRIMARY KEY ( ticket_id );

ALTER TABLE club_data
    ADD CONSTRAINT club_data_club_fk FOREIGN KEY ( club_id )
        REFERENCES club ( club_id );

ALTER TABLE club
    ADD CONSTRAINT club_manager_fk FOREIGN KEY ( manager_id )
        REFERENCES manager ( manager_id );
        
ALTER TABLE club
    ADD CONSTRAINT club_owner_fk FOREIGN KEY ( owner_id )
        REFERENCES owner ( owner_id );

ALTER TABLE match_club
    ADD CONSTRAINT match_club_club_fk FOREIGN KEY ( club_id )
        REFERENCES club ( club_id );

ALTER TABLE match_club
    ADD CONSTRAINT match_club_match_fk FOREIGN KEY ( match_id )
        REFERENCES match ( match_id );

ALTER TABLE match_commentator
    ADD CONSTRAINT match_comm_commentator_fk FOREIGN KEY ( commentator_id )
        REFERENCES commentator ( commentator_id );

ALTER TABLE match_commentator
    ADD CONSTRAINT match_commentator_match_fk FOREIGN KEY ( match_id )
        REFERENCES match ( match_id );

ALTER TABLE match_refree
    ADD CONSTRAINT match_refree_match_fk FOREIGN KEY ( match_id )
        REFERENCES match ( match_id );

ALTER TABLE match_refree
    ADD CONSTRAINT match_refree_refree_fk FOREIGN KEY ( refree_id )
        REFERENCES refree ( refree_id );

ALTER TABLE match
    ADD CONSTRAINT match_stadium_fk FOREIGN KEY ( stadium_id )
        REFERENCES stadium ( stadium_id );

ALTER TABLE match_stat
    ADD CONSTRAINT match_stat_match_fk FOREIGN KEY ( match_id )
        REFERENCES match ( match_id );

ALTER TABLE merchandise
    ADD CONSTRAINT merchandise_club_fk FOREIGN KEY ( club_id )
        REFERENCES club ( club_id );

ALTER TABLE player
    ADD CONSTRAINT player_club_fk FOREIGN KEY ( club_id )
        REFERENCES club ( club_id );

ALTER TABLE points_table
    ADD CONSTRAINT points_table_club_fk FOREIGN KEY ( club_id )
        REFERENCES club ( club_id );

ALTER TABLE ticket
    ADD CONSTRAINT ticket_match_fk FOREIGN KEY ( match_id )
        REFERENCES match ( match_id );

ALTER TABLE ticket
    ADD CONSTRAINT ticket_stadium_fk FOREIGN KEY ( stadium_id )
        REFERENCES stadium ( stadium_id );

INSERT INTO owner (owner_id, net_worth, investment_in_club, first_name, last_name) VALUES ('OWN001', 1000000, 500000, 'John', 'Doe'); 
INSERT INTO owner (owner_id, net_worth, investment_in_club, first_name, last_name) VALUES ('OWN002', 1500000, 700000, 'Jane', 'Smith'); 
INSERT INTO owner (owner_id, net_worth, investment_in_club, first_name, last_name) VALUES ('OWN003', 800000, 400000, 'David', 'Jones');
INSERT INTO owner (owner_id, net_worth, investment_in_club, first_name, last_name) VALUES ('OWN004', 2000000, 900000, 'Emily', 'Brown'); 
INSERT INTO owner (owner_id, net_worth, investment_in_club, first_name, last_name) VALUES ('OWN005', 1200000, 600000, 'Michael', 'Wilson'); 
INSERT INTO owner (owner_id, net_worth, investment_in_club, first_name, last_name) VALUES ('OWN006', 1800000, 850000, 'Jessica', 'Garcia');

INSERT INTO commentator (commentator_id, number_of_matches_commentated, language, first_name, last_name) VALUES ('COM001', 200, 'English', 'Martin', 'Tyler');
INSERT INTO commentator (commentator_id, number_of_matches_commentated, language, first_name, last_name) VALUES ('COM002', 180, 'Spanish', 'Carlos', 'Martinez');
INSERT INTO commentator (commentator_id, number_of_matches_commentated, language, first_name, last_name) VALUES ('COM003', 150, 'French', 'Thierry', 'Henry');
INSERT INTO commentator (commentator_id, number_of_matches_commentated, language, first_name, last_name) VALUES ('COM004', 170, 'German', 'Thomas', 'Muller');
INSERT INTO commentator (commentator_id, number_of_matches_commentated, language, first_name, last_name) VALUES ('COM005', 160, 'Italian', 'Gianluca', 'Vialli');
INSERT INTO commentator (commentator_id, number_of_matches_commentated, language, first_name, last_name) VALUES ('COM006', 190, 'Portuguese', 'Luis', 'Figo');

INSERT INTO stadium (stadium_id, stadium_name, city, capacity, "SIZE", attendance) VALUES ('STD001', 'Old Trafford', 'Manchester', 76000, 105, 75000);
INSERT INTO stadium (stadium_id, stadium_name, city, capacity, "SIZE", attendance) VALUES ('STD002', 'Camp Nou', 'Barcelona', 99354, 110, 90000);
INSERT INTO stadium (stadium_id, stadium_name, city, capacity, "SIZE", attendance) VALUES ('STD003', 'Wembley', 'London', 90000, 105, 85000);
INSERT INTO stadium (stadium_id, stadium_name, city, capacity, "SIZE", attendance) VALUES ('STD004', 'San Siro', 'Milan', 80018, 105, 78000);
INSERT INTO stadium (stadium_id, stadium_name, city, capacity, "SIZE", attendance) VALUES ('STD005', 'Anfield', 'Liverpool', 54074, 101, 53000);
INSERT INTO stadium (stadium_id, stadium_name, city, capacity, "SIZE", attendance) VALUES ('STD006', 'Santiago Bernabeu', 'Madrid', 81044, 107, 80000);

INSERT INTO match (match_id, match_date, result, stadium_id, time) VALUES ('MAT001', TO_DATE('2024-04-01', 'YYYY-MM-DD'), '3-1', 'STD001', 90);
INSERT INTO match (match_id, match_date, result, stadium_id, time) VALUES ('MAT002', TO_DATE('2024-04-02', 'YYYY-MM-DD'), '2-2', 'STD002', 90);
INSERT INTO match (match_id, match_date, result, stadium_id, time) VALUES ('MAT003', TO_DATE('2024-04-03', 'YYYY-MM-DD'), '0-1', 'STD003', 90);
INSERT INTO match (match_id, match_date, result, stadium_id, time) VALUES ('MAT004', TO_DATE('2024-04-04', 'YYYY-MM-DD'), '4-0', 'STD004', 90);
INSERT INTO match (match_id, match_date, result, stadium_id, time) VALUES ('MAT005', TO_DATE('2024-04-05', 'YYYY-MM-DD'), '1-3', 'STD005', 90);
INSERT INTO match (match_id, match_date, result, stadium_id, time) VALUES ('MAT006', TO_DATE('2024-04-06', 'YYYY-MM-DD'), '2-0', 'STD006', 90);

INSERT INTO match_commentator (mat_com_id, match_id, commentator_id) VALUES ('MCOM001', 'MAT001', 'COM001');
INSERT INTO match_commentator (mat_com_id, match_id, commentator_id) VALUES ('MCOM002', 'MAT001', 'COM002');
INSERT INTO match_commentator (mat_com_id, match_id, commentator_id) VALUES ('MCOM003', 'MAT003', 'COM003');
INSERT INTO match_commentator (mat_com_id, match_id, commentator_id) VALUES ('MCOM004', 'MAT003', 'COM004');
INSERT INTO match_commentator (mat_com_id, match_id, commentator_id) VALUES ('MCOM005', 'MAT002', 'COM005');
INSERT INTO match_commentator (mat_com_id, match_id, commentator_id) VALUES ('MCOM006', 'MAT002', 'COM006');

INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG001', 'John', 'Doe', 5, 3); 
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG002', 'Jane', 'Smith', 4, 2); 
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG003', 'David', 'Jones', 6, 4); 
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG004', 'Emily', 'Brown', 7, 5);
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG005', 'Michael', 'Wilson', 3, 2); 
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG006', 'Jessica', 'Garcia', 4, 3); 
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG007', 'Daniel', 'Martinez', 5, 4); 
INSERT INTO manager (manager_id, first_name, last_name, number_of_coaches, number_of_clubs_managed) VALUES ('MNG008', 'Sophia', 'Lopez', 2, 1); 

INSERT INTO club (club_id, owner_id, club_name, number_of_players, manager_id) VALUES ('CLB001', 'OWN001', 'Arsenal',28, 'MNG001');
INSERT INTO club (club_id, owner_id, club_name, number_of_players, manager_id) VALUES ('CLB002', 'OWN002', 'Manchester United',32, 'MNG002');
INSERT INTO club (club_id, owner_id, club_name, number_of_players, manager_id) VALUES ('CLB003', 'OWN003', 'Manchester City',32, 'MNG003');
INSERT INTO club (club_id, owner_id, club_name, number_of_players, manager_id) VALUES ('CLB004', 'OWN004', 'Liverpool',30, 'MNG004');
INSERT INTO club (club_id, owner_id, club_name, number_of_players, manager_id) VALUES ('CLB005', 'OWN005', 'Tottenham',28, 'MNG005');
INSERT INTO club (club_id, owner_id, club_name, number_of_players, manager_id) VALUES ('CLB006', 'OWN006', 'Chelsea FC', 24, 'MNG006');

INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC001', 'CLB001', 'United Jersey 2024', 'River Brown','Apparel', 90);
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC002', 'CLB002', 'Barca Scarf 2024', 'Jamie Williams', 'Accessory', 20);
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC003', 'CLB003', 'Liverpool Mug', 'Casey Smith','Accessory', 15);
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC004', 'CLB004', 'Madrid Cap', 'Alex Brown','Accessory', 25);
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC005', 'CLB005', 'Milan Keychain', 'Morgan Williams', 'Accessory', 10);
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC006', 'CLB006', 'Chelsea Backpack', 'Jordan Davis','Apparel', 110);
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC007', 'CLB004', 'Madrid Flag', 'River Miller','Accessories', 18.00); 
INSERT INTO merchandise (item_no, club_id, item_name, buyer_name, category, price) VALUES ('MRC008', 'CLB004', 'Madrid Keychain', 'Jamie Miller','Accessories', 5.50); 

INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR001', 'CLB001', 'Striker', 30, 20, TO_DATE('1995-05-15', 'YYYY-MM-DD'), 'John', 'Doe', 9, 1000000, 10);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR002', 'CLB001', 'Midfielder', 28, 5, TO_DATE('1990-08-20', 'YYYY-MM-DD'), 'Alice', 'Smith', 7, 1200000, 8);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR003', 'CLB002', 'Defender', 32, 2, TO_DATE('1992-04-10', 'YYYY-MM-DD'), 'Michael', 'Johnson', 5, 900000, 5);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR004', 'CLB002', 'Striker', 27, 15, TO_DATE('1993-10-05', 'YYYY-MM-DD'), 'Emma', 'Williams', 11, 1500000, 12);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR005', 'CLB003', 'Midfielder', 29, 8, TO_DATE('1988-12-25', 'YYYY-MM-DD'), 'David', 'Brown', 6, 1100000, 9);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR006', 'CLB003', 'Defender', 31, 1, TO_DATE('1994-07-18', 'YYYY-MM-DD'), 'Sophia', 'Jones', 3, 800000, 3);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR007', 'CLB004', 'Striker', 33, 25, TO_DATE('1991-03-30', 'YYYY-MM-DD'), 'James', 'Wilson', 10, 2000000, 20);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR008', 'CLB004', 'Midfielder', 26, 6, TO_DATE('1996-01-12', 'YYYY-MM-DD'), 'Olivia', 'Martinez', 8, 1300000, 7);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR009', 'CLB005', 'Defender', 30, 0, TO_DATE('1997-09-08', 'YYYY-MM-DD'), 'Ethan', 'Garcia', 4, 850000, 2);



INSERT INTO player (player_id, club_id, player_type, number_of_matches, number_of_goals, birth_date, first_name, last_name, jersey_number, wages, number_of_assists)

VALUES ('PLR010', 'CLB005', 'Striker', 25, 18, TO_DATE('1998-11-22', 'YYYY-MM-DD'), 'Ava', 'Rodriguez', 9, 1700000, 15);

INSERT INTO club_data (club_id, number_of_trophies, number_of_wins, number_of_players_purchased, number_of_players_sold, club_budget) VALUES ('CLB001', 20, 600, 5, 3, 1000000);
INSERT INTO club_data (club_id, number_of_trophies, number_of_wins, number_of_players_purchased, number_of_players_sold, club_budget) VALUES ('CLB002', 25, 650, 4, 2, 1500000);
INSERT INTO club_data (club_id, number_of_trophies, number_of_wins, number_of_players_purchased, number_of_players_sold, club_budget) VALUES ('CLB003', 18, 550, 6, 4, 900000);
INSERT INTO club_data (club_id, number_of_trophies, number_of_wins, number_of_players_purchased, number_of_players_sold, club_budget) VALUES ('CLB004', 22, 620, 3, 1, 1200000);
INSERT INTO club_data (club_id, number_of_trophies, number_of_wins, number_of_players_purchased, number_of_players_sold, club_budget) VALUES ('CLB005', 17, 500, 7, 5, 800000);
INSERT INTO club_data (club_id, number_of_trophies, number_of_wins, number_of_players_purchased, number_of_players_sold, club_budget) VALUES ('CLB006', 19, 560, 2, 2, 950000);

INSERT INTO match_club (mat_club_id, match_id, club_id) VALUES ('MC001', 'MAT001', 'CLB001');
INSERT INTO match_club (mat_club_id, match_id, club_id) VALUES ('MC002', 'MAT001', 'CLB002');
INSERT INTO match_club (mat_club_id, match_id, club_id) VALUES ('MC003', 'MAT002', 'CLB003');
INSERT INTO match_club (mat_club_id, match_id, club_id) VALUES ('MC004', 'MAT002', 'CLB004');
INSERT INTO match_club (mat_club_id, match_id, club_id) VALUES ('MC005', 'MAT003', 'CLB005');
INSERT INTO match_club (mat_club_id, match_id, club_id) VALUES ('MC006', 'MAT003', 'CLB006');

INSERT INTO points_table (club_id, rank, matches_played, matches_won, matches_lost, matches_drawn, no_result, season_club_sk, season) VALUES ('CLB001', 1, 38, 30, 5, 3, 0, 'CLB001_2024', '2024');
INSERT INTO points_table (club_id, rank, matches_played, matches_won, matches_lost, matches_drawn, no_result, season_club_sk, season) VALUES ('CLB002', 2, 38, 28, 7, 3, 0, 'CLB002_2024', '2024');
INSERT INTO points_table (club_id, rank, matches_played, matches_won, matches_lost, matches_drawn, no_result, season_club_sk, season) VALUES ('CLB003', 3, 38, 26, 8, 4, 0, 'CLB003_2024', '2024');
INSERT INTO points_table (club_id, rank, matches_played, matches_won, matches_lost, matches_drawn, no_result, season_club_sk, season) VALUES ('CLB004', 4, 38, 25, 9, 4, 0, 'CLB004_2024', '2024');
INSERT INTO points_table (club_id, rank, matches_played, matches_won, matches_lost, matches_drawn, no_result, season_club_sk, season) VALUES ('CLB005', 5, 38, 24, 10, 4, 0, 'CLB005_2024', '2024');
INSERT INTO points_table (club_id, rank, matches_played, matches_won, matches_lost, matches_drawn, no_result, season_club_sk, season) VALUES ('CLB006', 6, 38, 23, 11, 4, 0, 'CLB006_2024', '2024');

INSERT INTO refree (refree_id, first_name, last_name, years_of_experience, number_of_games_officiated, number_of_red_cards) VALUES ('REF001', 'Mark', 'Clattenburg', 12, 300, 25);
INSERT INTO refree (refree_id, first_name, last_name, years_of_experience, number_of_games_officiated, number_of_red_cards) VALUES ('REF002', 'Howard', 'Webb', 15, 400, 30);
INSERT INTO refree (refree_id, first_name, last_name, years_of_experience, number_of_games_officiated, number_of_red_cards) VALUES ('REF003', 'Pierluigi', 'Collina', 20, 500, 5);
INSERT INTO refree (refree_id, first_name, last_name, years_of_experience, number_of_games_officiated, number_of_red_cards) VALUES ('REF004', 'Felix', 'Brych', 10, 250, 20);
INSERT INTO refree (refree_id, first_name, last_name, years_of_experience, number_of_games_officiated, number_of_red_cards) VALUES ('REF005', 'Cüneyt', 'Çakır', 13, 350, 22);
INSERT INTO refree (refree_id, first_name, last_name, years_of_experience, number_of_games_officiated, number_of_red_cards) VALUES ('REF006', 'Björn', 'Kuipers', 14, 320, 18);

INSERT INTO match_refree (mat_ref_sk, match_id, refree_id) VALUES ('MREF001', 'MAT001', 'REF001');
INSERT INTO match_refree (mat_ref_sk, match_id, refree_id) VALUES ('MREF002', 'MAT001', 'REF002');
INSERT INTO match_refree (mat_ref_sk, match_id, refree_id) VALUES ('MREF003', 'MAT002', 'REF003');
INSERT INTO match_refree (mat_ref_sk, match_id, refree_id) VALUES ('MREF004', 'MAT002', 'REF004');
INSERT INTO match_refree (mat_ref_sk, match_id, refree_id) VALUES ('MREF005', 'MAT003', 'REF005');
INSERT INTO match_refree (mat_ref_sk, match_id, refree_id) VALUES ('MREF006', 'MAT003', 'REF006');

INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK001', 'STD001', 50, 101, 'Standard', TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Sold', 'Credit Card', 'John Doe', 'MAT001');
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK002', 'STD002', 55, 102, 'Standard', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 'Sold', 'Debit Card', 'Alice Johnson', 'MAT002');
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK003', 'STD003', 60, 103, 'Premium', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Available', 'Cash', 'Bob Smith', 'MAT003');
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK004', 'STD001', 65, 104, 'VIP', TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Available', 'Credit Card', 'Carol White', 'MAT001');
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK005', 'STD002', 50, 105, 'Standard', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 'Sold', 'Credit Card', 'Dave Green', 'MAT002');
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK006', 'STD003', 55, 106, 'Standard', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Sold', 'Debit Card', 'Eva Black', 'MAT003');
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK007', 'STD001', 75, 104, 'Regular', TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Available', 'Credit Card', 'Alicia Joe', 'MAT001'); 
INSERT INTO ticket (ticket_id, stadium_id, ticket_price, seat_number, ticket_type, sale_date, ticket_status, payment_method, buyer_name, match_id) VALUES ('TCK008', 'STD002', 85, 204, 'Premium', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 'Available', 'Credit Card', 'Mary Jane', 'MAT002');

INSERT INTO match_stat (match_id, match_goals, match_penalties, match_fouls) VALUES ('MAT001', 4, 1, 10);
INSERT INTO match_stat (match_id, match_goals, match_penalties, match_fouls) VALUES ('MAT002', 4, 0, 12);
INSERT INTO match_stat (match_id, match_goals, match_penalties, match_fouls) VALUES ('MAT003', 1, 0, 8);
INSERT INTO match_stat (match_id, match_goals, match_penalties, match_fouls) VALUES ('MAT004', 4, 1, 11);
INSERT INTO match_stat (match_id, match_goals, match_penalties, match_fouls) VALUES ('MAT005', 4, 0, 9);
INSERT INTO match_stat (match_id, match_goals, match_penalties, match_fouls) VALUES ('MAT006', 2, 0, 10);

commit;

--ticket sales per match view
CREATE VIEW ticket_sales_match_wise AS
SELECT
  m.match_id,
  m.match_date,
  s.stadium_name,
  s.city,
  COUNT(t.ticket_id) AS tickets_sold
FROM app_admin.match m
JOIN app_admin.stadium s ON m.stadium_id = s.stadium_id
JOIN app_admin.ticket t ON m.match_id = t.match_id
GROUP BY m.match_id, m.match_date, s.stadium_name, s.city
ORDER BY m.match_date;

--revenue of the club through merchandise
CREATE VIEW revenue_of_the_club_through_merchandise AS
SELECT
  c.club_id,
  c.club_name,
  SUM(m.price) AS total_revenue,
  COUNT(m.item_no) AS items_sold,
  (SELECT category FROM app_admin.merchandise m2 WHERE m2.club_id = c.club_id GROUP BY m2.category ORDER BY COUNT(*) DESC FETCH FIRST 1 ROW ONLY) AS top_selling_category
FROM app_admin.club c
JOIN app_admin.merchandise m ON c.club_id = m.club_id
GROUP BY c.club_id, c.club_name
ORDER BY total_revenue DESC;

-- player_PerformanceTrack_Attacker_Individual_View
CREATE or REPLACE VIEW player_Performance_View 
AS 
SELECT 
pl.first_name || ' '|| pl.last_name as NAME, 
pl.number_of_matches as Total_Played,
pl.number_of_goals as Total_Goals_Scored,
pl.number_of_assists as Total_Assists,
pl.jersey_number as Jersey,
pl.player_type as Player_Role,
ca.number_of_trophies as Milestones,
ca.number_of_wins  as Wins
from 
player pl 
join
club_data ca ON pl.club_id = ca.club_id;

--match summary view
CREATE VIEW match_summary_view AS
SELECT
  m.match_id,
  m.match_date,
  m.time,
  s.stadium_name,
  mc.club_id,
  ms.match_goals,
  ms.match_penalties,
  ms.match_fouls,
  pt.rank AS club_position_in_the_points_table
FROM app_admin.match m
JOIN app_admin.stadium s ON m.stadium_id = s.stadium_id
JOIN app_admin.match_stat ms ON m.match_id = ms.match_id
JOIN app_admin.match_club mc ON m.match_id = mc.match_id
JOIN app_admin.points_table pt ON mc.club_id = pt.club_id
GROUP BY m.match_id, m.match_date, m.time, s.stadium_name, mc.club_id, ms.match_goals, ms.match_penalties, ms.match_fouls, pt.rank
ORDER BY m.match_date, m.time;

-- View to calculate revenue for each item sold
CREATE VIEW Merchandise_Items_View AS
SELECT 
    m.club_id,
    m.item_name,
    m.price,
    COUNT(*) AS quantity_sold,
    COUNT(*) * m.price AS total_revenue
FROM 
    app_admin.merchandise m
GROUP BY 
    m.item_no, m.club_id, m.item_name, m.price;

--This view categorizes merchandise items based on their price range, which can help with pricing strategies.
CREATE OR REPLACE VIEW MerchandisePriceRange AS
SELECT
    CASE
        WHEN price < 50 THEN 'Low Price'
        WHEN price BETWEEN 50 AND 100 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_range,
    COUNT(*) AS count
FROM app_admin.merchandise
GROUP BY
    CASE
        WHEN price < 50 THEN 'Low Price'
        WHEN price BETWEEN 50 AND 100 THEN 'Medium Price'
        ELSE 'High Price'
    END;
    
CREATE VIEW team_Roaster AS
SELECT 
    p.first_name || ' ' || p.last_name as player_name,
    p.jersey_number,
    p.player_type,
    p.birth_date,
    c.club_name,
    m.first_name || ' ' || m.last_name as manager_name, 
    o.first_name || ' ' || o.last_name as owner_name
FROM player p
JOIN club c ON p.club_id = c.club_id
JOIN manager m ON c.manager_id = m.manager_id
JOIN owner o ON c.owner_id = o.owner_id;

-- granting permissions
GRANT SELECT ON ticket_sales_match_wise TO app_analyst;
GRANT SELECT ON match_summary_view TO app_analyst;
GRANT SELECT ON revenue_of_the_club_through_merchandise TO app_analyst;
GRANT SELECT ON player_Performance_View TO app_analyst;
GRANT SELECT ON Merchandise_Items_View TO app_analyst;
GRANT SELECT ON MerchandisePriceRange TO app_analyst;
GRANT SELECT ON team_Roaster TO app_analyst;

