CREATE TABLE IF NOT EXISTS dictionary.types_place
(
    type_place_id SMALLSERIAL
        CONSTRAINT pk_type_place PRIMARY KEY,
    title         VARCHAR(20)   NOT NULL,
    markup        NUMERIC(4, 2) NOT NULL -- Наценка
);