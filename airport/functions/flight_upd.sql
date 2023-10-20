CREATE OR REPLACE FUNCTION airport.flight_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _flight_id              BIGINT;
    _airplane_id            INT;
    _dt_take_off            TIMESTAMPTZ;
    _dt_landing             TIMESTAMPTZ;
    _airfield_take_off_code CHAR(3);
    _airfield_landing_code  CHAR(3);
    _price                  NUMERIC(8, 2);
    _pets                   BOOLEAN;
    _err_message            VARCHAR(500);
    _dt_ch                  timestamptz := now();
BEGIN
    SELECT COALESCE(ff.flight_id, nextval('airport.flights_flight_id_seq')),
           f.airplane_id,
           f.dt_take_off,
           f.dt_landing,
           f.airfield_take_off_code,
           f.airfield_landing_code,
           f.price,
           f.pets
    INTO _flight_id, _airplane_id, _dt_take_off, _dt_landing, _airfield_take_off_code, _airfield_landing_code, _price, _pets
    FROM jsonb_to_record(_src) AS f (flight_id BIGINT,
                                     airplane_id INT,
                                     dt_take_off TIMESTAMPTZ,
                                     dt_landing TIMESTAMPTZ,
                                     airfield_take_off_code CHAR(3),
                                     airfield_landing_code CHAR(3),
                                     price NUMERIC(8, 2),
                                     pets BOOLEAN)
             LEFT JOIN airport.flights ff ON ff.flight_id = f.flight_id;

    SELECT CASE
               WHEN _airfield_take_off_code = _airfield_landing_code
                   THEN 'Аэропорт вылета не может совпадать с аэропортом посадки.'
               WHEN _price <= 0 THEN 'Цена не может быть ниже или равна нулю.' END
    INTO _err_message;

    IF _err_message IS NOT NULL THEN
        RETURN public.errmessage('airport.flight_upd', _err_message, NULL);
    end if;

    WITH ins_cte AS (
        INSERT INTO airport.flights AS f (flight_id,
                                          airplane_id,
                                          dt_take_off,
                                          dt_landing,
                                          airfield_take_off_code,
                                          airfield_landing_code,
                                          price,
                                          pets)
            SELECT _flight_id,
                   _airplane_id,
                   _dt_take_off,
                   _dt_landing,
                   _airfield_take_off_code,
                   _airfield_landing_code,
                   _price,
                   _pets
            ON CONFLICT (flight_id) DO UPDATE
                SET airplane_id = excluded.airplane_id,
                    dt_take_off = excluded.dt_take_off,
                    dt_landing = excluded.dt_landing,
                    airfield_take_off_code = excluded.airfield_take_off_code,
                    airfield_landing_code = excluded.airfield_landing_code,
                    price = excluded.price,
                    pets = excluded.pets
            RETURNING f.*)
    INSERT
    INTO history.flightschanges AS fc (flight_id,
                                       airplane_id,
                                       dt_take_off,
                                       dt_landing,
                                       airfield_take_off_code,
                                       airfield_landing_code,
                                       price,
                                       pets,
                                       dt_ch)
    SELECT c.flight_id,
           c.airplane_id,
           c.dt_take_off,
           c.dt_landing,
           c.airfield_take_off_code,
           c.airfield_landing_code,
           c.price,
           c.pets,
           _dt_ch as dt_ch
    FROM ins_cte c;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;