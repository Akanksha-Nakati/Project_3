create or replace TRIGGER check_attendee_limit
BEFORE INSERT ON Registration
FOR EACH ROW
DECLARE
    registered_count INT;
    tickets_available INT;
BEGIN
    -- Get the current number of registered attendees for the event
    SELECT COUNT(*) INTO registered_count FROM Registration WHERE event_id = :NEW.event_id;
    -- Get the number of tickets available for the event
    SELECT ticketsbooked INTO tickets_available FROM Registration 
    WHERE event_id = :NEW.event_id AND ROWNUM = 1; -- Assuming each event entry holds the total tickets available

    -- Check if the available tickets are exceeded
    IF registered_count >= tickets_available THEN
        RAISE_APPLICATION_ERROR(-20001, 'No more tickets available for this event.');
    END IF;
END;
