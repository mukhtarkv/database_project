DROP DATABASE IF EXISTS travel_reservation_service;
CREATE DATABASE IF NOT EXISTS travel_reservation_service;
USE travel_reservation_service;

------------------------------------------
--
-- Entities
--
------------------------------------------

CREATE TABLE Accounts (
    Email VARCHAR(50) NOT NULL,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Pass VARCHAR(50) NOT NULL,

    PRIMARY KEY (Email)
);

-- Admin is a keyword in MySQL
CREATE TABLE Admins (
    Email VARCHAR(50) NOT NULL,

    PRIMARY KEY (Email),
    FOREIGN KEY (Email) REFERENCES Accounts (Email)
);

CREATE TABLE Clients (
    Email VARCHAR(50) NOT NULL,
    Phone_Number Char(12) UNIQUE NOT NULL CHECK (length(Phone_Number) = 12), -- Assuming format 123-456-7890

    PRIMARY KEY (Email),
    FOREIGN KEY (Email) REFERENCES Accounts (Email) 
);

-- Owner is a keyword in MySQL
CREATE TABLE Owners (
    Email VARCHAR(50) NOT NULL,

    PRIMARY KEY (Email),
    FOREIGN KEY (Email) REFERENCES Clients (Email)
);

CREATE TABLE Customer (
    Email VARCHAR(50) NOT NULL,
    CcNumber VARCHAR(19) UNIQUE NOT NULL CHECK (length(CcNumber) = 19), -- Assuming format "1234 1234 1234 1234"
    Cvv CHAR(3) NOT NULL CHECK (length(Cvv) = 3),
    Exp_Date DATE NOT NULL,
    Location VARCHAR(50) NOT NULL,

    PRIMARY KEY (Email),
    FOREIGN KEY (Email) REFERENCES Clients (Email)
);

CREATE TABLE Airline (
    Airline_Name VARCHAR(50) NOT NULL, -- Name is a keyword in MySQL
    Rating DECIMAL(2, 1) NOT NULL CHECK (Rating >= 1 AND Rating <= 5), -- Assuming 5 point rating scale

    PRIMARY KEY (Airline_Name)
);

CREATE TABLE Airport (
    Airport_Id CHAR(3) NOT NULL CHECK (length(Airport_Id) = 3),
    Airport_Name VARCHAR(50) UNIQUE NOT NULL,
    Time_Zone CHAR(3) NOT NULL CHECK(length(Time_Zone) = 3), -- Assuming 3 letter timezone abbreviation is used
    Street VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State CHAR(2) NOT NULL CHECK(length(State) = 2),
    Zip CHAR(5) NOT NULL CHECK(length(Zip) = 5),

    PRIMARY KEY (Airport_Id),
    UNIQUE KEY (Street, City, State, Zip)
);

------------------------------------------
--
-- Weak Entities
--
------------------------------------------

CREATE TABLE Flight (
	-- Comment length check until flight numbers are updated
    Flight_Num CHAR(5) NOT NULL, -- CHECK(length(Flight_Num) = 5),
    Airline_Name VARCHAR(50) NOT NULL,
    From_Airport CHAR(3) NOT NULL,
    To_Airport CHAR(3) NOT NULL,
    Departure_Time TIME NOT NULL,
    Arrival_Time TIME NOT NULL,
    Flight_Date DATE NOT NULL,
    Cost DECIMAL(6, 2) NOT NULL CHECK (Cost >= 0), -- Allow prices from $0.00 to $9999.99
    Capacity INT NOT NULL CHECK (Capacity > 0),

    PRIMARY KEY (Flight_Num, Airline_Name),
    FOREIGN KEY (Airline_Name) REFERENCES Airline (Airline_Name),
    FOREIGN KEY (From_Airport) REFERENCES Airport (Airport_Id),
    FOREIGN KEY (To_Airport) REFERENCES Airport (Airport_Id),
    
    -- Destination airport must be different from origin airport
    CHECK (From_Airport != To_Airport)
    -- Flight must arrive after it departs
    -- Commenting this for now. Since for short flights across time zones
    -- this may not always hold
    -- CHECK (Departure_Time < Arrival_Time)
);

