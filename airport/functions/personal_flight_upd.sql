CREATE OR REPLACE FUNCTION airport.personal_flight_upd(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _personal_id INT;
    _flight_id   BIGINT;
    _res         VARCHAR(10);
BEGIN
    SELECT p.personal_id,
           p.flight_id
    INTO _personal_id, _flight_id
    FROM jsonb_to_record(_src) AS p (personal_id INT,
                                     flight_id BIGINT);

    IF EXISTS(SELECT 1
              FROM airport.personal_flight p
              WHERE p.personal_id = _personal_id
                AND p.flight_id = _flight_id)
    THEN
        DELETE FROM airport.personal_flight AS a
        WHERE a.personal_id = _personal_id AND a.flight_id = _flight_id;
        _res = 'deleted';
    ELSE
        INSERT INTO airport.personal_flight AS a (personal_id,
                                              flight_id)
        SELECT _personal_id,
               _flight_id;
        _res = 'inserted';
    END IF;

    RETURN JSONB_BUILD_OBJECT('status', _res);
END
$$;