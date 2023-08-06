-- Заполняем таблицы данными ---

INSERT INTO pk.players (player_id, first_name, last_name, email, username, password, balance)
VALUES (1, 'John', 'Doe', 'johndoe@example.com', 'johndoe', 'password123', 1000),
       (2, 'Jane', 'Doe', 'janedoe@example.com', 'janedoe', 'password456', 500),
       (3, 'Bob', 'Smith', 'bobsmith@example.com', 'bobsmith', 'password789', 250),
       (4, 'Alice', 'Johnson', 'alicejohnson@example.com', 'alicejohnson', 'password123', 750),
       (5, 'Mike', 'Brown', 'mikebrown@example.com', 'mikebrown', 'password456', 100),
       (6, 'Sara', 'Lee', 'saralee@example.com', 'saralee', 'password789', 1500),
       (7, 'Tom', 'Wilson', 'tomwilson@example.com', 'tomwilson', 'password123', 2000),
       (8, 'Emily', 'Davis', 'emilydavis@example.com', 'emilydavis', 'password456', 300),
       (9, 'David', 'Taylor', 'davidtaylor@example.com', 'davidtaylor', 'password789', 50),
       (10, 'Olivia', 'Johnson', 'oliviajohnson@example.com', 'oliviajohnson', 'password123', 1250);

INSERT INTO pk.games (game_id, limits, type, max_players_cnt, chip_cost)
VALUES (1, 100, 'HOLDEM', 9, 10.00),
       (2, 200, 'OMAHA', 6, 20.00),
       (3, 50, 'SEVEN_CARD_STUD', 8, 5.00),
       (4, 500, 'SHORT_DECK', 4, 50.00),
       (5, 1000, 'OMAHA_HI_LO', 9, 100.00),
       (6, 2000, 'SEVEN_CARD_STUD_HI_LO', 7, 200.00),
       (7, 250, 'HOLDEM', 6, 25.00),
       (8, 100, 'OMAHA', 8, 10.00),
       (9, 5000, 'SHORT_DECK', 6, 500.00),
       (10, 10000, 'HOLDEM', 9, 1000.00);

INSERT INTO pk.tables (table_id, game_id, dealer_pos, table_cards, bank_amt)
VALUES (1, 1, 2, '2H 3D 4C 5S 6H', 500),
       (2, 3, 5, '10S QD KC 4H 2C', 250),
       (3, 7, 1, 'AS KS QS JS 10S', 1000),
       (4, 2, 8, 'AD 2C 3H 4S 5D', 750),
       (5, 5, 3, '8H 9D 10C JD QS', 1500),
       (6, 4, 0, 'AH KH QD JD 10H', 2000),
       (7, 6, 7, '2D 3C 4H 5S 6D', 5000),
       (8, 8, 4, '7H 8D 9C 10S JS', 100),
       (9, 9, 6, 'KD QD JD 10D 9D', 50000),
       (10, 10, 2, 'AC KC QC JC 10C', 100000);

INSERT INTO pk.players_at_the_table (players_at_the_table_id, chips_cnt, bet, cards, pos_num)
VALUES (1, 100, 10.00, '2S 3C', 1),
       (2, 200, 20.00, '4H 5D', 2),
       (3, 300, 30.00, '6C 7D', 3),
       (4, 400, 40.00, '8C 9S', 4),
       (5, 500, 50.00, '10H JD', 5),
       (6, 600, 60.00, 'QC KS', 6),
       (7, 700, 70.00, 'AH 2D', 5),
       (8, 800, 80.00, '3C 4H', 4),
       (9, 900, 90.00, '5D 6C', 3),
       (10, 1000, 100.00, '7H 8D', 2);

INSERT INTO pk.players_sessions (player_id, table_id, players_at_the_table_id)
VALUES (1, 1, 1),
       (2, 1, 2),
       (3, 1, 3),
       (4, 1, 4),
       (5, 1, 5),
       (6, 2, 6),
       (7, 2, 7),
       (8, 2, 8),
       (9, 2, 9),
       (10, 2, 10);

INSERT INTO pk.results (result_id, table_id, dealer_pos, table_cards, bank_amt)
VALUES (1, 1, 2, '2H 3D 4C 5S 6H', 500),
       (2, 2, 5, '10S QD KC 4H 2C', 250),
       (3, 3, 1, 'AS KS QS JS 10S', 1000),
       (4, 4, 8, 'AD 2C 3H 4S 5D', 750),
       (5, 5, 3, '8H 9D 10C JD QS', 1500),
       (6, 6, 0, 'AH KH QD JD 10H', 2000),
       (7, 7, 7, '2D 3C 4H 5S 6D', 5000),
       (8, 8, 4, '7H 8D 9C 10S JS', 100),
       (9, 9, 6, 'KD QD JD 10D 9D', 50000),
       (10, 10, 2, 'AC KC QC JC 10C', 100000);

INSERT INTO pk.players_results (results_id, player_id, winner_id)
VALUES (1, 1, 1),
       (1, 2, 1),
       (1, 3, 1),
       (1, 4, 1),
       (1, 5, 1),
       (2, 6, 2),
       (2, 7, 2),
       (2, 8, 2),
       (2, 9, 2),
       (2, 10, 2);

INSERT INTO pk.winners (winner_id, bet, cards, winning_amt)
VALUES (1, 50.00, 'AH 2D', 500),
       (2, 100.00, 'QC KS', 1000),
       (3, 150.00, '7H 8D', 1500),
       (4, 200.00, '5D 6C', 2000),
       (5, 250.00, '3C 4H', 2500),
       (6, 300.00, '10H JD', 3000),
       (7, 350.00, '8C 9S', 3500),
       (8, 400.00, '6H 7D', 4000),
       (9, 450.00, '4C 5S', 4500),
       (10, 500.00, '2H 3D', 5000);

INSERT INTO pk.bank_accounts (bank_account_id, money_amt, open_date, blocked_flg)
VALUES (1, 10000, CURRENT_DATE, FALSE),
       (2, 5000, CURRENT_DATE, FALSE),
       (3, 2000, CURRENT_DATE, FALSE),
       (4, 1000, CURRENT_DATE, FALSE),
       (5, 500, CURRENT_DATE, FALSE),
       (6, 250, CURRENT_DATE, FALSE),
       (7, 100, CURRENT_DATE, FALSE),
       (8, 50, CURRENT_DATE, FALSE),
       (9, 25, CURRENT_DATE, FALSE),
       (10, 10, CURRENT_DATE, FALSE);

INSERT INTO pk.transactions (transaction_id, bank_account_id, player_id, amount)
VALUES (1, 1, 1, 500),
       (2, 2, 2, 250),
       (3, 3, 3, 100),
       (4, 4, 4, 50),
       (5, 5, 5, 25),
       (6, 6, 6, 10),
       (7, 7, 7, 5),
       (8, 8, 8, 2.50),
       (9, 9, 9, 1),
       (10, 10, 10, 0.50);