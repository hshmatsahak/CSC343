INSERT INTO Organization(organization_id, name)
VALUES
    (1, 'Org1'),
    (2, 'Org2'),
    (3, 'Org3'),
    (4, 'Org4'),
    (5, 'Org5'),
    (6, 'Org6'),
    (7, 'Org7'),
    (8, 'Org8'),
    (9, 'Org9'),
    (10, 'Org10');


INSERT INTO Person(person_id, name, email, organization_id, status)
VALUES
    (1, 'Michelle Craig', 'michelle@example.com', 1, 'regular'),
    (2, 'Jennifer Campbell', 'jennifer@example.com', 2, 'regular'),
    (3, 'Sadia Sharmin', 'sadia@example.com', 3, 'student'),
    (4, 'Jonathan Calver', 'jc@example.com', 4, 'student'),
    (5, 'Larry Yueli Zhang', 'lyz@example.com', 5, 'student'),
    (6, 'Diane Horton', 'dh@example.com', 6, 'student'),
    (7, 'Daniel Zingaro', 'dz@example.com', 7, 'student'),
    (8, 'Danny Heap', 'dheap@example.com', 8, 'student'),
    (9, 'Keener', 'keener@example.com', 9, 'student'),
    (10, 'q1guy', 'q1guy@ex.com', 10, 'student');


INSERT INTO Conference(conference_id, name, location, start_date, end_date)
VALUES
    (1, 'SIGCSE TS', 'Milwaukee, Wisconsin', '2010-01-01', '2010-01-03'),
    (2, 'SIGCSE TS', 'Dallas, Texas', '2011-01-01', '2011-01-03'),
    (3, 'SIGCSE TS', 'Raleigh, NC', '2012-01-01', '2012-01-03'),
    (4, 'SIGCSE TS', 'Denver, ColoradoC', '2013-01-01', '2013-01-03'),
    (5, 'SIGCSE TS', 'Atlanta, Georgia', '2014-01-01', '2014-01-03'),
    (6, 'SIGCSE TS', 'Kansas City, Missouri', '2015-01-01', '2015-01-03'),
    (7, 'SIGCSE TS', 'Memphis, Tennessee', '2016-01-01', '2016-01-03'),
    (8, 'SIGCSE TS', 'Seattle, Washington', '2017-01-01', '2017-01-03'),
    (9, 'SIGCSE TS', 'Baltimore, Maryland', '2018-01-01', '2018-01-03'),
    (10, 'SIGCSE TS', 'Minneapolis, Minnesota', '2019-01-01', '2019-01-03'),
    (11, 'SIGCSE TS', 'Portland, Oregon', '2020-01-01', '2020-01-03'),
    (12, 'SIGCSE TS', 'Seattle, Washington', '2021-01-01', '2021-01-03'),
    (13, 'SIGCSE TS', 'Toronto, Canada', '2022-01-01', '2022-01-03'),
    (14, 'SIGCSE TS', 'Providence, Rhode Island', '2023-01-01', '2023-01-03'),
    (15, 'SIGCSE TS', 'Toronto, Canada', '2024-01-01', '2024-01-03'),
    (16, 'SIGCSE TS', 'Gaza, Palestine', '2025-01-01', '2025-01-03'),
    (17, 'CompEd', 'Aleppo, Syria', '2019-02-01', '2019-02-03'),
    (18, 'CompEd', 'Baghdad, Iraq', '2021-02-01', '2021-02-03'),
    (19, 'CompEd', 'Kabul, Afghanistan', '2023-02-01', '2023-02-03'),
    (20, 'CompEd', 'Toronto, Canada', '2025-02-01', '2025-02-03'),
    (21, 'ICML', 'Celaya, Mexico', '2024-03-01', '2024-03-03'),
    (22, 'ICLR', 'Tijuana, Mexico', '2024-04-01', '2024-04-03'),
    (23, 'NeurIPs', 'Uruapan, Mexico', '2024-05-01', '2024-05-03');


