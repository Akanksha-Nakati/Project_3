create or replace PROCEDURE ADD_FEEDBACK (
    PI_EVENT_ID IN Feedback.event_id%TYPE,
    PI_ATTENDEE_ID IN Feedback.attendee_id%TYPE,
    PI_RATING IN Feedback.rating%TYPE,
    PI_FEEDBACK_TEXT IN Feedback.feedback_text%TYPE
) AS 
    E_ATTENDEE_EXISTS EXCEPTION;
    E_DUPLICATE_FEEDBACK EXCEPTION;
    E_INVALID_RATING EXCEPTION;
    E_EVENT_NOT_FOUND EXCEPTION;
    E_EMPTY_REVIEW_TEXT EXCEPTION;
    v_event_count NUMBER; -- Variable to hold count of events

BEGIN
    -- Check if the attendee ID already has feedback
    FOR C IN (SELECT 1 FROM Feedback WHERE attendee_id = PI_ATTENDEE_ID AND event_id = PI_EVENT_ID) LOOP
        RAISE E_DUPLICATE_FEEDBACK;
    END LOOP;

    -- Check if the event ID exists
    SELECT COUNT(*) INTO v_event_count FROM Event WHERE event_id = PI_EVENT_ID;
    IF v_event_count = 0 THEN
        RAISE E_EVENT_NOT_FOUND;
    END IF;

    -- Validate rating (you can customize this check based on your rating criteria)
    IF PI_RATING < 1 OR PI_RATING > 5 THEN
        RAISE E_INVALID_RATING;
    END IF;

    -- Insert new feedback record
    INSERT INTO Feedback (feedback_id, event_id, attendee_id, rating, feedback_text) 
    VALUES (
        Feedback_SEQ.NEXTVAL, -- Assumes existence of sequence for generating feedback_id
        PI_EVENT_ID,
        PI_ATTENDEE_ID,
        PI_RATING,
        PI_FEEDBACK_TEXT
    );

    COMMIT; -- Commit the transaction to ensure changes are saved

    DBMS_OUTPUT.PUT_LINE('Feedback added successfully for attendee ID: ' || PI_ATTENDEE_ID);

EXCEPTION
    WHEN E_DUPLICATE_FEEDBACK THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Feedback from attendee ID "' || PI_ATTENDEE_ID || '" already exists for this event.');
    WHEN E_EVENT_NOT_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Error: The event ID "' || PI_EVENT_ID || '" does not exist.');
    WHEN E_INVALID_RATING THEN 
        DBMS_OUTPUT.PUT_LINE('Error: Invalid rating. Rating must be between 1 and 5.');
    WHEN OTHERS THEN 
        ROLLBACK; -- Roll back the transaction in case of an unexpected error 
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END ADD_FEEDBACK;