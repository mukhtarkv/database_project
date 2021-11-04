-- CS4400: Introduction to Database Systems (Fall 2021)

-- Team 73
-- Michael Coppeta (mcoppeta3)
-- Mukhtar Kussaiynbekov (mkussaiy3)
-- Jingrui Zhang (jzhang3134)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

-- ------------------------------------------------------
-- CREATE TABLE STATEMENTS AND INSERT STATEMENTS BELOW
-- ------------------------------------------------------
DROP DATABASE IF EXISTS travel_reservation_service;
CREATE DATABASE IF NOT EXISTS travel_reservation_service;
USE travel_reservation_service;

DROP TABLE IF EXISTS account;
CREATE TABLE account (
  email varchar(50),
  fname varchar(100) NOT NULL,
  lname varchar(100) NOT NULL,
  password varchar(50) NOT NULL,
  
  PRIMARY KEY (email)
) ENGINE=InnoDB;

insert into account values
('mmoss1@travelagency.com','Mark','Moss','password1'),
('asmith@travelagency.com','Aviva','Smith','password2'),
('mscott22@gmail.com','Michael','Scott','password3'),
('arthurread@gmail.com','Arthur','Read','password4'),
('jwayne@gmail.com','John','Wayne','password5'),
('gburdell3@gmail.com','George','Burdell','password6'),
('mj23@gmail.com','Michael','Jordan','password7'),
('lebron6@gmail.com','Lebron','James','password8'),
('msmith5@gmail.com','Michael','Smith','password9'),
('ellie2@gmail.com','Ellie','Johnson','password10'),
('scooper3@gmail.com','Sheldon','Cooper','password11'),
('mgeller5@gmail.com','Monica','Geller','password12'),
('cbing10@gmail.com','Chandler','Bing','password13'),
('hwmit@gmail.com','Howard','Wolowitz','password14'),
('swilson@gmail.com','Samantha','Wilson','password16'),
('aray@tiktok.com','Addison','Ray','password17'),
('cdemilio@tiktok.com','Charlie','Demilio','password18'),
('bshelton@gmail.com','Blake','Shelton','password19'),
('lbryan@gmail.com','Luke','Bryan','password20'),
('tswift@gmail.com','Taylor','Swift','password21'),
('jseinfeld@gmail.com','Jerry','Seinfeld','password22'),
('maddiesmith@gmail.com','Madison','Smith','password23'),
('johnthomas@gmail.com','John','Thomas','password24'),
('boblee15@gmail.com','Bob','Lee','password25');


DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
	email varchar(50),
    
    primary key (email),
    constraint admin_fk_1 foreign key (email) references account (email)
) ENGINE=InnoDB;
insert into admin values
('mmoss1@travelagency.com'),
('asmith@travelagency.com');


DROP TABLE IF EXISTS client;
CREATE TABLE client (
	email varchar(50),
    phone_number char(12) NOT NULL UNIQUE,
    
    primary key (email),
    constraint client_fk_2 foreign key (email) references account (email)
) ENGINE=InnoDB;
insert into client values
('mscott22@gmail.com','555-123-4567'),
('arthurread@gmail.com','555-234-5678'),
('jwayne@gmail.com','555-345-6789'),
('gburdell3@gmail.com','555-456-7890'),
('mj23@gmail.com','555-567-8901'),
('lebron6@gmail.com','555-678-9012'),
('msmith5@gmail.com','555-789-0123'),
('ellie2@gmail.com','555-890-1234'),
('scooper3@gmail.com','678-123-4567'),
('mgeller5@gmail.com','678-234-5678'),
('cbing10@gmail.com','678-345-6789'),
('hwmit@gmail.com','678-456-7890'),
('swilson@gmail.com','770-123-4567'),
('aray@tiktok.com','770-234-5678'),
('cdemilio@tiktok.com','770-345-6789'),
('bshelton@gmail.com','770-456-7890'),
('lbryan@gmail.com','770-567-8901'),
('tswift@gmail.com','770-678-9012'),
('jseinfeld@gmail.com','770-789-0123'),
('maddiesmith@gmail.com','770-890-1234'),
('johnthomas@gmail.com','404-770-5555'),
('boblee15@gmail.com','404-678-5555');


