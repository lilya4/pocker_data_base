-- Однажды Эрнест Хемингуэй поспорил...

INSERT INTO pk.players (player_id, first_name, last_name, email, username, password)
VALUES (1111, 'John', 'Doe', 'john_doe@gmail.com', 'john_doe', '12345');

INSERT INTO pk.bank_accounts (bank_account_id)
VALUES (1111);

INSERT INTO pk.transactions (transaction_id, bank_account_id, player_id, amount)
VALUES (1111, 1111, 1111, 1000);

SELECT blocked_flg
FROM pk.bank_accounts
WHERE bank_account_id = 1111;

UPDATE pk.transactions
SET status = 'SUCCESS'
WHERE transaction_id = 1111;

UPDATE pk.bank_accounts
SET money_amt = 1000
WHERE bank_account_id = 1111;

UPDATE pk.players
SET balance = 1000
WHERE player_id = 1111;

UPDATE pk.bank_accounts
SET blocked_flg = TRUE
WHERE bank_account_id = 1111;

DELETE
FROM pk.transactions
WHERE transaction_dttm < '2024-01-01 00:00:00';

INSERT INTO pk.transactions (transaction_id, bank_account_id, player_id, amount)
VALUES (1112, 1111, 1111, -1000);

SELECT blocked_flg
FROM pk.bank_accounts
WHERE bank_account_id = 1111;

UPDATE pk.transactions
SET status = 'FAILED'
WHERE transaction_id = 1112;

-------------------------------------------------------------------------------------

INSERT INTO pk.players (player_id, first_name, last_name, email, username, password)
VALUES (1112, 'Max', 'Payne', 'max_payne@gmail.com', 'max_flash', '12345'),
       (1113, 'John', 'Doe', 'john_doe@gmail.com', 'john_full_house', '12345');

INSERT INTO pk.bank_accounts (bank_account_id)
VALUES (1112);

INSERT INTO pk.transactions (transaction_id, bank_account_id, player_id, amount)
VALUES (1113, 1112, 1112, 10000),
       (1114, 1112, 1112, 10000);

SELECT blocked_flg
FROM pk.bank_accounts
WHERE bank_account_id = 1112;

UPDATE pk.transactions
SET status = 'SUCCESS'
WHERE transaction_id = 1113
   OR transaction_id = 1114;

UPDATE pk.bank_accounts
SET money_amt = 10000
WHERE bank_account_id = 1112;

UPDATE pk.players
SET balance = 10000
WHERE player_id = 1112
   OR player_id = 1113;

INSERT INTO pk.games (game_id, limits, type, max_players_cnt, chip_cost)
VALUES (1111, 1000, 'HOLDEM', 2, 100);

INSERT INTO pk.tables (table_id, game_id, dealer_pos, table_cards, bank_amt)
VALUES (1111, 1111, 1, '2H 3H 4H 5H 6H', 1000);

INSERT INTO pk.players_at_the_table (players_at_the_table_id, chips_cnt, bet, cards, pos_num)
VALUES (1111, 10000, 0, '7H 2C', 1),
       (1112, 10000, 0, 'AC AS', 2);

INSERT INTO pk.players_sessions (player_id, table_id, players_at_the_table_id)
VALUES (1112, 1111, 1111),
       (1113, 1111, 1112);

SELECT *
FROM pk.players_at_the_table;

UPDATE pk.players_at_the_table
SET bet = 100
WHERE players_at_the_table_id = 1111;

UPDATE pk.players_at_the_table
SET bet = 500
WHERE players_at_the_table_id = 1112;

UPDATE pk.players_at_the_table
SET bet = 10000
WHERE players_at_the_table_id = 1111;

UPDATE pk.players_at_the_table
SET bet = 10000
WHERE players_at_the_table_id = 1112;

INSERT INTO pk.results (result_id, table_id, dealer_pos, table_cards, bank_amt)
VALUES (1111, 1111, 1, '2H 3H 4H 5H 6H', 20000);

INSERT INTO pk.players_results (results_id, player_id, winner_id)
VALUES (1111, 1112, 1112),
       (1111, 1113, 1112);

