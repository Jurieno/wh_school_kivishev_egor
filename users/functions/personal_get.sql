CREATE OR REPLACE FUNCTION users.personal_get(_personal_id INT, _role_id INT, _phone_number VARCHAR(7)) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.personal_id,
                     p.role_id,
                     p.firstname,
                     p.lastname,
                     p.phone_number
              FROM users.personal p
              WHERE p.personal_id = COALESCE(_personal_id, p.personal_id)
                AND p.role_id = COALESCE(_role_id, p.role_id)
                AND p.phone_number = COALESCE(_phone_number, p.phone_number)) res;

END
$$;