DROP TABLE IF EXISTS owner;
CREATE TABLE owner (
	email varchar(50),
    
    primary key (email),
    constraint owner_fk_3 foreign key (email) references client (email)
) ENGINE=InnoDB;
insert into owner values
('mscott22@gmail.com'),
('arthurread@gmail.com'),
('jwayne@gmail.com'),
('gburdell3@gmail.com'),
('mj23@gmail.com'),
('lebron6@gmail.com'),
('msmith5@gmail.com'),
('ellie2@gmail.com'),
('scooper3@gmail.com'),
('mgeller5@gmail.com'),
('cbing10@gmail.com'),
('hwmit@gmail.com');


DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	email varchar(50),
    credit_card_number char(19) NOT NULL UNIQUE,
    expiration_date date NOT NULL,
    cvv decimal(3,0) NOT NULL,
    current_location varchar(50) NOT NULL DEFAULT "",
    
    primary key (email),
    constraint customer_fk_4 foreign key (email) references client (email)
) ENGINE=InnoDB;
insert into customer values
('scooper3@gmail.com','6518 5559 7446 1663','2024-2-01',551,''),
('mgeller5@gmail.com','2328 5670 4310 1965','2024-3-01',644,''),
('cbing10@gmail.com','8387 9523 9827 9291','2023-2-01',201,''),
('hwmit@gmail.com','6558 8596 9852 5299','2023-4-01',102,''),
('swilson@gmail.com','9383 3212 4198 1836','2022-8-01',455,''),
('aray@tiktok.com','3110 2669 7949 5605','2022-8-01',744,''),
('cdemilio@tiktok.com','2272 3555 4078 4744','2025-02-01',606,''),
('bshelton@gmail.com','9276 7639 7883 4273','2023-09-01',862,''),
('lbryan@gmail.com','4652 3726 8864 3798','2023-05-01',258,''),
('tswift@gmail.com','5478 8420 4436 7471','2024-12-01',857,''),
('jseinfeld@gmail.com','3616 8977 1296 3372','2022-06-01',295,''),
('maddiesmith@gmail.com','9954 5698 6355 6952','2022-07-01',794,''),
('johnthomas@gmail.com','7580 3274 3724 5356','2025-10-01',269,''),
('boblee15@gmail.com','7907 3513 7161 4248','2025-11-01',858,'');


DROP TABLE IF EXISTS owner_rates_customer;
CREATE TABLE owner_rates_customer (
	owner_email varchar(50),
    customer_email varchar(50),
    score decimal(1,0) NOT NULL,
    
    primary key (owner_email, customer_email),
    constraint rates_fk_5 foreign key (owner_email) references owner (email),
    constraint rates_fk_6 foreign key (customer_email) references customer (email)
) ENGINE=InnoDB;
insert into owner_rates_customer values
('gburdell3@gmail.com','swilson@gmail.com',5),
('cbing10@gmail.com','aray@tiktok.com',5),
('mgeller5@gmail.com','bshelton@gmail.com',3),
('arthurread@gmail.com','lbryan@gmail.com',4),
('arthurread@gmail.com','tswift@gmail.com',4),
('lebron6@gmail.com','jseinfeld@gmail.com',1),
('hwmit@gmail.com','maddiesmith@gmail.com',2);


DROP TABLE IF EXISTS customer_rates_owner;
CREATE TABLE customer_rates_owner (
	owner_email varchar(50),
    customer_email varchar(50),
    score decimal(1,0) NOT NULL,
    
    primary key (owner_email, customer_email),
    constraint rates_fk_7 foreign key (owner_email) references owner (email),
    constraint rates_fk_8 foreign key (customer_email) references customer (email)
) ENGINE=InnoDB;
insert into customer_rates_owner values
('gburdell3@gmail.com','swilson@gmail.com',5),
('cbing10@gmail.com','aray@tiktok.com',5),
('mgeller5@gmail.com','bshelton@gmail.com',4),
('arthurread@gmail.com','lbryan@gmail.com',4),
('arthurread@gmail.com','tswift@gmail.com',3),
('lebron6@gmail.com','jseinfeld@gmail.com',2),
('hwmit@gmail.com','maddiesmith@gmail.com',5);


DROP TABLE IF EXISTS airline;
CREATE TABLE airline (
	name varchar(50),
    rating decimal(2,1) NOT NULL,
    
    primary key (name)
) ENGINE=InnoDB;
insert into airline values
('Delta Airlines',4.7),
('Southwest Airlines',4.4),
('American Airlines',4.6),
('United Airlines',4.2),
('JetBlue Airways',3.6),
('Spirit Airlines',3.3),
('WestJet',3.9),
('Interjet',3.7);


DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
	airport_id char(3),
    name varchar(50) NOT NULL UNIQUE,
    time_zone char(3) NOT NULL,
    street varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state char(2) NOT NULL,
    zip char(5) NOT NULL,
    
    primary key (airport_id),
    unique (street, city, state, zip)
) ENGINE=InnoDB;
insert into airport values
('ATL','Atlanta Hartsfield Jackson Airport','EST','6000 N Terminal Pkwy','Atlanta','GA',30320),
('JFK','John F Kennedy International Airport','EST','455 Airport Ave','Queens','NY',11430),
('LGA','Laguardia Airport','EST','790 Airport St','Queens','NY',11371),
('LAX','Lost Angeles International Airport','PST','1 World Way','Los Angeles','CA',90045),
('SJC','Norman Y. Mineta San Jose International Airport','PST','1702 Airport Blvd','San Jose','CA',95110),
('ORD','O''Hare International Airport','CST','10000 W O''Hare Ave','Chicago','IL',60666),
('MIA','Miami International Airport','EST','2100 NW 42nd Ave','Miami','FL',33126),
('DFW','Dallas International Airport','CST','2400 Aviation DR','Dallas','TX',75261);


DROP TABLE IF EXISTS attractions;
CREATE TABLE attractions (
	airport_id char(3),
    attraction_name varchar(50),
    
    primary key (airport_id, attraction_name),
    constraint attractions_fk_9 foreign key (airport_id) references airport (airport_id)
) ENGINE=InnoDB;
insert into attractions values
('ATL','The Coke Factory'),
('ATL','The Georgia Aquarium'),
('JFK','The Statue of Liberty'),
('JFK','The Empire State Building'),
('LGA','The Statue of Liberty'),
('LGA','The Empire State Building'),
('LAX','Lost Angeles Lakers Stadium'),
('LAX','Los Angeles Kings Stadium'),
('SJC','Winchester Mystery House'),
('SJC','San Jose Earthquakes Soccer Team'),
('ORD','Chicago Blackhawks Stadium'),
('ORD','Chicago Bulls Stadium'),
('MIA','Crandon Park Beach'),
('MIA','Miami Heat Basketball Stadium'),
('DFW','Texas Longhorns Stadium'),
('DFW','The Original Texas Roadhouse');


DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
	airline_name varchar(50),
    flight_number char(5),
    departure_time char(8) NOT NULL,
    arrival_time char(8) NOT NULL,
    cost_per_seat decimal(5,0) NOT NULL,
    capacity decimal(4) NOT NULL,
    from_airport_id char(3) NOT NULL,
    to_airport_id char(3) NOT NULL,
    
    primary key (airline_name, flight_number),
    constraint flight_fk_10 foreign key (airline_name) references airline (name),
    constraint flight_fk_11 foreign key (from_airport_id) references airport (airport_id),
    constraint flight_fk_12 foreign key (to_airport_id) references airport (airport_id)
) ENGINE=InnoDB;
insert into flight values
('Delta Airlines',1,'10:00 AM','12:00 PM',400,150,'ATL','JFK'),
('Southwest Airlines',2,'10:30 AM','2:30 PM',350,125,'ORD','MIA'),
('American Airlines',3,'1:00 PM','4:00 PM',350,125,'MIA','DFW'),
('United Airlines',4,'4:30 PM','6:30 PM',400,100,'ATL','LGA'),
('JetBlue Airways',5,'11:00 AM','1:00 PM',400,130,'LGA','ATL'),
('Spirit Airlines',6,'12:30 PM','9:30 PM',650,140,'SJC','ATL'),
('WestJet',7,'1:00 PM','4:00 PM',700,100,'LGA','SJC'),
('Interjet',8,'7:30 PM','9:30 PM',350,125,'MIA','ORD'),
('Delta Airlines',9,'8:00 AM','10:00 AM',375,150,'JFK','ATL'),
('Delta Airlines',10,'9:15 AM','6:15 PM',700,110,'LAX','ATL'),
('Southwest Airlines',11,'12:07 PM','7:07 PM',600,95,'LAX','ORD'),
('United Airlines',12,'3:35 PM','5:35 PM',275,115,'MIA','ATL');


