-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--business questions
--1. top 5 arrival locations
SELECT arrival_location, COUNT(*)
FROM brt.trips
GROUP BY arrival_location
ORDER BY COUNT(*) DESC
LIMIT 5;


--2. top performing drivers
ALTER TABLE brt.drivers
ADD COLUMN full_name text;

UPDATE brt.drivers
SET full_name = concat(first_name, ' ', last_name);


SELECT drivers.full_name, drivers.national_identity_number AS NIN, COUNT(trips.driver_id) AS total_trips
FROM brt.drivers AS drivers
INNER JOIN brt.trips AS trips
ON drivers.id = trips.driver_id
GROUP BY drivers.full_name, drivers.national_identity_number
ORDER BY total_trips DESC
LIMIT 10;


--3. frequent passengers
ALTER TABLE brt.passengers
ADD COLUMN full_name text;

UPDATE brt.passengers
SET full_name = concat(first_name, ' ', last_name);


SELECT passengers.full_name, passengers.email_address, COUNT(passenger_trips.passenger_id) AS total_trips
FROM brt.passengers AS passengers
INNER JOIN brt.passenger_trips AS passenger_trips
ON passengers.id = passenger_trips.passenger_id
GROUP BY passengers.full_name, passengers.email_address
ORDER BY total_trips DESC
LIMIT 10;


--4.driver - vehicle pairings
SELECT drivers.full_name as driver_name, 
logs.driver_id,
vehicles.id as vehicle_id, 
vehicles.model, vehicles.plate_number
FROM brt.drivers as drivers
JOIN brt.driver_vehicle_logs AS logs
ON drivers.id = logs.driver_id
JOIN brt.vehicles as vehicles
ON logs.vehicle_id = vehicles.id;


--5.highest issue dates
SELECT DISTINCT (issue_date), COUNT (*) as cards_issued
FROM brt.passenger_cards
GROUP BY issue_date
ORDER BY COUNT (*) DESC
LIMIT 5


--------------------------------------------------------------------------
--my additional questions
--1. no of vehicles in use, available, under maintenance and out of us
SELECT status, COUNT (*)
FROM brt.vehicles
GROUP BY status


--2. top 5 departure locations
SELECT departure_location, COUNT(*)
FROM brt.trips
GROUP BY departure_location
ORDER BY COUNT(*) DESC
LIMIT 5;


--3. drivers with licenses to be renewed within one year (current date is feb 14, 2023)
SELECT license.expiry_date, license.driver_id, drivers.full_name
FROM brt.license as license
JOIN brt.drivers as drivers
ON license.driver_id = drivers.id
WHERE license.expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 year';


--4. drivers with the biggest buses (trip_capacity)
--viewing highest trip capacity
SELECT trip_capacity
FROM brt.trips
ORDER BY trip_capacity DESC

--viewing drivers details
SELECT drivers.full_name as driver_name, 
		drivers.id,
       trips.trip_capacity
FROM brt.drivers as drivers
JOIN brt.trips as trips
ON drivers.id = trips.driver_id
WHERE trip_capacity = 55


--5. 3 lowest performing drivers
SELECT drivers.full_name, drivers.email_address, COUNT(trips.driver_id) AS total_trips
FROM brt.drivers AS drivers
INNER JOIN brt.trips AS trips
ON drivers.id = trips.driver_id
GROUP BY drivers.full_name, drivers.email_address
ORDER BY total_trips
LIMIT 3;