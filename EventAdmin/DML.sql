TRUNCATE TABLE Event;
TRUNCATE TABLE Organizer;
TRUNCATE TABLE Sponsor;
TRUNCATE TABLE Feedback;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Registration;
TRUNCATE TABLE Attendee;
TRUNCATE TABLE Venue;
TRUNCATE TABLE Event_Schedule;


-----Inserting 15 values in Attendee table---------------------------------------------------------

EXEC ADD_ATTENDEE('John', 'Doe', 'john.doe@example.com', 'johnjohn', '1234567890');
EXEC ADD_ATTENDEE('Jane', 'Smith', 'jane.smith@example.com','janejane', '1234567891');
EXEC ADD_ATTENDEE('Alice', 'Johnson', 'alice.johnson@example.com','alice@123', '1234567892');
EXEC ADD_ATTENDEE('Bob', 'Williams', 'bob.williams@example.com','bob12345', '1234567893');
EXEC ADD_ATTENDEE('Carol', 'Brown', 'carol.brown@example.com', 'carol567', '1234567894');
EXEC ADD_ATTENDEE('David', 'Jones', 'david.jones@example.com', 'david234', '1234567895');
EXEC ADD_ATTENDEE('Eve', 'Garcia', 'eve.garcia@example.com','eve45678', '1234567896');
EXEC ADD_ATTENDEE('Frank', 'Miller', 'frank.miller@example.com','frank123', '1234567897');
EXEC ADD_ATTENDEE('Grace', 'Davis', 'grace.davis@example.com', 'grace890','1234567898');
EXEC ADD_ATTENDEE('Henry', 'Rodriguez', 'henry.rodriguez@example.com','henry765', '1234567899');
EXEC ADD_ATTENDEE('Isla', 'Martinez', 'isla.martinez@example.com', 'isla@123', '1234567800');
EXEC ADD_ATTENDEE('Jake', 'Hernandez', 'jake.hernandez@example.com', 'jake@897', '1234567801');
EXEC ADD_ATTENDEE('Laura', 'Lopez', 'laura.lopez@example.com', 'laura098','1234567802');
EXEC ADD_ATTENDEE('Michael', 'Gonzalez', 'michael.gonzalez@example.com','michael78', '1234567803');
EXEC ADD_ATTENDEE('Nancy', 'Wilson', 'nancy.wilson@example.com','nancy8765', '1234567804');

 ------Inserting 3 values in Sponsor table---------------------------------------------------------
EXEC ADD_SPONSOR ('Global Tech', 'info@globaltech.com', '8001234567','global@12',5000);
EXEC ADD_SPONSOR('Innovate Solutions', 'contact@innovatesol.com', '8001934568','innova12',5000);
EXEC ADD_SPONSOR('Eco Ventures', 'support@ecoven.com', '8001564569','eco@1234',1000);
EXEC ADD_SPONSOR('Northeastern GSG', 'neu@innovatesol.com', '8101234568','inn@4567',2000);
EXEC ADD_SPONSOR('Marino CO ', 'marino@ecoven.com', '9001234569','Mar@1236',4000);

------Inserting 4 values in Organization table---------------------------------------------------------
EXEC ADD_ORGANIZER('Event Planners', 'events@planners.com', '9001234567', 'events@123');
EXEC ADD_ORGANIZER('Global Organizers', 'contact@globalorg.com', '9007654321', 'global@456');
EXEC ADD_ORGANIZER('Festive Managers', 'info@festivemanagers.com', '9009876543', 'festive@789');
EXEC ADD_ORGANIZER('Top Events', 'support@topevents.com', '9001239876', 'top@123');
EXEC ADD_ORGANIZER('Organize It', 'hello@organizeit.com', '9004567890', 'organize@321');
EXEC ADD_ORGANIZER('Mega Events', 'service@megaevents.com', '9006543210', 'mega@654');
EXEC ADD_ORGANIZER('Mega Events', 'ser@megaevents.com', '9076542389', 'megaaa@654');
EXEC ADD_ORGANIZER('Organize It', 'he@organizeit.com', '9034126754', 'organize@456');


------Inserting 5 values in Event table---------------------------------------------------------
EXEC ADD_EVENT('Tech Expo 2024', 'Annual tech expo showcasing innovations in technology and electronics.','events@planners.com','Global Tech',100);
EXEC ADD_EVENT('Medical Conference 2024', 'A comprehensive conference for medical professionals to discuss the latest in healthcare technology.','service@megaevents.com','Innovate Solutions','200');
EXEC ADD_EVENT('Green Earth Festival', 'A festival promoting sustainability and green living with workshops, speakers, and exhibitions.','info@festivemanagers.com','Eco Ventures',300);
EXEC ADD_EVENT('Artists Retreat', 'An exclusive retreat for artists to collaborate, create, and display their work.','contact@globalorg.com','Northeastern GSG',350);
EXEC ADD_EVENT('Developers Meetup', 'Quarterly meetup for developers to share ideas, network, and collaborate on open source projects.','support@topevents.com','Eco Ventures',200);


 ------Inserting 5 values in Venue table---------------------------------------------------------
