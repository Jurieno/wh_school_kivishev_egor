CREATE TABLE IF NOT EXISTS dictionary.roles
(
    role_id SERIAL
        CONSTRAINT pk_role PRIMARY KEY,
    title   VARCHAR(50)
);

INSERT INTO dictionary.roles
VALUES (1, 'Пилот'),
       (2, 'Стюардеса')
ON CONFLICT (role_id) DO UPDATE
    SET title = excluded.title
WHERE role_id = excluded.role_id;