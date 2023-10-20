CREATE OR REPLACE FUNCTION airport.payment_places_ins(_data json, _payment_id BIGINT, _flight_id BIGINT) RETURNS NUMERIC(8, 2)
    SECURITY DEFINER
    LANGUAGE plpgsql
as
$$
DECLARE
BEGIN
    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT _payment_id as payment_id,
           p.place_id,
           _flight_id as flight_id
    FROM JSON_TO_RECORDSET(_data) AS p (place_id BIGINT);

    INSERT INTO airport.payment_places_order AS a (payment_id,
                                                   place_id,
                                                   flight_id)
    SELECT t.payment_id,
           t.place_id,
           t.flight_id
    FROM tmp t;

    RETURN res.price
    FROM (SELECT sum(tp.markup * f.price) as price
          FROM tmp t
                   LEFT JOIN airport.flights f ON t.flight_id = f.flight_id
                   LEFT JOIN airport.places p ON t.place_id = p.place_id
                   LEFT JOIN dictionary.types_place tp ON tp.type_place_id = p.place_id) res;
END
$$;