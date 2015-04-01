Use master
go
if exists
	(Select name from sys.Databases 
	  where name='BookReviewDb')
begin
Drop Database BookReviewDb
end
Go
Create Database BookReviewDb
Go
Use BookReviewDB
Go
/*******************************************
*Create tables
*******************************************/
Create Table Book
(
   BookKey int identity(1,1) primary key,
   BookTitle Nvarchar(255) not null,
   BookEntryDate DateTime not null default GetDate(),
   BookISBN nvarchar(13) null
)

Go

Create Table Author
(
  AuthorKey int identity(1,1) primary key,
  AuthorName nvarchar(255) not null,
)

Go
Create Table AuthorBook
(
   BookKey int not null,
   Authorkey int not null,
   constraint PK_BookAuthor Primary key(BookKey, AuthorKey),
   constraint FK_Author Foreign Key (AuthorKey) 
			references Author(AuthorKey),
   Constraint FK_Book Foreign Key (BookKey) 
			references Book(BookKey)
)
Go
Create Table Category
(
   CategoryKey int identity(1,1) primary key,
   CategoryName nvarchar(255)
)

Go
Create Table BookCategory
(
   CategoryKey int not null,
   BookKey int not null,
   Constraint PK_BookCategory Primary Key (CategoryKey, BookKey),
   Constraint FK_Category Foreign Key (CategoryKey)
		references Category (CategoryKey),
	Constraint FK_BookCat Foreign Key (BookKey)
		references Book (BookKey)


)

Go
Create table Reviewer
(
	ReviewerKey int identity(1,1) Primary key,
	ReviewerUserName Nvarchar(255) not null,
	ReviewerFirstName Nvarchar(255) null,
	ReviewerLastName Nvarchar(255) not null,
	ReviewerEmail Nvarchar(255) not null,
	ReviewerKeyCode int not null,
	ReviewPlainPassword Nvarchar(255) not null,
	ReviewerHashedPass VarBinary(500) not null,
	ReviewerDateEntered Date default GetDate()

)
Go
Create table Review
(
	ReviewKey int identity(1,1) primary key,
	BookKey int not null,
	ReviewerKey int not null,
	ReviewDate Date not null default GetDate(),
	ReviewTitle nvarchar(255) null,
	ReviewRating int not null,
	ReviewText Nvarchar(max) null,
	Constraint FK_BookRev Foreign Key(BookKey)
		References Book(BookKey),
	Constraint Fk_Reviewer Foreign Key (ReviewerKey)
		References Reviewer (ReviewerKey),
	Constraint chk_Rating Check (ReviewRating Between 0 and 5)

)

Go 
Create table CheckinLog
(
   CheckInLogKey int identity(1,1) primary key,
   ReviewerKey int not null,
   CheckinDateTime DateTime not null default GetDate(),
   Constraint FK_ReviewerCheckIn Foreign Key (ReviewerKey)
		References Reviewer(ReviewerKey)
)

Go
/*********************************************
* Begin inserts into some of the tables
*********************************************/
Insert into category(CategoryName)
values('Fiction'),
('Science Fiction'),
('Fantasy'),
('Romance'),
('Classic'),
('Romance'),
('Young Adult'),
('Horror'),
('Poetry'),
('History'),
('Biography'),
('Graphic Novel'),
('Myth'),
('Science'),
('Socialology'),
('Economics'),
('Travel'),
('Self Help'),
('Psychology'),
('Philosophy'),
('Music'),
('Film'),
('Television'),
('Politics'),
('Language'),
('technology')

Go

Insert into Author(AuthorName)
Values('David Foster Wallace'),
('Michel Foucault'),
('Jon Duckett'),
('Brian Green'),
('Pablo Neruda'),
('KIm Stanley Robinson'),
('Don Delilo'),
('Gilles Delueze'),
('Felix Guattari')

Go

Insert into Book(BookTitle, BookISBN)
Values('What is Philosophy', '0231079893'),
('Underworld', '0965664120'),
('JavaScript and JQuery', '9781118531648'),
('The elegant Universe', '0965088806'),
('All the Odes', '9780374115289'),
('Shaman','9781841499994'),
('Infinite Jest', '0316066524')

Go
Insert into AuthorBook(BookKey, AuthorKey)
Values(1,8),
(1,9),
(2,7),
(3,3),
(4,4),
(5,5),
(6,6),
(7,1)

Go
Insert into BookCategory(CategoryKey, BookKey)
Values(20,1),
(1,2),
(26,3),
(14,4),
(9,5),
(2,6),
(1,7),
(1,5)

/******************************************
* Create logins, users and roles
******************************************/

if exists
	(Select name from sys.sql_logins where name = 'GeneralLogIn')
Begin
Drop login GeneralLogIn
End
Go
Create Login GeneralLogIn with password ='P@ssw0rd1'
go
Create User GeneralUser for login GeneralLogIn
Go
Create role GeneralRole
Go
Grant select on Author to GeneralRole
Grant Select on Book to GeneralRole
Grant Select on AuthorBook to GeneralRole
Grant Select on Category to GeneralRole
Grant Select on BookCategory to GeneralRole
Grant Select on Reviewer to GeneralRole
Grant Select on Review to GeneralRole
Go
Exec sp_addrolemember 'GeneralRole','GeneralUser'
Go
if exists
	(Select name from sys.sql_logins where name = 'ReviewerLogIn')
Begin
Drop login ReviewerLogIn
End
Go
Create Login ReviewerLogIn with password='P@ssw0rd2'
Go
Create user ReviewerUser for login ReviewerLogin
go
Create role ReviewerRole
Go
Grant Select, Insert, Update on Author to ReviewerRole
Grant Select, Insert, Update on Book to ReviewerRole
Grant Select, Insert, Update on AuthorBook to ReviewerRole
Grant Select, Insert, Update on Category to ReviewerRole
Grant Select, Insert, Update on BookCategory to ReviewerRole
Grant Select, Insert, Update on Review to ReviewerRole
Grant Select, Insert, Update on Reviewer to ReviewerRole
Grant Select, Insert on CheckinLog to ReviewerRole

exec sp_addrolemember 'ReviewerRole', 'ReviewerUser'