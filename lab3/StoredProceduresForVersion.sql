Use Library
Go

Drop procedure uspCustomersBirthFromIntToDate;
Drop procedure uspCustomersBirthFromDateToInt;
Drop procedure uspAddCategoryIdToBooks;
Drop Procedure uspRemoveCategoryIdFromBooks
Drop Procedure uspAddCategoryTable
Drop procedure uspDropCategoryTable
Drop procedure uspAddFKConstraintCategoryIdToBooks
Drop procedure uspRemoveFKConstraintCategoryIdFromBooks
Drop Procedure uspAddDFConstraintAllLoansDate
Drop procedure uspRemoveDFConstraintAllLoansDate
Drop procedure uspAddPKCurrentLoans
Drop procedure uspRemovePKCurrentLoans
Drop procedure uspAddCandidateDepartmentName
Drop procedure uspRemoveCandidateDepartmentName

Go
--a)
CREATE OR ALTER PROC uspCustomersBirthFromIntToDate
AS
	Alter Table Customers
	Alter Column DateOfBirth varchar(20)

	ALTER TABLE Customers
	Alter Column DateOfBirth Date
--inverse
GO

CREATE OR ALTER PROC uspCustomersBirthFromDateToInt
AS
	Alter Table Customers
	Alter Column DateOfBirth varchar(20)

	Alter Table Customers
	Alter Column DateOfBirth int
GO

--b)
CREATE OR ALTER PROC uspAddCategoryIdToBooks
AS 
	Alter Table Books
	Add CategoryId INT
GO

Create OR Alter Proc uspRemoveCategoryIdFromBooks
AS
	Alter Table Books
	DROP Column CategoryId
GO

--g)
Create OR Alter Proc uspAddCategoryTable
AS
	Create Table Category(
	CategoryId int primary key,
	CategoryName varchar(50))
GO

Create OR Alter Proc uspDropCategoryTable
AS
	Drop Table Category
Go

--f
Create OR ALTER Proc uspAddFKConstraintCategoryIdToBooks
AS
	Alter Table Books
	Add Constraint FK_BOOKS_CategoryId foreign key(CategoryId) references Category(CategoryId)
Go

Create OR Alter Proc uspRemoveFKConstraintCategoryIdFromBooks
AS
	Alter Table Books
	Drop Constraint FK_BOOKS_CategoryId
GO

--c
Create OR Alter Proc uspAddDFConstraintAllLoansDate
AS 
	Alter Table AllLoans
	ALTER COLUMN StartOfLoan Date NOT NULL;
	
	Alter Table AllLoans
	ADD CONSTRAINT DF_AllLoans_StartDate
	 DEFAULT Convert(date, GETDATE()) FOR StartOfLoan;
GO

Create OR Alter Proc uspRemoveDFConstraintAllLoansDate
AS 
	Alter Table AllLoans
	Drop Constraint DF_AllLoans_StartDate;
	Alter Table AllLoans
	ALTER COLUMN StartOfLoan Date NULL;
GO
--d
Create Or Alter Proc uspAddPKCurrentLoans
AS
	Alter Table CurrentLoans
	Add CurrentLoanId int not null
	Constraint PK_CurrentLoanId Primary Key (CurrentLoanId) 
GO

Create Or Alter Proc uspRemovePKCurrentLoans
AS
	Alter Table CurrentLoans
	Drop Constraint PK_CurrentLoanId

	Alter Table CurrentLoans
	Drop Column CurrentLoanId
GO
--e
Create Or Alter Proc uspAddCandidateDepartmentName
AS
	Alter Table Departments
	Add Constraint UC_DepartmentName Unique(DepartmentName)
Go

Create Or Alter Proc uspRemoveCandidateDepartmentName
AS
	Alter Table Departments
	Drop Constraint UC_DepartmentName
Go


Create Table UpdateVersion(
	ProcName varchar(50),
	NextVersion int 
);

Create Table DowndateVersion(
	ProcName varchar(50),
	PrevVersion int 
);

