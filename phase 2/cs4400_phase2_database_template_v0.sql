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
    credit_card_number decimal(16,0) NOT NULL UNIQUE,
    expiration_date date NOT NULL,
    cvv decimal(3,0) NOT NULL,
    current_location varchar(50) NOT NULL DEFAULT "",
    
    primary key (email),
    constraint customer_fk_4 foreign key (email) references client (email)
) ENGINE=InnoDB;
insert into customer values
('scooper3@gmail.com',6518555974461660,'2024-2-29',551,''),
('mgeller5@gmail.com',2328567043101960,'2024-3-31',644,''),
('cbing10@gmail.com',8387952398279290,'2023-2-28',201,''),
('hwmit@gmail.com',6558859698525290,'2023-4-30',102,''),
('swilson@gmail.com',9383321241981830,'2022-8-31',455,''),
('aray@tiktok.com',3110266979495600,'2022-8-31',744,''),
('cdemilio@tiktok.com',2272355540784740,'2025-02-28',606,''),
('bshelton@gmail.com',9276763978834270,'2023-09-30',862,''),
('lbryan@gmail.com',4652372688643790,'2023-05-31',258,''),
('tswift@gmail.com',5478842044367470,'2024-12-31',857,''),
('jseinfeld@gmail.com',3616897712963370,'2022-06-30',295,''),
('maddiesmith@gmail.com',9954569863556950,'2022-07-31',794,''),
('johnthomas@gmail.com',7580327437245350,'2025-10-31',269,''),
('boblee15@gmail.com',7907351371614240,'2025-11-30',858,'');








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
    rating decimal(1,0) NOT NULL,
    
    primary key (name)
) ENGINE=InnoDB;

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

DROP TABLE IF EXISTS attractions;
CREATE TABLE attractions (
	airport_id char(3),
    attraction_name varchar(50),
    
    primary key (airport_id, attraction_name),
    constraint attractions_fk_9 foreign key (airport_id) references airport (airport_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
	airline_name varchar(50),
    flight_number decimal(5,0),
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

DROP TABLE IF EXISTS amenities;
CREATE TABLE amenities (
	property_owner varchar(50),
    property_name varchar(50),
    amenity_name varchar(50),
    
    primary key (property_owner, property_name, amenity_name),
	constraint amenities_fk_14 foreign key (property_owner, property_name) references property (owner_email, name)
) ENGINE=InnoDB;

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

DROP TABLE IF EXISTS book;
CREATE TABLE book (
	customer_email varchar(50),
    flight_airline_name varchar(50),
    flight_number decimal(5,0),
    number_of_seats decimal(4,0) NOT NULL,
    
    primary key (customer_email, flight_airline_name, flight_number),
    constraint book_fk_19 foreign key (customer_email) references customer (email),
    constraint book_fk_20 foreign key (flight_airline_name, flight_number) references flight (airline_name, flight_number)
) ENGINE=InnoDB;

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