EXEC ADD_VENUE('Convention Center', '123 Expo Blvd, Metropolis', '5','Tech Expo 2024');
EXEC ADD_VENUE('Grand Hall', '456 Grand Ave, Rivertown', '5','Medical Conference 2024');
EXEC ADD_VENUE('Downtown Conference Room', '789 Main St, Downtown', '10','Green Earth Festival');
EXEC ADD_VENUE('Riverside Pavilion', '321 Riverside Dr, Lakeside', '10','Artists Retreat');
EXEC ADD_VENUE('Skyline Banquet Hall', '654 Highrise Rd, Skytown', '10','Developers Meetup');


 ------Inserting 5 values in Event Schedule table---------------------------------------------------------
EXEC ADD_EVENT_SCHEDULE('Tech Expo 2024','Convention Center',DATE '2024-12-05',TO_TIMESTAMP('2024-12-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2024-12-05 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE('Medical Conference 2024', 'Grand Hall', DATE '2024-12-06', TO_TIMESTAMP('2024-12-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE('Green Earth Festival', 'Downtown Conference Room', DATE '2024-12-07', TO_TIMESTAMP('2024-12-07 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE('Artists Retreat', 'Riverside Pavilion', DATE '2024-12-08', TO_TIMESTAMP('2024-12-08 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-08 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE('Developers Meetup', 'Skyline Banquet Hall', DATE '2024-12-09', TO_TIMESTAMP('2024-12-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-09 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE('Tech Expo 2024','Convention Center',DATE '2024-12-06',TO_TIMESTAMP('2024-12-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2024-12-06 20:00:00', 'YYYY-MM-DD HH24:MI:SS'));


 ------Inserting 10 values in Registration table---------------------------------------------------------
 
EXEC ADD_REGISTRATION('john.doe@example.com', 'Tech Expo 2024', TO_TIMESTAMP('2024-11-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 100, DATE '2024-12-05');
EXEC ADD_REGISTRATION('jane.smith@example.com', 'Medical Conference 2024', TO_TIMESTAMP('2024-11-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 200,DATE '2024-12-06');
EXEC ADD_REGISTRATION('alice.johnson@example.com', 'Green Earth Festival', TO_TIMESTAMP('2024-11-15 14:30:00', 'YYYY-MM-DD HH24:MI:SS'),1, 300,DATE '2024-12-07');
EXEC ADD_REGISTRATION('bob.williams@example.com', 'Artists Retreat', TO_TIMESTAMP('2024-11-17 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 350,DATE '2024-12-08');
EXEC ADD_REGISTRATION('carol.brown@example.com', 'Developers Meetup', TO_TIMESTAMP('2024-11-20 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 200,DATE '2024-12-09');
EXEC ADD_REGISTRATION('david.jones@example.com', 'Tech Expo 2024', TO_TIMESTAMP('2024-11-10 09:30:00', 'YYYY-MM-DD HH24:MI:SS'),1, 100,DATE '2024-12-05');
EXEC ADD_REGISTRATION('eve.garcia@example.com', 'Medical Conference 2024', TO_TIMESTAMP('2024-11-12 10:15:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 200,DATE '2024-12-06');
EXEC ADD_REGISTRATION('frank.miller@example.com', 'Green Earth Festival', TO_TIMESTAMP('2024-11-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'),1, 300,DATE '2024-12-07');
EXEC ADD_REGISTRATION('grace.davis@example.com', 'Artists Retreat', TO_TIMESTAMP('2024-11-17 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 350,DATE '2024-12-08');
EXEC ADD_REGISTRATION('henry.rodriguez@example.com', 'Developers Meetup', TO_TIMESTAMP('2024-11-20 16:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 200,DATE '2024-12-09');
EXEC ADD_REGISTRATION('isla.martinez@example.com', 'Tech Expo 2024', TO_TIMESTAMP('2024-11-10 09:45:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 100,DATE '2024-12-05');
EXEC ADD_REGISTRATION('jake.hernandez@example.com', 'Medical Conference 2024', TO_TIMESTAMP('2024-11-12 10:45:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 200,DATE '2024-12-06');
EXEC ADD_REGISTRATION('laura.lopez@example.com', 'Green Earth Festival', TO_TIMESTAMP('2024-11-15 15:30:00', 'YYYY-MM-DD HH24:MI:SS'),1, 300,DATE '2024-12-07');
EXEC ADD_REGISTRATION('michael.gonzalez@example.com', 'Artists Retreat', TO_TIMESTAMP('2024-11-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 350,DATE '2024-12-08');
EXEC ADD_REGISTRATION('nancy.wilson@example.com', 'Developers Meetup', TO_TIMESTAMP('2024-11-20 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 200,DATE '2024-12-09');


 ------Inserting 10 values in Feedback table---------------------------------------------------------
EXEC ADD_FEEDBACK('Tech Expo 2024', 'john.doe@example.com', 3, 'Excellent event, very well organized.', 'Global Tech');
EXEC ADD_FEEDBACK('Medical Conference 2024', 'jane.smith@example.com', 5, 'Amazing experience, very insightful.', 'Global Tech');
EXEC ADD_FEEDBACK('Green Earth Festival', 'alice.johnson@example.com', 4, 'Great sessions, but too crowded.', 'Innovate Solutions');
EXEC ADD_FEEDBACK('Artists Retreat', 'bob.williams@example.com', 5, 'Loved the green initiatives and workshops.', 'Eco Ventures');
EXEC ADD_FEEDBACK('Developers Meetup', 'carol.brown@example.com', 4, 'A creative space for artists, well organized.', 'Northeastern GSG');
EXEC ADD_FEEDBACK('Tech Expo 202', 'david.jones@example.com', 5, 'Perfect meetup for networking and sharing ideas.', 'Global Tech');
EXEC ADD_FEEDBACK('Medical Conference 2024', 'eve.garcia@example.com', 3, 'Interesting topics but felt too rushed.', 'Global Tech');
EXEC ADD_FEEDBACK('Green Earth Festival', 'frank.miller@example.com', 4, 'Good displays, but more tech innovations expected.', 'Global Tech');
EXEC ADD_FEEDBACK('Artists Retreat', 'grace.davis@example.com', 5, 'Highly informative sessions, excellent organization.', 'Innovate Solutions');
EXEC ADD_FEEDBACK('Developers Meetup', 'henry.rodriguez@example.com', 4, 'Enjoyable event with practical insights on sustainability.', 'Eco Ventures');
EXEC ADD_FEEDBACK('Tech Expo 2024', 'isla.martinez@example.com', 5, 'A peaceful retreat for connecting with fellow artists.', 'Northeastern GSG');
EXEC ADD_FEEDBACK('Medical Conference 2024', 'jake.hernandez@example.com', 5, 'Loved the open-source collaboration discussions.', 'Global Tech');
EXEC ADD_FEEDBACK('Green Earth Festival', 'laura.lopez@example.com', 4, 'Great event, but parking was a challenge.', 'Global Tech');
EXEC ADD_FEEDBACK('Artists Retreat', 'michael.gonzalez@example.com', 5, 'Exceptional conference with great networking opportunities.', 'Innovate Solutions');
EXEC ADD_FEEDBACK('Developers Meetup', 'nancy.wilson@example.com', 3, 'Good ideas, but execution could be improved.', 'Eco Ventures');

EXEC ADD_FEEDBACK('Green Earth Festival', 'eve.garcia@example.com', 4, 'Good ideas, but execution could be improved.', 'Eco Ventures');




 ------Inserting 10 values in Payment table---------------------------------------------------------
EXEC ADD_PAYMENT('john.doe@example.com', 100, 'Credit Card', 'Completed');
EXEC ADD_PAYMENT('jane.smith@example.com', 200, 'Debit Card', 'Pending');
EXEC ADD_PAYMENT('alice.johnson@example.com', 300, 'PayPal', 'Completed');
EXEC ADD_PAYMENT('bob.williams@example.com',350, 'Credit Card', 'Failed');
EXEC ADD_PAYMENT('carol.brown@example.com',200,'Wire Transfer', 'Pending');
EXEC ADD_PAYMENT('david.jones@example.com',100, 'Debit Card', 'Completed');
EXEC ADD_PAYMENT('eve.garcia@example.com',200,'PayPal', 'Completed');
EXEC ADD_PAYMENT('frank.miller@example.com',300, 'Credit Card', 'Failed');
EXEC ADD_PAYMENT('grace.davis@example.com',350,'Debit Card', 'Completed');
EXEC ADD_PAYMENT('michael.gonzalez@example.com',350,'Wire Transfer', 'Pending');


-----------------------------------------------------------------------------------------------------------------------------------------------


select * from Event;
select * from Organizer;
select * from Sponsor;
select * from Feedback;
select * from Registration;
select * from Attendee;
select * from Venue;
select * from Event_Schedule;
select * from Payment;



