CREATE OR REPLACE PROCEDURE ADD_EVENT (
    PI_EVENT_NAME IN Event.event_name%TYPE,
    PI_EVENT_DESC IN Event.event_desc%TYPE,
    PI_ORGANIZER_EMAIL IN Organizer.email%TYPE,
    PI_SPONSOR_NAME IN Sponsor.sponsor_name%TYPE,
    PI_TICKET_PRICE IN Event.ticket_price%TYPE -- Added ticket_price as input parameter
) AS
    E_NAME_EXISTS EXCEPTION;
    E_INVALID_NAME EXCEPTION;
    E_ORGANIZER_NOT_FOUND EXCEPTION;
    E_SPONSOR_NOT_FOUND EXCEPTION;
    E_MULTIPLE_SPONSORS EXCEPTION;
    E_INVALID_TICKET_PRICE EXCEPTION; -- New exception for invalid ticket price

    V_ORGANIZER_ID Organizer.organizer_id%TYPE;
    V_SPONSOR_ID Sponsor.sponsor_id%TYPE;

BEGIN
    -- Get the ORGANIZER_ID from ORGANIZER table using EMAIL
    BEGIN
        SELECT organizer_id INTO V_ORGANIZER_ID 
        FROM Organizer 
        WHERE UPPER(email) = UPPER(PI_ORGANIZER_EMAIL);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_ORGANIZER_NOT_FOUND;
    END;

    -- Get the SPONSOR_ID from SPONSOR table using SPONSOR_NAME
    BEGIN
        SELECT sponsor_id INTO V_SPONSOR_ID 
        FROM Sponsor 
        WHERE UPPER(sponsor_name) = UPPER(PI_SPONSOR_NAME)
        AND ROWNUM = 1; -- Ensure only one result is returned

        -- Check if multiple sponsors exist with the same name
        DECLARE
            v_sponsor_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_sponsor_count
            FROM Sponsor
            WHERE UPPER(sponsor_name) = UPPER(PI_SPONSOR_NAME);

            IF v_sponsor_count > 1 THEN
                RAISE E_MULTIPLE_SPONSORS;
            END IF;
        END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_SPONSOR_NOT_FOUND;
    END;

    -- Check for NULL inputs
    IF PI_EVENT_NAME IS NULL OR PI_EVENT_DESC IS NULL THEN
        RAISE E_INVALID_NAME;
    END IF;

    -- Check for existing event name to ensure uniqueness
    DECLARE
        v_name_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_name_count 
        FROM Event 
        WHERE UPPER(event_name) = UPPER(PI_EVENT_NAME);

        IF v_name_count > 0 THEN
            RAISE E_NAME_EXISTS;
        END IF;
    END;

    -- Validate the ticket_price (non-null and non-negative)
    IF PI_TICKET_PRICE IS NULL OR PI_TICKET_PRICE < 0 THEN
        RAISE E_INVALID_TICKET_PRICE;
    END IF;

    -- If all validations pass, insert a new record
    INSERT INTO Event (event_id, event_name, event_desc, organizer_id, sponsor_id, ticket_price)
    VALUES (EVENT_SEQ.NEXTVAL, INITCAP(PI_EVENT_NAME), PI_EVENT_DESC, V_ORGANIZER_ID, V_SPONSOR_ID, PI_TICKET_PRICE);

    COMMIT; -- Commit the transaction

    -- Success message
    DBMS_OUTPUT.PUT_LINE('Event added successfully: ' || INITCAP(PI_EVENT_NAME));

EXCEPTION
    WHEN E_ORGANIZER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The specified ORGANIZER does not exist.');
    WHEN E_SPONSOR_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The specified SPONSOR does not exist.');
    WHEN E_MULTIPLE_SPONSORS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple sponsors found with the name "' || PI_SPONSOR_NAME || '".');
    WHEN E_NAME_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The event name "' || PI_EVENT_NAME || '" already exists.');
    WHEN E_INVALID_NAME THEN
        DBMS_OUTPUT.PUT_LINE('Error: Event name and description cannot be null.');
    WHEN E_INVALID_TICKET_PRICE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ticket price cannot be null or negative.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back the transaction in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_EVENT;

