CREATE TABLE airport.payment_places_order
(
    payment_id BIGINT NOT NULL,
    place_id BIGINT NOT NULL,
    flight_id BIGINT NOT NULL,
    CONSTRAINT uq_place_flight UNIQUE ( place_id, flight_id )
)