-- For each conference, its id and number of papers accepted
CREATE VIEW PaperCount AS
SELECT conference_id, count(*) as papercount
FROM SubmissionDecision 
JOIN Submission ON SubmissionDecision.submission_id = Submission.submission_id 
JOIN SubmissionItem ON Submission.itemid = SubmissionItem.itemid
WHERE decision='accept' and subtype='paper'
GROUP BY conference_id;

-- Conference IDs with the highest number of papers accepted
CREATE VIEW BestConferences AS
SELECT conference_id
FROM PaperCount
WHERE papercount = (SELECT max(papercount) FROM PaperCount);

-- First author id, item id and conference id for all paper submissions in one of the best conferences found above
CREATE VIEW FirstAuthors AS
SELECT conference_id, Submission.itemid, author_id
FROM SubmissionDecision
JOIN Submission ON SubmissionDecision.submission_id = Submission.submission_id
JOIN SubmissionAuthor ON Submission.itemid = SubmissionAuthor.itemid
JOIN SubmissionItem ON Submission.itemid = SubmissionItem.itemid
WHERE decision='accept' and subtype='paper' and conference_id IN (SELECT conference_id FROM BestConferences) AND authorship=1;

-- First author and all other relevant information (item id, conference id of paper and name, email, organization and status of author)
SELECT conference_id, itemid, author_id, name, email, organization_id, status
FROM FirstAuthors JOIN Person ON author_id = person_id;