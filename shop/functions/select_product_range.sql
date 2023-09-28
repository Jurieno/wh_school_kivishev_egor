CREATE OR REPLACE FUNCTION shop.select_product_range(_src jsonb) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _to_price numeric(10, 2);
    _do_price numeric(10, 2);
BEGIN
    SELECT p.to_price, p.do_price
    INTO _to_price, _do_price
    FROM jsonb_to_record(_src) AS p (to_price numeric(10, 2),
                                     do_price numeric(10, 2));

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
    FROM (SELECT p.product_id, p.title, p.price
          FROM shop.product p
          WHERE p.price <@ numrange(_to_price, _do_price, '[]')) res;
END
$$;