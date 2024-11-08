create or replace PROCEDURE ADD_ORGANIZATION (
    PI_ORGANIZER_NAME IN Organization.organizer_name%TYPE,
    PI_EMAIL IN Organization.email%TYPE,
    PI_PHONE_NUMBER IN Organization.phone_number%TYPE,
    PI_ORGANIZER_PASSWORD IN Organization.organizer_password%TYPE,
    PI_EVENT_SCHEDULE_ID IN Organization.event_schedule_id%TYPE
) AS 
    E_EMAIL_EXISTS EXCEPTION;
    E_PHONE_EXISTS EXCEPTION;
    E_INVALID_NAME EXCEPTION;
    E_NAME_TOO_LONG EXCEPTION;
    E_PASSWORD_TOO_LONG EXCEPTION;

    CONST_MAX_NAME_LENGTH CONSTANT INTEGER := 255; -- Max length as per table definition
    CONST_MAX_PASSWORD_LENGTH CONSTANT INTEGER := 20; -- Max password length as per table definition

BEGIN
    -- Check for NULL inputs for organizer name
    IF PI_ORGANIZER_NAME IS NULL THEN
        RAISE E_INVALID_NAME;
    END IF;

    -- Check if organizer name exceeds max length
    IF LENGTH(PI_ORGANIZER_NAME) > CONST_MAX_NAME_LENGTH THEN
        RAISE E_NAME_TOO_LONG;
    END IF;

    -- Check if password exceeds max length
    IF LENGTH(PI_ORGANIZER_PASSWORD) > CONST_MAX_PASSWORD_LENGTH THEN
        RAISE E_PASSWORD_TOO_LONG;
    END IF;

    -- Check for existing email to ensure uniqueness
    FOR C IN (SELECT 1 FROM Organization WHERE UPPER(email) = UPPER(PI_EMAIL)) LOOP
        RAISE E_EMAIL_EXISTS;
    END LOOP;

    -- Check for existing phone number to ensure uniqueness
    FOR C IN (SELECT 1 FROM Organization WHERE phone_number = PI_PHONE_NUMBER) LOOP
        RAISE E_PHONE_EXISTS;
    END LOOP;

    -- Insert a new record with unique organization_id using a sequence (assuming a sequence named ORG_SEQ)
    INSERT INTO Organization (organization_id, organizer_name, email, phone_number, organizer_password, event_schedule_id) 
    VALUES (
        ORGANIZATION_SEQ.NEXTVAL,  -- Use a sequence to auto-generate primary key values
        INITCAP(PI_ORGANIZER_NAME),
        LOWER(PI_EMAIL),
        PI_PHONE_NUMBER,
        PI_ORGANIZER_PASSWORD,
        PI_EVENT_SCHEDULE_ID
    );

    COMMIT; -- Commit the transaction to ensure changes are saved

    DBMS_OUTPUT.PUT_LINE('Organization added successfully: ' || INITCAP(PI_ORGANIZER_NAME));

EXCEPTION
    WHEN E_EMAIL_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The email "' || PI_EMAIL || '" is already registered.');
    WHEN E_PHONE_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: The phone number "' || PI_PHONE_NUMBER || '" is already registered.');
    WHEN E_INVALID_NAME THEN
        DBMS_OUTPUT.PUT_LINE('Error: Organizer name cannot be null.');
    WHEN E_NAME_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Organizer name exceeds the maximum length of ' || CONST_MAX_NAME_LENGTH || ' characters.');
    WHEN E_PASSWORD_TOO_LONG THEN
        DBMS_OUTPUT.PUT_LINE('Error: Password exceeds the maximum length of ' || CONST_MAX_PASSWORD_LENGTH || ' characters.');
    WHEN OTHERS THEN
        ROLLBACK; -- Roll back the transaction in case of an unexpected error 
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_ORGANIZATION;