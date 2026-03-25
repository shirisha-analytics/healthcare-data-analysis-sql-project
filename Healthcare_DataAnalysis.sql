
-- Data Exploration

USE healthcare_data;
SELECT count(*)
FROM healthcare;

SELECT *
FROM healthcare;

CREATE TABLE healthcare_staging AS
select *
FROM healthcare;

SELECT count(*)
FROM healthcare_staging;

SELECT *
FROM healthcare_staging;

-- Handling Missing Values

SELECT COUNT(*) AS total_rows,
SUM(Age= '') AS Missing_Age,
SUM(Gender= '') AS missing_gender,
SUM(Insurance_Type= '') AS missing_insurance
FROM healthcare_staging;

SELECT count(*)
FROM healthcare_staging
WHERE Age = '0';

-- Data Cleaning

DELETE from healthcare_staging
WHERE Age = '0';

UPDATE healthcare_staging
SET Gender= 'Unknown' 
WHERE Gender = '';

UPDATE healthcare_staging
SET Insurance_Type= 'Unknown'
WHERE Insurance_Type= '';

-- Data Type Conversion

UPDATE healthcare_staging
SET Booking_Date = REPLACE(Booking_Date, '-', '/'), Appointment_Date = REPLACE(Appointment_Date, '-', '/');

UPDATE healthcare_staging
SET Booking_Date = STR_to_date(Booking_Date, '%d/%m/%Y'), Appointment_Date = STR_to_date(Appointment_Date, '%d/%m/%Y');

ALTER TABLE healthcare_staging
MODIFY COLUMN Booking_Date DATE, MODIFY COLUMN Appointment_Date DATE;

SELECT *
FROM healthcare_staging;

SELECT count(DISTINCT Patient_ID) as Total_Patients
FROM healthcare_staging;

-- Demographic Analysis

SELECT Gender, AVG(Age) AS Avg_age
FROM healthcare_staging
Group by Gender
ORDER BY 2 DESC;

SELECT Insurance_Type, count(*) AS patient_count
FROM healthcare_staging
GROUP BY Insurance_Type
ORDER BY 2 DESC;

SELECT Gender, Insurance_Type, AVG(Age) AS Avg_age
FROM healthcare_staging
WHERE Age IS NOT NUll
Group by Gender, Insurance_Type
Order by Gender, Avg_age DESC;

-- Aggregated Insights

SELECT Insurance_Type,  YEAR(`Booking_Date`), Gender, count(*) as total_booking
FROM healthcare_staging
Group by Insurance_Type,  YEAR(`Booking_Date`), Gender
ORDER BY Insurance_Type,  YEAR(`Booking_Date`), Gender;

WITH Total_Booking_Year(Insurance_Type, `Year`, Gender, total_booking) AS
(
SELECT Insurance_Type,  YEAR(`Booking_Date`), Gender, count(*) as total_booking
FROM healthcare_staging
Group by Insurance_Type,  YEAR(`Booking_Date`), Gender
ORDER BY Insurance_Type,  YEAR(`Booking_Date`), Gender
)
SELECT *, DENSE_RANK() OVER(PARTITION BY `Year`  ORDER BY  total_booking DESC) AS Ranking
 FROM Total_Booking_Year
 WHERE `Year` IS NOT NULL;
 