INSERT INTO ConferencePrice(conference_id, status, fee)
VALUES
    (1, 'student', 100),
    (1, 'regular', 200),
    (2, 'student', 100),
    (2, 'regular', 200),
    (3, 'student', 100),
    (3, 'regular', 200),
    (4, 'student', 100),
    (4, 'regular', 200),
    (5, 'student', 100),
    (5, 'regular', 200),
    (6, 'student', 100),
    (6, 'regular', 200),
    (7, 'student', 100),
    (7, 'regular', 200),
    (8, 'student', 100),
    (8, 'regular', 200),
    (9, 'student', 100),
    (9, 'regular', 200),
    (10, 'student', 100),
    (10, 'regular', 200),
    (11, 'student', 100),
    (11, 'regular', 200),
    (12, 'student', 100),
    (12, 'regular', 200),
    (13, 'student', 100),
    (13, 'regular', 200),
    (14, 'student', 100),
    (14, 'regular', 200),
    (15, 'student', 100),
    (15, 'regular', 200),
    (16, 'student', 100),
    (16, 'regular', 200),
    (17, 'student', 100),
    (17, 'regular', 200),
    (18, 'student', 100),
    (18, 'regular', 200),
    (19, 'student', 100),
    (19, 'regular', 200),
    (20, 'student', 100),
    (20, 'regular', 200),
    (21, 'student', 100),
    (21, 'regular', 200),
    (22, 'student', 100),
    (22, 'regular', 200),
    (23, 'student', 100),
    (23, 'regular', 200);


INSERT INTO Organizer(conference_id, organizer)
VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1),
    (10, 1),
    (11, 1),
    (12, 1),
    (13, 1),
    (14, 1),
    (15, 1),
    (16, 1),
    (17, 1),
    (18, 1),
    (19, 1),
    (20, 1),
    (21, 1),
    (22, 1),
    (23, 1);


INSERT INTO ConferenceChair(conference_id, chair, chair_idx)
VALUES
    (1, 1, 1),
    (2, 1, 1),
    (3, 1, 1),
    (4, 1, 1),
    (5, 1, 1),
    (6, 1, 1),
    (7, 1, 1),
    (8, 1, 1),
    (9, 1, 1),
    (10, 1, 1),
    (11, 1, 1),
    (12, 1, 1),
    (13, 1, 1),
    (14, 1, 1),
    (15, 1, 1),
    (16, 1, 1),
    (17, 1, 1),
    (18, 1, 1),
    (19, 1, 1),
    (20, 1, 1),
    (21, 1, 1),
    (22, 1, 1),
    (23, 1, 1);


INSERT INTO Registration(person_id, conference_id)
VALUES
    -- Craig attend all conf of sig and comped
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),
    (1, 11),
    (1, 12),
    (1, 13),
    (1, 14),
    (1, 15),
    (1, 16),
    (1, 17),
    (1, 18),
    (1, 19),
    (1, 20),

    -- Campbell attend most, but not all, of SIGCSE TS since 2015
    -- we put all but 2019
    (2, 6),
    (2, 7),
    (2, 8),
    (2, 9),
    (2, 11),
    (2, 12),
    (2, 13),
    (2, 14),
    (2, 15),

    -- Session Chairs attend conference
    (4, 1),
    (4, 2),
    (4, 3),
    (4, 4),
    (4, 5),
    (4, 6),
    (4, 7),
    (4, 8),
    (4, 9),
    (4, 10),
    (4, 11),
    (4, 12),
    (4, 13),
    (9, 14),

    -- Sadia Shahid
    (3, 9),
    (3, 10),
    (3, 13),
    (3, 17),

    -- q1 guy just make him reg for all
    (10, 1),
    (10, 2),
    (10, 3),
    (10, 4),
    (10, 5),
    (10, 6),
    (10, 7),
    (10, 8),
    (10, 9),
    (10, 10),
    (10, 11),
    (10, 12),
    (10, 13),
    (10, 14),
    (10, 15),
    (10, 16),
    (10, 17),
    (10, 18),
    (10, 19),
    (10, 20);

