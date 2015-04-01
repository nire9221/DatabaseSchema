Use Master
Go
if exists
	(Select name from sys.databases 
		where name='ShowTracker')
begin
drop Database ShowTracker
end
Go
Create database ShowTracker
Go
Use ShowTracker
Go
/***********************
* Create tables 
************************/
Create table Venue
(
	VenueKey int identity (1,1) primary key,
	VenueName nvarchar(255) not null,
	VenueAddress nvarchar(255) not null,
	VenueCity nvarchar(255) not null,
	VenueState nchar(2) not null,
	VenueZipCode nchar(10) not null,
	VenuePhone nchar(13) not null,
	VenueEmail nvarchar(255),
	VenueWebPage nvarchar(255),
	VenueAgeRestriction int,
	VenueDateAdded DateTime default GetDate()
)

Go

Create Table Artist
(
	ArtistKey int identity (1,1) primary key,
	ArtistName nvarchar(255) not null,
	ArtistEmail nvarchar(255) not null,
	ArtistWebPage nvarchar(255),
	ArtistDateEntered DateTime default GetDate()
)

Go

Create Table Show
(
	ShowKey int identity(1,1) primary key,
	ShowName nvarchar(255),
	VenueKey int foreign key references Venue(venueKey),
	ShowDate Date not null,
	ShowTime Time not null,
	ShowTicketInfo nvarchar(255) not null,
	ShowDateEntered datetime default GetDate()
)

Go

Create Table ShowDetail
(
	ShowDetailKey int identity(1,1) primary key,
	ShowKey int foreign key references Show(ShowKey),
	ArtistKey int foreign key references Artist(ArtistKey),
	ShowDetailArtistStartTime time not null,
	ShowDetailAdditional nvarchar(255)
)

Go

Create Table Fan
(
	FanKey int identity(1,1) primary key,
	FanName nvarchar(255),
	FanEmail nvarchar(255) not null,
	FanDateEntered datetime default GetDate()
)

Go

Create Table Genre
(
	GenreKey int identity(1,1) primary key,
	GenreName nvarchar(255) not null,
	GenreDescription nvarchar(255) 
)

Go

Create Table ArtistGenre
(	ArtistKey int Foreign key references Artist(ArtistKey),
	GenreKey int Foreign key references Genre(GenreKey),
	Constraint ArtistGenreKey Primary Key (ArtistKey, GenreKey)
)

Go

Create Table FanGenre
(
	FanKey int Foreign key references Fan(FanKey),
	GenreKey int Foreign key references Genre(GenreKey),
	Constraint FanGenreKey Primary Key (FanKey, GenreKey)
)

Go

Create Table FanArtist
(
	FanKey int Foreign key references Fan(FanKey),
	ArtistKey int Foreign key references Artist(ArtistKey),
	Constraint FanArtistKey Primary Key (FanKey, ArtistKey)
)
Go

Create table FanLogin
(
	FanLoginKey int identity (1,1) primary key,
	FanKey int foreign key references Fan(FanKey),
	FanLoginUserName nvarchar(255) not null unique,
	FanLoginPasswordPlain nvarchar(255) not null unique,
	FanLoginRandom int not null,
	FanLoginHashed varbinary(500),
	FanLoginDateAdded DateTime default GetDate()
)

Create Table VenueLogin
(
	VenueLoginKey int identity (1,1) primary key,
	VenueKey int Foreign key references Venue(VenueKey),
	VenueLoginUserName nvarchar(255) not null unique,
	VenueLoginPasswordPlain nvarchar(255) not null unique,
	VenueLoginRandom int not null,
	VenueLoginHashed varbinary(500),
	VenueLoginDateAdded DateTime default GetDate()
)

Go

Create table LoginHistory
(	
	LoginHistorykey int identity(1,1) primary key,
	UserName nvarchar(255) not null,
	LoginHistoryDateTime DateTime default GetDate(),

)

Go

/*******************************
*  Some sample Data
*******************************/
Insert into Venue(VenueName, VenueAddress, VenueCity, VenueState, VenueZipCode, VenuePhone, VenueEmail, VenueWebPage, VenueAgeRestriction)
Values('Comet','1134 Pike','Seattle','WA','98122','2065551000','vomit@comet.com','http://www.comet.com',21),
('BackStage','2014 45th','Seattle','WA','98112','2065551001','shows@Backstage.com','http://www.BackStage.com',21),
('Paramount','801 Pine','Seattle','WA','98112','2065551002','paramount@CityNet.com','http://www.Paramount.com',null)

