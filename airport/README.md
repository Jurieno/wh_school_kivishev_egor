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
### Примеры исключений
```json
{
  "errors": [
    {
      "error": "airport.flight_upd",
      "detail": null,
      "message": "Аэропорт вылета не может совпадать с аэропортом посадки."
    }
  ]
}
```
```json
{
  "errors": [
    {
      "error": "airport.flight_upd",
      "detail": null,
      "message": "Цена не может быть ниже или равна нулю."
    }
  ]
}
```
