-- Nguyen Khanh Van --
-- câu 1 -- 
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Movies')
BEGIN
    ALTER DATABASE Movies SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Movies;
END
GO

CREATE DATABASE Movies
ON PRIMARY
(   NAME = Movies_data,
    FILENAME = 'D:\MSQL Server\MON CSDL\Movies_data.mdf',
    SIZE = 25MB,
    MAXSIZE = 40MB,
    FILEGROWTH = 1MB)
LOG ON
(   NAME = Movies_log,
    FILENAME = 'D:\MSQL Server\MON CSDL\Movies_log.ldf',
    SIZE = 6MB,
    MAXSIZE = 8MB,
    FILEGROWTH = 1MB);
GO
-- câu 2 --
ALTER DATABASE Movies
ADD FILE
(   NAME = Movies_data2,
    FILENAME = 'D:\MSQL Server\MON CSDL\Movies_data2.ndf',
    SIZE = 10MB);
GO


-- set single user --
ALTER DATABASE Movies SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- set resticted user --
ALTER DATABASE Movies SET RESTRICTED_USER;
-- set multi user --
ALTER DATABASE Movies SET MULTI_USER;
-- thay doi kich thuoc --
ALTER DATABASE Movies
MODIFY FILE
(   NAME = Movies_data2,
    SIZE = 15MB);
GO
-- set auto shrink --
ALTER DATABASE Movies SET AUTO_SHRINK ON;
GO

-- add filegroup data --
ALTER DATABASE Movies 
ADD FILEGROUP Data;
GO

-- move data -> movies -- 
ALTER DATABASE Movies 
ADD FILE (
    NAME = Movies_data2,
    FILENAME = 'D:\MSQL Server\MON CSDL\Movies_data2.ndf',
    SIZE = 10MB
) TO FILEGROUP Data;
GO

-- change Movies's size

ALTER DATABASE Movies 
MODIFY FILE (NAME = Movies_log, MAXSIZE = 10MB);
GO

-- Check Movies
EXEC sp_helpdb Movies;
GO

use Movies
go 
-- Create User-Defined Data Types
EXEC sp_addtype Movie_num, INT, 'NOT NULL';
EXEC sp_addtype Category_num, INT, 'NOT NULL';
EXEC sp_addtype Cust_num, INT, 'NOT NULL';
EXEC sp_addtype Invoice_num, INT, 'NOT NULL';
GO

-- Create Table: Customer
CREATE TABLE Customer (
    Cust_num Cust_num IDENTITY(300,1) PRIMARY KEY,
    Lname VARCHAR(20) NOT NULL,
    Fname VARCHAR(20) NOT NULL,
    Address1 VARCHAR(30) NULL,
    Address2 VARCHAR(20) NULL,
    City VARCHAR(20) NULL,
    State CHAR(2) NULL,
    Zip CHAR(10) NULL,
    Phone VARCHAR(10) NOT NULL,
    Join_date SMALLDATETIME NOT NULL
);
GO

-- Create Table: Category
CREATE TABLE Category (
    Category_num Category_num IDENTITY(1,1) PRIMARY KEY,
    Description VARCHAR(20) NOT NULL
);
GO

-- Create Table: Movie
CREATE TABLE Movie (
    Movie_num Movie_num PRIMARY KEY,
    Title VARCHAR(50) NOT NULL,
    Category_Num Category_num NOT NULL,
    Date_purch SMALLDATETIME NULL,
    Rental_price INT NULL,
    Rating CHAR(5) NULL,
    FOREIGN KEY (Category_Num) REFERENCES Category(Category_num)
);
GO

-- Create Table: Rental
CREATE TABLE Rental (
    Invoice_num Invoice_num PRIMARY KEY,
    Cust_num Cust_num NOT NULL,
    Rental_date SMALLDATETIME NOT NULL,
    Due_date SMALLDATETIME NOT NULL,
    FOREIGN KEY (Cust_num) REFERENCES Customer(Cust_num)
);
GO

-- Create Table: Rental_Detail 
CREATE TABLE Rental_Detail (
    Invoice_num Invoice_num NOT NULL,
    Line_num INT NOT NULL,
    Movie_num Movie_num NOT NULL,
    Rental_price SMALLMONEY NOT NULL,
    PRIMARY KEY (Invoice_num, Line_num),
    FOREIGN KEY (Invoice_num) REFERENCES Rental(Invoice_num),
    FOREIGN KEY (Movie_num) REFERENCES Movie(Movie_num)
);
GO

-- Table checked
EXEC sp_help Customer;
EXEC sp_help Category;
EXEC sp_help Movie;
EXEC sp_help Rental;
EXEC sp_help Rental_Detail;
GO

-- FK: Movie → Category
ALTER TABLE Movie 
ADD CONSTRAINT FK_movie FOREIGN KEY (Category_num) 
REFERENCES Category (Category_num);

-- FK: Rental → Customer
ALTER TABLE Rental 
ADD CONSTRAINT FK_rental FOREIGN KEY (Cust_num) 
REFERENCES Customer (Cust_num);

-- FK: Rental_Detail → Rental
ALTER TABLE Rental_Detail 
ADD CONSTRAINT FK_detail_invoice FOREIGN KEY (Invoice_num) 
REFERENCES Rental (Invoice_num) 
ON DELETE CASCADE;

-- FK: Rental_Detail → Movie
ALTER TABLE Rental_Detail 
ADD CONSTRAINT FK_detail_movie FOREIGN KEY (Movie_num) 
REFERENCES Movie (Movie_num);
GO

--Set default: Date_purch (Movie)
ALTER TABLE Movie 
ADD CONSTRAINT DK_movie_date_purch 
DEFAULT GETDATE() FOR Date_purch;

-- Set default: Join_date
ALTER TABLE Customer 
ADD CONSTRAINT DK_customer_join_date 
DEFAULT GETDATE() FOR Join_date;

-- Set default: Rental_date
ALTER TABLE Rental 
ADD CONSTRAINT DK_rental_rental_date 
DEFAULT GETDATE() FOR Rental_date;

-- Set default: Due_dat 
ALTER TABLE Rental 
ADD CONSTRAINT DK_rental_due_date 
DEFAULT DATEADD(DAY, 2, GETDATE()) FOR Due_date;
GO


-- Set accept vallues 
ALTER TABLE Movie 
ADD CONSTRAINT CK_movie 
CHECK (Rating IN ('G', 'PG', 'R', 'NC17', 'NR'));

-- Set condition Duedate>= Rentaldate
ALTER TABLE Rental 
ADD CONSTRAINT CK_Due_date 
CHECK (Due_date >= Rental_date);
GO