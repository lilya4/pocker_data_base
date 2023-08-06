import unittest
from cursor import execute_query


class ViewTests(unittest.TestCase):

    def test_players_view(self):
        query = "SELECT * FROM pk.players_view"
        result = execute_query(query)

        # проверяем количество строк
        self.assertEqual(len(result), 12)

        # проверяем все ли скрылось правильно
        self.assertEqual(result[0][1], '####')  # first_name
        self.assertEqual(result[0][2], '###')  # last_name
        self.assertEqual(result[0][3], '#######@example.com')  # email
        self.assertEqual(result[0][5], '********')  # password

    def test_players_at_the_table_view(self):
        query = "SELECT * FROM pk.players_at_the_table_view"
        result = execute_query(query)

        # проверяем количество строк
        self.assertEqual(len(result), 10)

        # проверяем равенство первой строки с ожидаемой
        self.assertEqual(result[0][0], 1)  # table_id
        self.assertEqual(result[0][1], 1)  # player_id
        self.assertEqual(result[0][2], '## ##')  # cards
        self.assertEqual(result[0][3], 10)  # bet
        self.assertEqual(result[0][4], 1)  # pos_num
        self.assertEqual(result[0][5], 100)  # chips_cnt

    def test_players_results_view(self):
        query = "SELECT * FROM pk.players_results_view"
        result = execute_query(query)

        # проверяем количество строк
        self.assertEqual(len(result), 11)

        # проверяем равенство первой строки с ожидаемой
        self.assertEqual(result[0][0], 'alicejohnson')  # username
        self.assertEqual(result[0][1], 450)  # winning_amt
        self.assertEqual(str(result[0][2]), '2023-05-20 12:32:39.385866')  # result_dttm

    def test_tables_view(self):
        query = "SELECT * FROM pk.tables_view"
        result = execute_query(query)

        # проверяем количество строк
        self.assertEqual(len(result), 2)

        # проверяем равенство первой строки с ожидаемой
        self.assertEqual(result[0][0], 1)  # table_id
        self.assertEqual(result[0][1], 'HOLDEM')  # type
        self.assertEqual(result[0][2], 5)  # current_players_cnt
        self.assertEqual(result[0][3], 9)  # max_players_cnt

    def test_players_at_the_table_full_view(self):
        query = "SELECT * FROM pk.players_at_the_table_full_view"
        result = execute_query(query)

        # проверяем количество строк
        self.assertEqual(len(result), 10)

        # проверяем равенство первой строки с ожидаемой
        self.assertEqual(int(result[0][0]), 1)  # table_id
        self.assertEqual(result[0][1], 1)  # player_id
        self.assertEqual(result[0][2], 'johndoe')  # username
        self.assertEqual(result[0][3], 10)  # bet
        self.assertEqual(result[0][4], 100)  # chips_cnt
        self.assertEqual(result[0][5], '2S 3C')  # cards
        self.assertEqual(result[0][6], '2H 3D 4C 5S 6H')  # table_cards
        self.assertEqual(result[0][7], 'HOLDEM')  # type
        self.assertEqual(result[0][8], 500)  # bank_amt

    def test_bank_account_transactions_view(self):
        query = "SELECT * FROM pk.bank_account_transactions_view"
        result = execute_query(query)

        # проверяем количество строк
        self.assertEqual(len(result), 12)

        # проверяем равенство первой строки с ожидаемой
        self.assertEqual(str(result[0][0]), '2023-05-20')  # transaction_date
        self.assertEqual(result[0][1], 1)  # bank_account_id
        self.assertEqual(result[0][2], 0)  # incoming
        self.assertEqual(result[0][3], 0)  # outgoing


if __name__ == '__main__':
    unittest.main()
