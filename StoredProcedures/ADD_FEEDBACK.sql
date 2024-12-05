CREATE OR REPLACE PROCEDURE ADD_FEEDBACK (
    PI_EVENT_NAME IN Event.event_name%TYPE, -- Input event name
    PI_ATTENDEE_EMAIL VARCHAR2, -- Input attendee email
    PI_RATING IN Feedback.rating%TYPE, -- Input rating
    PI_FEEDBACK_TEXT IN Feedback.feedback_text%TYPE, -- Input feedback text
    PI_SPONSOR_NAME IN Sponsor.sponsor_name%TYPE -- Input sponsor name
) AS
    E_ATTENDEE_EXISTS EXCEPTION;
    E_DUPLICATE_FEEDBACK EXCEPTION;
    E_INVALID_RATING EXCEPTION;
    E_EVENT_NOT_FOUND EXCEPTION;
    E_EMPTY_REVIEW_TEXT EXCEPTION;
    E_ATTENDEE_NOT_FOUND EXCEPTION;
    E_SPONSOR_NOT_FOUND EXCEPTION;
    E_UNEXPECTED_ERROR EXCEPTION;  -- For unexpected errors like ORA-00001

    v_event_id NUMBER; -- Variable to hold event_id
    v_feedback_count NUMBER; -- Variable to check for duplicate feedback
    v_sponsor_id NUMBER; -- Variable to hold sponsor_id
    V_ATTENDEE_ID ATTENDEE.ATTENDEE_ID%TYPE;

BEGIN
    -- Get the EVENT_ID from the Event table using EVENT_NAME
    BEGIN
        SELECT E.EVENT_ID
        INTO v_event_id
        FROM Event E
        WHERE LOWER(E.EVENT_NAME) = LOWER(PI_EVENT_NAME);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_EVENT_NOT_FOUND;
    END;

    -- Fetch ATTENDEE_ID from ATTENDEE table based on attendee email
    BEGIN
        SELECT ATTENDEE_ID INTO V_ATTENDEE_ID 
        FROM ATTENDEE 
        WHERE LOWER(EMAIL_ID) = LOWER(PI_ATTENDEE_EMAIL);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_ATTENDEE_NOT_FOUND;
    END;

    -- Get the SPONSOR_ID from the Sponsor table using SPONSOR_NAME
    BEGIN
        SELECT S.SPONSOR_ID
        INTO v_sponsor_id
        FROM Sponsor S
        WHERE LOWER(S.SPONSOR_NAME) = LOWER(PI_SPONSOR_NAME);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_SPONSOR_NOT_FOUND;
    END;

    -- Check if the attendee has already provided feedback for the specified event
    BEGIN
        SELECT COUNT(*)
        INTO v_feedback_count
        FROM Feedback
        WHERE attendee_id = v_attendee_id AND event_id = v_event_id;

        -- If feedback already exists for the same event, raise an error
        IF v_feedback_count > 0 THEN
            RAISE E_DUPLICATE_FEEDBACK;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- No feedback exists, continue
            NULL;
    END;

    -- Validate the rating
    IF PI_RATING < 1 OR PI_RATING > 5 THEN
        RAISE E_INVALID_RATING;
    END IF;

    -- Check if the feedback text is empty
    IF TRIM(PI_FEEDBACK_TEXT) IS NULL THEN
        RAISE E_EMPTY_REVIEW_TEXT;
    END IF;

    -- Insert new feedback record
    BEGIN
        INSERT INTO Feedback (feedback_id, event_id, attendee_id, rating, feedback_text, sponsor_id) 
        VALUES (
            Feedback_SEQ.NEXTVAL, -- Assumes existence of a sequence for generating feedback_id
            v_event_id,
            V_ATTENDEE_ID,
            PI_RATING,
            PI_FEEDBACK_TEXT,
            v_sponsor_id
        );
    EXCEPTION
        WHEN OTHERS THEN
            -- Handle unique constraint violation (ORA-00001) gracefully
            IF SQLCODE = -1 THEN  -- ORA-00001: unique constraint violated
                DBMS_OUTPUT.PUT_LINE('Error: Attendee has already given feedback for this event.');
            ELSE
                ROLLBACK; -- Rollback the transaction in case of any unexpected error
                DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
            END IF;
            RAISE E_UNEXPECTED_ERROR;
    END;

    COMMIT; -- Commit the transaction to ensure changes are saved

    DBMS_OUTPUT.PUT_LINE('Feedback added successfully for attendee ID: ' || V_ATTENDEE_ID);

EXCEPTION
    WHEN E_EVENT_NOT_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Error: No EVENT found for the specified name "' || PI_EVENT_NAME || '".');
    WHEN E_ATTENDEE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No ATTENDEE found for the specified name "' || PI_ATTENDEE_EMAIL || '".');
    WHEN E_SPONSOR_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No SPONSOR found for the specified name "' || PI_SPONSOR_NAME || '".');
    WHEN E_DUPLICATE_FEEDBACK THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Feedback from attendee ID "' || V_ATTENDEE_ID || '" already exists for this event.');
    WHEN E_INVALID_RATING THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Invalid rating. Rating must be between 1 and 5.');
    WHEN E_EMPTY_REVIEW_TEXT THEN
        DBMS_OUTPUT.PUT_LINE('Error: Feedback text cannot be empty.');
    WHEN E_UNEXPECTED_ERROR THEN 
        -- Do not re-raise the error, just log it
        NULL;
    WHEN OTHERS THEN 
        ROLLBACK; -- Rollback the transaction in case of an unexpected error 
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_FEEDBACK;
