CREATE OR REPLACE FUNCTION dictionary.role_get(_role_id INT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT r.role_id,
                     r.title
              FROM dictionary.roles r
              WHERE r.role_id = COALESCE(_role_id, r.role_id)) res;

END
$$;