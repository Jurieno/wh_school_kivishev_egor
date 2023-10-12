CREATE TABLE IF NOT EXISTS dictionary.roles
(
    role_id SERIAL
        CONSTRAINT pk_role PRIMARY KEY,
    title   VARCHAR(50)
);