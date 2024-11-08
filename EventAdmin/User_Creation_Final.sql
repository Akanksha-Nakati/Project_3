SET SERVEROUTPUT ON;

DECLARE
    V_USER VARCHAR(100);
BEGIN
    -- Check if the ORGANIZER user exists
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME = 'ORGANIZER';
    DBMS_OUTPUT.PUT_LINE('USER: ORGANIZER already exists');
    
    -- Grant privileges if the user exists
    BEGIN
        EXECUTE IMMEDIATE 'GRANT CONNECT TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.OrganizerEventInformation_View TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.Organizer_Event_Insights_View TO ORGANIZER';
        EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.Attendee_Payment_Details_View TO ORGANIZER';
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Grant error: ' || SQLERRM);
    END;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Create the user and grant privileges if the user does not exist
        BEGIN
            EXECUTE IMMEDIATE 'CREATE USER ORGANIZER IDENTIFIED BY IMORG#123456789';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO ORGANIZER';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.OrganizerEventInformation_View TO ORGANIZER';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.Organizer_Event_Insights_View TO ORGANIZER';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.Attendee_Payment_Details_View TO ORGANIZER';
            DBMS_OUTPUT.PUT_LINE('ORGANIZER created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Creation error: ' || SQLERRM);
        END;
END;
/

-- This user is responsible for analyzing sales data. They should have access to the V_Order, V_ProductSales, and V_CustomerOrderFrequency views.

DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='ATTENDEE';
    DBMS_OUTPUT.PUT_LINE('USER: ATTENDEE already exists');
    
    EXECUTE IMMEDIATE 'GRANT CONNECT TO ATTENDEE';
    EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ScheduledEvents_View TO ATTENDEE';
    EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.AttendeeEventInformation_View TO ATTENDEE';
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            -- Use a more complex password that may meet the policy requirements
            EXECUTE IMMEDIATE 'CREATE USER ATTENDEE IDENTIFIED BY IMAttend12345';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO ATTENDEE';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ScheduledEvents_View TO ATTENDEE';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.AttendeeEventInformation_View TO ATTENDEE';
            DBMS_OUTPUT.PUT_LINE('ATTENDEE created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        END;
END;
/


-- This user is responsible for managing customer relationships and handling customer feedback. They should have access to the V_CustomerReview and V_Order views.
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='SPONSOR';
    DBMS_OUTPUT.PUT_LINE('USER: SPONSOR already exists');
    EXECUTE IMMEDIATE 'GRANT CONNECT TO SPONSOR';
    EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ScheduledEvents_View TO SPONSOR';
    EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.SponsorEventAnalysis_View TO SPONSOR';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE USER SPONSOR IDENTIFIED BY IMSpons#1234';
            EXECUTE IMMEDIATE 'GRANT CONNECT TO SPONSOR';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.ScheduledEvents_View TO SPONSOR';
            EXECUTE IMMEDIATE 'GRANT SELECT ON EVENTADMIN.SponsorEventAnalysis_View TO SPONSOR';
            DBMS_OUTPUT.PUT_LINE('SPONSOR created successfully');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        END;
END;
/
 