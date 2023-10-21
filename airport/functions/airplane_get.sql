CREATE OR REPLACE FUNCTION airport.airplane_get(_airplane_id INT, _name VARCHAR, _is_active BOOLEAN) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT a.airplane_id,
                     a.airline_name,
                     a.name,
                     a.speed,
                     a.flight_range,
                     a.capacity_eco,
                     a.capacity_business,
                     a.is_active
              FROM airport.airplanes a
              WHERE a.airplane_id = COALESCE(_airplane_id, a.airplane_id)
                AND a.name = COALESCE(_name, a.name)
                AND a.is_active = COALESCE(_is_active, a.is_active)) res;

END
$$;