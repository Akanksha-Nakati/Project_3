create or replace PROCEDURE ADD_PAYMENT (
    PI_REGISTRATION_ID IN Payment.registration_id%TYPE,
    PI_AMOUNT IN Payment.amount%TYPE,
    PI_PAYMENT_METHOD IN Payment.payment_method%TYPE,
    PI_PAYMENT_DATE IN Payment.payment_date%TYPE,  -- Corrected parameter name
    PI_PAYMENT_STATUS IN Payment.payment_status%TYPE
) AS 
    v_registration_count NUMBER;
    -- Custom exceptions
    e_registration_exists EXCEPTION;
    e_invalid_amount EXCEPTION;

BEGIN
    -- Check if the registration_id already has an associated payment
    SELECT COUNT(*) INTO v_registration_count
    FROM Payment
    WHERE registration_id = PI_REGISTRATION_ID;
    IF v_registration_count > 0 THEN
        RAISE e_registration_exists;
    END IF;

    -- Check if the amount is positive
    IF PI_AMOUNT <= 0 THEN
        RAISE e_invalid_amount;
    END IF;

    -- Insert the new payment record
    INSERT INTO Payment (
        payment_id, 
        registration_id, 
        amount, 
        payment_method, 
        payment_date,  -- Corrected field name
        created_at, 
        updated_at, 
        payment_status
    )
    VALUES (
        PAYMENT_SEQ.NEXTVAL,  -- Assumes existence of a sequence for payment_id
        PI_REGISTRATION_ID,
        PI_AMOUNT,
        PI_PAYMENT_METHOD,
        PI_PAYMENT_DATE,  -- Corrected parameter usage
        SYSTIMESTAMP,  -- Sets the created_at timestamp
        SYSTIMESTAMP,  -- Sets the updated_at timestamp
        PI_PAYMENT_STATUS
    );
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Payment added successfully for registration ID: ' || PI_REGISTRATION_ID);

EXCEPTION
    WHEN e_registration_exists THEN
        DBMS_OUTPUT.PUT_LINE('Error: The registration ID ' || PI_REGISTRATION_ID || ' is already associated with a payment.');
    WHEN e_invalid_amount THEN
        DBMS_OUTPUT.PUT_LINE('Error: Payment amount must be positive.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_PAYMENT;
