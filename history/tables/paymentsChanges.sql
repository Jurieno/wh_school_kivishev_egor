CREATE TABLE IF NOT EXISTS history.paymentschanges
(
    payment_id  BIGINT,
    flight_id   BIGINT,
    employee_id BIGINT,
    price       NUMERIC(8, 2),
    dt_booking  TIMESTAMPTZ NOT NULL,
    dt_payment  TIMESTAMPTZ,
    valid       BOOLEAN,
    dt_ch       TIMESTAMPTZ,
    employee_ch INT
) PARTITION BY range (dt_ch);