INSERT INTO PaperSession (session_id, conference_id, session_num, session_chair, start_time, end_time)
VALUES
    (1, 1, 1, 4, 'Jan-01-2010 9:00', 'Jan-01-2010 12:00'),
    (2, 2, 1, 4, 'Jan-01-2011 9:00', 'Jan-01-2011 12:00'),
    (3, 3, 1, 4, 'Jan-01-2012 9:00', 'Jan-01-2012 12:00'),
    (4, 4, 1, 4, 'Jan-01-2013 9:00', 'Jan-01-2013 12:00'),
    (5, 5, 1, 4, 'Jan-01-2014 9:00', 'Jan-01-2014 12:00'),
    (6, 6, 1, 4, 'Jan-01-2015 9:00', 'Jan-01-2015 12:00'),
    (7, 7, 1, 4, 'Jan-01-2016 9:00', 'Jan-01-2016 12:00'),
    (8, 8, 1, 4, 'Jan-01-2017 9:00', 'Jan-01-2017 12:00'),
    (9, 9, 1, 4, 'Jan-01-2018 9:00', 'Jan-01-2018 12:00'),
    (10, 10, 1, 4, 'Jan-01-2019 9:00', 'Jan-01-2019 12:00'),
    (11, 11, 1, 4, 'Jan-01-2020 9:00', 'Jan-01-2020 12:00'),
    (12, 12, 1, 4, 'Jan-01-2021 9:00', 'Jan-01-2021 12:00'),
    (13, 13, 1, 4, 'Jan-01-2022 9:00', 'Jan-01-2022 12:00'),
    (14, 14, 1, 9, 'Jan-01-2023 9:00', 'Jan-01-2023 12:00'); -- Jonathan Calver has a paper
    

INSERT INTO PosterSession(session_id, conference_id, session_num, start_time, end_time)
VALUES
    (1, 9, 1, 'Jan-01-2018 7:00', 'Jan-01-2018 8:00'),
    (2, 10, 1, 'Jan-01-2019 7:00', 'Jan-01-2019 8:00'),
    (3, 17, 1, 'Feb-01-2019 7:00', 'Feb-01-2019 8:00');


INSERT INTO SubmissionItem(itemid, title, subtype)
VALUES
    (1, 'Introducing and Evaluating Exam Wrappers in CS2', 'paper'),
    
    (2, 'Craig_1', 'paper'),
    (3, 'Craig_2', 'paper'),
    (4, 'Craig_3', 'paper'),
    (5, 'Craig_4', 'paper'),
    (6, 'Craig_5', 'paper'),
    (7, 'Craig_6', 'paper'),
    (8, 'Craig_7', 'paper'),
    (9, 'Craig_8', 'paper'),
    (10, 'Craig_9', 'paper'),
    (11, 'Craig_10', 'paper'),

    (12, 'Campbell_1', 'paper'),

    (13, 'Campbell_2', 'paper'),
    (14, 'Campbell_3', 'paper'),
    (15, 'Campbell_4', 'paper'),
    (16, 'Campbell_5', 'paper'),

    (17, 'Experience Report on the Use of Breakout Rooms in a Large Online Course', 'paper'),

    (18, 'Sharmin_1', 'poster'),
    (19, 'Sharmin_2', 'poster'),
    (20, 'Sharmin_3', 'poster'),

    (21, 'Student Perspectives on Optional Groups', 'paper'),

    (22, 'dummy_comped2019', 'paper'),
    (23, 'dummy_comped2021', 'paper'),
    (24, 'dummy_comped2023', 'paper'),
    (25, 'dummy_comped2025', 'paper'),
    (26, 'dummy_sigcse2010', 'paper'),
    (27, 'dummy_sigcse2011', 'paper'),
    (28, 'dummy_sigcse2012', 'paper'),
    (29, 'dummy_sigcse2013', 'paper'),
    (30, 'dummy_sigcse2014', 'paper'),
    (31, 'dummy_sigcse2015', 'paper'),
    (32, 'dummy_sigcse2016', 'paper'),
    (33, 'dummy_sigcse2017', 'paper'),
    (34, 'dummy_sigcse2018', 'paper'),
    (35, 'dummy_sigcse2019', 'paper'),
    (36, 'dummy_sigcse2020', 'paper'),
    (37, 'dummy_sigcse2021', 'paper'),
    (38, 'dummy_sigcse2022', 'paper'),
    (39, 'dummy_sigcse2023', 'paper'),
    (40, 'dummy_sigcse2024', 'paper'),
    (41, 'dummy_sigcse2025', 'paper');

