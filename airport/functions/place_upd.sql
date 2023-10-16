CREATE OR REPLACE FUNCTION airport.place_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
as
$$
DECLARE
    _place_id      BIGINT;
    _place_num     SMALLINT;
    _airplane_id   INT;
    _type_place_id SMALLINT;
    _err_message   VARCHAR(500);
BEGIN
    SELECT COALESCE(s.place_id, nextval('airport.places_place_id_seq')) as place_id,
           s.place_num,
           s.airplane_id,
           s.type_place_id
    INTO _place_id, _place_num, _airplane_id, _type_place_id
    FROM jsonb_to_record(_src) AS s (place_id BIGINT,
                                     place_num SMALLINT,
                                     airplane_id INT,
                                     type_place_id SMALLINT);

    IF (SELECT a.capacity_eco
        FROM airport.airplanes a
        WHERE a.airplane_id = _airplane_id) < _place_num AND _type_place_id IN (1, 2)
    THEN
        RETURN public.errmessage('airport.place_upd.exceeded_the_seats',
                                 'Количество посадочных мест превышено указанному в параметрах самолёта.',
                                 'Эконом и комфорт места.');
    end if;

    IF (SELECT a.capacity_business
        FROM airport.airplanes a
        WHERE a.airplane_id = _airplane_id) < _place_num AND  _type_place_id = 3
    THEN
        RETURN public.errmessage('airport.place_upd.exceeded_the_seats',
                                 'Количество посадочных мест превышено указанному в параметрах самолёта.',
                                 'Бизнес места.');
    end if;

    INSERT INTO airport.places AS a (place_id,
                                     place_num,
                                     airplane_id,
                                     type_place_id)
    SELECT _place_id, _place_num, _airplane_id, _type_place_id
    ON CONFLICT (airplane_id, place_num) DO UPDATE
        SET place_num     = excluded.place_num,
            airplane_id   = excluded.airplane_id,
            type_place_id = excluded.type_place_id;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;