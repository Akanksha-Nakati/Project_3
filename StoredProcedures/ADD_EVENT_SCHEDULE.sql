create or replace PROCEDURE ADD_EVENT_SCHEDULE (
    PI_EVENT_ID IN NUMBER,
    PI_VENUE_ID IN NUMBER,
    PI_EVENT_SCHEDULE_DATE IN DATE,
    PI_START_TIME IN TIMESTAMP,
    PI_END_TIME IN TIMESTAMP
) AS 
    E_DATE_EXISTS EXCEPTION;
    E_INVALID_DATE EXCEPTION;
    E_START_END_TIME_ERROR EXCEPTION;
    v_count NUMBER;
BEGIN
    -- Check for NULL inputs
    IF PI_EVENT_SCHEDULE_DATE IS NULL OR PI_START_TIME IS NULL OR PI_END_TIME IS NULL THEN
        RAISE E_INVALID_DATE;
    END IF;

    -- Check if start time is earlier than end time
    IF PI_START_TIME >= PI_END_TIME THEN
        RAISE E_START_END_TIME_ERROR;
    END IF;

    -- Check for existing event schedule date for the same event
    SELECT COUNT(*) INTO v_count FROM Event_Schedule
    WHERE event_schedule_date = PI_EVENT_SCHEDULE_DATE
      AND event_id = PI_EVENT_ID;

    IF v_count > 0 THEN
        RAISE E_DATE_EXISTS;
    END IF;

    -- Insert the new event schedule record
    INSERT INTO Event_Schedule (
        eventschedule_id, event_id, venue_id, event_schedule_date, start_time, end_time, created_at, updated_at
    )
    VALUES (
        EVENT_SCHEDULE_SEQ.NEXTVAL, PI_EVENT_ID, PI_VENUE_ID, PI_EVENT_SCHEDULE_DATE, PI_START_TIME, PI_END_TIME, SYSTIMESTAMP, SYSTIMESTAMP
    );

    -- Commit the transaction
    COMMIT;

    -- Success message
    DBMS_OUTPUT.PUT_LINE('Event schedule added successfully for event ID: ' || PI_EVENT_ID);

EXCEPTION
    WHEN E_DATE_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An event schedule already exists for the specified date and event ID.');

    WHEN E_INVALID_DATE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Event schedule date, start time, and end time cannot be null.');

    WHEN E_START_END_TIME_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Start time must be earlier than end time.');

    WHEN OTHERS THEN
        ROLLBACK; -- Roll back the transaction in case of an unexpected error
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Output the error message
END;