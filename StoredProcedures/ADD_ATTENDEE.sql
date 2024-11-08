create or replace PROCEDURE ADD_ATTENDEE (
    PI_FIRST_NAME IN Attendee.first_name%TYPE,
    PI_LAST_NAME IN Attendee.last_name%TYPE,
    PI_EMAIL IN Attendee.email_id%TYPE,
    PI_ATTENDEE_PASSWORD IN Attendee.attendee_password%TYPE,
    PI_PHONE IN Attendee.phone_number%TYPE
) AS 
    v_email_count NUMBER;
    v_phone_count NUMBER;
    e_email_exists EXCEPTION;
    e_phone_exists EXCEPTION;
    e_attendee_password_valid EXCEPTION;
    e_numeric_name EXCEPTION;  -- Exception for numeric values in the name
BEGIN

-- Check if the password meets the minimum length requirement
    IF LENGTH(PI_ATTENDEE_PASSWORD) < 8 THEN
        RAISE E_ATTENDEE_PASSWORD_VALID;
    END IF;

-- Check if the first name contains numeric values
    IF REGEXP_LIKE(PI_FIRST_NAME, '\d') THEN
        RAISE E_NUMERIC_NAME;
    END IF;

-- Check if the last name contains numeric values
    IF REGEXP_LIKE(PI_LAST_NAME, '\d') THEN
        RAISE E_NUMERIC_NAME;
    END IF;

-- Check if email already exists
    SELECT COUNT(*) INTO v_email_count
    FROM Attendee
    WHERE email_id = LOWER(PI_EMAIL);
    IF v_email_count > 0 THEN
        RAISE e_email_exists;
    END IF;

-- Check if phone number already exists
    SELECT COUNT(*) INTO v_phone_count
    FROM Attendee
    WHERE phone_number = PI_PHONE;
    IF v_phone_count > 0 THEN
        RAISE e_phone_exists;
    END IF;

-- Insert new attendee
    INSERT INTO Attendee (attendee_id, first_name, last_name, email_id,attendee_password, phone_number)
    VALUES (
        ATTENDEE_SEQ.NEXTVAL,
        INITCAP(PI_FIRST_NAME),
        INITCAP(PI_LAST_NAME),
        LOWER(PI_EMAIL),
        PI_ATTENDEE_PASSWORD,
        PI_PHONE
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Attendee added successfully: ' || INITCAP(PI_FIRST_NAME) || ' ' || INITCAP(PI_LAST_NAME));

EXCEPTION
    WHEN e_email_exists THEN
        DBMS_OUTPUT.PUT_LINE('Error: The email "' || PI_EMAIL || '" is already registered.');
    WHEN e_phone_exists THEN
        DBMS_OUTPUT.PUT_LINE('Error: The phone number "' || PI_PHONE || '" is already registered.');
    WHEN e_attendee_password_valid THEN
        DBMS_OUTPUT.PUT_LINE('Password should have at least 8 characters');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_ATTENDEE;