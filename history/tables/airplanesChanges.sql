CREATE TABLE IF NOT EXISTS history.airplaneschanges
(
    airplane_id       INT,
    airline_name      VARCHAR(11),
    name              VARCHAR(30),
    speed             SMALLINT,
    flight_range      SMALLINT,
    capacity_eco      SMALLINT,
    capacity_business SMALLINT,
    is_active         BOOLEAN
);