CREATE TABLE Property (
    Property_Name VARCHAR(50) NOT NULL,
    Owner_Email VARCHAR(50) NOT NULL,
    Descr VARCHAR(500) NOT NULL, -- Description is a keyword in MySQL
    Capacity INT NOT NULL CHECK (Capacity > 0),
    Cost DECIMAL(6, 2) NOT NULL CHECK (Cost >= 0), -- Allow prices from $0.00 to $9999.99
    Street VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State CHAR(2) NOT NULL CHECK(length(State) = 2),
    Zip CHAR(5) NOT NULL CHECK(length(Zip) = 5),

    PRIMARY KEY (Property_Name, Owner_Email),
    FOREIGN KEY (Owner_Email) REFERENCES Owners (Email),
    UNIQUE KEY (Street, City, State, Zip)
);

------------------------------------------
--
-- Multivalued Attributes
--
------------------------------------------

CREATE TABLE Amenity (
    Property_Name VARCHAR(50) NOT NULL,
    Property_Owner VARCHAR(50) NOT NULL,
    Amenity_Name VARCHAR(50) NOT NULL,

    PRIMARY KEY (Property_Name, Property_Owner, Amenity_Name),
    FOREIGN KEY (Property_Name, Property_Owner) REFERENCES Property (Property_Name, Owner_Email) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Attraction (
    Airport CHAR(3) NOT NULL,
    Attraction_Name VARCHAR(50) NOT NULL,

    PRIMARY KEY (Airport, Attraction_Name),
    FOREIGN KEY (Airport) REFERENCES Airport (Airport_Id)
);

------------------------------------------
--
-- M-N Relationships
--
------------------------------------------

CREATE TABLE Review (
    Property_Name VARCHAR(50) NOT NULL,
    Owner_Email VARCHAR(50) NOT NULL,
    Customer VARCHAR(50) NOT NULL,
    Content VARCHAR(500), -- Assuming a customer could provide just a rating
    Score INT NOT NULL CHECK (Score >= 1 AND Score <= 5), -- Assuming 5 point rating scale

    PRIMARY KEY (Property_Name, Owner_Email, Customer),
    FOREIGN KEY (Property_Name, Owner_Email) REFERENCES Property (Property_Name, Owner_Email) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Customer) REFERENCES Customer (Email)
);

CREATE TABLE Reserve (
    Property_Name VARCHAR(50) NOT NULL,
    Owner_Email VARCHAR(50) NOT NULL,
    Customer VARCHAR(50) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Num_Guests INT NOT NULL CHECK (Num_Guests > 0),
    Was_Cancelled BOOLEAN NOT NULL,

    PRIMARY KEY (Property_Name, Owner_Email, Customer),
    FOREIGN KEY (Property_Name, Owner_Email) REFERENCES Property (Property_Name, Owner_Email),
    FOREIGN KEY (Customer) REFERENCES Customer (Email),
    
    -- End date must be after start date
    CHECK(End_Date >= Start_Date)
);

CREATE TABLE Is_Close_To (
    Property_Name VARCHAR(50) NOT NULL,
    Owner_Email VARCHAR(50) NOT NULL,
    Airport CHAR(3) NOT NULL,
    Distance INT NOT NULL CHECK (Distance >= 0), -- Assuming all distances rounded to nearest mile

    PRIMARY KEY (Property_Name, Owner_Email, Airport),
    FOREIGN KEY (Property_Name, Owner_Email) REFERENCES Property (Property_Name, Owner_Email) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Airport) REFERENCES Airport (Airport_Id)
);