Insert into Artist(ArtistName, ArtistEmail, ArtistWebPage)
values('Pearl Jam','jamfactor@pearljam.com','http:\\www.pearljam.com'),
('Decemberists','decemberists@portlandarts.com','http:\\www.Decemberists.com'),
('Death Cab for Cutie','deathcab@cutie.com','http:\\www.deathcab.com'),
('Neko Case','neko@nekocase.com','http:\\www.nekocase.com'),
('Baby Gramps','gramps@babygramps.com','http:\\www.babyGramps.com')

Insert into genre(GenreName)
values('Folk'),
('Alternative'),
('Rock'),
('Pop'),
('Hip hop'),
('Jazz'),
('Blues'),
('Grunge'),
('Classical'),
('Ragtime')

Insert into ArtistGenre(ArtistKey, GenreKey)
values(1,2),
(1,3),
(1,8),
(2,1),
(2,2),
(2,3),
(3,2),
(3,4),
(4,1),
(4,2),
(5,1),
(5,10)

Insert into show(ShowName, VenueKey, ShowDate, ShowTime, ShowTicketInfo)
values('Long live the King',3,'2/15/2015','20:00','Paramount or online')

Insert into ShowDetail(ShowKey, ArtistKey, ShowDetailArtistStartTime, ShowDetailAdditional)
values(IDENT_CURRENT('Show'),2,'20:00',null)

Insert into show(ShowName, VenueKey, ShowDate, ShowTime, ShowTicketInfo)
values('Keys',3,'3/1/2015','20:00','Paramount or online')

Insert into ShowDetail(ShowKey, ArtistKey, ShowDetailArtistStartTime, ShowDetailAdditional)
values(IDENT_CURRENT('Show'),4,'20:00','Opening Act')

Insert into ShowDetail(ShowKey, ArtistKey, ShowDetailArtistStartTime, ShowDetailAdditional)
values(IDENT_CURRENT('Show'),3,'21:30','Main Act')

Insert into show(ShowName, VenueKey, ShowDate, ShowTime, ShowTicketInfo)
values('Baby Gramps Live',1,'2/12/2015','20:00','Cover charge $7.00 at door')

Insert into ShowDetail(ShowKey, ArtistKey, ShowDetailArtistStartTime, ShowDetailAdditional)
values(IDENT_CURRENT('Show'),5,'20:00',null)

/***********************************************
* Logins and permissions
************************************************/

if exists
	(Select name from sys.sql_logins where name ='BasicShowTimeLogin')
begin
Drop Login BasicShowTimeLogin
end
go
Create login BasicShowTimeLogin with password='P@ssw0rd1'
Go
Create User BasicUser for login BasicShowTimeLogin
Go
Create role BasicRole
Go
Grant Select on Venue to BasicRole
Grant Select on Artist to BasicRole
Grant Select on Show to BasicRole
Grant Select on ShowDetail to BasicRole
Grant Select on genre to BasicRole
Grant Select on ArtistGenre to BasicRole
Go
exec sp_addrolemember 'BasicRole', 'BasicUser'
Go
if exists
(Select name from sys.sql_logins where name = 'VenueLogin')
Begin
Drop Login VenueLogin
End
Go
Create Login VenueLogin with Password='VenueP@ssword'
Go
Create user VenueUser for login VenueLogin
Go
Create Role VenueRole
Go
Grant Select, Update on Venue to VenueRole
Grant Select, Insert on Artist to VenueRole
Grant Select, Insert, Update on Show to VenueRole
Grant Select, Insert, Update on ShowDetail to VenueRole
Grant Select on genre to VenueRole
Grant Select on ArtistGenre to VenueRole
Grant Select, Insert on VenueLogin to VenueRole
Grant Select, Insert on LoginHistory to VenueRole
go
exec sp_addrolemember 'VenueRole', 'VenueUser'
go

if exists
(Select name from sys.sql_logins where name = 'FanLogin')
Begin
Drop Login FanLogin
End
Go
Create Login FanLogin with Password='FanP@ssword'
Go
Create user FanUser for login FanLogin
Go
Create Role FanRole
Go
Grant Select on Venue to FanRole
Grant Select on Artist to FanRole
Grant Select on Show to FanRole
Grant Select on ShowDetail to FanRole
Grant Select on genre to FanRole
Grant Select on ArtistGenre to FanRole
Grant Select, insert, update on Fan to FanRole
Grant Select, insert on FanGenre to FanRole
Grant Select, insert on FanArtist to FanRole
Grant Select, Insert on FanLogin to fanRole
Grant Select,Insert on LoginHistory to FanRole
go
exec sp_addrolemember 'FanRole', 'FanUser'
go