DROP TABLE IF EXISTS property;
CREATE TABLE property (
	owner_email varchar(50),
    name varchar(50),
    description text(300) NOT NULL, 
    cost_per_night_per_person decimal(5) NOT NULL,
    capacity decimal(3) NOT NULL,
    street varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state char(2) NOT NULL,
    zip char(5) NOT NULL,
    
    primary key (owner_email, name),
    unique key (street, city, state, zip),
    constraint property_fk_13 foreign key (owner_email) references owner (email)
) ENGINE=InnoDB;
insert into property values
('scooper3@gmail.com','Atlanta Great Property','This is right in the middle of Atlanta near many attractions!',600,4,'2nd St','ATL','GA',30008),
('gburdell3@gmail.com','House near Georgia Tech','Super close to bobby dodde stadium!',275,3,'North Ave','ATL','GA',30008),
('cbing10@gmail.com','New York City Property','A view of the whole city. Great property!',750,2,'123 Main St','NYC','NY',10008),
('mgeller5@gmail.com','Statue of Libery Property','You can see the statue of liberty from the porch',1000,5,'1st St','NYC','NY',10009),
('arthurread@gmail.com','Los Angeles Property','',700,3,'10th St','LA','CA',90008),
('arthurread@gmail.com','LA Kings House','This house is super close to the LA kinds stadium!',750,4,'Kings St','La','CA',90011),
('arthurread@gmail.com','Beautiful San Jose Mansion','Huge house that can sleep 12 people. Totally worth it!',900,12,'Golden Bridge Pkwt','San Jose','CA',90001),
('lebron6@gmail.com','LA Lakers Property','This house is right near the LA lakers stadium. You might even meet Lebron James!',850,4,'Lebron Ave','LA','CA',90011),
('hwmit@gmail.com','Chicago Blackhawks House','This is a great property!',775,3,'Blackhawks St','Chicago','IL',60176),
('mj23@gmail.com','Chicago Romantic Getaway','This is a great property!',1050,2,'23rd Main St','Chicago','IL',60176),
('msmith5@gmail.com','Beautiful Beach Property','You can walk out of the house and be on the beach!',975,2,'456 Beach Ave','Miami','FL',33101),
('ellie2@gmail.com','Family Beach House','You can literally walk onto the beach and see it from the patio!',850,6,'1132 Beach Ave','Miami','FL',33101),
('mscott22@gmail.com','Texas Roadhouse','This property is right in the center of Dallas, Texas!',450,3,'17th Street','Dallas','TX',75043),
('mscott22@gmail.com','Texas Longhorns House','You can walk to the longhorns stadium from here!',600,10,'1125 Longhorns Way','Dallas','TX',75001);