CREATE TABLE Book (
    Customer VARCHAR(50) NOT NULL,
    Flight_Num CHAR(5) NOT NULL,
    Airline_Name VARCHAR(50) NOT NULL,
    Num_Seats INT NOT NULL CHECK (Num_Seats > 0),
    Was_Cancelled BOOLEAN NOT NULL,

    PRIMARY KEY (Customer, Flight_Num, Airline_Name),
    FOREIGN KEY (Customer) REFERENCES Customer (Email),
    FOREIGN KEY (Flight_Num, Airline_Name) REFERENCES Flight (Flight_Num, Airline_Name)
);

CREATE TABLE Owners_Rate_Customers (
    Owner_Email VARCHAR(50) NOT NULL,
    Customer VARCHAR(50) NOT NULL,
    Score INT NOT NULL CHECK (Score >= 1 AND Score <= 5), -- Assuming 5 point rating scale

    PRIMARY KEY (Owner_Email, Customer),
    FOREIGN KEY (Owner_Email) REFERENCES Owners (Email) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Customer) REFERENCES Customer (Email)
);

CREATE TABLE Customers_Rate_Owners (
    Customer VARCHAR(50) NOT NULL,
    Owner_Email VARCHAR(50) NOT NULL,
    Score INT NOT NULL CHECK (Score >= 1 AND Score <= 5), -- Assuming 5 point rating scale

    PRIMARY KEY (Customer, Owner_Email),
    FOREIGN KEY (Customer) REFERENCES Customer (Email),
    FOREIGN KEY (Owner_Email) REFERENCES Owners (Email) ON UPDATE CASCADE ON DELETE CASCADE
);

------------------------------------------
--
-- Insert Statements
--
------------------------------------------

INSERT INTO Accounts (Email, First_Name, Last_Name, Pass) VALUES
('mmoss1@travelagency.com', 'Mark', 'Moss', 'password1'),
('asmith@travelagency.com', 'Aviva', 'Smith', 'password2'),
('mscott22@gmail.com', 'Michael', 'Scott', 'password3'),
('arthurread@gmail.com', 'Arthur', 'Read', 'password4'),
('jwayne@gmail.com', 'John', 'Wayne', 'password5'),
('gburdell3@gmail.com', 'George', 'Burdell', 'password6'),
('mj23@gmail.com', 'Michael', 'Jordan', 'password7'),
('lebron6@gmail.com', 'Lebron', 'James', 'password8'),
('msmith5@gmail.com', 'Michael', 'Smith', 'password9'),
('ellie2@gmail.com', 'Ellie', 'Johnson', 'password10'),
('scooper3@gmail.com', 'Sheldon', 'Cooper', 'password11'),
('mgeller5@gmail.com', 'Monica', 'Geller', 'password12'),
('cbing10@gmail.com', 'Chandler', 'Bing', 'password13'),
('hwmit@gmail.com', 'Howard', 'Wolowitz', 'password14'),
('swilson@gmail.com', 'Samantha', 'Wilson', 'password16'),
('aray@tiktok.com', 'Addison', 'Ray', 'password17'),
('cdemilio@tiktok.com', 'Charlie', 'Demilio', 'password18'),
('bshelton@gmail.com', 'Blake', 'Shelton', 'password19'),
('lbryan@gmail.com', 'Luke', 'Bryan', 'password20'),
('tswift@gmail.com', 'Taylor', 'Swift', 'password21'),
('jseinfeld@gmail.com', 'Jerry', 'Seinfeld', 'password22'),
('maddiesmith@gmail.com', 'Madison', 'Smith', 'password23'),
('johnthomas@gmail.com', 'John', 'Thomas', 'password24'),
('boblee15@gmail.com', 'Bob', 'Lee', 'password25');

INSERT INTO Admins (Email) VALUES
('mmoss1@travelagency.com'),
('asmith@travelagency.com');

