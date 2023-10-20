CREATE OR REPLACE FUNCTION airport.airfield_get(_airfields_code CHAR(3), _city VARCHAR, _is_active BOOLEAN) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT a.airfields_code,
                     a.count_runway,
                     a.count_helipad,
                     a.runway_len,
                     a.city,
                     a.street,
                     a.name,
                     a.is_active
              FROM airport.airfield a
              WHERE a.airfields_code = COALESCE(_airfields_code, a.airfields_code)
                AND a.city = COALESCE(_city, a.city)
                AND a.is_active = COALESCE(_is_active, a.is_active)) res;

END
$$;