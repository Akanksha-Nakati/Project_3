CREATE OR REPLACE PROCEDURE ADD_ORGANIZER (
    PI_ORGANIZER_NAME IN Organizer.organizer_name%TYPE,
    PI_EMAIL IN Organizer.email%TYPE,
    PI_PHONE_NUMBER IN Organizer.phone_number%TYPE,
    PI_ORGANIZER_PASSWORD IN Organizer.organizer_password%TYPE
) AS 
    E_EMAIL_EXISTS EXCEPTION;
    E_PHONE_EXISTS EXCEPTION;
    E_INVALID_NAME EXCEPTION;
    E_NAME_TOO_LONG EXCEPTION;
    E_PASSWORD_TOO_LONG EXCEPTION;
    CONST_MAX_NAME_LENGTH CONSTANT INTEGER := 255; -- Max length as per table definition
    CONST_MAX_PASSWORD_LENGTH CONSTANT INTEGER := 20; -- Max password length as per table definition
    v_email_count NUMBER;
    v_phone_count NUMBER;

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

    -- Check for existing email (case-insensitive comparison)
    SELECT COUNT(*) INTO v_email_count
    FROM Organizer
    WHERE LOWER(email) = LOWER(PI_EMAIL);

    IF v_email_count > 0 THEN
        RAISE E_EMAIL_EXISTS;
    END IF;

    -- Check for existing phone number
    SELECT COUNT(*) INTO v_phone_count
    FROM Organizer
    WHERE phone_number = PI_PHONE_NUMBER;

    IF v_phone_count > 0 THEN
        RAISE E_PHONE_EXISTS;
    END IF;

    -- Insert a new record with unique organizer_id using a sequence (assuming ORGANIZER_SEQ)
    INSERT INTO Organizer (organizer_id, organizer_name, email, phone_number, organizer_password) 
    VALUES (
        ORGANIZER_SEQ.NEXTVAL,  -- Use a sequence to auto-generate primary key values
        INITCAP(PI_ORGANIZER_NAME),
        LOWER(PI_EMAIL),
        PI_PHONE_NUMBER,
        PI_ORGANIZER_PASSWORD
    );

    COMMIT; -- Commit the transaction to ensure changes are saved

    DBMS_OUTPUT.PUT_LINE('Organizer added successfully: ' || INITCAP(PI_ORGANIZER_NAME));

EXCEPTION
    -- Handle specific constraint violations gracefully
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
        DBMS_OUTPUT.PUT_LINE('Some unexpected error occurred. Please try again.');
END ADD_ORGANIZER;
