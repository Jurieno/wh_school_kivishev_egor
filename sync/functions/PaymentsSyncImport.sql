CREATE OR REPLACE FUNCTION sync.paymentssyncimport(_src JSONB) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN

    INSERT INTO airport.payments AS p (payment_id,
                                       flight_id,
                                       employee_id,
                                       price,
                                       dt_booking,
                                       dt_payment,
                                       dt_ch,
                                       valid)
    SELECT s.payment_id,
           s.flight_id,
           s.employee_id,
           s.price,
           s.dt_booking,
           s.dt_payment,
           s.dt_ch,
           s.valid
    FROM jsonb_to_recordset(_src) AS s (payment_id  BIGINT,
                                        flight_id   BIGINT,
                                        employee_id BIGINT,
                                        price       NUMERIC(8, 2),
                                        dt_booking  TIMESTAMPTZ,
                                        dt_payment  TIMESTAMPTZ,
                                        dt_ch       TIMESTAMPTZ,
                                        valid       BOOLEAN)
    ON CONFLICT (payment_id) DO UPDATE
        SET flight_id   = excluded.flight_id,
            employee_id = excluded.employee_id,
            price       = excluded.price,
            dt_booking  = excluded.dt_booking,
            dt_payment  = excluded.dt_payment,
            valid       = excluded.valid
    WHERE p.dt_ch < excluded.dt_ch;

    RETURN JSONB_BUILD_OBJECT('data',NULL);
END
$$;