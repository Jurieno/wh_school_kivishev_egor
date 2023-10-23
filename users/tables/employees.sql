CREATE TABLE IF NOT EXISTS users.employees
(
    employee_id  BIGSERIAL
        CONSTRAINT pk_employees PRIMARY KEY,
    num_series   SMALLINT    NOT NULL,
    num_pass     CHAR(7)     NOT NULL,
    dt_issue     DATE        NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email        VARCHAR(50) NOT NULL,
    firstname    VARCHAR(50) NOT NULL,
    lastname     VARCHAR(70) NOT NULL,
    dt_birthday  DATE        NOT NULL,
    gender       BOOLEAN     NOT NULL,
    CONSTRAINT uq_users_ser_pass UNIQUE (num_series, num_pass)
);