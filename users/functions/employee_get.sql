CREATE OR REPLACE FUNCTION users.employee_get(_employee_id BIGINT, _num_series INT, _num_pass CHAR(7),
                                              _phone_number VARCHAR(11)) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
BEGIN

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT e.employee_id,
                     e.num_series,
                     e.num_pass,
                     e.dt_issue,
                     e.phone_number,
                     e.email,
                     e.firstname,
                     e.lastname,
                     e.dt_birthday,
                     e.gender
              FROM users.employees e
              WHERE e.employee_id = COALESCE(_employee_id, e.employee_id)
                AND e.num_series = COALESCE(_num_series, e.num_series)
                AND e.num_pass = COALESCE(_num_pass, e.num_pass)
                AND e.phone_number = COALESCE(_phone_number, e.phone_number)) res;

END
$$;