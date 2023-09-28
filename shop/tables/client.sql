CREATE TABLE IF NOT EXISTS shop.client
(
    client_id   integer                  NOT NULL
        CONSTRAINT pk_client
            PRIMARY KEY,
    name        varchar(30)              NOT NULL,
    phone       varchar(11)
        CONSTRAINT uq_client_phone
            UNIQUE,
    dt          timestamp WITH TIME ZONE NOT NULL,
    ch_employee integer                  NOT NULL
);