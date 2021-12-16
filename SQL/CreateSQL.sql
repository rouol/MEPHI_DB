CREATE TABLE Aircrafts
(
  aircraft_id INT NOT NULL,
  model TEXT NOT NULL,
  PRIMARY KEY (aircraft_id)
);

CREATE TABLE Airlines
(
  airline_id INT NOT NULL,
  name TEXT NOT NULL,
  contact_info TEXT NOT NULL,
  PRIMARY KEY (airline_id)
);

CREATE TABLE Countries
(
  country_id INT NOT NULL,
  name TEXT NOT NULL,
  PRIMARY KEY (country_id)
);

CREATE TABLE Passengers
(
  passenger_id INT NOT NULL,
  date_of_birth DATE NOT NULL,
  citizenship TEXT NOT NULL,
  document_type TEXT NOT NULL,
  document_number TEXT NOT NULL,
  PRIMARY KEY (passenger_id)
);

CREATE TABLE Seats
(
  category TEXT NOT NULL,
  class TEXT NOT NULL,
  fare_name TEXT NOT NULL,
  number TEXT NOT NULL,
  seat_id INT NOT NULL,
  price FLOAT NOT NULL,
  status TEXT NOT NULL,
  aircraft_id INT NOT NULL,
  PRIMARY KEY (seat_id),
  FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id)
);

CREATE TABLE Bookings
(
  booking_id INT NOT NULL,
  datetime timestamp NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  surname TEXT NOT NULL,
  name TEXT NOT NULL,
  patronymic TEXT NOT NULL,
  PRIMARY KEY (booking_id)
);

CREATE TABLE Cities
(
  city_id INT NOT NULL,
  name TEXT NOT NULL,
  country_id INT NOT NULL,
  PRIMARY KEY (city_id),
  FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);

CREATE TABLE Airports
(
  airport_id INT NOT NULL,
  name TEXT NOT NULL,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  timezone TEXT NOT NULL,
  city_id INT NOT NULL,
  PRIMARY KEY (airport_id),
  FOREIGN KEY (city_id) REFERENCES Cities(city_id)
);

CREATE TABLE Flights
(
  flight_id INT NOT NULL,
  departure_time timestamp NOT NULL,
  arrival_time timestamp NOT NULL,
  status TEXT NOT NULL,
  actual_departure_time timestamp NOT NULL,
  actual_arrival_time timestamp NOT NULL,
  departure_airport_id INT NOT NULL,
  arrive_airport_id INT NOT NULL,
  airline_id INT NOT NULL,
  aircraft_id INT NOT NULL,
  PRIMARY KEY (flight_id),
  FOREIGN KEY (departure_airport_id) REFERENCES Airports(airport_id),
  FOREIGN KEY (arrive_airport_id) REFERENCES Airports(airport_id),
  FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
  FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id)
);

CREATE TABLE Tickets
(
  seat_number TEXT NOT NULL,
  ticket_id INT NOT NULL,
  passenger_id INT NOT NULL,
  flight_id INT NOT NULL,
  booking_id INT NOT NULL,
  PRIMARY KEY (ticket_id),
  FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
  FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);