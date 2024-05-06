-- Overdue Items

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q2 cascade;

create table q2 (
    branch CHAR(5) NOT NULL,
    patron CHAR(20),
    title TEXT NOT NULL,
    overdue INT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS Type1NotReturned CASCADE;
DROP VIEW IF EXISTS Type2NotReturned CASCADE;
DROP VIEW IF EXISTS Type1Overdue CASCADE;
DROP VIEW IF EXISTS Type2Overdue CASCADE;
DROP VIEW IF EXISTS Final CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW Type1NotReturned AS
SELECT lb.code as branch, c.patron, h.title, DATE(c.checkout_time) + 21 as duedate
FROM Checkout c
JOIN LibraryHolding lh on c.copy=lh.barcode
JOIN LibraryBranch lb on lh.library = lb.code
JOIN Holding h on lh.holding = h.id
JOIN Ward w on lb.ward = w.id
WHERE c.id NOT IN (SELECT checkout FROM Return) and (htype='books' or htype='audiobooks') and w.name='Parkdale-High Park';

CREATE VIEW Type2NotReturned AS
SELECT lb.code as branch, c.patron, h.title, DATE(c.checkout_time) + 7 as duedate
FROM Checkout c
JOIN LibraryHolding lh on c.copy=lh.barcode
JOIN LibraryBranch lb on lh.library = lb.code
JOIN Holding h on lh.holding = h.id
JOIN Ward w on lb.ward = w.id
WHERE c.id NOT IN (SELECT checkout FROM Return) and (htype='music' or htype='movies' or htype='magazines and newspapers') and w.name='Parkdale-High Park';

CREATE VIEW Type1Overdue AS
SELECT branch, patron, title, CURRENT_DATE - duedate as overdue
FROM Type1NotReturned
WHERE CURRENT_DATE > duedate;

CREATE VIEW Type2Overdue AS
SELECT branch, patron, title, CURRENT_DATE - duedate as overdue
FROM Type2NotReturned
WHERE CURRENT_DATE > duedate;

CREATE VIEW Final AS (SELECT * FROM Type1Overdue) UNION ALL (SELECT * FROM Type2Overdue); 

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q2 SELECT * FROM Final;
