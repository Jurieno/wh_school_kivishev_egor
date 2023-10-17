CREATE TABLE IF NOT EXISTS airport.airplanes
(
    airplane_id       SERIAL
        CONSTRAINT pk_airplane PRIMARY KEY,
    airline_name      varchar(11) NOT NULL,
    name              varchar(30) NOT NULL,
    speed             SMALLINT    NOT NULL,
    flight_range      SMALLINT    NOT NULL,
    capacity_eco      SMALLINT    NOT NULL,
    capacity_business SMALLINT    NOT NULL,
    is_active         BOOLEAN,
    CONSTRAINT positive_capacity_e CHECK (capacity_eco > 0),
    CONSTRAINT positive_capacity_b CHECK (capacity_business >= 0),
    CONSTRAINT positive_speed CHECK (speed > 0),
    CONSTRAINT positive_flight_range CHECK (flight_range > 0)
);