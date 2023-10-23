CREATE OR REPLACE FUNCTION users.employee_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _employee_id  BIGINT;
    _num_series   SMALLINT;
    _num_pass     CHAR(7);
    _dt_issue     DATE;
    _phone_number VARCHAR(11);
    _email        varchar(50);
    _firstname    varchar(50);
    _lastname     varchar(70);
    _dt_birthday  DATE;
    _gender       BOOLEAN;
BEGIN
    SELECT COALESCE(ee.employee_id, nextval('users.personal_personal_id_seq')) AS employee_id,
           e.num_series,
           e.num_pass,
           e.dt_issue,
           e.phone_number,
           e.email,
           e.firstname,
           e.lastname,
           e.dt_birthday,
           e.gender
    INTO _employee_id, _num_series, _num_pass, _dt_issue, _phone_number, _email, _firstname, _lastname, _dt_birthday, _gender
    FROM jsonb_to_record(_src) AS e (employee_id BIGINT,
                                     num_series SMALLINT,
                                     num_pass CHAR(7),
                                     dt_issue DATE,
                                     phone_number VARCHAR(11),
                                     email varchar(50),
                                     firstname varchar(50),
                                     lastname varchar(70),
                                     dt_birthday DATE,
                                     gender BOOLEAN)
             LEFT JOIN users.employees ee ON e.employee_id = ee.employee_id;

    IF EXISTS(SELECT 1
              FROM users.employees e
              WHERE e.num_series = _num_series
                AND e.num_pass = _num_pass
                AND e.employee_id != _employee_id)
    THEN
        RETURN public.errmessage('users.employee_upd.repeat_series_pass',
                                 'Такой пользователь с серией и номером паспорта уже зарегистрирован.',
                                 NULL);
    END IF;

    INSERT INTO users.employees AS e (employee_id,
                                      num_series,
                                      num_pass,
                                      dt_issue,
                                      phone_number,
                                      email,
                                      firstname,
                                      lastname,
                                      dt_birthday,
                                      gender)
    SELECT _employee_id,
           _num_series,
           _num_pass,
           _dt_issue,
           _phone_number,
           _email,
           _firstname,
           _lastname,
           _dt_birthday,
           _gender
    ON CONFLICT (employee_id) DO UPDATE
        SET num_series   = excluded.num_series,
            num_pass     = excluded.num_pass,
            dt_issue     = excluded.dt_issue,
            phone_number = excluded.phone_number,
            email        = excluded.email,
            firstname    = excluded.firstname,
            lastname     = excluded.lastname,
            dt_birthday  = excluded.dt_birthday,
            gender       = excluded.gender;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;