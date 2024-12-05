CREATE OR REPLACE PROCEDURE ADD_SPONSOR (
    PI_SPONSOR_NAME IN Sponsor.sponsor_name%TYPE,
    PI_EMAIL IN Sponsor.email%TYPE,
    PI_PHONE IN Sponsor.phone_number%TYPE,
    PI_SPONSOR_PASSWORD IN Sponsor.sponsor_password%TYPE,
    PI_AMOUNT_SPONSORED IN Sponsor.amount_sponsored%TYPE
) AS
    v_email_count NUMBER;
    v_phone_count NUMBER;
    e_duplicate_sponsor EXCEPTION;  -- Exception for duplicate sponsor
    e_invalid_input EXCEPTION;     -- Exception for invalid input in name
    e_sponsor_password_valid EXCEPTION; -- Exception for invalid password
BEGIN
    -- Check if the sponsor name contains numeric values or special characters
    IF REGEXP_LIKE(PI_SPONSOR_NAME, '[\d\W]') THEN
        RAISE E_INVALID_INPUT;
    END IF;

    -- Check if the password meets the minimum length requirement
    IF LENGTH(PI_SPONSOR_PASSWORD) < 8 THEN
        RAISE E_SPONSOR_PASSWORD_VALID;
    END IF;

    -- Validate email and phone using the validate_user_contact function
    IF NOT validate_user_contact(PI_PHONE, PI_EMAIL) THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid phone number or email format.');
        RETURN;
    END IF;

    -- Check if email already exists
    SELECT COUNT(*) INTO v_email_count
    FROM Sponsor
    WHERE email = LOWER(PI_EMAIL);

    -- Check if phone number already exists
    SELECT COUNT(*) INTO v_phone_count
    FROM Sponsor
    WHERE phone_number = PI_PHONE;

    -- Raise exception if either email or phone exists
    IF v_email_count > 0 OR v_phone_count > 0 THEN
        RAISE e_duplicate_sponsor;
    END IF;

    -- Insert new sponsor
    INSERT INTO Sponsor (sponsor_id, sponsor_name, email, phone_number, sponsor_password, amount_sponsored)
    VALUES (
        SPONSOR_SEQ.NEXTVAL,  -- Assumes a sequence SPONSOR_SEQ for generating unique IDs
        INITCAP(PI_SPONSOR_NAME),
        LOWER(PI_EMAIL),
        PI_PHONE,
        PI_SPONSOR_PASSWORD,
        PI_AMOUNT_SPONSORED
    );

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Sponsor added successfully: ' || INITCAP(PI_SPONSOR_NAME));

EXCEPTION
    WHEN e_duplicate_sponsor THEN
        DBMS_OUTPUT.PUT_LINE('Error: Sponsor is already present with the given email or phone number.');
    WHEN e_sponsor_password_valid THEN
        DBMS_OUTPUT.PUT_LINE('Error: Password must be at least 8 characters long.');
    WHEN e_invalid_input THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid sponsor name. Please ensure the name does not contain numbers or special characters.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_SPONSOR;
/