INSERT INTO Clients (Email, Phone_Number) VALUES
('mscott22@gmail.com', '555-123-4567'),
('arthurread@gmail.com', '555-234-5678'),
('jwayne@gmail.com', '555-345-6789'),
('gburdell3@gmail.com', '555-456-7890'),
('mj23@gmail.com', '555-567-8901'),
('lebron6@gmail.com', '555-678-9012'),
('msmith5@gmail.com', '555-789-0123'),
('ellie2@gmail.com', '555-890-1234'),
('scooper3@gmail.com', '678-123-4567'),
('mgeller5@gmail.com', '678-234-5678'),
('cbing10@gmail.com', '678-345-6789'),
('hwmit@gmail.com', '678-456-7890'),
('swilson@gmail.com', '770-123-4567'),
('aray@tiktok.com', '770-234-5678'),
('cdemilio@tiktok.com', '770-345-6789'),
('bshelton@gmail.com', '770-456-7890'),
('lbryan@gmail.com', '770-567-8901'),
('tswift@gmail.com', '770-678-9012'),
('jseinfeld@gmail.com', '770-789-0123'),
('maddiesmith@gmail.com', '770-890-1234'),
('johnthomas@gmail.com', '404-770-5555'),
('boblee15@gmail.com', '404-678-5555');

INSERT INTO Owners (Email) VALUES
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

INSERT INTO Customer (Email, CCNumber, Cvv, Exp_Date, Location) VALUES
('scooper3@gmail.com', '6518 5559 7446 1663', '551', '2024-2-01', ''),
('mgeller5@gmail.com', '2328 5670 4310 1965', '644', '2024-3-01', ''),
('cbing10@gmail.com', '8387 9523 9827 9291', '201', '2023-2-01', ''),
('hwmit@gmail.com', '6558 8596 9852 5299', '102', '2023-4-01', ''),
('swilson@gmail.com', '9383 3212 4198 1836', '455', '2022-8-01', ''),
('aray@tiktok.com', '3110 2669 7949 5605', '744', '2022-8-01', ''),
('cdemilio@tiktok.com', '2272 3555 4078 4744', '606', '2025-2-01', ''),
('bshelton@gmail.com', '9276 7639 7883 4273', '862', '2023-9-01', ''),
('lbryan@gmail.com', '4652 3726 8864 3798', '258', '2023-5-01', ''),
('tswift@gmail.com', '5478 8420 4436 7471', '857', '2024-12-01', ''),
('jseinfeld@gmail.com', '3616 8977 1296 3372', '295', '2022-6-01', ''),
('maddiesmith@gmail.com', '9954 5698 6355 6952', '794', '2022-7-01', ''),
('johnthomas@gmail.com', '7580 3274 3724 5356', '269', '2025-10-01', ''),
('boblee15@gmail.com', '7907 3513 7161 4248', '858', '2025-11-01', '');

INSERT INTO Airline (Airline_Name, Rating) VALUES
('Delta Airlines', 4.7),
('Southwest Airlines', 4.4),
('American Airlines', 4.6),
('United Airlines', 4.2),
('JetBlue Airways', 3.6),
('Spirit Airlines', 3.3),
('WestJet', 3.9),
('Interjet', 3.7);

INSERT INTO Airport (Airport_Id, Airport_Name, Time_Zone, Street, City, State, Zip) VALUES
('ATL', 'Atlanta Hartsfield Jackson Airport', 'EST', '6000 N Terminal Pkwy', 'Atlanta', 'GA', '30320'),
('JFK', 'John F Kennedy International Airport', 'EST', '455 Airport Ave', 'Queens', 'NY', '11430'),
('LGA', 'Laguardia Airport', 'EST', '790 Airport St', 'Queens', 'NY', '11371'),
('LAX', 'Lost Angeles International Airport', 'PST', '1 World Way', 'Los Angeles', 'CA', '90045'),
('SJC', 'Norman Y. Mineta San Jose International Airport', 'PST', '1702 Airport Blvd', 'San Jose', 'CA', '95110'),
('ORD', 'O\'Hare International Airport', 'CST', '10000 W O\'Hare Ave', 'Chicago', 'IL', '60666'),
('MIA', 'Miami International Airport', 'EST', '2100 NW 42nd Ave', 'Miami', 'FL', '33126'),
('DFW', 'Dallas International Airport', 'CST', '2400 Aviation DR', 'Dallas', 'TX', '75261');

