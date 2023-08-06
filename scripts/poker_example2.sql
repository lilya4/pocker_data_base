-- Посмотрим распределение денег на счету у наших пользователей
SELECT balance, COUNT(*)
FROM pk.players
GROUP BY balance
HAVING COUNT(*) > 1;


-- Средний баланс игроков, которые выигрывают больше остальных
SELECT AVG(balance) AS avg_balance
FROM pk.players
WHERE player_id IN (SELECT player_id
                    FROM pk.winners
                    GROUP BY player_id
                    ORDER BY SUM(winning_amt - bet) DESC
                    LIMIT 10);


-- Найдем на какую сумму провели транзакций пользователи, которые имеют их более N штук (N = 0)
SELECT DISTINCT pl.username    AS player,
                SUM(tr.amount) AS total_amount
FROM pk.transactions as tr
         JOIN pk.players as pl USING (player_id)
GROUP BY pl.username
HAVING COUNT(tr.transaction_id) > 0
ORDER BY total_amount DESC;

-- Сколько транзакций провел каждый игрок и сколько всего проведено в системе
SELECT DISTINCT username,
                COUNT(*) OVER (PARTITION BY player_id) AS player_transactions_cnt,
                COUNT(*) OVER ()                       AS total_transactions_cnt
FROM pk.transactions
         JOIN pk.players USING (player_id)
ORDER BY player_transactions_cnt DESC;

-- Стол - ID игрока (сессии) - сколько игроков за столом - позиция нашего игрока (player_id = 1)
SELECT table_id,
       players_at_the_table_id,
       COUNT(*) OVER (PARTITION BY table_id) AS players_cnt,
       pos_num
FROM pk.players_at_the_table
         JOIN pk.players_sessions USING (players_at_the_table_id)
WHERE player_id = 1;

-- Самая большая и маленькая транзакция каждого игрока (по сути - самое большое зачисление и самое большое списание)
SELECT DISTINCT player_id,
                MAX(amount) OVER (PARTITION BY player_id) AS max_amount,
                MIN(amount) OVER (PARTITION BY player_id) AS min_amount
FROM pk.transactions
ORDER BY max_amount DESC, player_id;

-- Проранжируем игроков по силе. В чем сила? В балансе!
SELECT RANK() OVER (ORDER BY balance DESC) AS balance_rank,
       username,
       balance
FROM pk.players;

-- посмотрим, сколько выиграл каждый игрок за последние 10 игр
SELECT winner_id,
       SUM(winning_amt - bet)
       OVER (PARTITION BY winner_id ROWS BETWEEN 10 PRECEDING AND CURRENT ROW) AS last_10_games
FROM pk.winners
ORDER BY last_10_games DESC, winner_id;
