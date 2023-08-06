--- Считаем что индексы на primary и foreign keys уже созданы автоматически ---

-- Для games можно ввести индексы почти для всех полей, тк они редко добавляются и изменяются,
-- а фильтры для поиска игроки выставляют постоянно
CREATE INDEX IF NOT EXISTS games_type_idx ON pk.games (type);
CREATE INDEX IF NOT EXISTS games_min_bet_idx ON pk.games (limits);
CREATE INDEX IF NOT EXISTS games_max_players_cnt_idx ON pk.games (max_players_cnt);
CREATE INDEX IF NOT EXISTS games_chip_cost_idx ON pk.games (chip_cost);

-- При рассадке мы не хотим, чтобы за одним столом сидели 5 топ стеков и 3 минимальных, поэтому рассаживаем "случайно",
-- но с учетом стека игрока. Поэтому индекс по chips_cnt должен ускорить запросы
CREATE INDEX idx_players_at_the_table_chips_cnt
ON pk.players_at_the_table (chips_cnt);

-- Тарнзакции можно разделить по статусу
CREATE INDEX idx_transaction_status ON pk.transactions (status);

-- Создадим индексы по размеру выигрыша, дате и картам на руках
CREATE INDEX idx_results_winning_amt ON pk.results (bank_amt);
CREATE INDEX idx_results_result_dttm ON pk.results (result_dttm);
CREATE INDEX idx_results_table_cards ON pk.results (table_cards);



