-- CS4400: Introduction to Database Systems (Fall 2021)
-- Phase III: Stored Procedures & Views [v0] Tuesday, November 9, 2021 @ 12:00am EDT
-- Team 73
-- Michael Coppeta (mcoppeta3)
-- Mukhtar Kussaiynbekov (mkussaiy3)
-- Jingrui Zhang (jzhang3134)
-- Jon Green (?)
-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.

-- Helper methods
drop function if exists account_exists;
delimiter //
create function account_exists (i_email VARCHAR(50), i_first_name VARCHAR(100), i_last_name VARCHAR(100), i_password VARCHAR(50))
returns boolean deterministic
begin
return (select (i_email, i_first_name, i_last_name, i_password) in (select Email, First_Name, Last_Name, Pass from Accounts));
end //
delimiter ;

drop function if exists client_exists;
delimiter //
create function client_exists (i_email VARCHAR(50), i_phone_number Char(12))
returns boolean deterministic
begin
return (select (i_email, i_phone_number) in (select Email, Phone_Number from Clients));
end //
delimiter ;

drop function if exists account_with_email_exists;
delimiter //
create function account_with_email_exists (i_email VARCHAR(50))
returns boolean deterministic
begin
return (select i_email in (select Email from Clients));
end //
delimiter ;

drop function if exists customer_with_email_exists;
delimiter //
create function customer_with_email_exists (i_email VARCHAR(50))
returns boolean deterministic
begin
return (select i_email in (select Email from Customer));
end //
delimiter ;

drop function if exists client_with_phone_number_exists;
delimiter //
create function client_with_phone_number_exists (i_phone_number Char(12))
returns boolean deterministic
begin
return (select i_phone_number in (select Phone_Number from Clients));
end //
delimiter ;

-- ID: 1a
-- Name: register_customer
drop procedure if exists register_customer;
delimiter //
create procedure register_customer (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12),
    in i_cc_number varchar(19),
    in i_cvv char(3),
    in i_exp_date date,
    in i_location varchar(50)
) 
sp_main: begin
-- credit card number must be unique in system
if i_cc_number in (select CcNumber from Customer)
then leave sp_main; end if;

-- Handle case when customer to be added exists as an account and client 
if account_exists(i_email, i_first_name, i_last_name, i_password)
and client_exists(i_email, i_phone_number)
and not customer_with_email_exists(i_email) then
insert into Customer (Email, CcNumber, Cvv, Exp_Date, Location)
values (i_email, i_cc_number, i_cvv, i_exp_date, i_location);
leave sp_main; end if;

-- -- email and phone number must be unique in system
if account_with_email_exists(i_email)
or client_with_phone_number_exists(i_phone_number)
then leave sp_main; end if;

insert into Accounts (Email, First_Name, Last_Name, Pass)
values (i_email, i_first_name, i_last_name, i_password);

insert into Clients (Email, Phone_Number)
values (i_email, i_phone_number);

insert into Customer (Email, CcNumber, Cvv, Exp_Date, Location)
values (i_email, i_cc_number, i_cvv, i_exp_date, i_location);

end //
delimiter ;


-- ID: 1b
-- Name: register_owner
drop procedure if exists register_owner;
delimiter //
create procedure register_owner (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12)
) 
sp_main: begin
-- Handle case when customer to be added exists as an account and client
if account_exists(i_email, i_first_name, i_last_name, i_password)
and client_exists(i_email, i_phone_number)
and i_email not in (select Email from Owners) then
insert into Owners (Email) values (i_email);
leave sp_main; end if;

-- email and phone number must be unique in system
if account_with_email_exists(i_email)
or client_with_phone_number_exists(i_phone_number)
then leave sp_main; end if;

insert into Accounts (Email, First_Name, Last_Name, Pass)
values (i_email, i_first_name, i_last_name, i_password);

insert into Clients (Email, Phone_Number)
values (i_email, i_phone_number);

