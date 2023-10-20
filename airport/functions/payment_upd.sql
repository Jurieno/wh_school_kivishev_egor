CREATE OR REPLACE FUNCTION airport.payment_upd(_src jsonb, _data json, _em_ch INT) RETURNS jsonb
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _payment_id  BIGINT;
    _flight_id   BIGINT;
    _employee_id BIGINT;
    _price       NUMERIC(8, 2);
    _dt_booking  TIMESTAMPTZ;
    _dt_payment  TIMESTAMPTZ;
    _valid       BOOLEAN;
    _dt_ch       TIMESTAMPTZ := now();
BEGIN
    SELECT COALESCE(pp.payment_id, nextval('airport.payments_payment_id_seq')),
           p.flight_id,
           p.employee_id,
           p.dt_booking,
           p.dt_payment,
           p.valid
    INTO _payment_id, _flight_id, _employee_id, _dt_booking, _dt_payment, _valid
    FROM jsonb_to_record(_src) AS p (payment_id BIGINT,
                                     flight_id BIGINT,
                                     employee_id BIGINT,
                                     dt_booking TIMESTAMPTZ,
                                     dt_payment TIMESTAMPTZ,
                                     valid BOOLEAN)
             LEFT JOIN airport.payments pp ON pp.payment_id = p.payment_id;

    IF NOT EXISTS(SELECT 1 FROM airport.payments p WHERE p.payment_id = _payment_id) THEN
        SELECT airport.payment_places_ins(_data, _payment_id, _flight_id)
        INTO _price;
    END IF;

    WITH ins_cte AS (
        INSERT INTO airport.payments AS p (payment_id,
                                           flight_id,
                                           employee_id,
                                           price,
                                           dt_booking,
                                           dt_payment,
                                           dt_ch,
                                           valid)
            SELECT _payment_id,
                   _flight_id,
                   _employee_id,
                   _price,
                   _dt_booking,
                   _dt_payment,
                   _dt_ch,
                   _valid
            ON CONFLICT (payment_id) DO UPDATE
                SET flight_id = excluded.flight_id,
                    employee_id = excluded.employee_id,
                    price = excluded.price,
                    dt_booking = excluded.dt_booking,
                    dt_payment = excluded.dt_payment,
                    dt_ch = excluded.dt_ch,
                    valid = excluded.valid
            RETURNING p.*)
       , ins_his AS (
        INSERT INTO history.paymentschanges AS pc (payment_id,
                                                   flight_id,
                                                   employee_id,
                                                   price,
                                                   dt_booking,
                                                   dt_payment,
                                                   valid,
                                                   dt_ch,
                                                   employee_ch)
            SELECT ic.payment_id,
                   ic.flight_id,
                   ic.employee_id,
                   ic.price,
                   ic.dt_booking,
                   ic.dt_payment,
                   ic.valid,
                   _dt_ch as dt_ch,
                   _em_ch as employee_ch
            FROM ins_cte ic)
    INSERT
    INTO sync.paymentssync(payment_id,
                           flight_id,
                           employee_id,
                           price,
                           dt_booking,
                           dt_payment,
                           dt_ch,
                           valid)
    SELECT ic.payment_id,
           ic.flight_id,
           ic.employee_id,
           ic.price,
           ic.dt_booking,
           ic.dt_payment,
           ic.dt_ch,
           ic.valid
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;