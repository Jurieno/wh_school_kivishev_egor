CREATE OR REPLACE FUNCTION airport.personal_flight_get(_personal_id INT, _flight_id BIGINT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT pf.personal_id,
                     pf.flight_id
              FROM airport.personal_flight pf
              WHERE pf.personal_id = COALESCE(_personal_id, pf.personal_id)
                AND pf.flight_id = COALESCE(_flight_id, pf.flight_id)) res;

END
$$;