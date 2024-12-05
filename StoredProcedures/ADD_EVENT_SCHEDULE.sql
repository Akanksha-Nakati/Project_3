CREATE OR REPLACE PROCEDURE ADD_EVENT_SCHEDULE (
    PI_EVENT_NAME VARCHAR2,
    PI_VENUE_NAME VARCHAR2,
    PI_EVENT_SCHEDULE_DATE IN DATE,
    PI_START_TIME IN TIMESTAMP,
    PI_END_TIME IN TIMESTAMP
) AS 
    -- Exception declarations
    E_DATE_EXISTS EXCEPTION;
    E_INVALID_DATE EXCEPTION;
    E_START_END_TIME_ERROR EXCEPTION;
    E_EVENT_NOT_FOUND EXCEPTION;
    E_VENUE_NOT_FOUND EXCEPTION;

    -- Variables
    v_count NUMBER;
    V_EVENT_ID EVENT.EVENT_ID%TYPE;
    V_VENUE_ID VENUE.VENUE_ID%TYPE;

BEGIN
    -- Fetch EVENT_ID from EVENT table
    BEGIN
        SELECT EVENT_ID INTO V_EVENT_ID 
        FROM EVENT 
        WHERE UPPER(EVENT_NAME) = UPPER(PI_EVENT_NAME);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_EVENT_NOT_FOUND;
    END;

    -- Fetch VENUE_ID from VENUE table
    BEGIN
        SELECT VENUE_ID INTO V_VENUE_ID 
        FROM VENUE 
        WHERE UPPER(VENUE_NAME) = UPPER(PI_VENUE_NAME) AND ROWNUM = 1; -- Fetch only one venue if same name exists
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE E_VENUE_NOT_FOUND;
    END;

    -- Validate NULL inputs
    IF PI_EVENT_SCHEDULE_DATE IS NULL OR PI_START_TIME IS NULL OR PI_END_TIME IS NULL THEN
        RAISE E_INVALID_DATE;
    END IF;

    -- Validate that START_TIME is earlier than END_TIME
    IF PI_START_TIME >= PI_END_TIME THEN
        RAISE E_START_END_TIME_ERROR;
    END IF;

    -- Check for conflicting event schedules at the same venue for the same date
    SELECT COUNT(*) INTO v_count 
    FROM EVENT_SCHEDULE
    WHERE VENUE_ID = V_VENUE_ID
      AND EVENT_SCHEDULE_DATE = PI_EVENT_SCHEDULE_DATE
      AND (
          (PI_START_TIME BETWEEN START_TIME AND END_TIME) OR
          (PI_END_TIME BETWEEN START_TIME AND END_TIME) OR
          (PI_START_TIME <= START_TIME AND PI_END_TIME >= END_TIME)
      );

    -- If a conflicting schedule exists, raise an exception
    IF v_count > 0 THEN
        RAISE E_DATE_EXISTS;
    END IF;

    -- Insert new event schedule record
    INSERT INTO EVENT_SCHEDULE (
        EVENTSCHEDULE_ID, EVENT_ID, VENUE_ID, EVENT_SCHEDULE_DATE, START_TIME, END_TIME
    ) VALUES (
        EVENT_SCHEDULE_SEQ.NEXTVAL, V_EVENT_ID, V_VENUE_ID, PI_EVENT_SCHEDULE_DATE, PI_START_TIME, PI_END_TIME
    );

    -- Commit the transaction
    COMMIT;

    -- Debugging message for success (optional)
    DBMS_OUTPUT.PUT_LINE('Event schedule added successfully for Event ID: ' || V_EVENT_ID);

-- Exception Handling
EXCEPTION
    WHEN E_EVENT_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The specified EVENT does not exist.');
    WHEN E_VENUE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: The specified VENUE does not exist.');
    WHEN E_DATE_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('Error: An event schedule already exists for the specified date and time at this venue.');
    WHEN E_INVALID_DATE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Event schedule date, start time, or end time cannot be null.');
    WHEN E_START_END_TIME_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: Start time must be earlier than end time.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Some unexpected error occurred: ' || SQLERRM);
END ADD_EVENT_SCHEDULE;
