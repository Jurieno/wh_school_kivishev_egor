create
    or replace function shop.select_cl_from_ord(_src jsonb) returns jsonb
    security definer
    language plpgsql
as
$$
DECLARE
    _product_id INT;
BEGIN
    SELECT p.tovarid
    INTO _product_id
    FROM jsonb_to_record(_src) AS p (tovarid int);

    IF
        NOT exists(SELECT 1 FROM shop.product p WHERE p.product_id = _product_id)
    THEN
        RETURN public.errmessage(_errcode := 'shop.select_cl_from_ord.product_id',
                                 _msg := 'Товар не найден!',
                                 _detail := concat('product_id = ', _product_id));
    END IF;

    RETURN JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(res)))
        FROM (SELECT c.client_id, c.name, c.phone, c.dt, c.ch_employee
              FROM shop.ord o
                       INNER JOIN shop.client c on o.client_id = c.client_id
              WHERE o.product_id = _product_id) res;

END
$$;

select shop.select_cl_from_ord('{
  "tovarid": 5
}');




