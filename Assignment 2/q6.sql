-- Devoted Fans
 
-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q6 cascade;

CREATE TABLE q6 (
    patronID Char(20) NOT NULL,
    devotedness INT NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS BookAuthor CASCADE;
DROP VIEW IF EXISTS DesiredBooks CASCADE;
DROP VIEW IF EXISTS BookAuthorSolo CASCADE;
DROP VIEW IF EXISTS BookRelevantAuthorSolo CASCADE;
DROP VIEW IF EXISTS PossiblePairs CASCADE;
DROP VIEW IF EXISTS FinalCombos CASCADE;
DROP VIEW IF EXISTS FinalWithoutNulls CASCADE;
DROP VIEW IF EXISTS Final CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW BookAuthor AS 
SELECT contributor as author, h.id as book
FROM HoldingContributor hc JOIN Holding h on hc.holding = h.id 
WHERE h.htype='books';

CREATE VIEW DesiredBooks AS
SELECT book
FROM BookAuthor
GROUP BY book
HAVING count(author)=1;

CREATE VIEW BookAuthorSolo AS 
SELECT * FROM BookAuthor
WHERE book in (SELECT book FROM DesiredBooks);

CREATE VIEW RelevantAuthors AS
SELECT author FROM BookAuthorSolo
GROUP BY author
HAVING count(book) >= 2;

CREATE VIEW BookRelevantAuthorSolo AS
SELECT * FROM BookAuthorSolo
WHERE author in (SELECT author FROM RelevantAuthors);

CREATE VIEW PossiblePairs AS
SELECT c.patron as patronID, ba.author
FROM Checkout c
JOIN LibraryHolding lh on c.copy = lh.barcode
JOIN BookRelevantAuthorSolo ba ON lh.holding = ba.book
LEFT JOIN Review r on r.patron=c.patron and r.holding=ba.book
GROUP BY c.patron, ba.author
HAVING count(distinct ba.book) >= (SELECT count(*) FROM BookRelevantAuthorSolo ba2 WHERE ba2.author = ba.author)-1 and count(ba.book)=count(r.review);

CREATE VIEW FinalCombos AS
SELECT patronID, author 
FROM PossiblePairs pp
WHERE (SELECT avg(stars) FROM Review r WHERE r.patron=patronID and r.holding 
IN (SELECT book FROM BookRelevantAuthorSolo bras where bras.author=author))>=4.0;

CREATE VIEW FinalWithoutNulls AS
SELECT patronID, count(*) as cnt 
FROM FinalCombos
GROUP BY patronID;

CREATE VIEW Final AS
SELECT card_number, coalesce(cnt, 0) as devotedness
FROM FinalWithoutNulls fwn RIGHT JOIN Patron p on fwn.patronID=p.card_number;

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO q6 SELECT * FROM Final;
