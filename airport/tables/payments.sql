CREATE TABLE IF NOT EXISTS airport.payments
(
    payment_id  BIGSERIAL
        CONSTRAINT pk_payment PRIMARY KEY,
    flight_id   BIGINT        NOT NULL,
    employee_id BIGINT        NOT NULL,
    price       NUMERIC(8, 2) NOT NULL,
    dt_booking  TIMESTAMPTZ   NOT NULL,
    dt_payment  TIMESTAMPTZ,
    valid       BOOLEAN
);