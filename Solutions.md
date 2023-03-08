# Survey Questions

1. Top 5 arrival locations
~~~sql
SELECT arrival_location, COUNT(*)
FROM brt.trips
GROUP BY arrival_location
ORDER BY COUNT(*) DESC
LIMIT 5;
~~~
arrival_location | count
:---------------:|:----------:
Abule Egba| 41
Inner Marina|41
Aruna|41 
Ketu|40
Ajah|38

- For this, it was pretty straight forward, the data was in the trips table, so I used the COUNT function to gather the number of times each location appeared in the arrival_location column, and ordered it in descending order of the counts, then limited it by 5, to only show the 5 highest values.

---

2. Top performing drivers
~~~sql
ALTER TABLE brt.drivers
ADD COLUMN full_name text;

UPDATE brt.drivers
SET full_name = concat(first_name, ' ', last_name);


SELECT drivers.full_name, 
drivers.national_identity_number AS NIN, 
COUNT(trips.driver_id) AS total_trips
FROM brt.drivers AS drivers
INNER JOIN brt.trips AS trips
ON drivers.id = trips.driver_id
GROUP BY drivers.full_name, drivers.national_identity_number
ORDER BY total_trips DESC
LIMIT 10;
~~~
![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q2.png)

- Here, the requirement was to select the top performing drivers’ full names, NIN, and show the number of trips they have handled. We were asked to provide the drivers’ full names, so I created a new column for their full names, and use the concat() function on the first and last name columns to update their full names.
- The required data were in two different tables, so I used INNER JOIN to join the “trips” and “drivers” tables on the condition that the drivers’ id and trips’ driver_id were the same.
- I then selected the required columns, counting the “driver_id” column for the trips as “total_trips” to see how many times a driver went on a trip, then I ordered them by total trips in descending order and limited them by 10, to see only the top 10 performing drivers.

---

3. Frequent passengers
~~~sql
ALTER TABLE brt.passengers
ADD COLUMN full_name text;

UPDATE brt.passengers
SET full_name = concat(first_name, ' ', last_name);
~~~
~~~sql
SELECT passengers.full_name, passengers.email_address, COUNT(passenger_trips.passenger_id) AS total_trips
FROM brt.passengers AS passengers
INNER JOIN brt.passenger_trips AS passenger_trips
ON passengers.id = passenger_trips.passenger_id
GROUP BY passengers.full_name, passengers.email_address
ORDER BY total_trips DESC
LIMIT 10;
~~~
![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q3.png)
- In this question, the task was to select the full names and emails of the top 10 passengers, as in the previous question, I created a full name column for the passengers and updated it
- Then selected the information needed from both tables, using the COUNT() function again to select the top 10 appearing passenger IDs as total_trips and ordered them by the top 10 in descending order.
---

4. Driver - Vehicle pairings
~~~sql
SELECT drivers.full_name as driver_name, 
logs.driver_id,
vehicles.id as vehicle_id, 
vehicles.model, vehicles.plate_number
FROM brt.drivers as drivers
JOIN brt.driver_vehicle_logs AS logs
ON drivers.id = logs.driver_id
JOIN brt.vehicles as vehicles
ON logs.vehicle_id = vehicles.id;
~~~
![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q4.png)
- Here, the task was to find what drivers were paired to each vehicle, providing their full names, driver id, their vehicle id, the vehicle model, and its plate number.
- The information I needed for this was in 3 different tables, so I used two JOIN statements to draw information from the “drivers”, “driver_vehicle_logs”, and the “vehicles” tables. 
---

5. Highest issue dates
~~~sql
SELECT DISTINCT (issue_date), COUNT (*) as cards_issued
FROM brt.passenger_cards
GROUP BY issue_date
ORDER BY COUNT (*) DESC
LIMIT 5
~~~
issue_date|cards_issued
:--------:|:------------:
2022-05-19|5
2022-06-26|5
2022-05-17|3
2022-06-12|3
2022-02-11|3

- The task here was to select the dates where the most cards were issued, as well as the amount of cards issued on that date. 
- The query here was similar to that of question 1; select issue_date column and count the times each date appeared, order it by the count in descending order and limit it to the top 5 dates.
---

**That was it for the original business questions**

---

# My Questions

Next, I had to come up with more questions that could be useful for Jane to have further business insights for her company. 
After scanning the schema and the table contents, I came up with the following questions;

---

1.  Number of vehicles in use, available, under maintenance and out of use
~~~sql
SELECT status, COUNT (*)
FROM brt.vehicles
GROUP BY status
~~~
status|count
:----:|:----|
In use|14
Available|17
Under maintenance|21
Out of use|18

- This query selected the “status” column from the “vehicles” table, and counted how many times each status appeared.
---

2. Top 5 departure locations
~~~sql
SELECT departure_location, COUNT(*)
FROM brt.trips
GROUP BY departure_location
ORDER BY COUNT(*) DESC
LIMIT 5;
~~~
departure_location|count
:-----------------:|:------|
Alapere|41
Onipanu|39
Aruna|39
Irawo|38
Idera|38
- I ran a query similar to the arrival location one in the original business question
---

3. Drivers with licenses to be renewed within one year (current date is feb 14, 2023)
~~~sql
SELECT license.expiry_date, license.driver_id, drivers.full_name
FROM brt.license as license
JOIN brt.drivers as drivers
ON license.driver_id = drivers.id
WHERE license.expiry_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 year';
~~~
![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q8.png)

- For this, I used a JOIN statement to draw data from the “license” and “drivers” tables, to show drivers’ full names, IDs, and the expiry date.
- I also used a WHERE statement to filter the expiry_date column to select the dates between the current date(February 14th, 2023) and one year from that date, using the “+ INTERVAL ‘1 year’" clause.
---

4. Drivers with the biggest buses (trip_capacity)

--viewing highest trip capacity
~~~sql
SELECT trip_capacity
FROM brt.trips
ORDER BY trip_capacity DESC
~~~
- I first ran this query to determine what the highest capacities were for the buses

![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q9a.png)

--viewing drivers details
~~~sql
SELECT drivers.full_name as driver_name, 
		drivers.id,
       trips.trip_capacity
FROM brt.drivers as drivers
JOIN brt.trips as trips
ON drivers.id = trips.driver_id
WHERE trip_capacity = 55
~~~

- Then I used this JOIN query to select the buses with the highest capacity, linking them to their drivers information.

![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q9b.png)

---

5. 3 lowest performing drivers
~~~sql
SELECT drivers.full_name, drivers.email_address, COUNT(trips.driver_id) AS total_trips
FROM brt.drivers AS drivers
INNER JOIN brt.trips AS trips
ON drivers.id = trips.driver_id
GROUP BY drivers.full_name, drivers.email_address
ORDER BY total_trips
LIMIT 3;
~~~

![](https://github.com/imanjokko/Lagos-Metropolitan-BRT/blob/main/images/q10.png)

- This query was simply changing the order from descending to ascending for the query I ran in the original business question number 2
- But I decided to limit it to the lowest 3 performing drivers instead, changing it to LIMIT 10
- I also decided that their email addresses would be more useful information, to contact them and discuss ways to move forward with regards to their performances.