INSERT INTO Submission(submission_id, itemid, subdate, conference_id)
VALUES
    -- Michelle Craig 1, Diane Horton 6, Daniel Zingaro 7 and Danny Heap 8 
    (1, 1, '2015-11-01', 7),
    (2, 1, '2015-11-04', 7),
    (3, 1, '2015-11-08', 7),
    (4, 1, '2015-11-12', 7),
    (5, 1, '2015-11-16', 7),
    (6, 1, '2015-11-20', 7),
    (7, 1, '2015-11-24', 7),
    (8, 1, '2015-11-25', 7), 
    (9, 1, '2015-11-26', 7), -- accept
    
    -- Michelle Craig 1
    (10, 2, '2009-11-20', 1), --accept 10-19
    (11, 3, '2010-11-20', 2),
    (12, 4, '2011-11-20', 3),
    (13, 5, '2012-11-20', 4),
    (14, 6, '2013-11-20', 5),
    (15, 7, '2014-11-20', 6),
    (16, 8, '2015-11-20', 7),
    (17, 9, '2016-11-20', 8),
    (18, 10, '2017-11-20', 9),
    (19, 11, '2018-11-20', 10),

    -- Campbell and Larry Yueli Zhang
    (20, 12, '2018-11-20', 10), -- accept, campbell don't go

    -- Campbell only
    (21, 13, '2019-11-20', 11), 
    (22, 14, '2020-11-20', 12), 
    (23, 15, '2021-11-20', 13), 
    (24, 16, '2021-11-20', 13), -- accept, same conf as above

    -- Sadia Sharmin, Larry Yueli Zhang
    (25, 17, '2021-11-20', 13),

    -- Sadia Sharmin
    (26, 18, '2017-11-20', 9),
    (27, 19, '2018-11-20', 10),
    (28, 20, '2018-11-20', 17),

    -- Jonathan Calver, Jennifer Campbell and Michelle Craig
    (29, 21, '2022-11-20', 14),
    
    -- just to get right vals for q1
    (30, 22, '2012-10-20', 17),
    (31, 22, '2012-10-21', 17),
    (32, 23, '2012-10-20', 18),
    (33, 23, '2012-10-21', 18),
    (34, 23, '2012-10-20', 18),
    (35, 24, '2012-10-20', 19),
    (36, 24, '2012-10-21', 19),
    (37, 24, '2012-10-20', 19),
    (41, 25, '2012-10-20', 21),
    (42, 25, '2012-10-20', 22),
    (43, 25, '2012-10-20', 23),
    (44, 26, '2012-10-20', 1),
    (45, 26, '2012-10-20', 1),
    (46, 27, '2012-10-20', 2),
    (47, 27, '2012-10-20', 2),
    (48, 28, '2012-10-20', 3),
    (49, 28, '2012-10-20', 3),
    (50, 29, '2012-10-20', 4),
    (51, 29, '2012-10-20', 4),
    (52, 30, '2012-10-20', 5),
    (53, 30, '2012-10-20', 5),
    (54, 31, '2012-10-20', 6),
    (55, 31, '2012-10-20', 6),
    (56, 31, '2012-10-20', 7),
    (57, 32, '2012-10-20', 7),
    (58, 33, '2012-10-20', 8),
    (59, 33, '2012-10-20', 8),
    (60, 34, '2012-10-20', 9),
    (61, 34, '2012-10-20', 9),
    (62, 34, '2012-10-20', 9),
    (63, 34, '2012-10-20', 9),
    (64, 35, '2012-10-20', 10),
    (65, 35, '2012-10-20', 10),
    (66, 35, '2012-10-20', 10),
    (67, 35, '2012-10-20', 10),
    (68, 35, '2012-10-20', 10),
    (69, 35, '2012-10-20', 10),
    (70, 36, '2012-10-20', 11),
    (71, 36, '2012-10-20', 11),
    (72, 37, '2012-10-20', 12),
    (73, 37, '2012-10-20', 12),
    (74, 38, '2012-10-20', 13),
    (75, 38, '2012-10-20', 13),
    (76, 38, '2012-10-20', 13),
    (77, 38, '2012-10-20', 13),
    (78, 38, '2012-10-20', 13),
    (79, 38, '2012-10-20', 13),
    (80, 39, '2012-10-20', 14),
    (81, 39, '2012-10-20', 14),
    (82, 40, '2012-10-20', 15),
    (83, 40, '2012-10-20', 15),
    (84, 40, '2012-10-20', 15),
    (85, 41, '2012-10-20', 16);

