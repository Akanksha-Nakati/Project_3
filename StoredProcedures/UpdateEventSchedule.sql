CREATE OR REPLACE PROCEDURE UpdateEventSchedule (
    p_eventschedule_id IN Event_Schedule.eventschedule_id%TYPE,
    p_event_id         IN Event_Schedule.event_id%TYPE,
    p_event_schedule_date IN Event_Schedule.event_schedule_date%TYPE,
    p_start_time        IN Event_Schedule.start_time%TYPE,
    p_end_time          IN Event_Schedule.end_time%TYPE
) AS
BEGIN
    UPDATE Event_Schedule
    SET event_schedule_date = p_event_schedule_date,
        start_time = p_start_time,
        end_time = p_end_time
    WHERE eventschedule_id = p_eventschedule_id
      AND event_id = p_event_id;

    -- Check if the update was successful
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'No records updated. No event schedule found with ID: ' || p_eventschedule_id);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END UpdateEventSchedule;
/
