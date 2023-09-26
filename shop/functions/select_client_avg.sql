CREATE OR REPLACE FUNCTION shop.select_client_avg() RETURNS jsonb
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
BEGIN
    RETURN jsonb_build_object('data', jsonb_agg(row_to_json(res)))
        FROM (SELECT c.client_id,
                     c.name      AS "Имя клиента",
                     sum(s.cost) AS "Суммарное количество товара"
              FROM shop.sales s
                       INNER JOIN shop.client c ON c.client_id = s.id_client
              GROUP BY c.client_id, c.name
              HAVING sum(s.cost) > (SELECT round(avg(r."общее"), 2)
                                    FROM (SELECT sum(s.cost) AS "общее"
                                          FROM shop.sales s
                                          GROUP BY s.id_client) r)) res;
END
$$;

select shop.select_client_avg();