INSERT INTO pk.winners (winner_id, bet, cards, winning_amt)
VALUES (1112, 10000, '7H 2C', 20000),
       (1113, 10000, 'AC AS', 0);

UPDATE pk.players_at_the_table
SET chips_cnt = 20000
WHERE players_at_the_table_id = 1111;

UPDATE pk.players_at_the_table
SET chips_cnt = 0
WHERE players_at_the_table_id = 1112;

DELETE
FROM pk.players_sessions
WHERE players_at_the_table_id = 1112;
DELETE
FROM pk.players_at_the_table
WHERE players_at_the_table_id = 1112;

UPDATE pk.players
SET balance = 20000
WHERE player_id = 1112;
UPDATE pk.players
SET balance = 0
WHERE player_id = 1113;

UPDATE pk.tables
SET bank_amt    = 0,
    table_cards = '',
    dealer_pos  = 2
WHERE table_id = 1111;

DELETE
FROM pk.players_sessions
WHERE players_at_the_table_id = 1111;

DELETE
FROM pk.players_at_the_table
WHERE players_at_the_table_id = 1111;

DELETE
FROM pk.players
WHERE player_id = 1113;

INSERT INTO pk.transactions (transaction_id, bank_account_id, player_id, amount)
VALUES (1115, 1112, 1112, -20000);

SELECT blocked_flg
FROM pk.bank_accounts
WHERE bank_account_id = 1112;

SELECT balance FROM pk.players
WHERE player_id = 1112;

UPDATE pk.transactions
SET status = 'SUCCESS'
WHERE transaction_id = 1115;

UPDATE pk.bank_accounts
SET money_amt = 0
WHERE bank_account_id = 1112;

UPDATE pk.players
SET balance = 0
WHERE player_id = 1112;

-------------------------------------------------------------------------------------

-- посмотрим на средний баланс игроков в разрезе регистрации по годам
SELECT EXTRACT(YEAR FROM registration_date) AS year,
       ROUND(AVG(balance), 2) AS avg_balance
FROM pk.players
GROUP BY year;

-- посмотрим на средний баланс игроков в разрезе регистрации по месяцам
SELECT registration_date,
       ROUND(AVG(balance), 2) AS avg_balance
FROM pk.players
group by registration_date;

-- посмотрим на топ10 выигрышных карт на руках
SELECT cards,
       SUM(winning_amt) AS winning_amt
FROM pk.winners
WHERE cards IS NOT NULL
GROUP BY cards
ORDER BY winning_amt DESC
LIMIT 10;

-- посмотрим сколько игроков сейчас за столами на разных лимитах
SELECT limits,
       COUNT(DISTINCT player_id) AS players_cnt
FROM pk.players_sessions
JOIN pk.tables USING (table_id)
JOIN pk.games USING (game_id)
GROUP BY limits
ORDER BY players_cnt DESC;

-- посмотрим на топ10 самых выигрышных игроков
SELECT player_id,
       username,
       SUM(winning_amt) AS winning_amt
FROM pk.winners
    JOIN pk.players_results USING (winner_id)
    JOIN pk.players USING (player_id)
GROUP BY player_id, username
ORDER BY winning_amt DESC
LIMIT 10;

-- посмотрим на топ10 самых проигрышных игроков
SELECT player_id,
       username,
       SUM(winning_amt) AS winning_amt
FROM pk.winners
    JOIN pk.players_results USING (winner_id)
    JOIN pk.players USING (player_id)
GROUP BY player_id, username
ORDER BY winning_amt ASC
LIMIT 10;

-- посмотрим на популярность различных типов игр (считаем по количеству игроков)
SELECT type,
       COUNT(DISTINCT player_id) AS players_cnt
FROM pk.players_sessions
JOIN pk.tables USING (table_id)
JOIN pk.games USING (game_id)
GROUP BY type
ORDER BY players_cnt DESC;

-- посмотрим на популярность различных типов игр (считаем по количеству доступных столов)
SELECT type,
       COUNT(DISTINCT table_id) AS tables_cnt
FROM pk.tables
JOIN pk.games USING (game_id)
GROUP BY type
ORDER BY tables_cnt DESC;