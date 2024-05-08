--Q1 and Q2
SELECT *
FROM [Corona Virus Dataset]
WHERE Province IS NULL
   OR [Country Region] IS NULL
   OR Latitude IS NULL
   OR Longitude IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;

--There is no NULL values
-----------------------------------------------------------------
--Q3
Select COUNT(*)
From [Corona Virus Dataset]
--Number of rows = 78386

--------------------------------------------------------------------
--Q4

CREATE TABLE InvalidDatesTable (

    Province varchar(50),
    [Countery Region] VARCHAR(50),
    Latitude varchar(50),
    Longitude varchar(50),
	Date varchar(50),
	Confirmed varchar(50),
    Deaths varchar(50),
    Recovered varchar(50)

);

INSERT INTO InvalidDatesTable
SELECT *
FROM [Corona Virus Dataset]
WHERE ISDATE(Date) = 0;

DELETE FROM [Corona Virus Dataset]
WHERE ISDATE(Date) = 0;

Select * from InvalidDatesTable


ALTER TABLE [Corona Virus Dataset]
ALTER COLUMN Date DATE;


SELECT MIN(Date) AS Start_date, MAX(Date) AS End_date
FROM [Corona Virus Dataset];

-- Start_date 2020-01-02
-- End_date 2021-12-06

-------------------------------------------------------------------

--Q5
DECLARE @Start_date DATE = '2020-01-02';
DECLARE @End_date DATE = '2021-12-06';

SELECT DATEDIFF(MONTH, @Start_date, @End_date) + 1 AS months_between;
-- 24 months

-----------------------------------------------------------------------
--Q6
SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    AVG(CAST(Confirmed AS float)) AS avg_confirmed,
    AVG(CAST(Deaths AS float)) AS avg_deaths,
    AVG(CAST(Recovered AS float)) AS avg_recovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date),
    MONTH(Date)
ORDER BY 
    year, month;
-----------------------------------------------------------------------
--Q7

WITH MonthlyCounts AS (
    SELECT 
        YEAR(Date) AS year,
        MONTH(Date) AS month,
        Confirmed,
        Deaths,
        Recovered,
        ROW_NUMBER() OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY COUNT(*) DESC) AS row_num
    FROM 
        [Corona Virus Dataset]

	WHERE 
        Confirmed > 0
        AND Deaths > 0
        AND Recovered > 0
    GROUP BY 
        YEAR(Date),
        MONTH(Date),
        Confirmed,
        Deaths,
        Recovered
)

SELECT 
    year,
    month,
    confirmed,
    deaths,
    recovered
FROM 
    MonthlyCounts
WHERE 
    row_num = 1;

------------------------------------------------------------------------

--Q8

SELECT 
    YEAR(Date) AS year,
    MIN(CASE WHEN Confirmed > 0 THEN Confirmed ELSE NULL END) AS min_confirmed,
    MIN(CASE WHEN Deaths > 0 THEN Deaths ELSE NULL END) AS min_deaths,
    MIN(CASE WHEN Recovered > 0 THEN Recovered ELSE NULL END) AS min_recovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(date);


-------------------------------------------------------------------------
--Q9

SELECT 
    YEAR(Date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(date);
-----------------------------------------------------------------------------
--Q10
SELECT 
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(CAST(Confirmed AS float)) AS total_confirmed,
    SUM(CAST(Deaths AS float)) AS total_deaths,
    SUM(CAST(Recovered AS float)) AS total_recovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date),
    MONTH(Date)

Order by
	YEAR(Date),
	Month(Date);

------------------------------------------------------------------
--Q11
-- Calculate total confirmed cases
SELECT 
    SUM(CAST(Confirmed AS float)) AS total_confirmed_cases
FROM 
    [Corona Virus Dataset];

-- Calculate average confirmed cases
SELECT 
    AVG(CAST(Confirmed AS float)) AS average_confirmed_cases
FROM 
    [Corona Virus Dataset];

-- Calculate variance of confirmed cases
SELECT 
    AVG(CAST(Confirmed AS float) *CAST(Confirmed AS float)) - AVG(CAST(Confirmed AS float)) * AVG(CAST(Confirmed AS float)) AS variance_confirmed_cases
FROM 
    [Corona Virus Dataset];


-- Calculate standard deviation of confirmed cases
SELECT 
    STDEV(CAST(Confirmed AS float)) AS stdev_confirmed_cases
FROM 
    [Corona Virus Dataset];
-----------------------------------------------------------------------
--Q12
-- Calculate total death cases per month
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(CAST(deaths AS FLOAT)) AS total_death_cases
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(date),
    MONTH(date)
ORDER BY 
    year, month;

-- Calculate average death cases per month
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    AVG(CAST(deaths AS FLOAT)) AS average_death_cases
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(date),
    MONTH(date)
ORDER BY 
    year, month;

-- Calculate variance of death cases per month
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    AVG(CAST(deaths AS FLOAT) * CAST(deaths AS FLOAT)) - AVG(CAST(deaths AS FLOAT)) * AVG(CAST(deaths AS FLOAT)) AS variance_death_cases
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(date),
    MONTH(date)
ORDER BY 
    year, month;


-- Calculate standard deviation of death cases per month
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    STDEV(CAST(deaths AS FLOAT)) AS stdev_death_cases
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(date),
    MONTH(date)
ORDER BY 
    year, month;

----------------------------------------------------------------------------
--Q13
-- Calculate total Recovered cases
SELECT 
    SUM(CAST(Recovered AS float)) AS total_confirmed_cases
FROM 
    [Corona Virus Dataset];

-- Calculate average Recovered cases
SELECT 
    AVG(CAST(Recovered AS float)) AS average_confirmed_cases
FROM 
    [Corona Virus Dataset];

-- Calculate variance of Recovered cases
SELECT 
    AVG(CAST(Recovered AS float) *CAST(Recovered AS float)) - AVG(CAST(Recovered AS float)) * AVG(CAST(Recovered AS float)) AS variance_confirmed_cases
FROM 
    [Corona Virus Dataset];


-- Calculate standard deviation of Recovered cases
SELECT 
    STDEV(CAST(Recovered AS float)) AS stdev_confirmed_cases
FROM 
    [Corona Virus Dataset];

-------------------------------------------------------------------------
--Q14

SELECT [Country Region]
FROM [Corona Virus Dataset]
WHERE Confirmed = (SELECT MAX(Confirmed) FROM [Corona Virus Dataset]);

-- (1) Ireland
-- (2)Saudi Arabia
-- (3)Saudi Arabia
-- (4)Lithuania
--------------------------------------------------------------------------
--Q15

SELECT Deaths,[Country Region]
FROM [Corona Virus Dataset]
WHERE Deaths = (SELECT MAX(Deaths) FROM [Corona Virus Dataset]);

-- Italy 933

----------------------------------------------------------------------------

--Q16

SELECT [Country Region], Highest_Recovered_Cases
FROM (
    SELECT 
        [Country Region], 
        MAX(Recovered) AS Highest_Recovered_Cases,
        ROW_NUMBER() OVER (ORDER BY MAX(Recovered) DESC) AS RowNum
    FROM [Corona Virus Dataset]
    GROUP BY [Country Region]
) AS RankedCountries
WHERE RowNum <= 5;

--Tunisia 999
--Ethiopia 999
--Mexico  9987
--Hungary 998
--North Macedonia 998

-------------------------------------------------------------------------