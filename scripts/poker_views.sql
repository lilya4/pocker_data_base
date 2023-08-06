-- для пользователя скрываем его личные данные вроде электронной имени, фамилии, электронной почты и пароля
CREATE OR REPLACE VIEW pk.players_view AS
SELECT player_id,
       CONCAT(REPEAT('#', CHAR_LENGTH(first_name))) AS first_name,
       CONCAT(REPEAT('#', CHAR_LENGTH(last_name)))  AS last_name,
       CONCAT(REPEAT('#', CHAR_LENGTH(SPLIT_PART(email, '@', 1))),
              '@',
              SPLIT_PART(email, '@', 2))            AS email, -- скрываем часть email до @
       username,
       '********'                                   AS password,
       registration_date,
       balance
FROM pk.players;


-- для pk.players_at_the_table скрываем карты игроков
CREATE OR REPLACE VIEW pk.players_at_the_table_view AS
SELECT table_id,
       player_id,
       '## ##' AS cards,
       bet,
       pos_num,
       chips_cnt
FROM pk.players_at_the_table
         JOIN pk.players_sessions USING (players_at_the_table_id);

-- view для хранения результатов игроков
CREATE OR REPLACE VIEW pk.players_results_view AS
SELECT p.username,
       (pr.winning_amt - pr.bet) AS winning_amt,
       pr.result_dttm
FROM pk.players p
         JOIN (SELECT pr.player_id,
                      w.winning_amt,
                      w.bet,
                      r.result_dttm
               FROM pk.players_results pr
                        JOIN pk.results r ON pr.results_id = r.result_id
                        JOIN pk.winners w USING (winner_id)
               WHERE pr.winner_id IS NOT NULL) pr ON p.player_id = pr.player_id
ORDER BY p.username;

-- view для отображения столов и числа игроков за ними
CREATE OR REPLACE VIEW pk.tables_view AS
SELECT t.table_id,
       g.type                                     as game_type,
       COUNT(DISTINCT ps.players_at_the_table_id) AS current_players_cnt,
       g.max_players_cnt
FROM pk.tables t
         JOIN pk.players_sessions ps USING (table_id)
         JOIN pk.games g USING (game_id)
GROUP BY t.table_id, g.type, g.max_players_cnt;


select *
from pk.tables_view;

-- Полное view игрок - стол в котором отображаются все данные
-- table_id, player_id, username, bet, chips_cnt, cards, table_cards, game_type, bank
CREATE OR REPLACE VIEW pk.players_at_the_table_full_view AS
SELECT t.table_id,
       ps.player_id,
       p.username,
       pt.bet,
       pt.chips_cnt,
       pt.cards,
       t.table_cards,
       g.type,
       t.bank_amt
FROM pk.tables t
         JOIN pk.players_sessions ps USING (table_id)
         JOIN pk.players_at_the_table pt USING (players_at_the_table_id)
         JOIN pk.players p USING (player_id)
         JOIN pk.games g USING (game_id);


-- view для отображения прихода - ухода для каждого bank_account за каждый день (смотрим по успешным транзакциям)
CREATE OR REPLACE VIEW pk.bank_account_transactions_view AS
SELECT
    DATE(transaction_dttm) AS transaction_date,
    bank_account_id,
    SUM(CASE WHEN status = 'SUCCESS' AND amount >= 0 THEN amount ELSE 0 END) AS incoming,
    SUM(CASE WHEN status = 'SUCCESS' AND amount < 0 THEN amount ELSE 0 END) AS outgoing
FROM
    pk.transactions
GROUP BY
    transaction_date,
    bank_account_id
ORDER BY transaction_date, bank_account_id;
