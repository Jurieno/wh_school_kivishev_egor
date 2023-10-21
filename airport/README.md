[1. Таблица airfields](#Таблица-airfields)<br>
[2. Таблица airplanes](#Таблица-airplanes)<br>
[3. Таблица flights](#Таблица-flights)<br>
[4. Таблица payment_places_order](#Таблица-payment_places_order)<br>
[5. Таблица payments](#Таблица-payments)<br>
[6. Таблица personal_flight](#Таблица-personal_flight)<br>
[7. Таблица places](#Таблица-places)

# Схема airport

### Таблица airfields
```sql
CREATE TABLE IF NOT EXISTS airport.airfields
(
    airfields_code CHAR(3)
        CONSTRAINT pk_airfields PRIMARY KEY,
    count_runway   SMALLINT    NOT NULL,
    count_helipad  SMALLINT    NOT NULL,
    runway_len     SMALLINT    NOT NULL,
    city           VARCHAR(32) NOT NULL,
    street         VARCHAR(50) NOT NULL,
    name           VARCHAR(70) NOT NULL,
    is_active      BOOLEAN,
    CONSTRAINT uq_airfields_ct_st UNIQUE (city, street)
);
```
В ней описаны следующие поля:
```
airfields_code - Код аэропорта
count_runway   - Кол-во полос
count_helipad  - Кол-во вертолётных площадок
runway_len     - Длина полосы
city           - Город
street         - Улица и № дома
name           - Название аэропорта
is_active      - Активен
```
Ограничение уникальности установлено на 2 поля: num_series, num_pass
##### Пример создания аэропорта
```sql
SELECT airport.airfield_upd('{
  "airfields_code": "МАЛ",
  "count_runway": 0,
  "count_helipad": 6,
  "runway_len": 3200,
  "city": "Малайзия",
  "street": "Аэропорт 1",
  "name": "Малайзийский аэропорт презедента",
  "is_active": 0
}');
```
##### Пример обновления данных аэропорта
```sql
SELECT airport.airfield_upd('{
  "airfields_code": "МАЛ",
  "count_runway": 3,
  "count_helipad": 0,
  "runway_len": 3200,
  "city": "Малайзия",
  "street": "Аэропорт 1",
  "name": "Малайзийский аэропорт презедента",
  "is_active": 0
}');
```
##### Пример исключения
```json
{
  "errors": [
    {
      "error": "airport.airfield_upd.repeat_city_street",
      "detail": null,
      "message": "Аэропорт по этому адресу уже существует."
    }
  ]
}
```
##### Примеры GET запросов
```sql
airfield_get(_airfields_code character, _city varchar, _is_active boolean)
```
```sql
SELECT airport.airfield_get(NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "city": "Кемерово",
      "name": "Кемеровский аэропорт имени Тулеева",
      "street": "Аэропорт 1",
      "is_active": true,
      "runway_len": 2000,
      "count_runway": 0,
      "count_helipad": 3,
      "airfields_code": "KEM"
    },
    {
      "city": "Якутск",
      "name": "Якутский аэропорт",
      "street": "Аэропорт 1",
      "is_active": true,
      "runway_len": 1400,
      "count_runway": 1,
      "count_helipad": 2,
      "airfields_code": "ЯКУ"
    },
    {
      "city": "Малайзия",
      "name": "Малайзийский аэропорт презедента",
      "street": "Аэропорт 1",
      "is_active": false,
      "runway_len": 3200,
      "count_runway": 3,
      "count_helipad": 0,
      "airfields_code": "МАЛ"
    }
  ]
}
```
```sql
SELECT airport.airfield_get('KEM', NULL, NULL);
```
```json
{
  "data": [
    {
      "city": "Кемерово",
      "name": "Кемеровский аэропорт имени Тулеева",
      "street": "Аэропорт 1",
      "is_active": true,
      "runway_len": 2000,
      "count_runway": 0,
      "count_helipad": 3,
      "airfields_code": "KEM"
    }
  ]
}
```
```sql
SELECT airport.airfield_get(NULL, 'Малайзия', NULL);
```
```json
{
  "data": [
    {
      "city": "Малайзия",
      "name": "Малайзийский аэропорт презедента",
      "street": "Аэропорт 1",
      "is_active": false,
      "runway_len": 3200,
      "count_runway": 3,
      "count_helipad": 0,
      "airfields_code": "МАЛ"
    }
  ]
}
```
```sql
SELECT airport.airfield_get(NULL, NULL, TRUE);
```
```json
{
  "data": [
    {
      "city": "Кемерово",
      "name": "Кемеровский аэропорт имени Тулеева",
      "street": "Аэропорт 1",
      "is_active": true,
      "runway_len": 2000,
      "count_runway": 0,
      "count_helipad": 3,
      "airfields_code": "KEM"
    },
    {
      "city": "Якутск",
      "name": "Якутский аэропорт",
      "street": "Аэропорт 1",
      "is_active": true,
      "runway_len": 1400,
      "count_runway": 1,
      "count_helipad": 2,
      "airfields_code": "ЯКУ"
    }
  ]
}
```

### Таблица airplanes
```sql
CREATE TABLE IF NOT EXISTS airport.airplanes
(
    airplane_id       SERIAL
        CONSTRAINT pk_airplane PRIMARY KEY,
    airline_name      varchar(11) NOT NULL,
    name              varchar(30) NOT NULL,
    speed             SMALLINT    NOT NULL,
    flight_range      SMALLINT    NOT NULL,
    capacity_eco      SMALLINT    NOT NULL,
    capacity_business SMALLINT    NOT NULL,
    is_active         BOOLEAN,
    CONSTRAINT positive_capacity_e CHECK (capacity_eco > 0),
    CONSTRAINT positive_capacity_b CHECK (capacity_business >= 0),
    CONSTRAINT positive_speed CHECK (speed > 0),
    CONSTRAINT positive_flight_range CHECK (flight_range > 0)
)
```
В ней описаны следующие поля:
```
airplane_id       - ID самолёта
airline_name      - Название авиакомпании
name              - Название самолёта
speed             - Средняя скорость самолёта
flight_range      - Макс. дальность полёта
capacity_eco      - Кол-во эконом мест
capacity_business - Кол-во бизнес мест
is_active         - Активен
```
##### Пример создания самолёта
При создании самолёта, места бизнес и эконом класса создаются автоматически.
```sql
SELECT airport.airplane_upd('{
  "airline_name": "EK airlines",
  "name": "Василец",
  "speed": 700,
  "flight_range": 15000,
  "capacity_eco": 6,
  "capacity_business": 4,
  "is_active": 1
}')
```
##### Пример обновления данных самолёта
```sql
SELECT airport.airplane_upd('{
  "airplane_id": 2,
  "airline_name": "EK airlines",
  "name": "Василец",
  "speed": 700,
  "flight_range": 15000,
  "capacity_eco": 6,
  "capacity_business": 4,
  "is_active": 0
}')
```
##### Примеры исключений
```json
{
  "errors": [
    {
      "error": "airport.airplane_upd.empty_params_or_negative",
      "detail": null,
      "message": "Количество мест бизнес класса не может быть отрицательным."
    }
  ]
}
```
```json
{
  "errors": [
    {
      "error": "airport.airplane_upd.empty_params_or_negative",
      "detail": null,
      "message": "Количество мест эконом класса не может быть меньше одного."
    }
  ]
}
```
```json
{
  "errors": [
    {
      "error": "airport.airplane_upd.empty_params_or_negative",
      "detail": null,
      "message": "Скорость не может быть ниже единицы."
    }
  ]
}
```
```json
{
  "errors": [
    {
      "error": "airport.airplane_upd.empty_params_or_negative",
      "detail": null,
      "message": "Дальность полёта не может быть ниже единицы."
    }
  ]
}
```
##### Примеры GET запросов
```sql
airplane_get(_airplane_id integer, _name varchar, _is_active boolean)
```
```sql
SELECT airport.airplane_get(NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "name": "Стрелец",
      "speed": 800,
      "is_active": true,
      "airplane_id": 1,
      "airline_name": "EK airlines",
      "capacity_eco": 4,
      "flight_range": 10000,
      "capacity_business": 2
    },
    {
      "name": "Василец",
      "speed": 700,
      "is_active": true,
      "airplane_id": 2,
      "airline_name": "EK airlines",
      "capacity_eco": 6,
      "flight_range": 15000,
      "capacity_business": 4
    }
  ]
}
```
```sql
SELECT airport.airplane_get(1, NULL, NULL);
```
```json
{
  "data": [
    {
      "name": "Стрелец",
      "speed": 800,
      "is_active": true,
      "airplane_id": 1,
      "airline_name": "EK airlines",
      "capacity_eco": 4,
      "flight_range": 10000,
      "capacity_business": 2
    }
  ]
}
```
```sql
SELECT airport.airplane_get(NULL, 'Василец', NULL);
```
```json
{
  "data": [
    {
      "name": "Василец",
      "speed": 700,
      "is_active": true,
      "airplane_id": 2,
      "airline_name": "EK airlines",
      "capacity_eco": 6,
      "flight_range": 15000,
      "capacity_business": 4
    }
  ]
}
```
```sql
SELECT airport.airplane_get(NULL, NULL, TRUE);
```
```json
{
  "data": [
    {
      "name": "Стрелец",
      "speed": 800,
      "is_active": true,
      "airplane_id": 1,
      "airline_name": "EK airlines",
      "capacity_eco": 4,
      "flight_range": 10000,
      "capacity_business": 2
    },
    {
      "name": "Василец",
      "speed": 700,
      "is_active": true,
      "airplane_id": 2,
      "airline_name": "EK airlines",
      "capacity_eco": 6,
      "flight_range": 15000,
      "capacity_business": 4
    }
  ]
}
```

### Таблица flights
```sql
CREATE TABLE IF NOT EXISTS airport.flights
(
    flight_id              BIGSERIAL
        CONSTRAINT pk_flight PRIMARY KEY,
    airplane_id            INT           NOT NULL,
    dt_take_off            TIMESTAMPTZ   NOT NULL,
    dt_landing             TIMESTAMPTZ   NOT NULL,
    airfield_take_off_code CHAR(3)       NOT NULL,
    airfield_landing_code  CHAR(3)       NOT NULL,
    price                  NUMERIC(8, 2) NOT NULL,
    pets                   BOOLEAN       NOT NULL
);
```
В ней описаны следующие поля:
```
flight_id              - ID рейса
airplane_id            - ID самолёта
dt_take_off            - Дата вылета
dt_landing             - Дата посадки
airfield_take_off_code - Аэропорт вылета
airfield_landing_code  - Аэропорт посадки
price                  - Минимальная цена билета
pets                   - Перелёт с животным до 10кг в салоне
```
##### Пример создания рейса
```sql
SELECT airport.flight_upd('{
  "airplane_id": 1,
  "dt_take_off": "2023-10-17 18:09:47.407130 +00:00",
  "dt_landing": "2023-10-17 23:09:47.407130 +00:00",
  "airfield_take_off_code": "ЯКУ",
  "airfield_landing_code": "КЕМ",
  "price": 13000.00,
  "pets": 0
}');
```
##### Пример обновления рейса
```sql
SELECT airport.flight_upd('{
  "flight_id": 2,
  "airplane_id": 1,
  "dt_take_off": "2023-10-17 18:09:47.407130 +00:00",
  "dt_landing": "2023-10-17 23:09:47.407130 +00:00",
  "airfield_take_off_code": "КЕМ",
  "airfield_landing_code": "ЯКУ",
  "price": 13000.00,
  "pets": 0
}');
```
##### Примеры GET запросов
```sql
flight_get(_flight_id bigint, _airplane_id integer, _dt_take_off timestamp with time zone, _dt_landing timestamp with time zone)
```
```sql
SELECT airport.flight_get(NULL, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "pets": false,
      "price": 17000.2,
      "flight_id": 1,
      "dt_landing": "2023-10-16T23:09:47.40713+00:00",
      "airplane_id": 1,
      "dt_take_off": "2023-10-16T18:09:47.40713+00:00",
      "airfield_landing_code": "ЯКУ",
      "airfield_take_off_code": "КЕМ"
    },
    {
      "pets": true,
      "price": 10000,
      "flight_id": 2,
      "dt_landing": "2023-10-20T23:09:47.40713+00:00",
      "airplane_id": 2,
      "dt_take_off": "2023-10-20T18:09:47.40713+00:00",
      "airfield_landing_code": "КЕМ",
      "airfield_take_off_code": "ЯКУ"
    }
  ]
}
```
```sql
SELECT airport.flight_get(1, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "pets": false,
      "price": 17000.2,
      "flight_id": 1,
      "dt_landing": "2023-10-16T23:09:47.40713+00:00",
      "airplane_id": 1,
      "dt_take_off": "2023-10-16T18:09:47.40713+00:00",
      "airfield_landing_code": "ЯКУ",
      "airfield_take_off_code": "КЕМ"
    }
  ]
}
```
```sql
SELECT airport.flight_get(NULL, 2, NULL, NULL);
```
```json
{
  "data": [
    {
      "pets": true,
      "price": 10000,
      "flight_id": 2,
      "dt_landing": "2023-10-20T23:09:47.40713+00:00",
      "airplane_id": 2,
      "dt_take_off": "2023-10-20T18:09:47.40713+00:00",
      "airfield_landing_code": "КЕМ",
      "airfield_take_off_code": "ЯКУ"
    }
  ]
}
```
```sql
SELECT airport.flight_get(NULL, NULL, '2023-10-20 07:15:33.835754 +00:00', '2023-10-21 07:15:33.835754 +00:00');
```
```json
{
  "data": [
    {
      "pets": true,
      "price": 10000,
      "flight_id": 2,
      "dt_landing": "2023-10-20T23:09:47.40713+00:00",
      "airplane_id": 2,
      "dt_take_off": "2023-10-20T18:09:47.40713+00:00",
      "airfield_landing_code": "КЕМ",
      "airfield_take_off_code": "ЯКУ"
    }
  ]
}
```

### Таблица payment_places_order
```sql
CREATE TABLE IF NOT EXISTS airport.payment_places_order
(
    payment_id BIGINT NOT NULL,
    place_id   BIGINT NOT NULL,
    flight_id  BIGINT NOT NULL,
    CONSTRAINT uq_place_flight UNIQUE (place_id, flight_id)
)
```
В ней описаны следующие поля:
```
payment_id - ID оплаты
place_id   - ID места
flight_id  - ID рейса
```
##### Примеры GET запросов
```sql
payment_places_get(_payment_id bigint, _place_id bigint, _flight_id bigint)
```
```sql
SELECT airport.payment_places_get(NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "place_id": 1,
      "flight_id": 1,
      "payment_id": 2
    },
    {
      "place_id": 2,
      "flight_id": 1,
      "payment_id": 7
    }
  ]
}
```
```sql
SELECT airport.payment_places_get(7, NULL, NULL);
```
```json
{
  "data": [
    {
      "place_id": 2,
      "flight_id": 1,
      "payment_id": 7
    }
  ]
}
```
```sql
SELECT airport.payment_places_get(NULL, 1, NULL);
```
```json
{
  "data": [
    {
      "place_id": 1,
      "flight_id": 1,
      "payment_id": 2
    }
  ]
}
```

### Таблица payments 
```sql
CREATE TABLE IF NOT EXISTS airport.payments
(
    payment_id  BIGSERIAL
        CONSTRAINT pk_payment PRIMARY KEY,
    flight_id   BIGINT      NOT NULL,
    employee_id BIGINT      NOT NULL,
    price       NUMERIC(8, 2),
    dt_booking  TIMESTAMPTZ NOT NULL,
    dt_payment  TIMESTAMPTZ,
    dt_ch       TIMESTAMPTZ NOT NULL,
    valid       BOOLEAN
);
```
В ней описаны следующие поля:
```
payment_id  - ID оплаты
flight_id   - ID рейса
employee_id - ID пассажира
price       - Кол-во_мест * цена_рейса * markup
dt_booking  - Дата бронирования
dt_payment  - Дата оплаты
dt_ch       - Дата изменения
valid       - Исполнена оплата
```
##### Пример создания 
```sql
SELECT airport.payment_upd('{
  "flight_id": 1,
  "employee_id": 1,
  "dt_booking": "2023-10-19 15:57:14.247221 +00:00",
  "dt_payment": null,
  "valid": 0
}', '[
  {
    "place_id": "1"
  },
  {
    "place_id": "2"
  }
]', 1245);
```
##### Пример обновления данных 
```sql
SELECT airport.payment_upd('{
  "flight_id": 1,
  "employee_id": 1,
  "dt_booking": "2023-10-19 15:57:14.247221 +00:00",
  "dt_payment": "2023-10-20 15:57:14.247221 +00:00",
  "valid": 1
}', '[]', 1246);
```
##### Примеры GET запросов
```sql
payment_get(_payment_id bigint, _flight_id bigint, _employee_id bigint, _valid boolean)
```
```sql
SELECT airport.payment_get(NULL, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "dt_ch": "2023-10-19T16:00:56.474534+00:00",
      "price": null,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 2,
      "employee_id": 1
    },
    {
      "dt_ch": "2023-10-19T16:56:41.612681+00:00",
      "price": 37400.44,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 7,
      "employee_id": 1
    }
  ]
}
```
```sql
SELECT airport.payment_get(2, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "dt_ch": "2023-10-19T16:00:56.474534+00:00",
      "price": null,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 2,
      "employee_id": 1
    }
  ]
}
```
```sql
SELECT airport.payment_get(NULL, 1, NULL, NULL);
```
```json
{
  "data": [
    {
      "dt_ch": "2023-10-19T16:00:56.474534+00:00",
      "price": null,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 2,
      "employee_id": 1
    },
    {
      "dt_ch": "2023-10-19T16:56:41.612681+00:00",
      "price": 37400.44,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 7,
      "employee_id": 1
    }
  ]
}
```
```sql
SELECT airport.payment_get(NULL, NULL, 1, NULL);
```
```json
{
  "data": [
    {
      "dt_ch": "2023-10-19T16:00:56.474534+00:00",
      "price": null,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 2,
      "employee_id": 1
    },
    {
      "dt_ch": "2023-10-19T16:56:41.612681+00:00",
      "price": 37400.44,
      "valid": false,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": null,
      "payment_id": 7,
      "employee_id": 1
    }
  ]
}
```
```sql
SELECT airport.payment_get(NULL, NULL, NULL, true);
```
```json
{
  "data": [
    {
      "dt_ch": "2023-10-19T16:56:41.612681+00:00",
      "price": 37400.44,
      "valid": true,
      "flight_id": 1,
      "dt_booking": "2023-10-19T15:57:14.247221+00:00",
      "dt_payment": "2023-10-21T00:39:39.656+00:00",
      "payment_id": 7,
      "employee_id": 1
    }
  ]
}
```

### Таблица personal_flight
```sql
CREATE TABLE IF NOT EXISTS airport.personal_flight
(
    personal_id INT    NOT NULL,
    flight_id   BIGINT NOT NULL,
    CONSTRAINT uq_personal_flight UNIQUE (personal_id, flight_id)
);
```
В ней описаны следующие поля:
```
personal_id - ID персонала
flight_id   - ID рейса

```
##### Пример создания и удаления
```sql
SELECT airport.personal_flight_upd('{
  "personal_id": 7,
  "flight_id": 2
}');
```
##### Примеры ответа
```json
{
  "status": "inserted"
}
```
```json
{
  "status": "deleted"
}
```
##### Примеры GET запросов
```sql
personal_flight_get(_personal_id integer, _flight_id bigint)
```
```sql
SELECT airport.personal_flight_get(NULL, NULL);
```
```json
{
  "data": [
    {
      "flight_id": 2,
      "personal_id": 5
    },
    {
      "flight_id": 7,
      "personal_id": 6
    },
    {
      "flight_id": 7,
      "personal_id": 7
    },
    {
      "flight_id": 2,
      "personal_id": 7
    }
  ]
}
```
```sql
SELECT airport.personal_flight_get(NULL, 2);
```
```json
{
  "data": [
    {
      "flight_id": 2,
      "personal_id": 5
    },
    {
      "flight_id": 2,
      "personal_id": 7
    }
  ]
}
```
```sql
SELECT airport.personal_flight_get(7, NULL);
```
```json
{
  "data": [
    {
      "flight_id": 7,
      "personal_id": 7
    },
    {
      "flight_id": 2,
      "personal_id": 7
    }
  ]
}
```

### Таблица places
```sql
CREATE TABLE IF NOT EXISTS airport.places
(
    place_id      BIGSERIAL NOT NULL
        CONSTRAINT pk_place PRIMARY KEY,
    place_num     SMALLINT  NOT NULL,
    airplane_id   INT       NOT NULL,
    type_place_id SMALLINT  NOT NULL,
    CONSTRAINT uq_place_airplane UNIQUE (place_num, airplane_id)
)
```
В ней описаны следующие поля:
```
place_id      - ID места
place_num     - Номер места внутри самолёта
airplane_id   - ID самолёта
type_place_id - ID типа места
```
##### Пример создания места
```sql
SELECT airport.place_upd('{
  "place_num": 8,
  "airplane_id": 1,
  "type_place_id": 3
}');
```
##### Пример обновления данных места
```sql
SELECT airport.place_upd('{
  "place_id": 8,
  "place_num": 8,
  "airplane_id": 1,
  "type_place_id": 1
}');
```
##### Примеры исключений
```
{
  "errors": [
    {
      "error": "airport.place_upd.exceeded_the_seats",
      "detail": "Эконом и комфорт места.",
      "message": "Количество посадочных мест превышено указанному в параметрах самолёта."
    }
  ]
}
```
```
{
  "errors": [
    {
      "error": "airport.place_upd.exceeded_the_seats",
      "detail": "Бизнес места.",
      "message": "Количество посадочных мест превышено указанному в параметрах самолёта."
    }
  ]
}
```
##### Примеры GET запросов
```sql
place_get(_place_id bigint, _place_num integer, _airplane_id integer, _type_place_id integer)
```
```sql
SELECT airport.place_get(NULL, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "place_id": 1,
      "place_num": 1,
      "airplane_id": 1,
      "type_place_id": 1
    },
    {
      "place_id": 3,
      "place_num": 3,
      "airplane_id": 1,
      "type_place_id": 1
    },
    {
      "place_id": 6,
      "place_num": 5,
      "airplane_id": 1,
      "type_place_id": 3
    },
    {
      "place_id": 7,
      "place_num": 6,
      "airplane_id": 1,
      "type_place_id": 3
    },
    {
      "place_id": 10,
      "place_num": 1,
      "airplane_id": 2,
      "type_place_id": 1
    },
    {
      "place_id": 11,
      "place_num": 2,
      "airplane_id": 2,
      "type_place_id": 1
    },
    {
      "place_id": 12,
      "place_num": 3,
      "airplane_id": 2,
      "type_place_id": 1
    },
    {
      "place_id": 13,
      "place_num": 4,
      "airplane_id": 2,
      "type_place_id": 1
    },
    {
      "place_id": 14,
      "place_num": 5,
      "airplane_id": 2,
      "type_place_id": 1
    },
    {
      "place_id": 15,
      "place_num": 6,
      "airplane_id": 2,
      "type_place_id": 1
    },
    {
      "place_id": 17,
      "place_num": 7,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 18,
      "place_num": 8,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 19,
      "place_num": 9,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 20,
      "place_num": 10,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 2,
      "place_num": 2,
      "airplane_id": 1,
      "type_place_id": 2
    },
    {
      "place_id": 4,
      "place_num": 4,
      "airplane_id": 1,
      "type_place_id": 2
    }
  ]
}
```
```sql
SELECT airport.place_get(3, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "place_id": 3,
      "place_num": 3,
      "airplane_id": 1,
      "type_place_id": 1
    }
  ]
}
```
```sql
SELECT airport.place_get(NULL, 3, 1, NULL);
```
```json
{
  "data": [
    {
      "place_id": 3,
      "place_num": 3,
      "airplane_id": 1,
      "type_place_id": 1
    }
  ]
}
```
```sql
SELECT airport.place_get(NULL, NULL, NULL, 3);
```
```json
{
  "data": [
    {
      "place_id": 6,
      "place_num": 5,
      "airplane_id": 1,
      "type_place_id": 3
    },
    {
      "place_id": 7,
      "place_num": 6,
      "airplane_id": 1,
      "type_place_id": 3
    },
    {
      "place_id": 17,
      "place_num": 7,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 18,
      "place_num": 8,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 19,
      "place_num": 9,
      "airplane_id": 2,
      "type_place_id": 3
    },
    {
      "place_id": 20,
      "place_num": 10,
      "airplane_id": 2,
      "type_place_id": 3
    }
  ]
}
```
