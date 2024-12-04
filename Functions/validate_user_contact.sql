CREATE OR REPLACE FUNCTION validate_user_contact(phone_no IN VARCHAR2, email_id IN VARCHAR2)
RETURN BOOLEAN
IS
    -- Regular expression for validating the phone number
    phone_regex VARCHAR2(100) := '^[0-9]{10}$|^(\([0-9]{3}\))\s?[0-9]{3}-[0-9]{4}$|^([0-9]{3}-[0-9]{3}-[0-9]{4})$';
    -- Regular expression for validating the email
    email_regex VARCHAR2(100) := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
BEGIN
    -- Validate phone number
    IF NOT REGEXP_LIKE(phone_no, phone_regex) THEN
        RETURN FALSE;
    END IF;

    -- Validate email
    IF NOT REGEXP_LIKE(email_id, email_regex) THEN
        RETURN FALSE;
    END IF;

    -- If both are valid
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE; -- Return false in case of any unexpected error
END;
/