create or replace PROCEDURE ADD_REGISTRATION (
    PI_ATTENDEE_ID IN Registration.attendee_id%TYPE,
    PI_EVENT_ID IN Registration.event_id%TYPE,
    PI_REGISTRATION_DATE IN Registration.registration_date%TYPE,
    PI_TICKETS_AVAILABLE IN Registration.ticketsAvailable%TYPE,
    PI_TICKET_PRICE IN Registration.ticket_Price%TYPE
) AS 
    E_DUPLICATE_REGISTRATION EXCEPTION;
    E_EVENT_NOT_FOUND EXCEPTION;
    E_INVALID_TICKET_COUNT EXCEPTION;

BEGIN
    -- Check if the attendee ID already has a registration for this event
    FOR C IN (SELECT 1 FROM Registration WHERE attendee_id = PI_ATTENDEE_ID AND event_id = PI_EVENT_ID) LOOP
        RAISE E_DUPLICATE_REGISTRATION;
    END LOOP;

    -- Check if the event ID exists
    DECLARE
        v_event_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_event_count FROM Event WHERE event_id = PI_EVENT_ID;
        IF v_event_count = 0 THEN
            RAISE E_EVENT_NOT_FOUND;
        END IF;
    END;

    -- Validate the number of tickets
    IF PI_TICKETS_AVAILABLE <= 0 THEN
        RAISE E_INVALID_TICKET_COUNT;
    END IF;

    -- Insert new registration record
    INSERT INTO Registration (
        registration_id, 
        attendee_id, 
        event_id, 
        registration_date, 
        ticketsAvailable, 
        ticket_Price
    ) VALUES (
        Registration_SEQ.NEXTVAL, -- Assumes a sequence named Registration_SEQ for generating IDs
        PI_ATTENDEE_ID,
        PI_EVENT_ID,
        PI_REGISTRATION_DATE,
        PI_TICKETS_AVAILABLE,
        PI_TICKET_PRICE
    );

    -- Commit the transaction to ensure changes are saved
    COMMIT;

    -- Success message
    DBMS_OUTPUT.PUT_LINE('Registration added successfully for attendee ID: ' || PI_ATTENDEE_ID);

EXCEPTION
    WHEN E_DUPLICATE_REGISTRATION THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Attendee ID "' || PI_ATTENDEE_ID || '" is already registered for this event.');
    WHEN E_EVENT_NOT_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Error: The event ID "' || PI_EVENT_ID || '" does not exist.');
    WHEN E_INVALID_TICKET_COUNT THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Tickets available must be greater than zero.');
    WHEN OTHERS THEN 
        ROLLBACK; -- Roll back the transaction in case of an unexpected error 
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_REGISTRATION;
