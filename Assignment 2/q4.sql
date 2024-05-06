-- Explorers Contest

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q4 cascade;

CREATE TABLE q4 (
    patronID CHAR(20) NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS EventScheduleWithYears CASCADE;
DROP VIEW IF EXISTS PatronYearWard CASCADE;
DROP VIEW IF EXISTS Final CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW EventScheduleWithYears AS
SELECT *, EXTRACT(YEAR from edate) as year FROM EventSchedule es;

CREATE VIEW PatronYearWard AS
SELECT esu.patron, es.year, lb.ward
FROM EventSignUp esu
JOIN EventScheduleWithYears es on esu.event = es.event
JOIN LibraryEvent le on es.event = le.id
JOIN LibraryRoom lr on le.room = lr.id
JOIN LibraryBranch lb on lr.library = lb.code;

CREATE VIEW Final AS
SELECT distinct patron
FROM PatronYearWard
GROUP BY patron, year
HAVING count(distinct ward) = (SELECT count(*) FROM Ward);

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q4 SELECT * FROM Final;
