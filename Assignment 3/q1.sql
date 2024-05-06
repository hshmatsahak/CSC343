-- For each conference that has at least one submission, report its name, year, total # submissions, # submissions accepted and acceptance percentage, calculated as (accepted / total) * 100%
SELECT 
    Conference.name AS conference_name,
    EXTRACT(YEAR FROM Conference.start_date) AS conference_year,
    COUNT(Submission.submission_id) AS total_submissions,
    COUNT(CASE WHEN SubmissionDecision.decision = 'accept' THEN 1 END) AS accepted_submissions,
    (COUNT(CASE WHEN SubmissionDecision.decision = 'accept' THEN 1 END)*1.0 / COUNT(Submission.submission_id)) * 100 AS acceptance_percentage
FROM 
    Conference
LEFT JOIN 
    Submission ON Conference.conference_id = Submission.conference_id
LEFT JOIN 
    SubmissionDecision ON Submission.submission_id = SubmissionDecision.submission_id
GROUP BY 
    Conference.name, EXTRACT(YEAR FROM Conference.start_date)
HAVING
    COUNT(Submission.submission_id) > 0 -- avoid div by 0 error
ORDER BY 
    conference_name, conference_year;