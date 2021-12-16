-- найти в какие даты и рейсы каких авиакомпаний можно прилететь из Симферополя в Хельсинки (с пересадкой в Москве)
-- для Взрослого в Экономе, причем до Москвы на рейсе Аэрофлота
-- и вычислить среднюю стоимость билета
WITH available_flights_to as (
    WITH flights_to as (SELECT
       flight_id, departure_time, arrival_time, aircraft_id
    FROM flights
    INNER JOIN airlines on airlines.airline_id = flights.airline_id
    WHERE
        airlines.name = 'Аэрофлот' and
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
        departure_time, arrival_time, price, fare_name
    FROM flights_to, airlines, seats
    WHERE
        seats.aircraft_id = flights_to.aircraft_id and
        seats.status = 'available' and
        seats.category = 'Взрослый' and
        seats.class = 'Эконом'
    LIMIT 10),
avg_to as (
    SELECT
        AVG(available_flights_to.price) as avg_cost
    FROM available_flights_to
),
available_flights_next as (
    WITH flights_next as (SELECT
       flights.flight_id, flights.departure_time, flights.arrival_time, flights.aircraft_id
    FROM flights, available_flights_to
    WHERE
        status = 'available' and
        flights.departure_time > available_flights_to.arrival_time + '1 hour'::interval and
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
        departure_time, arrival_time, price, fare_name
    FROM flights_next, airlines, seats
    WHERE
        seats.aircraft_id = flights_next.aircraft_id and
        seats.status = 'available' and
        seats.category = 'Взрослый' and
        seats.class = 'Эконом'
    LIMIT 10),
avg_next as (
    SELECT
        AVG(available_flights_next.price) as avg_cost
    FROM available_flights_next
),
count_next as (
    SELECT
        COUNT(available_flights_next) as fl_count
    FROM available_flights_next
)
SELECT
    avg_to.avg_cost + avg_next.avg_cost as "средняя цена рейсов с пересадкой",
    fl_count as "число рейсов"
FROM avg_to, avg_next, count_next;
