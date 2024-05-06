-- Promotion
 
-- You must not change the next 2 lines, the domain definition, or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q3 cascade;
 
DROP DOMAIN IF EXISTS patronCategory;
create domain patronCategory as varchar(10)
  check (value in ('inactive', 'reader', 'doer', 'keener'));
 
create table q3 (
    patronID Char(20) NOT NULL,
    category patronCategory
);
 
 
-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS LibrariesUsedCheckout CASCADE;
DROP VIEW IF EXISTS LibrariesUsedEvents CASCADE;
DROP VIEW IF EXISTS LibrariesUsed CASCADE;
DROP VIEW IF EXISTS CheckoutZero CASCADE;
DROP VIEW IF EXISTS CheckoutNonzero CASCADE;
DROP VIEW IF EXISTS CheckoutLow CASCADE;
DROP VIEW IF EXISTS CheckoutHigh CASCADE;
DROP VIEW IF EXISTS AttendedZero CASCADE;
DROP VIEW IF EXISTS AttendedNonzero CASCADE;
DROP VIEW IF EXISTS AttendedLow CASCADE;
DROP VIEW IF EXISTS AttendedHigh CASCADE;
DROP VIEW IF EXISTS Final CASCADE;
DROP VIEW IF EXISTS CheckoutWithbranch CASCADE;
 
-- Define views for your intermediate steps here:
CREATE VIEW LibrariesUsedCheckout AS
SELECT c.patron as patronID, lb.code as code
FROM Checkout c
JOIN LibraryHolding lh on c.copy=lh.barcode
JOIN LibraryBranch lb on lh.library = lb.code;

CREATE VIEW LibrariesUsedEvents AS
SELECT es.patron as patronID, lb.code as code
FROM EventSignUp es
JOIN LibraryEvent le on es.event = le.id
JOIN LibraryRoom lr on le.room = lr.id
JOIN LibraryBranch lb on lr.library = lb.code;
 
CREATE VIEW LibrariesUsed AS
(SELECT * FROM LibrariesUsedCheckout)
UNION
(SELECT * FROM LibrariesUsedEvents);
 
-- checkout
CREATE VIEW CheckoutZero AS
SELECT distinct patronID 
FROM LibrariesUsed
WHERE patronID NOT IN (SELECT patron FROM Checkout);
 
CREATE VIEW CheckoutNonzero AS
SELECT distinct patronID
FROM LibrariesUsed
WHERE patronID NOT IN (SELECT patronID FROM CheckoutZero);

CREATE VIEW CheckoutWithbranch AS 
SELECT c.patron, lb.code FROM Checkout c 
JOIN LibraryHolding lh on c.copy=lh.barcode 
JOIN LibraryBranch lb on lh.library = lb.code;

CREATE Table CheckoutLow AS
(SELECT patronID FROM CheckoutZero)
UNION 
(SELECT patronID FROM CheckoutNonzero
WHERE (SELECT count(*)*1.0 FROM Checkout c1 where c1.patron=patronID) < (SELECT count(*)*0.25/count(distinct patron) FROM Checkout c2 where c2.patron IN 
(SELECT patron FROM Checkout c3 JOIN LibraryHolding lh on c3.copy=lh.barcode JOIN LibraryBranch lb on lh.library = lb.code where lb.code IN (SELECT code FROM LibrariesUsed lu2 where lu2.patronID=patronID))));
 
CREATE VIEW CheckoutHigh AS
SELECT patronID FROM CheckoutNonzero
WHERE (SELECT count(*)*1.0 FROM Checkout c1 where c1.patron=patronID) - (SELECT count(*)*0.75/count(distinct patron) FROM Checkout c2 where c2.patron IN (SELECT patron FROM CheckoutWithbranch where code IN (SELECT code FROM LibrariesUsed lu2 where lu2.patronID=patronID))) > 0.0;

-- attended
CREATE VIEW AttendedZero AS
SELECT distinct patronID
FROM LibrariesUsed
WHERE patronID NOT IN (SELECT patron FROM EventSignUp);

CREATE VIEW AttendedNonzero AS
SELECT distinct patronID
FROM LibrariesUsed
WHERE patronID IN (SELECT patron FROM EventSignUp);

CREATE VIEW AttendedLow AS
(SELECT distinct patronID FROM AttendedZero) 
UNION 
(SELECT distinct patronID FROM AttendedNonzero
WHERE (SELECT count(*)*1.0 FROM EventSignUp es1 where es1.patron=patronID) < 
(SELECT count(*)*0.25/count(distinct patron) FROM EventSignUp es2 where es2.patron 
IN (SELECT patron FROM EventSignUp es3 JOIN LibraryEvent le on es3.event = le.id 
JOIN LibraryRoom lr on le.room = lr.id JOIN LibraryBranch lb on lr.library = lb.code where lb.code 
IN (SELECT code FROM LibrariesUsed lu2 where lu2.patronID=patronID))));

CREATE VIEW AttendedHigh AS
SELECT patronID FROM AttendedNonzero
WHERE (SELECT count(*)*1.0 FROM EventSignUp es1 where es1.patron=patronID) > (SELECT count(*)*0.75/count(distinct patron) FROM EventSignUp es2 where es2.patron IN 
(SELECT patron FROM EventSignUp es3 JOIN LibraryEvent le on es3.event = le.id 
JOIN LibraryRoom lr on le.room = lr.id JOIN LibraryBranch lb on lr.library = lb.code where lb.code 
IN (SELECT code FROM LibrariesUsed lu2 where lu2.patronID=patronID)));
 
CREATE VIEW Final AS
((SELECT patronID, 'inactive' as category FROM AttendedLow) INTERSECT (SELECT patronID, 'inactive' as category FROM CheckoutLow))
UNION
((SELECT patronID, 'reader' as category FROM AttendedLow) INTERSECT (SELECT patronID, 'reader' FROM CheckoutHigh))
UNION
((SELECT patronID, 'doer' as category FROM AttendedHigh) INTERSECT (SELECT patronID, 'doer' FROM CheckoutLow))
UNION
((SELECT patronID, 'keener' as category FROM AttendedHigh) INTERSECT (SELECT patronID, 'keener' FROM CheckoutHigh));
 
-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q3 SELECT * FROM Final;
