# Schema Definition
~~~sql Schema Definition
DROP SCHEMA IF EXISTS brt;
CREATE SCHEMA brt;
~~~

# Table Definition
~~~sql
-- (1) 
CREATE TABLE brt.corridor_locations (
  id integer PRIMARY KEY,
  name varchar(20) UNIQUE NOT NULL
);

-- (2) 
CREATE TABLE brt.passengers (
  id integer PRIMARY KEY,
  first_name varchar(20) NOT NULL,
  last_name varchar(20) NOT NULL,
  gender char(1) NOT NULL CHECK(gender IN ('M', 'F', 'O')),
  email_address varchar(50) UNIQUE NOT NULL,
  address varchar(100) NOT NULL 
);

-- (3) 
CREATE TABLE brt.drivers (
  id integer PRIMARY KEY,
  first_name varchar(20) NOT NULL,
  last_name varchar(20) NOT NULL,
  gender char(1) NOT NULL CHECK(gender IN ('M', 'F', 'O')),
  email_address varchar(50) UNIQUE NOT NULL,
  address varchar(100) NOT NULL,
  date_of_birth date CHECK((date_part('year', NOW()) - date_part('year', date_of_birth)) > 25), -- This validates that any driver recorded should be above 25 years of age
  national_identity_number char(11) UNIQUE NOT NULL
);

-- (4) 
CREATE TABLE brt.vehicles (
  id integer PRIMARY KEY,
  vin varchar(20) UNIQUE NOT NULL,
  plate_number varchar(10) UNIQUE NOT NULL,
  model varchar(50) NOT NULL,
  capacity integer NOT NULL,
  status varchar(20) NOT NULL CHECK(status IN ('Available', 'In use', 'Under maintenance', 'Out of use'))
);

-- (5) 
CREATE TABLE brt.passenger_cards (
  id integer PRIMARY KEY,
  card_number varchar(10) UNIQUE NOT NULL,
  issue_date date DEFAULT NOW(),
  phone_number varchar(12) UNIQUE NOT NULL,
  passenger_id integer NOT NULL,
  FOREIGN KEY (passenger_id) REFERENCES brt.passengers (id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- (6) 
CREATE TABLE brt.trips (
  id integer PRIMARY KEY,
  departure_location varchar(20) NOT NULL,
  arrival_location varchar(20) NOT NULL CHECK(arrival_location <> departure_location), -- This validates that arrival location is not equal to departure location
  departure_time timestamp NOT NULL,
  arrival_time timestamp NOT NULL CHECK(arrival_time > departure_time), -- This ensures that arrival time is greater than departure time
  driver_id integer NOT NULL,
  trip_capacity integer NOT NULL CHECK(trip_capacity > 0), -- This ensures that no driver conveys zero passengers
  FOREIGN KEY (driver_id) REFERENCES brt.drivers (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- (7) 
CREATE TABLE brt.passenger_trips (
  id integer,
  passenger_id integer NOT NULL,
  trip_id integer NOT NULL,
  price decimal NOT NULL,
  PRIMARY KEY (passenger_id, trip_id), -- Composite keys bearing the not null and unique attributes due the primary key characteristics
  FOREIGN KEY (passenger_id) REFERENCES brt.passengers (id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (trip_id) REFERENCES brt.trips (id) ON DELETE RESTRICT -- Deleting from the trips table would lead to a violation of this foreign key constraint
);

-- (8) 
CREATE TABLE brt.driver_vehicle_logs (
  id integer PRIMARY KEY,
  driver_id integer NOT NULL,
  vehicle_id integer NOT NULL,
  pair_date date DEFAULT NOW(), -- Left untouched for future records. 
  FOREIGN KEY (driver_id) REFERENCES brt.drivers (id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (vehicle_id) REFERENCES brt.vehicles (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- (9) 
CREATE TABLE brt.driver_identification_cards (
  id integer,
  card_no char(5) PRIMARY KEY,
  issue_date date DEFAULT NOW(),
  driver_id integer UNIQUE NOT NULL, -- Enforcing a 1-1 relationship 
  FOREIGN KEY (driver_id) REFERENCES brt.drivers (id) ON UPDATE CASCADE ON DELETE CASCADE
);

ALTER TABLE brt.driver_identification_cards
ADD UNIQUE (id);

ALTER TABLE brt.driver_identification_cards
ALTER COLUMN id SET NOT NULL;

-- (10) 
CREATE TABLE brt.driver_additional_details (
  id integer PRIMARY KEY,
  phone_number varchar(12) UNIQUE NOT NULL,
  driver_id integer NOT NULL,
  FOREIGN KEY (driver_id) REFERENCES brt.drivers (id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- (11) 
CREATE TABLE brt.license (
  id SERIAL PRIMARY KEY,
  license_number varchar(12) UNIQUE NOT NULL,
  issue_date date NOT NULL CHECK((date_part('year', NOW()) - date_part('year', issue_date)) > 1),
  expiry_date date NOT NULL CHECK(expiry_date > issue_date),
  license_status varchar(7) DEFAULT('TBD'), -- Left untouched for single inserts
  driver_id integer UNIQUE, -- Enforcing a 1-1 relationship
  FOREIGN KEY (driver_id) REFERENCES brt.drivers (id)  ON UPDATE CASCADE ON DELETE CASCADE
);
~~~

# Table Import
The import operation should follow this order 
| Table | Order |
| --- | --- |
| corridor_locations | 1st import |
| drivers | 2nd import |
| passengers | 3rd import |
| vehicles | 4th import |
| passenger_cards | 5th import |
| trips | 6th import |
| passenger_trips | 7th import |
| driver_vehicle_logs | 8th import |
| driver_identification_cards | 9th import |
| driver_additional_details | 10th import |
| license | 11th import |