INSERT INTO Flight (Flight_Num, Airline_Name, From_Airport, To_Airport, Departure_Time, Arrival_Time, Flight_Date, Cost, Capacity) VALUES
( '1', 'Delta Airlines', 'ATL', 'JFK', '100000', '120000', '2021-10-18', 400, 150),
( '2', 'Southwest Airlines', 'ORD', 'MIA', '103000', '143000', '2021-10-18', 350, 125),
( '3', 'American Airlines', 'MIA', 'DFW', '130000', '160000', '2021-10-18', 350, 125),
( '4', 'United Airlines', 'ATL', 'LGA', '163000', '183000', '2021-10-18', 400, 100),
( '5', 'JetBlue Airways', 'LGA', 'ATL', '110000', '130000', '2021-10-19', 400, 130),
( '6', 'Spirit Airlines', 'SJC', 'ATL', '123000', '213000', '2021-10-19', 650, 140),
( '7', 'WestJet', 'LGA', 'SJC', '130000', '160000', '2021-10-19', 700, 100),
( '8', 'Interjet', 'MIA', 'ORD', '193000', '213000', '2021-10-19', 350, 125),
( '9', 'Delta Airlines', 'JFK', 'ATL', '80000', '100000', '2021-10-20', 375, 150),
( '10', 'Delta Airlines', 'LAX', 'ATL', '91500', '181500', '2021-10-20', 700, 110),
( '11', 'Southwest Airlines', 'LAX', 'ORD', '120700', '190700', '2021-10-20', 600, 95),
( '12', 'United Airlines', 'MIA', 'ATL', '153500', '173500', '2021-10-20', 275, 115);

INSERT INTO Property (Property_Name, Owner_Email, Descr, Capacity, Cost, Street, City, State, Zip) VALUES
('Atlanta Great Property', 'scooper3@gmail.com', 'This is right in the middle of Atlanta near many attractions!', 4, 600, '2nd St', 'ATL', 'GA', '30008'),
('House near Georgia Tech', 'gburdell3@gmail.com', 'Super close to bobby dodde stadium!', 3, 275, 'North Ave', 'ATL', 'GA', '30008'),
('New York City Property', 'cbing10@gmail.com', 'A view of the whole city. Great property!', 2, 750, '123 Main St', 'NYC', 'NY', '10008'),
('Statue of Libery Property', 'mgeller5@gmail.com', 'You can see the statue of liberty from the porch', 5, 1000, '1st St', 'NYC', 'NY', '10009'),
('Los Angeles Property', 'arthurread@gmail.com', '', 3, 700, '10th St', 'LA', 'CA', '90008'),
('LA Kings House', 'arthurread@gmail.com', 'This house is super close to the LA kinds stadium!', 4, 750, 'Kings St', 'La', 'CA', '90011'),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'Huge house that can sleep 12 people. Totally worth it!', 12, 900, 'Golden Bridge Pkwt', 'San Jose', 'CA', '90001'),
('LA Lakers Property', 'lebron6@gmail.com', 'This house is right near the LA lakers stadium. You might even meet Lebron James!', 4, 850, 'Lebron Ave', 'LA', 'CA', '90011'),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'This is a great property!', 3, 775, 'Blackhawks St', 'Chicago', 'IL', '60176'),
('Chicago Romantic Getaway', 'mj23@gmail.com', 'This is a great property!', 2, 1050, '23rd Main St', 'Chicago', 'IL', '60176'),
('Beautiful Beach Property', 'msmith5@gmail.com', 'You can walk out of the house and be on the beach!', 2, 975, '456 Beach Ave', 'Miami', 'FL', '33101'),
('Family Beach House', 'ellie2@gmail.com', 'You can literally walk onto the beach and see it from the patio!', 6, 850, '1132 Beach Ave', 'Miami', 'FL', '33101'),
('Texas Roadhouse', 'mscott22@gmail.com', 'This property is right in the center of Dallas, Texas!', 3, 450, '17th Street', 'Dallas', 'TX', '75043'),
('Texas Longhorns House', 'mscott22@gmail.com', 'You can walk to the longhorns stadium from here!', 10, 600, '1125 Longhorns Way', 'Dallas', 'TX', '75001');

