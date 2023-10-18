CREATE TABLE IF NOT EXISTS sync.paymentssync
(
    log_id      BIGSERIAL                NOT NULL
        CONSTRAINT pk_paymentssync PRIMARY KEY,
    payment_id  BIGINT                   NOT NULL,
    flight_id   BIGINT                   NOT NULL,
    employee_id BIGINT                   NOT NULL,
    price       NUMERIC(8, 2)            NOT NULL,
    dt_booking  TIMESTAMPTZ              NOT NULL,
    dt_payment  TIMESTAMPTZ,
    dt_ch       TIMESTAMPTZ,
    valid       BOOLEAN,
    sync_dt     TIMESTAMP WITH TIME ZONE NULL
);