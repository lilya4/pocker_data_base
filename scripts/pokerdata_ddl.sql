CREATE SCHEMA IF NOT EXISTS pk;

CREATE TABLE IF NOT EXISTS pk.players
(
    player_id         INTEGER PRIMARY KEY,
    first_name        VARCHAR(50)    NOT NULL,
    last_name         VARCHAR(50)    NOT NULL,
    email             VARCHAR(255)   NOT NULL,
    username          VARCHAR(50)    NOT NULL UNIQUE,
    password          VARCHAR(255)   NOT NULL,
    registration_date TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    balance           DECIMAL(18, 2) NOT NULL CHECK (balance >= 0) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS pk.games
(
    game_id         INTEGER PRIMARY KEY,
    limits          INTEGER        NOT NULL CHECK (limits > 0),
    type            VARCHAR(50)    NOT NULL CHECK (type IN ('HOLDEM', 'OMAHA', 'OMAHA_HI_LO', 'SEVEN_CARD_STUD',
                                                            'SEVEN_CARD_STUD_HI_LO', 'SHORT_DECK')),
    max_players_cnt INTEGER        NOT NULL CHECK (max_players_cnt > 0 AND max_players_cnt <= 9),
    chip_cost       DECIMAL(18, 2) NOT NULL CHECK (chip_cost >= 0)
);

CREATE TABLE IF NOT EXISTS pk.tables
(
    table_id    INTEGER PRIMARY KEY,
    game_id     INTEGER        NOT NULL,
    dealer_pos  INTEGER        NOT NULL CHECK (dealer_pos >= 0 AND dealer_pos <= 8),
    table_cards VARCHAR(255)   NOT NULL,
    bank_amt    DECIMAL(18, 2) NOT NULL CHECK (bank_amt >= 0),
    FOREIGN KEY (game_id) REFERENCES pk.games (game_id)
);

CREATE TABLE IF NOT EXISTS pk.players_at_the_table
(
    players_at_the_table_id INTEGER PRIMARY KEY,
    chips_cnt               INTEGER        NOT NULL CHECK (chips_cnt >= 0),
    bet                     DECIMAL(18, 2) NOT NULL CHECK (bet >= 0),
    cards                   VARCHAR(255)   NOT NULL,
    pos_num                 INTEGER        NOT NULL CHECK (pos_num >= 0 AND pos_num <= 8)
);

CREATE TABLE IF NOT EXISTS pk.players_sessions
(
    player_id               INTEGER NOT NULL,
    table_id                INTEGER NOT NULL,
    players_at_the_table_id INTEGER NOT NULL,
    PRIMARY KEY (player_id, table_id),
    FOREIGN KEY (players_at_the_table_id) REFERENCES pk.players_at_the_table (players_at_the_table_id)
);

CREATE TABLE IF NOT EXISTS pk.results
(
    result_id   INTEGER PRIMARY KEY,
    table_id    INTEGER        NOT NULL,
    dealer_pos  INTEGER        NOT NULL CHECK (dealer_pos >= 0 AND dealer_pos <= 8),
    table_cards VARCHAR(255)   NOT NULL,
    bank_amt    DECIMAL(18, 2) NOT NULL CHECK (bank_amt >= 0),
    result_dttm TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES pk.tables (table_id)
);

CREATE TABLE IF NOT EXISTS pk.players_results
(
    results_id INTEGER NOT NULL,
    player_id  INTEGER NOT NULL,
    winner_id INTEGER NOT NULL,
    PRIMARY KEY (results_id, player_id),
    FOREIGN KEY (results_id) REFERENCES pk.results (result_id)
);

CREATE TABLE IF NOT EXISTS pk.winners
(
    winner_id   INTEGER PRIMARY KEY,
    bet         DECIMAL(18, 2) NOT NULL CHECK (bet >= 0),
    cards       VARCHAR(255)   NOT NULL,
    winning_amt DECIMAL(18, 2) NOT NULL CHECK (winning_amt >= 0)
);

CREATE TABLE IF NOT EXISTS pk.bank_accounts
(
    bank_account_id INTEGER PRIMARY KEY,
    money_amt       DECIMAL(18, 2) NOT NULL CHECK (money_amt >= 0) DEFAULT 0,
    open_date       DATE           NOT NULL DEFAULT CURRENT_DATE,
    blocked_flg     BOOLEAN        NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS pk.transactions
(
    transaction_id   INTEGER PRIMARY KEY,
    bank_account_id  INTEGER        NOT NULL,
    player_id        INTEGER        NOT NULL,
    transaction_dttm TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status           VARCHAR(50)    NOT NULL CHECK (status IN ('SUCCESS', 'FAILED', 'PENDING', 'CANCELLED')) DEFAULT 'PENDING',
    amount           DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (bank_account_id) REFERENCES pk.bank_accounts (bank_account_id),
    FOREIGN KEY (player_id) REFERENCES pk.players (player_id)
);