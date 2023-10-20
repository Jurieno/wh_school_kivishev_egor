CREATE OR REPLACE FUNCTION airport.airfield_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
as
$$
DECLARE
    _airfields_code CHAR(3);
    _count_runway   SMALLINT;
    _count_helipad  SMALLINT;
    _runway_len     SMALLINT;
    _city           VARCHAR(32);
    _street         VARCHAR(50);
    _name           VARCHAR(70);
    _is_active      BOOLEAN;
BEGIN
    SELECT a.airfields_code,
           a.count_runway,
           a.count_helipad,
           a.runway_len,
           a.city,
           a.street,
           a.name,
           a.is_active
    INTO _airfields_code, _count_runway, _count_helipad, _runway_len, _city, _street, _name, _is_active
    FROM jsonb_to_record(_src) AS a (airfields_code CHAR(3),
                                     count_runway SMALLINT,
                                     count_helipad SMALLINT,
                                     runway_len SMALLINT,
                                     city VARCHAR(32),
                                     street VARCHAR(50),
                                     name VARCHAR(70),
                                     is_active BOOLEAN);

    IF EXISTS(SELECT 1
              FROM airport.airfields a
              WHERE a.city = _city
                AND a.street = _street
                AND a.airfields_code != _airfields_code)
    THEN
        RETURN public.errmessage('airport.airfield_upd.repeat_city_street',
                                 'Аэропорт по этому адресу уже существует.',
                                 NULL);
    end if;

    INSERT INTO airport.airfields AS a (airfields_code,
                                        count_runway,
                                        count_helipad,
                                        runway_len,
                                        city,
                                        street,
                                        name,
                                        is_active)
    SELECT _airfields_code,
           _count_runway,
           _count_helipad,
           _runway_len,
           _city,
           _street,
           _name,
           _is_active
    ON CONFLICT (airfields_code) DO UPDATE
        SET count_runway  = excluded.count_runway,
            count_helipad = excluded.count_helipad,
            runway_len    = excluded.runway_len,
            city          = excluded.city,
            street        = excluded.street,
            name          = excluded.name,
            is_active     = excluded.is_active;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;