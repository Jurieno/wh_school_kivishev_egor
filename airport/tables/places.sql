CREATE TABLE IF NOT EXISTS airport.places
(
    place_id      BIGSERIAL NOT NULL
        CONSTRAINT pk_place PRIMARY KEY,
    place_num     SMALLINT  NOT NULL,
    airplane_id   INT       NOT NULL,
    type_place_id SMALLINT  NOT NULL,
    CONSTRAINT uq_place_airplane UNIQUE (place_id, airplane_id)
);