insert into Owners (Email) values (i_email);

end //
delimiter ;


-- ID: 1c
-- Name: remove_owner
drop procedure if exists remove_owner;
delimiter //
create procedure remove_owner ( 
    in i_owner_email varchar(50)
)
sp_main: begin
if i_owner_email in (select Owner_Email from Property)
then leave sp_main; end if;

delete from Owners where Email = i_owner_email;

if i_owner_email not in (select Email from Customer) then
delete from Clients where Email = i_owner_email;
delete from Accounts where Email = i_owner_email;
end if;

end //
delimiter ;

call register_customer('falcon@gmail.com', 'Samuel', 'Wilson', 'password22', '777-469-5347', '9121 2762 7467 5215', '809', '2022-05-11', 'Baton Rouge');
call register_owner('falcon@gmail.com', 'Samuel', 'Wilson', 'password22', '777-469-5347');
select * from Owners natural join Customer
where Owners.Email not in (select Owner_Email from Property);
call remove_owner("falcon@gmail.com");


-- Helper methods
drop function if exists flight_exists;
delimiter //
create function flight_exists (i_flight_num char(5), i_airline_name varchar(50))
returns boolean deterministic
begin
return (select (i_flight_num, i_airline_name) in (select Flight_Num, Airline_Name from Flight));
end //
delimiter ;

drop function if exists date_passed;
delimiter //
create function date_passed (i_past_date date, i_current_date date)
returns boolean deterministic
begin
return DATEDIFF(i_current_date, i_past_date) > 0;
end //
delimiter ;

-- ID: 2a
-- Name: schedule_flight
drop procedure if exists schedule_flight;
delimiter //
create procedure schedule_flight (
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_from_airport char(3),
    in i_to_airport char(3),
    in i_departure_time time,
    in i_arrival_time time,
    in i_flight_date date,
    in i_cost decimal(6, 2),
    in i_capacity int,
    in i_current_date date
)
sp_main: begin
if flight_exists(i_flight_num, i_airline_name)
or i_from_airport = i_to_airport
or date_passed(i_flight_date, i_current_date)
then leave sp_main; end if;

INSERT INTO Flight (Flight_Num, Airline_Name, From_Airport, To_Airport, Departure_Time, Arrival_Time, Flight_Date, Cost, Capacity)
VALUES (i_flight_num, i_airline_name, i_from_airport, i_to_airport, i_departure_time, i_arrival_time, i_flight_date, i_cost, i_capacity);
end //
delimiter ;

-- select date_time_passed('2021-10-18', '2021-11-04');
call schedule_flight('3', 'Southwest Airlines', 'MIA', 'DFW', '130000', '160000', '2021-10-18', 350, 125, '2021-11-04');


-- Helper methods
drop function if exists get_flight_date;
delimiter //
create function get_flight_date (i_flight_num char(5), i_airline_name varchar(50))
returns date deterministic
begin
return (select Flight_Date from Flight where Flight_Num = i_flight_num and Airline_Name = i_airline_name);
end //
delimiter ;

-- ID: 2b
-- Name: remove_flight
drop procedure if exists remove_flight;
delimiter //
create procedure remove_flight ( 
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
) 
sp_main: begin
if not flight_exists(i_flight_num, i_airline_name)
or date_passed(get_flight_date(i_flight_num, i_airline_name), i_current_date)
then leave sp_main; end if;

delete from Book where Flight_Num = i_flight_num and Airline_Name = i_airline_name;
delete from Flight where Flight_Num = i_flight_num and Airline_Name = i_airline_name;

end //
delimiter ;

-- call remove_flight('2', 'Southwest Airlines', '2021-08-01');


-- Helper methods
drop function if exists get_num_empty_seats;
delimiter //
create function get_num_empty_seats (i_flight_num char(5), i_airline_name varchar(50))
returns integer deterministic
begin
return (select num_empty_seats from view_flight where flight_id = i_flight_num and airline = i_airline_name);
end //
delimiter ;

