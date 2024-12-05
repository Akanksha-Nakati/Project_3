CREATE OR REPLACE FUNCTION get_available_seats(
    event_id_input NUMBER,
    event_schedule_date_input DATE -- Added event_schedule_date parameter
)
RETURN NUMBER
IS
    venue_capacity INT;
    registered_count INT;
    available_seats INT;
BEGIN
    -- Fetch the venue capacity for the event based on the event schedule and venue
    BEGIN
        SELECT v.venue_capacity 
        INTO venue_capacity
        FROM Venue v
        JOIN Event_Schedule es ON v.venue_id = es.venue_id
        WHERE es.event_id = event_id_input
        AND es.event_schedule_date = event_schedule_date_input;  -- Now using the provided event schedule date
        
        DBMS_OUTPUT.PUT_LINE('yes');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No venue data found for event_id: ' || event_id_input || ' and schedule date: ' || event_schedule_date_input);
            RETURN -1; -- Return -1 to indicate no data found for venue
    END;

    -- Fetch the current count of registered attendees for the event (considering the specific schedule)
    BEGIN
        SELECT COUNT(*)
        INTO registered_count
        FROM Registration r
        JOIN Event_Schedule es ON r.event_id = es.event_id
        WHERE es.event_id = event_id_input
        AND es.event_schedule_date = event_schedule_date_input;  -- Ensure this is based on the provided schedule date
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No registration data found for event_id: ' || event_id_input || ' and schedule date: ' || event_schedule_date_input);
            registered_count := 0; -- No attendees yet, so set to 0
    END;

    -- Calculate available seats
    available_seats := venue_capacity - registered_count;

    -- Ensure non-negative available seats
    IF available_seats < 0 THEN
        available_seats := 0;
    END IF;

    RETURN available_seats;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        RETURN -1;
END;
