--- This view (OrganizerEventInformation_View) displays all events organized by each organizer, along with detailed information about each event, including its schedule, venue, and ticket price. It categorizes each event as "Past," "Ongoing," or "Upcoming" based on the event's scheduled date. all the previous, current and upcoming events with their details

CREATE OR REPLACE VIEW OrganizerEventInformation_View AS
SELECT org.organization_id,
       org.organizer_name,
       org.phone_number AS organizer_phone,
       e.event_id,
       e.event_name,
       e.event_desc AS event_description,
       r.ticket_price AS ticket_price,
       es.event_schedule_date AS event_date,
       es.start_time AS event_start_time,
       es.end_time AS event_end_time,
       v.venue_name,
       v.venue_address,
       v.venue_capacity,
       CASE 
           WHEN es.event_schedule_date < SYSDATE THEN 'Past'
           WHEN TRUNC(es.event_schedule_date) = TRUNC(SYSDATE) THEN 'Ongoing'
           ELSE 'Upcoming'
       END AS event_status
FROM Organization org
JOIN Event e ON org.organization_id = e.organizer_id
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Venue v ON es.venue_id = v.venue_id
JOIN Registration r ON e.event_id = r.event_id;

----- This view includes details of the events each attendee has registered for, showing both events they have attended and upcoming events.

CREATE OR REPLACE VIEW AttendeeEventInformation_View AS
SELECT r.registration_id,
       a.attendee_id,
       a.first_name,
       a.last_name,
       a.email_id AS attendee_email,
       a.phone_number AS attendee_phone,
       e.event_id,
       e.event_name,
       e.event_desc AS event_description,
       r.ticket_price,
       es.event_schedule_date AS event_date,
       es.start_time AS event_start_time,
       es.end_time AS event_end_time,
       v.venue_name,
       v.venue_address,
       CASE 
           WHEN es.event_schedule_date < SYSDATE THEN 'Attended'
           ELSE 'Upcoming'
       END AS attendance_status
FROM Attendee a
JOIN Registration r ON a.attendee_id = r.attendee_id
JOIN Event e ON r.event_id = e.event_id
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Venue v ON es.venue_id = v.venue_id;

----- This view (ScheduledEvents_View) provides an overview of all scheduled and upcoming events available for attendees and sponsors.

CREATE OR REPLACE VIEW ScheduledEvents_View AS
SELECT e.event_id,
       e.event_name,
       e.event_desc AS event_description,
       r.ticket_price,
       es.event_schedule_date AS event_date,
       es.start_time AS event_start_time,
       es.end_time AS event_end_time,
       v.venue_name,
       v.venue_address,
       CASE 
           WHEN TRUNC(es.event_schedule_date) = TRUNC(SYSDATE) THEN 'Scheduled'
           ELSE 'Upcoming'
       END AS event_status
FROM Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Venue v ON es.venue_id = v.venue_id
JOIN Registration r ON e.event_id = r.event_id
WHERE es.event_schedule_date >= TRUNC(SYSDATE);


--- This view provides organizers with details of their events, registered attendees, and any feedback received. 

CREATE OR REPLACE VIEW Organizer_Event_Insights_View AS
SELECT o.organizer_name,
       o.email AS organizer_email,
       e.event_id,
       e.event_name,
       e.event_desc AS event_description,
       a.attendee_id,
       a.first_name || ' ' || a.last_name AS attendee_name,
       f.feedback_id,
       f.feedback_text,
       f.rating
FROM Organization o
JOIN Event e ON o.organization_id = e.organizer_id
JOIN Registration r ON e.event_id = r.event_id
JOIN Attendee a ON r.attendee_id = a.attendee_id
LEFT JOIN Feedback f ON e.event_id = f.event_id AND a.attendee_id = f.attendee_id;


--This view provides organizers with details of attendees who are registered for events, including attendee and event information and their payments. 


CREATE OR REPLACE VIEW Attendee_Payment_Details_View AS
SELECT o.organizer_name,
       o.email AS organizer_email,
       e.event_id,
       e.event_name,
       a.attendee_id,
       a.first_name || ' ' || a.last_name AS attendee_name,
       r.registration_id,
       r.registration_date,
       p.payment_id,
       p.amount AS payment_amount,
       p.payment_method,
       p.payment_date,
       p.payment_status
FROM Organization o
JOIN Event e ON o.organization_id = e.organizer_id
JOIN Registration r ON e.event_id = r.event_id
JOIN Attendee a ON r.attendee_id = a.attendee_id
LEFT JOIN Payment p ON r.registration_id = p.registration_id;


--- This view (SponsorEventAnalysis_View) provides sponsors with detailed information about the events they have sponsored. It also allows sponsors to analyze attendee engagement and feedback for each event they sponsor.


CREATE OR REPLACE VIEW SponsorEventAnalysis_View AS
SELECT s.sponsor_id,
       s.sponsor_name,
       s.email AS sponsor_email,
       e.event_id,
       e.event_name,
       e.event_desc AS event_description,
       es.event_schedule_date AS event_date,
       COUNT(r.registration_id) AS attendee_count,
       AVG(f.rating) AS average_feedback_rating,
       RTRIM(XMLAGG(XMLELEMENT(e, f.feedback_text || '; ').EXTRACT('//text()') ORDER BY f.feedback_id).GetClobVal(), '; ') AS attendee_feedback
FROM Sponsor s
JOIN Event e ON s.sponsor_id = e.sponsor_id
JOIN Event_Schedule es ON e.event_id = es.event_id
LEFT JOIN Registration r ON e.event_id = r.event_id
LEFT JOIN Feedback f ON e.event_id = f.event_id
GROUP BY s.sponsor_id,
         s.sponsor_name,
         s.email,
         e.event_id,
         e.event_name,
         e.event_desc,
         es.event_schedule_date;



SELECT * FROM OrganizerEventInformation_View;
SELECT * FROM Organizer_Event_Insights_View;
SELECT * FROM Attendee_Payment_Details_View;
SELECT * FROM ScheduledEvents_View;
SELECT * FROM AttendeeEventInformation_View;
SELECT * FROM SponsorEventAnalysis_View;