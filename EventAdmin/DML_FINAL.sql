TRUNCATE TABLE Event;
TRUNCATE TABLE Organizer;
TRUNCATE TABLE Sponsor;
TRUNCATE TABLE Feedback;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Registration;
TRUNCATE TABLE Attendee;
TRUNCATE TABLE Venue;
TRUNCATE TABLE Event_Schdule;


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
EXEC ADD_ORGANIZATION('Event Planners', 'events@planners.com', '9001234567', 'events@123', 1);
EXEC ADD_ORGANIZATION('Global Organizers', 'contact@globalorg.com', '9007654321', 'global@456', 2);
EXEC ADD_ORGANIZATION('Festive Managers', 'info@festivemanagers.com', '9009876543', 'festive@789', 3);
EXEC ADD_ORGANIZATION('Top Events', 'support@topevents.com', '9001239876', 'top@123', 4);
EXEC ADD_ORGANIZATION('Organize It', 'hello@organizeit.com', '9004567890', 'organize@321', 5);
EXEC ADD_ORGANIZATION('Mega Events', 'service@megaevents.com', '9006543210', 'mega@654', 6);

------Inserting 5 values in Event table---------------------------------------------------------
EXEC ADD_EVENT('Tech Expo 2024', 'Annual tech expo showcasing innovations in technology and electronics.',1,15);
EXEC ADD_EVENT('Medical Conference 2024', 'A comprehensive conference for medical professionals to discuss the latest in healthcare technology.',2,16);
EXEC ADD_EVENT('Green Earth Festival', 'A festival promoting sustainability and green living with workshops, speakers, and exhibitions.',3,17);
EXEC ADD_EVENT('Artists Retreat', 'An exclusive retreat for artists to collaborate, create, and display their work.',3,18);
EXEC ADD_EVENT('Developers Meetup', 'Quarterly meetup for developers to share ideas, network, and collaborate on open source projects.',2,19);

 ------Inserting 5 values in Venue table---------------------------------------------------------
EXEC ADD_VENUE('Convention Center', '123 Expo Blvd, Metropolis', '30',5);
EXEC ADD_VENUE('Grand Hall', '456 Grand Ave, Rivertown', '100',4);
EXEC ADD_VENUE('Downtown Conference Room', '789 Main St, Downtown', '200',7);
EXEC ADD_VENUE('Riverside Pavilion', '321 Riverside Dr, Lakeside', '100',6);
EXEC ADD_VENUE('Skyline Banquet Hall', '654 Highrise Rd, Skytown', '200',5);



 ------Inserting 5 values in Event Schedule table---------------------------------------------------------
EXEC ADD_EVENT_SCHEDULE(5,1,DATE '2024-12-05',TO_TIMESTAMP('2024-12-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2024-12-05 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE(4, 2, DATE '2024-12-06', TO_TIMESTAMP('2024-12-06 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE(6, 3, DATE '2024-12-07', TO_TIMESTAMP('2024-12-07 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE(7, 4, DATE '2024-12-08', TO_TIMESTAMP('2024-12-08 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-08 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));
EXEC ADD_EVENT_SCHEDULE(4, 5, DATE '2024-12-09', TO_TIMESTAMP('2024-12-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-12-09 16:00:00', 'YYYY-MM-DD HH24:MI:SS'));




 ------Inserting 10 values in Registration table---------------------------------------------------------
EXEC ADD_REGISTRATION( 1, 5, TO_TIMESTAMP('2023-11-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 101, 50);
EXEC ADD_REGISTRATION(2, 6, TO_TIMESTAMP('2023-11-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 102, 55);
EXEC ADD_REGISTRATION(3, 4, TO_TIMESTAMP('2023-11-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 103, 60);
EXEC ADD_REGISTRATION(4, 7, TO_TIMESTAMP('2023-11-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 104, 65);
EXEC ADD_REGISTRATION(5, 5, TO_TIMESTAMP('2023-11-14 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 105, 70);
EXEC ADD_REGISTRATION(6, 6, TO_TIMESTAMP('2023-11-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 106, 75);
EXEC ADD_REGISTRATION(7, 4, TO_TIMESTAMP('2023-11-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 107, 80);
EXEC ADD_REGISTRATION(8, 7, TO_TIMESTAMP('2023-11-17 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 108, 85);
EXEC ADD_REGISTRATION(9, 5, TO_TIMESTAMP('2023-11-18 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 109, 90);
EXEC ADD_REGISTRATION(10, 4, TO_TIMESTAMP('2023-11-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 110, 95);



 ------Inserting 10 values in Feedback table---------------------------------------------------------
EXEC ADD_FEEDBACK(5, 1, 5, 'Excellent event, very well organized.');
EXEC ADD_FEEDBACK(6, 2, 4, 'Great experience, though it started late.');
EXEC ADD_FEEDBACK(4, 3, 3, 'Average event, could be improved.');
EXEC ADD_FEEDBACK(7, 4, 5, 'Fantastic! Really enjoyed the presentations.');
EXEC ADD_FEEDBACK(5, 5, 4, 'Very good, but the venue was too crowded.');
EXEC ADD_FEEDBACK(4, 6, 2, 'Not what I expected, quite disorganized.');
EXEC ADD_FEEDBACK(6, 7, 5, 'Perfect event, great speakers and sessions.');
EXEC ADD_FEEDBACK(7, 8, 3, 'It was okay, nothing special.');
EXEC ADD_FEEDBACK(5, 9, 4, 'Good event, but needed better food options.');
EXEC ADD_FEEDBACK(4, 10, 1, 'Poorly organized, I left early.');

 ------Inserting 10 values in Payment table---------------------------------------------------------
EXEC ADD_PAYMENT(1,50, 'Credit Card', TO_TIMESTAMP('2023-11-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
EXEC ADD_PAYMENT(2,55, 'Debit Card', TO_TIMESTAMP('2023-11-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');
EXEC ADD_PAYMENT(3,60, 'PayPal', TO_TIMESTAMP('2023-11-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
EXEC ADD_PAYMENT(4,65, 'Credit Card', TO_TIMESTAMP('2023-11-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Failed');
EXEC ADD_PAYMENT(5,70,'Wire Transfer', TO_TIMESTAMP('2023-11-14 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');
EXEC ADD_PAYMENT(6,75, 'Debit Card', TO_TIMESTAMP('2023-11-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
EXEC ADD_PAYMENT(7,80,'PayPal', TO_TIMESTAMP('2023-11-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
EXEC ADD_PAYMENT(8,85, 'Credit Card', TO_TIMESTAMP('2023-11-17 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Failed');
EXEC ADD_PAYMENT(9,90,'Debit Card', TO_TIMESTAMP('2023-11-18 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');
EXEC ADD_PAYMENT(10,95,'Wire Transfer', TO_TIMESTAMP('2023-11-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');


select * from Event;
select * from Organizer;
select * from Sponsor;
select * from Feedback;
select * from Payment;
select * from Registration;
select * from Attendee;
select * from Venue;
select * from Event_Schdule;






