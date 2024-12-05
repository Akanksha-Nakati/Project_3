CREATE OR REPLACE PROCEDURE UpdateAttendee (
    p_attendee_id    IN Attendee.attendee_id%TYPE,
    p_first_name     IN Attendee.first_name%TYPE,
    p_last_name      IN Attendee.last_name%TYPE,
    p_email_id       IN Attendee.email_id%TYPE,   -- Using email_id instead of email
    p_phone_number   IN Attendee.phone_number%TYPE
) AS
BEGIN
    UPDATE Attendee
    SET first_name = p_first_name,
        last_name = p_last_name,
        email_id = p_email_id,     -- Correct column name is email_id
        phone_number = p_phone_number
    WHERE attendee_id = p_attendee_id;

    -- Include error handling and ensure the changes were applied
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No records updated. Attendee not found with ID: ' || p_attendee_id);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Optionally, rollback changes on error
        ROLLBACK;
        RAISE;
END UpdateAttendee;
/