drop function if exists customer_booked_flight_with_cancel_status;
delimiter //
create function customer_booked_flight_with_cancel_status (i_customer_email varchar(50), i_flight_num char(5), i_airline_name varchar(50), i_cancel_status boolean)
returns boolean deterministic
begin
return (select (i_customer_email, i_flight_num, i_airline_name) in (select Customer, Flight_Num, Airline_Name from Book where Was_Cancelled = i_cancel_status));
end //
delimiter ;

drop function if exists get_num_flights_on_date_with_cancel_status;
delimiter //
create function get_num_flights_on_date_with_cancel_status (i_flight_date date, i_customer_email varchar(50), i_cancel_status boolean)
returns integer deterministic
begin
return (select COUNT(*) from Book
where Customer = i_customer_email
and get_flight_date(Flight_Num, Airline_Name) = i_flight_date
and Was_Cancelled = i_cancel_status);
end //
delimiter ;

-- ID: 3a
-- Name: book_flight
drop procedure if exists book_flight;
delimiter //
create procedure book_flight (
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_num_seats int,
    in i_current_date date
)
sp_main: begin
if not customer_with_email_exists(i_customer_email)
or not flight_exists(i_flight_num, i_airline_name)
or i_num_seats > get_num_empty_seats(i_flight_num, i_airline_name)
or date_passed(get_flight_date(i_flight_num, i_airline_name), i_current_date)
or customer_booked_flight_with_cancel_status(i_customer_email, i_flight_num, i_airline_name, true)
then leave sp_main; end if;

if customer_booked_flight_with_cancel_status(i_customer_email, i_flight_num, i_airline_name, false) then
update Book set Num_Seats = Num_Seats + i_num_seats
where Customer = i_customer_email and Flight_Num = i_flight_num and Airline_Name = i_airline_name;
leave sp_main; end if;

if get_num_flights_on_date_with_cancel_status(get_flight_date(i_flight_num, i_airline_name), i_customer_email, false) = 1
then leave sp_main; end if;

insert into Book (Customer, Flight_Num, Airline_Name, Num_Seats, Was_Cancelled)
values (i_customer_email, i_flight_num, i_airline_name, i_num_seats, false);

end //
delimiter ;

call book_flight('scooper3@gmail.com', '2', 'Southwest Airlines', 122, '2021-10-01');

-- ID: 3b
-- Name: cancel_flight_booking
drop procedure if exists cancel_flight_booking;
delimiter //
create procedure cancel_flight_booking ( 
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
)
sp_main: begin
if not customer_with_email_exists(i_customer_email)
or not flight_exists(i_flight_num, i_airline_name)
or date_passed(get_flight_date(i_flight_num, i_airline_name), i_current_date)
then leave sp_main; end if;

if customer_booked_flight_with_cancel_status(i_customer_email, i_flight_num, i_airline_name, false) then
update Book set Was_Cancelled = 1
where Customer = i_customer_email and Flight_Num = i_flight_num and Airline_Name = i_airline_name;
leave sp_main; end if;

end //
delimiter ;

-- call cancel_flight_booking('bshelton@gmail.com', '4', 'United Airlines', '2021-10-01');

-- Helper methods
drop function if exists get_total_booked_seats;
delimiter //
create function get_total_booked_seats (flight_num CHAR(5), airline_name VARCHAR(50))
returns integer deterministic
begin
return coalesce((select SUM(Num_Seats)
from Book natural join Flight
where Flight.Flight_Num = flight_num
and Flight.Airline_Name = airline_name
and not Was_Cancelled), 0);
end //
delimiter ;

drop function if exists get_total_spent_on_flight;
delimiter //
create function get_total_spent_on_flight (flight_num CHAR(5), airline_name VARCHAR(50))
returns double deterministic
begin
declare total_spent double;
set total_spent = 0.0;

