CREATE TABLE IF NOT EXISTS dictionary.types_place
(
    type_place_id SMALLSERIAL
        CONSTRAINT pk_type_place PRIMARY KEY,
    title         VARCHAR(20)   NOT NULL,
    markup        NUMERIC(4, 2) NOT NULL -- Наценка
);

INSERT INTO dictionary.types_place
VALUES (1, 'Стандарт', 1.0),
       (2, 'У окна', 1.2),
       (3, 'Бизнес', 3.0)
ON CONFLICT (type_place_id) DO UPDATE
    SET title  = excluded.title,
        markup = excluded.markup
WHERE type_place_id = excluded.type_place_id;