-- still have to add dummy sub authors here
INSERT INTO SubmissionAuthor (itemid, author_id, authorship)
VALUES
    -- Michelle Craig, Diane Horton, Daniel Zingaro and Danny Heap 
    (1, 1, 1),
    (1, 6, 2),
    (1, 7, 3),
    (1, 8, 4),

    -- Craig
    (2, 1, 1),
    (3, 1, 1),
    (4, 1, 1),
    (5, 1, 1),
    (6, 1, 1),
    (7, 1, 1),
    (8, 1, 1),
    (9, 1, 1),
    (10, 1, 1),
    (11, 1, 1),

    -- Campbell + Larry
    (12, 2, 1),
    (12, 5, 2),

    -- Campbell
    (13, 2, 1),
    (14, 2, 1),
    (15, 2, 1),
    (16, 2, 1),

    -- Sadia Sharmin, Larry Yueli Zhang
    (17, 3, 1),
    (17, 5, 2),

    -- Sadia
    (18, 3, 1),
    (19, 3, 1),
    (20, 3, 1),

    -- Jonathan Calver, Jennifer Campbell and Michelle Craig
    (21, 4, 1),
    (21, 2, 2),
    (21, 1, 3),

    -- to get right vals
    (22, 10, 1),
    (23, 10, 1),
    (24, 10, 1),
    (25, 10, 1),
    (26, 10, 1),
    (27, 10, 1),
    (28, 10, 1),
    (29, 10, 1),
    (30, 10, 1),
    (31, 10, 1),
    (32, 10, 1),
    (33, 10, 1),
    (34, 10, 1),
    (35, 10, 1),
    (36, 10, 1),
    (37, 10, 1),
    (38, 10, 1),
    (39, 10, 1),
    (40, 10, 1),
    (41, 10, 1);

