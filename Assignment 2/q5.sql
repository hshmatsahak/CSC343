-- Lure Them Back

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q5 cascade;

CREATE TABLE q5 (
    patronID CHAR(20) NOT NULL,
    email TEXT NOT NULL,
    usage INT NOT NULL,
    decline INT NOT NULL,
    missed INT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS PatronYearMonth CASCADE;
DROP VIEW IF EXISTS PatronYearFull CASCADE;
DROP VIEW IF EXISTS PatronYearMonthFull CASCADE;
DROP VIEW IF EXISTS PatronYearDistinct CASCADE;
DROP VIEW IF EXISTS EveryMonth2022 CASCADE;
DROP VIEW IF EXISTS Atleast5Month2023 CASCADE;
DROP VIEW IF EXISTS Atleast1Inactive2023 CASCADE;
DROP VIEW IF EXISTS Nothing2024 CASCADE;
DROP VIEW IF EXISTS DiminishingPatrons CASCADE;
DROP VIEW IF EXISTS Final CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW PatronYearMonth AS
SELECT patron, EXTRACT(YEAR from checkout_time) as year, EXTRACT(MONTH from checkout_time) as month
FROM Checkout;

CREATE VIEW PatronYearFull AS
SELECT card_number as patron, year 
FROM (SELECT card_number FROM Patron) AllPatrons CROSS JOIN (VALUES (2022), (2023), (2024)) AS Years(year);

CREATE VIEW PatronYearMonthFull AS
SELECT patron, year, month FROM PatronYearFull NATURAL LEFT JOIN PatronYearMonth;

CREATE VIEW PatronYearDistinct AS
SELECT patron, year, CASE WHEN count(month) = 0 THEN 0 ELSE count(distinct month) END AS distinctmonths
FROM PatronYearMonthFull
GROUP BY patron, year;

CREATE VIEW EveryMonth2022 AS
SELECT patron as patronID
FROM PatronYearDistinct
WHERE year = 2022 and distinctmonths = 12;

CREATE VIEW Atleast5Month2023 AS
SELECT patron as patronID
FROM PatronYearDistinct
WHERE year = 2023 and distinctmonths >= 5;

CREATE VIEW Atleast1Inactive2023 AS
SELECT patron as patronID
FROM PatronYearDistinct
WHERE year = 2023 and distinctmonths < 12;

CREATE VIEW Nothing2024 AS
SELECT patron as patronID
FROM PatronYearDistinct
WHERE year = 2024 and distinctmonths = 0;

CREATE VIEW DiminishingPatrons AS (SELECT * FROM EveryMonth2022) INTERSECT (SELECT * FROM Atleast5Month2023) INTERSECT (SELECT * FROM Atleast1Inactive2023) INTERSECT (SELECT * FROM Nothing2024);

CREATE VIEW Final AS
SELECT p.card_number, coalesce(p.email, 'none') as email, 
(select count(distinct lh.holding) from Checkout c JOIN LibraryHolding lh on c.copy=lh.barcode where c.patron=patronID) as usage,
(select count(*) from PatronYearMonth pym where pym.patron=patronID and year=2022) - (select count(*) from PatronYearMonth pym where pym.patron=patronID and year=2023) as decline, 
12 - (select distinctmonths from PatronYearDistinct pyd where pyd.patron=patronID and pyd.year=2023) as missed
FROM DiminishingPatrons dp JOIN Patron p on dp.patronID=p.card_number;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q5 SELECT * FROM Final;
