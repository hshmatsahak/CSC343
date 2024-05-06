-- Our A3Conference schema is outlined below.
-- We value storing the minimum amount of data with our design. 
-- To that extent, we prioritize avoiding redundancy and enforcing non-null columns 
-- over trying to enforce constraints without assertions or triggers
-- As a result, many of our constraints use an assertion or trigger
-- The advantages of our design are in its simplicity (intuitive) and space. There is
-- no column whose values could have been derived from the other columns (no redundancy).

-- Could Not

-- Could not enforce: "Reviewers cannot review their own submissions, the submissions of anyone else with whom they are co-authors, 
-- or the submissions of anyone else from their organization. Reviewers can also declare additional conflicts beyond those rules".
-- The way we designed our schema, these are cross-table constraints that require assertions. 
-- We have a table for submissions, a table for reviews and a table for submission authors.

-- Could not enforce: Submissions that have previously been accepted cannot be submitted again later.
-- We will use a trigger for this. On inserting a row into submissions, we will check that it
-- has not already been submitted. We can't enforce without as this is a relationship between two 
-- different tables, (Submission and Submission_Decision).

-- Could not enforce: Session chair is not an author on any papers at that session, 
-- and do not have something else schedule at the same time.
-- These require cross table constraints, can't use foreign keys, unique, null, etc.
-- We assert that session chair cannot appear as submission author on any submissions in that session.

-- Could not enforce: Multiple presentations can be scheduled at the same time but no author can have two 
-- presentations at the same time, with one exception. An author can have one paper and poster at the same time, 
-- as long as they are not the sole author on either of them.
-- This requires cross table constraint between Poster Session Presentations, Paper Session Presentations and Submission_Author
-- We thus leave it to assertion to check for overlapping time slots.

-- Could not enforce: students pay a lower fee than other attendees. This is not a per-row or per-column constraint. 
-- We need to compare between rows. So, we will assert student fee < regular fee for all conferences.

-- Could not enforce: conference chairs must have been on the organizing committee for that conference at least twice 
-- before becoming conference chair, unless the conference is too new.
-- This requires cross table assertion between Organizer and ConferenceChair. Since at least twice, can't use FK.

-- Did Not

-- Did not enforce: "anonymous submissions are not permitted". Technically, we can have an attribute 'first_author' 
-- and force it to be not null, but this is something we can figure out from the SubmissionAuthor table, so it introduces 
-- redundancy. Instead, we assert that each submission_id appears at least once in the SubmissionAuthors table.

-- Did not enforce: "at least one author on each paper must be a reviewer." We can do this by splitting Submission 
-- into PaperSubmissions and PosterSubmissions, then having an attribute for reviewer_author_id, and force it to be not null. 
-- However, we can determine if an author is a reviewer through the Submission_Review table, so we can avoid redundancy 
-- of adding a new attribute by instead having an assertion. The assertion would check that for each submission id with 
-- type=paper, at least one of the reviewers in Submission appears in the Submission_Review table.

-- Did not enforce: At least one author on every accepted submission must be registered for the conference. 
-- We could have a non null attribute on some SubmissionAccepted table storing name of someone who is registered
-- but this is redundant as we can figure it out by just using Registration, SubmissionDecision, and Submission_Author

-- Did not enforce: Workshops must have at least one facilitator.
-- We could add a lead_facilitator attribute on the Workshop table, and have a foreign key (workshop_id, lead_facilitator) 
-- that references the WorkshopFacilitator table. lead_facilitator would be non null. But again, this would be redundant.
-- We instead assert that after inserting to workshop facilitator, we satisfy the constraint given.

-- Assumptions / Extra constraints

-- Organization cannot be null. Those who aren't part of any organization could be part of an 'Unafiliated' group, 
-- Each organization has different name. A person can only be part of one org.
-- A submission gets submitted to a particular conference. It only receives one decision, ie you can't reject then accept
-- the same submission later. The paper/poster must be submitted under a new submission id for another decision.
-- No conference can have two workshops with the same name. Again, very reasonable.
-- Can't have two conferences with the same name, in the same location, on the same day. Very reasonable.
-- Can't pay a negative fee.
-- Each paper/poster can only be presented once in a particular session

-- Standard schema setup
DROP SCHEMA IF EXISTS A3Conference CASCADE;
CREATE SCHEMA A3Conference;
SET SEARCH_PATH TO A3Conference;

-- Custom variables
create domain SubmissionType as text
    not null
    check (value in ('paper', 'poster'));

create domain SessionType as text
    not null
    check (value in ('paper', 'poster'));

-- Define tables

-- Each row contains id and name of an organization
CREATE TABLE Organization (
    organization_id int primary key,
    name text not null unique
);

-- Each row contains identifying information for one person
CREATE TABLE Person (
    person_id int primary key,
    name text not null,
    email text not null unique,
    organization_id int not null,
    status varchar(7) not null CHECK (status IN ('student', 'regular')),
    FOREIGN KEY (organization_id) REFERENCES Organization(organization_id)
);

-- Table to store information about conferences (name, location, date)
CREATE TABLE Conference (
    conference_id int primary key,
    name text not null,
    location text not null,
    start_date date not null,
    end_date date not null,
    UNIQUE(name, location, start_date)
);

