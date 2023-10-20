[1. Таблица employees](#Таблица-employees)<br>
[2. Таблица personal](#Таблица-personal)

# Схема users

### Таблица employees
```sql
CREATE TABLE IF NOT EXISTS users.employees
(
    employee_id  BIGSERIAL
        CONSTRAINT pk_employees PRIMARY KEY,
    num_series   SMALLINT    NOT NULL,
    num_pass     CHAR(7)     NOT NULL,
    dt_issue     DATE        NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    email        varchar(50) NOT NULL,
    firstname    varchar(50) NOT NULL,
    lastname     varchar(70) NOT NULL,
    dt_birthday  DATE        NOT NULL,
    gender       BOOLEAN     NOT NULL,
    CONSTRAINT uq_users_ser_pass UNIQUE (num_series, num_pass)
)
```
В ней описаны следующие поля:
```
employee_id  - ID пассажира
num_series   - Серия паспорта
num_pass     - Номер паспорта
dt_issue     - Дата выдачи паспорта
phone_number - Номер телефона
email        - Электронная почта
firstname    - Имя
lastname     - Фамилия
dt_birthday  - Дата рождения
gender       - Пол
```
Ограничение уникальности установлено на 2 поля: num_series, num_pass
##### Пример создания пассажира
```sql
SELECT users.employee_upd('{
  "num_series": "1238",
  "num_pass": "123659",
  "dt_issue": "2022-02-01",
  "phone_number": "79253290022",
  "email": "tutatuta@mail.ru",
  "firstname": "Антон",
  "lastname": "Павлов",
  "dt_birthday": "2002-03-01",
  "gender": 0
}');
```
##### Пример обновления данных пассажира
```sql
SELECT users.employee_upd('{
  "employee_id": 4,
  "num_series": "1111",
  "num_pass": "123659",
  "dt_issue": "2022-02-01",
  "phone_number": "79253290022",
  "email": "antonpavlov@mail.ru",
  "firstname": "Антон",
  "lastname": "Павлов",
  "dt_birthday": "2002-03-01",
  "gender": 0
}');
```
##### Пример исключения
```json
{
  "errors": [
    {
      "error": "users.employee_upd.repeat_series_pass",
      "detail": null,
      "message": "Такой пользователь с серией и номером паспорта уже зарегистрирован."
    }
  ]
}
```
##### Примеры GET запросов
```sql
employee_get(_employee_id bigint, _num_series integer, _num_pass character, _phone_number varchar)
```
```sql
SELECT users.employee_get(NULL, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "email": "tutatuta@mail.ru",
      "gender": false,
      "dt_issue": "2022-02-01",
      "lastname": "Васильев",
      "num_pass": "123656 ",
      "firstname": "Пётр",
      "num_series": 1231,
      "dt_birthday": "2001-02-01",
      "employee_id": 1,
      "phone_number": "79253290022"
    },
    {
      "email": "tutatuta@mail.ru",
      "gender": false,
      "dt_issue": "2022-02-01",
      "lastname": "Васильев",
      "num_pass": "123655 ",
      "firstname": "Пётр",
      "num_series": 1231,
      "dt_birthday": "2001-02-01",
      "employee_id": 3,
      "phone_number": "79253290022"
    },
    {
      "email": "tutatuta@mail.ru",
      "gender": false,
      "dt_issue": "2022-02-01",
      "lastname": "Павлов",
      "num_pass": "123659 ",
      "firstname": "Егор",
      "num_series": 1238,
      "dt_birthday": "2002-03-01",
      "employee_id": 4,
      "phone_number": "79253290000"
    }
  ]
}
```
```sql
SELECT users.employee_get(NULL, 1231, '123656 '::char(7), NULL);
```
```json
{
  "data": [
    {
      "email": "tutatuta@mail.ru",
      "gender": false,
      "dt_issue": "2022-02-01",
      "lastname": "Васильев",
      "num_pass": "123656 ",
      "firstname": "Пётр",
      "num_series": 1231,
      "dt_birthday": "2001-02-01",
      "employee_id": 1,
      "phone_number": "79253290022"
    }
  ]
}
```
```sql
SELECT users.employee_get(3, NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "email": "tutatuta@mail.ru",
      "gender": false,
      "dt_issue": "2022-02-01",
      "lastname": "Васильев",
      "num_pass": "123655 ",
      "firstname": "Пётр",
      "num_series": 1231,
      "dt_birthday": "2001-02-01",
      "employee_id": 3,
      "phone_number": "79253290022"
    }
  ]
}
```
```sql
SELECT users.employee_get(NULL, NULL, NULL, '79253290000');
```
```json
{
  "data": [
    {
      "email": "tutatuta@mail.ru",
      "gender": false,
      "dt_issue": "2022-02-01",
      "lastname": "Павлов",
      "num_pass": "123659 ",
      "firstname": "Егор",
      "num_series": 1238,
      "dt_birthday": "2002-03-01",
      "employee_id": 4,
      "phone_number": "79253290000"
    }
  ]
}
```

### Таблица personal
```sql
CREATE TABLE IF NOT EXISTS users.personal
(
    personal_id  SERIAL
        CONSTRAINT pk_personal PRIMARY KEY,
    role_id      INT         NOT NULL,
    firstname    VARCHAR(50) NOT NULL,
    lastname     varchar(50) NOT NULL,
    phone_number varchar(11) NOT NULL
);
```
В ней описаны следующие поля:
```
personal_id  - ID персонала
role_id      - ID должности
firstname    - Имя
lastname     - Фамилия
phone_number - Номер телефона
```
##### Пример добавления персонала
```sql
SELECT users.personal_upd('{
  "role_id": 1,
  "firstname": "Василий",
  "lastname": "Птушкин",
  "phone_number": "79233290022"
}');
```
##### Пример изменения данных персонала
```sql
SELECT users.personal_upd('{
  "personal_id": 5,
  "role_id": 1,
  "firstname": "Василий",
  "lastname": "Птушкин",
  "phone_number": "79230001100"
}');
```
##### Пример GET запросов
```sql
personal_get(_personal_id integer, _role_id integer, _phone_number varchar)
```
```sql
SELECT users.personal_get(NULL, NULL, NULL);
```
```json
{
  "data": [
    {
      "role_id": 1,
      "lastname": "Птушкин",
      "firstname": "Василий",
      "personal_id": 5,
      "phone_number": "79233290022"
    },
    {
      "role_id": 2,
      "lastname": "Васин",
      "firstname": "Георгий",
      "personal_id": 6,
      "phone_number": "79005553344"
    },
    {
      "role_id": 2,
      "lastname": "Георгин",
      "firstname": "Василий",
      "personal_id": 7,
      "phone_number": "79005553224"
    },
    {
      "role_id": 2,
      "lastname": "Болошко",
      "firstname": "Анна",
      "personal_id": 8,
      "phone_number": "79005550000"
    },
    {
      "role_id": 1,
      "lastname": "Кривченко",
      "firstname": "Фёдор",
      "personal_id": 9,
      "phone_number": "79005551122"
    }
  ]
}
```
```sql
SELECT users.personal_get(7, NULL, NULL);
```
```json
{
  "data": [
    {
      "role_id": 2,
      "lastname": "Георгин",
      "firstname": "Василий",
      "personal_id": 7,
      "phone_number": "79005553224"
    }
  ]
}
```
```sql
SELECT users.personal_get(NULL, 2, NULL);
```
```json
{
  "data": [
    {
      "role_id": 2,
      "lastname": "Васин",
      "firstname": "Георгий",
      "personal_id": 6,
      "phone_number": "79005553344"
    },
    {
      "role_id": 2,
      "lastname": "Георгин",
      "firstname": "Василий",
      "personal_id": 7,
      "phone_number": "79005553224"
    },
    {
      "role_id": 2,
      "lastname": "Болошко",
      "firstname": "Анна",
      "personal_id": 8,
      "phone_number": "79005550000"
    }
  ]
}
```
```sql
SELECT users.personal_get(NULL, NULL, '79005553224');
```
```json
{
  "data": [
    {
      "role_id": 2,
      "lastname": "Георгин",
      "firstname": "Василий",
      "personal_id": 7,
      "phone_number": "79005553224"
    }
  ]
}
```