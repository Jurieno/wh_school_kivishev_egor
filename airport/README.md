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
### Пример исключения
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
### Примеры исключений
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

