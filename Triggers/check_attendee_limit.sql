CREATE OR REPLACE TRIGGER check_attendee_limit
BEFORE INSERT ON Registration
FOR EACH ROW
DECLARE
    total_tickets_booked INT;
    total_tickets_available INT;
BEGIN
    -- Get the total number of tickets already booked for the event
    SELECT NVL(SUM(ticketsBooked), 0) INTO total_tickets_booked
    FROM Registration
    WHERE event_id = :NEW.event_id;
 
    -- Fetch the total tickets available for the event from the Venue table linked to the event
    SELECT TO_NUMBER(venue_capacity) INTO total_tickets_available
    FROM Venue
    WHERE event_id = :NEW.event_id;
 
    -- Check if adding new tickets exceeds the total available tickets
    IF (total_tickets_booked + :NEW.ticketsBooked) > total_tickets_available THEN
        RAISE_APPLICATION_ERROR(-20001, 'No more tickets available for this event.');
    END IF;
END;
/