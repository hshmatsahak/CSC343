-- For each person in the database, report their id, name and number of conferences they have attended.
SELECT 
    Person.person_id,
    Person.name,
    COUNT(DISTINCT conference_id) AS num_conferences_attended
FROM Registration RIGHT JOIN Person ON Registration.person_id = Person.person_id
GROUP BY Person.person_id, Person.name;