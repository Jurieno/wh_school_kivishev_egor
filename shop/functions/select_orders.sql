CREATE
    OR REPLACE FUNCTION shop.select_orders(_src jsonb) RETURNS jsonb
    security definer
    language plpgsql
as
$$
DECLARE
    _client_id INT;
BEGIN

    SELECT s.client_id
    INTO _client_id
    FROM jsonb_to_record(_src) AS s (client_id int);

    IF NOT EXISTS(SELECT 1 FROM shop.client c WHERE c.client_id = _client_id)
    THEN
        RETURN public.errmessage(_errcode := 'shop.select_orders.client_id',
                                  _msg := 'Пользователь не найден!',
                                  _detail := concat('client_id = ', _client_id));
    END IF;

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
    FROM (SELECT o.client_id,
                 o.product_id,
                 p.title,
                 sum(o.cost*p.price) AS Сумма
          FROM shop.ord o
                   INNER JOIN shop.product p on p.product_id = o.product_id
          WHERE o.client_id = _client_id
          GROUP BY o.client_id, o.product_id, p.title) res;

END
$$;

SELECT shop.select_orders('{
  "client_id": 3
}');