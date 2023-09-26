CREATE TABLE IF NOT EXISTS shop.product
(
    product_id    INT,
    title VARCHAR(30)    NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    CONSTRAINT PK_product PRIMARY KEY (product_id),
    CONSTRAINT ch_price CHECK ( Price > 0 )
);