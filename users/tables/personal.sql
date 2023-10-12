CREATE TABLE IF NOT EXISTS users.personal
(
    personal_id  SERIAL
        CONSTRAINT pk_personal PRIMARY KEY,
    role_id      INT         NOT NULL,
    firstname    VARCHAR(50) NOT NULL,
    lastname     varchar(50) NOT NULL,
    phone_number varchar(11) NOT NULL
);