-- Warmup Query 2

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO LibraryWarmup;
DROP TABLE IF EXISTS wu2 cascade;

CREATE TABLE wu2 (
    card_number CHAR(20),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    average FLOAT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS FiveStarPatrons CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW FiveStarPatrons AS SELECT patron FROM Review WHERE stars = 5;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO wu2 SELECT patron, first_name, last_name, avg(stars) FROM Review JOIN Patron ON Review.patron=Patron.card_number GROUP BY patron, first_name, last_name HAVING count(review)>1 and patron IN (SELECT patron FROM FiveStarPatrons); 
