CREATE OR REPLACE FUNCTION shop.ord_upd(_src json) RETURNS json
    SECURITY DEFINER
    LANGUAGE plpgsql
as
$$
DECLARE
    _dt         TIMESTAMPTZ = NOW();
    _errmessage varchar(500);
BEGIN
    CREATE TEMP TABLE tmp ON COMMIT DROP AS
    SELECT s.order_id,
           s.client_id,
           s.product_id,
           _dt AS dt,
           s.cost
    FROM JSON_TO_RECORDSET(_src) AS s (
                                       order_id INT,
                                       client_id INT,
                                       product_id INT,
                                       dt timestamptz,
                                       cost INT
        );

    SELECT CASE
               WHEN t.client_id IS NULL THEN 'Не передан обязательный параметр client_id'
               WHEN t.product_id IS NULL THEN 'Не передан обязательный параметр product_id'
               WHEN t.cost < 1 THEN 'Количество товаров не может быть меньше 1'
               WHEN c.client_id IS NULL THEN 'Такого клиента не существует'
               WHEN p.product_id IS NULL THEN 'Такого товара не существует' END
    INTO _errmessage
    FROM tmp t
        LEFT JOIN shop.client c ON t.client_id = c.client_id
        LEFT JOIN shop.product p ON t.product_id = p.product_id;

    IF _errmessage IS NOT NULL THEN
        RETURN public.errmessage('shop.ord_upd', _errmessage, NULL);
    end if;

    INSERT INTO shop.ord AS o (order_id,
                               client_id,
                               product_id,
                               dt,
                               cost)
    SELECT t.order_id,
           t.client_id,
           t.product_id,
           t.dt,
           t.cost
    FROM tmp t
    ON CONFLICT (order_id) DO UPDATE
        SET client_id  = excluded.client_id,
            product_id = excluded.product_id,
            cost       = excluded.cost
    WHERE o.dt < excluded.dt;

    RETURN JSONB_BUILD_OBJECT('data', jsonb_agg(row_to_json(res)))
    FROM (SELECT t.order_id,
                 t.client_id,
                 t.product_id,
                 t.dt,
                 t.cost FROM tmp t) res;

END
$$;

SELECT shop.ord_upd('[
  {
    "order_id": 35,
    "client_id": 3,
    "product_id": 25,
    "cost": 3
  },
  {
    "order_id": 36,
    "client_id": 5,
    "product_id": 2,
    "cost": 1
  }
]');