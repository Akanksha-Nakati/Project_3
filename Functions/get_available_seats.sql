CREATE OR REPLACE FUNCTION get_available_seats(event_id_input NUMBER)
RETURN NUMBER
IS
    venue_capacity INT;
    registered_count INT;
    available_seats INT;
BEGIN
    -- Fetch the venue capacity for the event
    SELECT v.venue_capacity 
    INTO venue_capacity
    FROM Venue v
    JOIN Event_Schedule es ON v.venue_id = es.venue_id
    WHERE es.event_id = event_id_input;

    -- Fetch the current count of registered attendees
    SELECT COUNT(*)
    INTO registered_count
    FROM Registration
    WHERE event_id = event_id_input;

    -- Calculate available seats
    available_seats := venue_capacity - registered_count;

    -- Ensure non-negative available seats
    IF available_seats < 0 THEN
        available_seats := 0;
    END IF;

    RETURN available_seats;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for event_id: ' || event_id_input);
        RETURN -1; -- Return -1 to indicate no data
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        RETURN -1;
END;
/
