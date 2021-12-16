-- найти рейсы по маршруту Москва - Хельсинки, доступные для бронирования (осталось более 4 часов до рейса) на указанную дату
-- с указанием авиакомпании, выполняющей данный рейс
-- и проверкой на то, что есть свободные места в указанном классе и категории билета
WITH available_flights as (SELECT
       flight_id, departure_time, arrival_time, aircraft_id, airlines.name as airline
FROM flights
INNER JOIN airlines on flights.airline_id = airlines.airline_id
WHERE
    status = 'available' and
    flights.departure_time > current_timestamp + '4 hour'::interval and
    flights.departure_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Москва'
        ) and
    flights.arrive_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Хельсинки'
        ))
SELECT DISTINCT
   flight_id, departure_time, arrival_time, airline
FROM available_flights, seats
WHERE
    seats.aircraft_id = available_flights.aircraft_id and
    seats.status = 'available' and
    seats.category = 'Взрослый' and
    seats.class = 'Эконом';

-- вывести авиакомпании, облуживающие рейс по маршруту Симферополь - Москва, доступные для бронирования (осталось более 4 часов до рейса) на указанную дату
-- и проверкой на то, что есть свободные места в указанном классе и категории билета
WITH available_flights as (SELECT
       flight_id, departure_time, arrival_time, aircraft_id, airlines.name as airline
FROM flights
INNER JOIN airlines on flights.airline_id = airlines.airline_id
WHERE
    status = 'available' and
    flights.departure_time > current_timestamp + '4 hour'::interval and
    flights.departure_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Симферополь'
        ) and
    flights.arrive_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Москва'
        ))
SELECT DISTINCT
   airline
FROM available_flights, seats
WHERE
    seats.aircraft_id = available_flights.aircraft_id and
    seats.status = 'available' and
    seats.category = 'Взрослый' and
    seats.class = 'Эконом';

-- найти самые дешевые билеты Эконом класса для Взрослого
-- на рейс Симферополь - Москва, доступный для бронирования (осталось более 4 часов до рейса) на указанную дату
-- и проверкой на то, что есть свободные места в указанном классе и категории билета
WITH available_flights as (SELECT
       flight_id, departure_time, arrival_time, aircraft_id, airlines.name as airline
FROM flights
INNER JOIN airlines on flights.airline_id = airlines.airline_id
WHERE
    status = 'available' and
    date(flights.departure_time) = date('2022-03-17') and
    flights.departure_time > date('2022-03-17') + '4 hour'::interval and
    flights.departure_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Симферополь'
        ) and
    flights.arrive_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Москва'
        ))
SELECT DISTINCT
    flight_id, departure_time, arrival_time, airline, price, fare_name
FROM available_flights, seats
WHERE
    seats.aircraft_id = available_flights.aircraft_id and
    seats.status = 'available' and
    seats.category = 'Взрослый' and
    seats.class = 'Эконом'
ORDER BY seats.price ASC
LIMIT 10;


-- показать все бронирования на рейс Симферополь - Москва
WITH ts as (
    WITH fl as (
        SELECT
               flight_id, departure_time, arrival_time
        FROM flights
        WHERE
            status = 'available' and
            flights.departure_time > current_timestamp + '4 hour'::interval and
            flights.departure_airport_id IN (
                SELECT airport_id FROM airports, cities
                WHERE
                      airports.city_id = cities.city_id and
                      cities.name = 'Симферополь'
                ) and
            flights.arrive_airport_id IN (
                SELECT airport_id FROM airports, cities
                WHERE
                      airports.city_id = cities.city_id and
                      cities.name = 'Москва'
                )
    )
    SELECT
        *
    FROM fl
    JOIN tickets on fl.flight_id = tickets.flight_id
)
SELECT * FROM bookings
JOIN ts on ts.booking_id = bookings.booking_id;


