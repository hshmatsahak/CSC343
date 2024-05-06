DROP VIEW IF EXISTS AllDetails CASCADE;

CREATE VIEW AllDetails AS
SELECT es.event, es.edate, es.start_time as evt_start, es.end_time as evt_end, lh.start_time as lib_start, lh.end_time as lib_end
FROM EventSchedule es
JOIN LibraryEvent le ON es.event = le.id
JOIN LibraryRoom lr ON le.room = lr.id
JOIN LibraryBranch lb ON lr.library = lb.code
LEFT JOIN LibraryHours lh ON lb.code = lh.library AND week_day(to_char(es.edate, 'dy')) = lh.day;

DELETE FROM EventSchedule es
WHERE EXISTS (
    SELECT *
    FROM AllDetails ad 
    WHERE ad.event=es.event and ad.edate=es.edate and (ad.lib_start IS NULL or ad.evt_start < ad.lib_start or ad.evt_end > ad.lib_end)
);

-- Delete events with no remaining sessions
DELETE FROM LibraryEvent
WHERE id NOT IN (
    SELECT event
    FROM EventSchedule
);

-- Delete registrations for events with no remaining sessions
DELETE FROM EventSignUp
WHERE event NOT IN (
    SELECT id
    FROM LibraryEvent
);
