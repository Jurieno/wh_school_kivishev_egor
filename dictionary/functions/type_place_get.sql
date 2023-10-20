CREATE OR REPLACE FUNCTION dictionary.type_place_get(_type_place_id INT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT t.type_place_id,
                     t.title,
                     t.markup
              FROM dictionary.types_place t
              WHERE t.type_place_id = COALESCE(_type_place_id, t.type_place_id)) res;

END
$$;