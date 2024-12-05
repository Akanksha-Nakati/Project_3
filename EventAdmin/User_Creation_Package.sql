CREATE OR REPLACE PACKAGE EventUserManagementPackage AS
  PROCEDURE CreateUser(p_username IN VARCHAR2);
END EventUserManagementPackage;
/
 
CREATE OR REPLACE PACKAGE BODY EventUserManagementPackage AS
  PROCEDURE CreateUser(p_username IN VARCHAR2) IS
    V_USER_EXISTS NUMBER;
  BEGIN
    -- Check if the user already exists
    SELECT COUNT(*) INTO V_USER_EXISTS FROM ALL_USERS WHERE USERNAME = UPPER(p_username);
 
    IF V_USER_EXISTS = 0 THEN
      -- User creation logic depending on the role
      IF p_username = 'ORGANIZER' THEN
        EXECUTE IMMEDIATE 'CREATE USER ORGANIZER IDENTIFIED BY Secure#987654';
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE ON EVENTADMIN.ORGANIZER TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ORGANIZER_SEQ TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.EVENT TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.EVENT_SCHEDULE TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.VENUE TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ATTENDEE TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.FEEDBACK TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.PAYMENT TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ORGANIZEREVENTINFORMATION_VIEW TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ORGANIZER_EVENT_INSIGHTS_VIEW TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ATTENDEE_PAYMENT_DETAILS_VIEW TO ORGANIZER';
        DBMS_OUTPUT.PUT_LINE('ORGANIZER created successfully');
      ELSIF p_username = 'ATTENDEE' THEN
        EXECUTE IMMEDIATE 'CREATE USER ATTENDEE IDENTIFIED BY "IMAttend12345"';
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE ON EVENTADMIN.ATTENDEE TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.EVENT TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.EVENT_SCHEDULE TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.PAYMENT TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.FEEDBACK TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.REGISTRATION TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.VENUE TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.SCHEDULEDEVENTS_VIEW TO ATTENDEE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ATTENDEEEVENTINFORMATION_VIEW TO ATTENDEE';
        DBMS_OUTPUT.PUT_LINE('ATTENDEE created successfully');
      ELSIF p_username = 'SPONSOR' THEN
        EXECUTE IMMEDIATE 'CREATE USER SPONSOR IDENTIFIED BY "IMSpons#1234"';
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE ON EVENTADMIN.SPONSOR TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.EVENT TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.EVENT_SCHEDULE TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.PAYMENT TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.FEEDBACK TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.REGISTRATION TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.VENUE TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.SCHEDULEDEVENTS_VIEW TO SPONSOR';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.SPONSOREVENTANALYSIS_VIEW TO SPONSOR';
        DBMS_OUTPUT.PUT_LINE('SPONSOR created successfully');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid user type');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('USER: ' || p_username || ' already exists');
    END IF;
 
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
      -- Re-raise the error for external handling
      RAISE;
  END CreateUser;
END EventUserManagementPackage;
/
 
 
BEGIN
  EventUserManagementPackage.CreateUser('ORGANIZER');
END;
/
 
BEGIN
  EventUserManagementPackage.CreateUser('ATTENDEE');
END;
/
BEGIN
  EventUserManagementPackage.CreateUser('SPONSOR');
END;
/
 
--DROP USER ORGANIZER CASCADE;
--DROP USER SPONSOR CASCADE;
--DROP USER ATTENDEE CASCADE;
 
--SELECT COUNT(*) FROM ALL_USERS WHERE USERNAME ='ATTENDEE';