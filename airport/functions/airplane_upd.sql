CREATE OR REPLACE FUNCTION airport.airplane_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _airplane_id       INT;
    _airline_name      varchar(11);
    _name              varchar(30);
    _speed             SMALLINT;
    _flight_range      SMALLINT;
    _capacity_eco      SMALLINT;
    _capacity_business SMALLINT;
    _is_active         BOOLEAN;
    _updated           BOOLEAN := false;
BEGIN
    SELECT COALESCE(a.airplane_id, nextval('airport.airplanes_airplane_id_seq')) as airplane_id,
           a.airline_name,
           a.name,
           a.speed,
           a.flight_range,
           a.capacity_eco,
           a.capacity_business,
           a.is_active
    INTO _airplane_id, _airline_name, _name, _speed, _flight_range, _capacity_eco, _capacity_business, _is_active
    FROM jsonb_to_record(_src) AS a (airplane_id INT,
                                     airline_name varchar(11),
                                     name varchar(30),
                                     speed SMALLINT,
                                     flight_range SMALLINT,
                                     capacity_eco SMALLINT,
                                     capacity_business SMALLINT,
                                     is_active BOOLEAN);

    IF (SELECT 1 FROM airport.airplanes a WHERE a.airplane_id = _airplane_id) THEN
        _updated = true;
    end if;

    WITH ins_cte AS (
        INSERT INTO airport.airplanes AS a (airplane_id,
                                            airline_name,
                                            name,
                                            speed,
                                            flight_range,
                                            capacity_eco,
                                            capacity_business,
                                            is_active)
            SELECT _airplane_id,
                   _airline_name,
                   _name,
                   _speed,
                   _flight_range,
                   _capacity_eco,
                   _capacity_business,
                   _is_active
            ON CONFLICT (airplane_id) DO UPDATE
                SET airplane_id = excluded.airplane_id,
                    airline_name = excluded.airline_name,
                    name = excluded.name,
                    speed = excluded.speed,
                    flight_range = excluded.flight_range,
                    capacity_eco = excluded.capacity_eco,
                    capacity_business = excluded.capacity_business,
                    is_active = excluded.is_active
            RETURNING a.*)
    INSERT
    INTO history.airplaneschanges AS ec (airplane_id,
                                         airline_name,
                                         name,
                                         speed,
                                         flight_range,
                                         capacity_eco,
                                         capacity_business,
                                         is_active)
    SELECT c.airplane_id,
           c.airline_name,
           c.name,
           c.speed,
           c.flight_range,
           c.capacity_eco,
           c.capacity_business,
           c.is_active
    FROM ins_cte c;

    IF NOT _updated THEN
        INSERT INTO airport.places
        SELECT nextval('airport.places_place_id_seq'),
               generate_series(1, _capacity_eco),
               _airplane_id,
               1;

        INSERT INTO airport.places
        SELECT nextval('airport.places_place_id_seq'),
               generate_series(_capacity_eco + 1, _capacity_business + _capacity_eco),
               _airplane_id,
               3;
    end if;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;