CREATE OR REPLACE FUNCTION shop.select_ord_from_dt(_src jsonb) RETURNS jsonb
    security definer
    language plpgsql
as
$$
DECLARE
    _dt timestamptz;
BEGIN
    SELECT p.dt
    INTO _dt
    FROM jsonb_to_record(_src) AS p (dt timestamptz);

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT p.title,
                     sum(o.cost)           as Количество,
                     sum(o.cost * p.price) as Стоимость,
                     c.name
              FROM shop.ord o
                       INNER JOIN shop.product p on o.product_id = p.product_id
                       INNER JOIN shop.client c on o.client_id = c.client_id
              WHERE o.dt::date = _dt::date
              GROUP BY o.client_id, o.product_id, p.title, c.name) res;
END
$$;