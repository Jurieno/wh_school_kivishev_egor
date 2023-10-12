CREATE TABLE IF NOT EXISTS airport.personal_flight
(
    personal_id INT NOT NULL,
    flight_id BIGINT NOT NULL,
    CONSTRAINT uq_personal_flight UNIQUE (personal_id, flight_id)
);