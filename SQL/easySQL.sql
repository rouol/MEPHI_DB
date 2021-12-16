-- рейсы по маршруту Москва - Хельсинки, доступные для бронирования (осталось более 4 часов до рейса)
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
              cities.name = 'Москва'
        ) and
    flights.arrive_airport_id IN (
        SELECT airport_id FROM airports, cities
        WHERE
              airports.city_id = cities.city_id and
              cities.name = 'Хельсинки'
        );

-- авиакомпании на рейсы которые есть бронирования
SELECT DISTINCT
    airlines.name
FROM airlines
JOIN flights f on airlines.airline_id = f.airline_id
JOIN tickets t on f.flight_id = t.flight_id;


-- показать на какие рейсы забронировал Федоров Евгений
WITH booked as (
    SELECT
        *
    FROM bookings
    WHERE
        bookings.surname = 'Федоров' and
        bookings.name = 'Евгений'
)
SELECT
    f.flight_id
FROM tickets
JOIN booked on booked.booking_id = ticket_id
JOIN flights f on tickets.flight_id = f.flight_id;

-- откуда и куда?
WITH booked as (
    SELECT
        *
    FROM bookings
    WHERE
        bookings.surname = 'Федоров' and
        bookings.name = 'Евгений'
)
SELECT
    cd.name as "откуда", ca.name as "куда"
FROM tickets
JOIN booked on booked.booking_id = ticket_id
JOIN flights f on tickets.flight_id = f.flight_id
JOIN airports ad on ad.airport_id = f.departure_airport_id
JOIN airports aa on aa.airport_id = f.arrive_airport_id
JOIN cities ca on ca.city_id = aa.city_id
JOIN cities cd on cd.city_id = ad.city_id;

-- показать все занятые места
SELECT * FROM seats
WHERE status = 'booked';
-- очистить все занятые места
UPDATE seats
SET status = 'available'
WHERE status = 'booked';

-- забронировать указанное место
UPDATE seats
SET status = 'booked'
WHERE seat_id = 1501340010055;
-- снять бронь с указанного места
UPDATE seats
SET status = 'available'
WHERE seat_id = 1501340010055;
-- проверка
SELECT * FROM seats
WHERE seat_id = 1501340010055
LIMIT 10;