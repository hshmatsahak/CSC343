-- Warmup Query 1

-- You must not change the next 2 lines or the table definition.
-- Find the card numbers and number of items checked out for all patrons who currently have at least 3 checkouts not yet returned.
SET SEARCH_PATH TO LibraryWarmup;
DROP TABLE IF EXISTS wu1 CASCADE;

CREATE TABLE wu1 (
    patron CHAR(20) NOT NULL,
    checkouts int NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS NotReturned CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW NotReturned AS SELECT * FROM Checkout WHERE id not IN (SELECT checkout as id FROM Return);

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO wu1 SELECT patron, count(*) as checkouts FROM NotReturned GROUP BY patron HAVING count(*)>=3;