select SUM(Num_Seats * Cost *
(case Was_Cancelled when true then 0.2 else 1.0 end))
into total_spent
from Book natural join Flight
where Flight.Flight_Num = flight_num
and Flight.Airline_Name = airline_name;

return coalesce(total_spent, 0.0);
end //
delimiter ;

-- ID: 3c
-- Name: view_flight
create or replace view view_flight (
    flight_id,
    flight_date,
    airline,
    destination,
    seat_cost,
    num_empty_seats,
    total_spent
) as
select Flight_Num, Flight_Date, Airline_Name, To_Airport, Cost,
Capacity - get_total_booked_seats(Flight_Num, Airline_Name),
get_total_spent_on_flight(Flight_Num, Airline_Name)
from Flight;


-- Helper methods
drop function if exists address_exists;
delimiter //
create function address_exists (i_street varchar(50), i_city varchar(50), i_state char(2), i_zip char(5))
returns boolean deterministic
begin
return (select (i_street, i_city, i_state, i_zip) in (select Street, City, State, Zip from Property));
end //
delimiter ;

drop function if exists property_is_owned_by;
delimiter //
create function property_is_owned_by (i_property_name varchar(50), i_owner_email varchar(50))
returns boolean deterministic
begin
return (select (i_property_name, i_owner_email) in (select Property_Name, Owner_Email from Property));
end //
delimiter ;

-- ID: 4a
-- Name: add_property
drop procedure if exists add_property;
delimiter //
create procedure add_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_description varchar(500),
    in i_capacity int,
    in i_cost decimal(6, 2),
    in i_street varchar(50),
    in i_city varchar(50),
    in i_state char(2),
    in i_zip char(5),
    in i_nearest_airport_id char(3),
    in i_dist_to_airport int
) 
sp_main: begin
if address_exists(i_street, i_city, i_state, i_state)
or property_is_owned_by(i_property_name, i_owner_email)
then leave sp_main; end if;

insert into Property (Property_Name, Owner_Email, Descr, Capacity, Cost, Street, City, State, Zip)
VALUES (i_property_name, i_owner_email, i_description, i_capacity, i_cost, i_street, i_city, i_state, i_zip);

if i_nearest_airport_id in (select Airport_Id from Airport) and i_dist_to_airport is not NULL then
INSERT INTO Is_Close_To (Property_Name, Owner_Email, Airport, Distance)
VALUES (i_property_name, i_owner_email, i_nearest_airport_id, i_dist_to_airport); end if;
  
end //
delimiter ;

call add_property('Dunder Mifflin', 'mscott22@gmail.com', 'A great paper company for an overnight stay!', 15, 50.00, 'Slough Avenue', 'Scranton', 'PA', 18503, 'LGA', 135);


-- ID: 4b
-- Name: remove_property
drop procedure if exists remove_property;
delimiter //
create procedure remove_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_current_date date
)
sp_main: begin
if (select COUNT(*) from Reserve
where Property_Name = i_property_name and Owner_Email = i_owner_email
and DATEDIFF(i_current_date, Start_Date) >= 0
and DATEDIFF(End_Date, i_current_date) >= 0) > 0
then leave sp_main; end if;

delete from Reserve where Property_Name = i_property_name and Owner_Email = i_owner_email;
delete from Property where Property_Name = i_property_name and Owner_Email = i_owner_email;
    
end //
delimiter ;

call remove_property('LA Lakers Property', 'lebron6@gmail.com', '2021-10-22');


-- Helper methods
drop function if exists property_is_reserved_by;
delimiter //
create function property_is_reserved_by (i_property_name varchar(50), i_owner_email varchar(50), i_customer_email varchar(50))
returns boolean deterministic
begin
return (select (i_property_name, i_owner_email, i_customer_email) in (select Property_Name, Owner_Email, Customer from Reserve));
end //
delimiter ;

