CREATE OR REPLACE PROCEDURE ADD_ATTENDEE (
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
    e_null_first_name EXCEPTION; -- Exception for NULL first name
    e_null_email EXCEPTION;     -- Exception for NULL email
    e_null_phone EXCEPTION;     -- Exception for NULL phone number
BEGIN
    -- Check for NULL values in first name, email, and phone number
    IF PI_FIRST_NAME IS NULL THEN
        RAISE e_null_first_name;
    END IF;

    IF PI_EMAIL IS NULL THEN
        RAISE e_null_email;
    END IF;

    IF PI_PHONE IS NULL THEN
        RAISE e_null_phone;
    END IF;

    -- Check if the password meets the minimum length requirement
    IF LENGTH(PI_ATTENDEE_PASSWORD) < 8 THEN
        RAISE e_attendee_password_valid;
    END IF;

    -- Check if the first name contains numeric values
    IF REGEXP_LIKE(PI_FIRST_NAME, '\d') THEN
        RAISE e_numeric_name;
    END IF;

    -- Check if the last name contains numeric values
    IF REGEXP_LIKE(PI_LAST_NAME, '\d') THEN
        RAISE e_numeric_name;
    END IF;

    -- Validate email and phone using the validate_user_contact function
    IF NOT validate_user_contact(PI_PHONE, PI_EMAIL) THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid phone number or email format.');
        RETURN;
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
    INSERT INTO Attendee (attendee_id, first_name, last_name, email_id, attendee_password, phone_number)
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
        DBMS_OUTPUT.PUT_LINE('Password should have at least 8 characters.');
    WHEN e_numeric_name THEN
        DBMS_OUTPUT.PUT_LINE('Error: Names cannot contain numeric values.');
    WHEN e_null_first_name THEN
        DBMS_OUTPUT.PUT_LINE('Error: First name cannot be NULL.');
    WHEN e_null_email THEN
        DBMS_OUTPUT.PUT_LINE('Error: Email cannot be NULL.');
    WHEN e_null_phone THEN
        DBMS_OUTPUT.PUT_LINE('Error: Phone number cannot be NULL.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_ATTENDEE;