INSERT INTO Amenity (Property_Name, Property_Owner, Amenity_Name) VALUES
('Atlanta Great Property', 'scooper3@gmail.com', 'A/C & Heating'),
('Atlanta Great Property', 'scooper3@gmail.com', 'Pets allowed'),
('Atlanta Great Property', 'scooper3@gmail.com', 'Wifi & TV'),
('Atlanta Great Property', 'scooper3@gmail.com', 'Washer and Dryer'),
('House near Georgia Tech', 'gburdell3@gmail.com', 'Wifi & TV'),
('House near Georgia Tech', 'gburdell3@gmail.com', 'Washer and Dryer'),
('House near Georgia Tech', 'gburdell3@gmail.com', 'Full Kitchen'),
('New York City Property', 'cbing10@gmail.com', 'A/C & Heating'),
('New York City Property', 'cbing10@gmail.com', 'Wifi & TV'),
('Statue of Libery Property', 'mgeller5@gmail.com', 'A/C & Heating'),
('Statue of Libery Property', 'mgeller5@gmail.com', 'Wifi & TV'),
('Los Angeles Property', 'arthurread@gmail.com', 'A/C & Heating'),
('Los Angeles Property', 'arthurread@gmail.com', 'Pets allowed'),
('Los Angeles Property', 'arthurread@gmail.com', 'Wifi & TV'),
('LA Kings House', 'arthurread@gmail.com', 'A/C & Heating'),
('LA Kings House', 'arthurread@gmail.com', 'Wifi & TV'),
('LA Kings House', 'arthurread@gmail.com', 'Washer and Dryer'),
('LA Kings House', 'arthurread@gmail.com', 'Full Kitchen'),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'A/C & Heating'),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'Pets allowed'),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'Wifi & TV'),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'Washer and Dryer'),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'Full Kitchen'),
('LA Lakers Property', 'lebron6@gmail.com', 'A/C & Heating'),
('LA Lakers Property', 'lebron6@gmail.com', 'Wifi & TV'),
('LA Lakers Property', 'lebron6@gmail.com', 'Washer and Dryer'),
('LA Lakers Property', 'lebron6@gmail.com', 'Full Kitchen'),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'A/C & Heating'),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'Wifi & TV'),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'Washer and Dryer'),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'Full Kitchen'),
('Chicago Romantic Getaway', 'mj23@gmail.com', 'A/C & Heating'),
('Chicago Romantic Getaway', 'mj23@gmail.com', 'Wifi & TV'),
('Beautiful Beach Property', 'msmith5@gmail.com', 'A/C & Heating'),
('Beautiful Beach Property', 'msmith5@gmail.com', 'Wifi & TV'),
('Beautiful Beach Property', 'msmith5@gmail.com', 'Washer and Dryer'),
('Family Beach House', 'ellie2@gmail.com', 'A/C & Heating'),
('Family Beach House', 'ellie2@gmail.com', 'Pets allowed'),
('Family Beach House', 'ellie2@gmail.com', 'Wifi & TV'),
('Family Beach House', 'ellie2@gmail.com', 'Washer and Dryer'),
('Family Beach House', 'ellie2@gmail.com', 'Full Kitchen'),
('Texas Roadhouse', 'mscott22@gmail.com', 'A/C & Heating'),
('Texas Roadhouse', 'mscott22@gmail.com', 'Pets allowed'),
('Texas Roadhouse', 'mscott22@gmail.com', 'Wifi & TV'),
('Texas Roadhouse', 'mscott22@gmail.com', 'Washer and Dryer'),
('Texas Longhorns House', 'mscott22@gmail.com', 'A/C & Heating'),
('Texas Longhorns House', 'mscott22@gmail.com', 'Pets allowed'),
('Texas Longhorns House', 'mscott22@gmail.com', 'Wifi & TV'),
('Texas Longhorns House', 'mscott22@gmail.com', 'Washer and Dryer'),
('Texas Longhorns House', 'mscott22@gmail.com', 'Full Kitchen');

