SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE ADD_PAYMENT (
    PI_ATTENDEE_EMAIL VARCHAR2,                    -- Attendee email to find registrations
    PI_AMOUNT Payment.amount%TYPE,                -- Payment amount
    PI_PAYMENT_METHOD Payment.payment_method%TYPE, -- Payment method
    PI_PAYMENT_STATUS Payment.payment_status%TYPE  -- Payment status
) AS
    -- Custom exceptions
    E_REGISTRATION_NOT_FOUND EXCEPTION;
    E_PAYMENT_ALREADY_EXISTS EXCEPTION;
    E_INVALID_AMOUNT EXCEPTION;
    E_TICKET_PRICE_MISMATCH EXCEPTION;  -- New exception for ticket price mismatch

    -- Variables
    V_REGISTRATION_ID Registration.registration_id%TYPE;
    V_REGISTRATION_TICKET_PRICE Registration.ticket_Price%TYPE;
    V_REGISTRATION_COUNT NUMBER;
BEGIN
    -- Cursor to fetch multiple registrations for the given attendee email
    DECLARE
        CURSOR reg_cursor IS
            SELECT R.registration_id, R.ticket_Price
            FROM Registration R
            JOIN Attendee A ON R.attendee_id = A.attendee_id
            WHERE LOWER(A.EMAIL_ID) = LOWER(PI_ATTENDEE_EMAIL);
        
    BEGIN
        OPEN reg_cursor;
        LOOP
            FETCH reg_cursor INTO V_REGISTRATION_ID, V_REGISTRATION_TICKET_PRICE;
            EXIT WHEN reg_cursor%NOTFOUND;

            -- Check if a payment already exists for the fetched REGISTRATION_ID
            SELECT COUNT(*) INTO V_REGISTRATION_COUNT
            FROM Payment
            WHERE registration_id = V_REGISTRATION_ID;

            IF V_REGISTRATION_COUNT > 0 THEN
                DBMS_OUTPUT.PUT_LINE('Payment already exists for Registration ID: ' || V_REGISTRATION_ID);
                -- You can choose to either skip or raise an error here, depending on your logic
                CONTINUE;
            END IF;

            -- Validate the payment amount
            IF PI_AMOUNT <= 0 THEN
                RAISE E_INVALID_AMOUNT;
            END IF;

            -- Check if the ticket price matches the payment amount
            IF PI_AMOUNT != V_REGISTRATION_TICKET_PRICE THEN
                RAISE E_TICKET_PRICE_MISMATCH;
            END IF;

            -- Insert the payment record
            INSERT INTO Payment (
                payment_id, 
                registration_id, 
                amount, 
                payment_method,  
                created_at, 
                payment_status
            ) VALUES (
                PAYMENT_SEQ.NEXTVAL,  -- Assuming a sequence for payment_id
                V_REGISTRATION_ID,
                PI_AMOUNT,
                PI_PAYMENT_METHOD,
                SYSTIMESTAMP,         -- Set created_at timestamp
                PI_PAYMENT_STATUS
            );

            -- Debugging message for success
            DBMS_OUTPUT.PUT_LINE('Payment added successfully for Registration ID: ' || V_REGISTRATION_ID);
        END LOOP;

        CLOSE reg_cursor;

        -- Commit the transaction
        COMMIT;

    EXCEPTION
        WHEN E_INVALID_AMOUNT THEN
            DBMS_OUTPUT.PUT_LINE('Error: Payment amount must be positive.');
        WHEN E_TICKET_PRICE_MISMATCH THEN
            DBMS_OUTPUT.PUT_LINE('Error: The payment amount does not match the ticket price.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
    END;
END ADD_PAYMENT;
/
