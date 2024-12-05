--EXEC Statements for Update
EXEC UpdateEvent (p_event_id => 1,p_event_name => 'Tech Expo 2024', p_event_desc => 'Annual tech expo' );

EXEC UpdateAttendee(1, 'John', 'Smith', 'john.doe@example.com', '123-456-7890');

EXEC UpdateEventSchedule(1, 1, TO_DATE('2024-07-10', 'YYYY-MM-DD'),
TO_TIMESTAMP('2024-07-10 08:30:00', 'YYYY-MM-DD HH24:MI:SS'),
TO_TIMESTAMP('2024-07-10 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));