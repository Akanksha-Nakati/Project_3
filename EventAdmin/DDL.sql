-- DDL SCRIPTS
-- Delete existing sequences, if any

DECLARE
   v_exists NUMBER;
BEGIN
   -- Loop through each sequence in the database
   FOR c IN (SELECT sequence_name FROM user_sequences)
   LOOP
      -- Check if the sequence exists
      SELECT COUNT(*)
      INTO v_exists
      FROM user_sequences
      WHERE sequence_name = c.sequence_name;
      -- If the sequence exists, drop it
      IF v_exists > 0 THEN
         EXECUTE IMMEDIATE 'DROP SEQUENCE ' || c.sequence_name;
         -- Output a message indicating that the sequence was dropped
         DBMS_OUTPUT.PUT_LINE('Sequence dropped: ' || c.sequence_name);
      END IF;
   END LOOP;
EXCEPTION
   -- Handle any exceptions that occur during sequence deletion
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


DECLARE
   v_exists NUMBER;
BEGIN
   FOR t IN (SELECT table_name FROM user_tables)
   LOOP
      SELECT COUNT(*)
      INTO v_exists
      FROM user_tables
      WHERE table_name = t.table_name;

      IF v_exists > 0 THEN
         EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
         DBMS_OUTPUT.PUT_LINE('Table dropped: ' || t.table_name);
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Create sequences for primary key generation
CREATE SEQUENCE ATTENDEE_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ORGANIZER_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE FEEDBACK_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE REGISTRATION_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SPONSOR_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE PAYMENT_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE VENUE_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE EVENT_SCHEDULE_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE EVENT_SEQ START WITH 1 INCREMENT BY 1;

-- Creating table for 'Attendee'
CREATE TABLE Attendee (
    attendee_id NUMBER(10) NOT NULL PRIMARY KEY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    email_id VARCHAR2(255) NOT NULL UNIQUE,
    attendee_password VARCHAR2(20) NOT NULL UNIQUE,
    phone_number VARCHAR2(20) NOT NULL UNIQUE
);

-- Creating table for 'Sponsor'
CREATE TABLE Sponsor (
    sponsor_id NUMBER(10) NOT NULL PRIMARY KEY,
    sponsor_name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL UNIQUE,
    phone_number VARCHAR2(20) NOT NULL UNIQUE,
    sponsor_password VARCHAR2(20) NOT NULL UNIQUE,
    amount_sponsored NUMBER(10) NOT NULL
);

-- Creating table for 'Venue'
CREATE TABLE Venue (
    venue_id NUMBER(10) NOT NULL PRIMARY KEY,
    venue_name VARCHAR2(255) NOT NULL,
    venue_address VARCHAR2(255) NOT NULL,
    venue_capacity VARCHAR2(255) NOT NULL,
    event_id NUMBER(10) NOT NULL
);

-- Creating table for 'Organization'
CREATE TABLE Organizer (
    organizer_id NUMBER(10) NOT NULL PRIMARY KEY,
    organizer_name VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL UNIQUE,
    phone_number VARCHAR2(20) NOT NULL UNIQUE,
    organizer_password VARCHAR2(20) NOT NULL UNIQUE
);

CREATE TABLE Event (
    event_id NUMBER(10) NOT NULL PRIMARY KEY,
    event_name VARCHAR2(255) NOT NULL,
    event_desc VARCHAR2(1024) NOT NULL,
    organizer_id NUMBER(10) NOT NULL,
    sponsor_id NUMBER(10) NOT NULL,
    ticket_price NUMBER(10)NOT NULL CHECK (ticket_price >= 0)
);

--New registration table
CREATE TABLE Registration (
    registration_id NUMBER(10) NOT NULL UNIQUE, -- Ensures uniqueness
    attendee_id NUMBER(10) NOT NULL,
    event_id NUMBER(10) NOT NULL,
    registration_date TIMESTAMP,
    ticketsBooked NUMBER NOT NULL,
    ticket_Price NUMBER(10) NOT NULL,
    PRIMARY KEY (attendee_id, event_id) -- Composite Primary Key
);

-- Creating table for 'Feedback'
CREATE TABLE Feedback (
    feedback_id NUMBER(10) NOT NULL PRIMARY KEY,
    event_id NUMBER(10) NOT NULL,
    attendee_id NUMBER(10) NOT NULL,
    rating VARCHAR2(255) NOT NULL,
    feedback_text VARCHAR2(255) NOT NULL,
    sponsor_id NUMBER(10),
    CONSTRAINT unique_feedback UNIQUE (attendee_id, event_id)  -- Ensure unique combination of attendee and event
);

-- Creating table for 'Payment'
CREATE TABLE Payment (
    payment_id NUMBER(10) NOT NULL PRIMARY KEY,
    registration_id NUMBER(10) NOT NULL UNIQUE, 
    amount NUMBER(10) NOT NULL,
    payment_method VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    payment_status VARCHAR2(255) NOT NULL
);

-- Creating table for 'Event_Schedule'
CREATE TABLE Event_Schedule (
    eventschedule_id NUMBER(10) NOT NULL PRIMARY KEY,
    event_id NUMBER(10) NOT NULL,
    venue_id NUMBER(10) NOT NULL,
    event_schedule_date DATE NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL
);

-- ADD FOREIGN KEY REFERENCES:

ALTER TABLE Event ADD CONSTRAINT FK_Organizer_Event FOREIGN KEY (organizer_id) REFERENCES Organizer (organizer_id);
ALTER TABLE Event ADD CONSTRAINT FK_Sponsor_Event FOREIGN KEY (sponsor_id) REFERENCES Sponsor(sponsor_id);
ALTER TABLE Registration ADD CONSTRAINT FK_Attendee_Registration FOREIGN KEY (attendee_id) REFERENCES Attendee(attendee_id);
ALTER TABLE Registration ADD CONSTRAINT FK_Event_Registration FOREIGN KEY (event_id) REFERENCES Event(event_id);
ALTER TABLE Feedback ADD CONSTRAINT FK_Event_Feedback FOREIGN KEY (event_id) REFERENCES Event(event_id);
ALTER TABLE Feedback ADD CONSTRAINT FK_Attendee_Feedback FOREIGN KEY (attendee_id) REFERENCES Attendee(attendee_id);
ALTER TABLE Payment ADD CONSTRAINT FK_Registration_Payment FOREIGN KEY (registration_id) REFERENCES Registration(registration_id);
ALTER TABLE Event_Schedule ADD CONSTRAINT FK_Event_Event_Schedule FOREIGN KEY (event_id) REFERENCES Event(event_id);
ALTER TABLE Event_Schedule ADD CONSTRAINT FK_Venue_Event_Schedule FOREIGN KEY (venue_id) REFERENCES Venue(venue_id);
ALTER TABLE Venue ADD CONSTRAINT FK_Venue_Event_id FOREIGN KEY (event_id) REFERENCES Event(event_id);


