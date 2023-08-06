import decimal
import unittest
from cursor import execute_query


###########################################
#                ЗАДАНИЕ 7                #
# Тесты написаны с учетом запуска пунктов #
#        до п6 и никаких больше.          #
###########################################

class TestQueries(unittest.TestCase):
    # Посмотрим распределение денег на счету у наших пользователей
    def test_balance_distribution(self):
        query = "SELECT balance, COUNT(*) FROM pk.players GROUP BY balance HAVING COUNT(*) > 1;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 1)
        # Проверяем, что каждая строка содержит два значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце (Decimal и int)
            self.assertIsInstance(row[0], decimal.Decimal)
            self.assertIsInstance(row[1], int)

        print('Tests of balance distribution finished')

    # Средний баланс игроков, которые выигрывают больше остальных
    def test_average_balance(self):
        query = "SELECT AVG(balance) AS avg_balance FROM pk.players WHERE player_id IN (SELECT player_id FROM pk.winners GROUP BY player_id ORDER BY SUM(winning_amt - bet) DESC LIMIT 10);"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем что результат - 1 число, 1 столбец и число 750
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 1)
        self.assertIsInstance(result[0], tuple)
        self.assertEqual(len(result[0]), 1)
        self.assertEqual(float(result[0][0]), 725.0)

        print('Tests of average balance finished')

    # Найдем на какую сумму провели транзакций пользователи, которые имеют их более N штук (N = 0)
    def test_total_transaction_amount(self):
        query = "SELECT DISTINCT pl.username AS player, SUM(tr.amount) AS total_amount FROM pk.transactions as tr JOIN pk.players as pl USING (player_id) GROUP BY pl.username HAVING COUNT(tr.transaction_id) > 0 ORDER BY total_amount DESC;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 12)
        # Проверяем, что каждая строка содержит два значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], decimal.Decimal)

        print('Tests of total transaction amount finished')

    # Сколько транзакций провел каждый игрок и сколько всего проведено в системе
    def test_transaction_count(self):
        query = "SELECT DISTINCT username, COUNT(*) OVER (PARTITION BY player_id) AS player_transactions_cnt, COUNT(*) OVER () AS total_transactions_cnt FROM pk.transactions JOIN pk.players USING (player_id) ORDER BY player_transactions_cnt DESC;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 12)
        # Проверяем, что каждая строка содержит три значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], str)
            self.assertIsInstance(row[1], int)
            self.assertIsInstance(row[2], int)

        print('Tests of transaction count finished')

    # Стол - ID игрока (сессии) - сколько игроков за столом - позиция нашего игрока (player_id = 1)
    def test_player_position(self):
        query = "SELECT table_id, players_at_the_table_id, COUNT(*) OVER (PARTITION BY table_id) AS players_cnt, pos_num FROM pk.players_at_the_table JOIN pk.players_sessions USING (players_at_the_table_id) WHERE player_id = 1;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 1)
        # Проверяем, что каждая строка содержит четыре значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 4)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], int)
            self.assertIsInstance(row[1], int)
            self.assertIsInstance(row[2], int)
            self.assertIsInstance(row[3], int)

        print('Tests of player position finished')

    # Самая большая и маленькая транзакция каждого игрока (по сути - самое большое зачисление и самое большое списание)
    def test_max_min_transactions(self):
        query = "SELECT DISTINCT player_id, MAX(amount) OVER (PARTITION BY player_id) AS max_amount, MIN(amount) OVER (PARTITION BY player_id) AS min_amount FROM pk.transactions ORDER BY max_amount DESC, player_id;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 12)
        # Проверяем, что каждая строка содержит три значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], int)
            self.assertIsInstance(row[1], decimal.Decimal)
            self.assertIsInstance(row[2], decimal.Decimal)

        print('Tests of max and min transactions finished')

    # Проранжируем игроков по балансу
    def test_balance_ranking(self):
        query = "SELECT RANK() OVER (ORDER BY balance DESC) AS balance_rank, username, balance FROM pk.players;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 12)
        # Проверяем, что каждая строка содержит три значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 3)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], int)
            self.assertIsInstance(row[1], str)
            self.assertIsInstance(row[2], decimal.Decimal)

        print('Tests of balance ranking finished')

    # Посмотрим, сколько выиграл каждый игрок за последние 10 игр
    def test_last_10_games_winnings(self):
        query = "SELECT winner_id, SUM(winning_amt - bet) OVER (PARTITION BY winner_id ROWS BETWEEN 10 PRECEDING AND CURRENT ROW) AS last_10_games FROM pk.winners ORDER BY last_10_games DESC, winner_id;"
        result = execute_query(query)
        self.assertIsNotNone(result)
        # Проверяем тип данных и количество столбцов
        self.assertIsInstance(result, list)
        self.assertEqual(len(result), 12)
        # Проверяем, что каждая строка содержит два значения
        for row in result:
            self.assertIsInstance(row, tuple)
            self.assertEqual(len(row), 2)
            # Проверяем типы данных в каждом столбце
            self.assertIsInstance(row[0], int)
            self.assertIsInstance(row[1], decimal.Decimal)

        print('Tests of last 10 games winnings finished')


# Запуск тестов
if __name__ == '__main__':
    unittest.main()
    print('Tests finished')
