USE Library
GO


--Owner
INSERT INTO Owners(OwnerId, [Name], [Address])
VALUES (1, 'Omnipa SRL 2004', 'Str. Avram 14');

INSERT INTO Owners(OwnerId, [Name], [Address])
VALUES (2, 'Biblioteca Carturesti srl', 'Plaza Mall');

Insert Into Owners(OwnerId, [Name], [Address])
Values (3, 'Universitatea Babes-Bolyai', 'Mihail Kogalniceanu 1');

Select * from Owners;

--Category
Insert Into Category Values (1, 'Fantasy');
Insert Into Category Values (2, 'Crime Fiction');
Insert Into Category Values (3, 'Documentation');
Insert Into Category Values (4, 'Philosophy');
Insert Into Category Values (5, 'Action');
Insert Into Category Values (6, 'Manual');

Select * from Category;

--Books
Insert into Books Values ('Lord of The Rings', 'J. R. Tolkien', 1, 2);
Insert Into Books Values ('C/C++ Documntation', 'Dennis M. Ritchie', 3, 1);
Insert Into Books Values ('Orient Express', 'Agatha Christie', 2, 3);
Insert Into Books Values ('Harry Potter and the Philosophers Stove', 'J.K Rowling', 1, 2);
Insert Into Books Values ('Basics of Hegel', 'Alexendre Kojeve', 4, 1);
Insert Into Books Values ('Winnetou', 'Karl May', 5, 3);
Insert Into Books Values ('Basics of Hegel', 'Alexendre Kojeve', 4, 3);
--Insert Into Books Values (9, 'Continuation of Hegel', 'Alexendre Kojeve', 9, 3);

--error
Insert into Books Values (2, 'harry potter and the prisoner of azkaban', 'jk rowling', 4, 2);

Select * from Books;
--Customers
Insert Into Customers Values ( 'Akos Marton', 'Janos', 'aoaoao@gmail.com', 'Fortuna a/5/64', '2003-06-22');
Insert Into Customers Values ( 'No', 'One', 'idk@gmail.com', 'str nowhere 1/A', '1995-01-01');
Insert Into Customers Values ( 'George', 'Parisol', 'georgee@gmail.com', 'abbey road 5', '1956-01-20');
Insert Into Customers Values ( 'Nowhere', 'Man', 'rubbersoul@gmail.com', 'liverpool street 6', '1965-04-06');
Insert Into Customers Values ( 'John', 'Lennon', 'lennon@gmail.com', 'New York Street 6', '1940-01-01');
Select * from Customers;

--Department
Insert into Departments Values(1, 'Adults');
Insert Into Departments Values(2, 'Teenagers');
Insert Into Departments Values(3, 'Kids');

--Librarians
Insert Into Librarians Values(1, 'Jane', 'Ascher', 'janeascher@yahoo.com', 3);
Insert Into Librarians Values(2, 'Dave', 'Abis', 'itsdave@citromail.com', 1);
Insert Into Librarians Values(3, 'Joe', 'Mama', 'imjoe@gmail.com', 2);
Select * from Librarians;
--Reviews
Insert Into Reviews Values(1, 1, 1, 8, 'Fenomenal fantasy book. Too much description for me though');
Insert Into Reviews Values(2, 3, 2, 10, 'Tears of joy after reading');
Insert Into Reviews Values(3, 4, 2, 8, 'Incredible crimi book');
Insert Into Reviews (ReviewId, BookId, CustomerId, Rating, [Description]) Values(4, 7, 1, 7, 'I did not understand a word');
Select * from Reviews;

--AllLoans
Insert Into AllLoans Values(1, 1, 3, 1, '2023-09-14', '2023-09-28');
Insert Into AllLoans(LoanId, CustomerId, BookId, LibrarianId, StartOfLoan, EndOfLoan) Values(2, 1, 1, 2, '2023-09-28', NULL);
Insert Into AllLoans(LoanId, CustomerId, BookId, LibrarianId, StartOfLoan, EndOfLoan) Values(3, 2, 4, 2, '2023-09-05', '2023-10-11');
Insert Into AllLoans(LoanId, CustomerId, BookId, LibrarianId, StartOfLoan, EndOfLoan) Values(4, 2, 3, 1, '2023-09-05', null);
Insert Into AllLoans(LoanId, CustomerId, BookId, LibrarianId, StartOfLoan, EndOfLoan) Values(5, 4, 6, 2, '2022-09-05', '2022-10-05');
Insert Into AllLoans(LoanId, CustomerId, BookId, LibrarianId, StartOfLoan, EndOfLoan) Values(6, 1, 7, 1, '2022-11-05', '2023-08-15');
Insert Into AllLoans(LoanId, CustomerId, BookId, LibrarianId, EndOfLoan) Values(7, 1, 6, 1, '2023-12-05');

Select * from AllLoans;

--DistinctLoans
Insert Into CustomersBooks(BookId, CustomerId) Values(1, 1);
Insert Into CustomersBooks(BookId, CustomerId) Values(4, 2);
Insert Into CustomersBooks(BookId, CustomerId) Values(3, 2);
Insert Into CustomersBooks(BookId, CustomerId) Values(6, 4);
Insert Into CustomersBooks(BookId, CustomerId) Values(7, 1);
Insert Into CustomersBooks(BookId, CustomerId) Values(6, 1);
Select * from CustomersBooks;

--CurrentLoans
Select * from CurrentLoans;
Insert Into CurrentLoans(LoanId, CustomerId, BookId) Values (2, 1, 1);
Insert Into CurrentLoans(LoanId, CustomerId, BookId) Values (4, 2, 3);

--Publishes
Select * From Publishes;
Insert Into Publishes(BookId, PublisherId) Values(4, 1);
Insert Into Publishes(BookId, PublisherId) Values(6, 2);
Insert Into Publishes(BookId, PublisherId) Values(6, 1);

--Publishers
Select * From Publishers;
Insert Into Publishers(PublisherId, PublisherName) Values(1, 'Uni Pubs');
Insert Into Publishers(PublisherId, PublisherName) Values(2, 'Liberty');

--UPDATES

UPDATE Books
Set Author = 'J.R.R Tolkien'
Where (BookId = 1 Or NOT BookId = 2) And Title = 'Lord of The Rings' And CategoryId between 1 and 3 and Author is not null;

Update Books 
Set Title = 'Harry Potter and the Philosophers Stone'
Where Title Like '%Stove%' and CategoryId < 3;

Update Owners
Set Address = 'Iulius mall'
Where OwnerId = 2;

Update Customers
Set Email = 'janosakosmarton@gmail.com'
where CustomerId = 1;

Delete Books
Where BookId = 5;

delete AllLoans
Where LoanId = 7;

Delete Customers
Where CustomerId IN (3,3);

Update Librarians
Set Email = [Name] + '@citromail.com'
Where LibrarianId Between 1 AND 10 AND [Name] = 'Dave';

Update Reviews 
Set [Description] = 'Fenomenal book, would read it again'
Where Rating >= 9;

Update Reviews
Set [Description] = 'Poorly written book, not recommended'
Where Rating <= 4 AND Rating > 2; 

Delete Reviews
Where Rating <> 10;


delete Books;
delete Reviews;
truncate table Category;
delete AllLoans;
delete Departments;
delete CurrentLoans;
delete Customers;