Insert Into UpdateVersion Values('uspCustomersBirthFromDateToInt', 1);
Insert Into DownDateVersion Values('uspCustomersBirthFromIntToDate', 0);

Insert Into UpdateVersion Values('uspRemoveFKConstraintCategoryIdFromBooks', 2);
Insert Into DownDateVersion Values('uspAddFKConstraintCategoryIdToBooks', 1);

Insert Into UpdateVersion Values('uspRemoveCategoryIdFromBooks', 3);
Insert Into DownDateVersion Values('uspAddCategoryIdToBooks', 2);

Insert Into UpdateVersion Values('uspDropCategoryTable', 4);
Insert Into DownDateVersion Values('uspAddCategoryTable', 3);

Insert Into UpdateVersion Values('uspAddDFConstraintAllLoansDate', 5);
Insert Into DowndateVersion Values('uspRemoveDFConstraintAllLoansDate', 4);

Insert Into UpdateVersion Values('uspAddCandidateDepartmentName', 6);
Insert Into DowndateVersion Values('uspRemoveCandidateDepartmentName', 5);

Insert Into UpdateVersion Values('uspAddPKCurrentLoans', 7);
Insert Into DownDateVersion Values('uspRemovePKCurrentLoans', 6);

Select * From UpdateVersion;
Select * From DowndateVersion;

Create Table CurrentVersion(
	curr int
);
Insert Into CurrentVersion Values(0);
Update CurrentVersion set curr = 0 where curr = 7


--Implement the mechanism itself!
-------------------------------------------------
Go
Create Or Alter Proc uspChangeVersion(@ChangeVersion INT) 
AS
	Declare	@current int;
	Select @current = curr --get current version
	From CurrentVersion;

	if @ChangeVersion > @current AND @ChangeVersion <= 7
	Begin

		Declare @NextVersion int, @SPName Varchar(50)

		Declare VersionCursor CURSOR For
				Select ProcName,NextVersion
				From UpdateVersion 
				Order By NextVersion

		Open VersionCursor;
		Fetch next from VersionCursor
			Into @SPName, @NextVersion

		While @@FETCH_STATUS = 0 AND @NextVersion <= @ChangeVersion
		Begin 
			If @NextVersion > @current
			Begin
				Print @SPname
				EXEC (@SPName)
			End
			Fetch Next from VersionCUrsor
				Into @SPName, @NextVersion
		End

		Update CurrentVersion 
		set curr = @ChangeVersion
		where curr = @current

		Close VersionCursor
		Deallocate VersionCursor;
	End
	
	Else If @ChangeVersion < @current AND @ChangeVersion >= 0
	Begin
		
		Declare	@current2 int;
		Select @current2 = curr --get current version
		From CurrentVersion;
		Declare @PrevVersion int, @SPName2 Varchar(50)

		Declare VersionCursor CURSOR For
				Select ProcName,PrevVersion
				From DowndateVersion
				Order By PrevVersion Desc

		Open VersionCursor;
		Fetch next from VersionCursor
			Into @SPName2, @PrevVersion

		While @@FETCH_STATUS = 0 AND @PrevVersion >= @ChangeVersion
		Begin 
			If @PrevVersion < @current2
			Begin
				Print @SPName2
				EXEC (@SPName2)
			End
			Fetch Next from VersionCUrsor
				Into @SPName2, @PrevVersion
		End

		Update CurrentVersion 
		set curr = @ChangeVersion
		where curr = @current2

		Close VersionCursor
		Deallocate VersionCursor;
	End
	Print 'Done'
Go

Select * From CurrentVersion;



select * from Customers;
select * from Books;
select * from Category;
select * from AllLoans;
select * from Departments;
select * from CurrentLoans;
EXEC uspChangeVersion 0;

select * from sys.columns;

SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
Inner Join sys.types t ON c.system_type_id = t.system_type_id
WHERE c.object_id = OBJECT_ID('Books') --insert table name


--select  into !! you need a cursor to iterate through and fetch the values of the fieldds into a column

select Object_id('Books');

select * From Books;

Select Max(CategoryId)
From Books
Group By CategoryId;
