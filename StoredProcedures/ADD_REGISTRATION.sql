CREATE OR REPLACE PROCEDURE ADD_REGISTRATION(
    PI_ATTENDEE_EMAIL VARCHAR2,
    PI_EVENT_NAME VARCHAR2,
    PI_REGISTRATION_DATE IN DATE,
    PI_TICKETS_REQUESTED IN NUMBER,
    PI_TICKET_PRICE IN NUMBER,
    PI_EVENT_SCHEDULE_DATE IN DATE
) AS
    V_EVENT_ID EVENT.EVENT_ID%TYPE;
    V_ATTENDEE_ID ATTENDEE.ATTENDEE_ID%TYPE;
    V_SCHEDULED_COUNT INT;
    V_EXISTING_BOOKINGS INT;
    V_VENUE_CAPACITY INT;
    V_BOOKED_SEATS INT;
    V_AVAILABLE_SEATS INT;
    V_EVENT_START_TIME EVENT_SCHEDULE.start_time%TYPE;
    V_EVENT_END_TIME EVENT_SCHEDULE.end_time%TYPE;
    V_EVENT_TICKET_PRICE EVENT.ticket_price%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Procedure started.');

    -- Validate inputs
    IF PI_ATTENDEE_EMAIL IS NULL OR PI_ATTENDEE_EMAIL = '' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Attendee email is invalid.');
    END IF;

    IF PI_EVENT_NAME IS NULL OR PI_EVENT_NAME = '' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Event name is invalid.');
    END IF;

    -- Check tickets requested
    IF PI_TICKETS_REQUESTED > 1 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Only one ticket can be booked per attendee.');
    END IF;

    -- Fetch EVENT_ID and ticket price from the Event table
    BEGIN
        SELECT EVENT_ID, ticket_price
        INTO V_EVENT_ID, V_EVENT_TICKET_PRICE
        FROM EVENT
        WHERE UPPER(EVENT_NAME) = UPPER(PI_EVENT_NAME)
        AND ROWNUM = 1;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20009, 'Event not found (Please check the associated ticket price.)');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20099, 'Multiple events found for the provided event name. Ensure the event name is unique.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20099, 'Unexpected error while fetching event details: ' || SQLERRM);
    END;

    -- Validate ticket price matches the event's price
    IF PI_TICKET_PRICE <> V_EVENT_TICKET_PRICE THEN
        RAISE_APPLICATION_ERROR(-20008, 'Ticket price does not match the event''s ticket price.');
    END IF;

    -- Fetch ATTENDEE_ID
    BEGIN
        SELECT ATTENDEE_ID
        INTO V_ATTENDEE_ID
        FROM Attendee
        WHERE LOWER(email_id) = LOWER(PI_ATTENDEE_EMAIL)
        AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 'Attendee not found.');
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20099, 'Multiple attendees found with the same email. Ensure email is unique.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20099, 'Unexpected error while fetching attendee details: ' || SQLERRM);
    END;

    -- Verify event is scheduled for the given date
    SELECT COUNT(*)
    INTO V_SCHEDULED_COUNT
    FROM Event_Schedule
    WHERE event_id = V_EVENT_ID AND event_schedule_date = PI_EVENT_SCHEDULE_DATE;

    IF V_SCHEDULED_COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Event is not scheduled on the provided date.');
    END IF;

    -- Fetch event start and end times
    SELECT start_time, end_time
    INTO V_EVENT_START_TIME, V_EVENT_END_TIME
    FROM Event_Schedule
    WHERE event_id = V_EVENT_ID AND event_schedule_date = PI_EVENT_SCHEDULE_DATE;

    -- Check that event end time is after event start time
    IF V_EVENT_END_TIME <= V_EVENT_START_TIME THEN
        RAISE_APPLICATION_ERROR(-20006, 'Event end time must be after event start time.');
    END IF;

    -- Check that registration time is before event start time
    IF PI_REGISTRATION_DATE >= V_EVENT_START_TIME THEN
        RAISE_APPLICATION_ERROR(-20007, 'Registration time must be before the event start time.');
    END IF;

    -- Check if the attendee already booked a ticket for this event on this date
    SELECT COUNT(*)
    INTO V_EXISTING_BOOKINGS
    FROM Registration R
    JOIN Event_Schedule ES ON R.event_id = ES.event_id
    WHERE R.attendee_id = V_ATTENDEE_ID
      AND R.event_id = V_EVENT_ID
      AND ES.event_schedule_date = PI_EVENT_SCHEDULE_DATE;

    IF V_EXISTING_BOOKINGS > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Attendee has already booked a ticket for this event on the specified date.');
    END IF;

    -- Insert registration
    INSERT INTO Registration (
        registration_id,
        attendee_id,
        event_id,
        registration_date,
        ticketsBooked,
        ticket_Price
    ) VALUES (
        Registration_SEQ.NEXTVAL,
        V_ATTENDEE_ID,
        V_EVENT_ID,
        PI_REGISTRATION_DATE,
        PI_TICKETS_REQUESTED,
        PI_TICKET_PRICE
    );

    -- Fetch venue capacity from the Venue table
    SELECT venue_capacity INTO V_VENUE_CAPACITY
    FROM Venue
    WHERE event_id = V_EVENT_ID;

    -- Calculate booked seats
    SELECT SUM(ticketsBooked)
    INTO V_BOOKED_SEATS
    FROM Registration R
    JOIN Event_Schedule ES ON R.event_id = ES.event_id
    WHERE ES.event_id = V_EVENT_ID AND ES.event_schedule_date = PI_EVENT_SCHEDULE_DATE;

    -- Calculate available seats
    V_AVAILABLE_SEATS := V_VENUE_CAPACITY - NVL(V_BOOKED_SEATS, 0);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Registration added successfully.');
    DBMS_OUTPUT.PUT_LINE('Available seats now: ' || V_AVAILABLE_SEATS);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END ADD_REGISTRATION;
/
