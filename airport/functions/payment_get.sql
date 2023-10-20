CREATE OR REPLACE FUNCTION airport.payment_get(_payment_id BIGINT, _flight_id BIGINT, _employee_id BIGINT,
                                             _valid BOOLEAN) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.payment_id,
                     p.flight_id,
                     p.employee_id,
                     p.price,
                     p.dt_booking,
                     p.dt_payment,
                     p.dt_ch,
                     p.valid
              FROM airport.payments p
              WHERE p.payment_id = COALESCE(_payment_id, p.payment_id)
                AND p.flight_id = COALESCE(_flight_id, p.flight_id)
                AND p.employee_id = COALESCE(_employee_id, p.employee_id)
                AND p.valid = COALESCE(_valid, p.valid)) res;

END
$$;