-- Создание триггера, который позволяет при вставке новой транзакции автоматически проверять её корректность и обновляет данные на банковском счёте
CREATE OR REPLACE FUNCTION pk_transactions_trigger()
    RETURNS TRIGGER AS
$$
DECLARE
    player_balance DECIMAL(18, 2);
    blocked        BOOLEAN;
BEGIN
    -- Получаем баланс игрока
    SELECT balance INTO player_balance FROM pk.players WHERE player_id = NEW.player_id;

    -- Проверка статуса банкового аккаунта
    SELECT blocked_flg INTO blocked FROM pk.bank_accounts WHERE bank_account_id = NEW.bank_account_id;
    IF blocked = TRUE THEN
        -- Устанавливаем статус FAILED и выходим из триггера
        NEW.status = 'FAILED';
        RETURN NEW;
    END IF;

    -- Проверка типа операции
    IF NEW.amount > 0 THEN
        -- Увеличение баланса игрока
        UPDATE pk.players SET balance = player_balance + NEW.amount WHERE player_id = NEW.player_id;
    ELSE
        -- Уменьшение баланса игрока
        IF player_balance + NEW.amount < 0 THEN
            -- Устанавливаем статус FAILED и выходим из триггера
            NEW.status = 'FAILED';
            RETURN NEW;
        ELSE
            UPDATE pk.players SET balance = player_balance + NEW.amount WHERE player_id = NEW.player_id;
        END IF;
    END IF;

    -- Устанавливаем статус SUCCESS
    NEW.status = 'SUCCESS';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER transactions_trigger
    BEFORE INSERT
    ON pk.transactions
    FOR EACH ROW
EXECUTE FUNCTION pk_transactions_trigger();


-- Создание триггера, который позволяет при вставке в games вызывает добавление одного связанного с ней table в pk.tables
CREATE OR REPLACE FUNCTION pk_games_trigger()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO pk.tables (table_id, game_id, dealer_pos, table_cards, bank_amt) VALUES (NEW.game_id, NEW.game_id, 1, '', 0);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER games_trigger
    AFTER INSERT
    ON pk.games
    FOR EACH ROW
EXECUTE FUNCTION pk_games_trigger();

