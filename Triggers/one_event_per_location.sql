create or replace TRIGGER one_event_per_location
BEFORE INSERT OR UPDATE ON EVENT_SCHEDULE
FOR EACH ROW
DECLARE
    v_count INTEGER;
BEGIN
    -- Count the number of events in the same venue on the same date
    SELECT COUNT(*)
    INTO v_count
    FROM EVENT_SCHEDULE
    WHERE EVENT_SCHEDULE_DATE = :NEW.EVENT_SCHEDULE_DATE
      AND VENUE_ID = :NEW.VENUE_ID
      AND EVENTSCHEDULE_ID != :NEW.EVENTSCHEDULE_ID; -- Exclude the current record being updated/inserted

    -- Raise an error if there's already an event scheduled at the same venue on the same date
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Only one event is allowed at a venue on a particular day.');
    END IF;
END;
