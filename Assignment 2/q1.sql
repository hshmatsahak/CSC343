-- Branch Activity

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q1 cascade;

CREATE TABLE q1 (
    branch CHAR(5) NOT NULL,
    year INT NOT NULL,
    events INT NOT NULL,
    sessions FLOAT NOT NULL,
    registration INT NOT NULL,
    holdings INT NOT NULL,
    checkouts INT NOT NULL,
    duration FLOAT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS AllBranchYearCombos CASCADE;
DROP VIEW IF EXISTS EventScheduleWithYears CASCADE;
DROP VIEW IF EXISTS BranchYearNumEvents CASCADE;
DROP VIEW IF EXISTS BranchYearEventNumsessions CASCADE;
DROP VIEW IF EXISTS BranchYearAvgsessions CASCADE;
DROP VIEW IF EXISTS PatronEvent CASCADE;
DROP VIEW IF EXISTS EventYearBranch CASCADE;
DROP VIEW IF EXISTS PatronEventBranchYear CASCADE;
DROP VIEW IF EXISTS BranchYearNumregistrations CASCADE;
DROP VIEW IF EXISTS BranchHoldings CASCADE;
DROP VIEW IF EXISTS BranchYearHoldings CASCADE;
DROP VIEW IF EXISTS CheckoutBranchYear CASCADE;
DROP VIEW IF EXISTS BranchYearNumcheckouts CASCADE;
DROP VIEW IF EXISTS BranchYearDuration CASCADE;
DROP VIEW IF EXISTS BranchYearAvgduration CASCADE;
DROP VIEW IF EXISTS Combined CASCADE;
DROP VIEW IF EXISTS Final CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW AllBranchYearCombos AS
SELECT code as branch, year
FROM (SELECT distinct code FROM LibraryBranch) AS branches CROSS JOIN (VALUES (2019), (2020), (2021), (2022), (2023)) AS Years(year);

--Events
CREATE VIEW EventScheduleWithYears AS
SELECT *, EXTRACT(YEAR from edate) as year FROM EventSchedule es;

CREATE VIEW BranchYearNumEvents AS
SELECT lb.code, es.year, count(distinct es.event) as events
FROM EventScheduleWithYears es
JOIN LibraryEvent le on es.event = le.id
JOIN LibraryRoom lr on le.room = lr.id
JOIN LibraryBranch lb on lr.library = lb.code
WHERE es.year>=2019 and es.year<=2023
GROUP BY lb.code, es.year;

-- Sessions
CREATE VIEW BranchYearEventNumsessions AS
SELECT lb.code, es.year, es.event, count(*) as numsessions
FROM EventScheduleWithYears es
JOIN LibraryEvent le on es.event = le.id
JOIN LibraryRoom lr on le.room = lr.id
JOIN LibraryBranch lb on lr.library = lb.code
WHERE year>=2019 and year<=2023
GROUP BY lb.code, es.year, es.event;

CREATE VIEW BranchYearAvgsessions AS
SELECT code, year, avg(numsessions) as sessions
FROM BranchYearEventNumsessions 
GROUP BY code, year;

-- Registration
CREATE VIEW PatronEvent AS
SELECT patron, event
FROM EventSignUp;

CREATE VIEW EventYearBranch AS
SELECT lb.code, es.year, es.event
FROM EventScheduleWithYears es
JOIN LibraryEvent le on es.event = le.id
JOIN LibraryRoom lr on le.room = lr.id
JOIN LibraryBranch lb on lr.library = lb.code
WHERE year>=2019 and year<=2023
GROUP BY lb.code, es.year, es.event;

CREATE VIEW PatronEventBranchYear AS
SELECT eyb.code, eyb.year, eyb.event, pe.patron
FROM EventYearBranch eyb
JOIN PatronEvent pe on eyb.event=pe.event;

CREATE VIEW BranchYearNumregistrations AS
SELECT code, year, count(*) as registration
FROM PatronEventBranchYear
GROUP BY code, year;

-- Holdings
CREATE VIEW BranchHoldings AS SELECT library as code, count(*) as holdings FROM LibraryHolding GROUP BY library;
CREATE VIEW BranchYearHoldings AS SELECT * FROM BranchHoldings CROSS JOIN (VALUES (2019), (2020), (2021), (2022), (2023)) AS Years(year);

-- Checkouts
CREATE VIEW CheckoutBranchYear AS
SELECT c.id, extract(YEAR from checkout_time) as year, lh.library as code
FROM Checkout c 
JOIN LibraryHolding lh on c.copy=lh.barcode
WHERE extract(YEAR from checkout_time)>=2019 
and extract(YEAR from checkout_time)<=2023;
 
CREATE VIEW BranchYearNumcheckouts AS
SELECT code, year, count(*) as checkouts
FROM CheckoutBranchYear
GROUP BY code, year;

-- Duration
CREATE VIEW BranchYearDuration AS
SELECT lh.library as code, extract(YEAR from checkout_time) as year, ROUND(EXTRACT(EPOCH FROM AGE(return_time, checkout_time)) / (60 * 60 * 24)) as durationday
FROM Return r
JOIN Checkout c on r.checkout=c.id
JOIN LibraryHolding lh on c.copy=lh.barcode
WHERE extract(YEAR from checkout_time)>=2019 and extract(YEAR from checkout_time)<=2023; 

CREATE VIEW BranchYearAvgduration AS
SELECT code, year, avg(durationday) as duration
FROM BranchYearDuration
GROUP BY code, year;

-- Combine
CREATE VIEW Combined AS
SELECT code as branch, year, events, sessions, registration, holdings, checkouts, duration
FROM BranchYearNumEvents
NATURAL FULL JOIN BranchYearAvgsessions
NATURAL FULL JOIN BranchYearNumregistrations
NATURAL FULL JOIN BranchYearHoldings
NATURAL FULL JOIN BranchYearNumcheckouts
NATURAL FULL JOIN BranchYearAvgduration;

-- Final: Fix Null
CREATE VIEW Final AS
SELECT branch, year, coalesce(events, 0) as events, coalesce(sessions, 0) as sessions, coalesce(registration, 0) as registration, 
coalesce(holdings, 0) as holdings, coalesce(checkouts, 0) as checkouts, coalesce(duration, 0.0) as duration
FROM Combined NATURAL RIGHT JOIN AllBranchYearCombos;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q1 SELECT * FROM Final;
