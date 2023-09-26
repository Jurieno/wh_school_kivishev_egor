CREATE TABLE IF NOT EXISTS shop.ord
(
    ord_id     INT,
    client_id  INT       NOT NULL,
    product_id INT       NOT NULL,
    dt         TIMESTAMP NOT NULL,
    cost       INT       NOT NULL,
    CONSTRAINT PK_ord PRIMARY KEY (ord_id),
    CONSTRAINT ch_cost CHECK ( cost > 0 )
);