CREATE OR REPLACE FUNCTION airport.place_get(_place_id BIGINT, _place_num INT, _airplane_id INT,
                                             _type_place_id INT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.place_id,
                     p.place_num,
                     p.airplane_id,
                     p.type_place_id
              FROM airport.places p
              WHERE p.place_id = COALESCE(_place_id, p.place_id)
                AND p.place_num = COALESCE(_place_num, p.place_num)
                AND p.airplane_id = COALESCE(_airplane_id, p.airplane_id)
                AND p.type_place_id = COALESCE(_type_place_id, p.type_place_id)) res;

END
$$;