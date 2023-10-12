CREATE TABLE IF NOT EXISTS airport.flights
(
    flight_id              BIGSERIAL
        CONSTRAINT pk_flight PRIMARY KEY,
    airplane_id            INT           NOT NULL,
    dt_take_off            TIMESTAMPTZ   NOT NULL,
    dt_landing             TIMESTAMPTZ   NOT NULL,
    airfield_take_off_code CHAR(3)       NOT NULL,
    airfield_landing_code  CHAR(3)       NOT NULL,
    price                  NUMERIC(8, 2) NOT NULL,
    pets                   BOOLEAN       NOT NULL
);