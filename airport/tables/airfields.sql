CREATE TABLE IF NOT EXISTS airport.airfields
(
    airfields_code CHAR(3)
        CONSTRAINT pk_airfields PRIMARY KEY,
    count_runway   SMALLINT    NOT NULL,
    count_helipad  SMALLINT    NOT NULL,
    runway_len     SMALLINT    NOT NULL,
    city           VARCHAR(32) NOT NULL,
    street         VARCHAR(50) NOT NULL,
    name           VARCHAR(70) NOT NULL,
    CONSTRAINT uq_airfields_ct_st UNIQUE (city, street)
);