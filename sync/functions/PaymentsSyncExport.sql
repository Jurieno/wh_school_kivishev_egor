CREATE OR REPLACE FUNCTION sync.paymentssyncexport(_log_id BIGINT) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _dt  TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _res JSONB;
BEGIN
    DELETE
    FROM sync.paymentssync es
    WHERE es.log_id <= _log_id
      AND es.sync_dt IS NOT NULL;

    WITH sync_cte AS (SELECT ps.log_id,
                             ps.payment_id,
                             ps.flight_id,
                             ps.employee_id,
                             ps.price,
                             ps.dt_booking,
                             ps.dt_payment,
                             ps.dt_ch,
                             ps.valid
                      FROM sync.paymentssync ps
                      ORDER BY ps.log_id
                      LIMIT 1000)
       , cte_upd AS (UPDATE sync.paymentssync es
                     SET sync_dt = _dt
                     FROM sync_cte sc
                     WHERE es.log_id = sc.log_id)
    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;