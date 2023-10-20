CREATE OR REPLACE FUNCTION airport.payment_places_get(_payment_id BIGINT, _place_id BIGINT, _flight_id BIGINT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.payment_id,
                     p.place_id,
                     p.flight_id
              FROM airport.payment_places_order p
              WHERE p.payment_id = COALESCE(_payment_id, p.payment_id)
                AND p.employee_id = COALESCE(_place_id, p.employee_id)
                AND p.flight_id = COALESCE(_flight_id, p.flight_id)) res;

END
$$;