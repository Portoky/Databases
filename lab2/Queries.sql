Use Library
Go



--a--
Select B.BookId
From Books B, CurrentLoans CL, Owners O
Where CL.BookId = B.BookId AND O.OwnerId = B.OwnerId AND O.[Name] = 'Omnipa SRL 2004'
UNION
Select B.BookId
From Books B, CurrentLoans CL, Owners O
Where CL.BookId = B.BookId AND O.OwnerId = B.OwnerId AND O.[Name] = 'Universitatea Babes-Bolyai';
--?-- can I do that --yes you can
Select B.BookId
From Books B, CurrentLoans CL, Owners O
Where CL.BookId = B.BookId AND O.OwnerId = B.OwnerId AND O.[Name] = 'Omnipa SRL 2004' OR O.[Name] = 'Biblioteca Carturesti srl'

--b--
Select B.BookId
From Books B, Publishes Ps, Publishers Prs
Where B.BookId = Ps.BookId AND Ps.PublisherId = Prs.PublisherId AND Prs.PublisherName = 'Liberty'
INTERSECT
Select B.BookId
From Books B, Publishes Ps, Publishers Prs
Where B.BookId = Ps.BookId AND Ps.PublisherId = Prs.PublisherId AND Prs.PublisherName = 'Uni Pubs';
--
Select C.Surname, C.[Name]
From Customers C where C.CustomerId In
(Select Distinct CustomerId
From CurrentLoans )

--c--
Select C.CustomerId
From Customers C
Except
Select Distinct CustomerId
From CurrentLoans;
--
Select B.BookId
From Books B Inner Join CustomersBooks CB On
	B.BookId = CB.BookId and CB.BookId not in
		(Select R.BookId 
		From Reviews R)
select * from Reviews;

--d--
Select b.BookId, cb.CustomerId, r.Rating
From Books B LEFT JOIN CustomersBooks CB On
	B.BookId = CB.BookId 
	Inner join Reviews R on R.BookId = CB.BookId and R.CustomerId = cb.CustomerId and R.Rating > 5;
Select * from CustomersBooks;

Select *
From Customers C Left Join CustomersBooks CB on
	C.CustomerId = CB.CustomerId 
	Left Join Reviews R on R.CustomerId = CB.CustomerId;
--
Select *
From Books B Right Join CurrentLoans CL on
	B.BookId = CL.BookId
--
Select * 
From Customers C Full Join AllLoans AL on
	C.CustomerId = AL.CustomerId
--the one with for joins! and 2 many to many tables

--choose those customers that already have a loan
-- from those loans choose those books that have been rented
--and from those book chose the publishers that published those books
Select C.CustomerId, B.BookId, Prs.PublisherId
From Customers C Inner Join CustomersBooks CB on
	C.CustomerId = CB.CustomerId Inner Join Books B on
		B.BookId = CB.BookId Inner Join Publishes Ps on
			B.BookId = Ps.BookId Inner Join Publishers Prs on
				Ps.PublisherId = Prs.PublisherId;

select * from CustomersBooks;
select * from Reviews;

--h--
Select Top 3 Count(AL.LibrarianId) as LibrarianCount, AL.BookId BookId
From AllLoans AL 
group by AL.BookId
having  Count(AL.LibrarianId) > 1
ORDER BY Count(AL.LibrarianId) DESC;

Select MAX(CategoryCount) as [Largest number of books in a category]
from (Select Count(CategoryId) as CategoryCount, CategoryId
		From Books B 
		Group By CategoryId) t
 
 --
 --it chooses those customers that have the most diverse loan
 --so it loaned the only different books and the most 
 --gives out if theres a customer who has the most loans with only differenct books
 Select CB.CustomerId
 From CustomersBooks CB
 Group By CB.CustomerId
 Having Count(*) = 
	(Select Max(t.NumberOfLoans) 
	From 
		(Select Count(*) as NumberOfLoans
		From AllLoans AL
		Group By AL.CustomerId) t)
--
--Selects those books that has a better avg rating than 
--those books with the minimum sum of all ratings for them
Select R.BookId, Avg(R.Rating)
From Reviews R
Group By R.BookId
Having Avg(R.Rating) >
	(Select Min(t.SumRating)
	From
		(Select Sum(R2.Rating) as SumRating 
		From Reviews R2
		Group By R2.BookId) t)
--e--
Select *
From Books B
Where B.BookId IN 
	(Select R.BookId
	From Reviews R
	Where Rating >= 8)
--selects those department that have librarians but
--these librearians have not given out a single book yet
Select DepartmentId 
From Departments D
Where D.DepartmentId IN
	(Select L.DepartmentId
	From Librarians L
	Where LibrarianId NOT IN
		(Select AL.LibrarianId
		From AllLoans AL)
	)

--f--
Select top 5  *
From Customers C
Where Exists
	(Select R.CustomerId
	From Reviews R
	Where R.Rating <= 7 And R.CustomerId = C.CustomerId);
--
Select *
From Category Ca
Where Not Exists
	(Select Distinct B.CategoryId
	From Books B
	Where B.CategoryId = Ca.CategoryId)

--g--

Select * 
From (Select * 
	From AllLoans AL
	Where DateDiff(month, AL.StartOfLoan, AL.EndOfLoan) >= 3) t
Where t.LibrarianId = 1;
Select DateDiff(month, '2022-01-01', '2023-01-01');
--
Select t.BookId
From (Select *
	From Reviews R 
	Where LEN(R.[Description]) > 20) t
	Where t.BookId In (
		Select CL.BookId
		From CurrentLoans CL);

--i--
Select R.CustomerId, R.Rating
From Reviews R
Where R.Rating > Any
	(Select R2.Rating
	From Reviews R2
	Where BookId Not in
		(Select CL.BookId
		From CurrentLoans CL))
Order by R.Rating;

Select R.CustomerId, R.Rating
From Reviews R
Where R.Rating >= All
	(Select R2.Rating
	From Reviews R2
	Where BookId Not in
		(Select CL.BookId
		From CurrentLoans CL));
--chose those owners that doesnt own a books (xd)
Select *
From Owners O
Where O.OwnerId <> Any
	(Select B.OwnerId
	From Books B);
--checks if there is all the books have been published by one publisher
Select * 
From Publishers Prs
Where Prs.PublisherId = All
	(Select Ps.PublisherId
	From Publishes Ps)

--i2--Rewrite it
Select R.CustomerId, R.Rating
From Reviews R
Where R.Rating > 
	(Select Min(R2.Rating)
	From Reviews R2
	Where BookId Not in
		(Select CL.BookId
		From CurrentLoans CL));

Select R.CustomerId, R.Rating
From Reviews R
Where R.Rating >=
	(Select Max(R2.Rating)
	From Reviews R2
	Where BookId Not In
		(Select CL.BookId
		From CurrentLoans CL));

Select *
From Owners O
Where O.OwnerId Not In
	(Select B.OwnerId
	From Books B);
--its kind of the inverse version of the other: it returns those Publishers that are not in publishers the therefore you can deduce i there is only one 
Select * 
From Publishers Prs
Where Prs.PublisherId Not In
	(Select Ps.PublisherId
	From Publishes Ps)



Select * From AllLoans;


Select * From Departments;

Select * From Librarians; 

select * from Reviews

Select * from CurrentLoans;

select * from Books;

Select * from CustomersBooks;

Select * from Reviews;