INSERT INTO Attraction (Airport, Attraction_Name) VALUES
('ATL', 'The Coke Factory'),
('ATL', 'The Georgia Aquarium'),
('JFK', 'The Statue of Liberty'),
('JFK', 'The Empire State Building'),
('LGA', 'The Statue of Liberty'),
('LGA', 'The Empire State Building'),
('LAX', 'Lost Angeles Lakers Stadium'),
('LAX', 'Los Angeles Kings Stadium'),
('SJC', 'Winchester Mystery House'),
('SJC', 'San Jose Earthquakes Soccer Team'),
('ORD', 'Chicago Blackhawks Stadium'),
('ORD', 'Chicago Bulls Stadium'),
('MIA', 'Crandon Park Beach'),
('MIA', 'Miami Heat Basketball Stadium'),
('DFW', 'Texas Longhorns Stadium'),
('DFW', 'The Original Texas Roadhouse');

INSERT INTO Review (Property_Name, Owner_Email, Customer, Content, Score) VALUES
('House near Georgia Tech', 'gburdell3@gmail.com', 'swilson@gmail.com', 'This was so much fun. I went and saw the coke factory, the falcons play, GT play, and the Georgia aquarium. Great time! Would highly recommend!', 5),
('New York City Property', 'cbing10@gmail.com', 'aray@tiktok.com', 'This was the best 5 days ever! I saw so much of NYC!', 5),
('Statue of Libery Property', 'mgeller5@gmail.com', 'bshelton@gmail.com', 'This was truly an excellent experience. I really could see the Statue of Liberty from the property!', 4),
('Los Angeles Property', 'arthurread@gmail.com', 'lbryan@gmail.com', 'I had an excellent time!', 4),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'tswift@gmail.com', 'We had a great time, but the house wasn\'t fully cleaned when we arrived', 3),
('LA Lakers Property', 'lebron6@gmail.com', 'jseinfeld@gmail.com', 'I was disappointed that I did not meet lebron james', 2),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'maddiesmith@gmail.com', 'This was awesome! I met one player on the chicago blackhawks!', 5),
('New York City Property', 'cbing10@gmail.com', 'cdemilio@tiktok.com', 'It was decent, but could have been better', 4);

INSERT INTO Reserve (Property_Name, Owner_Email, Customer, Start_Date, End_Date, Num_Guests, Was_Cancelled) VALUES
('House near Georgia Tech', 'gburdell3@gmail.com', 'swilson@gmail.com', '2021-10-19', '2021-10-25', 3, 0),
('New York City Property', 'cbing10@gmail.com', 'aray@tiktok.com', '2021-10-18', '2021-10-23', 2, 0),
('New York City Property', 'cbing10@gmail.com', 'cdemilio@tiktok.com', '2021-10-24', '2021-10-30', 2, 0),
('Statue of Libery Property', 'mgeller5@gmail.com', 'bshelton@gmail.com', '2021-10-18', '2021-10-22', 4, 0),
('Los Angeles Property', 'arthurread@gmail.com', 'lbryan@gmail.com', '2021-10-19', '2021-10-25', 2, 0),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'tswift@gmail.com', '2021-10-19', '2021-10-22', 10, 0),
('LA Lakers Property', 'lebron6@gmail.com', 'jseinfeld@gmail.com', '2021-10-19', '2021-10-24', 4, 0),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'maddiesmith@gmail.com', '2021-10-19', '2021-10-23', 2, 0),
('Chicago Romantic Getaway', 'mj23@gmail.com', 'aray@tiktok.com', '2021-11-1', '2021-11-7', 2, 1),
('Beautiful Beach Property', 'msmith5@gmail.com', 'cbing10@gmail.com', '2021-10-18', '2021-10-25', 2, 0),
('Family Beach House', 'ellie2@gmail.com', 'hwmit@gmail.com', '2021-10-18', '2021-10-28', 5, 1),
('New York City Property', 'cbing10@gmail.com', 'mgeller5@gmail.com', '2021-11-02', '2021-11-06', 3, 1);

