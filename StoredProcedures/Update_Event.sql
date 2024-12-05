CREATE OR REPLACE PROCEDURE UpdateEvent (
    p_event_id       IN Event.event_id%TYPE,
    p_event_name     IN Event.event_name%TYPE,
    p_event_desc     IN Event.event_desc%TYPE
) AS
BEGIN
    UPDATE Event
    SET event_name = p_event_name,
        event_desc = p_event_desc
    WHERE event_id = p_event_id;

    -- Check if the update was successful
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No records updated. Event not found with ID: ' || p_event_id);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Optionally, rollback changes on error
        ROLLBACK;
        RAISE;
END UpdateEvent;
/