-- Table to store information about conference price (student vs regular)
CREATE Table ConferencePrice (
    conference_id int not null,
    status varchar(7) not null CHECK (status IN ('student', 'regular')),
    fee float not null CHECK (fee >= 0),
    PRIMARY KEY (conference_id, status),
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id)
);

-- Table storing information about conference organizers
CREATE TABLE Organizer (
    conference_id int not null,
    organizer int not null,
    PRIMARY KEY (conference_id, organizer),
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id),
    FOREIGN KEY (organizer) REFERENCES Person(person_id)
);

-- Table storing information about conference chairs
CREATE TABLE ConferenceChair (
    conference_id int not null,
    chair int not null,
    chair_idx int not null CHECK (chair_idx>=1 and chair_idx<=2),
    PRIMARY KEY (conference_id, chair),
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id),
    FOREIGN KEY (chair) REFERENCES Person(person_id)
);

-- Table to store information about conference attendees
CREATE TABLE Registration (
    person_id int not null,
    conference_id int not null,
    PRIMARY KEY (person_id, conference_id),
    FOREIGN KEY (person_id) REFERENCES Person(person_id),
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id)
);

-- Table to store information about conference paper sessions
CREATE Table PaperSession (
    session_id int primary key,
    conference_id int not null,
    session_num int not null CHECK (session_num > 0),
    session_chair int not null,
    start_time time not null,
    end_time time not null,
    UNIQUE (conference_id, session_num),
    FOREIGN KEY (conference_id, session_chair) REFERENCES Registration(conference_id, person_id)
);

-- Table to store information about conference poster sessions
CREATE Table PosterSession (
    session_id int primary key,
    conference_id int not null,
    session_num int not null CHECK (session_num > 0),
    start_time time not null,
    end_time time not null,
    UNIQUE (conference_id, session_num),
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id)
);

-- Table to store information about submission items (could be paper or poster)
CREATE TABLE SubmissionItem (
    itemid int primary key,
    title text not null,
    subtype SubmissionType
);

-- Table to store information about submissions (submission item is submitted to a conference)
CREATE TABLE Submission (
    submission_id int primary key,
    itemid int not null,
    subdate date not null,
    conference_id int not null,
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id),
    FOREIGN KEY (itemid) REFERENCES SubmissionItem(itemid)
);

-- Table to store information about submissions' authors
CREATE TABLE SubmissionAuthor (
    itemid int not null,
    author_id int not null,
    authorship int not null CHECK (authorship > 0), -- first author, etc
    PRIMARY KEY (itemid, author_id),
    FOREIGN KEY (itemid) REFERENCES SubmissionItem(itemid),
    FOREIGN KEY (author_id) REFERENCES Person(person_id)
);

-- Table to store information about submission reviews
CREATE TABLE SubmissionReview (
    submission_id int not null,
    reviewer_id int not null,
    decision varchar(6) not null CHECK (decision IN ('accept', 'reject')),
    PRIMARY KEY (submission_id, reviewer_id),
    FOREIGN KEY (submission_id) REFERENCES Submission(submission_id),
    FOREIGN KEY (reviewer_id) REFERENCES Person(person_id)
);

-- Table to store information about submission decisions
CREATE TABLE SubmissionDecision (
    submission_id int primary key,
    decision_date date not null,
    decision varchar(6) not null CHECK (decision IN ('accept', 'reject')),
    FOREIGN KEY (submission_id) REFERENCES Submission(submission_id)
);

-- Table to store information about which paper was submitted at which session at what time
CREATE TABLE PaperSessionPresentation (
    session_id int not null,
    submission_id int not null,
    start_time timestamp not null,
    end_time timestamp not null,
    PRIMARY KEY (session_id, submission_id),
    FOREIGN KEY (session_id) REFERENCES PaperSession(session_id),
    FOREIGN KEY (submission_id) REFERENCES Submission(submission_id)
);

-- Table to store information about which poster was submitted at which session
CREATE TABLE PosterSessionPresentation (
    session_id int not null,
    submission_id int not null,
    PRIMARY KEY (session_id, submission_id),
    FOREIGN KEY (session_id) REFERENCES PosterSession(session_id),
    FOREIGN KEY (submission_id) REFERENCES Submission(submission_id)
);

-- Table to store information about workshops (name and which conference)
CREATE TABLE Workshop (
    workshop_id int primary key,
    name text not null,
    conference_id int not null,
    UNIQUE (name, conference_id),
    FOREIGN KEY (conference_id) REFERENCES Conference(conference_id)
);

-- Price of each workshop for student vs regular
CREATE Table WorkshopPrice (
    workshop_id int not null,
    status varchar(7) not null CHECK (status IN ('student', 'regular')),
    fee float not null CHECK (fee >= 0),
    PRIMARY KEY (workshop_id, status)
);

-- Table to store workshop registrations
CREATE TABLE WorkshopRegistration (
    person_id int not null,
    workshop_id int not null,
    PRIMARY KEY (person_id, workshop_id),
    FOREIGN KEY (person_id) REFERENCES Person(person_id),
    FOREIGN KEY (workshop_id) REFERENCES Workshop(workshop_id)
);

-- Table to store information about workshop facilitators
CREATE TABLE WorkshopFacilitator (
    workshop_id int not null,
    facilitator_id int not null,
    PRIMARY KEY (workshop_id, facilitator_id),
    FOREIGN KEY (workshop_id) REFERENCES Workshop(workshop_id),
    FOREIGN KEY (facilitator_id) REFERENCES Person(person_id)
);
