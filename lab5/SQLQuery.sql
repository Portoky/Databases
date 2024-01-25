USE Library
GO

drop table CustomersBooks;
drop table Publishes;
drop table AllLoans;
drop table CurrentLoans;
drop table Librarians;
drop table Departments;
drop table Books;
drop table Customers;
drop table Publishers;
drop table Reviews;
drop table Category;
drop table Owners;

--who loans the book
CREATE TABLE Customers(
	CustomerId INT Primary key Identity(1, 1),
	[Name] VARCHAR(50),
	Surname VARCHAR(50),
	Email VARCHAR(50),
	[Address] VARCHAR(100),
	DateOfBirth Date,
);
--it can be a legal person as well like a company or such
Create Table Owners(
	OwnerId int Primary key,
	[Name] varchar(100),
	[Address] varchar(100)
);

--not the same as department
Create Table Category(
	CategoryId int primary key,
	CategoryName varchar(50)
)

Create Table Books(
	BookId int Primary Key Identity(1, 1),
	--difference!
	SerialNumber int unique,
	--
	Title varchar(50),
	Author varchar(50),
	CategoryId int references Category(CategoryId) on delete cascade,
	OwnerId int references Owners(OwnerId) on delete cascade
);

--like child, or teenager, or adult this three
Create Table Departments(
	DepartmentId int Primary key,
	DepartmentName Varchar(50)
);

Create Table Librarians(
	LibrarianId int Primary key,
	[Name] Varchar(50), 
	Surname Varchar(50),
	Email Varchar(50),
	DepartmentId int references Departments(DepartmentId) on delete cascade
);

Create Table CustomersBooks(
	CustomersBookId Int primary key identity(1,1),
	BookId int references Books(BookId) on delete cascade,
	CustomerId int references Customers(CustomerId) on delete cascade,
);

Create Table AllLoans(
	LoanId int Primary key,
	CustomersBookId int references CustomersBooks(CustomersBookId) on delete cascade,
	BookId int not null,
	CustomerId int not null, 
	LibrarianId int references Librarians(LibrarianId) on delete cascade,
	StartOfLoan date null, --nullable!
	EndOfLoan date,
	--Constraint REF_AL_CustomersBooks Foreign key (BookId, CustomerId) references CustomersBooks(BookId, CustomerId)
);

Create Table CurrentLoans(
	LoanId int,
	BookId int,
	CustomerId int,
	Constraint FK_CurrLoan_L Foreign Key (LoanId) references AllLoans(LoanId) on delete cascade
);

Create Table Publishers(
	PublisherId int primary key,
	PublisherName Varchar(50)
);

Create Table Publishes(
	 BookId int references Books(BookId) on delete cascade,
	 PublisherId int references Publishers(PublisherId) on delete cascade,
	 Constraint PK_Publishes Primary Key (BookId, PublisherId)
);

Create Table Reviews(
	ReviewId int primary key,
	CustomerBookId int references CustomersBooks(CustomersBookId),
	BookId int not null,
	CustomerId int not null,
	Rating tinyint check (Rating >= 1 AND Rating <= 10),
	Description varchar(1000),
	--Constraint REF_R_CustomersBooks Foreign key (BookId, CustomerId) references CustomersBooks(BookId, CustomerId)
);

Select * from Reviews;
