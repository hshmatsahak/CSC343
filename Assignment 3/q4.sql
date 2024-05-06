-- Submission ids of all accepted submissions
CREATE VIEW AcceptedSubmissions AS
SELECT submission_id FROM SubmissionDecision
WHERE decision='accept';

-- Item ids of all submissions that are eventually accepted
CREATE VIEW AcceptedSubmissionItems AS
SELECT itemid FROM Submission
WHERE submission_id IN (SELECT submission_id FROM AcceptedSubmissions);

-- Number of times item is submitted before being accepted
CREATE VIEW TimesSubmitted AS
SELECT itemid, count(*) as times
FROM Submission
WHERE itemid in (SELECT itemid FROM AcceptedSubmissionItems)
GROUP BY itemid;

-- Item ids of items that are submitted the maximum number of times before being accepted
SELECT * FROM SubmissionItem WHERE itemid IN 
(SELECT itemid
FROM TimesSubmitted
WHERE times = (SELECT max(times) FROM TimesSubmitted));