drop function if exists get_available_space_in_property;
delimiter //
create function get_available_space_in_property (i_property_name varchar(50), i_owner_email varchar(50), i_start_date date, i_end_date date)
returns integer deterministic
begin
return coalesce((select Capacity from Property where Property_Name = i_property_name and Owner_Email = i_owner_email), 0) -
coalesce((select SUM(Num_Guests) from Reserve where Property_Name = i_property_name and Owner_Email = i_owner_email
and not Was_Cancelled and Start_Date = i_start_date and End_Date = i_end_date), 0);
end //
delimiter ;

-- ID: 5a
-- Name: reserve_property
drop procedure if exists reserve_property;
delimiter //
create procedure reserve_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_start_date date,
    in i_end_date date,
    in i_num_guests int,
    in i_current_date date
)
sp_main: begin
if not property_is_owned_by(i_property_name, i_owner_email)
or property_is_reserved_by(i_property_name, i_owner_email, i_customer_email)
or DATEDIFF(i_current_date, i_start_date) >= 0
then leave sp_main; end if;

if (select COUNT(*) from Reserve
where Customer = i_customer_email
and ((DATEDIFF(i_start_date, Start_Date) >= 0
and DATEDIFF(End_Date, i_start_date) >= 0)
or (DATEDIFF(i_end_date, Start_Date) >= 0
and DATEDIFF(End_Date, i_end_date) >= 0)) > 0)
then leave sp_main; end if;

if get_available_space_in_property(i_property_name, i_owner_email, i_start_date, i_end_date) < i_num_guests
then leave sp_main; end if;

INSERT INTO Reserve (Property_Name, Owner_Email, Customer, Start_Date, End_Date, Num_Guests, Was_Cancelled)
VALUES (i_property_name, i_owner_email, i_customer_email, i_start_date, i_end_date, i_num_guests, false);

end //
delimiter ;

