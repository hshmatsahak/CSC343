DROP VIEW IF EXISTS BranchesToExtend CASCADE;

CREATE VIEW BranchesToExtend AS
SELECT lb.code AS branch_code
FROM LibraryBranch lb
WHERE lb.code NOT IN (SELECT lh.library FROM LibraryHours lh WHERE lh.day='sun')
  AND NOT EXISTS (SELECT * FROM LibraryHours lh WHERE lh.library=lb.code and lh.day in ('mon', 'tue', 'wed', 'thu', 'fri') and lh.end_time > '18:00:00');

UPDATE LibraryHours lh
SET end_time = '21:00:00'
WHERE lh.library in (SELECT branch_code FROM BranchesToExtend) and lh.day = 'thu';

INSERT INTO LibraryHours
SELECT branch_code, 'thu', '18:00:00', '21:00:00'
FROM BranchesToExtend bte
WHERE branch_code NOT IN (SELECT lh.library FROM LibraryHours lh WHERE lh.day='thu');
