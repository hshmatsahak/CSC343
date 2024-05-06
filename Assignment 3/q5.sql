-- For each conference: Conference details, number of paper presentations across all paper sessions for that conference, and number of paper sessions for that conference
CREATE VIEW PaperCounts AS
SELECT Conference.conference_id as conference_id, Conference.location as location, Conference.name as conference_name, Conference.start_date as start_date, Conference.end_date as end_date, count(*) as num_papers, count(DISTINCT PaperSession.session_id) as num_paper_sessions
FROM PaperSession JOIN PaperSessionPresentation ON PaperSession.session_id = PaperSessionPresentation.session_id 
RIGHT JOIN Conference ON Conference.conference_id = PaperSession.conference_id
GROUP BY Conference.conference_id;

-- For each conference: Number of poster presentations across all poster sessions for that conference, and number of poster sessions for that conference
CREATE VIEW PosterCounts AS
SELECT Conference.conference_id as conf, count(*) as num_posters, count(DISTINCT PosterSession.session_id) as num_poster_sessions
FROM PosterSession JOIN PosterSessionPresentation ON PosterSession.session_id = PosterSessionPresentation.session_id 
RIGHT JOIN Conference ON Conference.conference_id = PosterSession.conference_id
GROUP BY Conference.conference_id;

-- Conference details and average number of paper and poster presentations per paper and poster session, respectively
SELECT 
    PaperCounts.conference_id, PaperCounts.conference_name, PaperCounts.location, PaperCounts.start_date, PaperCounts.end_date, 
    CASE
        WHEN num_paper_sessions = 0 THEN 0
        ELSE num_papers / num_paper_sessions
    END AS avg_papers_perpapersession,
    CASE
        WHEN num_poster_sessions = 0 THEN 0
        ELSE num_posters / num_poster_sessions
    END AS avg_posters_perpostersession
FROM PaperCounts JOIN PosterCounts ON PaperCounts.conference_id = PosterCounts.conf
