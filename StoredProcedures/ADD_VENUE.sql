create or replace PROCEDURE ADD_VENUE (
    PI_VENUE_NAME Venue.venue_name%TYPE,
    PI_VENUE_ADDRESS Venue.venue_address%TYPE,
    PI_VENUE_CAPACITY Venue.venue_capacity%TYPE,
    PI_EVENT_ID Event.event_id%TYPE
) AS
    E_INVALID_NAME EXCEPTION;
    E_INVALID_ADDRESS EXCEPTION;
    E_INVALID_CAPACITY EXCEPTION;
    E_INVALID_EVENT_ID EXCEPTION;
    E_NAME_TOO_LONG EXCEPTION;
    E_ADDRESS_TOO_LONG EXCEPTION;

    -- Constants for maximum lengths based on the Venue table definition
    CONST_MAX_NAME_LENGTH CONSTANT INTEGER := 255;
    CONST_MAX_ADDRESS_LENGTH CONSTANT INTEGER := 255;
    CONST_MAX_CAPACITY_LENGTH CONSTANT INTEGER := 255;
BEGIN
    -- Check for NULL inputs
    IF PI_VENUE_NAME IS NULL THEN
        RAISE E_INVALID_NAME;
    END IF;

    IF PI_VENUE_ADDRESS IS NULL THEN
        RAISE E_INVALID_ADDRESS;
    END IF;

    IF PI_VENUE_CAPACITY IS NULL THEN
        RAISE E_INVALID_CAPACITY;
    END IF;

    IF PI_EVENT_ID IS NULL THEN
        RAISE E_INVALID_EVENT_ID;
    END IF;

    -- Check for input length
    IF LENGTH(PI_VENUE_NAME) > CONST_MAX_NAME_LENGTH THEN
        RAISE E_NAME_TOO_LONG;
    END IF;

    IF LENGTH(PI_VENUE_ADDRESS) > CONST_MAX_ADDRESS_LENGTH THEN
        RAISE E_ADDRESS_TOO_LONG;
    END IF;

    -- Validate if event_id exists in the Event table
    DECLARE
        v_event_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_event_exists FROM Event WHERE event_id = PI_EVENT_ID;
        IF v_event_exists = 0 THEN
            RAISE E_INVALID_EVENT_ID;
        END IF;
    END;

    -- Insert the new venue with auto-generated venue_id
    INSERT INTO Venue (venue_id, venue_name, venue_address, venue_capacity, event_id)
    VALUES (
        VENUE_SEQ.NEXTVAL,                -- Use sequence to generate venue_id
        INITCAP(PI_VENUE_NAME), 
        INITCAP(PI_VENUE_ADDRESS), 
        PI_VENUE_CAPACITY,
        PI_EVENT_ID
    );

    COMMIT; -- Commit the transaction

    -- Success message
    DBMS_OUTPUT.PUT_LINE('Venue added successfully: ' || INITCAP(PI_VENUE_NAME));
EXCEPTION
    WHEN E_INVALID_NAME THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue name cannot be null.');
    WHEN E_INVALID_ADDRESS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue address cannot be null.');
    WHEN E_INVALID_CAPACITY THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue capacity cannot be null.');
    WHEN E_INVALID_EVENT_ID THEN
        DBMS_OUTPUT.PUT_LINE('Error: The provided event ID does not exist.');
    WHEN E_NAME_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue name exceeds the maximum length of ' || CONST_MAX_NAME_LENGTH || ' characters.');
    WHEN E_ADDRESS_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue address exceeds the maximum length of ' || CONST_MAX_ADDRESS_LENGTH || ' characters.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_VENUE;