INSERT INTO SubmissionReview(submission_id, reviewer_id, decision)
VALUES
    -- papers from Michelle Craig, Diane Horton, Daniel Zingaro and Danny Heap
    (1, 3, 'reject'),
    (1, 5, 'reject'),
    (1, 9, 'reject'),
    (2, 3, 'reject'),
    (2, 5, 'reject'),
    (2, 9, 'reject'),
    (3, 3, 'reject'),
    (3, 5, 'reject'),
    (3, 9, 'reject'),
    (4, 3, 'reject'),
    (4, 5, 'reject'),
    (4, 9, 'reject'),
    (5, 3, 'reject'),
    (5, 5, 'reject'),
    (5, 9, 'reject'),
    (6, 3, 'reject'),
    (6, 5, 'reject'),
    (6, 9, 'reject'),
    (7, 3, 'reject'),
    (7, 5, 'reject'),
    (7, 9, 'reject'),
    (8, 3, 'reject'),
    (8, 5, 'reject'),
    (8, 9, 'reject'),
    (9, 3, 'accept'),
    (9, 5, 'accept'),
    (9, 9, 'accept'),

    -- accept Craig's papers
    (10, 3, 'accept'),
    (10, 5, 'accept'),
    (10, 9, 'accept'),
    (11, 3, 'accept'),
    (11, 5, 'accept'),
    (11, 9, 'accept'),
    (12, 3, 'accept'),
    (12, 5, 'accept'),
    (12, 9, 'accept'),
    (13, 3, 'accept'),
    (13, 5, 'accept'),
    (13, 9, 'accept'),
    (14, 3, 'accept'),
    (14, 5, 'accept'),
    (14, 9, 'accept'),
    (15, 3, 'accept'),
    (15, 5, 'accept'),
    (15, 9, 'accept'),
    (16, 3, 'accept'),
    (16, 5, 'accept'),
    (16, 9, 'accept'),
    (17, 3, 'accept'),
    (17, 5, 'accept'),
    (17, 9, 'accept'),
    (18, 3, 'accept'),
    (18, 5, 'accept'),
    (18, 9, 'accept'),
    (19, 3, 'accept'),
    (19, 5, 'accept'),
    (19, 9, 'accept'),

    -- accept Campbell + Larry papers
    (20, 6, 'accept'),
    (20, 7, 'accept'),
    (20, 8, 'accept'),

    -- accept Campbell's papers
    (21, 6, 'accept'),
    (21, 7, 'accept'),
    (21, 8, 'accept'),
    (22, 6, 'accept'),
    (22, 7, 'accept'),
    (22, 8, 'accept'),
    (23, 6, 'accept'),
    (23, 7, 'accept'),
    (23, 8, 'accept'),
    (24, 6, 'accept'),
    (24, 7, 'accept'),
    (24, 8, 'accept'),

    -- accept paper from Sadia Sharmin and Larry Yueli Zhang
    (25, 1, 'accept'),
    (25, 2, 'accept'),
    (25, 4, 'accept'),

    -- accept posters from Sadia Sharmin
    (26, 1, 'accept'),
    (26, 2, 'accept'),
    (26, 4, 'accept'),
    (27, 1, 'accept'),
    (27, 2, 'accept'),
    (27, 4, 'accept'),
    (28, 1, 'accept'),
    (28, 2, 'accept'),
    (28, 4, 'accept'),

    -- accept paper from Jonathan Calver, Jennifer Campbell and Michelle Craig
    (29, 3, 'accept'),
    (29, 5, 'accept'),
    (29, 9, 'accept'),

    -- just to get correct ans
    (56, 1, 'accept'),
    (56, 2, 'accept'),
    (56, 3, 'accept'),
    (57, 1, 'accept'),
    (57, 2, 'accept'),
    (57, 3, 'accept'),
    (82, 1, 'accept'),
    (82, 2, 'accept'),
    (82, 3, 'accept');


