CREATE OR REPLACE PROCEDURE ADD_VENUE (
    PI_VENUE_NAME Venue.venue_name%TYPE,
    PI_VENUE_ADDRESS Venue.venue_address%TYPE,
    PI_VENUE_CAPACITY Venue.venue_capacity%TYPE,
    PI_EVENT_NAME VARCHAR2
) AS
    E_INVALID_NAME EXCEPTION;
    E_INVALID_ADDRESS EXCEPTION;
    E_INVALID_CAPACITY EXCEPTION;
    E_EVENT_NOT_FOUND EXCEPTION;
    E_NAME_TOO_LONG EXCEPTION;
    E_ADDRESS_TOO_LONG EXCEPTION;
    E_DUPLICATE_VENUE_ADDRESS EXCEPTION;
    E_NEGATIVE_CAPACITY EXCEPTION;

    V_EVENT_ID EVENT.EVENT_ID%TYPE;
    V_DUPLICATE_COUNT NUMBER;

    -- Constants for maximum lengths based on the Venue table definition
    CONST_MAX_NAME_LENGTH CONSTANT INTEGER := 255;
    CONST_MAX_ADDRESS_LENGTH CONSTANT INTEGER := 255;
    CONST_MAX_CAPACITY_LENGTH CONSTANT INTEGER := 255;
BEGIN
    -- Fetch EVENT_ID from EVENT table, ensuring only one event is fetched
    BEGIN
        SELECT EVENT_ID INTO V_EVENT_ID
        FROM EVENT
        WHERE UPPER(EVENT_NAME) = UPPER(PI_EVENT_NAME)
        AND ROWNUM = 1; -- Ensures only one row is returned (in case of duplicates)
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_EVENT_NOT_FOUND;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Error: Multiple events found with the same name.');
            RAISE E_EVENT_NOT_FOUND; -- Handle as event not found if multiple events are found
    END;

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

    -- Check that venue capacity is not negative
    IF PI_VENUE_CAPACITY < 0 THEN
        RAISE E_NEGATIVE_CAPACITY;
    END IF;

    -- Check for input length
    IF LENGTH(PI_VENUE_NAME) > CONST_MAX_NAME_LENGTH THEN
        RAISE E_NAME_TOO_LONG;
    END IF;

    IF LENGTH(PI_VENUE_ADDRESS) > CONST_MAX_ADDRESS_LENGTH THEN
        RAISE E_ADDRESS_TOO_LONG;
    END IF;

    -- Check if the venue address already exists (even if the venue name is different)
    SELECT COUNT(*)
    INTO V_DUPLICATE_COUNT
    FROM Venue
    WHERE UPPER(venue_address) = UPPER(PI_VENUE_ADDRESS);

    IF V_DUPLICATE_COUNT > 0 THEN
        RAISE E_DUPLICATE_VENUE_ADDRESS;
    END IF;

    -- Insert the new venue with auto-generated venue_id
    INSERT INTO Venue (venue_id, venue_name, venue_address, venue_capacity, event_id)
    VALUES (
        VENUE_SEQ.NEXTVAL,                -- Use sequence to generate venue_id
        INITCAP(PI_VENUE_NAME), 
        INITCAP(PI_VENUE_ADDRESS), 
        PI_VENUE_CAPACITY,
        V_EVENT_ID
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
    WHEN E_NEGATIVE_CAPACITY THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue capacity cannot be negative.');
    WHEN E_EVENT_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The provided event does not exist.');
    WHEN E_NAME_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue name exceeds the maximum length of ' || CONST_MAX_NAME_LENGTH || ' characters.');
    WHEN E_ADDRESS_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Venue address exceeds the maximum length of ' || CONST_MAX_ADDRESS_LENGTH || ' characters.');
    WHEN E_DUPLICATE_VENUE_ADDRESS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The venue address "' || PI_VENUE_ADDRESS || '" is already registered.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_VENUE;