DROP TABLE IF EXISTS amenities;
CREATE TABLE amenities (
	property_owner varchar(50),
    property_name varchar(50),
    amenity_name varchar(50),
    
    primary key (property_owner, property_name, amenity_name),
	constraint amenities_fk_14 foreign key (property_owner, property_name) references property (owner_email, name)
) ENGINE=InnoDB;
insert into amenities values
('scooper3@gmail.com','Atlanta Great Property','A/C & Heating'),
('scooper3@gmail.com','Atlanta Great Property','Pets allowed'),
('scooper3@gmail.com','Atlanta Great Property','Wifi & TV'),
('scooper3@gmail.com','Atlanta Great Property','Washer and Dryer'),
('gburdell3@gmail.com','House near Georgia Tech','Wifi & TV'),
('gburdell3@gmail.com','House near Georgia Tech','Washer and Dryer'),
('gburdell3@gmail.com','House near Georgia Tech','Full Kitchen'),
('cbing10@gmail.com','New York City Property','A/C & Heating'),
('cbing10@gmail.com','New York City Property','Wifi & TV'),
('mgeller5@gmail.com','Statue of Libery Property','A/C & Heating'),
('mgeller5@gmail.com','Statue of Libery Property','Wifi & TV'),
('arthurread@gmail.com','Los Angeles Property','A/C & Heating'),
('arthurread@gmail.com','Los Angeles Property','Pets allowed'),
('arthurread@gmail.com','Los Angeles Property','Wifi & TV'),
('arthurread@gmail.com','LA Kings House','A/C & Heating'),
('arthurread@gmail.com','LA Kings House','Wifi & TV'),
('arthurread@gmail.com','LA Kings House','Washer and Dryer'),
('arthurread@gmail.com','LA Kings House','Full Kitchen'),
('arthurread@gmail.com','Beautiful San Jose Mansion','A/C & Heating'),
('arthurread@gmail.com','Beautiful San Jose Mansion','Pets allowed'),
('arthurread@gmail.com','Beautiful San Jose Mansion','Wifi & TV'),
('arthurread@gmail.com','Beautiful San Jose Mansion','Washer and Dryer'),
('arthurread@gmail.com','Beautiful San Jose Mansion','Full Kitchen'),
('lebron6@gmail.com','LA Lakers Property','A/C & Heating'),
('lebron6@gmail.com','LA Lakers Property','Wifi & TV'),
('lebron6@gmail.com','LA Lakers Property','Washer and Dryer'),
('lebron6@gmail.com','LA Lakers Property','Full Kitchen'),
('hwmit@gmail.com','Chicago Blackhawks House','A/C & Heating'),
('hwmit@gmail.com','Chicago Blackhawks House','Wifi & TV'),
('hwmit@gmail.com','Chicago Blackhawks House','Washer and Dryer'),
('hwmit@gmail.com','Chicago Blackhawks House','Full Kitchen'),
('mj23@gmail.com','Chicago Romantic Getaway','A/C & Heating'),
('mj23@gmail.com','Chicago Romantic Getaway','Wifi & TV'),
('msmith5@gmail.com','Beautiful Beach Property','A/C & Heating'),
('msmith5@gmail.com','Beautiful Beach Property','Wifi & TV'),
('msmith5@gmail.com','Beautiful Beach Property','Washer and Dryer'),
('ellie2@gmail.com','Family Beach House','A/C & Heating'),
('ellie2@gmail.com','Family Beach House','Pets allowed'),
('ellie2@gmail.com','Family Beach House','Wifi & TV'),
('ellie2@gmail.com','Family Beach House','Washer and Dryer'),
('ellie2@gmail.com','Family Beach House','Full Kitchen'),
('mscott22@gmail.com','Texas Roadhouse','A/C & Heating'),
('mscott22@gmail.com','Texas Roadhouse','Pets allowed'),
('mscott22@gmail.com','Texas Roadhouse','Wifi & TV'),
('mscott22@gmail.com','Texas Roadhouse','Washer and Dryer'),
('mscott22@gmail.com','Texas Longhorns House','A/C & Heating'),
('mscott22@gmail.com','Texas Longhorns House','Pets allowed'),
('mscott22@gmail.com','Texas Longhorns House','Wifi & TV'),
('mscott22@gmail.com','Texas Longhorns House','Washer and Dryer'),
('mscott22@gmail.com','Texas Longhorns House','Full Kitchen');


DROP TABLE IF EXISTS review;
CREATE TABLE review (
	customer_email varchar(50),
    property_owner varchar(50),
    property_name varchar(50),
    content text(500) NOT NULL,
    score decimal(1) NOT NULL,
    
    primary key (customer_email, property_owner, property_name),
    constraint review_fk_15 foreign key (customer_email) references customer (email),
    constraint review_fk_16 foreign key (property_owner, property_name) references property (owner_email, name)
) ENGINE=InnoDB;
insert into review values
('swilson@gmail.com','gburdell3@gmail.com','House near Georgia Tech',"This was so much fun. I went and saw the coke factory, the falcons play, GT play, and the Georgia aquarium. Great time! Would highly recommend!",5),
('aray@tiktok.com','cbing10@gmail.com','New York City Property',"This was the best 5 days ever! I saw so much of NYC!",5),
('bshelton@gmail.com','mgeller5@gmail.com','Statue of Libery Property',"This was truly an excellent experience. I really could see the Statue of Liberty from the property!",4),
('lbryan@gmail.com','arthurread@gmail.com','Los Angeles Property',"I had an excellent time!",4),
('tswift@gmail.com','arthurread@gmail.com','Beautiful San Jose Mansion',"We had a great time, but the house wasn''t fully cleaned when we arrived",3),
('jseinfeld@gmail.com','lebron6@gmail.com','LA Lakers Property',"I was disappointed that I did not meet lebron james",2),
('maddiesmith@gmail.com','hwmit@gmail.com','Chicago Blackhawks House',"This was awesome! I met one player on the chicago blackhawks!",5);


