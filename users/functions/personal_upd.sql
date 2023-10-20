CREATE OR REPLACE FUNCTION users.personal_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
as
$$
DECLARE
    _personal_id  INT;
    _role_id      INT;
    _firstname    VARCHAR(50);
    _lastname     varchar(50);
    _phone_number varchar(11);
BEGIN
    SELECT COALESCE(pp.personal_id, nextval('users.personal_personal_id_seq')) as personal_id,
           p.role_id,
           p.firstname,
           p.lastname,
           p.phone_number
    INTO _personal_id, _role_id, _firstname, _lastname, _phone_number
    FROM jsonb_to_record(_src) AS p (personal_id INT,
                                     role_id INT,
                                     firstname VARCHAR(50),
                                     lastname varchar(50),
                                     phone_number varchar(11))
    LEFT JOIN users.personals pp ON p.personal_id = pp.personal_id;

    INSERT INTO users.personal AS e (personal_id,
                                     role_id,
                                     firstname,
                                     lastname,
                                     phone_number)
    SELECT _personal_id, _role_id, _firstname, _lastname, _phone_number
    ON CONFLICT (personal_id) DO UPDATE
        SET role_id      = excluded.role_id,
            firstname    = excluded.firstname,
            lastname     = excluded.lastname,
            phone_number = excluded.phone_number;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;