INSERT INTO SubmissionDecision(submission_id, decision_date, decision)
VALUES
    -- rejected papers
    (1, '2015-12-01', 'reject'),
    (2, '2015-12-04', 'reject'),
    (3, '2015-12-08', 'reject'),
    (4, '2015-12-12', 'reject'),
    (5, '2015-12-16', 'reject'),
    (6, '2015-12-20', 'reject'),
    (7, '2015-12-24', 'reject'),
    (8, '2015-12-25', 'reject'),
    -- accepted papers
    (9, '2015-12-30', 'accept'),
    (10, '2009-12-30', 'accept'),
    (11, '2010-12-30', 'accept'),
    (12, '2011-12-30', 'accept'),
    (13, '2012-12-30', 'accept'),
    (14, '2013-12-30', 'accept'),
    (15, '2014-12-30', 'accept'),
    (16, '2015-12-30', 'accept'),
    (17, '2016-12-30', 'accept'),
    (18, '2017-12-30', 'accept'),
    (19, '2018-12-30', 'accept'),
    (20, '2018-12-30', 'accept'),
    (21, '2019-12-30', 'accept'),
    (22, '2020-12-30', 'accept'),
    (23, '2021-12-30', 'accept'),
    (24, '2021-12-30', 'accept'),
    (25, '2021-12-30', 'accept'),
    (29, '2022-12-30', 'accept'),
    -- accepted posters
    (26, '2017-12-30', 'accept'),
    (27, '2018-12-30', 'accept'),
    (28, '2018-12-30', 'accept'),

    -- --dummy
    (30, '2018-12-30', 'reject'),
    (31, '2018-12-30', 'reject'),
    (32, '2018-12-30', 'reject'),
    (33, '2018-12-30', 'reject'),
    (34, '2018-12-30', 'accept'),
    (35, '2018-12-30', 'reject'),
    (36, '2018-12-30', 'reject'),
    (37, '2018-12-30', 'accept'),

    -- -- just to get right
    (56, '2018-12-30', 'accept'),
    (57, '2018-12-30', 'accept'),
    (82, '2018-12-30', 'accept');

INSERT INTO PaperSessionPresentation(session_id, submission_id, start_time, end_time)
VALUES
    (7, 9, 'Jan-01-2016 9:00', 'Jan-01-2016 9:59'),
    (1, 10, 'Jan-01-2010 9:00', 'Jan-01-2010 9:59'),
    (2, 11, 'Jan-01-2011 9:00', 'Jan-01-2011 9:59'),
    (3, 12, 'Jan-01-2012 9:00', 'Jan-01-2012 9:59'),
    (4, 13, 'Jan-01-2013 9:00', 'Jan-01-2013 9:59'),
    (5, 14, 'Jan-01-2014 9:00', 'Jan-01-2014 9:59'),
    (6, 15, 'Jan-01-2015 9:00', 'Jan-01-2015 9:59'),
    (7, 16, 'Jan-01-2016 9:00', 'Jan-01-2016 9:59'),
    (8, 17, 'Jan-01-2017 9:00', 'Jan-01-2017 9:59'),
    (9, 18, 'Jan-01-2018 9:00', 'Jan-01-2018 9:59'),
    (10, 19, 'Jan-01-2019 9:00', 'Jan-01-2019 9:59'),
    (10, 20, 'Jan-01-2019 9:00', 'Jan-01-2019 9:59'),
    (11, 21, 'Jan-01-2020 9:00', 'Jan-01-2020 9:59'),
    (12, 22, 'Jan-01-2021 9:00', 'Jan-01-2021 9:59'),
    (13, 23, 'Jan-01-2022 9:00', 'Jan-01-2022 9:59'),
    (13, 24, 'Jan-01-2022 9:00', 'Jan-01-2022 9:59'), -- make diff time as above
    (13, 25, 'Jan-01-2022 9:00', 'Jan-01-2022 9:59'),
    (14, 29, 'Jan-01-2023 9:00', 'Jan-01-2023 9:59');


INSERT INTO PosterSessionPresentation(session_id, submission_id)
VALUES
    (1, 26),
    (2, 27),
    (3, 28);


INSERT INTO Workshop(workshop_id, name, conference_id)
VALUES
    (1, 'sigcse2023_workshop', 14), -- sig
    (2, 'comp2019_workshop', 17); -- comped


INSERT INTO WorkshopPrice(workshop_id, status, fee)
VALUES
    (1, 'student', 100),
    (1, 'regular', 200),
    (2, 'student', 100),
    (2, 'regular', 200);


INSERT INTO WorkshopRegistration(person_id, workshop_id)
VALUES
    (2, 1),
    (2, 2);


INSERT INTO WorkshopFacilitator(workshop_id, facilitator_id)
VALUES
    (1, 1),
    (2, 1);