create or replace PROCEDURE ADD_EVENT (
    PI_EVENT_NAME IN Event.event_name%TYPE,
    PI_EVENT_DESC IN Event.event_desc%TYPE,
    PI_ORGANIZER_ID IN Event.organizer_id%TYPE,
    PI_SPONSOR_ID IN Event.sponsor_id%TYPE
) AS 
    E_NAME_EXISTS EXCEPTION;
    E_INVALID_NAME EXCEPTION;
    E_INVALID_SPONSOR_ID EXCEPTION;
    E_INVALID_ORGANIZER_ID EXCEPTION;

BEGIN
    -- Check for NULL inputs
    IF PI_EVENT_NAME IS NULL OR PI_EVENT_DESC IS NULL THEN
        RAISE E_INVALID_NAME;
    END IF;

    -- Check for existing event name to ensure uniqueness
    DECLARE
        v_name_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_name_count FROM Event WHERE UPPER(event_name) = UPPER(PI_EVENT_NAME);
        IF v_name_count > 0 THEN
            RAISE E_NAME_EXISTS;
        END IF;
    END;

    -- Validate sponsor_id
    DECLARE
        v_sponsor_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_sponsor_count FROM Sponsor WHERE sponsor_id = PI_SPONSOR_ID;
        IF v_sponsor_count = 0 THEN
            RAISE E_INVALID_SPONSOR_ID;
        END IF;
    END;

    -- Validate organizer_id
    DECLARE
        v_organizer_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_organizer_count FROM Organization WHERE organization_id = PI_ORGANIZER_ID;
        IF v_organizer_count = 0 THEN
            RAISE E_INVALID_ORGANIZER_ID;
        END IF;
    END;

    -- If all validations pass, insert a new record
    INSERT INTO Event (event_id, event_name, event_desc, organizer_id, sponsor_id)
    VALUES (EVENT_SEQ.NEXTVAL, INITCAP(PI_EVENT_NAME), PI_EVENT_DESC, PI_ORGANIZER_ID, PI_SPONSOR_ID);

    COMMIT; -- Commit the transaction

    -- Success message
    DBMS_OUTPUT.PUT_LINE('Event added successfully: ' || INITCAP(PI_EVENT_NAME));

EXCEPTION
    WHEN E_NAME_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The event name "' || PI_EVENT_NAME || '" already exists.');
    WHEN E_INVALID_NAME THEN
        DBMS_OUTPUT.PUT_LINE('Error: Event name and description cannot be null.');
    WHEN E_INVALID_SPONSOR_ID THEN
        DBMS_OUTPUT.PUT_LINE('Error: The sponsor ID "' || PI_SPONSOR_ID || '" is invalid.');
    WHEN E_INVALID_ORGANIZER_ID THEN
        DBMS_OUTPUT.PUT_LINE('Error: The organizer ID "' || PI_ORGANIZER_ID || '" is invalid.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back the transaction in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_EVENT;