DROP TABLE IF EXISTS reserve;
CREATE TABLE reserve (
	customer_email varchar(50),
    property_owner varchar(50),
    property_name varchar(50),
    start_date date NOT NULL,
    end_date date NOT NULL,
    number_of_guests decimal(3) NOT NULL,
    
    primary key (customer_email, property_owner, property_name),
    constraint reserve_fk_17 foreign key (customer_email) references customer (email),
    constraint reserve_fk_18 foreign key (property_owner, property_name) references property (owner_email, name)
) ENGINE=InnoDB;
insert into reserve values
('swilson@gmail.com','gburdell3@gmail.com','House near Georgia Tech','2021-10-19','2021-10-25',3),
('aray@tiktok.com','cbing10@gmail.com','New York City Property','2021-10-18','2021-10-23',2),
('cdemilio@tiktok.com','cbing10@gmail.com','New York City Property','2021-10-24','2021-10-30',2),
('bshelton@gmail.com','mgeller5@gmail.com','Statue of Libery Property','2021-10-18','2021-10-22',4),
('lbryan@gmail.com','arthurread@gmail.com','Los Angeles Property','2021-10-19','2021-10-25',2),
('tswift@gmail.com','arthurread@gmail.com','Beautiful San Jose Mansion','2021-10-19','2021-10-22',10),
('jseinfeld@gmail.com','lebron6@gmail.com','LA Lakers Property','2021-10-19','2021-10-24',4),
('maddiesmith@gmail.com','hwmit@gmail.com','Chicago Blackhawks House','2021-10-19','2021-10-23',2),
('aray@tiktok.com','mj23@gmail.com','Chicago Romantic Getaway','2021-11-01','2021-11-07',2),
('cbing10@gmail.com','msmith5@gmail.com','Beautiful Beach Property','2021-10-18','2021-10-25',2),
('hwmit@gmail.com','ellie2@gmail.com','Family Beach House','2021-10-18','2021-10-28',5);


DROP TABLE IF EXISTS book;
CREATE TABLE book (
	customer_email varchar(50),
    flight_airline_name varchar(50),
    flight_number char(5),
    number_of_seats decimal(4,0) NOT NULL,
    
    primary key (customer_email, flight_airline_name, flight_number),
    constraint book_fk_19 foreign key (customer_email) references customer (email),
    constraint book_fk_20 foreign key (flight_airline_name, flight_number) references flight (airline_name, flight_number)
) ENGINE=InnoDB;
insert into book values
('swilson@gmail.com','JetBlue Airways',5,3),
('aray@tiktok.com','Delta Airlines',1,2),
('bshelton@gmail.com','United Airlines',4,4),
('lbryan@gmail.com','WestJet',7,2),
('tswift@gmail.com','WestJet',7,2),
('jseinfeld@gmail.com','WestJet',7,4),
('maddiesmith@gmail.com','Interjet',8,2),
('cbing10@gmail.com','Southwest Airlines',2,2),
('hwmit@gmail.com','Southwest Airlines',2,5);


DROP TABLE IF EXISTS is_close_to;
CREATE TABLE is_close_to (
	airport_id char(3),
    property_owner varchar(50),
    property_name varchar(50),
    distance decimal(2,0) NOT NULL,
    
    primary key (airport_id, property_owner, property_name),
    constraint is_close_to_fk_21 foreign key (airport_id) references airport (airport_id),
    constraint is_close_to_fk_22 foreign key (property_owner, property_name) references property (owner_email, name)
) ENGINE=InnoDB;
insert into is_close_to values
('ATL','scooper3@gmail.com','Atlanta Great Property',12),
('ATL','gburdell3@gmail.com','House near Georgia Tech',7),
('JFK','cbing10@gmail.com','New York City Property',10),
('JFK','mgeller5@gmail.com','Statue of Libery Property',8),
('LGA','cbing10@gmail.com','New York City Property',25),
('LGA','mgeller5@gmail.com','Statue of Libery Property',19),
('LAX','arthurread@gmail.com','Los Angeles Property',9),
('LAX','arthurread@gmail.com','LA Kings House',12),
('SJC','arthurread@gmail.com','Beautiful San Jose Mansion',8),
('LAX','arthurread@gmail.com','Beautiful San Jose Mansion',30),
('LAX','lebron6@gmail.com','LA Lakers Property',6),
('ORD','hwmit@gmail.com','Chicago Blackhawks House',11),
('ORD','mj23@gmail.com','Chicago Romantic Getaway',13),
('MIA','msmith5@gmail.com','Beautiful Beach Property',21),
('MIA','ellie2@gmail.com','Family Beach House',19),
('DFW','mscott22@gmail.com','Texas Roadhouse',8),
('DFW','mscott22@gmail.com','Texas Longhorns House',17);