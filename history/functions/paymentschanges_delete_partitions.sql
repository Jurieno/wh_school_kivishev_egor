CREATE OR REPLACE FUNCTION history.paymentschanges_delete_partition(_name_table TEXT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _i                    DATE := date_trunc('MONTH', now() - '4 MONTH'::INTERVAL);
    _partition_table_name TEXT;
BEGIN
    _partition_table_name := FORMAT('history.%s_%s'::TEXT, _name_table, REGEXP_REPLACE(_i::TEXT, '-', '_', 'g')::TEXT);

    WHILE (TO_REGCLASS(_partition_table_name::TEXT) IS NOT NULL)
    LOOP
        EXECUTE FORMAT('DROP TABLE %s;', _partition_table_name);

        _i := _i - '1 MONTH'::INTERVAL;
        _partition_table_name := FORMAT('history.%s_%s'::TEXT, _name_table, REGEXP_REPLACE(_i::TEXT, '-', '_', 'g')::TEXT);
    END LOOP;

    RETURN jsonb_build_object('data', NULL);
END
$$;