-- select get_available_space_in_property('Beautiful San Jose Mansion', 'arthurread@gmail.com', '2021-10-19', '2021-10-22');
-- call reserve_property('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'johnthomas@gmail.com', '2021-10-19', '2021-10-22', 1, '2021-10-01');


-- ID: 5b
-- Name: cancel_property_reservation
drop procedure if exists cancel_property_reservation;
delimiter //
create procedure cancel_property_reservation (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here

end //
delimiter ;


-- ID: 5c
-- Name: customer_review_property
drop procedure if exists customer_review_property;
delimiter //
create procedure customer_review_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_content varchar(500),
    in i_score int,
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here
    
end //
delimiter ;


-- ID: 5d
-- Name: view_properties
create or replace view view_properties (
    property_name, 
    average_rating_score, 
    description, 
    address, 
    capacity, 
    cost_per_night
) as
select Property.Property_Name, AVG(Score), Descr,
CONCAT(Street, ", ", City, ", ", State, ", ", Zip),
Capacity, Cost
from Property left join Review on Property.Property_Name = Review.Property_Name and Property.Owner_Email = Review.Owner_Email
group by Property.Property_Name, Street, City, State, Zip;


-- ID: 5e
-- Name: view_individual_property_reservations
drop procedure if exists view_individual_property_reservations;
delimiter //
create procedure view_individual_property_reservations (
    in i_property_name varchar(50),
    in i_owner_email varchar(50)
)
sp_main: begin
    drop table if exists view_individual_property_reservations;
    create table view_individual_property_reservations (
        property_name varchar(50),
        start_date date,
        end_date date,
        customer_email varchar(50),
        customer_phone_num char(12),
        total_booking_cost decimal(6,2),
        rating_score int,
        review varchar(500)
    ) as
    -- TODO: replace this select query with your solution
    select 'col1', 'col2', 'col3', 'col4', 'col5', 'col6', 'col7', 'col8' from reserve;

end //
delimiter ;


-- ID: 6a
-- Name: customer_rates_owner
drop procedure if exists customer_rates_owner;
delimiter //
create procedure customer_rates_owner (
    in i_customer_email varchar(50),
    in i_owner_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here

end //
delimiter ;


-- ID: 6b
-- Name: owner_rates_customer
drop procedure if exists owner_rates_customer;
delimiter //
create procedure owner_rates_customer (
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here

end //
delimiter ;

-- Helper methods
drop function if exists get_total_flights;
delimiter //
create function get_total_flights (airport_id CHAR(3), is_destination BOOLEAN)
returns integer deterministic
begin
return (select COUNT(*)
from Airport join Flight on (is_destination and Airport_Id = To_Airport) or (not is_destination and Airport_Id = From_Airport)
where Airport.Airport_Id = airport_id);
end //
delimiter ;

drop function if exists get_average_departing_cost;
delimiter //
create function get_average_departing_cost (airport_id CHAR(3))
returns double deterministic
begin
return (select AVG(Cost)
from Airport join Flight on Airport_Id = From_Airport
where Airport.Airport_Id = airport_id);
end //
delimiter ;

-- ID: 7a
-- Name: view_airports
create or replace view view_airports (
    airport_id, 
    airport_name, 
    time_zone, 
    total_arriving_flights, 
    total_departing_flights, 
    avg_departing_flight_cost
) as   
select Airport_Id, Airport_Name, Time_Zone,
get_total_flights(Airport_Id, TRUE),
get_total_flights(Airport_Id, FALSE),
get_average_departing_cost(Airport_Id)
from Airport;


-- ID: 7b
-- Name: view_airlines
create or replace view view_airlines (
    airline_name, 
    rating, 
    total_flights, 
    min_flight_cost
) as
select Airline_Name, Rating, COUNT(Flight_Num), MIN(Cost)
from Airline natural join Flight
group by Airline_Name;


-- Helper method
drop function if exists get_total_seats_purchased;
delimiter //
create function get_total_seats_purchased (email VARCHAR(50))
returns double precision deterministic
begin
return COALESCE((select SUM(Num_Seats)
from Customer left join Book on Customer.Email = Book.Customer
where Customer.Email = email), 0);
end //
delimiter ;

-- ID: 8a
-- Name: view_customers
create or replace view view_customers (
    customer_name, 
    avg_rating, 
    location, 
    is_owner, 
    total_seats_purchased
) as
select CONCAT(First_Name, " ", Last_Name),
AVG(Score), Location,
Owners.Email is not NULL,
get_total_seats_purchased(Customer.Email)
from Customer natural join Accounts left join Owners on Customer.Email = Owners.Email
left join Owners_Rate_Customers on Customer.Email = Customer
group by Customer.Email;


-- Helper methods
drop function if exists get_num_properties_owned;
delimiter //
create function get_num_properties_owned (email VARCHAR(50))
returns double deterministic
begin
return COALESCE((select COUNT(*) from Property
where Property.Owner_Email = email), 0);
end //
delimiter ;

drop function if exists get_avg_property_rating;
delimiter //
create function get_avg_property_rating (email VARCHAR(50))
returns double deterministic
begin
return (select AVG(Score)
from Property natural join Review
where Property.Owner_Email = email);
end //
delimiter ;

-- ID: 8b
-- Name: view_owners
create or replace view view_owners (
    owner_name, 
    avg_rating, 
    num_properties_owned, 
    avg_property_rating
) as
select CONCAT(First_Name, " ", Last_Name),
AVG(Score),
get_num_properties_owned(Email),
get_avg_property_rating(Email)
from Owners natural join Accounts
left join Owners_Rate_Customers on Email = Owner_Email
group by Email;


-- ID: 9a
-- Name: process_date
drop procedure if exists process_date;
delimiter //
create procedure process_date ( 
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here
    
end //
delimiter ;
