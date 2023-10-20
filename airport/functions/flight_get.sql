CREATE OR REPLACE FUNCTION airport.flight_get(_flight_id BIGINT, _airplane_id INT, _dt_take_off TIMESTAMPTZ,
                                                _dt_landing TIMESTAMPTZ) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT f.flight_id,
                     f.airplane_id,
                     f.dt_take_off,
                     f.dt_landing,
                     f.airfield_take_off_code,
                     f.airfield_landing_code,
                     f.price,
                     f.pets
              FROM airport.flights f
              WHERE f.flight_id = COALESCE(_flight_id, f.flight_id)
                AND f.airplane_id = COALESCE(_airplane_id, f.airplane_id)
                AND f.dt_take_off >= COALESCE(_dt_take_off, f.dt_take_off)
                AND f.dt_landing <= COALESCE(_dt_landing, f.dt_landing)) res;

END
$$;