-- Warmup Query 3

SET SEARCH_PATH TO LibraryWarmup;

-- You must not change the next 2 lines, the type definition, or the table definition.
DROP TYPE IF EXISTS size_type CASCADE;
DROP TABLE IF EXISTS wu3 CASCADE;

CREATE TYPE LibraryWarmup.size_type AS ENUM (
	'large', 'medium', 'small'
);

CREATE TABLE wu3 (
    ward INT,
    size size_type NOT NULL,
    num_branches int NOT NULL
);

-- Do this for each of the views that define your intermediate steps.
-- (But give them better names!) The IF EXISTS avoids generating an error
-- the first time this file is imported.
-- If you do not define any views, you can delete the lines about views.
DROP VIEW IF EXISTS hasParking CASCADE;
DROP VIEW IF EXISTS noParking CASCADE;
DROP VIEW IF EXISTS Large CASCADE;
DROP VIEW IF EXISTS Medium CASCADE;
DROP VIEW IF EXISTS Small CASCADE;

-- Define views for your intermediate steps here:
CREATE VIEW hasParking AS SELECT * FROM LibraryBranch WHERE has_parking = true;
CREATE VIEW noParking AS SELECT * FROM LibraryBranch WHERE has_parking = false;
CREATE VIEW Large AS SELECT code, ward FROM hasParking WHERE EXISTS (SELECT * FROM LibraryRoom WHERE library=code and rtype='auditorium');
CREATE VIEW Medium AS (SELECT code, ward FROM hasParking WHERE NOT EXISTS (SELECT * FROM LibraryRoom WHERE library=code and rtype='auditorium')) UNION (SELECT code, ward FROM noParking WHERE EXISTS (SELECT * FROM LibraryRoom WHERE library=code and rtype='auditorium'));
CREATE VIEW Small AS SELECT code, ward FROM noParking WHERE NOT EXISTS (SELECT * FROM LibraryRoom WHERE library=code and rtype='auditorium');

-- Your query that answers the question goes below the "insert into" line:
INSERT INTO wu3 (SELECT ward, CAST('large' as size_type), count(code) FROM Large GROUP BY ward) UNION (SELECT ward, CAST('medium' as size_type), count(code) FROM Medium GROUP BY ward) UNION (SELECT ward, CAST('small' as size_type), count(code) FROM Small GROUP BY ward)
