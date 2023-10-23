CREATE OR REPLACE FUNCTION history.paymentschanges_create_partition() RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _dt DATE := date_trunc('YEAR', now());
    _i DATE;
    _partition_table_name TEXT;
BEGIN
    FOR _i IN
        SELECT d FROM generate_series(_dt, _dt + '11 month'::INTERVAL, '1 month'::INTERVAL) d
    LOOP
        _partition_table_name := FORMAT('paymentschanges_%s', REGEXP_REPLACE(_i::TEXT, '-', '_', 'g')::TEXT);
        IF (TO_REGCLASS(_partition_table_name::TEXT) ISNULL) THEN
            EXECUTE FORMAT(
              'CREATE TABLE history.%I PARTITION OF history.paymentschanges'
              '     FOR VALUES FROM (%L) TO (%L);'
              , _partition_table_name, _i, _i + '1 month'::INTERVAL);
        END IF;
    END LOOP;

    RETURN jsonb_build_object('data', NULL);
END
$$;