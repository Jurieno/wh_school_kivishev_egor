[1. Таблица roles](#Таблица-roles)<br>
[2. Таблица types_place](#Таблица-types_place)

# Схема dictionary

### Таблица roles
```sql
CREATE TABLE IF NOT EXISTS dictionary.roles
(
    role_id SERIAL
        CONSTRAINT pk_role PRIMARY KEY,
    title   VARCHAR(50)
);
```
В ней описаны следующие поля:
```
role_id - ID должности
title   - Название
```

##### Примеры GET запросов
```sql
role_get(_role_id integer)
```
```sql
SELECT dictionary.role_get(NULL);
```
```json
{
  "data": [
    {
      "title": "Пилот",
      "role_id": 1
    },
    {
      "title": "Стюардеса",
      "role_id": 2
    }
  ]
}
```
```sql
SELECT dictionary.role_get(2);
```
```json
{
  "data": [
    {
      "title": "Стюардеса",
      "role_id": 2
    }
  ]
}
```

### Таблица types_place
```sql
CREATE TABLE IF NOT EXISTS dictionary.types_place
(
    type_place_id SMALLSERIAL
        CONSTRAINT pk_type_place PRIMARY KEY,
    title         VARCHAR(20)   NOT NULL,
    markup        NUMERIC(4, 2) NOT NULL
);
```
В ней описаны следующие поля:
```
type_place_id - ID типа места
title         - Название
markup        - Наценка
```
##### Пример GET запросов
```sql
type_place_get(_type_place_id integer)
```
```sql
SELECT dictionary.type_place_get(NULL);
```
```json
{
  "data": [
    {
      "title": "Стандарт",
      "markup": 1,
      "type_place_id": 1
    },
    {
      "title": "У окна",
      "markup": 1.2,
      "type_place_id": 2
    },
    {
      "title": "Бизнес",
      "markup": 3,
      "type_place_id": 3
    }
  ]
}
```
```sql
SELECT dictionary.type_place_get(2);
```
```json
{
  "data": [
    {
      "title": "У окна",
      "markup": 1.2,
      "type_place_id": 2
    }
  ]
}
```