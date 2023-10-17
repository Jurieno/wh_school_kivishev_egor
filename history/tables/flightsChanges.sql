CREATE TABLE IF NOT EXISTS history.flightschanges
(
    flight_id              BIGINT,
    airplane_id            INT,
    dt_take_off            TIMESTAMPTZ,
    dt_landing             TIMESTAMPTZ,
    airfield_take_off_code CHAR(3),
    airfield_landing_code  CHAR(3),
    price                  NUMERIC(8, 2),
    pets                   BOOLEAN,
    dt_ch                  timestamptz
);