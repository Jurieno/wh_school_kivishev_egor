CREATE TABLE IF NOT EXISTS airport.payments
(
    payment_id  BIGSERIAL
        CONSTRAINT pk_payment PRIMARY KEY,
    flight_id   BIGINT      NOT NULL,
    employee_id BIGINT      NOT NULL,
    price       NUMERIC(8, 2),
    dt_booking  TIMESTAMPTZ NOT NULL,
    dt_payment  TIMESTAMPTZ,
    dt_ch       TIMESTAMPTZ NOT NULL,
    valid       BOOLEAN
);