INSERT INTO Is_Close_To (Property_Name, Owner_Email, Airport, Distance) VALUES
('Atlanta Great Property', 'scooper3@gmail.com', 'ATL', 12),
('House near Georgia Tech', 'gburdell3@gmail.com', 'ATL', 7),
('New York City Property', 'cbing10@gmail.com', 'JFK', 10),
('Statue of Libery Property', 'mgeller5@gmail.com', 'JFK', 8),
('New York City Property', 'cbing10@gmail.com', 'LGA', 25),
('Statue of Libery Property', 'mgeller5@gmail.com', 'LGA', 19),
('Los Angeles Property', 'arthurread@gmail.com', 'LAX', 9),
('LA Kings House', 'arthurread@gmail.com', 'LAX', 12),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'SJC', 8),
('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'LAX', 30),
('LA Lakers Property', 'lebron6@gmail.com', 'LAX', 6),
('Chicago Blackhawks House', 'hwmit@gmail.com', 'ORD', 11),
('Chicago Romantic Getaway', 'mj23@gmail.com', 'ORD', 13),
('Beautiful Beach Property', 'msmith5@gmail.com', 'MIA', 21),
('Family Beach House', 'ellie2@gmail.com', 'MIA', 19),
('Texas Roadhouse', 'mscott22@gmail.com', 'DFW', 8),
('Texas Longhorns House', 'mscott22@gmail.com', 'DFW', 17);

INSERT INTO Book (Customer, Flight_Num, Airline_Name, Num_Seats, Was_Cancelled) VALUES
('swilson@gmail.com', '5', 'JetBlue Airways', 3, 0),
('aray@tiktok.com', '1', 'Delta Airlines', 2, 0),
('bshelton@gmail.com', '4', 'United Airlines', 4, 0),
('lbryan@gmail.com', '7', 'WestJet', 2, 0),
('tswift@gmail.com', '7', 'WestJet', 2, 0),
('jseinfeld@gmail.com', '7', 'WestJet', 4, 1),
('bshelton@gmail.com', '5', 'JetBlue Airways', 4, 1),
('maddiesmith@gmail.com', '8', 'Interjet', 2, 0),
('cbing10@gmail.com', '2', 'Southwest Airlines', 2, 0),
('hwmit@gmail.com', '2', 'Southwest Airlines', 5, 1);

INSERT INTO Owners_Rate_Customers (Owner_Email, Customer, Score) VALUES
('gburdell3@gmail.com', 'swilson@gmail.com', 5),
('cbing10@gmail.com', 'aray@tiktok.com', 5),
('mgeller5@gmail.com', 'bshelton@gmail.com', 3),
('arthurread@gmail.com', 'lbryan@gmail.com', 4),
('arthurread@gmail.com', 'tswift@gmail.com', 4),
('lebron6@gmail.com', 'jseinfeld@gmail.com', 1),
('hwmit@gmail.com', 'maddiesmith@gmail.com', 2);

INSERT INTO Customers_Rate_Owners (Customer, Owner_Email, Score) VALUES
('swilson@gmail.com', 'gburdell3@gmail.com', 5),
('aray@tiktok.com', 'cbing10@gmail.com', 5),
('bshelton@gmail.com', 'mgeller5@gmail.com', 3),
('lbryan@gmail.com', 'arthurread@gmail.com', 4),
('tswift@gmail.com', 'arthurread@gmail.com', 4),
('jseinfeld@gmail.com', 'lebron6@gmail.com', 1),
('maddiesmith@gmail.com', 'hwmit@gmail.com', 2);
