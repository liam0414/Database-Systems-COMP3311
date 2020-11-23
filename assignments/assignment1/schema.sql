-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by Liam Chen
-- Student ID: z3278107

/*
Key Assumptions:
1. The spec requires all class hierarchies to be implemented by ER MAPPING, but it is impossible 
   to represent disjoint constraint for Events table and Recurring Event table. only single table can achieve this

2. The frontend designer will deal with:
	2.1 validation issues such as password and email validation
	2.2 specific date and time format displayed on the front end, database only stores raw data

3. Users: A user has to be either a user or a superuser(admin), default is set to 'false' as very few users are admin.

4. Groups: A group has to have a name, hence not null.

5. Events: 
	5.1 events don't have to have a location, some of the events function just like reminders(e.g. Christmas Shutdown)
	5.2 a private event is shown simply as "Busy" in the interface, this is achieved by front end

6. Alarms: alarm stored as interval data type, e.g. 15 mins before, 5 mins before, 1 minute before, a domain type of strings
	is another option, depending on how they 

7. Spanning_Events: A spanning event has to be more than one day, end date > start date

8. Recurring_Events:
	8.1 A recurring event may or may not have an end date, if it has, end date has to be greater than start date
		this is achieved by ((end_Date > start_Date AND end_Date <> NULL) OR NULL)
	8.2 a recurring event has to happen at least 1 time
	8.3 MonthlyByDayEvent and MonthlyByDateEvent both assume every month, e.g. first week Monday of the month
		Again, weekInMonth will be checked by frontend designer to ensure input is valid.

9. With all the enums in types, their fields are not null, e.g. status InviteStatus NOT NULL visibility has to be either public or private 
	hence they are all set to NOT NULL in the tables unless noted otherwise by the client
*/

-- Types
CREATE TYPE AccessibilityType AS enum ('read-write','read-only','none');
CREATE TYPE InviteStatus AS enum ('invited','accepted','declined');
CREATE TYPE VisibilityType AS enum ('public', 'private');

-- Domains
CREATE DOMAIN DayOfWeek AS char(3) CHECK (LOWER(VALUE) IN ('mon','tue','wed','thu','fri','sat','sun'));
-- Tables

CREATE TABLE Users (
	id          serial,
	email       text NOT NULL UNIQUE,
	name 		text NOT NULL,
	passwd		text NOT NULL,
	is_admin	boolean NOT NULL DEFAULT 'false',
	PRIMARY KEY (id)
);

CREATE TABLE Groups (
	id          serial,
	name        text NOT NULL,
	owner		integer NOT NULL, -- Total participation
	PRIMARY KEY (id),
	FOREIGN KEY (owner) REFERENCES Users(id)
);

CREATE TABLE Calendars (
	id 			serial,
	colour		text NOT NULL,
	name 		text NOT NULL,
	owner		integer NOT NULL REFERENCES Users(id),	--total participation
	default_access	AccessibilityType NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Events (
	id 			serial,
	title 		text NOT NULL,
	start_time  time,
	end_time	time,
	location 	text,
	visibility  VisibilityType NOT NULL,
	created_by  integer NOT NULL REFERENCES Users(id), -- not null = total participation (ownership)
	part_of 	integer NOT NULL REFERENCES Calendars(id), -- not null = total participation
	PRIMARY KEY (id)
);

CREATE TABLE Alarms (
	events_id 	integer NOT NULL REFERENCES Events(id),
	alarm 		interval MINUTE NOT NULL,
	PRIMARY KEY (events_id, alarm)
);

CREATE TABLE One_Day_Events (
	date 		date NOT NULL,
	events_id	integer,
	PRIMARY KEY (events_id),
	FOREIGN KEY (events_id) REFERENCES Events(id)
);

CREATE TABLE Spanning_Events (
	start_Date 	date NOT NULL,
	end_Date 	date NOT NULL CHECK (end_Date > start_Date),
	events_id	integer,
	PRIMARY KEY (events_id),
	FOREIGN KEY (events_id) REFERENCES Events(id)
);

CREATE TABLE Recurring_Events (
	start_Date 	date NOT NULL,
	end_Date 	date CHECK ((end_Date > start_Date AND end_Date <> NULL) OR NULL),
	ntimes 		integer CHECK (ntimes > 0),
	events_id	integer,
	PRIMARY KEY (events_id),
	FOREIGN KEY (events_id) REFERENCES Events(id)
);

CREATE TABLE Weekly_Events (
	recurring_events_id 	integer,
	dayOfWeek 	DayOfWeek NOT NULL,
	frequency 	integer NOT NULL CHECK (frequency > 0),
	PRIMARY KEY (recurring_events_id),
	FOREIGN KEY (recurring_events_id) REFERENCES Recurring_Events(events_id)
);

CREATE TABLE Monthly_By_Day_Events (
	recurring_events_id 	integer,
	dayOfWeek 	DayOfWeek NOT NULL,
	weekInMonth integer NOT NULL CHECK (weekInMonth >=1 AND weekInMonth <= 5),
	PRIMARY KEY (recurring_events_id),
	FOREIGN KEY (recurring_events_id) REFERENCES Recurring_Events(events_id)
);

CREATE TABLE Monthly_By_Date_Events (
	recurring_events_id 	integer,
	dateInMonth integer NOT NULL CHECK (dateInMonth >= 1 AND dateInMonth <= 31),
	PRIMARY KEY (recurring_events_id),
	FOREIGN KEY (recurring_events_id) REFERENCES Recurring_Events(events_id)
);

CREATE TABLE Annual_Events (
	recurring_events_id 	integer,
	date 	date NOT NULL,
	PRIMARY KEY (recurring_events_id),
	FOREIGN KEY (recurring_events_id) REFERENCES Recurring_Events(events_id)
);

-- relationships 
CREATE TABLE Members (
	user_id 	integer REFERENCES Users(id),
	group_id 	integer REFERENCES Groups(id),
	PRIMARY KEY (user_id, group_id)
);

CREATE TABLE Accessibility (
	user_id 	integer REFERENCES Users(id),
	calendar_id integer REFERENCES Calendars(id),
	access 		AccessibilityType NOT NULL,
	PRIMARY KEY (user_id, calendar_id)
);

CREATE TABLE Subscribed (
	user_id 	integer REFERENCES Users(id),
	calendar_id integer REFERENCES Calendars(id),
	colour		text,	--subscriber colour
	PRIMARY KEY (user_id, calendar_id)
);

CREATE TABLE Invited (
	event_id 	integer REFERENCES Events(id),
	user_id 	integer REFERENCES Users(id),
	status 		InviteStatus NOT NULL,
	PRIMARY KEY (event_id, user_id)
);
