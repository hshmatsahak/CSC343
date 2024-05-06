DROP VIEW IF EXISTS RefTable CASCADE;
DROP VIEW IF EXISTS EligibleOverdueBooks CASCADE;

CREATE VIEW RefTable AS
SELECT c.id, c.patron, c.checkout_time
FROM Checkout c
JOIN LibraryHolding lh ON c.copy = lh.barcode
JOIN LibraryBranch lb ON lh.library = lb.code
JOIN Holding h on lh.holding = h.id
WHERE c.id NOT IN (SELECT checkout FROM Return)
  AND htype='books'
  AND lb.name = 'Downsview';

CREATE VIEW EligibleOverdueBooks AS (
    SELECT t1.id AS checkout_id
    FROM RefTable t1
    WHERE DATE(t1.checkout_time) + 21 < CURRENT_DATE
      AND t1.patron IN (
          SELECT patron
          FROM RefTable t2
          GROUP BY patron
          HAVING COUNT(*) <= 5
      )
      AND NOT EXISTS (
          SELECT t3.id
          FROM RefTable t3
          WHERE DATE(t3.checkout_time) + 28 < CURRENT_DATE
            AND t3.patron = t1.patron
      )
);

UPDATE Checkout AS c
SET checkout_time = c.checkout_time + INTERVAL '14 days'
WHERE c.id in (SELECT checkout_id FROM EligibleOverdueBooks);
