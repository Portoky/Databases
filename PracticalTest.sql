Use Birthday
Go

Drop Table Guest;
Drop Table Performance;
Drop Table Band;
Drop Table Tent;
Drop Table Caterer;


Create Table Caterer(
	CatererId int primary key,
	[Name] varchar(50),
	[Address] varchar(50),
	IsVegetarian Bit
)

Create Table Tent(
	TentId int primary key,
	[Name] varchar(50),
	Capacity int,
	CatererId int references Caterer(CatererId)
)

Create Table Band(
	BandId int primary key,
	[Name] varchar(50),
	Genre varchar(50),
	Fee int
)

Create Table Performance(
	BandId int references Band(BandId),
	TentId int references Tent(TentId),
	StartTime time,
	EndTime time,
	Constraint PK_Performance Primary Key(BandId, TentId)
)

Create Table Guest(
	GuestId int primary key,
	[Name] varchar(50),
	Birth date,
	TentId int references Tent(TentId)
)

Insert Into Band Values(1, 'a', 'a', 100), (2, 'b', 'b', 200);
Insert Into Band Values(3, 'c', 'c', 100000);
Insert Into Caterer Values(1, 'caterer1', 'aaa', 1), (2, 'caterer2', 'bbb', 0)
Insert Into Tent Values(1, 'tent1', 200, 1), (2, 'tent2', 5000, 2), (3, 'tent3',4200, 1);
Insert Into Tent Values(4, 'tent4', 200, 1);
Insert Into Performance Values(1, 1, '05:15:00', '06:15:00'), (1, 2, '15:00:00', '16:00:00');
Insert Into Performance Values(1, 4, '05:15:00', '06:15:00'), (2, 4, '15:00:00', '16:00:00'), (3, 4, '05:00:00', '06:00:00');

Select * From Performance;
--2
Go
Create Or Alter Proc RemovePerfs(@F int, @T time)
As
Begin
	Delete Performance
	From Performance P 
	Inner Join Band B on B.BandId = P.BandId
	Where P.EndTime < @T AND B.Fee > @F;
End

Exec RemovePerfs 99, '12:00:00'


--3
Go
Create View TentView 
As
	Select T.Name
	From Tent T 
		Inner Join Performance P On T.TentId = P.TentId
			Inner Join Band B on B.BandId = P.BandId
				Group By P.TentId, T.Name
				Having Sum(B.Fee) > 40000 AND Count(*) >= 3
Go

Select * from TentView

Create Function VeggieTents(@P Int, @providesVegMenu Bit)
REturns @ResTab Table([Name] varchar(50))
As
Begin
	Insert Into @ResTab
	Select TT.Name
	From (Select T.TentId
			From Tent T Inner Join Performance perf on T.TentId = perf.TentId 
			Group By (T.TentId) 
			Having Count(perf.TentId) >= @P) t2 
		Inner Join Tent TT on t2.TentId = TT.TentId 
			inner Join Caterer C on TT.CatererId =C.CatererId and C.IsVegetarian = @providesVegMenu
	Return
End
Go
Select * from VeggieTents(3, 1);

