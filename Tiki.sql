﻿USE master
GO
IF DB_ID('QL_BHOL') IS NOT NULL
	DROP DATABASE QL_BHOL

GO
CREATE DATABASE QL_BHOL
GO
USE QL_BHOL

CREATE TABLE Customer(
	Id_Customer INT IDENTITY(1,1),
	Customer_Email VARCHAR(30) UNIQUE,
	Customer_Phone VARCHAR(10) UNIQUE,
	Customer_Password VARCHAR(25)
	CONSTRAINT PK_C
	PRIMARY KEY (Id_Customer)
)

CREATE TABLE CustomerInfo (
	Id_Customer INT,
	Customer_Name NVARCHAR(255),
	Customer_Gender BIT,
	Customer_Birthday DATE
	CONSTRAINT PK_CI
	PRIMARY KEY (Id_Customer)
)


CREATE TABLE Supplier (
	Id_Supplier INT,
	Supplier_Name NVARCHAR(255),
	Supplier_Phone CHAR(11),
	Supplier_Address CHAR(30),
	Supplier_Website CHAR(30),
	Supplier_IdTax CHAR(30),
	CONSTRAINT PK_S
	PRIMARY KEY (Id_Supplier)
)


CREATE TABLE TypeGood (
	Id_TG INT,
	TG_Name NVARCHAR(100),
	TG_URL VARCHAR(50)
	CONSTRAINT PK_TG
	PRIMARY KEY (Id_TG)
)

CREATE TABLE GoodDetail (
	Id_GD INT IDENTITY(1,1),
	GD_Name NVARCHAR(255),
	GD_Color NVARCHAR(10),
	GD_Size NCHAR(4),
	GD_Price MONEY,
	GD_Remain INT,
	GD_Sold INT,
	GD_Discount_Rate FLOAT,
	GD_Rating_AVG FLOAT,
	Thumbnail_URL NTEXT,
	Thumbnail_width FLOAT,
	Thumbnail_height FLOAT, 
	Id_Good INT,
	Id_TG INT,
	Id_Supplier INT,
	Supplier_Name NVARCHAR(255),
	Specification_Type NVARCHAR(200)
	CONSTRAINT PK_GD
	PRIMARY KEY (Id_GD)
)

CREATE TABLE GoodPresented(
	Id_Good INT IDENTITY(1, 1),
	GD_Name NVARCHAR(255),
	GD_Price MONEY,
	GD_Discount_Rate FLOAT,
	GD_Rating_AVG FLOAT,
	Thumbnail_URL NTEXT,
	Id_Supplier INT,
	Supplier_Name NVARCHAR(255),
	Product_Group NVARCHAR(255)
	CONSTRAINT PK_GP
	PRIMARY KEY (Id_Good)
)

CREATE TABLE Warehouse(
	Id_WH INT IDENTITY(1, 1),
	WH_Name NVARCHAR(255),
	WH_Address NVARCHAR(255),
	WH_Hotline CHAR(11)
	CONSTRAINT PK_WH
	PRIMARY KEY (Id_WH)
)

CREATE TABLE Good_Warehouse(
	Id_Good_Warehouse INT IDENTITY(1, 1),
	Id_GD INT,
	Id_WH INT,
	Supplier_Name CHAR(30),
	Number INT,
	CONSTRAINT PK_Good_Warehouse
	PRIMARY KEY (Id_Good_Warehouse)
)


CREATE TABLE Good_Cart(
	Id_Good_Cart INT IDENTITY(1, 1),
	Id_GD INT,
	Id_Customer INT,
	GC_Number INT,
	WH_Hotline CHAR(11)
	CONSTRAINT PK_Good_Cart
	PRIMARY KEY (Id_Good_Cart)
)


CREATE TABLE TypePay(
	Id_TP INT IDENTITY(1, 1),
	TP_Name NVARCHAR(128)
	CONSTRAINT PK_TP
	PRIMARY KEY (Id_TP)
)


CREATE TABLE StatusInvoice(
	Id_StatusInvoice INT IDENTITY(1, 1),
	StatusInvoice_Name CHAR(30)
	CONSTRAINT PK_SI
	PRIMARY KEY (Id_StatusInvoice)
)

CREATE TABLE DeliveryInformation(
	Id_DI INT IDENTITY(1, 1),
	Id_Customer INT,
	DI_PhoneNumber CHAR(11),
	DI_Name CHAR(30),
	DI_Address CHAR(30),
	DI_Ward CHAR(30),
	DI_District CHAR(30),
	DI_Province CHAR(30) 
	CONSTRAINT PK_DI
	PRIMARY KEY (Id_DI)
)

CREATE TABLE TypeVoucher(
	Id_TV INT IDENTITY(1,1),
	TV_Name NVARCHAR(255) 
	CONSTRAINT PK_TV
	PRIMARY KEY (Id_TV)
)

CREATE TABLE Voucher(
	Id_Voucher INT IDENTITY(1, 1),
	Voucher_Name NVARCHAR(255),
	Voucher_StartDate DATE,
	Voucher_EndDate DATE,
	Id_TV INT,
	Voucher_Value INT,
	CONSTRAINT PK_Voucher
	PRIMARY KEY (Id_Voucher)
)

CREATE TABLE PublicVoucher(
	Id_PublicVoucher INT,
	Voucher_Remain INT
	CONSTRAINT PK_PublicVoucher
	PRIMARY KEY (Id_PublicVoucher)
)

CREATE TABLE PersonalVoucher(
	Id_PersonalVoucher INT,
	VoucherEachPerson INT
	CONSTRAINT PK_PersonalVoucher
	PRIMARY KEY (Id_PersonalVoucher)
)

CREATE TABLE Customer_PersonalVoucher(
	Id_Customer INT,
	Id_PersonalVoucher INT,
	Voucher_Remain INT
	CONSTRAINT PK_C_PersonalVoucher
	PRIMARY KEY (Id_Customer, Id_PersonalVoucher)
)


CREATE TABLE Customer_PublicVoucher(
	Id_Customer INT,
	Id_PublicVoucher INT
	CONSTRAINT PK_C_PublicVoucher
	PRIMARY KEY (Id_Customer, Id_PublicVoucher)
)

CREATE TABLE Invoice(
	Id_Invoice INT IDENTITY(1, 1),
	Invoice_InvoiceDate DATE,
	Invoice_TotalPrice MONEY,
	Id_StatusInvoice INT,
	Id_ShipVoucher INT,
	Id_ProductVoucher INT,
	Id_TP INT,
	Id_DI INT,
	Id_Customer INT
	CONSTRAINT PK_Invoice
	PRIMARY KEY (Id_Invoice)
)

CREATE TABLE Good_Invoice(
	Id_GD INT,
	Id_Invoice INT,
	GD_Name CHAR(30),
	GD_Price MONEY,
	Supplier_Name CHAR(30),
	GI_Number INT
	CONSTRAINT PK_Good_Invoice
	PRIMARY KEY (Id_GD,Id_Invoice)
)

CREATE TABLE DeliveryOrder(
	Id_DO INT IDENTITY(1,1),
	Id_Invoice INT,
	DO_DateDelivery DATE,
	CONSTRAINT PK_DeliveryOrder
	PRIMARY KEY (Id_DO)
)

CREATE TABLE Good_Delivery(
	Id_Good_Warehouse INT,
	Id_DO INT,
	Id_Invoice INT,
	GoodNumber INT
	CONSTRAINT PK_Good_Delivery
	PRIMARY KEY (Id_Good_Warehouse, Id_DO)
)


ALTER TABLE dbo.CustomerInfo
ADD CONSTRAINT FK_CI_C
	FOREIGN KEY (Id_Customer)
	REFERENCES dbo.Customer


ALTER TABLE dbo.GoodDetail
ADD CONSTRAINT FK_GD_TG
	FOREIGN KEY (Id_TG)
	REFERENCES dbo.TypeGood

ALTER TABLE dbo.GoodDetail
ADD CONSTRAINT FK_GD_Supplier
	FOREIGN KEY (Id_Supplier)
	REFERENCES dbo.Supplier

	
ALTER TABLE dbo.Good_Warehouse
ADD CONSTRAINT FK_GW_WH
	FOREIGN KEY (Id_WH)
	REFERENCES dbo.Warehouse

ALTER TABLE dbo.Good_Warehouse
ADD CONSTRAINT FK_GW_GD
	FOREIGN KEY (Id_GD)
	REFERENCES dbo.GoodDetail


ALTER TABLE dbo.Good_Cart
ADD CONSTRAINT FK_GC_C
	FOREIGN KEY (Id_Customer)
	REFERENCES dbo.Customer

ALTER TABLE dbo.Good_Cart
ADD CONSTRAINT FK_GC_GD
	FOREIGN KEY (Id_GD)
	REFERENCES dbo.GoodDetail

ALTER TABLE dbo.DeliveryInformation
ADD CONSTRAINT FK_DI_C
	FOREIGN KEY (Id_Customer)
	REFERENCES dbo.Customer


ALTER TABLE dbo.Voucher
ADD CONSTRAINT FK_Voucher_TV
	FOREIGN KEY (Id_TV)
	REFERENCES dbo.TypeVoucher


ALTER TABLE dbo.PublicVoucher
ADD CONSTRAINT FK_PublicVoucher_Voucher
	FOREIGN KEY (Id_PublicVoucher)
	REFERENCES dbo.Voucher

ALTER TABLE dbo.PersonalVoucher
ADD CONSTRAINT FK_PersonalVoucher_Voucher
	FOREIGN KEY (Id_PersonalVoucher)
	REFERENCES dbo.Voucher


ALTER TABLE dbo.Invoice
ADD CONSTRAINT FK_Invoice_SI
	FOREIGN KEY (Id_StatusInvoice)
	REFERENCES dbo.StatusInvoice

ALTER TABLE dbo.Invoice
ADD CONSTRAINT FK_Invoice_ShipVoucher
	FOREIGN KEY (Id_ShipVoucher)
	REFERENCES dbo.Voucher

	
ALTER TABLE dbo.Invoice
ADD CONSTRAINT FK_Invoice_ProductVoucher
	FOREIGN KEY (Id_ProductVoucher)
	REFERENCES dbo.Voucher

ALTER TABLE dbo.Invoice
ADD CONSTRAINT FK_Invoice_TP
	FOREIGN KEY (Id_TP)
	REFERENCES dbo.TypePay
	
ALTER TABLE dbo.Invoice
ADD CONSTRAINT FK_Invoice_DI
	FOREIGN KEY (Id_DI)
	REFERENCES dbo.DeliveryInformation

	
ALTER TABLE dbo.Invoice
ADD CONSTRAINT FK_Invoice_Customer
	FOREIGN KEY (Id_Customer)
	REFERENCES dbo.Customer


ALTER TABLE dbo.Good_Invoice
ADD CONSTRAINT FK_GI_GD
	FOREIGN KEY (Id_GD)
	REFERENCES dbo.GoodDetail

	
ALTER TABLE dbo.Good_Invoice
ADD CONSTRAINT FK_GI_Invoice
	FOREIGN KEY (Id_Invoice)
	REFERENCES dbo.Invoice


ALTER TABLE dbo.DeliveryOrder
ADD CONSTRAINT FK_DO_Invoice
	FOREIGN KEY (Id_Invoice)
	REFERENCES dbo.Invoice

ALTER TABLE dbo.Good_Delivery
ADD CONSTRAINT FK_GoodDelivery_GW
	FOREIGN KEY (Id_Good_Warehouse)
	REFERENCES dbo.Good_Warehouse

ALTER TABLE dbo.Good_Delivery
ADD CONSTRAINT FK_GoodDelivery_DO
	FOREIGN KEY (Id_DO)
	REFERENCES dbo.DeliveryOrder

ALTER TABLE dbo.Good_Delivery
ADD CONSTRAINT FK_GoodDelivery_Invoice
	FOREIGN KEY (Id_Invoice)
	REFERENCES dbo.Invoice

ALTER TABLE dbo.Customer_PersonalVoucher
ADD CONSTRAINT FK_CPersonalV_PersonalVoucher
	FOREIGN KEY (Id_PersonalVoucher)
	REFERENCES dbo.PersonalVoucher
	
ALTER TABLE dbo.Customer_PersonalVoucher
ADD CONSTRAINT FK_CPersonalV_Customer
	FOREIGN KEY (Id_Customer)
	REFERENCES dbo.Customer

	
ALTER TABLE dbo.Customer_PublicVoucher
ADD CONSTRAINT FK_CPersonalV_PublicVoucher
	FOREIGN KEY (Id_PublicVoucher)
	REFERENCES dbo.PublicVoucher
	
ALTER TABLE dbo.Customer_PublicVoucher
ADD CONSTRAINT FK_CPublicV_Customer
	FOREIGN KEY (Id_Customer)
	REFERENCES dbo.Customer
GO
------------------------------------------------------------
INSERT INTO dbo.TypePay
(
    TP_Name
)
VALUES ( 'MoMo'),
	( 'COD'),
	('Banking')

INSERT INTO dbo.StatusInvoice
(
    StatusInvoice_Name
)
VALUES
( N'Đang xác nhận'),
( N'Đang giao'),
( N'Đã hoàn tất')

INSERT INTO dbo.Warehouse
(
    WH_Name,
    WH_Address,
    WH_Hotline
)
VALUES
('Kho1', 'HCM', '0915253236'),
('Kho2', 'HCM', '0915253246'),
('Kho3', 'HCM', '0915253216'),
('Kho4', 'HN', '0915253296'),
('Kho5', 'HN', '0915253336'),
('Kho6', 'HN', '0915253736'),
('Kho7', 'DN', '0915257236'),
('Kho8', 'DN', '0915853236'),
('Kho9', 'DN', '0915353236'),
('Kho10', 'HCM', '0915253231'),
('Kho11', 'HCM', '0915253232')

DROP PROCEDURE IF EXISTS dbo.gen_typeGood
go
CREATE PROCEDURE gen_typeGood 
AS
BEGIN
	DECLARE @typeName NVARCHAR(255)
	DECLARE @id INT
	SET @id = 1
	DECLARE CURSOR1 CURSOR FOR SELECT Product_group FROM dbo.GoodPresented GROUP BY Product_group
	OPEN CURSOR1

	FETCH NEXT FROM CURSOR1 INTO @typeName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO dbo.TypeGood
		(Id_TG,
		    TG_Name
		)
		VALUES
		(@id, @typeName)
		SET @id = @id +1
		FETCH NEXT FROM CURSOR1 INTO @typeName
	END
	CLOSE CURSOR1              -- Đóng Cursor
DEALLOCATE CURSOR1
END
GO
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tosbaldstone0@linkedin.com', '5332003866', 'DKuv9Y7TpKc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmeadus1@domainmarket.com', '7759521704', 'opIGRI6z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msimione2@altervista.org', '2663804433', 'r7WJBNDk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgraffham3@mlb.com', '2332956479', 'Uz7xXWVe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jkenton4@msu.edu', '7083514233', 'gvBkW2Ju');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lsouthcoat5@oracle.com', '8804279951', 'nQOz6YRw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jjurkowski6@dion.ne.jp', '9933530072', 'r6VJ1gjR9WA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eyeandel7@friendfeed.com', '2936995125', 'ccYc7NX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddunstan8@sogou.com', '8479324411', 'RQNeySF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('starpey9@spiegel.de', '2683192810', 'S5JY4FJ8xT7e');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hcleevera@buzzfeed.com', '5729630265', 'fmJorG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpaffotb@gravatar.com', '4706747507', 'QKD2nU2CmhS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zdoerfferc@alexa.com', '8693483571', 'xbx1Qr4cmN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('creyned@auda.org.au', '1657537624', '9MLu3jO02uaP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('educhatele@vistaprint.com', '5735425833', '7huNtMEHA3y4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ejindraf@usatoday.com', '6267710123', 'BLphwj4w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbramhallg@freewebs.com', '1269683216', '0JtcNMEYBJh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccodnerh@imageshack.us', '2466453020', 'CQqxnvk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmcveighi@stumbleupon.com', '5673495210', 'xSz4hRFtOy18');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpashenkovj@zdnet.com', '9319095512', 'P1QU8EKMeI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ggascark@vk.com', '3922516924', 'TQvvYG3Gnx8S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('beayrsl@t.co', '6396376796', 'QR5cWVzFY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dnapolitanom@state.gov', '4699065761', 'vasLQnBV64Mi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsiebartn@wsj.com', '4191650499', 'b8pcpmzu5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('psurgeonero@spotify.com', '7466062196', 'WjtGiG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hlawrensonp@twitter.com', '1083100697', 'imf1IkeFMQB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gspybyq@latimes.com', '7032770955', 'xZbPQr3OfJGi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcritcherr@1688.com', '8972792674', 'CgzZVM5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fharriagns@surveymonkey.com', '3569214618', 'DamiHkTwFY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nconigsbyt@squidoo.com', '8649512886', 'Gs3Kub5C1U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pogleyu@sohu.com', '6124994040', 'Cqzrwcfj0yn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlangcastlev@ucla.edu', '8741620563', 'mZZdYIA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpinillaw@nyu.edu', '5617837493', 'CpUpMAU3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atchirx@weather.com', '7793117746', 'HVR3TNgYd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('greinischy@myspace.com', '2973233095', 'DFNBGy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kchelamz@feedburner.com', '4879271782', '8ADgLxSJbXP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmerryfield10@google.de', '7126292467', 'IOprrR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scullen11@gnu.org', '3004220233', '7ixHLLFn4sP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vwestell12@yandex.ru', '9896908763', 'v8x1gAS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsaxelby13@istockphoto.com', '5059128687', 'DtWBzRit5a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccamilletti14@bravesites.com', '6534737542', 'QoHxkB1J4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcurzey15@vkontakte.ru', '3212840677', '7Ad6rYje');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cspiniello16@fastcompany.com', '9892962714', 'Bjp4gM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdomico17@cafepress.com', '5947839852', 'ZQ0kQlOVe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emackenzie18@clickbank.net', '9304168547', 'OdeGYqoJbhU1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdessant19@sourceforge.net', '8177726615', 'Lba6eCA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgroundwator1a@businessweek.com', '3804743341', 'niOFShAVGm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jyarrington1b@businessweek.com', '5736059507', '0HX8BIJKjNlC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rtidbold1c@tumblr.com', '2125608373', 'QNYga9047');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kaitken1d@nytimes.com', '1982917079', 'Q7pUFNw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fwestern1e@php.net', '1172580236', 'Cg22uZJYnXl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sklezmski1f@infoseek.co.jp', '9686892384', 'EowjXQdB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgannicleff1g@hc360.com', '7433486899', '6cY0WWq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agrigsby1h@microsoft.com', '4327328861', 'nQhtVI60Ht');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpretley1i@hc360.com', '9446689462', 'xMLwm2wCQr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jklimas1j@about.me', '4919080868', 'n2O87NqD7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ecrus1k@rakuten.co.jp', '2469000049', '7aq0ZlC6uNo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ryearnes1l@comsenz.com', '2707705447', 'PpmRkVRiY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vtibbs1m@cbslocal.com', '4853769554', '1gzlpK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccleugher1n@i2i.jp', '8144837351', 'fiAPXJ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lyapp1o@about.me', '3021734205', 'VGzpLxH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sblacksell1p@cyberchimps.com', '6047260032', 'vWQFxuS9SLH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vgioani1q@clickbank.net', '4225013845', 'BUcQot');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pwegner1r@ebay.co.uk', '1741226807', 'E9vzFwlu0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nrobelow1s@woothemes.com', '9584857469', 'WfxF6m2oj01');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ttallon1t@sohu.com', '7887940073', 'KpHxPMhuvg7y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhuffey1u@theatlantic.com', '9995364013', 'VBPtM6L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nference1v@rediff.com', '1146593188', 'q09qXgGTM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsnelson1w@macromedia.com', '5815508011', 'PbizBLf40');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dkinsman1x@dagondesign.com', '2167978031', '7dJ72W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtebbit1y@prlog.org', '2764465582', 'IpdvHe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acassely1z@list-manage.com', '3191481264', '2OuChfYfg8fu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcrang20@eventbrite.com', '8354495246', 'hvF2HuDpE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swyche21@goo.ne.jp', '3316094837', 'ezAq6Ii');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jrushforth22@icio.us', '7044217108', 'hIJVq2Jcwa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdequesne23@noaa.gov', '4558725193', 'yHBAfGM0Wn2U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebrychan24@samsung.com', '8188796848', 'ICq4kxRs2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcaisley25@examiner.com', '1932714335', 'dA5NNrkuHbs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dblamires26@apple.com', '6834155980', 'ZfeTpNKk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tsmitheman27@weather.com', '7994374426', 'K4BOBC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmaccoughen28@rambler.ru', '7271658724', 'uq5mA6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ibasant29@wordpress.org', '6068286040', 'MPyYKHWd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cchazotte2a@acquirethisname.com', '2631054952', 'cmRbUz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmacfadzean2b@slashdot.org', '4484271688', '5AZjTh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('droddy2c@google.ca', '4154445641', 'QzqO73ghp0bQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emckinna2d@scientificamerican.com', '7923176657', 'v8ULQsg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('leblein2e@blogtalkradio.com', '5129640511', 'OF6GU8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('savraham2f@slate.com', '5583251211', 'TfTcuSlIf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nalelsandrowicz2g@de.vu', '7305518359', 'NJ7YXMxGUmA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fcollman2h@nps.gov', '6441556114', 'iwUGopEL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmalyon2i@wiley.com', '8119422346', 'aCGoptyEYtm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mleghorn2j@answers.com', '8804678629', 'Jx6D6BUk4cUl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndebnam2k@dailymotion.com', '3893902451', 'sEufnwU5H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahaggus2l@pbs.org', '2471157358', 'VObSFglaPO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdorney2m@chronoengine.com', '6243022860', 'GGHmEwpzRk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcluely2n@mysql.com', '6706871468', 'ofaSCjDB17uB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('osteggals2o@cbslocal.com', '2538657841', 'NgI1g7s');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbelmont2p@livejournal.com', '1255498837', 'BLfeT7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afison2q@chronoengine.com', '8749819234', 'XARnlq9IFmE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hplumbridge2r@businesswire.com', '2129257416', 'jtYVzTQHwpqo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmewe2s@google.com.hk', '5217267317', 'ePnbp3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vpeeke2t@1688.com', '9348363559', 'kZdprlsmQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndantonio2u@topsy.com', '7201862845', '819aimcR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rchapple2v@disqus.com', '4212832671', 'AO6BKAemNGzB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbaudinelli2w@vk.com', '5583225373', 'VRGf2ikI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rdominicacci2x@va.gov', '6363703488', 'o6duOF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpiffe2y@yale.edu', '8218364040', 'id5spGP0hY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmiddleton2z@tiny.cc', '2508945342', 'ynJRF7Zbfu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pwannop30@globo.com', '3325171115', 'gPN56x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbeadnall31@cocolog-nifty.com', '9388002799', 'RTElM2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tspeerman32@google.co.uk', '7588542595', 'LP3zzjRe0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oberge33@slideshare.net', '1591803245', 'lpP0hes');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vmacillrick34@redcross.org', '4308123985', 'fQKkqsh7v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gyoungs35@craigslist.org', '4849105265', 'Mt6GgjuJt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adobbie36@google.ru', '7968333066', 'eKJhU70Lu2a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tnunnery37@ucsd.edu', '4682116927', 'XUvuQLg8tqh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfort38@woothemes.com', '1349963193', 'goAN1f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmcmorran39@timesonline.co.uk', '5243913478', 'x8A4YQlxiXcj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shawkeridge3a@mediafire.com', '5957734957', 'NPi6xSXdOJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nmousby3b@symantec.com', '3375334012', 'pcSaCBronj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yhazeldene3c@arstechnica.com', '6587972962', 'CSlrwMX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dvaulkhard3d@mtv.com', '6422306153', '0H8Bys');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhungerford3e@myspace.com', '7292686275', 'AoRC0UKz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebeneyto3f@addtoany.com', '8568065047', 'WQFmCmY4J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmoneypenny3g@reddit.com', '1358368416', 'ca8e2BvukvQd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbrisbane3h@sina.com.cn', '4799735846', '07WTZ1kUAmHj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddougher3i@bloglines.com', '8794913807', 'zN6gqVdu8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jruske3j@vinaora.com', '8163379646', 'tMFBvsheeEby');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhilley3k@upenn.edu', '4389925402', 'mPFZBKVvY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oevert3l@altervista.org', '2528849301', 'qW9LEbTREF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qscandwright3m@etsy.com', '8978289971', '8hxALf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ksandell3n@bluehost.com', '4104915860', '0DxHmQMHrmp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vrubery3o@toplist.cz', '5959429773', '17uyUNZzwm8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zmallord3p@istockphoto.com', '5172676210', 'XEwsMAMA1YU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbrave3q@berkeley.edu', '7814883273', 'ANhIr8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmcgray3r@friendfeed.com', '4234058589', 'uIaQNVbzEg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmclay3s@japanpost.jp', '2374019880', 'IN0oJgwE5XH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehurley3t@shareasale.com', '1289913385', 'Drz15NM5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ialdgate3u@unicef.org', '4644612461', 'Qkba13w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfilip3v@washingtonpost.com', '3223139371', 'G2Upug');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eeitter3w@ibm.com', '5926920034', 'xehnhB3P8h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmcisaac3x@businessinsider.com', '1123250934', 'sRjrHAPzD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jrootes3y@baidu.com', '2168822101', 'TvX4qhdN9vp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hcelier3z@pen.io', '2588459486', 'ceVFVyj36SZA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbaitman40@latimes.com', '5041693662', 'DHZWH2pPx0X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdanielian41@soup.io', '6142282133', 'KSoRPSRFnod');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjobbing42@diigo.com', '5497350066', 'Qt7rKPqMQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpoyner43@craigslist.org', '5624385799', 'X2u38Hs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmordaunt44@t.co', '2139939637', 'YEepk4h7bveH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ckilby45@ask.com', '9605725954', 'W5gHERxN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jivanuschka46@nsw.gov.au', '9962218057', 'xEWKOqMH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hnecolds47@dailymotion.com', '5266866186', '9zny9med9Ky');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bwafer48@deviantart.com', '1568691729', '6YOGwTmbjV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlequeux49@themeforest.net', '4362324137', 'CvA84kG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdahlen4a@blogspot.com', '7104439474', 'PddKjzpA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atanzer4b@chicagotribune.com', '6588764670', 'lwZHtCf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhuncoot4c@mlb.com', '5629846836', 'HVtLJKPMH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcarrane4d@seattletimes.com', '4287382357', 'bFGXOZe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('damsden4e@cloudflare.com', '4291563348', '6jn55AzVh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgoldsbury4f@hc360.com', '8481271147', 'UmsDc9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aburnip4g@people.com.cn', '6904912608', 'qt7TVsXAA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ghars4h@flickr.com', '4261311647', '7SkgLEw9RU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmachan4i@vk.com', '5931521500', 'TN8wzKX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vshotboulte4j@shutterfly.com', '8723385584', 'H5aFlfK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alazarus4k@prweb.com', '3054017588', 'IaKNWH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eguyonneau4l@chronoengine.com', '6164049134', 'GoyNcD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('olilie4m@usgs.gov', '3291039569', 'xOZKQRE295A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('blademann4n@de.vu', '7226896026', 'uzTDa27w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdrohun4o@soup.io', '6403479343', 'CXG7jizJbGN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mduggary4p@walmart.com', '6601205266', 'YOrEHHb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('imalin4q@skype.com', '9457284184', 'Lxa5NW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yandrejs4r@1und1.de', '2375205369', '4CYVCmvNWkQJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmaughan4s@sourceforge.net', '6411430240', 'd2YCcOA7skSH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mheading4t@umich.edu', '4121233320', 'm6rKWMBxJR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdudderidge4u@dagondesign.com', '2894665104', 'OCgcqPXlWbzm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hugolini4v@squarespace.com', '5149340657', 'JaX1XhesQz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sogara4w@biglobe.ne.jp', '3035532150', 'otq1c6o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obaudacci4x@ifeng.com', '3764462367', 'hFLqzyZ7G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmion4y@usda.gov', '3311224195', 'sn3trzYBgnU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pbrader4z@g.co', '6544391981', 'uvqz1hOHPU0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amergue50@myspace.com', '4115489531', 'IRlYmI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('elochrie51@foxnews.com', '1206549435', 'Slehvft8QbyJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fheathorn52@google.it', '8378217131', 'Bfk3M0fo4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcrisall53@salon.com', '4932528782', 'xy3f7twxN9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgreenhow54@hugedomains.com', '2371611340', '4DF40u4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmoscon55@baidu.com', '3416433754', 'u0EuaoB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eflips56@gmpg.org', '2312631183', 'lP6XG9b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('crutherfoord57@cnn.com', '8825471114', '1u97iB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgarritley58@angelfire.com', '9146173429', 'AeeMG3oze');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgarry59@discovery.com', '9414840429', 'q0yP9Os');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pblampied5a@businessweek.com', '8343850277', 'DbGMmP0d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lsprull5b@php.net', '6802364309', 'rxZS37OYIcg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aaxleby5c@webeden.co.uk', '3123560325', 'tiyBvTXvAdW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acorneliussen5d@taobao.com', '1134243811', 'Z1VxvySEFy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hfoulstone5e@smh.com.au', '7513713868', 'Qtgpt5APx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdeeves5f@engadget.com', '6764697598', 'PGKdAbl4C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swhaley5g@cafepress.com', '5833196616', '7ERUy5ZlKZTc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ubooker5h@gizmodo.com', '2311944722', 'p2BSFdc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcabrales5i@is.gd', '4318260939', '4QZWvyl9mrB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwittrington5j@wix.com', '6005756735', 'D7rf3LYlxEC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fellershaw5k@spiegel.de', '9922479274', 'N8YihC4HiI4C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pchappelow5l@hubpages.com', '4304024318', 'GcDWT2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nrenshell5m@usgs.gov', '1643721480', 'ZeUeAXoj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgallimore5n@wikia.com', '6443435019', 'TgIYgJbKdC5H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfullerd5o@elpais.com', '2116351000', 'AasVHjLEH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmeadows5p@booking.com', '5622312725', '2wMJQDl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dspellward5q@netscape.com', '5158860714', 'QCaY1c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('diannitti5r@wordpress.com', '3384012957', '7JHkShsZ1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpren5s@theglobeandmail.com', '1461034821', 'XGlscy3y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsawforde5t@people.com.cn', '6029200605', 'FLLzibU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpietron5u@economist.com', '4383943566', 'KNhaYddN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebroddle5v@yandex.ru', '3105957830', 'OTi5ykS2UMs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jwiper5w@cbc.ca', '5213795692', 'U2HaFdsa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amannion5x@i2i.jp', '1485154294', 'qSOFey');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rwapples5y@dedecms.com', '6454922073', 'GB9eG1QS60w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('myanson5z@statcounter.com', '7438104472', '5wY21LKC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esamways60@imgur.com', '8344202427', '9kQT9a0PcfEC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldilloway61@miitbeian.gov.cn', '9693094047', 'Knhp8tRo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gakitt62@patch.com', '2213867606', 'OcWbM3uqu8D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gfansy63@scribd.com', '4046784251', '8mQiIp9I6c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlillo64@unc.edu', '4366165508', 'JgqoAIMeclV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nspilsbury65@ameblo.jp', '3914704860', '6Fa0HYaZx4vl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gaicheson66@live.com', '8926712155', 't5P52gWl8q7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wsainthill67@elegantthemes.com', '1214558150', 'pso4qrYR0VP4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iskaife68@behance.net', '6504418591', 'XWVRiz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adobrovsky69@go.com', '5512208226', 'F1jLpJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jodoran6a@technorati.com', '1722430363', 'h5cgPxHl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmartugin6b@bloglovin.com', '7565132811', 'e9FN1nMi0l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eborrett6c@free.fr', '8778548189', 'YJeGZ8T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jstanier6d@vinaora.com', '2196081908', 'PRoKqW9g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srippen6e@newsvine.com', '6505318151', '6wgZe2KDt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('clehenmann6f@alexa.com', '6015049187', 'XAB512hL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldevere6g@accuweather.com', '4548213607', 'BcYJHv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ledinboro6h@mozilla.org', '5696671503', '32HC84O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsharphouse6i@smh.com.au', '6864411135', 'H5xzXGhf9FU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpaice6j@home.pl', '9071031611', 'APKjQZLKF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ppettifor6k@dmoz.org', '2454157818', 'ombiykdG7h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apinilla6l@latimes.com', '3993096509', 'u6OvgWWMrx4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afowley6m@economist.com', '7493489826', '9Axdd2saphb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amarchant6n@washington.edu', '6509967089', 'KcjMXG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbaxandall6o@ning.com', '8175746009', '5ro75lcJQ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cswalwel6p@shareasale.com', '4755491957', 'TREi2oyjR4Do');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbrason6q@goo.ne.jp', '5221267642', 'h0t7k0kU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmcconville6r@nifty.com', '7488048032', '6iLzg5v58f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('phanssmann6s@ustream.tv', '3806061392', 'oUql3MClF4t');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smowbury6t@studiopress.com', '2337087042', 'cRtGZZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wberndtssen6u@nps.gov', '5527887050', 'sInCyjorJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbabbidge6v@scribd.com', '3385293639', 'wKNE1m4z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msquelch6w@desdev.cn', '7598306069', 'mRZMWbvJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhasty6x@vistaprint.com', '2932166728', 'P9Xoe8sXg3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmanifold6y@mtv.com', '5762281962', 'lqKn2g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hfyldes6z@slate.com', '2384489132', '4L2n3l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fearl70@google.com.au', '8673756921', 'hHB3z70gU7Gv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('stitta71@scribd.com', '8958334734', 'dVdg2KgTJH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tizhak72@google.co.uk', '6174243778', '36B8bB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehotchkin73@rambler.ru', '8848851747', '1nTIHrD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bclutram74@fc2.com', '8478672229', 'e2aPTfW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iminci75@webmd.com', '9592354583', 'FiRWofCS1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alittlefield76@yandex.ru', '1876855611', 'poZ5kAPW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfriett77@1688.com', '9323514881', 'xSG5UpPR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ejonuzi78@economist.com', '5138385747', '4kHWwap');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jjerrans79@storify.com', '6556213861', 'gbCalIMol2we');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spostan7a@nydailynews.com', '7703563445', 'fG8RKOq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcisland7b@jalbum.net', '6228102747', 'nAorDJRPThM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kconeau7c@usgs.gov', '7939466037', 'WQXsRRmPRL2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdeveril7d@1und1.de', '4841107551', '1m0Bo5P3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vheeran7e@simplemachines.org', '4064718694', 'FUYVoLbWe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eburniston7f@about.com', '3636960532', 'NIDF4O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vmanketell7g@about.me', '7649411741', 'mtMIbZzi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amottram7h@intel.com', '9349935580', 'KgBiX6tGSwJg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbainbridge7i@patch.com', '4071841804', 'AT1YI4k2U1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsheraton7j@upenn.edu', '9007661061', 'qkpOto4qZUI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbox7k@yolasite.com', '3482950254', 'iWX0sjc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjecock7l@macromedia.com', '5604614203', 'PWdVF6wMEqk2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mketchen7m@sogou.com', '4662960435', 'ibb0JL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spetroulis7n@pcworld.com', '2648752463', 'ytwLwBqOD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfinneran7o@a8.net', '8928365659', '0o3dISLJt5zY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fellerman7p@51.la', '2968914153', 'ACgfyfpN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chalbard7q@biblegateway.com', '1228213447', 'DLlbLNCve');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emackonochie7r@uol.com.br', '6845828261', 'm9WYI6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbestwall7s@fastcompany.com', '2775004003', '366FunF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fwadeling7t@cocolog-nifty.com', '2002019191', 'qNCYQtu3Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wmines7u@columbia.edu', '2432743238', 'iNrpMA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdun7v@nifty.com', '2812639107', 'J3lEo6r6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kkohter7w@netvibes.com', '7488226022', '7gjIfG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ametterick7x@jalbum.net', '7311555057', 'cvIgjUAv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('flongstreeth7y@usnews.com', '4756012084', 'TemkpA5FzeT5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tseargeant7z@ihg.com', '6237976539', '9fEs4yJw61ab');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rseger80@4shared.com', '7977743154', 'z7Zr5aRZbzKq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tvanweedenburg81@reuters.com', '7022081027', '9XUmQ69wfe6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aburwin82@weibo.com', '3139472246', 'StJXxgae');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aorsay83@w3.org', '7914953509', 'LPIwuUxSU6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbamlett84@nationalgeographic.com', '8615003156', 'zQQNc2vnss');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vnewlin85@cisco.com', '3336567866', 'uKfmX6DZx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcreigan86@mapy.cz', '3162149368', 'TyUJJzR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afilippov87@yandex.ru', '3779308166', 'n6tKGOZBJ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpavlitschek88@oracle.com', '3351286042', 'pFExVxb4Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbromidge89@wikimedia.org', '8809543275', 'TWo9WX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dchipp8a@plala.or.jp', '3834688638', 'cWE1jIRH1Su7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbeek8b@latimes.com', '1153035498', 'VbSpSssG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klongworth8c@privacy.gov.au', '5458767325', 'bGH0MK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bchicken8d@is.gd', '3308827775', 'cAuqqlVKfLVr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nsokell8e@people.com.cn', '4978739542', 'VsvPo3IVTE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srantoul8f@techcrunch.com', '3786930208', 'W2CRDMj7R6kG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sroxburgh8g@vkontakte.ru', '1837731910', 'cz65LUvYRj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbrend8h@ted.com', '1707506418', 'dy6xb6FLee0U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsiggee8i@google.ca', '5562587235', 'fA4KmurR59a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcasetta8j@noaa.gov', '9745894926', '6gFyj1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmiddlemiss8k@cocolog-nifty.com', '4019294140', 'LwIHBAFj3co');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wrosenfeld8l@msu.edu', '1555175638', 'f2j5OPa2U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ibeville8m@pbs.org', '5373118851', 'TvAk3h63dmy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oodempsey8n@state.tx.us', '2134358108', '65XH0priOAAC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sjessope8o@admin.ch', '3443042459', 'h8w77R4oe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfarnworth8p@walmart.com', '3846149194', 'km3wKK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obenne8q@gov.uk', '4886413398', 'atsMHjA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atine8r@wufoo.com', '8374249907', '1pCiBH3Fam');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('estoker8s@jigsy.com', '3285961010', 'KPrtrIHZqpmK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asackler8t@netscape.com', '7869217093', 'nz0q7Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmatchell8u@google.nl', '9522927520', 'vAkLKkV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abenzi8v@miibeian.gov.cn', '8605628917', 'JBhKWw2Wb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adanneil8w@unicef.org', '4817565169', 'z47VhCh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgateley8x@nih.gov', '7465274328', 'BbpkqcZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msukbhans8y@themeforest.net', '3808524841', 'Zc4wWv1NH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ngeistbeck8z@redcross.org', '2761261812', 'KnPgNpCvXjz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lchene90@adobe.com', '3644658446', 'XX9yZVJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbrockhouse91@huffingtonpost.com', '5745939454', 'XBThVgv9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcookney92@technorati.com', '6208483781', 'kineqLbBUc3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('socorr93@smh.com.au', '8059038752', 'bTG9uVM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpitcaithly94@go.com', '2085189803', 'LZQhRhqS3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lclare95@cam.ac.uk', '1785554969', 'Z1qWtZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdosdill96@noaa.gov', '1852634539', 'uPjk5sWIzFm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmelloy97@ebay.com', '7058011013', 'Q5YA8Lk7XRgu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iarbuckle98@odnoklassniki.ru', '6076446672', 'NnjUQ9MdhFbP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jlethley99@topsy.com', '3087901914', 'YjSjTqG1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtaberer9a@seesaa.net', '9684524490', 'ceB0zJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fgrabert9b@msn.com', '3577358528', 'tX84Y9p1FY9E');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rclyburn9c@fema.gov', '1554599850', 'odGNKPqMC2WL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adelacey9d@psu.edu', '5026410813', 'uSIToSCGj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kstockley9e@twitpic.com', '2944601992', 'ZBUdKAIYOGV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbothwell9f@opensource.org', '1875246293', 'gNDrPpij');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgarbott9g@typepad.com', '5879954290', 'M1zGwaaH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpeppin9h@businessweek.com', '3806781417', 'ynHoBF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kcleaves9i@google.com', '1655790383', 'tJz3nz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('balflatt9j@msn.com', '7729678032', 'locNIXdrjsJ7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rferreras9k@census.gov', '7098782739', 'xbJzdjOQ75De');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmckeran9l@house.gov', '4239696808', 'fYm6ZfGH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('olibbie9m@state.gov', '5887364369', 'ikOf5Fp0QW8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esuggitt9n@google.com.hk', '2198585168', 'gDBAmUP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fpaddingdon9o@123-reg.co.uk', '7023015956', 'RtuBdlGUH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rshipway9p@foxnews.com', '6553456423', 'hbpUUaa1OJW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cedwins9q@moonfruit.com', '1057716442', 'lhW9SL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klattie9r@bizjournals.com', '5572682128', 'Irr27B2M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmacilhagga9s@columbia.edu', '6953042966', 'gsNlxyRk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acollumbell9t@zimbio.com', '9881535391', 'G3JPwbqQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsmethurst9u@indiatimes.com', '2995055287', '7NH1VaH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jjakes9v@comcast.net', '7063069449', 'tBhtWtnGu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbatchelor9w@phoca.cz', '7691879177', 'vSO62R7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('akarchewski9x@paypal.com', '1331790786', 'NH0QFfENT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfraine9y@bing.com', '1335869631', 'uwJHQt8IlW1I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldagostini9z@nature.com', '8262270286', 'bb7EqLvc1hP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lneilandsa0@flavors.me', '6139354941', 'eu9Twn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsiddlea1@dyndns.org', '4362932017', 'tCK2eyHzgA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfarquharsona2@netvibes.com', '9271963669', 'Rk9YNT5QQyLN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klentea3@unc.edu', '1453668861', 'vYsQOzfsL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmeneghia4@blogs.com', '4514004458', 'v6WtYOZeKGS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tyglesiasa5@cnn.com', '4069998982', 'D99g3gqqzs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ltrenamana6@elegantthemes.com', '2447554434', 'Ga3ancO3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctretta7@vkontakte.ru', '3687469956', 'TYCaFTnSbG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmeiklama8@psu.edu', '7228801445', 'eHUVwyy8oDSD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdalwisa9@harvard.edu', '1059308527', 'czk5BOkZr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbatterhamaa@slashdot.org', '9447487079', 'DMYbB5U3TR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('croofeab@etsy.com', '6098534890', '0fPK1jmAag');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddormonac@1und1.de', '1954116486', 'xjCTxE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('didlead@xing.com', '8055075905', 'zsUjbQt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bvassarae@walmart.com', '2225020783', 'r5Sf6wPJvzTI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ktankardaf@phoca.cz', '8766546565', 'vaj2vWe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtefftag@geocities.jp', '3193715163', 'c4P9z2WQgn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fastyah@wikispaces.com', '3669983535', 'R6Eej2VhqCU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rberreyai@cdbaby.com', '8636619696', 'GOtSJfU8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abringloeaj@comsenz.com', '6939567695', 'JXb2CY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmolenak@comsenz.com', '8459670830', 'wylnDQvHbEXK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbemwellal@reddit.com', '3591686625', 'dJEJtz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('otrudgionam@ucoz.com', '4528245483', 'pUQDSFsIqoG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pscobbiean@joomla.org', '6828807826', 'kTU9q66EAXS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acluseao@youtu.be', '6793818044', 'u0IsxSHU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ychidzoyap@dagondesign.com', '4131944115', 't1f9EZR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtrumperaq@dagondesign.com', '7987024007', 'EcpZ9HL4fyZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dchadbournar@washington.edu', '5512002620', '4SeazMx4Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbonnas@sogou.com', '8794013304', 'x6ZmGv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnoyeat@cargocollective.com', '8701113719', 'wnJW4ybyu31');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rginniau@canalblog.com', '4291287848', 'R4mDPyKdx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfancourtav@apache.org', '4813801482', 'Fi8BkLqJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('clettleyaw@jiathis.com', '7082969263', 'UWxvJZG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmingetax@un.org', '7406548908', 'QXTMKDaKb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tkivelhanay@ox.ac.uk', '8753885364', 'kEHFDkzANaF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdummeraz@deliciousdays.com', '2917249169', 'BlWWop');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rewbancheb0@bloomberg.com', '3163215199', '55kv8ho0R');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vbrunnb1@homestead.com', '9129277013', 'SESkCiCuDao');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsarreb2@boston.com', '5536221031', 'RMG8jMRmd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llikelyb3@taobao.com', '6782378311', 'ATxoEu93');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rjutsonb4@wunderground.com', '8512834419', 'Q3TvUDaFLWZx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kblaslb5@google.nl', '7836653933', '2AipxYxixrOS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhattersleyb6@altervista.org', '6368889277', 'gB5joqZdz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rkimbleyb7@miibeian.gov.cn', '6481400538', 'yqyOnX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mwaycottb8@bigcartel.com', '4367336406', 'Z6h8W5vNZ8O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acarollb9@theatlantic.com', '8444417571', 'VZxPtOFqB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('czoephelba@toplist.cz', '6826281085', 'Mz1kHa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('khuyhtonbb@cocolog-nifty.com', '3513789788', 'ipYE8sE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('civicbc@amazon.co.jp', '4206524286', 'vL5G0va2Lpls');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmingobd@icq.com', '3772283188', '1Td36B2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mchienebe@google.it', '9575773867', 'aEQV1Mh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ipicardobf@artisteer.com', '3878371516', '44rTnAi6z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dderechterbg@diigo.com', '3225846795', 'nIYSNG2jrR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmeadenbh@wordpress.org', '8551482302', 'SO5GGuGpn2o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('araperbi@jigsy.com', '2428344316', '0orV80E7C6eW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dreveybj@chicagotribune.com', '5388521416', 'dfvQwJlu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('calfonsettobk@woothemes.com', '1555972752', 'ktR4hHtQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwoodyearbl@diigo.com', '9646420492', '7yRQL7ghr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eaddekinbm@tinypic.com', '4847508457', 'wHhnt2ilns');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oivanovbn@dot.gov', '4219410154', 'yTn5GGt9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpybusbo@taobao.com', '6976789456', 'UfgIKOjs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbroxisbp@telegraph.co.uk', '4948738125', 'd4RQQJ8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drozenbaumbq@china.com.cn', '5208589479', 'yUWJRMu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdelacroixbr@dyndns.org', '2515520180', 'qT6pvcE1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mberninibs@yahoo.com', '7184235573', 'v7iOOiwEM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oeverybt@tiny.cc', '8895816570', 'kEOo4PdusCLX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dosmarbu@msu.edu', '9103669818', 'LhecklbUGh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fnanabv@answers.com', '1763273251', 'rf07VBQ05Iz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdreinanbw@forbes.com', '1257722849', 'EwkqESK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awilmottbx@arstechnica.com', '5438413189', 'aEpgrec');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pblakedenby@slideshare.net', '2506002592', 'qx4J8a481');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmerlinbz@whitehouse.gov', '9806348711', 'HcYuSinY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('panglessc0@sbwire.com', '4061973544', 'nqo6TK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtourc1@webeden.co.uk', '8388235134', 'Cm7rnxP9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwilcoxc2@theatlantic.com', '4073321457', 'jkcFotVSlH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sblincowc3@360.cn', '7374997483', 'gQyD84EOk9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcunradic4@buzzfeed.com', '1856970493', '2IjjrPu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asimenonc5@scientificamerican.com', '2029657213', 'G8ZjBJi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddavidovitchc6@usgs.gov', '7031681581', '5pHXNTYOS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ntettersellc7@digg.com', '5846771158', 'TbGQySGK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('akiffec8@washington.edu', '5557468010', 'g9ColnZ1BcD4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aferedayc9@sakura.ne.jp', '4333611643', '6hAn6Z13');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pbritonca@chronoengine.com', '8411553598', '0c3EmfNlMsZb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgettycb@nasa.gov', '5457448230', 'OuG8uzURJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcrimcc@unblog.fr', '5501020632', 'rCwOxH6Oi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tveltmanncd@clickbank.net', '1147658751', '4PCCl7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tserfatice@nps.gov', '4989065777', 'uiAnQ8JbgG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmeatyardcf@bravesites.com', '7654402078', 'wxmjfKe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbugscg@ihg.com', '3903414756', 'Lkup3C2C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdoumerch@whitehouse.gov', '4762437336', 'RnCui3zCOGmq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsarvarci@biblegateway.com', '3688946024', 'QJ3IxA9edIjc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gtoopincj@myspace.com', '5225621613', 'WJ925j7R');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('svallisck@nature.com', '3099991826', 'UAbEirPB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbensleycl@google.ca', '9315919513', 'qn8joewa3j');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlamortcm@ycombinator.com', '4731285441', '8tijIkakyB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acorbincn@stanford.edu', '2282205086', 'W4sRpPyKcO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rdabornco@whitehouse.gov', '9062653304', 'jhsIahHSm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmacloughlincp@wikipedia.org', '9845270081', 'XcinWG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmaryoncq@deliciousdays.com', '7128017128', 'fbvWl9bO8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcossercr@usnews.com', '9803349601', 'SnDHwlXW5J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('soxboroughcs@people.com.cn', '6232130034', 'O6ZIjdrhIBxG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfolkesct@thetimes.co.uk', '1629895308', 'xhEuVX8Ej');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smclanecu@paginegialle.it', '1169166053', 'tbvg1GunOOo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdebelliscv@netscape.com', '2979021251', '6CfVlk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gfreyncw@issuu.com', '6519414125', '5vdkDbe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wbelchamcx@vinaora.com', '1418275465', 'c1AUAa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('twroughtoncy@macromedia.com', '7068563682', 'JetSnKFoby7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmeniercz@chicagotribune.com', '9921947304', 'nerwEiQh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ariddeld0@telegraph.co.uk', '9362028072', 'YkHxCOlXf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chanmored1@flickr.com', '6141124550', 'r9ZPgM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gridesdaled2@ucsd.edu', '1151503880', 'e8Qiyhp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldarrigod3@soup.io', '2376944230', 'RNQLqJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdacombed4@lulu.com', '1078883203', 'tV6musiwjZ5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfettisd5@columbia.edu', '3745324383', 'BLkNselvJgql');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spiffordd6@businessinsider.com', '6973020567', 'EEdZCsgArbf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lphizakarleyd7@alibaba.com', '9203149344', 'BmLMUmJTA6i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lstrutd8@youku.com', '7456376857', 'oeljLLjT5XfG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awebbyd9@usnews.com', '9313691406', '5ZJ9b3or6hHJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smattiuzzida@dot.gov', '1699484546', 'x2hvEGq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mshaperodb@craigslist.org', '7759362086', 'r1VhgSscM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwentdc@wikispaces.com', '3107130731', 'AUUzNE8Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('brosenshinedd@unicef.org', '2469321919', 'boLNixyFW0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlehrlede@boston.com', '6168357009', 'teOKDCf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('avallerdf@oaic.gov.au', '4059787707', 'KRXlx6lTyZbC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdudgeondg@soup.io', '3727176732', 't6izMN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nclimodh@cbsnews.com', '3789475423', 'ICICuR17kiz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jblabeydi@joomla.org', '8555558647', 'lnZ6t5r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbattesondj@merriam-webster.com', '1468087545', 'zmzKbXfeCU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbecksondk@home.pl', '4493258952', 'G4yZhEhmF5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egarrondl@mashable.com', '6294523528', 'MdhtGSBxCdu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldarkerdm@artisteer.com', '3004956368', 'jR4MoUUj0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esmedmoordn@networksolutions.com', '8786083678', 'WbztCD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbullinghamdo@topsy.com', '2547325547', 'hL1zzCS0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdrinkaledp@aboutads.info', '8378001346', '4ai6keTDCE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msexdq@cnbc.com', '5705485826', 'WlygPliH2Imv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klaideldr@xrea.com', '3659028913', 'z7z9UQo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddwellyds@netvibes.com', '4645631312', 'i5ZcPsFUr1C0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iforrestordt@bigcartel.com', '8939803339', 'LjCGkvvx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('blanddu@biblegateway.com', '3011824838', '6idAtj9LLz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('soloshindv@about.com', '6292932095', 'rnpDYF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ekhosadw@fastcompany.com', '2329383635', 'jTcgbmOytT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgiacobiliodx@bravesites.com', '1957135791', 'ms8tzDpa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('csherdy@netvibes.com', '8459409276', 'pRUjjAbWrX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aweedendz@gravatar.com', '2599660666', 'ULwD8b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smacgarritye0@hao123.com', '4085952073', 'oZSNB9E2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kumfreye1@amazon.co.jp', '6941840083', '6DmwnJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bemlyne2@earthlink.net', '3266580652', 'kNMWHjh1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rabramowskye3@samsung.com', '7136078235', '710uBJjHS4O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dportingalee4@whitehouse.gov', '9302441804', 'sTrtUJCrvEDs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhandscombee5@bluehost.com', '4912228287', 'uXm6KAACNH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbeagane6@wikispaces.com', '8084327376', 'Mcad2Gjl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bguidottie7@slate.com', '9374019636', 'iz8LPKLPFWQ6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbulfielde8@ameblo.jp', '4536490623', 'Z0PwfMrs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wgallandree9@shareasale.com', '8668512861', '88ovskYP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ayvensea@hc360.com', '6328681673', 'Mg6hVOmx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdarmodyeb@guardian.co.uk', '7057251346', 'BnOxglEVy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpenhaleec@umn.edu', '2382912282', 'JSgYeY8f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ngladyered@ucoz.com', '3086008529', 'KK6bGE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsimmingsee@51.la', '5077987349', '3BYblBL4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwyardef@jimdo.com', '8858588105', 'plKo5S7iF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vwyatteg@rakuten.co.jp', '4922410514', 'RmRVgE1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmarveleh@edublogs.org', '3974596045', 'TZX3FlMPPw03');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jettlesei@ow.ly', '5919728142', '7f0WcFb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egreystokeej@acquirethisname.com', '7351049252', 'dofwnv5Mq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfanningek@istockphoto.com', '8589608156', 'QGG9IH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtoalel@nydailynews.com', '3517137398', 'RTHyGHgTPAT6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ppetrelliem@imgur.com', '5182597706', 'wtywIsdQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbladeen@globo.com', '7446425766', 'XgqLpJuB5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rhillborneeo@hao123.com', '8868873282', 'FY5Hzt5m42L2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhiblingep@businessweek.com', '9005645476', 'wzivhlxBx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rblazeviceq@globo.com', '1401642292', '3mmVnt3tC4xY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aberneyer@spotify.com', '7867607246', 'EgV94es');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ocarwithimes@delicious.com', '8415992029', '2JpNkqsF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chellekeret@hugedomains.com', '5996500404', 'PjYmPc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aworleyeu@economist.com', '9768351261', 'i3lSF2G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhamflettev@is.gd', '1932703004', 'NX1dUH5yExS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbetjeew@yellowbook.com', '1578899523', '77FrTC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vdaintonex@cloudflare.com', '2149758653', 'Ie8JBaFwq7s0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmaskelyneey@eventbrite.com', '6367319543', 'aJdhatHq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhuotez@yelp.com', '5345084360', 'QwrpgX7h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('karpinf0@reddit.com', '7636071299', 'GwiiEgDM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('epennringtonf1@boston.com', '5265367776', '5drSLbXJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmciloryf2@berkeley.edu', '3123376324', 'q29vyaeW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wbarentsf3@businessinsider.com', '5558527641', 'BJhPe4wqu9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbockmannf4@cpanel.net', '9062213956', 'UrKbKQeQa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asmolanf5@gov.uk', '4961780838', 'NoDOOSMS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asidlef6@squarespace.com', '3282157576', 'bLn4DHJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oglaumf7@elpais.com', '2769996280', 'Zs2S7ms9MB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llambalf8@ucla.edu', '8844445212', 'm2YXBazt35D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcuncliffef9@biglobe.ne.jp', '3257834769', 'yT1TxZe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dboughtflowerfa@time.com', '4978633927', 'Pq4L0LTK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('djedrzejewskyfb@angelfire.com', '7975929550', 'lgYf5VLdm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pparagreenfc@ameblo.jp', '4238241814', 'Ylug3AzNQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmapsfd@ucsd.edu', '1859436946', 'pKlMZn3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acavozzife@google.com', '2337234300', 'oB1QDi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('izmitrovichff@harvard.edu', '9478387863', 'hpRi9JFR9su');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gtooveyfg@vistaprint.com', '3792014636', 'SjD9pSQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfoxwellfh@cisco.com', '2888264725', 'tKOnLG3wHna');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scawsfi@opera.com', '5956819232', '10XME18ie');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rreddyfj@mayoclinic.com', '9607978519', 'D2wBZ0n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awaddiefk@acquirethisname.com', '5148764943', 'P5jebbrqX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jrickmanfl@cnbc.com', '2596004435', 'uI5spSh10FLn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eblintfm@qq.com', '3768754956', '6M3emm2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmccarthyfn@4shared.com', '7358788376', 'L3arRDixLPzB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amilingtonfo@toplist.cz', '1589112554', 'gD7Ztf54');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbrickwoodfp@tinypic.com', '6601559389', 'vKbNUUFN7u');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjellettfq@wired.com', '7957180273', 'zmd6G1QID5eZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('krobardetfr@storify.com', '2559146374', 'Hs3vog3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmoorfieldfs@wikipedia.org', '2789797049', 'iSEfQgJxK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wwhitefootft@alibaba.com', '4449080162', 'nz0gRONlXFaU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('etabnerfu@de.vu', '5709444942', 'Hymf92');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpietsmafv@meetup.com', '6328852446', 'f6fVEKYMTzA0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcreeboefw@techcrunch.com', '3632088518', '0687zTftge');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmeechanfx@yellowbook.com', '8093615852', 'SGKGh19q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpettisallfy@youku.com', '3754758322', 'WsbvrKrngpPI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edufaurfz@gmpg.org', '3523658644', 'XR4s1QAsvZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rluciang0@360.cn', '6084887536', 'NmEUpUl82l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cstanneyg1@netlog.com', '9949510923', 'AMUM6Am');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dvasilovg2@businessinsider.com', '8247756963', 'nRZDTyp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fwoltersg3@bluehost.com', '6157764802', 'EIUnCO9JXWD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tstaigg4@amazon.de', '6171595208', 'LyHGgn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('plinebargerg5@sciencedaily.com', '9401634075', 'SPbJCtt8hYM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dthreadgouldg6@histats.com', '6531242019', 'CyXmsaRaOHQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abrockettg7@quantcast.com', '5229875472', 'yvv27iQbQkV6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kcotesfordg8@de.vu', '6132305955', 'DwiML5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sonslowg9@msu.edu', '4011959619', 'YF6TTIn5e1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlembkega@fastcompany.com', '7877576788', 'gheS7c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tjerransgb@amazon.com', '6445935702', 'w05ACk3gwvz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fchallengergc@over-blog.com', '7311905303', 'MbrNYZCt0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('siwaszkiewiczgd@feedburner.com', '8399409570', 'toAc00AH8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbischoffge@disqus.com', '3022475359', '5hHLixLgCnC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgillaspygf@nps.gov', '3302783351', 'XUCt9VfBiOI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afassbindlergg@mlb.com', '5027583991', 'qbGyi1OB1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdemitrisgh@chicagotribune.com', '5965118113', 'KDL1WjusPR41');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eduplantiergi@tamu.edu', '4195103684', 'ALGxujvdG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gnaptongj@latimes.com', '3513573274', 'KEv5oSzYm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdunphiegk@oaic.gov.au', '9467703070', 'fbbb6Ka');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgoddmangl@columbia.edu', '8721859698', 'CsEcEE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcuddehaygm@topsy.com', '1269365823', 'nHhDai');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mrosellign@skyrock.com', '3301101032', 'Dc4UpeD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ogoddmango@loc.gov', '5386746382', 'gek3JU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtosneygp@g.co', '6446575705', 'SBt8zJtwY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eworsnipgq@hostgator.com', '9963276065', '80wmaXliC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gstainsgr@trellian.com', '2535162668', 'M2x1wIwn7fdr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sswitsurgs@google.nl', '2354973543', 'XOwwKm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kanstygt@dailymotion.com', '9631374403', 'Ms5koo5Tz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsmittongu@list-manage.com', '7332715337', '4pYsA3z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hstannislawskigv@shop-pro.jp', '6229560540', 'nFsgLt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smitchinsongw@canalblog.com', '6516028039', 'B7WdWx2KN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spomeroygx@narod.ru', '6523469347', '7HioOCsw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmccullygy@mayoclinic.com', '7731540336', 'oDujDIZlPl1K');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aphilottgz@bloomberg.com', '3194042231', 'XDJB6ooOH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rslighth0@tinyurl.com', '2899742108', 'yGFGCE05E2AY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgahaganh1@patch.com', '3303778979', 'VKCX4nZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pcammishh2@loc.gov', '1894561560', 'L9kGkdv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agendrickeh3@google.pl', '4945152231', 'WTrztHLm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdamerellh4@storify.com', '3778917821', 'CchBrfIYwrc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlinsleyh5@rakuten.co.jp', '1637874976', 'mtsfbsb0X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bburgenh6@indiatimes.com', '1438911740', 'YrggyDT41C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('creinmarh7@amazonaws.com', '5711209092', 'S52zKNi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smcclymonth8@bigcartel.com', '3901303624', 'gUPUMcHS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alequesneh9@ameblo.jp', '6258507054', 'GirtfUiUO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdequinceyha@europa.eu', '5245149550', 'CfNPcXHQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srumgayhb@shutterfly.com', '2127403044', 'Hn5PEw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhekhc@opera.com', '4382998729', '2OHcsCbd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pkretchmerhd@prnewswire.com', '6433474323', '6AGm30wJEG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpostonhe@pen.io', '7335969325', 'MEIt1ca7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hswinehf@elegantthemes.com', '3626589512', '1Yq5Wk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mandreopoloshg@accuweather.com', '8505432417', 'rmC7mEeb60M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pnecrewshh@pagesperso-orange.fr', '7421817218', 'GjmaBC0LQGfL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddecayettehi@tuttocitta.it', '5134605621', 'jgSiUdtV1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('arochfordhj@hibu.com', '7393467020', '6PndRiH0v6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhardihk@narod.ru', '1535909343', 'YMAvSJ624');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jnotonhl@ox.ac.uk', '2039998932', 'vfOTOJv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmartinezhm@yale.edu', '4145989475', 'XzmejPo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eantcliffhn@spiegel.de', '2024594974', 'f7w3qOxL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlipmanho@spotify.com', '3791771989', 'lusyB0eP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rjovichp@nba.com', '8241911010', '6abiiSxt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbeezehq@nbcnews.com', '9525999018', '47xaZOqg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcullneanhr@ow.ly', '6107329539', '9Sy9Ef9D4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aparagreenhs@shareasale.com', '1421471219', 'pUY4PFTj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dthewht@freewebs.com', '8709704717', 'uw7jUJQmjUu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abalamhu@abc.net.au', '2277276471', 'EOKePzl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srodearhv@issuu.com', '8451303756', '8PxqChQOL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abiltonhw@tmall.com', '6447035795', 'l0fgZqAEE1P5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('reassonhx@berkeley.edu', '8877795015', 'f9UZNS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abrimicombehy@timesonline.co.uk', '8577484369', '5NVHQC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsugdenhz@symantec.com', '9384818610', '1lv7S67');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('djakemani0@tuttocitta.it', '9966837639', 'D2CUauDBd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmattosoffi1@tinyurl.com', '5423698592', 'puUiGrAdG8p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmaplethorpei2@nbcnews.com', '5681380349', 'jggWdGF0p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mharmoni3@amazon.co.uk', '1298733313', '4MNv4M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oarmitti4@timesonline.co.uk', '5987238736', 'ugbfsEgU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpettiwardi5@chron.com', '4051606255', 'Z4PnpN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adavydochkini6@homestead.com', '7814646987', 'jCxAsS6C4cSd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhaibeli7@dailymotion.com', '7821169183', '5rWMYZW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fworldi8@phoca.cz', '5872745941', 'EZ5UgzLGDSC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('prosebothami9@biglobe.ne.jp', '1582501638', 'dZPuGKQLgFx8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mavrahamia@chicagotribune.com', '7665926587', 'KHmbZl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vgracewoodib@wordpress.com', '5458144376', 'UmQh7Tq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcobbaldic@geocities.com', '4393574190', '1fRilDf7i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kphelipeauid@dot.gov', '9834549137', 'Rg3eVwn35l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obritnerie@amazon.co.uk', '7637313054', 'JmpfTldNx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbickleyif@yellowpages.com', '4392269587', '1uaS9WIT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('myushachkovig@fc2.com', '3643863063', '73TwtrF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afiddlerih@stumbleupon.com', '4797358174', 'eTZqkLPrG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtregustii@ucoz.ru', '7634919666', 'S3yNZv5EHgR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('granbyij@chronoengine.com', '2644295559', 'eYX2thFlJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dranvoiseik@yelp.com', '9895576101', '9HeJMf14xDm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vaprilil@patch.com', '1836822601', 'klEtmFdzJQvW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mslisbyim@amazon.com', '2416185515', 'm4y1VhW7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tsowleyin@gnu.org', '7188469490', 'bPoD3WsJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('caxbyio@discuz.net', '4285144639', 'mAawxTQ5A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msmitheip@twitter.com', '8921162694', 'wC7nyqrq2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ablackeriq@nifty.com', '6648771845', 'lePMnuczUh6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vatwelir@1und1.de', '8749652402', 'YS2ivjqf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kvarranis@gnu.org', '9579261524', 'efuov6oRn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfuchsit@blogs.com', '8125071662', 'Zh5INeYcJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmatthieseniu@ebay.co.uk', '1263404614', 'fZiusqR9XO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccastelluzziiv@eventbrite.com', '9726624561', 'GY1MBHLe5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('htaleworthiw@surveymonkey.com', '8914784525', 'wt4vmD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adrewesix@nps.gov', '1279515400', 'CzVdzCnAN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abenbrickiy@netvibes.com', '4918397654', 'uQuJUMbf4K');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cshemiltiz@ed.gov', '6555825291', 'J141LHAD27o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hrobertellij0@dion.ne.jp', '4287710735', 'eXlBTA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmcginnisj1@sciencedirect.com', '9319977198', 'SL5VJfEe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vbentleyj2@trellian.com', '9038481968', '9VOaYiss');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpydcockj3@t.co', '9603899862', 'tTVRSpkTIO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ashoriej4@cpanel.net', '1732285865', 'bVliRsy7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ladeyj5@hhs.gov', '8932338883', '5NR9KOw6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pmcallasterj6@example.com', '3005123915', 'sY4wWL3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmatticcij7@dailymail.co.uk', '4931642929', 'F6yIHb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cattonj8@google.es', '2838511779', 's0NZedumvU4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('uaaronsohnj9@slideshare.net', '3952098621', 'BfK8UrY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('binnisja@noaa.gov', '3628415522', 'g4ylrGCa3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpendletonjb@boston.com', '8822968540', '3WeRj5pCp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccloneyjc@quantcast.com', '1539978040', 'sDXCxVH7ef');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sberryjd@prweb.com', '2594235713', 'BshpRKGd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('estennettje@furl.net', '9166461336', 'ERnmmbeVfVyG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('omatuszewskijf@sciencedaily.com', '9755554163', 'ytDRzR8Z8p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aashmanjg@icio.us', '2678427423', 'fcfaEjg06');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rjagielskijh@google.it', '5977061085', 'LkTTCoZos');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rrobuchonji@huffingtonpost.com', '7831555788', 'Jed9j5BMcA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vmoraledajj@google.cn', '7977043061', 'PFlGVVbFwq8Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgirardinjk@china.com.cn', '1306385211', 'dMmUpuq84');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ballredjl@cpanel.net', '6287866970', 'MdxUJa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('theindrickjm@mapy.cz', '1159317412', 'FYO6JhbU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtatfordjn@domainmarket.com', '4441444220', '4hu0MrI8Edl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rtottlejo@bizjournals.com', '6157663364', 'oSWotcg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtretterjp@moonfruit.com', '8531197787', 'PzS3x1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cromejq@samsung.com', '8928435839', 'GIKSDOP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mconklinjr@microsoft.com', '5476474187', 'uOQRV0IltIXZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('croakejs@homestead.com', '3724694905', 'HsST6Ri');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zgerriejt@opensource.org', '2034462101', 'GDu23e');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkenwayju@dagondesign.com', '6272664560', 'AuzdJDDGIs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emaciejakjv@chronoengine.com', '7411689514', '9EQ6tfMreI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehauggjw@fc2.com', '4077715316', 'AJasKGgZSYZf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ffifootjx@miibeian.gov.cn', '4884801832', 'oQnwGLk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cvotierjy@mediafire.com', '1824870559', 'VxgxFJIj4q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fpippinjz@slideshare.net', '1005687323', 'cmgG0d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aseylerk0@last.fm', '1544178629', 'q32eP1XzbX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nrokek1@state.tx.us', '3878828776', 'vDGlc9qp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgaitleyk2@soup.io', '5928655073', '39puwpY3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('syanshonokk3@github.com', '9188813743', 'zPHuAfv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgierckek4@washington.edu', '8019375651', 'teWz1ko1i2R');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbarracksk5@liveinternet.ru', '4063685370', 'FtQRPSFEavS9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pgendrickek6@google.ru', '1539252923', 'G1AojCDMs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fcoutthartk7@naver.com', '1706397856', 'D8LAuSs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drentoulk8@artisteer.com', '3716503748', '4H6eRkO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bballintynek9@xinhuanet.com', '9046058374', 'qEJqIvl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmccuskerka@over-blog.com', '7072990519', 'Gb0lpVgedl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sadamkb@fda.gov', '9023841893', 'xUMd1Heyx9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jlarcherkc@usgs.gov', '7173259791', 'QtfRoDqjj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lquilkinkd@reverbnation.com', '7272555148', 'cj7KKlRJUe2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcurwoodke@networksolutions.com', '2979004552', 'E06fAvh0cyL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('coriordankf@youtube.com', '2837738912', 'xR1AqdNe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('psnapkg@nationalgeographic.com', '3138855444', 'JAXik9awTu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lstanifordkh@mail.ru', '6047663604', 'pFXhhJ6ozw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('imcsharryki@privacy.gov.au', '3083522354', 'ok6hJg0F');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgiacominikj@cornell.edu', '3037089685', 'xWKO4djRTEN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcubbinkk@archive.org', '4323012405', 'TcrDZ4jxAuaU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcanwellkl@abc.net.au', '3968631956', 'sZLi0XAeSZEK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ltomovickm@bluehost.com', '5308992568', '98wjPyTzyrC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aolczykkn@artisteer.com', '2853862789', 'Fu5o5O2jjNR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsnawdenko@woothemes.com', '3264536426', 'LEKmdN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wfraynekp@multiply.com', '6804542469', 'WJ2lfm5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdymentkq@seattletimes.com', '9804196254', 'JoKj9vIqZtQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dohairekr@springer.com', '9285584916', 'Wpl5FOCR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwhitmarshks@accuweather.com', '4699201081', 'djFfAXRrI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgoningkt@state.tx.us', '2739119867', 'sAlAPZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alaugierku@livejournal.com', '2502549242', 'EA3sSsBkY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pashmolekv@nsw.gov.au', '8632715600', 'ZzKuMkSOQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shaggartkw@sourceforge.net', '8583084085', '6Dk3fcfidlf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fkeigkx@independent.co.uk', '3512232273', '5TO6dnjkVDzp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jyantsurevky@washingtonpost.com', '4858623772', 'qwhxwwHp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sshilletokz@twitpic.com', '2305201635', 'T1UO39');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bwoolmerl0@1und1.de', '5546866636', '64E8YXdL3GG5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alopesl1@yandex.ru', '3856483814', 'rrlmF7w7A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acarasl2@fc2.com', '2467859405', 'qP0dWOb5lWC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afairecloughl3@ameblo.jp', '1006025780', 'e2RbNDr6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdymidowiczl4@japanpost.jp', '7764959526', 's8ywLaOfSbb9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhallibertonl5@walmart.com', '7129614833', 'j3ciOa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('htremblettl6@bloomberg.com', '5093292894', 'jqTB1B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ckasparskil7@webeden.co.uk', '5927105910', 'VnYsHYTkhC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlamacraftl8@google.pl', '4707815047', 'hTFa8jvKQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tsewardsl9@de.vu', '5309615864', 'G0nGoTsohoW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nmeddickla@nationalgeographic.com', '6103609157', 'x4uCwP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfawderylb@reuters.com', '2114811461', 'QzBfmudZGB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbarringerlc@pagesperso-orange.fr', '3196495167', 'UoTUbQGF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bjusteld@infoseek.co.jp', '1598204289', 'okivlxeI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmattheusle@sciencedirect.com', '5813077340', 'hq9iXs5cx99');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ukestonlf@plala.or.jp', '6642311400', 'm30sAZyQPN9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('csagarlg@china.com.cn', '4696206050', 'mDlCSBRGsu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jborlesslh@go.com', '1818039936', 'EvtrTFxkb9c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wtackettli@yale.edu', '1581322762', 'l2XGupt2LH2m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('grudledgelj@baidu.com', '8299581519', 'XJiEPC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tscranneylk@elegantthemes.com', '4296783213', 'kipdgU3DA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scayll@nps.gov', '3253752650', 'z5aZRJHf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpietrzyklm@miitbeian.gov.cn', '1119609354', '4IastgUNF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfeckeyln@meetup.com', '1995424769', 'ZnIJMRStOs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wmcneilleylo@histats.com', '9187320648', 'eKMd2Gz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hvasiltsovlp@barnesandnoble.com', '4364912226', 'qy1zfp27qL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llambdeanlq@oakley.com', '6596388370', 'UtFHByXis');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oleeblr@phpbb.com', '7347074457', 'Yhhdv3zuXgy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dchiversls@statcounter.com', '3757593555', 'DZt2Y5WqK5Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nkenelinlt@acquirethisname.com', '7616972128', 'nyH6Dnb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emoaklerlu@vk.com', '7879800362', 'sUxv59');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rhalidaylv@omniture.com', '7072269747', 'DqT5WG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kjozseflw@hhs.gov', '8028978932', 'fXqYGDb9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbrasteadlx@issuu.com', '6377204762', 'sOKLmyxW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kstockerly@dedecms.com', '2513609977', '11RUu2qD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tkubickilz@webmd.com', '1306730959', 'rRTOnt7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('plydfordm0@digg.com', '6513740055', 'jNxRnxt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msarahm1@soundcloud.com', '4648813914', 'upX0qs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ffaltinm2@oaic.gov.au', '6443791841', '8b7yubre');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('morthmannm3@facebook.com', '5364223959', 'eRBcka6U873D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmcwhinm4@privacy.gov.au', '4564357129', '6ZPialNs15S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmasonm5@usda.gov', '3132531397', 'O4sDEc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('icreavanm6@google.it', '4084657398', 'nyqxQ356f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmccoolem7@chicagotribune.com', '7767055623', 'MRBtMpxnm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgilletm8@pcworld.com', '4902086489', 'xFvx32c6oXN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jworlockm9@wix.com', '4608842188', 'IK0itrVOlpZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfugglema@thetimes.co.uk', '4351184635', 'hhjxppYx9qu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwooffittmb@cnbc.com', '9068433812', 'p8jOyYpsH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pvedenyapinmc@canalblog.com', '9592764660', 'hWnMDpztO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpallismd@g.co', '7414861987', 'O1Vk90');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aepinoyme@e-recht24.de', '8524112432', '17Lsj53aLDBC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rvickermf@bizjournals.com', '2983917515', 'fcccetrwQz8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lprestnermg@cbsnews.com', '8101318312', 'tlxXvKXd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('leliazmh@springer.com', '3527314797', 'BdVln5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mclemenzimi@sfgate.com', '4246750687', 'JIsUk7AIRoLn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bliffeymj@vinaora.com', '8165685167', 'lLvp18E5N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mvitterymk@fastcompany.com', '1115047616', 'e3zl9SxWRm7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbatramml@github.io', '5074875445', 'VcRLEicn7xFA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dkhidrmm@mozilla.com', '1727585689', 'FKalpu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hsawartmn@army.mil', '3723671486', 'd4NpSGee');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pminchimo@icq.com', '6935200224', '19x2Agza');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjeanneaump@sun.com', '8177670319', 'DbeyGQpp4t5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tjerzycowskimq@macromedia.com', '7227401374', 'y6VmlagYCN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbaidenmr@elpais.com', '9703987114', 'r7bX7S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gantonuccims@amazonaws.com', '1147624436', 'ppvJT4nJ2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccleynmanmt@columbia.edu', '9146293655', 'fL1m5Lj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmccarlmu@wp.com', '5585150302', 'JQ1Ms3NKBD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gtitmusmv@youku.com', '5626119750', '2mvAAzecrodT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sjuaramw@slashdot.org', '3948061842', 'cQDh1QC8f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdarganmx@surveymonkey.com', '9193261460', 'GGeAQ48M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gstedallmy@exblog.jp', '3526511638', 'lrOeNhgaLcL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ktothmz@shareasale.com', '5073056312', 'h3LOHOABgO7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llindsayn0@ca.gov', '7649714249', 'LHtxoIfN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bchmarnyn1@noaa.gov', '2998618502', '2xP7Xa1v9KE1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmatisn2@about.com', '9957929254', 'CccxYed6KTtv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgrinishinn3@google.co.uk', '2022546670', 'JFz9yMc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('darmern4@mayoclinic.com', '8807067388', 'dLRj5i3Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yurwinn5@ezinearticles.com', '5976154780', 'NanUIBtVrf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwattonn6@instagram.com', '3143821824', 'USkEjp7IU5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tdahmeln7@chicagotribune.com', '7487913465', 'h3zufQm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gclyman8@instagram.com', '3457393190', 'gjLb3Hx5dQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fgiorgin9@ebay.com', '7183562906', 't2MwUSLUh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('utonnesenna@dot.gov', '4436925696', 'ObD29FOvzZN4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('coffinnb@hud.gov', '9438549421', 'W6Fil3FTH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('htrolleync@squidoo.com', '6588710931', '1YhuePG77bt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acourtnd@cisco.com', '7017856588', '6LwcEmxgzWB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jkullmannne@vk.com', '4981842046', 'C8d03CdX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbellwoodnf@csmonitor.com', '4664960316', 'FxbhiL65t');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spriddieng@usa.gov', '8458410908', '5sMG6CHRz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smerritonnh@google.nl', '7167099557', 'f6JR5GmVeqzT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ajoynesni@fastcompany.com', '5557123260', 'ad0kd1P9I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gblownj@prlog.org', '5608672998', 'B8KK4YitU3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtanbynk@123-reg.co.uk', '7918055518', 'ejUNHto');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shincksnl@phoca.cz', '8415301177', 'lYi6mC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edeversonnm@statcounter.com', '7423988422', '4jR1NJAsIqpG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebentleynn@google.es', '4686747670', 'zQzkhxq6Y5S7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgalleyno@businessinsider.com', '5717017409', 'VY0hq1O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alasseynp@weibo.com', '3228514848', 'UCluPar');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kaskienq@mtv.com', '9085925524', 'fVzpIroud7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eklimmeknr@arstechnica.com', '4581373956', 'FjVFUP0Xnv1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbarrsns@histats.com', '7859053725', 'NEdQB5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebraidleynt@paypal.com', '7041353496', 'qVTzmfd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gpeerlessnu@google.pl', '7166227849', 'sKiaLFNB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pmarcroftnv@blogger.com', '5899397774', 'S9Yba5buif');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bnevisonnw@nsw.gov.au', '9719911152', '99tA6ZuVN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbratchernx@rakuten.co.jp', '6503747227', 'dBZq5pL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhawkeyny@usatoday.com', '5056663997', '8VzdmX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vschimpkenz@wordpress.org', '8928767514', 'QRguv9I8n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbuzineo0@tuttocitta.it', '1544201904', 'LUx2H2n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hpalleo1@ucla.edu', '4368329218', 'UvUJrErQb99l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbeahano2@slashdot.org', '1073265461', 'EWi0lqXha');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcirico3@prnewswire.com', '1867596426', 'byqtzAGfP1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('krettieo4@ning.com', '5442380408', 'gRvaeva');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmcfadino5@jugem.jp', '6653261202', 'NLe8Vw95Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdoggetto6@eventbrite.com', '6861559702', 'Rhxzons7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gtriggso7@slideshare.net', '4829397338', 'aOOkOjbI0b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aapflero8@themeforest.net', '7687393127', 'TwqmpeKVhbwq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hfrielo9@istockphoto.com', '6453119928', 'AiMWXlB4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aspringateoa@elpais.com', '5171424923', 'wNi4MdXQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sturesob@biblegateway.com', '7022605017', '1MWch1VpXq1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rdiioriooc@opera.com', '7659491696', '5rm7IXG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwebermannod@bravesites.com', '8265777485', 'lEHjXRdR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmcguffoe@goo.gl', '6599373540', 'ki71MgthfRw9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srenekeof@admin.ch', '4984934681', 'SNQUOFUfDUOh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmarchentog@wunderground.com', '4828524662', 'FuOxcFDd7kU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amadsenoh@vk.com', '4748876338', '4a6FwLC5TZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgroocockoi@apache.org', '3492175961', 'dZRfvjTc3Pk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aboldingoj@ebay.com', '8142044826', 'F2efyw8Wwg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbrunigesok@dagondesign.com', '3194652220', 'XjotbaJ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sfeldmusol@admin.ch', '5251566197', 'L25AKQdcC0Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fchaimsonom@webmd.com', '3622752000', 'dagT3kV2fHPr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ablesdillon@tripadvisor.com', '4564680262', 'Y8npF3T9Ld9X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dloxlyoo@sourceforge.net', '4068555484', 's4bMCOA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcoldbreathop@prnewswire.com', '3449556250', 'kibVuzv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcammishoq@pbs.org', '9659485767', '89k8wxN01');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wcockmanor@clickbank.net', '4355370850', '6HI3Wz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afielderos@jimdo.com', '8166600129', 'x5JbTGPX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpenvarneot@smugmug.com', '4232721052', 'vb66I0Xa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gchattertonou@google.com.br', '5612180855', 'qY5gauhd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jlabouneov@ustream.tv', '6653088483', 'pqZAQf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbourbonow@ovh.net', '6528122048', 'Itdz0VejO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pquaifeox@bloglovin.com', '1689334731', 'CBls6d17d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kquenelloy@illinois.edu', '4435780484', 'fDFsz8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmaiseyoz@ox.ac.uk', '8648321035', 'KVUbN9q2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgopsellp0@photobucket.com', '6678929799', 'f25gsSz0iOP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('frubenchikp1@is.gd', '5637564332', 'MZoHp6QIgw3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbassanop2@indiatimes.com', '6511148151', 'HxSUq2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mwardingtonp3@parallels.com', '6644726365', 'pF18TlPplF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chacquardp4@issuu.com', '1609502206', 'ceIoFsrR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aworledgep5@dmoz.org', '4011301251', '8CvZ0x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmatterdacep6@virginia.edu', '4334915252', 'N0C7DM01m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bburdonp7@sciencedirect.com', '4155119265', '8pBorgo0P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcogginsp8@psu.edu', '3544361261', 'HWrKXOy4p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('astantonp9@naver.com', '8986742509', 'Ecw22KJ0uOQZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kokynsillaghepa@weather.com', '7159991851', 'AV5JbZsS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('riliffpb@ibm.com', '3361121836', 'AZ8L4qEPy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vgavinipc@xinhuanet.com', '8684768770', '1IXUntrmks');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbowlaspd@php.net', '8841352147', 'o40qqtUykLLI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mferonetpe@biglobe.ne.jp', '9402969472', 'UcngvZ6Q4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obrandinopf@amazonaws.com', '6389043739', '9cBDGXoTo3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccrookshankspg@wikispaces.com', '3841836487', 'jkJe7A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wcamolettoph@rediff.com', '5918448241', 'bC5B5DsF8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkeripi@gizmodo.com', '9787308227', 'PqpZAkPdagO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amelliardpj@creativecommons.org', '8149089684', '58ePdAhBnN2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpaulsenpk@nature.com', '8368265451', 'Pwgg2cNuX5lk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ralmakpl@domainmarket.com', '1398195986', '2oDw0Rf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmelmorepm@shinystat.com', '4536767163', 'l8E9yd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gkaretpn@constantcontact.com', '6103812653', 'vUGWKRPOO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcreaneypo@a8.net', '6947978661', 'YkH7ajwGVs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ovallenspp@i2i.jp', '6326709099', 'DMbyNx68Ymtk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eadamovichpq@go.com', '2099175712', '1F6Y0r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jugolettipr@barnesandnoble.com', '1823441603', 'ThOCc7qO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aswiggerps@mozilla.org', '3739999830', 'BVzbaRW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('upatriapt@independent.co.uk', '2167800507', 'AQ7GRWGTCiKi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jyerbornpu@psu.edu', '8742444925', 'sTo5BGnYx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tryriepv@dyndns.org', '8402915733', '6ToZiVT7P5K');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdunsmorepw@utexas.edu', '8769669714', 'kyHcbo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('whaithwaitepx@google.fr', '7814032755', 'ehw5u1Ij8Lo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ltewnionpy@ed.gov', '3563065862', 'J1mxk3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbreissanpz@nymag.com', '7872425730', '1U7HTYsH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bchristiensenq0@4shared.com', '2242465226', 'W0e141Dt7A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbourdonq1@walmart.com', '5175094307', '1VIGJzA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmacclenanq2@cnn.com', '7577718251', 'at7AKufF4o4S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cchiverstoneq3@typepad.com', '2151877747', 'PohuyoV1Wb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wskeeneq4@nationalgeographic.com', '3796746175', 'NdxudbLpF6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atuberfieldq5@unesco.org', '3193852651', 'mLr2PUYve');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aduberyq6@prweb.com', '4829933746', 'AqKBgL0sY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfludderq7@usnews.com', '8723455996', 'mbu0LH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('twinkleq8@usnews.com', '9531087228', 'Bs1HobSpQIft');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('keklessq9@exblog.jp', '3838638284', 'zrAk6e');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgellettqa@de.vu', '3426551382', 'EjQT6vGIKmPY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('furienqb@aboutads.info', '5805282623', 'ZBblZH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('blightollerqc@wired.com', '7209530570', '2cM9Bdt6C6JE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhavisqd@bigcartel.com', '5599878678', 'Ybhl48NjEmOh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asellstromqe@shareasale.com', '1505586673', 'Y4u8efMSoGZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('koakeyqf@theatlantic.com', '2381138676', 'exd3unOgg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('djakolevitchqg@hibu.com', '2386092781', 'vYk3ElV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbloodworthqh@google.nl', '9045186554', '3ocTNKkny');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fpattonqi@dedecms.com', '3925929619', '3zRSZw9CPK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhuxtonqj@google.com.br', '8257822075', 'hHZZ8Aajh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aferraoqk@nbcnews.com', '4585224292', 'BEMNgQlKM0Hg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdibbinql@europa.eu', '9462593791', 'QLWaZPaJ2U3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgrimeqm@loc.gov', '5913944423', 'YZvwuvRuK705');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hcheesleyqn@bloomberg.com', '5868486935', '1b3fMhr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fharlerqo@people.com.cn', '8094909732', '5E9M9zKeWCt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwiggallqp@xrea.com', '9821338846', '62OB05iGU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pabbisqq@sohu.com', '4915816108', 'Dwo60TAjOrYF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yoverilqr@gravatar.com', '7919220435', 'fNQL4hlgUrRp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llodemannqs@ycombinator.com', '7948679475', '490ir9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkovnotqt@booking.com', '6856081313', 'gi5jwHZG6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pepslyqu@rakuten.co.jp', '4431263120', 'dI15PfmFKm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgeorgesonqv@chicagotribune.com', '5957077373', 'Uvb1zv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smugglestonqw@zimbio.com', '5297502376', '5sTa86ic');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sarnliqx@flavors.me', '1538635720', 'XlaEoIpi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('csallqy@themeforest.net', '2022414524', 'A49QWoFy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rleathwoodqz@aol.com', '6128655060', 'mWnf4L9p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('melliottr0@acquirethisname.com', '8411859438', 'T44mGiXGyr3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ghanksr1@slideshare.net', '3944793577', 'lJCYpxuT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgouldebyr2@chron.com', '9155802131', 'ChvqiEB5Ed');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eschelligr3@psu.edu', '9233283388', 'ijngoUTi09');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ajoinerr4@epa.gov', '2012618107', 'wsthIhN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgannawayr5@buzzfeed.com', '1044613324', 'rfzuqIiEkQz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjessr6@google.fr', '5071988379', 'FT2X2lXs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdibiagior7@google.co.jp', '5918987845', 'v3TdtK9rR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbickmorer8@google.com', '4281973179', 'lWOnQp8yfbi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbifieldr9@soundcloud.com', '3593136777', 'fYan2x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msattinra@odnoklassniki.ru', '7208173235', 'X5ywFs0XIZeo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wpearmainrb@yellowpages.com', '4592862129', 'LvX7DnsqY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drotherrc@eventbrite.com', '8451798725', 'fEWO41E5dyIk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcuxsonrd@bbb.org', '7059428680', 'kr2rd7iMI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kportrissre@51.la', '8037221911', 'QohaaW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acurrrf@census.gov', '2486784225', 'Lghb22');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmeadrg@over-blog.com', '6145300899', '6K6Kmn3hby');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swhistlecroftrh@woothemes.com', '3865798428', 'gGUTmZ1oQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ekarpfenri@sitemeter.com', '9972665747', '5xe1F07QA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgawithrj@e-recht24.de', '6902354555', 'lVJHaB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdeverickrk@geocities.com', '5952459010', '9sPGctR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ecromleyrl@simplemachines.org', '1725503255', 'r3iReQb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vfranzinirm@furl.net', '2298625612', 'bYCL5geSFoU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsalzbergrn@facebook.com', '7035008676', 'JXZzF3Qdf9Rx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('glepporo@amazon.co.jp', '9582457614', 'YgoD4RJbl5TE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('olejeunerp@gizmodo.com', '6352726492', 'kRg9MX2ra1Dq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pbarthelmerq@blogtalkradio.com', '5277020746', 'q4WiDyO2qz5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adebernardirr@soundcloud.com', '2209087162', '2ghBPmeE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('thayers0@friendfeed.com', '6799655809', '16CYoV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nloveless1@dmoz.org', '2237165715', 'udzQ2cMG8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hgambrell2@xing.com', '2786511711', 'd717bA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfellibrand3@ftc.gov', '7792672101', 'QMDD1BtBsTmj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('daldren4@alibaba.com', '1231142541', 'lHf8s8ENMTK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmatejka5@merriam-webster.com', '7228231936', '1rfYw4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmoxted6@meetup.com', '7505767315', 'w8ZqByNtKiUH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ytennant7@mozilla.com', '9001279253', 'XA37873Et');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scardero8@adobe.com', '8981414324', 'CEf1RBXfqqa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msiggers9@etsy.com', '4215412070', 'Ird1Qma6Xj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbeamisha@upenn.edu', '8454326637', '4ZYxUx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ppanniersb@indiegogo.com', '2687113206', '4gY7Cy1eN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ralyonovc@upenn.edu', '7601137425', '9Xjc54Xwy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dolenind@joomla.org', '2288506675', 't4xZgdF7J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ajosephse@liveinternet.ru', '3448270908', 'Vw45fBGJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlivingstonf@drupal.org', '5821106741', 'AHZwvBF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ykunag@epa.gov', '9249239989', '6Eka1dHRH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpurkinsh@aboutads.info', '2319790341', 'aPhZAdYW0cN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jnarramori@abc.net.au', '4722801948', 'ML6DCETUxXrk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddoultonj@cisco.com', '3004745826', 'EmIzCLxmab9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmandelk@mysql.com', '7017563382', 'TLUZIpiD7GM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mrambautl@livejournal.com', '4511141473', 'At8TJE4dY9bv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbudgenm@phoca.cz', '1032296206', 'pZc9wtpnXU9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbaynonn@dagondesign.com', '8954996539', 'ZLqT5VWReMHx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcottesfordo@jimdo.com', '4633041219', 'ziLSW5aL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmcaulayp@irs.gov', '2901801148', 'bgef823Jn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('evallentinq@yellowpages.com', '7714301471', 'EDeJO4WhA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbacher@geocities.com', '4898931603', 'BiobnOIghZw5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jprovests@salon.com', '2234396311', 'EF6nlIWJZJ2L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgibbent@skyrock.com', '9226192454', 'ka3d9UxAQbW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gpocknollu@ow.ly', '2929683775', 'v4kvBk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmcnirlanv@youtu.be', '1216691390', 'wHPUiZBbg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jandreopolosw@pbs.org', '1791904231', '7kxdG43QU2l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kellamsx@shop-pro.jp', '8833267286', 'HMthXKADTwN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcrippsy@princeton.edu', '1632106973', 'OYI5Jhl7L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nmalsterz@shareasale.com', '4289709337', 'aqaWG7fGIQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esidney10@lulu.com', '4789613547', 'wVlW05FFf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jhallihan11@examiner.com', '1893889792', 'ZmXq8xqY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('twattam12@naver.com', '4177990923', 'qja0XJD06iiN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('poak13@unc.edu', '7068046420', 'Zyfa7B285OpA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rhambling14@kickstarter.com', '9872768610', '7jt9jhIYFT5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdutton15@digg.com', '9021101370', '5fTDt0AR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfairfoot16@cpanel.net', '6921133938', 'DzpzFGO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mwiper17@ocn.ne.jp', '6092947663', 'HjDcGuFKRzs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmccahey18@intel.com', '8208359177', 'AVXW8p2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aaskam19@prweb.com', '1687217199', 'bktRzm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('htankard1a@sogou.com', '1277797391', 'pscRTr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kcapstick1b@bbb.org', '2188266586', 'S5Hn0Elgi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhammell1c@fastcompany.com', '6385409587', 'nWKsxq5ksz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kzanardii1d@census.gov', '1142517811', 'c2ZaNc8f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rtertre1e@wikispaces.com', '5546831489', 'qC8Tq7A1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fjiracek1f@goodreads.com', '8167546403', '3HL5f1IyGkF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ezannotti1g@businesswire.com', '1779137307', '1U1Xh25');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nmatyja1h@typepad.com', '5158377504', 'SHdyvRR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mflowerden1i@hibu.com', '7548265132', 'FtnkDcQc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dshmyr1j@goo.gl', '4169629822', 'aQIp0rm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pminci1k@wikispaces.com', '1316705404', 'ylWDVjFmH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fpistol1l@multiply.com', '3301551346', 'HeOFn8Iftpmi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhrinchishin1m@cam.ac.uk', '8228570713', 'ZEDOeTN8Tfe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpiletic1n@webmd.com', '6567122301', 'UlNrFt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aclutterham1o@va.gov', '9585517121', 'GyrPIjSW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdullard1p@bloomberg.com', '9962107033', 'cRzAcPI96X8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('psiggery1q@europa.eu', '1361560267', 'v4RrBN6cX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rstilling1r@washington.edu', '6342464408', '9YmKQR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spechard1s@bloglovin.com', '9081196310', 'zC0RyT97o1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlawther1t@paypal.com', '1782256841', 'jdUW38scj1D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbrayn1u@businessinsider.com', '1966303891', 'SEhdJmk5LaN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ntettley1v@yellowbook.com', '4905246213', 'bz4AQ7RMI0a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgreenman1w@exblog.jp', '7234561829', '6MBKcUYRXId');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcorran1x@cnet.com', '5577180507', '1M0lluR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcressey1y@a8.net', '7771136569', 'zsmlVEKwnk5W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eannetts1z@ucla.edu', '6455527715', 'g5nTZU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gportchmouth20@reference.com', '9562090524', 'C0bLMgn81');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmaypes21@cpanel.net', '4628924383', 'OeXbx4gC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aalcoran22@cloudflare.com', '9617670267', 's3fThdZ3nA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gadie23@pagesperso-orange.fr', '8055889199', 'NpXBHlL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kabeau24@admin.ch', '3974428801', 'f2OoWeVN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmalthouse25@nbcnews.com', '3665396014', 'theUAvtBb4r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acarreck26@ca.gov', '5412747280', 'uo1FEwJSWQtz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwimes27@upenn.edu', '8293522514', 'HLHidX1GrW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wwatling28@oakley.com', '9731740535', 'swoJvE3c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lisenor29@drupal.org', '2798101947', '2mT3Djqsn9G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rchafney2a@washingtonpost.com', '5704258861', 'NvQnPHiQv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rempringham2b@alexa.com', '7591073047', 'PQhC3rs0jQD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('imullinger2c@printfriendly.com', '3911086930', 'CJV4NMJWUm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcarder2d@about.com', '2321131209', '4miIGtq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmallia2e@fotki.com', '1465432371', 'z9TLA4a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adragoe2f@japanpost.jp', '9244391728', '7p22biZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rshaefer2g@aol.com', '6452498565', 'VQTBKmbwS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpendrick2h@facebook.com', '6783649720', 'Oz5ha7A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sponton2i@gmpg.org', '7329557010', 'nz932mRFqyW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gfero2j@php.net', '6381867961', '8SKiPxmf5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbazelle2k@behance.net', '6794922094', 'nofUw4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pjedrzejewsky2l@businesswire.com', '1553164260', 'n5mpQUj9i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rspaunton2m@ask.com', '7971558712', 'HJldtT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mthying2n@uol.com.br', '1091999063', 'pBLvhV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aflury2o@wordpress.org', '2603349803', 'VpLSMlAqC80');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfowley2p@time.com', '2463860856', 'pjhAGj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cderrett2q@shareasale.com', '2062348894', 'gdSXS4N0Ue0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lkoomar2r@t.co', '1158948413', 'CGacLM4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dburnside2s@scribd.com', '8618562369', 'OX9gXc6nr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdamiata2t@spotify.com', '3529112449', 'YGwcmYc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbaszniak2u@shutterfly.com', '7521129905', 'vLoKcE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jetridge2v@istockphoto.com', '4773811465', '9EEOTGFRDYr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afreiburger2w@gnu.org', '6485471176', 'AeJQaPfg84Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbasill2x@mlb.com', '3223828600', 'rmdmQbi5F9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmcgowan2y@canalblog.com', '7882961123', 'njiEq9uC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yroelofsen2z@yandex.ru', '7206417781', 'pm3L2OPJx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('akorf30@wordpress.org', '8768734025', 'O1D31yg9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctew31@wisc.edu', '7779539646', 'VBF8N8aRav4J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwillcock32@ow.ly', '3097167509', '4OIrAC4iYqd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cshadrack33@barnesandnoble.com', '3804709191', '2QjPBSyRlYt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tabrashkin34@fda.gov', '2156398136', 'uRnprw5ux');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pisabell35@usgs.gov', '2255390549', 'rEhWP5g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ueland36@salon.com', '9976634049', 'fVxrqKki');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hsergean37@discuz.net', '1936193077', 'euO98Oa2qM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmetherell38@networksolutions.com', '8781968379', '1k3w8qyDJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('astrognell39@jiathis.com', '5032463472', 'tN610I1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhake3a@trellian.com', '8129461889', 'k0pDMODTtYAt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msacase3b@tinypic.com', '2917942278', 'xnxy7I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aoherlihy3c@cnbc.com', '2431788179', 'VqqlTX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abecaris3d@friendfeed.com', '5797046628', 'TogNHHN5J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kjovis3e@zdnet.com', '2676375247', 'f58WPpTtF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rtollow3f@vk.com', '5839319420', '353WpqET');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('brodda3g@over-blog.com', '6469771622', 'MTHn90CnDdy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wlindro3h@artisteer.com', '2639492519', '9D68cgIfrvcH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aledrun3i@jiathis.com', '1493983406', 'C5MEA6KgCQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cyosselevitch3j@elegantthemes.com', '3934901286', '9wLtH5XnAx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lberick3k@meetup.com', '7337819271', 'LT1M5runOd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jscriven3l@bandcamp.com', '5379913869', 'htF6ZISwzv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awhitebread3m@moonfruit.com', '2532698405', 'NDMfrx9Fi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aredgewell3n@google.co.jp', '4836007700', 'GfRirBZw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eghirardi3o@biblegateway.com', '2752189961', 'm4Ff4zVlS2d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('orobillart3p@live.com', '8489442739', 'bJoeQ9MGcF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('benderby3q@netscape.com', '8781952871', 'F1KNCBH2v26');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('efeavers3r@intel.com', '1987283575', '1Njty5Xc6Br');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdelaeglise3s@jimdo.com', '6158998864', 'H4meG06L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gstefanovic3t@wsj.com', '1427163544', 'b8TwkDl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kkeywood3u@intel.com', '4911277015', 'cZ7dsxZOJwqR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ifulton3v@state.tx.us', '4248705659', 'LLYuUyo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgirdwood3w@aboutads.info', '2832928005', 'oAofc1sAf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nattewill3x@behance.net', '2548487096', 'zM4nVSbBr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qdominelli3y@irs.gov', '4721646232', 'RolRBGJZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpoinsett3z@fc2.com', '4719811538', 'f0W29lzQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btran40@hostgator.com', '6701006391', 'fvEAyS2L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('thodge41@yellowpages.com', '8171013928', 'ri9aN10uGUr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drathborne42@dailymail.co.uk', '1972396330', 'zJa6122v5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbourton43@google.ru', '4935556400', '1PZqvVYD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kneads44@boston.com', '4254179251', 'mo4hAVST5Wu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmedlicott45@goo.gl', '6222956566', 'k1jxPE4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbelsham46@github.io', '2169009321', 'fH11GIDJhuv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpersse47@berkeley.edu', '3562118257', 'TZjopLErOfqB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdegliantoni48@webeden.co.uk', '2188078569', 'Hhq5mf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmattea49@1688.com', '2611798501', 'DdTn3phoZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hpyson4a@constantcontact.com', '7728016756', 'COTlFornTGv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nnewart4b@acquirethisname.com', '4624555317', 'YymKmlLh3D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmarcroft4c@eventbrite.com', '3827678160', '7MPlfbX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpfeffer4d@delicious.com', '7089625127', 'BTG3WSOBI3uU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bselcraig4e@yahoo.com', '7423561212', '3eoHcmcxtb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpennock4f@pinterest.com', '4492720113', 'ZXm84Y9XO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nquelch4g@marriott.com', '4703311436', 'kCMW9kd3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbillings4h@squarespace.com', '2876703612', 'aJyhUszs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('npoolman4i@flickr.com', '9811626716', '03UsypBw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcaldroni4j@naver.com', '5901790385', 'EkdFCCq35GNS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmacsherry4k@businessweek.com', '7064152651', 'kdzCoJMGA8C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qmccully4l@phoca.cz', '8426585181', 'SNOapW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpengelly4m@360.cn', '3416591960', 'jUdbcwo2Dm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfulk4n@samsung.com', '2637548044', 'kNGjnCBHVBtq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('priccelli4o@hatena.ne.jp', '5533194140', 'xf6XbT6imNu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbodle4p@jigsy.com', '1766010180', 'a42UUS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nroz4q@gov.uk', '3577410296', 'W3hCdSR1w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mneesam4r@jalbum.net', '5843067250', 'eKlLmf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcordet4s@123-reg.co.uk', '1186597010', 'b6pGf9A0yJI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egrandison4t@discovery.com', '7229988985', 'wzFIFUTn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('elillywhite4u@discovery.com', '9273334225', 'Xa4tNfrCPS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddunthorn4v@whitehouse.gov', '6796638257', 'tT8ffc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcargo4w@flavors.me', '8627437496', 'SCEXws');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qclaessens4x@mysql.com', '1145999672', 'IRpq3j7Wnp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpentland4y@mozilla.org', '8663211584', 'PyJjfg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmayell4z@bbc.co.uk', '6276791651', 'iO8AKe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apalfrey50@washington.edu', '5691209144', 'TbPyoA4A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msyratt51@java.com', '4646842132', 'wBg1ba75K0N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bwarbeys52@cnbc.com', '2217101627', 'CoLLZlGPz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scraiker53@studiopress.com', '4346513095', 'RrUpOCsG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahammersley54@wikipedia.org', '9923890870', 'yf8logwKcFy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebowater55@friendfeed.com', '2076881578', 'CiSnWH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rharmson56@wired.com', '8662100496', 'leq5tkF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nkeston57@omniture.com', '7235782138', 'CJQdGpo1P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agreason58@topsy.com', '8983330539', 'dcfzNCiBSn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbodycote59@blogtalkradio.com', '9888806872', 'cuzhz7hj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acrichmere5a@blogtalkradio.com', '7673160964', 'msc9GtxzXU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bclawe5b@addtoany.com', '2028869622', 'Ch82e9YAi8a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('umoyse5c@tamu.edu', '1866889964', 'Mbb7JGp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfarney5d@about.me', '5028564230', 'aELwjjGrY4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkearton5e@51.la', '1923087863', 'A83gZ5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gredsall5f@usgs.gov', '6957558171', 'Jvfp7qbKqmmz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gperon5g@marketwatch.com', '3156846204', 'h1bgOcbYi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pskakunas5h@discovery.com', '8485312694', 'ncbgu6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ladao5i@github.com', '6258281879', 'KUa3ckPpG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbecker5j@fastcompany.com', '3147540668', 'IZDB8hCSjn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ghulmes5k@opera.com', '5047887307', 'ZiM1JX6w66m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhollerin5l@google.ca', '7265781277', 'f0OwlvieX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmusk5m@dedecms.com', '8316877268', 'PyftAN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egiannazzi5n@cloudflare.com', '5109999291', '1iJUa7pJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acoldbreath5o@people.com.cn', '9483585691', '60sBw6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bburrett5p@xing.com', '8128944507', 'fWDR2UilU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klupton5q@cornell.edu', '8168736675', 'Bn594rIgf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adeftie5r@nature.com', '3023333395', 'HVh0Y5usx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jlatey5s@phoca.cz', '5744227571', 'NBhYhvW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbrightey5t@t-online.de', '2022629321', 'RAQ2xFuA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdibiaggi5u@webeden.co.uk', '5905749630', '3egKApbkIy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcansdill5v@hhs.gov', '1472471698', 'g8NqhPLfJyB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpharaoh5w@google.cn', '6004650490', '9uvl9c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mflattman5x@ebay.com', '6176293631', 'YqUYwpKy2dkp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lleschelle5y@squidoo.com', '6845902590', 'QoBJmRO7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mekless5z@walmart.com', '8355990253', '61qEMUB2YTq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rallebone60@tinypic.com', '1934861641', 'BWMsPrMsw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcrinkley61@sakura.ne.jp', '5293090818', '8QFYdlrP37');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obrockhouse62@themeforest.net', '9252964313', 'KJTlr7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klorenzetto63@state.gov', '4703706370', 'ebsZcNRNks');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btregunnah64@ustream.tv', '3937909787', 'mggcE0aZ2VM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fgolling65@goo.ne.jp', '1967544431', 'PlG2yRWD0H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jkaspar66@blogs.com', '2906186987', 'RYxTXmccZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ptrenholme67@amazon.de', '7291152034', '6yTTGG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adwane68@usgs.gov', '2395676846', 'W3fk3xrbV6L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kcurrier69@tumblr.com', '6505696331', '54PSj8pCDypn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndelacroix6a@icq.com', '6474229083', 'xPhDmeuCDG2c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rleyland6b@sitemeter.com', '7854995008', 'bPFfHccbrij4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abouchier6c@hc360.com', '7916394173', 'wDqINBlW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nwythe6d@un.org', '9427288476', '8UCNBrTZg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebaudi6e@bloglines.com', '6647832936', 'E5FUhs7T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swyrall6f@reference.com', '3181306700', 'JCxEIop8C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acrumb6g@sbwire.com', '3978927479', 't9pLxWp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mrathmell6h@squarespace.com', '9775070018', 'juYuyzNCf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esedworth6i@google.fr', '9329913340', 'CaNlaU4jR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ochilver6j@booking.com', '5645249106', '030iVdKm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jondrus6k@linkedin.com', '7063844853', 'onX9L2w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpiegrome6l@disqus.com', '8205304685', 'Rb3pwzSJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddalgarnowch6m@vk.com', '5081815765', 'eTx8SpQdS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpuleston6n@washington.edu', '3125690208', 'jJsNIX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgriffiths6o@cdc.gov', '3049915504', 'PNB37GBMPFCv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbergeau6p@google.ru', '5838223722', 'JXPrG3vaVlob');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('diddiens6q@disqus.com', '6928561368', 'MPMJoN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmerman6r@reddit.com', '4898205612', 'xgSsWKKXPg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ttoghill6s@opensource.org', '1792003238', '2Tjt3dWz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgallandre6t@nationalgeographic.com', '1852384645', 'NVNgEP2y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mspenley6u@123-reg.co.uk', '8161130897', 'Ay3ujy5j9P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ngawthrope6v@devhub.com', '4931156994', 'V0IVdmIes');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpragnall6w@trellian.com', '4222981976', 'CussNKU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('helster6x@ovh.net', '4424629769', 'tMn1MI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tnower6y@indiatimes.com', '1512406383', 'SskuA1Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qubanks6z@uol.com.br', '7726128785', '0gKLhLuaYDwT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdonat70@mail.ru', '3037033799', 'nQArcdV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jheephy71@smh.com.au', '7598262661', 'cZt8Dmq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('njefferies72@bbc.co.uk', '7961041840', 'YvrPQlql');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('creye73@spotify.com', '4189443365', 'YDs7IFT7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sfloyd74@nature.com', '3116909486', 'o1wBIno');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acinnamond75@slashdot.org', '4369598147', '3v9eG2o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcarous76@usgs.gov', '1295984216', '0AqKg0bBOoh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mclousley77@ucoz.ru', '6002172311', 'rk6xG37');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsloss78@cbslocal.com', '7198443920', 'E2IPTA82');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgantlett79@nydailynews.com', '9262438413', '0EkIKNm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rharlow7a@desdev.cn', '7005935735', 'O2ZBN68');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iramel7b@earthlink.net', '6669482425', 'FhcPHJfl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emcqueen7c@addthis.com', '5778272465', '8h4PEHw0Ax');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmaisey7d@icq.com', '3967365197', '6JOwl7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lziemens7e@hexun.com', '1265065038', 'aMJIV3tp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aduham7f@reddit.com', '9328106166', 'Sng45SDHI7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rdurkin7g@mashable.com', '1832276228', 'KHYcZz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gstevings7h@cdc.gov', '5081807250', 'aATTDUWZXz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gpolsin7i@mit.edu', '3722413382', 'SNvmeZR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dkhalid7j@bravesites.com', '6987544580', 'IvV5dzLvxtY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlarcombe7k@nbcnews.com', '9075815792', 'yDD0vqE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mstubbes7l@bigcartel.com', '3757482399', 'qxvBEf1nA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lrichardet7m@google.ca', '1064350112', 'saG6kJUWaq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hsineath7n@chron.com', '1096128223', 'AmATcdmr2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsievewright7o@topsy.com', '5148800285', '523KTcxqMOE7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('larro7p@europa.eu', '8718529622', 'wMID8QXnebA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdeverille7q@mlb.com', '9156983977', 'SwSfA1D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebonham7r@blinklist.com', '3259650656', 'Md8MRNxC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ufitzpatrick7s@cnet.com', '8499693684', 'RI2u3B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgreig7t@ted.com', '1642808009', 'UsUqVNaT1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('trunham7u@blinklist.com', '3557515472', 'xtRdPV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlobley7v@geocities.com', '2152849207', '1q0aBIvrbbTE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgoulstone7w@free.fr', '8935769766', 'ewJAj2aWIu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tranner7x@shinystat.com', '9752493846', 'ct9S0wf7cv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zshovelton7y@umn.edu', '8018099348', 'OFKGsPp55MJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gstener7z@google.pl', '2668907167', 'IfKsbb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmaccaughey80@hexun.com', '3896849710', '3RxM60AhEq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsemble81@wired.com', '1273158235', 'ninhP2pZhupM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbreens82@reuters.com', '5206491147', 'ft1w8FN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmell83@whitehouse.gov', '2926600904', 'SJawEc0Uf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmiddlemist84@accuweather.com', '1123898098', 'rhzyz2G7rGCO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gnorris85@surveymonkey.com', '1177051758', 'nt1BXux23kPx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwoodage86@amazon.com', '3828878857', '7ct5vzb76Jey');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ejoskowitz87@reference.com', '4775545219', 'guJn3GC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('etalman88@feedburner.com', '6251079316', 'j8hLGUP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cedmed89@msn.com', '9638405006', 'm8jwPRoBin');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jderuel8a@dropbox.com', '1936615373', 'iu2tY6aXloR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ftomicki8b@thetimes.co.uk', '7183761027', '9zAU3y4VS1HH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbates8c@sfgate.com', '8168843974', 'dTBJp1z2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcrickett8d@networkadvertising.org', '8298468775', 'zbUEhI3CY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('balden8e@shinystat.com', '8162716450', '4RlaBVnKa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gharding8f@google.com.au', '9624791197', 'pYJusWGg61tB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmicka8g@cdc.gov', '6065331322', 'tJu6C7N6LDEF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scastagnaro8h@webmd.com', '7601393356', 'i15n63');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bscorton8i@cafepress.com', '5941545055', 'Z1vtMania8yz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nskipton8j@prlog.org', '1002883874', 'sNdN9G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msproule8k@4shared.com', '8877116641', 'CVmYebu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbagnold8l@guardian.co.uk', '5641076088', 'eMMIRK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwoodeson8m@hugedomains.com', '5435594131', 'DivbBS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hosheilds8n@godaddy.com', '7087114784', 'Zink0lUqbJ7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('htyers8o@jalbum.net', '4565819546', 'NEoQQh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abenediktsson8p@booking.com', '5037535149', '7mpB1C7Yl2H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmacellen8q@dyndns.org', '9883490233', 'FMKL9GZPje3G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sglanders8r@etsy.com', '8221118128', '14sJmM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rthomasset8s@amazon.com', '5904476260', 'YMkLGu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmiddiff8t@reddit.com', '8773335886', 'Z7bczjWStf0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfelten8u@t.co', '5585402034', 'v97OEIK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sradoux8v@loc.gov', '4614097960', 'ZfZhcU3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hscard8w@bloomberg.com', '1239924907', 'vH9NYGfjIWqN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddelahunty8x@blog.com', '2492776478', 'JJPJDP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vbackshaw8y@livejournal.com', '7197102753', 'oRxyhWD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfolshom8z@ftc.gov', '4715792109', '4mZ16Rj06z2V');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scroom90@yale.edu', '8706459912', 'CIxHClpOWT8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmartyn91@soundcloud.com', '6275179048', 'IaqnVPr25W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fallright92@harvard.edu', '7626419259', 'TDWK936m8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('creford93@hugedomains.com', '1482717132', '4LSySGV16ne');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmullaney94@hatena.ne.jp', '3868655296', 'yYp9ehW9NN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gizaac95@storify.com', '8829997773', '1uc6YiZnPU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbrawley96@pen.io', '7155790398', 'mqoBHSAH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edowson97@craigslist.org', '3852372054', '0bbTwnT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfrisby98@ca.gov', '7101615675', 'VIiH5g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpesic99@home.pl', '7175516439', 'lQOvKYzvcB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('crames9a@youtu.be', '9631491566', 'x2cqog');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgreenhowe9b@altervista.org', '2874916521', 'AblCtcc4br');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jneighbour9c@smh.com.au', '5554207249', 'WllKDJzJfDb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpurtell9d@wordpress.com', '4444565937', 'hHfRq3gafu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcalleja9e@amazon.co.jp', '8068655597', '1v0eh4bhF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhutchens9f@bluehost.com', '6659535650', 'LFOMCLmXk4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctatnell9g@cpanel.net', '3407199942', '6S7Ivc5E');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmccaughan9h@google.cn', '8242110934', 'rlzXeBWgCsx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmorrice9i@miitbeian.gov.cn', '2632465629', 'omh4jWdFD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgarlinge9j@geocities.com', '1905770107', 'txvki9pZE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zborer9k@mail.ru', '1044423238', '4IkWrVpw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mruddoch9l@house.gov', '1587491035', 'fucfB9a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcharlet9m@guardian.co.uk', '3415784099', 'hqEE0Ffi0ag');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adeverehunt9n@tumblr.com', '1864453460', 'VVnCVQ3RHf2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbrettelle9o@fotki.com', '8874833344', 'mDVojJ1EDeO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwittey9p@github.io', '8822621193', 'v5trxt6S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aaddicott9q@wp.com', '4052374974', 'WeIGp2jui');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('charg9r@foxnews.com', '6314628449', 'pcUvNo4SiOAH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ubreslane9s@bravesites.com', '2395932756', 'ZRBi64jN70');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdoak9t@msu.edu', '7413183027', '0y5ouxXkb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbenedek9u@ed.gov', '4388605983', '4DtLb37JfjD7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtabert9v@washington.edu', '8953190048', 'QB3hemVQ3i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fkershow9w@wikia.com', '9664423367', 'I87pcYXOFRGK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('opersitt9x@icio.us', '2618363733', 'Qk5beQe6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebroggio9y@eepurl.com', '5019358128', '9gqGch8W4V');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jimorts9z@unblog.fr', '8959503386', 'CmJF9UVOA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aryletta0@blog.com', '6116158203', 'DmRHSIf2vYpw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kknocka1@spiegel.de', '1283636332', 'OG5WYecAnbaC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbeynona2@dion.ne.jp', '2705976416', 'Rh9xtNyjvJk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('basbreya3@facebook.com', '5208164993', 'mabhHh4H2R6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mkingsnoada4@a8.net', '5599286790', 'h9tv9hk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ralmacka5@infoseek.co.jp', '8951960893', 'IGQT6iU9n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jturnocka6@google.cn', '7506776037', 'DRNbbtjgRYx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bwasbeya7@xing.com', '3917462136', 'ZjL2gP53Lx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nandreua8@cbc.ca', '8541603126', 'tGHfymNSoNn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmunforda9@omniture.com', '2196868461', 'aoi48FdPW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hhuegettaa@furl.net', '1563046997', 'aFmwHqap');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edwireab@prlog.org', '1134805957', 'PknfNL3aRq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgrinsteadac@alexa.com', '7854184437', 'n4qu23QirPfs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rquidenhamad@trellian.com', '9817070022', 'VCzBgoRAeIbw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ewallickerae@imageshack.us', '8399182575', 'NYaWCiJ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('viannielloaf@rambler.ru', '6143731168', 'sX8BYIi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hstaigag@shareasale.com', '4198431208', '14XTTn2ep');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmicallefah@nih.gov', '3942748110', '3Q5acWCFvBY0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('averickai@google.ru', '1733434325', 'k2oKeb48obp1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sferyaj@godaddy.com', '7776606301', 'vyMQfNo9c3ai');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cvinceak@odnoklassniki.ru', '4728455181', 'Uylkw32');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gattiwillal@army.mil', '8532920308', 'YhIOPzGjE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vtreasadenam@digg.com', '2017957329', 'PCmB4VTBZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zedwardsonan@disqus.com', '2388586593', 'fC8p2wqO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pthomassinao@flavors.me', '1578828056', 'ZUK3JXs6k');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddonativoap@ifeng.com', '7217953859', 'xhIaRo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rtongueaq@salon.com', '3952669736', 'zY6K54iAmI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bluetchfordar@mashable.com', '9799249276', 'erd5R9sOLU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oelbyas@nature.com', '1454371352', 'N3L7U0R5wjGZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zpartingtonat@biglobe.ne.jp', '6999596354', 'BZabMnSA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('epaoloneau@nbcnews.com', '9986767802', 'oV4cJW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgregoreav@addtoany.com', '2848760704', 'lsC6L1REv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbeddoaw@diigo.com', '1352548383', 'JM4sXpH1sts6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kemenyax@nbcnews.com', '2712183883', 'n1FwxgpFA4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbrunskillay@ucoz.com', '4697628635', 'PUce5oa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srickeardaz@ebay.com', '8776732340', 'sTo3sTMK53SR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drosseyb0@umich.edu', '5192183471', 'z6UsAXMgocr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbarenskieb1@amazon.co.jp', '2728852131', 'akfFEma1ZWM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vwellbankb2@addthis.com', '6269838738', 'K80NYlvT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vproseb3@nih.gov', '6152938905', 'KdMEM2P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nkyntonb4@samsung.com', '7418066154', 'euERgP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eshreveb5@abc.net.au', '7797894826', 'HVqkm47KUjB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mjanotab6@guardian.co.uk', '3316621538', 'Y4Voix');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ereaveyb7@reference.com', '5634608089', 'V1Pt51oswznA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdarbonb8@cnbc.com', '8622964626', 'inR81QXB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmcmakinb9@scribd.com', '7935518984', 'jboRFMfL1LP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbernetteba@cnn.com', '5238395539', 'NlEBkmI6pZY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eewolsbb@netvibes.com', '7952995296', 'ZmDVixq9gp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vquesnebc@bbb.org', '1675557260', 'w9YfnSBKQuUP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amccrohonbd@ucoz.com', '1254714673', 'Su1v05jDD6H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfarryanbe@vistaprint.com', '8515942900', 'lrhdiqtUJJW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vschubbertbf@theglobeandmail.com', '2017669222', 'qrYxUsZCoH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('savrahamybg@tmall.com', '7336104668', 'evxg1ChEKCq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scrockenbh@ted.com', '3095785823', 'IZ5DHrQTsKu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drobertsenbi@telegraph.co.uk', '2015143347', 'fP3mVmmJX2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tsturgisbj@pagesperso-orange.fr', '1465273555', 'VSea0bfs28');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbirkbk@hubpages.com', '4195329394', 'Vc86IMIkqvw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcapewellbl@a8.net', '1758493491', 'SZmogSlvbb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbradybm@tripadvisor.com', '8507821633', 'tSFNDm3s');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fsalsburybn@blogtalkradio.com', '2562138059', '8eZyiBRBXVN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agravenerbo@blinklist.com', '8929698579', 'Oag8pMM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('thaywoodbp@cargocollective.com', '2212167171', 'mq5nSQFEmc61');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dnormandalebq@house.gov', '3082014277', 'yRFXs0DzkO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfairnbr@gravatar.com', '2541588873', 'FCGOgZL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lscoggansbs@netscape.com', '9817914361', '4eDcJ3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbertrambt@ovh.net', '2236358029', '1eTxRVFh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aswitlandbu@house.gov', '8719824132', 'yjvO2R');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jroseburghbv@issuu.com', '2304438307', 'LMRCvDCI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfranekbw@apple.com', '8962979934', 'AYXqVUc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlamploughbx@go.com', '2359280081', 'cOkQe4JjS9A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ladiscotby@wordpress.org', '5619154591', '4Hf55ytK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpalffybz@unicef.org', '4574347470', 'fDplGSH8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vlevingsc0@alibaba.com', '3057436934', 'dJ3StzE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehakerc1@issuu.com', '8591784036', 'gnmdoKdtmt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbraistedc2@illinois.edu', '4558078756', '8aC1zF9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbarizeretc3@so-net.ne.jp', '4819046181', 'QGNYUc9jG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkanec4@networkadvertising.org', '2303062729', 'Rdm5TejUwEd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpautardc5@nhs.uk', '1825781335', 'Fhz02hxG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sskamellc6@sun.com', '5323475047', 'jCsxZuv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmoyserc7@mediafire.com', '9759158016', '18cD7ASGH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfeanderc8@go.com', '1407999282', 'ewWQz7fxJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mturbittc9@joomla.org', '2004789015', 'zIeJfpduK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jprickettca@tinypic.com', '3708203600', '01QLbo5KZFjx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsalescb@cbslocal.com', '5604186582', 'WnTBDZA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jsalewaycc@jimdo.com', '9935906491', '5ZS3N9Rrch');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yproutcd@i2i.jp', '2738357373', 'gWhQwWZo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kandrieuxce@g.co', '7505629746', 'HmNBwlsuD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ksimonincf@tumblr.com', '9388357625', 'NCJ5wrV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('boatencg@cnet.com', '6994652202', 'vkpzud');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rhuckech@clickbank.net', '4943351813', 'e7oa1gC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlindleyci@hhs.gov', '7314353798', '5TibIOzZxt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmccarthycj@furl.net', '2069472728', 'iWhPZAWJA5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('morfordck@arizona.edu', '7483712537', 'oS0FfALx2H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gchungcl@meetup.com', '1729280449', 'b3npUQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aprielcm@cbsnews.com', '5559510984', 'WQd7tWHxI6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vpyrahcn@studiopress.com', '5261604465', 'ab9y5Xgm0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aridderco@comcast.net', '7608712511', 'mW0P6heQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfrankcombcp@hatena.ne.jp', '2152498041', 'm4HiC3RDm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adefrainecq@moonfruit.com', '3008707096', '2xbwXa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lnowellcr@ox.ac.uk', '5224010956', 'kjcpP2WoHA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kcrootcs@webmd.com', '9237273399', 'hKRssLWhg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eoglassanect@utexas.edu', '6764746023', '0VKyFtMt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qastlettcu@rediff.com', '3029194225', 'Ou1W4oxedteY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('areddingcv@eepurl.com', '4639612498', 'myFxDa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('etoohercw@smh.com.au', '8422929881', 'wMnRJH9S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdevenishcx@instagram.com', '7003597866', 'QPjgqh3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mburkecy@japanpost.jp', '8153104710', 'WXCWt1n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mclementetcz@plala.or.jp', '9255460329', 'dtzgwmtTJBYE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmcgauhyd0@mysql.com', '1754337107', 'D0rYXb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ynattrissd1@oracle.com', '3292449068', '6IdILspew4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nluned2@discovery.com', '8656319299', 'znHey2Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('skordovanid3@godaddy.com', '1282288105', 'UGaaSv1rGiz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mabramovicid4@addtoany.com', '9995276857', 'RrYIr8Kn0wjc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwoodberryd5@oakley.com', '1425391287', 'g5lIUrbBMPc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('plachezed6@purevolume.com', '5728568401', 'beowI1P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wloidld7@jimdo.com', '6164943123', 'YAYZuGHif');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hcarswelld8@mac.com', '5581660719', '2HURzS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmasserd9@gnu.org', '4831203049', 'WU7KgzN28Bs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpaolinellida@ftc.gov', '7566929589', 'nzxefCnws');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zadlamdb@wikipedia.org', '9945057718', 'ecxF3Yv8Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awestoverdc@twitter.com', '7974614495', 'npv47N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jvoakdd@cpanel.net', '4302617892', 't2ZzfUOpjFgG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wtingeyde@amazon.co.uk', '7816071035', 'vcnMWsiur9Wt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpaunsforddf@nydailynews.com', '3518303769', '0sYVi7Drdw1s');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hzylbermanndg@weebly.com', '1015559784', '1D3Xgz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wchasendh@pbs.org', '7189190782', 'MCx9rgXi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cprawledi@irs.gov', '4254119100', 'D6PHGIW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sflobertdj@de.vu', '2586006121', 'qbG7SJNTuoKr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eodroughtdk@nih.gov', '9799157986', 'anKgUD2Bg9U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cnorledgedl@cnn.com', '8459157952', 'ieVBityj7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cflorencedm@psu.edu', '4507990567', 'xr9tYWe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jserotskydn@opera.com', '8659952283', 'JpNc3jVIB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cabramowitzdo@bravesites.com', '1429761398', 'vrN28YkJm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iblodgetdp@ehow.com', '6815205635', 'a9pH2oOEITT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nsperlingdq@linkedin.com', '1929409638', 'ORtYH8Elo4IJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cleyesdr@usatoday.com', '4078287802', '8tuog9ZyW4Jq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdugallds@timesonline.co.uk', '1151519289', 'WVruvu1l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mprawledt@eepurl.com', '8539071608', 'LCdza079hRh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdurbanndu@unblog.fr', '2749234858', 'NJUKt8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btarbattdv@ft.com', '1619404500', 'E91XzhrtY7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ppickwelldw@angelfire.com', '3849229100', 'ILXNtD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ethirtledx@reference.com', '9125601248', 'fojnFgQKFI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btrattlesdy@google.fr', '6431974636', 'dBgeld');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hpallesendz@smugmug.com', '9709390579', 'PlGrqkDp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tdarye0@businesswire.com', '1311538810', '9wRGoQonRUi8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmartine1@phpbb.com', '2775282588', 'FRT2KX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msterricke2@apache.org', '6876290251', 'vziY115Ri');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sorrisse3@cyberchimps.com', '1847638923', 'kXBSE5Wf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asarjeante4@privacy.gov.au', '1238600510', 'g1GzGNQK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vsherrarde5@ameblo.jp', '7733297363', 'oDg6jZY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wbenoite6@weebly.com', '1894554684', 'oSlN4O0BfbB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hgerrame7@bandcamp.com', '3341729679', '2jq65fUtH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bjulianoe8@i2i.jp', '6699817061', 'S6HSQVI4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgohne9@disqus.com', '6596495667', 'CTrUV3Ps3qR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbradshawea@ning.com', '3908410586', 'jB0v1N0i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtwallineb@multiply.com', '7182748205', '7ITjZFbn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dscardifieldec@etsy.com', '8166671664', 'EVDOpF2hSZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('balebrookeed@1und1.de', '5775949369', 's1sZNDC0ko');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbakewellee@simplemachines.org', '7498582012', 'Fnl41f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccookseyef@themeforest.net', '7449692846', 'SzIh51fz79bj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pcorneweg@diigo.com', '3421952304', 'DodYi61');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlindsayeh@homestead.com', '6214845750', '8dDdQlb1t8Ko');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcasettaei@edublogs.org', '8193736810', '4FQZq6B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbeateyej@sphinn.com', '2784933935', 'DA0zkfbPl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eparvinek@icio.us', '2246838381', 'KTGiUx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kparmbyel@printfriendly.com', '9752974708', 'HaMHOp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aotimonyem@redcross.org', '1277468610', 'hqQJYr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mloften@loc.gov', '8165950697', 'HoSIIj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('psalthouseeo@sciencedirect.com', '9432229454', 'ckBBCgKNhP1y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsatterleeep@usnews.com', '8605019838', '1eOOCBs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccatletteeq@rambler.ru', '3385615941', 'cel2nlwQMA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nsouther@paypal.com', '1043520201', '69J6wDvafM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wgritsunoves@tumblr.com', '6438172213', 'TJqS8zcIFKX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhanselet@tuttocitta.it', '7043351552', '7ninKG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('enetherclifteu@google.co.jp', '7944933192', '8UAoudHkqXE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpillerev@t.co', '4396215963', 'BXSaxF7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ntoweyew@unblog.fr', '9107107780', '1P1JkPQkol');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dkeightleyex@sogou.com', '5532161531', 'RZkUmL9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ngowansoney@icq.com', '3574932349', 'EWI5IO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vgarbettez@networkadvertising.org', '8406354418', '5j853g4aDv1N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sjochananyf0@istockphoto.com', '2157407112', '5eOiMLS7d3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vslatterf1@spiegel.de', '8037781214', 'gRvcB9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hvestyf2@zimbio.com', '7362052517', 'VjdoPqPJojq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddownagef3@hexun.com', '8121032964', '5AgK7ln');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mjohnesf4@com.com', '1484975615', 'dCMP5qYKOEUL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hasplenf5@elpais.com', '1644961176', 'KkBVl4D4C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gtreef6@admin.ch', '4591053702', '9xuzbIlJ0T4A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lnewgroshf7@discuz.net', '5829604530', 'XzIEaEvt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('krudingerf8@alexa.com', '6381982176', 'K9nDwYPeHDLv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rwardinglyf9@ehow.com', '1686494454', 'lfijPe2SDR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kfevierfa@adobe.com', '3982073963', 'n4gu447wNa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdoumerquefb@csmonitor.com', '7363238685', 'PUuUb2et4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aclynmanfc@gnu.org', '5181340319', '2yIRsJqdJ1NU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbernlifd@jugem.jp', '5744484986', '11YuoZI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcamilife@bing.com', '5639281791', '33NXe2PS18');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('grampleeff@archive.org', '5796538607', '5o5PBuzkd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhinchonfg@xinhuanet.com', '5247889759', 'k74DXkg8mB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kewbanksfh@hatena.ne.jp', '8628944499', 'ZWqyARBIC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eweinsfi@ocn.ne.jp', '1302396781', 'hPGEbEgVuqw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lwoolmingtonfj@techcrunch.com', '2024405851', 'xqvg8gwOcN0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cvanyutinfk@sourceforge.net', '3454072752', 'bi0tMCEu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfleemanfl@ucsd.edu', '9456617559', 'ToQQEmOAT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dknoblefm@tripadvisor.com', '3722128645', '7IUlGUEkO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ncecerefn@gmpg.org', '9252730270', 'SXQf7z1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eiredalefo@cafepress.com', '6997532680', '8pnRmv8N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scuffinfp@prweb.com', '6882004208', 'BeYp2IzY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsimakovfq@surveymonkey.com', '8085658138', 'oaQOqo07PGX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atwinningfr@craigslist.org', '8206563764', 't9Rw3LflERNw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcrebottfs@alexa.com', '6853278134', 'Jtfi1KKX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lantoschft@google.de', '2244423079', 'RmQILp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ggettenfu@businessweek.com', '8772007707', 'SevrSHn9QCF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('avockingsfv@free.fr', '4284996555', 'wZNdrk5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ftopfw@craigslist.org', '9617831913', 'PgRvlqNH7ige');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbintonfx@goodreads.com', '4202789752', 'dOQefi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cduddenfy@cbslocal.com', '1174225506', 'DDcZmC1o2hu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dabrahamsfz@upenn.edu', '5618994202', 'aW295pCgoUET');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgabbatissg0@usgs.gov', '6731307530', '1UoI4jnn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('omackernessg1@sourceforge.net', '8751957862', 'ATlDUxjNh0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('whambrickg2@slideshare.net', '2272493157', 'SJOHmqYzG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rplayfairg3@a8.net', '1317468332', 'ngPGTw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hkobpag4@epa.gov', '6288338897', 'mVfHVw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfullerg5@pbs.org', '9213808627', 'FwFirO5g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfeakg6@blogspot.com', '9712683718', 'DTwtWpkx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmacduffg7@psu.edu', '8241295448', 'ZiODtNv9yS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('olithcowg8@php.net', '6581254600', 'awQhHzn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jsateg9@jigsy.com', '4479324361', 'Vntwt7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aizkovitchga@xing.com', '9866630994', 'Q5w0OfM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rboylandgb@domainmarket.com', '3948181343', 'udaebEl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bstickinsgc@webnode.com', '8359605901', 'uChdKA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbusselgd@guardian.co.uk', '2252147878', 'BUCMlmJrOCjv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gofihilyge@sitemeter.com', '2484562516', 'XGtqnStR1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhaileygf@webnode.com', '5584304264', 'hWu0L1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjacquestgg@t-online.de', '8101451253', 'IFdBPjHhcAe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tenokssongh@ucoz.com', '8941143730', 'uGoBJZvKt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lwilldergi@ow.ly', '7943672747', '3jcQp7lpCYg2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aisakowiczgj@usnews.com', '6964342677', 'BDAl4n8IRKD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmccloshgk@arizona.edu', '1873092677', '34xWkNdHP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gnorthamgl@independent.co.uk', '5057736834', 'sjTzG8CdV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swehnerrgm@mtv.com', '2968351390', 'MCxIzaY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emarquissgn@elpais.com', '3729624256', '5VluFPx2bPi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adillinghamgo@friendfeed.com', '9539013481', '8MwBHNbKgex');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('crowbottomgp@salon.com', '6963929175', 'wzOV4yN5Vho');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awaslingq@newsvine.com', '4199228993', 'DFQuQy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhankinsgr@jiathis.com', '9396212068', '8TM2EhgV7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gverillogs@phpbb.com', '9539961172', 'IEdeqf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tciepluchgt@dell.com', '8132625530', 'SM7ZWjU76');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahenzegu@friendfeed.com', '6188967332', 'XkVQz1Ye');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('charbardgv@furl.net', '6165363427', 'KqAOPT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ischuttegw@google.ru', '9028566325', 'Xu4h6Mx90A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cnorledgegx@netlog.com', '7132009797', 'a3p6mXe8ru');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eyatmangy@123-reg.co.uk', '7614347043', 'AVw9WMX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alundbeckgz@issuu.com', '1409499395', 'Gwlw0iTngwd7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ledglerh0@multiply.com', '2984983493', 'CGHkV5iW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obrugmanh1@comcast.net', '3984655254', 'j3ITuc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jperfordh2@unicef.org', '1959739073', 'uD2v0T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('crosoneh3@scribd.com', '2142054538', 'antxxzctf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amartyh4@wsj.com', '5868882298', 'C3rTiDqG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sfouracreh5@ebay.com', '4113482683', 'PlpVWXYFnKgr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmcduffh6@example.com', '7554385831', 'D6fGKaU0KZA9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlattimoreh7@123-reg.co.uk', '5153271663', 'A4CXq2B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ipetkovh8@sogou.com', '5139345512', 'It59lnDspj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kperkinh9@dyndns.org', '5237957097', 'jTd4cQF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cseaversha@digg.com', '1038405522', 'L7b8AtZQh3b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('clucushb@free.fr', '2083757799', 'UeuKY5kE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hproswellhc@stumbleupon.com', '4151064998', 'm2Ywcsepryq4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlappinehd@google.com.br', '5897261772', '1JGHVR5u');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('imcgallhe@ted.com', '6203955025', 'tDWGGgv2Mu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgoldishf@slideshare.net', '3069111240', 'K28NVJz0c0oC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scuttlerhg@google.co.uk', '5002660176', '2Q2eCLmA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wrennickhh@reddit.com', '5993492465', 'yCRaT9iJepb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mboowhi@apache.org', '5545391026', '5vJ8q9eKe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('npenritthj@weibo.com', '4186362701', 'GFhH6SuIzOy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gvonhelmholtzhk@symantec.com', '9326028113', 'TiO4q8Yyp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('stimbridgehl@admin.ch', '1956208913', 'IJ1IFpVmW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddenisovichhm@sun.com', '9394977512', '21qZRknYI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lthornberhn@squidoo.com', '1168967595', 'FPxJJI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdriuzziho@tumblr.com', '9476439184', 'kufipCTdO53');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcrocketthp@soundcloud.com', '7738615108', 'm81so814va');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kfairbeardhq@tripod.com', '7488962524', 'D4B1VTgzlP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtolcharhr@reddit.com', '7612637692', '24iDqWiw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fgareisrhs@patch.com', '4457905470', 'erv3oO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sreckeht@digg.com', '7384311729', '1tYQjOL7Tsfo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mosmondhu@utexas.edu', '3035851797', 'pQjfzboEPQE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nluthwoodhv@apache.org', '2887316794', 'znjGePjoTK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wmagnehw@engadget.com', '3456972317', 'kOsQoZG16l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('owibrowhx@newsvine.com', '9079828328', 'WimtzwhYucz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsanjahy@multiply.com', '4027995131', 'ivAc3f7XxXBH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jwhymanhz@usatoday.com', '7972135942', 'IQjW0SlVQP0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdinningi0@vk.com', '3298083744', 'roILn3NyJuc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccoughlani1@bravesites.com', '2486320477', 'i1zTMzc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwalcari2@sun.com', '3598368645', 'QK8pCvSjMC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpettengelli3@webs.com', '2708371580', 'qYJUZ798');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awillbrahami4@github.com', '2018219213', '4k7k2e');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('skettleyi5@example.com', '1521763379', 'oq9ai8wP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('flaybourni6@sfgate.com', '8201619546', 'l6SmT8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgoddingi7@chicagotribune.com', '7467942217', 'jCMX9I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdecreuzei8@admin.ch', '8811640679', 'UyQXuN2KBBZZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbilli9@google.cn', '3975904414', 'aAc8KuEKmUV2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpavisia@army.mil', '9976103108', 'V5Eq5I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlurrimanib@bigcartel.com', '7167077242', 'jZFrQgbQKiUr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('notsonic@blog.com', '2496758603', 'wUqDRtNS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('whavocid@baidu.com', '8241577031', '5uSylP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmeachanie@sourceforge.net', '3188464589', 'se5mTPApcYs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdoerrlingif@europa.eu', '2355155750', 'muCurwPS5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gfelliniig@hubpages.com', '5244024731', '0cs1xB2F');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbloxsomeih@vinaora.com', '5209846697', 'w7frXs5R6Gkl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgatwardii@europa.eu', '2924933718', 'Q05e6NCSc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('handriolettiij@flavors.me', '1205170813', 'I6BQz7wBC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebruggerik@dailymotion.com', '4718169761', 'VbTpCOph');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cporsonil@storify.com', '7126990512', 'VjCjG140zdtV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lborgnetim@istockphoto.com', '4067444940', 'HBsDN3L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcushellyin@blogtalkradio.com', '1435398629', '0umqKWWg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbrandleio@narod.ru', '1356798578', 'YkgqNgG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eandreuip@nasa.gov', '5742859858', 'J3TSBar4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wknottiq@parallels.com', '1864970492', 'ljdHZJOGn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmulvanyir@about.com', '8342455139', 'iK2FhCSGxcr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aromeufis@omniture.com', '8087668378', 'DkH2TvtzD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbogaertit@hostgator.com', '2197137082', 'nWCgZw2S8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhowlingsiu@google.co.uk', '1408672261', 'OFt2aErM0mL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmcclearyiv@cafepress.com', '8922914181', 'xJZfVz8PPaL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ochurlyiw@yale.edu', '1981759188', 'eyqVh4rn6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scopynix@phoca.cz', '4702468606', 'uqqje0EXEcD5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfaltiniy@goodreads.com', '4132150305', 'YiCxoD1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bchurchyardiz@pen.io', '6061146649', 'zBiLQCrqL02z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afendtj0@quantcast.com', '7784563090', 'PmCPM6T9m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scuncarrj1@mysql.com', '1935247714', 'CnR47fAl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vlokierj2@intel.com', '6128920897', 'hTWAfG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfrareyj3@biblegateway.com', '6401950454', 'GtJQqyw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eactonj4@engadget.com', '8012438835', 'lhblZs0b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcasselsj5@pagesperso-orange.fr', '6997885954', 'QSk9lCjYs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdirandj6@people.com.cn', '5227738434', 'WzcYPMa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mruggierj7@wisc.edu', '9237748140', 'RPBE5YDnDK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rnazarethj8@reference.com', '4445648374', 'ccMv1p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egiurioj9@google.it', '7131080736', 'gNNzLJdNig');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('xwoodlandsja@washington.edu', '2524398423', 'uXluEwEDE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gjeavonsjb@dailymail.co.uk', '3667807887', 'LRe9i0n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjanuarystjc@who.int', '1624480656', 'Y2N5yak9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('anelsenjd@blogtalkradio.com', '9456640768', '3DzG3T49032');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsemensje@un.org', '1461223622', 'h7qRC4Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('djinkinsjf@irs.gov', '2812501323', 'wpgGvFGduid');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kshewardjg@seattletimes.com', '4975854810', 'dYUbflZgK4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndionisijh@51.la', '3839653502', 'fHcZjKe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drattrieji@globo.com', '8097095867', 'nSXPD7HDC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vterlindenjj@freewebs.com', '7143213944', 'arcTkb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmahonyjk@lycos.com', '2439134708', 'jkV8WWbBE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hlowmassjl@cloudflare.com', '9632282015', '9uO6vDst');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sparramjm@google.ru', '3052110006', 'nL9yOYgJj4Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fettelsjn@vinaora.com', '3192608855', 'xip7vdHoH872');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfaldoejo@flickr.com', '7237505405', '2FmEos8e');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('geglinjp@wsj.com', '6998673387', 'vK4SCvMEJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smacalpinejq@angelfire.com', '4143583231', 'JWoCx9C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cnorsisterjr@independent.co.uk', '9374733372', 'zwXrT47PmJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcrockerjs@about.com', '4337903008', 'qe4m7J6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sthurgoodjt@craigslist.org', '6454826604', 'p0z0wsiOmov');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kblakistonju@yale.edu', '5928034911', 'CbJZBfiC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esurgenjv@mail.ru', '9464124369', 'q1jTbK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhryskiewiczjw@illinois.edu', '8445910356', 'IJQk77');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gduchennejx@about.com', '1347320926', 'Lqglb2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gpeekevoutjy@trellian.com', '3908625722', 'wJiCAC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pomoylanejz@scientificamerican.com', '9284259606', 'TbWRJTkTgwV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ralldredk0@studiopress.com', '4568281395', 'oFSvmy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbrittenk1@ucoz.ru', '6598577659', 'TUVFlpT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpeattiek2@google.com', '6321967257', 'Z0Q8v58FRhE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jheildsk3@intel.com', '2398490562', 'A5UxWc3RX3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfancetk4@angelfire.com', '9582907915', 'Bf8pvWhxW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfalshawk5@adobe.com', '5498213174', 'epkutlh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pvangeffenk6@slate.com', '9717719967', 'bFTwDxMd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agladdenk7@ezinearticles.com', '1349173280', '8W8tY0S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmcgaugheyk8@wordpress.com', '2343621276', 'Q9pugMQmSH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbilbeek9@unesco.org', '4779867066', 'nTGNGopC8i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgrovehamka@umn.edu', '9455150295', 'pC67W1s1UQ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('prooksbykb@oaic.gov.au', '1263116150', '0LD4moAtVy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btolchardekc@slate.com', '8078484351', 'sjI89OUjCWQF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcoglekd@delicious.com', '1063179349', 'PDRn6LnFw9mD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wdanake@google.nl', '3961536083', 'Rlox5mYR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gkennealykf@cnbc.com', '9558234639', 'h5CDRM2x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfendkg@ifeng.com', '1229463361', 'dJ9Wdpga3zz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('crossonikh@fc2.com', '2468223593', 'w3CR6il');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rdibenki@sciencedaily.com', '7259643002', 'Im1PCg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('khartegankj@g.co', '3123576262', 'Cu69ESHbQxJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahuffadinekk@usda.gov', '3584967144', 'ZnNwkP7xSrU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bauldkl@simplemachines.org', '3021245239', 'tqwlnU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdraperkm@hhs.gov', '7846211531', 'NeOiCGO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lkitterkn@omniture.com', '8282012065', 'JWO5HAqgKQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nprierko@163.com', '7841466195', '2XXyvQ4YBT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rspaldinkp@lycos.com', '6356291134', '65QveuguyW3d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmintrimkq@techcrunch.com', '5534586627', 'egm31O1eMxBE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asandwichkr@gnu.org', '1267319425', 'ZzBHwGyzcjK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klearyks@51.la', '6343198925', '0CJMYP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddennykt@ted.com', '6054814255', '8SJvhmJSk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfrearku@hc360.com', '7606774791', 'x5tBLoh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdunnetkv@discovery.com', '7133958860', 'lJ8jCx3hz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kswafieldkw@blogtalkradio.com', '3307004878', '2M09Pl3p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbettskx@pen.io', '2268476184', 'ExNllY9mm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aosbandky@uiuc.edu', '8986144632', 'XCjEJLVa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pameykz@ed.gov', '6326274769', 'CRljCo7k');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('beariel0@home.pl', '4968316963', 'KAp4ucYGUk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdaringtonl1@spiegel.de', '4373756253', 'AtGbZD7z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rnoorel2@state.tx.us', '4496215243', 'ohdRhtT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lszymanekl3@shutterfly.com', '2821558858', 'KCfydYKD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbixleyl4@amazon.de', '5683538362', 'yfXAao0E5N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ksilbersakl5@phoca.cz', '3996841721', '1Hh27Vwt0jz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlonghornel6@dion.ne.jp', '6849019156', 'XgT1CZpvrY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gstrattenl7@theglobeandmail.com', '5385203309', '4F9AchNs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rkittoel8@shop-pro.jp', '2295215545', 'ZCZ6Y4dYd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kboikl9@wp.com', '8322868734', 'Onxjk5rx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgaukrogerla@hubpages.com', '4703255644', 'WqjVfxP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsheelb@un.org', '5032877989', 'gW89YCSM4j6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmoehlerlc@icq.com', '4793763978', 'miyCUYB00dv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gvoiseyld@microsoft.com', '6696366334', 'HXJ480c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ntackleyle@google.ca', '3193314435', 'afdVaeo7uIa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('brytonlf@latimes.com', '3466775700', 'htExgaL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ajimmeslg@mayoclinic.com', '3071372325', 'C1xkkFH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wmuckloelh@berkeley.edu', '5806244038', 'c9zGs1wl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mleclaireli@fda.gov', '4705226882', 'cN6F0UNBS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdunrigelj@businessinsider.com', '8499138605', 'gAwo1Pi8j');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vkennionlk@shinystat.com', '6096014068', '6qjOBMlKMBEm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndackombell@scribd.com', '9295269964', 'rAyN6XY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlavelllm@gmpg.org', '9107277312', 'e1EkCy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mthickingln@fda.gov', '2275917815', 'JyuG90ZZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cromanlo@nps.gov', '2535953426', '6GhzTxyDWes');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgitthouselp@dailymail.co.uk', '9985252461', 'bflNAk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jamerighilq@cdbaby.com', '3854150330', 'rU7hIxVlpvt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('arichardsonlr@umich.edu', '4251044591', 'kxZgroYp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ffilppettils@themeforest.net', '9867334298', '40WMl2hPz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbrixeylt@wikimedia.org', '4462623450', '59ad1m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('djosefoviclu@home.pl', '8848043029', '4zqdsh9j');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hjaanlv@biglobe.ne.jp', '2954923866', 'sXzmcP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mravillaslw@tripadvisor.com', '1502554842', 'T5to20padTJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('testevezlx@tmall.com', '2515911156', 'woOYv0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbealtonly@hud.gov', '3425064222', 'K4WTnGQk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwoodrofflz@ebay.com', '1572824837', 'zIdHF2aTbL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tstiffkinsm0@newyorker.com', '5282416585', 'xcmbhqCC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhartzenbergm1@cornell.edu', '3287913070', 'vUCTju65E38r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpryddenm2@smh.com.au', '8072202083', 'dz9RrVr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgoarem3@umich.edu', '8659781227', 'OlUSBh7G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('troxbeem4@usnews.com', '1082545930', 'qQlpKd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jsunleym5@cisco.com', '5829473053', '6QaY8om');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iwillattm6@etsy.com', '9528822510', 'T3LPzeOgbYZ7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbalmem7@vkontakte.ru', '1083561185', 'vzVrtMd4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmcenenym8@uiuc.edu', '7036362377', 'KPM9vmyla');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lleggm9@usda.gov', '2569616060', 'cEtTFq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpendrickma@washington.edu', '8427339931', 'oCPjAEaftb3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shardermb@google.pl', '1813083981', '0i0RlDW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wriddlemc@weather.com', '2458743282', '1FOc93T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bwilsteadmd@guardian.co.uk', '6014192471', 'UmpmdCY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yyeseninme@psu.edu', '8413053313', 'E3BHCmMQUD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfeildmf@biblegateway.com', '1444961003', 'GdrvNAah');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sseakmg@psu.edu', '5712360206', 'DMdL9qt6TD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lnajeramh@mac.com', '3497321930', 'd9ojwk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('frobinettemi@twitter.com', '1591253803', 'J1CVtuXf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpiggfordmj@oaic.gov.au', '7487138837', 'a5E2E8YcXI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nchippinmk@google.ru', '2422221122', 'Csr3XQOiwTQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bstebbingsml@comcast.net', '5039768979', 'AZV1ia8yEVcR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jstilingmm@instagram.com', '4104197070', 'wGcQ2m38Cq9l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('avasenkovmn@github.io', '9905806128', 'jhWHywLa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('csweetmo@yahoo.co.jp', '9199122747', 'h3e8GKB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cduinbletonmp@techcrunch.com', '3767001514', 'V6b7hAKIO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ohallutmq@symantec.com', '4619733167', 'aVtB3fgoF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pheinertmr@liveinternet.ru', '2724604652', 'DGtYxep');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmulqueenms@hibu.com', '7264009993', '23Kh6Df');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ashillingmt@acquirethisname.com', '6571561054', 'YKeSutC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfendtmu@squidoo.com', '5545759980', '1IM1UA2saw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hgranemv@mlb.com', '8787819679', 'jt8tC5Nh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hleallemw@census.gov', '1192239133', 'sR1YClJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nshewanmx@hhs.gov', '6417568211', 'ywvar51YQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtarbardmy@dailymotion.com', '4412466290', 'NRgl7ZCG9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tganingmz@nhs.uk', '4356111091', 'blDLrYvykP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fcrusn0@bizjournals.com', '8743299406', 'otztyuvUA3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgilkisonn1@mozilla.org', '1842797148', 'BceJgI9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pguerrazzin2@independent.co.uk', '8133411949', 'uxLEUO0EO5m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swheatmann3@reference.com', '1351062849', 'HQuczcC9yY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcheatern4@nifty.com', '4498069328', 'M0D9oSXP0D5S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lsunshinen5@mac.com', '4881783872', '7Ucz5NOyLbi5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbentamen6@tamu.edu', '2452199085', 'TpBoTsUacwT7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpothecaryn7@vk.com', '3479715490', '13RCnhP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmounceyn8@youku.com', '3063154596', 'I1zm69');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bverrallsn9@arstechnica.com', '2627732697', '5GKN6wq1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amacinnesna@goo.gl', '6263197017', 'FPjUYtcp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('baltoftsnb@ezinearticles.com', '2714824360', 'HwIEnlF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pbraywoodnc@yolasite.com', '8923236980', 'k1R50SRs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kchungnd@yelp.com', '5616548760', 'LB4QKOVKy8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbeddinghamne@trellian.com', '8658602233', 'uGjwh7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cchidgeynf@ft.com', '1004518146', 'HIon00');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfardonng@webmd.com', '1391392323', 'BB69Vcec0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jvasqueznh@google.com.br', '6762580756', 'Zuhd20askhpw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('avosseni@mail.ru', '8118014105', 'e27IglcDH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('etarquininj@pbs.org', '6393197336', 'hHHyHA4eVWi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kcleynmannk@youtube.com', '5573612285', 'C7BloROFo9lH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcordingleynl@people.com.cn', '4412410129', 'AGH2jGb3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('plabrouenm@e-recht24.de', '6784594598', 'uFcZpWX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwinsiowieckinn@reference.com', '9725000483', 'osys6SoP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfippeno@chicagotribune.com', '4421302051', '50EPnNEuK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('khartleynp@si.edu', '2302470787', 'U69j5XANxtko');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ecainesnq@illinois.edu', '4422634168', 'Ub8y5bnXkwp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwynrehamenr@nbcnews.com', '6611294932', 'DKykKnbF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmylanns@nytimes.com', '8324988427', 'l0AwemL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agorlingnt@latimes.com', '3146675201', 'IJ6wv5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lugolottinu@cnn.com', '8866819804', 'S7jOIMOnkVX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbrusternv@moonfruit.com', '2198049457', 'Cer7hfPyLw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adogetnw@discovery.com', '3076784435', 'eF1iQJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddykesnx@wisc.edu', '4682413118', 'aqUSaWz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alewsamny@jalbum.net', '2622686903', 'FOmuqD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sonionnz@huffingtonpost.com', '3959155847', 'd5asKtjoKz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dledleyo0@smugmug.com', '7698957761', 'bUbJAzIG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('enorgateo1@gravatar.com', '1279888830', 'ELQsWwZBV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpasslero2@time.com', '9407180071', 'KtpC7g30');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfusseyo3@dailymotion.com', '7134589942', 'VpShDyMXZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acaneroo4@nature.com', '4744091333', 'N0peG9a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ljanso5@earthlink.net', '2698069001', 'ZTBw1i8m9o4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbarwacko6@springer.com', '5363181840', 'xA0CmDnA0DXe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcadamyo7@gizmodo.com', '5392068522', 'AyZ6J0xI7GJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gheildo8@archive.org', '9642755851', 'thnpQOoYzF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('coheyneo9@nba.com', '2607318206', '92doE9cX2z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('areeseoa@baidu.com', '5082378722', 'Vp3Pp8IFb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nstledgerob@diigo.com', '8837097584', '3q88hwnx7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rladenoc@uol.com.br', '7553948292', 'HArmn3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zsegood@apache.org', '9791624431', 'yOhJnSxaFgyg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tdjurisicoe@oakley.com', '1493466128', 'D8O5sVEI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ltrowbridgeof@lulu.com', '9482887696', 'aF0fpfKIgpgn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmcallesterog@ibm.com', '5285893821', '42rcy44CO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ktheureroh@storify.com', '3541129684', 'fLijihf3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hnelleoi@chron.com', '7901837587', 'gv6qOtr6RzdY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbranchoj@google.ca', '6597928260', 'mioqN0VWlg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rklementok@latimes.com', '9639194931', 'XMSchdxVYnBZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgradonol@phpbb.com', '2022305859', 'IvfTDidUewGO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jnesfieldom@washingtonpost.com', '9133439752', '1UGMSeF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fborgon@last.fm', '5107223575', 'Q5qeBr22WP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldudbridgeoo@usa.gov', '6734407519', 'LOy6x6o0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rluttgertop@tamu.edu', '1364566003', 'Ddet0fx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cseeoq@tripod.com', '9688636116', 'hkxaePb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jvidoor@cdbaby.com', '8936211598', 'PObH8dW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlochranos@army.mil', '4905683675', 'UXDmhb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbaserot@nydailynews.com', '2811706216', 'celVK84');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('areichartzou@surveymonkey.com', '9394647651', 'V4Vu3zhui');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcamockeov@a8.net', '8703749828', 'Nnw7GDSKPIfZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acastellanosow@yellowpages.com', '1556552758', 'OBsbtgZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbromheadox@geocities.jp', '5708323740', '2lTFxX7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jespinetoy@hibu.com', '5726573434', 'lGEhrQXGowiv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hwinckworthoz@clickbank.net', '1018507320', 'IuFHFDtkw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cposnettep0@businessweek.com', '2749740005', 'LfNrE1S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbeelp1@hud.gov', '6261417023', 'j6ov4FS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('meringtonp2@yellowbook.com', '1915979837', 'mZ1hSU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmcmurtyp3@e-recht24.de', '4399991017', 'wyG01cTUJg8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgentp4@mapy.cz', '7032018303', 'thQkDRL7zEBY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btollep5@ezinearticles.com', '9675246397', 'Ttu4nvQOn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmcgarrityp6@last.fm', '4236264407', 'BAWsW9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cyouhillp7@csmonitor.com', '4387031233', 'Dy2Gvyxi01');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fitzcovichp8@thetimes.co.uk', '1151849826', '8sowZSN4hy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cthunnercliffp9@themeforest.net', '4239299888', 'hPPwuS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cstangroompa@cdc.gov', '7115440956', 'b1IxSdW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eagasspb@microsoft.com', '4694712060', '3xI6XtLK5B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dellimanpc@gnu.org', '6692785444', 'lFlVb5E1KR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lsleeppd@google.co.jp', '5766439816', 'XjW6yycLD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sstockbridgepe@theguardian.com', '1507647615', '80ZvSRoON0er');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cprovispf@house.gov', '4974850613', '9ZaM0T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hwynettpg@jigsy.com', '2626016187', '5l06tclnPR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmcneaph@tripod.com', '7041498402', 'tinz2QSaWpK4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgaddiepi@economist.com', '5111467022', 'Rr4Df1Prg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apowepj@google.ru', '2646885473', '9lx5kfo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shollylandpk@army.mil', '2493575122', 'xDK8sJnFcdOo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbradforthpl@flickr.com', '5788300962', 'vO4EZCJeHbv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehatfieldpm@surveymonkey.com', '8519391274', 'zMnvxK5KZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nmooneypn@baidu.com', '4796534127', 'Trpfby');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lchaudhrypo@google.com.hk', '7801435963', 'vh1wsffa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgreastypp@mysql.com', '5168229657', 'Gj1mCc1r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jogleasanepq@prweb.com', '6424971291', 'Q8zctlp6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edevoielspr@utexas.edu', '5619844977', 'Z60c7NeGuKoZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('obailesps@jalbum.net', '6537082961', 'ut6s3j7Wzd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dforespt@google.it', '4076544136', 'oQoe7d1CZeC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('estansfieldpu@eepurl.com', '2285608274', 'KILsALq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cboikpv@ebay.co.uk', '1912374924', '8taTEp724c44');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfryerpw@bbb.org', '7488822699', 'Sbbhmr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chansberrypx@arstechnica.com', '3359021427', 'PlnM96B7eC6Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtweedepy@fda.gov', '6112627213', '0ZjmbExqx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pbrattenpz@ftc.gov', '6261413678', 'Ljdio0q6QKmU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dridgewellq0@msu.edu', '3207640293', 'KJd0PvD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sevensq1@unblog.fr', '4398366112', 'gWNzFI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sreckusq2@joomla.org', '6166901492', 'NlNhvOG0lMO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcarreckq3@exblog.jp', '3739134525', 'bDpujgjLB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpridenq4@dedecms.com', '9316087009', 'vxpB8RylW7v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcareq5@seattletimes.com', '7392879567', 'she7tqACPyBu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sguerreq6@berkeley.edu', '9614177009', 'mkkbi9b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rschurichtq7@cdbaby.com', '9541909839', 'agkyGrKsdtw5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bciccarelloq8@youku.com', '4715329330', 'N3mADIi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rporterq9@miitbeian.gov.cn', '2446743927', 'U1qcuGKVz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jheismanqa@csmonitor.com', '6714834195', 'e4cbLN68');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwettonqb@sciencedaily.com', '2497905818', 'GZ0uiQddxOd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shailwoodqc@slideshare.net', '9345453107', 'vT6JYjJp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcunniffeqd@odnoklassniki.ru', '8176425028', 'vPl5zIb2m49');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ptruettqe@blinklist.com', '7343398269', 'a6xGA4A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdmitrievqf@blogger.com', '8449422224', '8UEYFTAYT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsandyqg@miibeian.gov.cn', '8622871144', 'bmyRGwhYN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mellimanqh@geocities.com', '4083509670', 'OlEa2rNwPs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lduhamqi@ucsd.edu', '6756648786', 'V9LJanF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agoffqj@free.fr', '6093199392', 'JkkTGlX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jnisuisqk@nih.gov', '2552664098', 'Duw4HvB8ZEp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zhugonnetql@time.com', '4905277858', 'yx20TeLdD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpashanqm@scribd.com', '6447180839', 'qANgTml');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alegrandqn@jimdo.com', '3351682166', 'neNyEqNyVZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctoveyqo@unc.edu', '1439387567', 'cKk0ePUH3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jchafneyqp@boston.com', '6619194955', 'Ks1jvze5Vdfk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rduberryqq@dailymotion.com', '6819484391', 'bDsqLkgX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbelfeltqr@deliciousdays.com', '5988237173', 'HplhmMjnHK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fchestersqs@google.es', '5804722056', 'Cd6RRDh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hwinkettqt@amazon.co.uk', '6475616128', 'Z9H0O9cV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbernhartqu@lulu.com', '3903689064', 'rNx6Ybip');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pseaqv@amazon.co.uk', '9392470567', 'xCCtKthwBf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lelderedqw@cloudflare.com', '8308065026', 'OunptrxaK1l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kasselqx@europa.eu', '2618817476', 'B9iWiLgLYM0b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcoasterqy@vk.com', '2956151067', 'dOAUe5vg8cZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmussalliqz@ibm.com', '7167734671', 'NjPSJBMdoZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lonowlanr0@hugedomains.com', '3245597133', 'eYksGAW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcheeser1@joomla.org', '1337227123', 'y218hLYb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scowardr2@ucsd.edu', '6353732988', 'WWKEZwkGBL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('krubenr3@yelp.com', '8111222502', 'G2NNtuCQi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmacgallr4@google.com', '8944782923', '9sWKheJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shardir5@simplemachines.org', '6731419653', 'x7wthGdVL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdyter6@linkedin.com', '1021318844', 'BGEEUyQp6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhawksleer7@prlog.org', '7841357585', 'KEsOrL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfaustr8@xing.com', '3592225045', 'ycPMV99Z3rT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpiscullir9@geocities.jp', '5849315765', 'RQCZTn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wmaccollomra@360.cn', '9022105899', 'boyM063n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cisenorrb@merriam-webster.com', '8453556537', 'uO8ynYChQ0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcabellrc@phoca.cz', '8803577668', 'SZ5ZOOUZrAY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awrightemrd@bravesites.com', '5331721339', 'xlMrKOmGnFf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbladonre@craigslist.org', '6795386242', 'prsZAmZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apennuzzirf@merriam-webster.com', '4867297980', '0qVSgXQu81');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emuirdenrg@webnode.com', '4521981210', 'Tp4wvqZMQSme');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jhurryrh@va.gov', '8954584626', 'Q17LFl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smarari@reuters.com', '8892085500', 'MnLuT3OT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hklawirj@acquirethisname.com', '9396950128', '1JcQOpvrb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnaccirk@senate.gov', '7184810187', 'mSsJXst');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lelenrl@vk.com', '2449533608', 'AIfF8I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rduranterm@va.gov', '7344572327', 'tGveK1Cprq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('beliotrn@so-net.ne.jp', '9711892949', 'H6182aFoCwv5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahubertro@bloglovin.com', '1138817795', 'TAX7quyo761');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kghidolirp@exblog.jp', '7606389060', 'sOzD6SiSOzCG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fjeffryesrq@webeden.co.uk', '5509241342', 'ZtCCjlwEI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('botierneyrr@blinklist.com', '5994068187', '95hHKJk6nR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kstiffkins0@salon.com', '8823854119', 'xFiQuasMY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpurchase1@plala.or.jp', '9032571312', 'PZavPDfH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcisland2@people.com.cn', '1999310277', 'HYD7brfhov');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbunhill3@dropbox.com', '8944978438', 'VbMxh6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('weverington4@lulu.com', '5052812502', '9C9XQna5H2f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nfallon5@reference.com', '4121768968', 'AyQbE6Sgyp5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aburness6@goo.gl', '2879868662', '63108em0w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llepiscopi7@boston.com', '5791153402', '5EfZ50OPUdF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vsnowsill8@weather.com', '3663232576', 'DHvbIA2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fchaplyn9@soup.io', '4581217712', 'MZS05E');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jzannutoa@irs.gov', '7155699772', 'dHgKaQEE4sGw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awimburyb@thetimes.co.uk', '1717491711', 'E8u7zahRXugj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdowseyc@time.com', '4663467846', 'o8RBr7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wbarlied@mediafire.com', '1648362633', 'zgswFar8CQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmadgee@over-blog.com', '9059046286', 'b5wMemp8fj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aarnottf@360.cn', '3709442935', 'eRFtIT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('shinceg@nhs.uk', '4966410532', 'kyFOhaqP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vlyndsh@sohu.com', '7101213098', 'yzRuz0hMWg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcarringtoni@php.net', '6583654009', 'ZkgwMhIDQNT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dswindellj@intel.com', '5715277053', '9bRQnc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nmealek@nsw.gov.au', '3399184758', '0L4qhu1Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('icourtoisl@drupal.org', '3677228345', 'ZtcUdxow0s');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sherrievenm@un.org', '4438792637', 'FufuEyaQz9p9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmarzelen@youtu.be', '1555039535', 'Xf306G9DM79');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('esnelmano@t.co', '8573404666', '5NKMTWzg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oroadknightp@stumbleupon.com', '7991486966', 'MT5iXhGsvE8b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbirtonshawq@godaddy.com', '8295655725', 'ERlKrhVu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wmayner@sfgate.com', '1942540219', 'aLkvaHoYQmIu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwebbens@ask.com', '5713353093', 'fv0uvwMmR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebowellt@amazon.co.jp', '6896715452', 'yEzwA9BiimuP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfranzoliniu@cpanel.net', '8445964741', 'pUw01S8u3v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nrosiniv@yolasite.com', '1304656750', 'B6gtwri2O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('earpurw@ucoz.ru', '4437426093', '87t19H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('istovoldx@google.com.hk', '3034376891', 'UmqfGjcxq2d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jthomlinsony@diigo.com', '3162315013', 'vyErl3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agounardz@discuz.net', '2394838969', 'TGC2aDeU1yR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpellett10@posterous.com', '8636870438', 'cgIUqGw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aswinford11@mtv.com', '5172918196', 'aCDpdi16S2rc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ochanner12@linkedin.com', '5762614104', 'hkPAl5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmatias13@paypal.com', '6199554414', 'pPuIQhE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gqueyos14@marriott.com', '8961361499', 'ijlLR6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emallinson15@123-reg.co.uk', '2364880672', 'LA61Kq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcastiblanco16@prweb.com', '6065444873', 'B22Ilrh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mreen17@shareasale.com', '8311680090', 'HKPoQuPdYQM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmckelloch18@domainmarket.com', '9197473038', 'PGhvURk8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hanstiss19@google.cn', '3983223890', 'Ptwf2NBDeK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcranham1a@mozilla.org', '8051045401', 'X89Y6Q9diG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfountaine1b@blog.com', '8084051808', 'zpadgvSa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmorsley1c@hugedomains.com', '7116310119', '4a68AA451G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdalessandro1d@netvibes.com', '3589754829', 'kRtudU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ntiffney1e@amazon.com', '3606464156', 'aTZcVW5klIWK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdackombe1f@tmall.com', '1282505369', 'A9CVvpkTgPCf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fkeenleyside1g@pagesperso-orange.fr', '2157728344', '3nZOJQJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlaurie1h@cmu.edu', '4381500495', 'I0NoBSnXCx9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ktatam1i@theguardian.com', '2179643454', 'hmojhFZUoHlL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acalender1j@vistaprint.com', '8156573773', '3mTbF7xTeM6O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ilarvin1k@ed.gov', '4001593481', 'MtyghOnW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcoxen1l@pagesperso-orange.fr', '3862963593', 'xN3LE4inN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hgoulden1m@google.ru', '8609176003', 'rJkxXPJ7a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nfaircliff1n@admin.ch', '4268706151', 'CduggHI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rvanleijs1o@chronoengine.com', '8168649075', 'U5gwLFZvKX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgluyas1p@opensource.org', '4486428354', 'z3NWU1v8G');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mhocking1q@w3.org', '5659368472', 'fHF5wQpGHxU4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmitchiner1r@ftc.gov', '9594723834', 'qSBfyBXy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmccarrick1s@java.com', '9674663041', '9BU8hd4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kbowmen1t@elegantthemes.com', '2993925568', 'ojzZ8q3u1j7y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cblaszczak1u@weebly.com', '1633141031', '8MYLYS7ToFO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bvinas1v@domainmarket.com', '4083883890', 'WhywsqK0fs4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mchattington1w@samsung.com', '7398286927', 'Yj1niO7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtoyer1x@craigslist.org', '1946602611', 'CWBb31tXV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbever1y@ox.ac.uk', '5269184042', 'KjT4b1U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bsexti1z@hao123.com', '6572837652', 'ObnzJh0qDa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hadamowitz20@deviantart.com', '6835625927', 'ffrZILQ9Qk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fjoska21@mit.edu', '4468689793', 'fyFlikBHJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mstanier22@bizjournals.com', '7749902516', 'RpiS27HW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sdoole23@mediafire.com', '4701055635', 'TRPRmDPtp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdonohoe24@t.co', '1577892306', 'zaa16v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('schoffin25@tumblr.com', '4991953291', 'd0OX3kSea83');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jadamiec26@icq.com', '3345252178', 'QC2maRToC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ngoldup27@hc360.com', '4286649964', '5l4q43FBp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('srowth28@earthlink.net', '4484180700', 'N4l4ttyTotI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmulheron29@whitehouse.gov', '1321078715', 'F39K1s7av2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdaouse2a@timesonline.co.uk', '3497382961', 'XKxOX0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhandman2b@skyrock.com', '2502865260', 'YpxLHkK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tleyden2c@macromedia.com', '4967931802', 'aahofcsQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcrinion2d@eepurl.com', '6938278506', 'yxD7oRp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alawerence2e@elpais.com', '9332834144', 'l1a2iOo9InA6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('feliez2f@smh.com.au', '2019472692', 'xoqJoBQh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbony2g@webnode.com', '8516303925', 'hJfy9V');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('slebourn2h@fotki.com', '8677558891', 'enULI9R2G3QO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iwhitbread2i@abc.net.au', '9604156852', 'sveWablL5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kreaper2j@is.gd', '1158107254', '28CJy7Lr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emerry2k@studiopress.com', '2548241377', 'hD8X6Mp3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bboneham2l@google.co.jp', '3184386584', 'OhFDHT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mshearmer2m@163.com', '9272450451', '0rSHUJUkItX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbrigstock2n@fema.gov', '3846240708', 'em7y3pz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mwilloughway2o@oracle.com', '4781671311', '68rsFQj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsibly2p@tinyurl.com', '2321786557', 'TV2fl9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('xhallahan2q@nytimes.com', '6231600030', '2yH7JR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hpeyntue2r@nature.com', '6435823939', 'C1zY1Oz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sjackways2s@prweb.com', '3246281580', '2Wx6g3n5b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mswigger2t@domainmarket.com', '6978631116', 'GH82hVEev');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlade2u@reverbnation.com', '9148726778', '46huTECJrCT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bczyz2v@shareasale.com', '5535802021', '7rQgbhlb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eciccetti2w@sbwire.com', '2102123170', 'VCZTnX7g1l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwride2x@ucla.edu', '5624321372', 'SP6v3wNFT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vseabrooke2y@wikia.com', '1863369982', 'j6CP29NYGlDD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swhitehair2z@mozilla.com', '5126824721', 'xvKZJUaM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmcgilbon30@livejournal.com', '4782288562', 'ATjLNDIUe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgough31@bloglines.com', '1765755066', '6FNdyN4cO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amcorkil32@edublogs.org', '9585176216', '9dyr146azS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mspellar33@taobao.com', '4375017582', 'VDu0wBw4k');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acoopper34@vinaora.com', '8881517539', 'eNAwps');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgreenless35@i2i.jp', '9714607822', '5vV9AERgh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdottridge36@google.fr', '3573206691', 'tyJWHfN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpharro37@goodreads.com', '8869004748', 'jYorUu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jsaffran38@ning.com', '3373933554', '0TCBFS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcasassa39@baidu.com', '2201784146', 'dq51qqbw4Co');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfrome3a@stumbleupon.com', '2816083675', '6w185Ip');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pyewman3b@a8.net', '3171261974', 'UtHaD1FZG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('grendbaek3c@fema.gov', '3332902062', 'IBPGfm9X4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kfishwick3d@psu.edu', '4738928461', 'qJGb9lUA2bO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ijosum3e@soup.io', '2581759092', 'jA2pBx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tportress3f@yolasite.com', '5647316129', 'VtJTvwgE6s');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zlind3g@dagondesign.com', '9347011641', 'bfWZUJbtm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccharnick3h@cam.ac.uk', '1248396047', 'gNVK4bCS8n0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmcilriach3i@nifty.com', '8036816062', 'mUEZKEOe4FK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccaskey3j@dedecms.com', '5184070701', 'J4opHq37v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('frich3k@bbc.co.uk', '6917132720', 'JTfQuFyP4Gh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhawney3l@deliciousdays.com', '5256778570', 'LUdglp7ixg5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egilman3m@kickstarter.com', '8252396880', 'Mm38hsRR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bskittles3n@admin.ch', '8512974892', '58sDy2wf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhassekl3o@moonfruit.com', '4691511620', 'r4v12gLi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdomoni3p@engadget.com', '4623181434', 'AlPEzabwj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbecaris3q@ftc.gov', '2676961869', 'ooh1Qg8uZO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rolone3r@buzzfeed.com', '9141695854', 'U6B8lB7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgottschalk3s@google.ca', '4267776657', 'Hn5heuo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('plavalle3t@lulu.com', '4485669085', '6nKg3U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgarfoot3u@digg.com', '8884212476', 'p2otjAE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlatchford3v@psu.edu', '6117116746', 'Qbfvf6bUsT2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmcmillan3w@indiegogo.com', '1914171869', '1nvnAdeOZa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbris3x@wisc.edu', '7993506006', 'dYjP0gTRw3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lzorn3y@goodreads.com', '7005055702', 'Bqbcsp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('isibbson3z@gnu.org', '1587162079', 'EAdxwP2Aa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsheaber40@examiner.com', '5006441053', 'dCAF1rgtelcI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fwrey41@youku.com', '8491649331', '4o2Zz2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nstammirs42@godaddy.com', '8074657290', 'SobDwus');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lkintzel43@hubpages.com', '4677731157', 's9EnkEY7Wh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ayerborn44@hostgator.com', '6134013415', 'i9lvuN5dEuA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebrimilcombe45@answers.com', '5806267973', '5ZubM9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('saspinal46@woothemes.com', '3364313124', 'TbikpOpgutZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehatherley47@jiathis.com', '2165187961', 'HPtG2Vo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hca48@cyberchimps.com', '8586088485', 'Xo8aaUhtuy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acurnock49@alibaba.com', '9246282348', 'yUiVjg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbaughan4a@state.tx.us', '8222284215', 'HdggsXb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgammon4b@4shared.com', '1273038725', 'Y7FnFmd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jheadingham4c@rambler.ru', '2055212590', 'wFf23ghLJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgoodison4d@quantcast.com', '4252776471', 'DoKSPyM8D6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfumagalli4e@virginia.edu', '5989190148', 'ONAtqbqRUFBn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhearnaman4f@eventbrite.com', '6252708628', '0gFR7FN4SK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjakubowski4g@ox.ac.uk', '9121301619', '7GvOs32G6BP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hperview4h@ed.gov', '1922954247', 'bKcco2nwWGsI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbrobeck4i@bizjournals.com', '6279345471', 'Uky9rbgz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tprester4j@sohu.com', '9944578419', 'D1vaSWLq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmccambrois4k@cnbc.com', '5097909656', 'vGKnzVnmvvR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hjore4l@google.nl', '4927165061', 'cT0rN2l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdehmel4m@wikispaces.com', '2145311043', 'W2CMu2qxik5H');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldeane4n@jugem.jp', '7246160138', '90OAs1XFGYD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('elongfield4o@macromedia.com', '3526772647', 'jRxIyvlM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ecoppins4p@state.gov', '3661097132', 'JQQ3Upj7r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rjuares4q@usa.gov', '6379752279', 'lkPZVJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jsutter4r@si.edu', '4947553291', 'Cu0RyA41OIAO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('snorthfield4s@goodreads.com', '5264676527', '7uCDn5g06Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rbedham4t@live.com', '8008994598', '5qKwe3ORrEi9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gjaime4u@ocn.ne.jp', '7272993714', '23PKEL3Fy0cQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kfilipov4v@japanpost.jp', '8892111713', 'hwWpt89Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tchaperling4w@ovh.net', '8351477575', 'IcDbsg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlared4x@ucoz.ru', '4437642150', 'pLycMzFWcK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lofairy4y@elegantthemes.com', '7193256276', 'VTT4PbdQVt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbrimner4z@about.com', '9506821322', 'ON0gM1GVF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfreire50@illinois.edu', '1188158990', 'MwE2yR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pyapp51@examiner.com', '3235409029', 'b80KVQzL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgeorgel52@printfriendly.com', '8617785907', 'E7wnOJ4IckZf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abyron53@addtoany.com', '9556660340', 'kAjIEQJJm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpenvarne54@hostgator.com', '2013738663', 'cKOMOLSnp8J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('traith55@ted.com', '6508342556', 'IhCW0q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbastow56@ebay.com', '2347984969', 'IpULsv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kkits57@harvard.edu', '8552605489', 'N6Yqdr5shJW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jlight58@japanpost.jp', '5529173305', 'q7ARjO9j0u');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pfeben59@nationalgeographic.com', '8231399887', 'oSvZCtZOZx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smckinstry5a@bluehost.com', '1706595210', 'J0hY4yUi8Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kfarnfield5b@t-online.de', '8437460661', 'YpoZEQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dseville5c@who.int', '4552876446', 'XWPS35uQHml');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cblenkiron5d@sfgate.com', '9217828320', 'eff78hJFNVgo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cveracruysse5e@reverbnation.com', '9546947931', 'L7A2Hx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ascandred5f@mediafire.com', '1784898853', 'mVxcLi8XN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('medbrooke5g@disqus.com', '2792644624', 'qXLolDjQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbriance5h@pagesperso-orange.fr', '4585570026', 'iOWCpYq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rspencelayh5i@hostgator.com', '6879560015', 'YhqN1wW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('moylett5j@yahoo.co.jp', '8998223669', 'x6BFuk8NzT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mluxton5k@so-net.ne.jp', '9263779351', '2vFxR3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jrainford5l@epa.gov', '7541767185', 'pXOQcd6nB2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpozzi5m@shareasale.com', '7422320183', 'EshWqVjKi5W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcopcote5n@google.nl', '1521507274', 'jH2hm0x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ocometto5o@discuz.net', '1217566289', 'OBiOI04bal9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmccaughen5p@mapy.cz', '2636830536', 'SLt0fz1B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmanson5q@hugedomains.com', '2513433807', '2kHynGpDk0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcartledge5r@geocities.com', '1036896771', 'nsRGQxDgjB20');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cboggers5s@ebay.co.uk', '7883678918', '9ABKG9LT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vleathwood5t@mayoclinic.com', '9305922398', 'vgqpaj6xatJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aropking5u@g.co', '3773288582', 'XXotkWNix');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gjeske5v@reference.com', '1138015283', '5zP4WpH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sashley5w@telegraph.co.uk', '4093904660', '5iuoO7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lferrey5x@1und1.de', '5609182972', 'M8cD9Ns2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdeville5y@cnbc.com', '1274193258', 'GymQrZnrj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbraunton5z@gravatar.com', '8187697025', 'G4FUl1V');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwalewski60@people.com.cn', '1879635046', 'ZNg9JUOy9L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wbabinski61@xing.com', '5097002141', 'NwYFJZYYOvPZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpickles62@mapquest.com', '5006255200', 'W9U0hjPl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rwiszniewski63@sourceforge.net', '9155307132', 'AteYIyP8hi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yrevelle64@geocities.com', '2295938751', 'olQWjAsED');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfillary65@mayoclinic.com', '8912234233', 'UC9K6Gy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rricciardello66@nymag.com', '2704778057', 'OfeK9iIkju');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('asentance67@abc.net.au', '2063255770', 'RPE1nRji');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tjouhandeau68@businesswire.com', '9138953935', 'muxn2Tb3LY7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afrodsham69@i2i.jp', '7224669955', 'bMh2YeR7wrg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('relcy6a@miitbeian.gov.cn', '4147297913', 'QTY6MoADc0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atasch6b@europa.eu', '9338716961', 'jA5yVH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hkeer6c@com.com', '3086113802', 'y1HqGfl6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbough6d@cornell.edu', '8427142870', 'k1lRtmgW3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rtuxill6e@ebay.co.uk', '3295768082', 'CqyapD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpixton6f@mapquest.com', '9644758804', '5e2LEMK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('khawyes6g@blogger.com', '4202488155', 'BS6dNDl6BI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcalvert6h@ycombinator.com', '2787211979', '9jVLgTluCk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rkeese6i@apple.com', '9343135065', '7nuJFj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iferenczy6j@people.com.cn', '9373177038', 'ycRbsjvcd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mclowser6k@discovery.com', '2404317809', 'WmCZKd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amehmet6l@irs.gov', '1715713001', 's1JTye');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpentland6m@amazonaws.com', '2461222001', 'MW97G3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdawton6n@weebly.com', '4561457691', 'fcYvVgtQ1wUz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rferrie6o@latimes.com', '5484176238', 'Rn6AbjZe0Wk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('krolles6p@hibu.com', '6971896940', 'xlRVRJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chuthart6q@studiopress.com', '8101511363', 'zezY48WxbY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klaroze6r@e-recht24.de', '4131831795', 'HBTXvr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kpideon6s@cnbc.com', '5652554440', 'HzG0wh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjarville6t@telegraph.co.uk', '6831399742', '5UXYQ1Dkhudr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpaur6u@stumbleupon.com', '3149162461', 'AwgCmpa25');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsymondson6v@trellian.com', '4977593091', '5RvhHZpPW8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwheadon6w@usa.gov', '2665082884', '9XVrhT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmaysor6x@weebly.com', '5531295975', 'ax0ZeU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emerryman6y@gmpg.org', '7428499547', 'HIO3FRy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mvanarsdale6z@phpbb.com', '7324205025', 'kMVp12Odk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sohm70@g.co', '8654583706', 'blxrZJDfiYE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlarne71@mit.edu', '1352554808', 'P2v9s8y4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kblockey72@google.it', '6619088084', '6wOhVRURfoXh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbony73@uiuc.edu', '4036145539', 'UuS5KwZqzLJE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmckevany74@msn.com', '7455655253', '3TUMZzLIe7W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbelsham75@jimdo.com', '5874888315', 'V72j4u8cIn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chuison76@paginegialle.it', '4664287859', 'd6ek38Lki');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('crendell77@utexas.edu', '1825471565', 'UlqfLy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eatherton78@hc360.com', '4426409421', 'S8ow4GF7WR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdendon79@amazon.de', '6553734536', '5elO8A6rNvV0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('brameau7a@army.mil', '7146169045', '1Zcqbi6o92h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmaplesden7b@webeden.co.uk', '5995709740', 'xWntUceAJ4dE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apolfer7c@nyu.edu', '3797547676', '2bm3i1pUUDZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fjepp7d@economist.com', '8977788152', 'u9N1TMh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgouldie7e@delicious.com', '5244033739', 'GIuvTUdPh6b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adadda7f@booking.com', '2441405548', 'zXXQTJmmjYn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gjoslyn7g@last.fm', '9353871328', 'CAdgXaW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgoodby7h@arizona.edu', '3957074210', 'cMf7xNQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ftibb7i@abc.net.au', '7727160226', 'aMpHxSswf3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lstanbrooke7j@marketwatch.com', '6406004357', 'CJptyrN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abellhanger7k@yolasite.com', '7543975426', '0p48iJ9RE58I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgallant7l@admin.ch', '1756925394', 'NG831e6ftcRU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmcgrudder7m@pbs.org', '1385558191', 'JXWQY6Zq2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abaselio7n@pcworld.com', '9953030554', 'gyKKC843WENl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfey7o@mozilla.com', '7729745960', 'PVPlaXQDD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgleeton7p@dell.com', '6291966249', '95pU2x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('svanshin7q@sciencedaily.com', '7477232027', 'SMdGcRErWW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smcteer7r@myspace.com', '9446522240', 'D9hjYu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtulip7s@loc.gov', '1131104510', '8rOGsFmd8WJG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msalomon7t@china.com.cn', '8461830117', 'fiIgmwDo3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cglowacha7u@ameblo.jp', '8227061966', 'AxNpO0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rallington7v@hubpages.com', '9905293204', '7zn7ItqDga2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtaffee7w@guardian.co.uk', '1569132455', 'VQXoeTxexXpO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('akubik7x@wikipedia.org', '7483766286', 'YuCKyN7I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lducastel7y@mapquest.com', '3289296493', 'PSCR2YlpXK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sviste7z@arizona.edu', '1159485988', 'bkGpAsYy9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lforlonge80@blogtalkradio.com', '3061953002', 'Ir18fB7c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mferrara81@telegraph.co.uk', '6274632080', 'zN62rIwMy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wskelton82@shareasale.com', '7971789618', '7vYWJQFy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mchaundy83@meetup.com', '8668912819', '18ZeYAD639h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdines84@acquirethisname.com', '4474414380', 'QKEYBjEQT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aabrahm85@bbb.org', '9535115139', 'i9IA9b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rartrick86@dyndns.org', '7054540982', 'gkQt1al');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('krook87@issuu.com', '7607595114', '89fkv5tC8v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tknell88@rambler.ru', '6268083446', 'yfJrpZTy4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aivushkin89@oaic.gov.au', '4303996639', 'nS3lE6Eaj5iE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nkubiczek8a@wikispaces.com', '1103656487', 'lvoIwsbxfz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcazin8b@naver.com', '4334073735', 'CEG5Iw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnann8c@digg.com', '4332965914', 'ViIjsl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmcbayne8d@reuters.com', '6694699806', 'lMC1Cqp4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcomport8e@go.com', '9834209862', 'Yp1ipzb6M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ggotliffe8f@theatlantic.com', '6145301384', '7yzuGb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pantill8g@webs.com', '9265907619', 'STVMwsVt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmcclements8h@bizjournals.com', '2125731778', 'mlWbmYqb2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhowood8i@wikimedia.org', '6612143573', '1Xnw73Czt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lrandals8j@intel.com', '9338769315', 'rXwfbe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apedrocco8k@home.pl', '4777404812', 'I1UIxXNTTtd7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gfowden8l@wp.com', '7453547885', 'tzl00bxH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smival8m@qq.com', '9815782460', 'JNqbyT7NHto');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dlegate8n@omniture.com', '6436956828', 'wnUThlU3A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbough8o@acquirethisname.com', '2396665235', 'ZHMPtD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbinton8p@so-net.ne.jp', '9536347236', 'llOyrcUyKxPC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klord8q@who.int', '9328410573', 'soSY3EqWu8b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agrcic8r@linkedin.com', '5742504690', 'xnXjt1u');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dapplewhaite8s@mtv.com', '6203010360', 'MQDLsCbkxA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('erosbotham8t@apache.org', '3472420881', 'f4QhEoI1OM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddanels8u@alibaba.com', '8496454478', 'Wn0hLTu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtoderini8v@newyorker.com', '7758511586', 'WIzqFv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('zsatterley8w@shutterfly.com', '5117327738', 'hNAePuf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahairs8x@so-net.ne.jp', '5775287638', 'rMrXh6O3g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sansill8y@independent.co.uk', '6704870891', '7tg5M5X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbalfour8z@chron.com', '6081272878', '4UxxTe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('burpeth90@sphinn.com', '7908463230', 'PdD2cYhFdl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cvolonte91@nsw.gov.au', '4806654185', 'Odg61vn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdmiterko92@smugmug.com', '4049266431', 'sTXU3uB7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ggoolding93@csmonitor.com', '6343488913', 'LPOzGwY4my1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('brodbourne94@jimdo.com', '4834287634', 'JEnSwuZhoKS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hshepperd95@admin.ch', '3046996032', 'X4aHT84u');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rlarkin96@oaic.gov.au', '4256416967', 'OQhmvu64a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwheeliker97@examiner.com', '5745480581', 'kdS2DUiySTl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkemwal98@cdc.gov', '7949663655', 'XDFnVY3M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('delnor99@hc360.com', '7878600417', 'LLjhdz45gDmT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('brembaud9a@youtu.be', '8865127558', '7Fkeo52');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bchattington9b@washingtonpost.com', '4649827305', 'yaezCsZJb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('phaskett9c@craigslist.org', '3843659512', 'Wb1IEIl90');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jthompson9d@berkeley.edu', '5785172880', 'zYKOu0zzKn1y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dkensington9e@weather.com', '6089094422', 'HRVc77t0j');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hduplain9f@google.fr', '7603828576', 'CDZjIZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eellerton9g@yahoo.co.jp', '2977401486', 'JhnUK9Ls');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('balforde9h@tumblr.com', '9914398916', 'MxGab4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ptonkes9i@thetimes.co.uk', '4264119443', 'WDscrS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pgrandham9j@youtube.com', '4301034088', 'lxSPJo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('meccles9k@prweb.com', '3909740378', 'IgtxzFc7s');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oromaine9l@youtube.com', '7925886275', 'wwAg5f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dconley9m@chronoengine.com', '8212465930', 'kPXNWM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpaeckmeyer9n@clickbank.net', '1294682937', 'tOaiOVqtDk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdumberell9o@exblog.jp', '5101615863', 'ocqsEag');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbodell9p@scribd.com', '5673884627', 'TpefybJa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kodhams9q@issuu.com', '3312367168', 'LUw3ZCfxCH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmouth9r@jalbum.net', '3818412050', 'JhQhw3OPzy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bscone9s@icq.com', '3749019840', '5epF4ICifnv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpettegre9t@ucsd.edu', '9466070336', 'krg1xXBmmR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tnutton9u@yellowbook.com', '8355576565', 'wYVY4BA5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ksnelman9v@usda.gov', '7747645908', 'zNNHsbdHE91');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddeane9w@t-online.de', '3751262585', 'nvCLAy04');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdorbin9x@addthis.com', '6385331211', '1oytG7eM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ptumbridge9y@oracle.com', '7317002081', 'cHWaxSM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eanfossi9z@google.com.br', '3348754461', 'NS85uQhIB76');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('snailea0@hhs.gov', '5362171657', 'CgaasUr6b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jnijssena1@deviantart.com', '2804601090', 'kG0Bi41hj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vyoungmana2@etsy.com', '4602015858', 'yjBXtdu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgethyna3@yahoo.co.jp', '3345476989', 'GPHi6Lp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pjanninga4@techcrunch.com', '2969638068', 'iuJJTe3YL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbrimma5@cisco.com', '6582784449', 'LHJ1iC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hfairlamba6@mtv.com', '5993890375', 'bJPBnLO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdondona7@wordpress.com', '2629394079', 'nrLtHjOFXdD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('waulda8@samsung.com', '4841847180', 'chxo26tD9O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfettera9@java.com', '2055867008', 'fcJfWHXyThpJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dantunesaa@noaa.gov', '3016264915', '3HV2h7rweL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wgrestyab@rakuten.co.jp', '7192506995', '66suhy5x');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbeesonac@seattletimes.com', '8244759702', '4rAchrgCU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('skemmerad@weebly.com', '9875247808', 'pUuo9yS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('glaitae@timesonline.co.uk', '6676853472', 'tFS4dKLhOl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mavrahamofaf@fc2.com', '2667958870', 'Ynw5ipo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afaiersag@uol.com.br', '8334813066', 'xdOJ8xB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmacgiollapheadairah@nifty.com', '5463574600', 'hLW8WCkgN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smatthewmanai@arstechnica.com', '6022925906', '5oCAw7L6aD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hhandoveraj@earthlink.net', '6729565655', 'uAUeByqSl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmoorcraftak@skyrock.com', '4786264399', '2pZib8WQXs1J');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wnemchinoval@answers.com', '5633121003', 'I0Gf3N0CuO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmalenfantam@mapquest.com', '6884127368', 'Hmv4NscHf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jvaaran@hatena.ne.jp', '6709726639', 'mUOtoBj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wsprowleao@dedecms.com', '7177106975', 'XDgaBGB8TQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmarriottap@kickstarter.com', '5083882168', 'n5VdcUwF2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('khustonaq@opera.com', '4596966536', 'IbYOfVzQ1Y6d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfillisar@indiatimes.com', '6495557182', 'PuHOX8T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmcrorieas@twitpic.com', '3759933378', 'J3BU9JJdMS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cklimontovichat@imdb.com', '9064248405', 'Ycb9E1nIinHX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlumsdenau@dyndns.org', '4673524745', '6bcRcB7zLAc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ageraldezav@google.pl', '2662440999', 'e96YQfDmb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('llampenaw@businessinsider.com', '1038568522', '5rhmAGT5f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jboughtwoodax@technorati.com', '2401273445', 'w6nZYGSh03bo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ztetleyay@google.es', '4275252239', 'LbL5qFoc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcherryaz@hibu.com', '4748150224', 'Gr2iFuHkW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbabinb0@cbc.ca', '6139699840', 'z4vKaO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klaightb1@moonfruit.com', '8104229602', 'ORc5StZzwuSc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aperigoeb2@wiley.com', '7263744829', 'Q0cWJFlgNL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhefferb3@google.com.au', '9957302095', 'YWbJZx8Z7Jf5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tbasezzib4@nymag.com', '8412351405', 'ZqqLTd9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmollerb5@macromedia.com', '1612242685', 'E00MA4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('drelfeb6@imdb.com', '7276810963', 'pdwttC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmalingb7@vistaprint.com', '2066667386', 'qZnVSXP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amuzzillob8@wikipedia.org', '2036428826', 'uIJu0W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aarthyb9@google.fr', '2415265961', '0U3h9U8P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctribeba@sciencedirect.com', '1615969811', 'hPbz9DRM1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('akealybb@netvibes.com', '6228084132', 'VJj0EXGP7F8c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdewanbc@altervista.org', '5999224494', '4dWQ2MGqmqK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbladderbd@usatoday.com', '3133226558', 'QonT6CKWB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jscortonbe@reddit.com', '5249876965', 'O2QG4yTxC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hricoaldbf@flavors.me', '1828543918', 'CfIjY7y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdevennybg@soundcloud.com', '9564991673', 'lJFJOwM5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgrievebh@usda.gov', '2597525362', '4xl7pZxgW3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ucotteebi@cafepress.com', '9161440990', '16ic5m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('slervenbj@moonfruit.com', '1628275083', '3pRL1xFg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dblaycockbk@illinois.edu', '4989023852', '9bs16QzqX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fkubickibl@rambler.ru', '7227130195', 'HMNDvv6D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wedwardbm@dell.com', '4649758151', 'j1llX6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apetrellibn@deviantart.com', '5765032223', 'BaCdr1fEY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmcnamarabo@washington.edu', '9694414502', 'BdR6nFDCz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jnorvillebp@cloudflare.com', '9975738583', 'pGOLxAb7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ciglesiasbq@si.edu', '7919045025', 'pcDuDoid');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ltruwertbr@360.cn', '1077509367', 'MjBseb1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gboulterbs@sbwire.com', '8217809828', 'TYet1wF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awhitelawbt@blog.com', '6977974644', 'dhJFvHXHDp5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ckilfoylebu@examiner.com', '8025591723', 'D8cH2S');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbisgrovebv@icio.us', '3133824661', 'VLACMdoaM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsiviourbw@is.gd', '6006136253', 'oBql36QiY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wplatfootbx@vimeo.com', '4022674578', 'nVEWoUczv8X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rhallewellby@shop-pro.jp', '1454801526', 'myK2VN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlavallbz@shareasale.com', '6712194405', 'zXJXdj4yOu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwakelingc0@aboutads.info', '7966452838', 'q91npB4l1YTY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpulsfordc1@newsvine.com', '3729349664', 'rd2UPtP2Q492');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ogullifordc2@foxnews.com', '1598249667', 'aL0Jt6kbaRdk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mshemminc3@zimbio.com', '8919470274', 'C4Sx0QOp8qo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atomanc4@pbs.org', '1568050532', 'TqSHaBCo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('orodgersc5@mtv.com', '1725814582', '6ONjTE0UJk9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhicklingbottomc6@shutterfly.com', '8573567384', 'vvwNH1czht7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edonisec7@toplist.cz', '1501534886', 'S5YOD5NRxnm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddelacotec8@sourceforge.net', '1921652304', '1NpgryCrbyf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('osimakc9@feedburner.com', '1331213531', '0qy2RTVKQNc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcossorca@amazonaws.com', '5018348502', 'xyPWa2KXyaAb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mspearettcb@berkeley.edu', '9614311429', 'KmvSYI12zT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcharlescc@webs.com', '3875329794', 'ImbOBqUCE3YA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfilliskirkcd@who.int', '3318671358', '6CnR9Czjeqr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mthaxterce@forbes.com', '6658470616', 'kIPbNOb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmaudittcf@gizmodo.com', '2171266159', '3BpPDxIrw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kshottincg@etsy.com', '9438674541', 'a7qhUdusq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbrandoch@canalblog.com', '6633452707', 'SSTGsYeDZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('evangoci@discuz.net', '4672926582', 'cminz0d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ispellsworthcj@disqus.com', '2908386455', 'qg9IAD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pdanielovitchck@npr.org', '6438006809', 'wTHqxmW64j');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcambercl@list-manage.com', '9777120491', 'DTvfOjy7a');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gspellicycm@latimes.com', '6442331583', 'FyMlzs09');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ooslarcn@ibm.com', '3355521929', 'nm7zCyg8IlX0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('truhbenco@craigslist.org', '9126821097', 'TtsrB9898l45');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jhurdcp@microsoft.com', '8863891744', 'T10KNu0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmassimocq@studiopress.com', '9156724077', '2qpcQ0W');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wwasbroughcr@typepad.com', '2689671802', 'QgnR8V');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dkitecs@nasa.gov', '7541156452', 'PAzR3tP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msaysect@indiegogo.com', '4214259894', 'IvA7fIdN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmcelweecu@taobao.com', '7655604738', 'KJBU7nOlzUI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgrigollicv@sohu.com', '6477369439', 'OEUQq5rAAvYl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ajurscw@elegantthemes.com', '1182535318', 'cNKE26');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kschimonicx@e-recht24.de', '6411900718', '6FJ4i8ruV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cosmancy@cisco.com', '1045368480', 'yNFIsV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('npicardocz@thetimes.co.uk', '7209899126', '8Pm1qd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sweekd0@phoca.cz', '2044628584', 'Ly7vSCKP8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('odewittd1@youtube.com', '4846898530', 'yvv7sIIppW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eblakistond2@slashdot.org', '3562170310', '7GHAZt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hgiblingd3@seattletimes.com', '1008681272', 'FVQhAI4Ew9Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nfairlamd4@economist.com', '5664371220', 'n1FdXePZJg8M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dflecknoed5@chicagotribune.com', '4122344482', 'TtTzW0w9fYzH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pashworthd6@nps.gov', '9641197124', '9qQPnFSuRP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('phacund7@google.ru', '8981511240', 'cYCqHTmj9EI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cchoudhuryd8@hubpages.com', '5958254595', 'MFO1aGH5piu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('giveansd9@w3.org', '6913593686', 'wxUhAx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('flempennyda@blogger.com', '9731884822', 'JqI05xUuvU87');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iolyetdb@state.gov', '9781133059', '6hSKLn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmaiseydc@marketwatch.com', '3659154014', '2q80fXhFDjQb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apenddrethdd@psu.edu', '1436880286', 'MiPCho');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aalgeode@deviantart.com', '1811462889', 'FbcjXYelh5AT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcindereydf@pagesperso-orange.fr', '3935177243', 'szltn9Eiz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jimesondg@hostgator.com', '6969373924', 'FTlBapZFFXB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmilligandh@cbslocal.com', '8178582745', 'u4VYGieUBuyE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tdugalldi@thetimes.co.uk', '1806813385', 'UM262SBEL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hvedenyapindj@slideshare.net', '1983994630', 'dI6nfYzPqE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fleekdk@wikia.com', '8723348010', 'Tww1TnvMx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spettyfardl@ning.com', '7472793447', '7IsHivcSR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcruttendendm@microsoft.com', '6114024900', '5EZLd85');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('trenforthdn@vistaprint.com', '1502756973', 'cIj8L7tRgG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kharlerdo@kickstarter.com', '5677081201', 'e482ac27hj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('divettsdp@edublogs.org', '1886577895', 'Z00WcE5pPKn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rwoofindendq@blogs.com', '9746089900', 'H2T75rMvo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmessinghamdr@creativecommons.org', '4627163714', 'Y4gaRUGr5Kv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chumberds@google.com.hk', '4704325158', 'NnMAvnCDH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nprendivilledt@dropbox.com', '6745345612', '7IYqFAcdpiSC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iswancottdu@com.com', '1401903144', 'oxGUVC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lwilseydv@themeforest.net', '6705181052', 'qzhK5akUz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbrasdw@go.com', '7684580539', '7Zx1OXp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('myakobdx@jugem.jp', '7792925416', '5iE5E7d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eoloughlindy@fotki.com', '4363001638', 'ZMtUdDg03Ty');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nwastlingdz@google.com.hk', '3193820599', 'dJ4xtQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbuessene0@senate.gov', '3495628732', 'aE2h8PG2VSZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oposselte1@digg.com', '4169063812', 'hG9m9isuK4h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ewinstonee2@angelfire.com', '9538429282', 'ZxPesDAZ4K');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kthornhame3@blogtalkradio.com', '6622767542', '0H3BLyVrC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rcurrelle4@timesonline.co.uk', '8051723939', 'J7dRoRlWW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('erighye5@dyndns.org', '4943300786', 'M28RPI4oKA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wnevette6@tiny.cc', '4796517761', 'tK1Xx8zAw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fsaville7@princeton.edu', '1684051366', 'fveC1Cqd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mkillbye8@fema.gov', '2083417340', 'igZT8g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgraesere9@hexun.com', '3008659624', 'ruYXWE78');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ebateea@spiegel.de', '1601708714', 'fBcgvHb6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhargroveeb@csmonitor.com', '8024762749', 'c6BXlA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tdibbsec@blinklist.com', '7901833502', 'lefM95');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtignered@psu.edu', '7726380280', '4VZxCp7L50o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awitchee@cloudflare.com', '5158636103', 'IgjurOXNnF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpersittef@dagondesign.com', '6017573156', '4uSdQXCtaV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dfrayneg@sphinn.com', '8642801864', 'GBOZho');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agladstoneeh@godaddy.com', '7169211252', 'U39uPQR7B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dheinsenei@narod.ru', '9187787920', 'FzYWME');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fpeopleej@sciencedirect.com', '2676101150', '1H99Jbyntoz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ejoskovitchek@vimeo.com', '9415257931', '5aimb3qnzOfi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtoveyel@ibm.com', '5342656830', 'CZNuM4w3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btrowleem@rambler.ru', '3125992577', 'flxDxm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgirardeten@com.com', '3902038666', 'kJhjIL0cIY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jsangoeo@ezinearticles.com', '6532862976', 'Hba57qAUK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccolliarep@boston.com', '7809757803', '7TFHM8M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hwiddoweseq@unicef.org', '6809621078', 'SUlA85ElcD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgarweller@ehow.com', '1246718644', 'xb1cCD4V8vQ9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lackhurstes@hao123.com', '7967826425', '9Wg6bxk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rchanceet@disqus.com', '3524483266', '219nh5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('freekieeu@elegantthemes.com', '5224239795', 'GYviB0P1ly9D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klaleveeev@nymag.com', '4725027331', 'N4xzjjEcqmXK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pmatasovew@mysql.com', '7176586327', 'K82S33zChOwM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('askipponex@statcounter.com', '5049483340', '3EBNjtM7lb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmackayey@infoseek.co.jp', '7866362388', 'cCVUCld');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mthirkettleez@illinois.edu', '4131127632', 'c413tu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhowgillf0@walmart.com', '7677540488', '4XUurH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hjachimiakf1@over-blog.com', '5385403557', 'vvBhlMe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nkollachf2@gravatar.com', '8083993969', 'BXMAXpUjcW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hsaketf3@bizjournals.com', '5594003537', 'eJ6IKIWzR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehuddartf4@unc.edu', '6719769127', 'wieNpuKxMu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jfiskef5@marriott.com', '4121255191', 'JhDZLCI4ctYY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pwhitmanf6@xrea.com', '9206134727', 'N9xBeLf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abrendf7@themeforest.net', '9954477687', 'fuI7qMFZKm1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adelayglesiaf8@instagram.com', '7773938430', '4S8Sbr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amacef9@blogtalkradio.com', '7993740599', 'OLL0BmRr');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgerholzfa@ezinearticles.com', '5979869748', '3FsNIWcF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('okybirdfb@cpanel.net', '1886954175', '84srzgIv6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pslinnfc@skyrock.com', '9864872056', 'GhPbHP4jyxt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nhurdwellfd@marriott.com', '9414538791', 'jkLQpVGUrwc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hthomsenfe@ameblo.jp', '9963370148', 'OBLiW4nNPJqV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcheeneyff@msn.com', '3646414995', 'vRNtmqpe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nlesliefg@baidu.com', '7252302395', 'S8uy6Yd4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msjostromfh@ft.com', '1638080441', '0XucsXZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ntoderinifi@icio.us', '7164175144', 'T96uoZwVHtVU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmalimoefj@artisteer.com', '9945535970', 'VzhKmQ048t');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdrinkhallfk@ox.ac.uk', '7337989878', '8sjmEVLpm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmccaughrenfl@feedburner.com', '8006518648', 'ELSsZs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('docahsedyfm@t-online.de', '2804909482', 'pqGhTmNf9HDy');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ocurteisfn@salon.com', '7916694604', 'Lj1oHdnMhDa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('upetriellofo@adobe.com', '9441018985', 'HMr14X9h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lskunesfp@marketwatch.com', '7902246273', 'jYNlf2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apettiefq@tiny.cc', '3844607511', 'CUnCkbB0k');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('swenhamfr@wunderground.com', '9433292133', 'BYuaTug9WM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmilleyfs@1und1.de', '8792953427', 'ia1Q7v7D');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gdufoureft@miitbeian.gov.cn', '3134375111', 'CtRbwVTS0WPX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fputtanfu@miitbeian.gov.cn', '9603842011', 'MjZ7gwUe4DJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhewfv@naver.com', '6413306263', 'NRyJn4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ifirbankfw@mashable.com', '6656537330', 'knhmbl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('achildesfx@odnoklassniki.ru', '5988520689', 'RtklWxzzR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpuxleyfy@unblog.fr', '7026052346', 'PmAFB4Jn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('reyesfz@census.gov', '7091755426', '38eAFMZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('raliboneg0@google.com', '6997588482', 'XiZeQOlt1w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmaginotg1@home.pl', '8373841155', 'Wf9QsdAzBXdq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vcampaigneg2@storify.com', '8014093142', 'NH9nRF8jARg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpedlowg3@google.com.au', '5303364750', 'Cz0IluEW0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbiggamg4@yandex.ru', '3769955795', 'q5dvLOTOjA5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yelcombg5@nsw.gov.au', '9609585503', 'LvIqdDg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfranzmang6@clickbank.net', '2225150057', '2g0CygG90TJt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdraycottg7@constantcontact.com', '8699295583', '7mD0F2tihOcn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cnequestg8@huffingtonpost.com', '2755635799', '6XLNNn3H4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rstrandg9@dot.gov', '7659995740', 'HB8Au1aRcs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ladairga@wikimedia.org', '8106150398', 'abF1TqjC02');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('oleahairgb@umich.edu', '4845412129', 's6pGe7pGu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rrawstornegc@salon.com', '9434327880', 'fPgsN6G4MVjt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('npydcockgd@sohu.com', '4511381384', 'cFBw3kP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('arolfinige@gizmodo.com', '2124562490', 'viNBfgc7c0bV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('leverlygf@dedecms.com', '8754036858', 'dFOEZo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('doxnamgg@google.de', '3778151701', 'l6F5lmW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edandygh@privacy.gov.au', '4575733291', 'aDgIaO1TD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgleavegi@livejournal.com', '7221111403', 'hsATAKbslnm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mplumbegj@ihg.com', '7543345779', 'JwyL3CiOpfRi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cissattgk@jiathis.com', '6889608086', 'cpiaLNT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbowdengl@mlb.com', '8067570265', 'W3c9Evzo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ppursergm@photobucket.com', '6907429867', 'MEBQRB96WiE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ajindracekgn@hubpages.com', '7878599063', 'o0CFJViXZl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gvondrasekgo@bluehost.com', '1075513375', 'KSikQ0WDAV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ghellekergp@ustream.tv', '9808498178', 'xvrhmli0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jduhamgq@youtube.com', '3546907156', '7OMWk0p2ad6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('onaerupgr@bloglines.com', '1247802012', 'pZvNoff');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nfreemangs@sfgate.com', '5004727951', 'xfELh7L7DRT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sscarlangt@jiathis.com', '6163195533', 'ejLla3lrZS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfitzhenrygu@time.com', '2278201918', 'rMlpzwlZ3uP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dclackersgv@loc.gov', '6886345116', 'y2eg35rSDexx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbadbygw@si.edu', '7668216795', 'vvR25mPd7V3h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('alinsaygx@ovh.net', '8112243441', 'TPvBKmvcH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tsylvainegy@storify.com', '7564621042', 'oc8HtQ25');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('frosewellgz@vk.com', '2215820978', 'Dpap5i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgregolettih0@geocities.jp', '8533625298', 'D1fMZ1dh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcrosettih1@hibu.com', '7717947219', 'dTfCU4p8d5xO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rspatonih2@comcast.net', '1829667043', 'arnO26h');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbewshireh3@nationalgeographic.com', '5824702820', '8QzHhRA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('csarah4@themeforest.net', '2707777214', 'G4bfP5V1RR9r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtreleaseh5@ibm.com', '7669975496', '4KksJ6K9qK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nfulgerh6@privacy.gov.au', '4544342584', 'XUt2it');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcampaigneh7@ucsd.edu', '5797693863', 'BDRkHY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gfrippsh8@goodreads.com', '9307410600', 'mQnvrnYtF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbrookesbieh9@nba.com', '6543185083', 'DTh6w4M');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbratcherha@php.net', '2919907521', 'fQTWXApYTq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kearryhb@hhs.gov', '6089821650', 'y6CF836O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bkohnerthc@about.me', '5641092573', 'gxSodRqVAokO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afetteshd@go.com', '7743898282', 'zukgm3wC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbacchushe@loc.gov', '8334072831', 'G91QdA7O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mbasillonhf@angelfire.com', '9305724163', 'VxASRM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vdabernotthg@foxnews.com', '2638848677', 'yS1oaGfprgg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pvaskinhh@youku.com', '9724477388', '86xO6VjI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('warraulthi@xing.com', '5864611497', 'os3TT3h1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehaughinhj@chron.com', '7468307868', '2yrakgFAhe07');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmacanespiehk@diigo.com', '6163201209', 'E7TVAM2vKa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcracknallhl@reuters.com', '3546761686', 'gihOo67');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lennalshm@pbs.org', '4728026072', 'uz4c2gCLaZw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnilleshn@bizjournals.com', '7062874370', 'lmeFH78');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgitthouseho@vinaora.com', '4921359265', 'fgGi3HHQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdebankehp@alibaba.com', '9463989639', 'Lh4wXbITu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ehealyhq@princeton.edu', '3273638238', 'gDJORn8B9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcasfordhr@example.com', '7794205406', 'lNs6g0jT5lU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdodellhs@moonfruit.com', '6855800689', 'I8WyHYK4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rkelbererht@sohu.com', '3185329861', 'YlVL12');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmattusevichhu@census.gov', '6955464167', 'MosCMth');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgaishsonhv@jigsy.com', '4277641606', 'DaWKDM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwortmanhw@tmall.com', '7331992594', '1ovmVYpw8Jt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jkermeenhx@disqus.com', '2257148796', 'AyUD5d');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wcoomeshy@tmall.com', '1537333599', 'zfEp82');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sclethrohz@sciencedirect.com', '5921990272', '1vBjynbx4l');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbrindlei0@theatlantic.com', '5064703906', 'bk27v1Lro');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mriepli1@google.com.hk', '4887603167', 'iTiuG791rSA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcasselsi2@list-manage.com', '3875611603', 'W7ksHiTWBl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rwedoni3@si.edu', '7127500706', 'bWt1n3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tdarlingtoni4@ow.ly', '8789176601', 'LlkVSAW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mglovesi5@bloomberg.com', '6294444290', 'Xl5O5W8EiAk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mheibli6@de.vu', '4226211721', 'nBf9Pit');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ggarrattleyi7@rediff.com', '9877588583', 'LcAXiAUqfVRU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtearei8@wunderground.com', '1022062742', '65SegTEMwx98');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbaumei9@posterous.com', '5703975042', 'TTz6JzH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agoroniia@drupal.org', '1951095544', 'coFOX8p4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnatalieib@usgs.gov', '9063124006', 'LfYJdW7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('thillhouseic@telegraph.co.uk', '3204547419', 'myv6dBev');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('csmithamid@upenn.edu', '1389593178', '64e1HaD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbadenie@zdnet.com', '5559554610', 'vAjfna0z7k');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ljirzikif@vkontakte.ru', '1244839259', 'NBynMwQG5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdarrigoneig@blogspot.com', '3634033466', 'bwmey42R');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adooneyih@sun.com', '2032981697', 'JqtyHKj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbacklerii@infoseek.co.jp', '4691659298', 'MEsmSDh3oYU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ttotterdellij@blogspot.com', '8229465562', 'DZ0G7r7grkd2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bdizlieik@dropbox.com', '1715438579', '2HmX7OQi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lfarneyil@cdbaby.com', '8339911514', 'Ruusefaaf046');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acullumim@reuters.com', '1801496709', '1XWMG11NQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aholdeyin@com.com', '2986969163', 'QRABwKIj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abreedsio@xing.com', '5386236870', 'aCvXix9m');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfalckip@tripod.com', '1246407727', 'Zi0KJiJdB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tfishbourneiq@amazonaws.com', '4041133627', 'XiC4nxCZCUxf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhaselyir@aol.com', '6602376793', 'xBbaOeb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ojanseyis@deviantart.com', '5488519488', 'Xs1rX6k7z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tliddellit@behance.net', '4301565220', 'F3RG8hH6VMx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dewersiu@instagram.com', '4438213611', 'PPzwbQE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mcartmaleiv@java.com', '9169722285', 'TCTjvygFxLHm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhovertiw@usa.gov', '2287149582', 'kGM5tKsxCRAf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('astapyltonix@pen.io', '2139763032', 'Z8kuGEqs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtompkissiy@indiegogo.com', '5323928022', 'xCYzu0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddonnaniz@studiopress.com', '3795034382', 'zyiraBd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ekissockj0@163.com', '9548160085', '5MwJy3sU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ayousonj1@elegantthemes.com', '3447936347', '1ETsJfDaq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsecrettj2@friendfeed.com', '4717073400', '8TtbRRuM');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('egriffoenj3@example.com', '6329522223', 'dW6xgz');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnormavellj4@yale.edu', '5881081860', 'ztkMDWQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edilrewj5@zimbio.com', '8332854751', 'K4bEYSNmOd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfroomj6@hc360.com', '9677399744', 'rI5f6FxGOB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fhoytej7@blogs.com', '1744602033', 'x3tx6NdA1EU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gjemmisonj8@opera.com', '4751975283', 'GthTtcJtxGUV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cauburyj9@jimdo.com', '9391166799', 'mnLNCv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('evasiljevicja@addtoany.com', '3808861248', 'wXshRtQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vdowjb@comsenz.com', '1686564026', 'hwOMQfSs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbunclarkjc@earthlink.net', '8669560793', 'TxWbljd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kwhanstalljd@springer.com', '2774331773', 'wG2uYq3ErxNo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('seberdtje@about.com', '8795930680', 'sa1KhlX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbrogionijf@vistaprint.com', '8647564941', 'EOnBpZp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbulpittjg@fc2.com', '9138608620', 'vOuSwH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kiremongerjh@weather.com', '5577076612', 'K3UrEdcdf9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtolleji@netlog.com', '2187661348', '1ugtxUl4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcastagnejj@goodreads.com', '2019207280', 'RqpLMrs1MJw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mklauerjk@quantcast.com', '8101412637', 'XQXu7E4qs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldennerlyjl@amazon.co.jp', '5216332566', 'dNuizHab1AA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbabcockjm@joomla.org', '5804008240', 'MuDbEWJDoKB8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ldaicejn@omniture.com', '5504967780', 'X1nW1eZlO4I4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdunsirejo@wikipedia.org', '9189777232', 'ymfZttKyCj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gpedlowjp@g.co', '5599851022', 'upI6XkRkt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtroppmannjq@columbia.edu', '8784224942', 'X8mjW0TOt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jaggisjr@seesaa.net', '6175072522', 'ZuMcHj0NI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dloundjs@qq.com', '1425461760', 'xriBF8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gcarojt@de.vu', '1181167265', '4W91oFW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rdelaegliseju@deviantart.com', '1204018667', 'wj3eNZiMiWA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbeafordjv@facebook.com', '3151914427', 'MaLT4porJHZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sfernandesjw@1688.com', '9893312417', 'olsx7ug33f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aiacabuccijx@icio.us', '8155685917', '9UcdE27y1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lflickerjy@forbes.com', '4894643071', 'cZPKxGBS49T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('atryejz@comcast.net', '7577056880', 'Uo7Hz0SZgvT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmurtellk0@nbcnews.com', '2452885518', 'NgUzisPkRSf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yspillerk1@buzzfeed.com', '1478303481', 'QP4GIII8ti');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('proulstonk2@jalbum.net', '5847830416', 'IEydaCY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgadneyk3@slideshare.net', '3067227290', '4Xh6Ym7Z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('olangabeerk4@irs.gov', '3737616949', 'Q5dksJFyS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmacdonellk5@yellowpages.com', '8723284976', 'Ahvyp7gCwXU9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lallmondk6@e-recht24.de', '8485666238', 'IkjjPEFR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cmorffewk7@sciencedaily.com', '4686834831', 'qpDCWuKN5sB2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('matleek8@unicef.org', '8916320186', 'qQEt6XC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('citzaksonk9@marketwatch.com', '9823438636', 'zg8kOWdSHiw9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vgavaghanka@etsy.com', '2123581165', '3RuM7sSp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pstansfieldkb@reference.com', '2717192123', 'PKpXEGGUi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gnewshamkc@printfriendly.com', '1661941448', 'M0oxeKuw1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjordansonkd@nhs.uk', '9525723123', 'nfBzh3p9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmulryanke@topsy.com', '6515845789', 'y2waOQ9Sxo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cjurczakkf@gnu.org', '8466255130', 'LuiDgXGIt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgoldbykg@statcounter.com', '7386632504', 'n0NZsQVJkB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccabellkh@springer.com', '7777025773', 'O2tRSKdrpU5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpaskinski@studiopress.com', '6741487979', '2Cmn3vKXeP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdietmarkj@nationalgeographic.com', '3984632653', 'zcQIxOm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdomengekk@chron.com', '4326206407', 'lnMb3NU4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdowgillkl@cafepress.com', '4451495918', 'yqO7nVi29nU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tlindelofkm@blogtalkradio.com', '1043427311', 'kte4JfID1q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctattersdillkn@yelp.com', '8808354046', 'otDXWn2sN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbogaertko@google.pl', '6287485005', 'yv9L5B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ccapeskp@pcworld.com', '5689352682', 'AropbpuNRq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mralfekq@paginegialle.it', '9544998637', 'A6WS9VGA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bfeenykr@indiatimes.com', '4701052172', 'IZPVdoec5bx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sfilippiks@flickr.com', '8177143955', 'NbLp91pDU09');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eczaplakt@fastcompany.com', '6585464211', 'Kwwij6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('spratchettku@answers.com', '3277403422', 'y2RTrVuHAX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('klealekv@seattletimes.com', '2524566977', 'vswQHke9pxdg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abrehaultkw@answers.com', '9649021657', 'x85CmxF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jtittershillkx@umn.edu', '1714656876', 'zjJOUOFY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rsimysonky@sina.com.cn', '7663202141', '0Vuefo59qykN');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jpeircekz@flavors.me', '4368860778', 'wfw2ZjT9euB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dpetkensl0@latimes.com', '8438908982', 'V1Uu8y2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hdoudl1@tmall.com', '8524893160', 'iuIfqXu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bwoodusl2@hubpages.com', '1294435402', 'nETT4hVjY5I');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('iskillmanl3@jugem.jp', '5432561840', 'p3m3c8CSOqe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gburnetl4@etsy.com', '4059217567', 'NSNQj0q0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afaithfulll5@ustream.tv', '7132431230', '2YI0EI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwastelll6@unc.edu', '4649670676', '9iCDecTsXmg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgosslingl7@com.com', '5224457157', '8c4tYnOnkG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('adarkinsl8@artisteer.com', '6216295190', 'E6ma3T');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('welgeyl9@infoseek.co.jp', '9091660687', 'eaKcyv3XA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rstrangela@cnet.com', '1378560551', 'c5dIPQw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lwalentynowiczlb@ucoz.com', '2451008576', 'NSlPosqOb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgricewoodlc@japanpost.jp', '7416857710', 'dxivYzj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rfortyld@mediafire.com', '5094284793', 'yuWUQtA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tgeavenyle@scribd.com', '8488378369', 'kGclR3kk4a5V');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('msutherlandlf@mysql.com', '9706845667', 'yShDSWOwu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gsherrocklg@usgs.gov', '1114161418', 'oL9JVl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cgeakelh@netvibes.com', '9302446973', 'E9fuLaoQ6Mji');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amillamli@sciencedaily.com', '3981588019', 'QlsHPPUm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mkevernlj@newsvine.com', '9813720857', 'AuMctlJqImh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ddillestonlk@miibeian.gov.cn', '9104984179', '1swaDc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('schreell@newyorker.com', '3699635868', 'ABsiyb9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbellchamberlm@marriott.com', '9596343423', '9rnYNF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eprevettln@nymag.com', '5118988222', 'UtLX9U');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abrabbinslo@lycos.com', '5787210315', '9muxej');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpogosianlp@discuz.net', '1242867907', 'lRSjk8c6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nsnoadlq@admin.ch', '6061332226', 'ieGZmgtK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nbrotherhoodlr@seattletimes.com', '1297320036', 'x6gKsTj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lhedneyls@ibm.com', '6206486362', 'aNK8ZtRbN29');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dhenfrelt@merriam-webster.com', '2625892883', 'm0btw5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fdonisilu@furl.net', '3157339997', 'fNZuDUWV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rharkeslv@yandex.ru', '3526042710', 'sBMQQG3e0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mlightowlerlw@ed.gov', '6787387628', 'aUltrO9ZrF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('skachelerlx@histats.com', '2234507710', 'VkbvXK0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mjindacekly@hhs.gov', '3997788120', 'mHSOYAyf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acarthylz@uol.com.br', '2659618407', 'lRGN2yFa');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acossumm0@myspace.com', '2634445071', 'lG9uajp1Q1R');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sgoggenm1@vimeo.com', '8471081940', 'yvMMbkaaAcn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmetheringhamm2@livejournal.com', '8824098772', 'jXCpkOiJmPL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lferrinom3@bloglovin.com', '3823257539', 'w8SnCFhitnF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hsmithamm4@meetup.com', '8215310496', 'BRiaqI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgrizardm5@uiuc.edu', '6703458549', 'Pa3CPYYK24');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kacklandsm6@bravesites.com', '5642777321', 'IXkeyd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdaym7@shareasale.com', '7229374065', 'bPaeaN4UZKU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eyurshevm8@guardian.co.uk', '7138264703', 'uoL8c6jHt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fmcnabbm9@earthlink.net', '6827372401', 'NfkwHj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgiacomelloma@cbsnews.com', '1881680327', 'Z4qYR1DZRbt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jkhristyukhinmb@soup.io', '6521715336', 'OdjPNU08rAm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scaldwallmc@homestead.com', '1419842878', '3mQmq8');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mtweddlemd@icq.com', '5547523141', '8NgrRJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rentwistleme@mashable.com', '7052381875', 'xOqDUv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ksherermf@nymag.com', '9606476300', 'JVChyBMxg3t');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tavramovichmg@eventbrite.com', '5209592533', 'Ez4qWX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dgabbitismh@usnews.com', '3857415283', '1ahVE7o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cpoggmi@yolasite.com', '1729918907', 'IuB8snVnTI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jneevemj@themeforest.net', '9552112176', 'wwDzJVTc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rgaythermk@spotify.com', '8792887894', 'vqeF0fCX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gvasentsovml@oaic.gov.au', '5891464125', 'EkC1AGYHj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cbarrowsmm@marriott.com', '5071067145', '7D7xwYTL5ZfT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aionmn@simplemachines.org', '7099964870', 'EYpdQnPTF');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scastellacciomo@slideshare.net', '7276968067', 'hNH8JOjkbI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aeddsmp@usgs.gov', '9899347635', 'yXV2gdB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bamosmq@theguardian.com', '7551699189', 'Uup3Pc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmolinesmr@t-online.de', '8074244135', 'VG2BTcj3L');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ipendrems@gmpg.org', '4643144186', '3qqHYTWFmkg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwindybankmt@prnewswire.com', '3819407665', 'kb2j7przB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gbartusekmu@forbes.com', '5102561483', 'UqxSVOoKb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rpashleymv@earthlink.net', '2421590602', 'KdHXucmO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmcveymw@canalblog.com', '3023120293', 'bjGGOG4N');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdablingmx@seattletimes.com', '3928232168', 'zhveisLDl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fsothammy@stumbleupon.com', '5674167405', 'jKiRU0xULWS');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdoberermz@house.gov', '1999152774', 'MGdF4z');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bgoldspinkn0@amazon.de', '1531447925', 'eijSRyxsp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('beschalotten1@wordpress.com', '9246789977', 'mDaxiPjlq');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dsansonn2@soup.io', '7134932901', '83XCYOv');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afoskenn3@npr.org', '6909522514', 'rVljiBY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mdobien4@nationalgeographic.com', '4159302361', 'xLoZd3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tpaulen5@over-blog.com', '7528885492', 'K17vi6ol');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wfrankcomben6@mediafire.com', '1862077230', 'WRPFjsxx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rhailn7@google.it', '3539566104', '3BMVbmHU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('afentonn8@craigslist.org', '8256277133', 'LtwbY5nMxNs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('idaelmann9@istockphoto.com', '3761282775', 'IFIYsNe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tmerritonna@gravatar.com', '7207484947', 'Al3Q5I2o');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('psuthernsnb@cloudflare.com', '5605120844', 'jK5d2ed');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lcolnettnc@topsy.com', '2532288546', '4G6SaPe');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cdorantnd@zimbio.com', '1021571978', 'zZPobtH0oC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tthomane@clickbank.net', '2836798528', 'OhMhCXnNi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('emoylernf@flavors.me', '5211553186', 'OSlAiWoQk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('btokellng@google.co.jp', '4002570110', '7pi4zMST');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmackeynh@wikia.com', '9076350034', 'WdWD6V2SHos');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbawleni@sitemeter.com', '3734075802', 'GHNHxqwlXE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bhumbatchnj@amazon.com', '1297135306', 'yuu13v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtracenk@deliciousdays.com', '8119597198', 'DfPLpIaNi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpaceynl@europa.eu', '4729204553', 'E4pJVRXC3X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmillinnm@liveinternet.ru', '9212830047', '3NaXtp6Slul');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('thamalnn@amazon.de', '5745806804', 'sqBbpt3TsgV');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fbirchenoughno@issuu.com', '2634943423', 'xOhCTWJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mrieflinnp@smh.com.au', '5555748669', 'ApyqiUadYer');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('triolfonq@ycombinator.com', '4488328214', 'PlCWfGMx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgornarnr@ehow.com', '7446111616', 'kmoGtHZt1r');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rjobkens@mapy.cz', '4274505699', 'hULMzNewhx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aafflecknt@oracle.com', '3473749251', '0WjDxilujpQ4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('blewisnu@usda.gov', '8763294760', 'pJuojG9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('amaskallnv@e-recht24.de', '9365097737', 'IhrExBd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gspoolenw@reddit.com', '9207676705', 'oD0AiW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eosichevnx@163.com', '8975964790', 'IN5tpod5aDdl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cscrangeny@harvard.edu', '8271133881', 'xVmANf7A');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tjonczyknz@scientificamerican.com', '8516670414', 'TBXazvnczxdA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdeatono0@fda.gov', '2102356601', 'o323pP9BGx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbaumo1@networkadvertising.org', '3604478017', '6bcX3Xzz4rG');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('awaythingo2@sciencedaily.com', '7758814736', 'BEamH6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('anicollso3@yandex.ru', '8557590703', '5DpG2AY15');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mroydso4@sohu.com', '7447998919', 'jnnaoGJnRbwt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vphillippso5@opera.com', '1608298125', 'iUH3lk1O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('croggero6@sphinn.com', '9906402582', 'XmLcypJkRvh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jgastickeo7@unblog.fr', '8106482308', 'FyLtET');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpantryo8@sohu.com', '3944061547', 'Q0Rl0F7Xs7jx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lagiuso9@last.fm', '4476079626', 'hdUQwgg0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('akhadiroa@usgs.gov', '6333146582', 'wqx8CF3G9dL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('imowattob@techcrunch.com', '1144687544', 'k5Bzb0da5NC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gwoodersonoc@engadget.com', '1096503969', 'b2deTh5EK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbowlesod@gravatar.com', '4792222991', 'jgIwWAjJSbJj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mipsgraveoe@fema.gov', '7098368475', 'dSNoS8FckDP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hchaplainof@cnbc.com', '3183801405', 'QfDm6g');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcollimoreog@delicious.com', '9384208646', 'tRI16uI7Lyc');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pbeltonoh@devhub.com', '3427345327', 'IU3HoRncPw');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gupsonoi@reference.com', '8534971666', '9im5G6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('agoomesoj@over-blog.com', '7085316994', '6YGfR6c');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mjakovijevicok@blogtalkradio.com', '9337038384', 'LYyB8gA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bpeardeol@tripod.com', '6596216924', '5Ch5dTyf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fsaffellom@nifty.com', '4055127240', 'N7BsyZtaDb');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpaveseon@youku.com', '5959904419', 'eGIoRR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hhessleoo@twitpic.com', '9289375667', 'NgQHZArWHwp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kmoseleyop@phoca.cz', '5805405625', 'XMJdR7B');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sskentelburyoq@goo.gl', '9304316029', 'vdnlPYhA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tcartmanor@technorati.com', '2784714762', 'b2aAvcY7El');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apodmoreos@51.la', '5067588831', 'hwn1wwUv7f');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nworkot@wsj.com', '5137831365', 'klP5WoMJCq8X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pmccluskeyou@github.com', '1655897488', 'fzSewiPI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eeminsonov@tinypic.com', '7724108881', 'OItbSAyTeE');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vofihilyow@unicef.org', '8632046828', 'qlf7jIZxJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('djenkingox@yale.edu', '8698636972', 'qSBFeKjZgW');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lpaulssonoy@washingtonpost.com', '9711045039', 'jc2Y9Zk132');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lkairnsoz@infoseek.co.jp', '4922104997', '3sJmhRYkI');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wlardezp0@china.com.cn', '8671113998', 'z6JnppPER');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gpratleyp1@cargocollective.com', '3734744662', 'keTbQrHKosyH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('nskeatp2@gnu.org', '7987543827', 'g3agMUZf02E');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cspallsp3@youku.com', '7207148655', 'QbJqrceEBP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahawkwoodp4@independent.co.uk', '2041836922', '8xzBmDDhpXBU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('qfleethamp5@4shared.com', '9932790252', 'lsYxpmAAAL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbarkworthp6@google.com', '3512547906', 'F7XIL60Jl');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmompessonp7@newyorker.com', '3762947630', 'nCkfRRR');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gmouanp8@blogspot.com', '2543015976', 'XGm9FfIcoWKs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lbrignallp9@nifty.com', '7233876392', 'sfoeHl6P');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bbrounpa@google.cn', '3199921387', 'HmQKcS5m7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmcguirepb@thetimes.co.uk', '5845730014', 'pTBuo7Br');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sestoilepc@seesaa.net', '9698751616', 'rA5NBCs5Yj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('yobraypd@joomla.org', '9678919879', 'vAQcXB5fm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('tspurierpe@skyrock.com', '6588006412', 'bhSWd4n');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('acrownshawpf@fotki.com', '8328698262', 'L9DmlpOsd0O');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mjearypg@networksolutions.com', '9171282558', 'QZpv2Q');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bskrinesph@imgur.com', '4858951513', 'fwlCRf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dtomblingpi@joomla.org', '3458042203', 'Sp49JMG5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('glaughtissepj@blogtalkradio.com', '4087411581', 'aR7uCqK3Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kgepsonpk@princeton.edu', '9874111465', '9hZfAlz57');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hmuzzillopl@nifty.com', '2808947270', 'W0R6FepdQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmansfordpm@ed.gov', '5704561123', 'LE2vaY');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('edullardpn@pen.io', '2682211447', 'RrLLPx');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bmorgonpo@biblegateway.com', '9035772937', 'jyn9J6w');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndumbreckpp@ezinearticles.com', '4512793075', 'h1TEgC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mkasperpq@archive.org', '6033433911', 'MO1d1lwocpm');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('goakshottpr@unblog.fr', '2386757799', 'pew79Mp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bcoskerryps@yandex.ru', '5928404608', '4Nw4SoM5');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ageorgesonpt@go.com', '3709097910', 'utgQgP7V0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mpretopu@nature.com', '3668215565', 'J3Bsox');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('macedopv@npr.org', '7431701495', 'nNtLx6d6Y');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mmacguffogpw@reddit.com', '8919241074', '5YCC50');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kellenspx@flavors.me', '9844230245', 'pM7WoqHTnZA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('olamkinpy@pagesperso-orange.fr', '7804761528', 'mMBTjuea1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcaldwellpz@patch.com', '6781952416', 'H2bNV0d4i');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('sbaineq0@1und1.de', '9151017535', 't9G9I92N4bC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfrediq1@washington.edu', '3142800322', 'LKBFU8Mqg');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwheeldonq2@tiny.cc', '4999461370', 'F9mIWykoXwc6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mgrishaevq3@sun.com', '8074800829', 'sBRalk');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ndubsq4@newyorker.com', '6157109075', 'zDSmjp');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wgirdwoodq5@nyu.edu', '7603365938', 'lklaLVZ1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('svilleq6@twitter.com', '8052163325', 'h4Q5XU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('azoephelq7@mac.com', '4265561980', '0ON2nJ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kdeiq8@businesswire.com', '9147516225', 'kMKbdHcbFhtt');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dnorkettq9@xrea.com', '1029675222', 'bQniMB');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwraithqa@hhs.gov', '3051283086', 'v1NftL3zo');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jbrugmanqb@cisco.com', '6169850381', 'n5af6dSGcaGn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('landreouqc@1688.com', '1189956666', 'YFbJSgvOhh');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cleteurtreqd@usa.gov', '7794376054', 'HImg63');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('apaleyqe@photobucket.com', '2474975876', '7md7n5n2Zx4');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dcollymoreqf@digg.com', '6803990671', 'WTKkhSwiT');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hkissqg@hhs.gov', '3914225964', 'LjI2H3b');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jmacneachtainqh@lulu.com', '6552126280', 'e49ynn');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('hbluckqi@aboutads.info', '6045351160', 'eJLBwREf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lvillarqj@delicious.com', '2703269847', 'nq2HbX');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('scurdsqk@examiner.com', '1356891063', 'XwKer02Win');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('eriolfiql@webnode.com', '8028040531', 'V8N5pov');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('vcolliberqm@sogou.com', '6166498525', 'CkmWnq5vu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ckienzleqn@soundcloud.com', '9429155451', 'pWVAjBL');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('abykqo@deliciousdays.com', '1722104924', 'p3SFtI7p');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('askepqp@wunderground.com', '6383013134', 'D9QgFDa9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('smacdirmidqq@google.nl', '6914679715', 'UJbfnkMi');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kharyngtonqr@cnbc.com', '9561738998', 'cDvjvMD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ainsollqs@patch.com', '6688358874', 'zTxQRf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jcanadaqt@google.cn', '9764480673', '7jGh1vvu');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chessentalerqu@wikipedia.org', '6754610923', 'szODDVRwd');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ahaggartyqv@i2i.jp', '3869754596', '63EuNCqZZO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('pgotthardsfqw@uiuc.edu', '4264172537', 'zdCTnYx7jD');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rmalamoreqx@bloglines.com', '1914765239', 'XXcaSNcmO');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('rchildrenqy@va.gov', '1577944086', 'gStm7pSku2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dbescobyqz@fotki.com', '1266250201', 'BQa4t2');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('chufferr0@mac.com', '3949967244', '2yEb7C');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kfelgater1@4shared.com', '9825868637', 'wTZ1Q3v');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('inormaviller2@dailymail.co.uk', '1325235348', 'LtjACAzRNint');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('geneferr3@goo.gl', '8643942927', 'Yt6gCXU');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('fwhacketr4@illinois.edu', '8459667725', 'C7qeQcZ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('breidier5@alibaba.com', '9558977557', 'qZdcWq0');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mwoolamr6@forbes.com', '7887814636', 'dNMEYDQ');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('kshoweringr7@nature.com', '7348476783', 'NrxMjrJ1');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lgoader8@economist.com', '7172851972', 'TlzDtZ7GCf');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bjollier9@angelfire.com', '6672031523', 'RkzycI6s7');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jyablsleyra@51.la', '2719032727', 'UihMJ1ZC8F');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('elightowlerrb@accuweather.com', '1789720477', 'MPaYe3A9');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mfrounksrc@google.it', '5163966006', 'LpJ6lA');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('mnapthinerd@europa.eu', '6312928266', 'sglZ6FnQM9X');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('bstoterre@tamu.edu', '3028339935', 'wcWMUGXMK');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dwhaymandrf@wikia.com', '2031396286', 'iNUlLVRKcT3');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jdolbyrg@hubpages.com', '2436473356', 'h9KuXs');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('aalvesrh@google.pl', '8244501879', 'YPduKH5o35');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cwaszczykowskiri@freewebs.com', '9773983180', 'ki9B1ptNI6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('jscoonerj@rakuten.co.jp', '1112443781', '0n203qUdVH');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('cfoxrk@opera.com', '9942880215', '4YzyuM8mp57j');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dmcclenaghanrl@sina.com.cn', '9627198637', 'lLpuE4XP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('joakenfieldrm@theglobeandmail.com', '2125846415', 'KQvTlj');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('ctavernorrn@4shared.com', '8431875425', '7hqt3RYW6');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('gvasilischevro@google.ru', '9758941335', 'q97I02');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('wcurtissrp@google.de', '6636416694', 'oOIK6tP');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('lmckellarrq@mozilla.com', '4498981818', 'SKBtvC');
insert into Customer (Customer_Email, Customer_Phone, Customer_Password) values ('dedwardsrr@vimeo.com', '2742557075', 'BUmS8vc');

insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1, 'Jose Doyle', 0, '6/9/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2, 'Dusty Allsep', 0, '6/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (3, 'Budd McGiffie', 1, '9/7/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (4, 'Kalindi Hamblin', 0, '2/12/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (5, 'Ingar Glusby', 1, '7/14/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (6, 'Tania Fardy', 0, '7/10/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (7, 'Krystalle Frensche', 0, '10/26/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (8, 'Korie Simpkiss', 1, '6/2/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (9, 'Belinda Ferreli', 0, '11/4/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (10, 'Anjela Hugues', 0, '6/26/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (11, 'Emelda Clubley', 0, '7/7/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (12, 'Evelyn Brett', 1, '4/18/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (13, 'Neely Love', 0, '12/9/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (14, 'Cherice Hort', 0, '7/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (15, 'Gayle Castella', 1, '12/24/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (16, 'Betteann Ennor', 0, '3/2/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (17, 'Mohammed Greening', 0, '9/18/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (18, 'Justis Tunbridge', 0, '5/31/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (19, 'Isidora Trobridge', 1, '1/1/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (20, 'Stewart Vedikhov', 1, '8/8/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (21, 'Cristionna Blunsen', 1, '11/20/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (22, 'Adriena Whebell', 1, '2/16/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (23, 'Alia Vaadeland', 0, '5/26/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (24, 'Karl Kopf', 0, '10/22/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (25, 'Imogen Dowey', 1, '12/18/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (26, 'Ronna Beaconsall', 1, '7/6/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (27, 'Lavina Axworthy', 0, '5/29/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (28, 'Lane Pinn', 0, '7/7/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (29, 'Selie Overstone', 0, '2/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (30, 'Madel Neasham', 1, '9/18/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (31, 'Noelle Esley', 0, '6/16/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (32, 'Jermayne Eckersley', 0, '8/13/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (33, 'Lewes Daice', 0, '10/22/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (34, 'Marcia Woodstock', 0, '4/13/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (35, 'Claudia Bakeup', 0, '9/10/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (36, 'Dud Marham', 1, '7/16/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (37, 'Brana Mangan', 1, '2/8/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (38, 'Jamaal Sanpher', 1, '1/13/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (39, 'Gunilla Caddell', 1, '10/13/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (40, 'Amalie McCarter', 1, '2/27/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (41, 'Aeriell Seabourne', 1, '2/28/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (42, 'Audrey Taveriner', 1, '11/27/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (43, 'Kalvin Westgarth', 1, '8/11/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (44, 'Jehu Bengough', 0, '8/16/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (45, 'Elfie Raddenbury', 0, '9/25/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (46, 'Mikey Kearford', 0, '10/15/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (47, 'Ginger Orrell', 1, '1/16/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (48, 'Nara Langthorne', 1, '2/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (49, 'Paolina Gaisford', 0, '11/6/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (50, 'Hyacintha Crock', 1, '3/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (51, 'Allistir Guildford', 1, '10/11/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (52, 'Becky Pratte', 0, '2/22/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (53, 'Lou Huckleby', 1, '10/1/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (54, 'Cleo Bielfeld', 1, '2/16/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (55, 'Tracey Scholes', 1, '8/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (56, 'Idaline Amberson', 1, '8/10/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (57, 'Josselyn Coulthard', 0, '3/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (58, 'Aline De Robertis', 1, '6/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (59, 'Chancey Twelve', 0, '4/28/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (60, 'Pepillo Joul', 0, '8/27/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (61, 'Cymbre Hinz', 1, '12/19/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (62, 'Holly-anne McVaugh', 1, '8/8/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (63, 'Danette Partington', 1, '11/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (64, 'Laughton Litzmann', 0, '11/29/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (65, 'Bernardina Saxelby', 0, '1/25/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (66, 'Bette Bunnell', 1, '5/18/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (67, 'Ramona Winley', 0, '3/1/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (68, 'Anny Christofides', 0, '8/24/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (69, 'Kris Brun', 1, '5/27/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (70, 'Helene Rickersy', 1, '6/14/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (71, 'Booth Crockatt', 1, '6/13/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (72, 'Francois Hallatt', 1, '10/21/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (73, 'Sybilla Mannagh', 0, '3/31/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (74, 'Maribeth Manion', 1, '6/7/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (75, 'Allyce Stonebridge', 0, '7/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (76, 'Meredith Baldocci', 1, '3/15/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (77, 'Bernadette Iliffe', 0, '9/29/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (78, 'Salvidor Adan', 1, '8/6/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (79, 'Eleonora Crimes', 1, '4/9/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (80, 'Lanna Stripling', 0, '1/28/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (81, 'Lorine Wetherburn', 0, '8/20/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (82, 'Conn Beadon', 0, '12/1/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (83, 'Fonz Yexley', 1, '3/13/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (84, 'Joyce Dilliston', 1, '9/20/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (85, 'Karolina Gobell', 1, '6/27/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (86, 'Tobias Pecey', 1, '11/2/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (87, 'Cymbre Dunthorne', 1, '4/28/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (88, 'Marla De Simoni', 0, '6/4/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (89, 'Stanfield Albury', 1, '2/16/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (90, 'Graeme Karpets', 0, '8/15/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (91, 'Jud Stutard', 0, '3/25/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (92, 'Dorena Baines', 0, '4/1/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (93, 'Letta Stamps', 1, '11/11/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (94, 'Bree Magarrell', 0, '12/5/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (95, 'April Babalola', 1, '11/10/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (96, 'Quinton Ends', 1, '1/21/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (97, 'Kinnie MacFadden', 1, '3/19/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (98, 'Dalila Elijahu', 1, '5/29/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (99, 'Lissi Euplate', 0, '2/18/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (100, 'Elsa Parham', 0, '7/11/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (101, 'Clive Howlett', 1, '8/16/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (102, 'Emmanuel Yosselevitch', 1, '2/13/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (103, 'Jacklin Verrechia', 1, '11/15/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (104, 'Aridatha Skyppe', 1, '10/25/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (105, 'Bobby Knibley', 0, '8/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (106, 'Keene Lobe', 0, '7/30/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (107, 'Austen Matashkin', 0, '6/28/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (108, 'Jo Slatford', 0, '7/5/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (109, 'Lily Akister', 0, '6/6/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (110, 'Bailey Clemo', 1, '10/28/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (111, 'Gerladina Balderston', 0, '6/9/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (112, 'Phip Annell', 0, '3/25/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (113, 'Dorree Mullarkey', 1, '9/8/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (114, 'Rodi Branchet', 0, '11/24/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (115, 'Chancey Heeran', 0, '1/25/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (116, 'Cornie Eggleston', 1, '10/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (117, 'Gerrard Potteril', 1, '4/6/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (118, 'Brody Lack', 0, '5/25/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (119, 'Holly-anne Benettini', 0, '9/5/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (120, 'Sheryl Pietzker', 1, '12/17/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (121, 'Berty Tasker', 0, '11/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (122, 'Tommy Gaffney', 1, '12/27/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (123, 'Pavel Schonfelder', 0, '5/24/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (124, 'Curran MacAindreis', 1, '12/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (125, 'Francyne Nye', 1, '8/28/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (126, 'Ugo Yeomans', 0, '9/15/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (127, 'Golda Alexandersen', 0, '10/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (128, 'Amye Klainman', 1, '8/18/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (129, 'Bobette Paterson', 0, '1/7/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (130, 'Quill Fusco', 0, '3/22/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (131, 'Richie McKerrow', 1, '2/12/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (132, 'Rozella Maggiore', 1, '11/25/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (133, 'Garek Heindl', 1, '7/21/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (134, 'Denney Palatino', 0, '2/24/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (135, 'Nollie Gresley', 1, '8/5/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (136, 'Brittan Enever', 0, '6/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (137, 'Ike De Launde', 1, '7/9/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (138, 'Garvy Stebles', 0, '4/1/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (139, 'Kaine Chetwynd', 1, '11/21/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (140, 'Lelia Adamkiewicz', 1, '7/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (141, 'Julietta MacGiolla Pheadair', 1, '3/23/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (142, 'Tim Rexworthy', 0, '2/5/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (143, 'Roy Reinhart', 1, '7/29/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (144, 'Ali Buard', 1, '7/30/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (145, 'Morganne Arkwright', 1, '12/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (146, 'Caria Diviney', 1, '2/11/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (147, 'Elyssa Mc Gaughey', 0, '11/17/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (148, 'Abbey Sudlow', 1, '2/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (149, 'Deanna Mochan', 0, '11/28/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (150, 'Sarine Rasch', 1, '3/2/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (151, 'Ebeneser McGooch', 0, '5/26/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (152, 'Nicoli Braganca', 0, '4/30/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (153, 'Hortensia Jagels', 0, '1/26/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (154, 'Solomon Abbey', 1, '10/25/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (155, 'Elroy Adamik', 0, '1/3/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (156, 'Gonzalo Shorthouse', 1, '2/13/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (157, 'Chrystal MacMoyer', 0, '4/21/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (158, 'Opal Dudman', 0, '7/28/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (159, 'Laurie Howroyd', 1, '1/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (160, 'Jojo Randalston', 1, '3/24/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (161, 'Kelley Dyott', 0, '12/4/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (162, 'Bobinette Knowles', 0, '6/29/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (163, 'Heddie Armstead', 1, '1/9/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (164, 'Shepherd Bowhey', 0, '6/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (165, 'Tim Wartonby', 0, '4/23/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (166, 'Jacquelin Stentiford', 0, '6/26/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (167, 'Maxwell Meacher', 0, '9/16/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (168, 'Darsey Cogan', 0, '5/2/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (169, 'Simonette Esilmon', 0, '6/9/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (170, 'Cleon Heller', 0, '12/29/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (171, 'Daniela Bosworth', 0, '8/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (172, 'Kendra Anderson', 0, '3/17/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (173, 'Sibby Daffern', 0, '7/27/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (174, 'Jocelyn Buckland', 1, '7/15/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (175, 'Cherianne Charnley', 1, '11/24/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (176, 'Myles Havoc', 0, '10/1/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (177, 'Dyana Fromont', 1, '9/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (178, 'Noemi Rubie', 0, '1/13/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (179, 'Elana Berriball', 1, '7/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (180, 'Brod Filkov', 0, '4/24/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (181, 'Guinna Krook', 0, '5/8/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (182, 'Sigvard Bilofsky', 1, '3/7/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (183, 'Hebert Dummigan', 1, '10/27/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (184, 'Thornie Meecher', 1, '2/26/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (185, 'Harlen Bartolomeu', 1, '5/20/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (186, 'Walliw Tett', 0, '5/10/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (187, 'Morgun Dunk', 0, '1/4/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (188, 'Hilly Skypp', 0, '1/24/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (189, 'Alejandrina Brinkler', 0, '9/4/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (190, 'Waiter Letham', 1, '11/17/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (191, 'Maryanne Tomsu', 1, '4/2/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (192, 'Prent Kivlehan', 1, '11/6/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (193, 'Erina Padden', 0, '9/2/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (194, 'Sutton Ramirez', 0, '7/22/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (195, 'Moore Extence', 1, '3/29/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (196, 'Town Barden', 1, '8/17/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (197, 'Kelley Itzkovwitch', 1, '4/15/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (198, 'Katerina Shimoni', 0, '12/10/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (199, 'Kristen Norgate', 1, '8/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (200, 'Thibaud Hews', 0, '8/1/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (201, 'Leola Josilowski', 0, '10/11/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (202, 'Marsh Jerrams', 0, '3/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (203, 'Mara Suttie', 1, '11/20/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (204, 'Lane Egleton', 0, '5/18/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (205, 'Natale Eldin', 0, '1/26/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (206, 'Ysabel Pidgin', 0, '9/21/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (207, 'Fleur Emmatt', 1, '5/2/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (208, 'Tabbie Bruckshaw', 1, '1/7/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (209, 'Cleo Martinon', 0, '6/20/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (210, 'Itch Dearness', 0, '3/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (211, 'Matti O''Hara', 0, '6/24/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (212, 'Jacklyn Tosney', 1, '5/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (213, 'Erena Hesse', 0, '5/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (214, 'Brantley Pays', 1, '2/14/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (215, 'Laurella Whellans', 0, '6/30/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (216, 'Joel Zelake', 0, '12/19/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (217, 'Else Allcorn', 0, '8/12/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (218, 'Brad Curton', 1, '7/13/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (219, 'Xavier Hearley', 0, '2/7/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (220, 'Rasla Rhyme', 0, '10/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (221, 'Raven Abdey', 0, '10/11/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (222, 'Amity Moulin', 0, '11/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (223, 'Cordie Rubega', 1, '11/13/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (224, 'Les Rought', 1, '11/4/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (225, 'Amalea Ortler', 0, '8/12/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (226, 'Ondrea Swainson', 0, '5/20/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (227, 'Joete Cometti', 0, '2/7/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (228, 'Wood Doolan', 0, '8/29/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (229, 'Gerard Upham', 0, '12/9/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (230, 'Dell Langrish', 0, '6/18/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (231, 'Isacco Kezor', 1, '4/16/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (232, 'Gallagher Mooney', 0, '10/22/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (233, 'Marigold Bilam', 1, '7/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (234, 'Connie Rigglesford', 0, '8/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (235, 'Giraud Stag', 1, '6/28/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (236, 'Danice Arnau', 0, '3/5/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (237, 'Sollie Powton', 1, '12/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (238, 'Odetta Heinle', 1, '10/30/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (239, 'Valeda Ingliss', 0, '2/10/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (240, 'Ugo Huxster', 0, '11/30/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (241, 'Alain Ladyman', 0, '8/6/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (242, 'Saree Rush', 1, '1/12/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (243, 'Lucas Heffy', 0, '5/7/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (244, 'Ruddy Dungee', 0, '5/23/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (245, 'Correy Pfeiffer', 0, '12/18/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (246, 'Jami Sheddan', 1, '1/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (247, 'Antonius Cassy', 0, '4/17/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (248, 'Ronnie Ruffli', 0, '10/13/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (249, 'Lorne O''Carmody', 0, '6/12/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (250, 'Deva Riccioppo', 1, '12/19/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (251, 'Gerta Lockier', 0, '8/7/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (252, 'Waldon Lehrian', 0, '4/11/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (253, 'Loralie Kilmurry', 1, '6/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (254, 'Ange Fullard', 1, '6/10/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (255, 'Debora Seville', 0, '9/16/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (256, 'Jessa Szantho', 1, '1/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (257, 'Celie Yurlov', 1, '5/14/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (258, 'Clemente Ianno', 1, '4/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (259, 'Tamara Ziehms', 0, '4/14/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (260, 'Diego Witling', 1, '4/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (261, 'Giovanni Bridgnell', 0, '11/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (262, 'Val Philott', 1, '12/4/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (263, 'Dionne Secret', 0, '8/3/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (264, 'Juditha Moffet', 1, '12/25/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (265, 'Gates Riseley', 1, '2/18/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (266, 'Maighdiln Piggens', 1, '3/4/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (267, 'Emilia Kinig', 1, '11/10/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (268, 'Talbot Della Scala', 0, '1/21/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (269, 'Venus Wyke', 1, '9/30/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (270, 'Marwin York', 1, '10/2/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (271, 'Josiah Jervoise', 0, '2/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (272, 'Lanni Claremont', 0, '4/18/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (273, 'Hernando Trotter', 0, '6/2/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (274, 'Hannis Strute', 1, '1/28/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (275, 'Darby Dyers', 1, '2/26/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (276, 'Fanechka Goulthorp', 0, '1/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (277, 'Alic Ilyin', 0, '10/18/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (278, 'Glori Betham', 1, '2/12/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (279, 'Nertie Aries', 0, '6/14/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (280, 'Geoffry Mackelworth', 0, '3/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (281, 'Aigneis Saltsberg', 0, '6/21/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (282, 'Noami Peotz', 1, '9/15/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (283, 'Othelia Bertelet', 1, '8/12/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (284, 'Sidonnie Trayling', 0, '8/4/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (285, 'Rudyard Mowles', 1, '7/2/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (286, 'Cornell Ridgwell', 1, '7/6/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (287, 'Evie Mongeot', 1, '7/25/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (288, 'Karleen Edmett', 1, '8/30/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (289, 'Drusi Glozman', 0, '3/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (290, 'Clarinda Allmen', 1, '9/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (291, 'Hakeem Follacaro', 1, '9/27/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (292, 'Clifford Keems', 0, '3/1/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (293, 'Skipton Kaaskooper', 1, '1/4/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (294, 'Currie Straun', 0, '5/8/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (295, 'Leoline Pfeffer', 0, '3/11/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (296, 'Tamarah Klossmann', 1, '6/3/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (297, 'Breanne Ibel', 1, '5/19/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (298, 'Brooks Doak', 0, '9/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (299, 'Kandy Habbema', 1, '3/1/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (300, 'Jacquelin McGuigan', 1, '7/13/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (301, 'Upton Marke', 0, '4/7/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (302, 'Raychel Weblin', 1, '3/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (303, 'Artur Yourell', 1, '9/16/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (304, 'Ev Acedo', 0, '6/13/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (305, 'Montgomery Schnieder', 1, '10/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (306, 'Amalea Antonchik', 0, '11/19/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (307, 'Jeralee Greeves', 1, '8/19/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (308, 'Olenolin Restill', 0, '11/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (309, 'Paige Rauprich', 0, '12/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (310, 'Aime Tincey', 0, '5/31/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (311, 'Gwenore Purton', 0, '3/21/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (312, 'Lolly Lemmanbie', 0, '5/25/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (313, 'Cash Dionis', 1, '3/16/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (314, 'Josephine Frearson', 1, '1/1/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (315, 'Amalea Wanklyn', 0, '2/4/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (316, 'Gabriello Loines', 1, '4/22/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (317, 'Heath Stych', 0, '1/19/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (318, 'Vitia Klousner', 1, '1/10/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (319, 'Phoebe Seemmonds', 0, '12/10/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (320, 'Yetty Eggle', 1, '12/15/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (321, 'Valina Stowte', 1, '6/5/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (322, 'Gage Sime', 1, '11/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (323, 'Melesa Whytock', 1, '8/11/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (324, 'Rivi Whenham', 1, '12/19/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (325, 'Emmie Scranny', 0, '11/15/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (326, 'Langsdon Lawerence', 0, '7/3/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (327, 'Foster Currm', 0, '11/4/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (328, 'Raine Clewer', 0, '5/21/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (329, 'Dorey Akram', 1, '9/10/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (330, 'Sascha Sweeten', 1, '1/19/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (331, 'Alberto Plumb', 1, '12/28/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (332, 'Dusty Hendrichs', 0, '9/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (333, 'Barr Husher', 1, '7/30/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (334, 'Natal Hosier', 0, '10/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (335, 'Magdalen Curl', 0, '9/26/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (336, 'Velma Golagley', 1, '7/5/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (337, 'Melodee Cicutto', 1, '9/8/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (338, 'Starlin Clint', 1, '8/28/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (339, 'Edwina Phant', 1, '4/18/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (340, 'Charmion Lombardo', 1, '4/24/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (341, 'Dulsea Paty', 0, '1/24/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (342, 'Tammy Olifaunt', 0, '11/4/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (343, 'Berri Onthank', 0, '5/11/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (344, 'Emmalynne Annice', 0, '9/29/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (345, 'Stearn Shemming', 1, '3/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (346, 'Gordon Gever', 0, '10/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (347, 'Gay Cordoba', 0, '6/21/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (348, 'Ninnette Hitzmann', 1, '9/13/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (349, 'Spence Riggs', 1, '10/24/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (350, 'Carney Halversen', 0, '2/20/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (351, 'Rutherford Ulyet', 1, '8/5/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (352, 'Scot Puncher', 1, '2/8/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (353, 'Aldwin Welband', 0, '9/13/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (354, 'Leonidas Jurgenson', 1, '8/15/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (355, 'Noellyn Helin', 1, '10/2/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (356, 'Filmore Hendren', 1, '11/27/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (357, 'Georgi Haddrell', 1, '6/26/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (358, 'Petronia Bothe', 1, '4/1/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (359, 'Daisey Patshull', 0, '10/30/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (360, 'Libbi Vittet', 0, '8/8/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (361, 'Sharity Dries', 1, '2/26/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (362, 'Lanae Gerg', 1, '7/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (363, 'Bekki Gerold', 1, '12/27/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (364, 'Codie Cuer', 1, '1/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (365, 'Myrvyn MacArthur', 0, '3/9/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (366, 'Chauncey Shortell', 1, '5/9/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (367, 'Pietra Dionisii', 1, '11/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (368, 'Brita Dibben', 1, '4/15/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (369, 'Nana Perrins', 1, '8/12/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (370, 'Electra Dunmore', 0, '5/19/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (371, 'Monika Nanninini', 0, '9/2/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (372, 'Rufus Korb', 1, '3/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (373, 'Avrit Smalls', 0, '1/18/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (374, 'Raina Hartlebury', 0, '2/22/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (375, 'Garold Flori', 0, '1/23/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (376, 'Elbert Jagiela', 0, '1/31/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (377, 'Nickolas Debling', 1, '10/9/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (378, 'Addie Romayne', 1, '8/21/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (379, 'Weylin Sapena', 0, '1/9/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (380, 'Douglass Blaksley', 0, '9/25/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (381, 'Flint Felmingham', 1, '9/4/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (382, 'Batholomew Darnbrook', 1, '4/7/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (383, 'Althea Burstow', 0, '4/1/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (384, 'Marje Croom', 0, '5/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (385, 'Ellerey Rawles', 1, '7/30/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (386, 'Barry Santora', 1, '5/6/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (387, 'Sydelle Mochar', 0, '8/15/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (388, 'Ruthy Lafee', 0, '12/17/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (389, 'Judie Meysham', 0, '5/22/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (390, 'Selene Stobie', 0, '9/28/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (391, 'Andres Hatchette', 1, '8/4/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (392, 'Saxe Brougham', 1, '8/11/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (393, 'Darelle Jeves', 1, '4/2/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (394, 'Marcie Offill', 1, '7/18/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (395, 'Jedidiah Maken', 0, '2/17/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (396, 'Murray Lowcock', 1, '3/23/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (397, 'Janot Crome', 1, '7/25/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (398, 'Stephannie Kiddie', 0, '4/9/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (399, 'Jacinda Wyse', 0, '12/21/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (400, 'Arabella De Freitas', 0, '3/17/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (401, 'Ira Gronowe', 0, '4/8/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (402, 'Aloin Duffyn', 1, '10/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (403, 'Lorri Jerrans', 0, '9/3/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (404, 'Jane Shannahan', 0, '6/17/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (405, 'Dickie Culy', 0, '9/20/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (406, 'Erica Force', 1, '8/15/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (407, 'Charlotta Lissandrini', 0, '11/6/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (408, 'Lynelle Ertelt', 1, '10/2/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (409, 'Reece Creese', 0, '1/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (410, 'Chip Harcase', 1, '12/17/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (411, 'Michaela Veryan', 1, '1/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (412, 'Ardine Hofner', 1, '6/4/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (413, 'Clerissa Russi', 0, '10/6/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (414, 'Daveen Bindin', 1, '9/7/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (415, 'Jeramey Lippiello', 0, '9/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (416, 'Lew Stansbury', 0, '2/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (417, 'Bjorn Falco', 1, '4/13/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (418, 'Shell Guerola', 1, '8/17/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (419, 'Wade Scuffham', 0, '7/6/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (420, 'Catherin Cordero', 1, '3/26/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (421, 'Wilfred Sirmond', 1, '7/28/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (422, 'Neel Buckthorpe', 1, '6/19/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (423, 'Lorry Trotman', 1, '12/14/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (424, 'Alane Courteney', 1, '11/11/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (425, 'Gerard Eade', 1, '9/15/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (426, 'Maury Ferre', 1, '12/27/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (427, 'Elsy Edgehill', 1, '11/26/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (428, 'Fanny Sapshed', 0, '7/4/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (429, 'Gloriane Gobel', 1, '10/10/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (430, 'Darnall Fellman', 1, '7/23/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (431, 'Kaitlin Mulrenan', 1, '10/20/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (432, 'Norbie Wilmott', 0, '11/6/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (433, 'Maximilianus O''Shee', 1, '2/2/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (434, 'Aggi Davidy', 1, '12/7/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (435, 'Carmita Enriques', 1, '6/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (436, 'Ange Confait', 1, '11/28/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (437, 'Mead Towsie', 1, '8/12/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (438, 'Betty Queenborough', 1, '10/15/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (439, 'Brew Croke', 1, '4/2/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (440, 'Philippine Mattsson', 0, '3/11/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (441, 'Renault Riggoll', 1, '6/14/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (442, 'Hubey Tregonna', 0, '3/1/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (443, 'Debi Rivett', 0, '5/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (444, 'Aubert Escoffier', 1, '10/28/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (445, 'Celina Billam', 1, '7/14/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (446, 'Zared Sherwill', 0, '6/4/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (447, 'Markos Skermer', 0, '1/29/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (448, 'Frasier Benyon', 0, '10/12/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (449, 'Lukas McWhorter', 0, '12/22/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (450, 'Lise Baitson', 1, '10/25/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (451, 'Morey Lightollers', 0, '4/27/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (452, 'Alys Seligson', 0, '9/1/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (453, 'Travers Brolly', 0, '9/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (454, 'Ophelia Buxsey', 1, '8/24/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (455, 'Lucy Zecchinii', 0, '6/9/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (456, 'Miguela Pearsall', 1, '2/6/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (457, 'Gasparo Gonnel', 1, '10/12/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (458, 'Wyatt Secrett', 1, '9/17/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (459, 'Cobby Undrill', 1, '9/2/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (460, 'Zulema Gould', 0, '12/3/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (461, 'Benedick Dawidowitsch', 0, '8/17/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (462, 'Penelopa Douberday', 0, '10/25/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (463, 'Caryn Chaize', 1, '1/12/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (464, 'Mirabella Clerke', 0, '9/21/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (465, 'Bonnibelle Pierucci', 1, '7/18/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (466, 'Aurthur Grealish', 0, '6/14/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (467, 'Keary Repp', 0, '3/24/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (468, 'Coral Bromidge', 0, '7/30/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (469, 'Hobie Jersch', 1, '7/2/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (470, 'Grethel Tasseler', 0, '4/3/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (471, 'Natassia Werrit', 1, '12/16/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (472, 'Fredrick Crowcher', 1, '6/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (473, 'Drona Wiggett', 1, '7/5/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (474, 'Alena Fagge', 0, '8/30/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (475, 'Petronilla Raeside', 1, '7/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (476, 'Jacki Moorfield', 0, '12/2/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (477, 'Codi Goulthorp', 1, '10/2/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (478, 'Phaedra Pearmine', 0, '11/20/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (479, 'Ninette Burn', 0, '9/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (480, 'Noble Pieroni', 1, '5/5/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (481, 'Haleigh Jodlkowski', 0, '7/11/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (482, 'Catherine Evert', 0, '1/5/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (483, 'Bondie Pickett', 1, '12/19/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (484, 'Devin Newbigging', 0, '8/14/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (485, 'Raine Chillingsworth', 0, '4/17/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (486, 'Debbie Bruhn', 0, '5/28/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (487, 'Julie Gabbitus', 0, '4/13/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (488, 'Alva Mc-Kerley', 0, '1/5/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (489, 'Emily Petchell', 0, '6/14/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (490, 'Balduin Vamplus', 0, '8/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (491, 'Fredrick Worge', 0, '12/2/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (492, 'Sylvan Blankhorn', 1, '8/31/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (493, 'Sara-ann Conboy', 1, '2/13/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (494, 'Courtenay Whitehurst', 1, '12/6/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (495, 'Page Wigg', 1, '6/30/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (496, 'Amberly Screech', 0, '8/12/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (497, 'Rhodia Beringer', 1, '8/21/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (498, 'Evanne Ferrarini', 1, '8/7/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (499, 'Cicily Gillbey', 1, '12/11/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (500, 'Wanids Wharmby', 1, '12/13/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (501, 'Arturo Fredson', 0, '1/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (502, 'Grazia Mainstone', 1, '5/1/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (503, 'Buck Ribbens', 0, '8/2/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (504, 'Pietro Marion', 1, '11/17/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (505, 'Fairfax Trippack', 0, '1/7/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (506, 'Ashlee Robrow', 1, '9/18/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (507, 'Gare Jenkyn', 1, '5/25/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (508, 'Borden Stiebler', 1, '3/23/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (509, 'Carlo Walding', 0, '9/29/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (510, 'Clyve Grimes', 0, '1/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (511, 'Ki Clac', 0, '12/27/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (512, 'Ruttger Cornewall', 1, '5/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (513, 'Tawnya Biddlecombe', 0, '6/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (514, 'Gordon Ezzle', 0, '8/28/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (515, 'Stacey Tyndall', 0, '8/13/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (516, 'Elizabet Windley', 0, '4/9/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (517, 'Hymie Yurkov', 0, '1/31/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (518, 'Doralynne Teasdale-Markie', 1, '10/10/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (519, 'Rockie MacKettrick', 0, '7/21/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (520, 'Cristy Jenicek', 1, '2/1/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (521, 'Minnie Kennan', 1, '5/11/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (522, 'Blondelle Edghinn', 1, '9/19/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (523, 'Eduino Hindenberger', 0, '8/30/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (524, 'Shannen Lamerton', 1, '10/8/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (525, 'Ashil Kimbrough', 1, '9/9/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (526, 'Berni Svanetti', 1, '6/7/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (527, 'Nonna Forsard', 1, '5/27/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (528, 'Francoise Cecere', 0, '5/1/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (529, 'Norbert Keeves', 0, '5/12/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (530, 'Chiarra Rickasse', 0, '6/6/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (531, 'Tatiana Lewty', 0, '1/29/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (532, 'Eal Happel', 1, '7/17/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (533, 'Ario Alexsandrev', 1, '7/5/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (534, 'Ernest Negro', 0, '8/2/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (535, 'Ronnie Fells', 1, '10/6/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (536, 'Prisca Rivenzon', 1, '12/16/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (537, 'Angelina Bennie', 0, '1/13/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (538, 'Krissy Greser', 1, '11/12/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (539, 'Torin Boshere', 1, '10/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (540, 'Jermaine Brittian', 1, '7/30/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (541, 'Dulce Baison', 1, '4/23/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (542, 'Charlton Nissle', 1, '10/21/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (543, 'Jenelle Dannett', 1, '5/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (544, 'Emmie Ruddom', 0, '9/18/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (545, 'Marietta Wetherell', 0, '7/17/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (546, 'Jaymie Potapczuk', 0, '7/1/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (547, 'Melessa Plaice', 0, '1/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (548, 'Ariel Vanderson', 0, '9/21/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (549, 'Gaylord Aldham', 0, '6/24/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (550, 'Elnore Boland', 1, '1/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (551, 'Aylmar Blazeby', 0, '6/25/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (552, 'Alecia Minto', 1, '10/23/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (553, 'Charlton Conahy', 0, '6/29/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (554, 'Penelopa Sawford', 1, '8/23/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (555, 'Dallon Denge', 1, '12/18/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (556, 'Bernadine Berecloth', 0, '4/3/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (557, 'Flora Witton', 0, '9/3/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (558, 'Savina Bloxland', 0, '11/9/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (559, 'Marie Greim', 1, '10/14/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (560, 'Clem Guarnier', 0, '12/8/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (561, 'Dianne Mattschas', 0, '8/27/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (562, 'Kelley Crisford', 1, '2/1/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (563, 'Jyoti MacVay', 0, '11/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (564, 'Barbe Grief', 1, '3/30/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (565, 'Xenos Mushet', 0, '8/1/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (566, 'Anabelle Goatman', 0, '9/9/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (567, 'Wallie O''Dennehy', 1, '3/8/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (568, 'Martha Maywood', 0, '4/8/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (569, 'Terrance Blazevic', 1, '11/20/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (570, 'Seamus Beadel', 1, '2/16/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (571, 'Ailee Briar', 0, '4/15/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (572, 'Kingston Stitson', 1, '10/14/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (573, 'Cornelia Whiteland', 1, '10/14/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (574, 'Mikey O''Fallowne', 1, '10/10/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (575, 'Jacqueline Powlesland', 0, '8/27/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (576, 'Justin Westgate', 1, '5/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (577, 'Faith Albarez', 1, '5/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (578, 'Jamal Fuster', 1, '6/1/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (579, 'Hewitt Dominik', 0, '6/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (580, 'Enrichetta Crathern', 1, '9/23/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (581, 'Anatol Iacovaccio', 1, '7/12/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (582, 'Keenan Dumbreck', 0, '3/1/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (583, 'Morgen Trahair', 0, '4/6/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (584, 'Sydelle Scowcroft', 0, '6/17/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (585, 'Liuka Iddy', 1, '1/12/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (586, 'Mallory McNamara', 0, '6/27/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (587, 'Staci Cray', 1, '1/9/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (588, 'Zed Smetoun', 1, '8/23/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (589, 'Shena de Grey', 0, '10/1/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (590, 'Electra Krop', 0, '5/24/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (591, 'Theo Roston', 1, '9/8/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (592, 'Dwayne Evanson', 0, '5/23/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (593, 'Rebekah Serrier', 0, '8/7/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (594, 'Adolf Hardwick', 1, '8/22/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (595, 'Bay Streeton', 0, '1/2/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (596, 'Munmro Narraway', 0, '7/1/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (597, 'Leonid Keeting', 1, '10/11/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (598, 'Lianne Cowndley', 1, '7/6/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (599, 'Barthel Cunnington', 0, '8/20/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (600, 'Vern Behagg', 1, '4/4/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (601, 'Avery Cockayne', 0, '10/11/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (602, 'Hamish Sigsworth', 1, '8/12/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (603, 'Callida Saltern', 0, '10/31/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (604, 'Leona Dudmarsh', 0, '11/29/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (605, 'Alleen Ivkovic', 0, '12/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (606, 'Melinda Skelly', 0, '1/2/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (607, 'Antonella Smallpeice', 1, '9/16/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (608, 'Sid Manifold', 0, '12/12/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (609, 'Shauna Emmens', 0, '1/8/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (610, 'Johannah Gordge', 0, '6/4/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (611, 'Bertrand Walters', 0, '3/7/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (612, 'Dani Bamsey', 0, '10/16/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (613, 'Teddie Romera', 1, '11/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (614, 'Austina Melpuss', 1, '10/11/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (615, 'Gonzales Jelly', 0, '9/2/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (616, 'Illa Snoddy', 1, '6/19/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (617, 'Nigel Lefwich', 0, '7/28/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (618, 'Huey Kilvington', 0, '12/9/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (619, 'Filberto Faussett', 0, '1/3/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (620, 'Garner Sexon', 1, '8/29/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (621, 'Tiler Dale', 0, '5/26/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (622, 'Halsey Hurst', 1, '12/10/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (623, 'Leila Durrand', 1, '12/3/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (624, 'Editha Wardale', 1, '9/6/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (625, 'Lewiss Ticksall', 1, '3/10/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (626, 'Katharina Fratson', 0, '11/27/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (627, 'Hilliard Hoggan', 0, '3/24/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (628, 'Mommy De Andisie', 1, '8/27/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (629, 'Hillard McVrone', 1, '7/10/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (630, 'Heinrick Brisley', 1, '10/13/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (631, 'Peter Lachaize', 1, '7/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (632, 'Izaak Verny', 1, '7/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (633, 'Adelice Shirer', 0, '8/14/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (634, 'Gusty Etchells', 0, '9/11/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (635, 'Omar Parnell', 0, '5/26/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (636, 'Biddie MacNeilley', 1, '1/5/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (637, 'Feliks Spick', 1, '8/18/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (638, 'Milty Sainthill', 1, '7/9/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (639, 'Cal Vaulkhard', 0, '4/19/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (640, 'Vilma Hush', 0, '9/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (641, 'Brice Brehaut', 1, '6/18/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (642, 'Claudio Rosterne', 0, '1/17/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (643, 'Roscoe Kittel', 1, '7/28/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (644, 'Hugibert Durbin', 1, '3/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (645, 'Silvia L''Hommee', 1, '9/4/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (646, 'Petra Tranmer', 0, '10/21/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (647, 'Daren Siaskowski', 1, '6/4/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (648, 'Kendall Vynall', 0, '2/2/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (649, 'Hilary Rogerot', 1, '7/2/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (650, 'Vassili Waith', 0, '1/11/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (651, 'Anneliese Hazeman', 1, '5/4/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (652, 'Clemmie Janatka', 1, '12/26/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (653, 'Kaile Brum', 1, '8/23/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (654, 'Stillman Deacock', 0, '8/27/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (655, 'Jamie Toderbrugge', 0, '3/19/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (656, 'Calvin Bracci', 0, '4/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (657, 'Masha Tomas', 1, '1/1/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (658, 'Kylie Boom', 0, '9/3/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (659, 'Quinn Rominov', 0, '7/27/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (660, 'Xena Camillo', 1, '5/5/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (661, 'Donnell Alderson', 1, '3/10/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (662, 'Felicdad Wandrack', 0, '7/27/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (663, 'Jud Benyon', 0, '6/30/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (664, 'Dotty Hebron', 1, '4/2/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (665, 'Jinny Defew', 0, '3/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (666, 'Ailee Mennell', 0, '2/13/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (667, 'Glen Marflitt', 1, '12/20/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (668, 'Fields Manssuer', 1, '8/14/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (669, 'Justus Kem', 0, '2/7/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (670, 'Herold Bradman', 0, '6/5/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (671, 'Krissie O''Nowlan', 1, '11/17/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (672, 'Cos Kenyon', 1, '7/12/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (673, 'Melania Signe', 0, '9/4/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (674, 'Goraud La Vigne', 0, '5/28/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (675, 'Maximilien Calvey', 1, '3/4/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (676, 'Tonye Pudsall', 1, '9/5/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (677, 'Caitlin Coltan', 0, '10/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (678, 'Delmer Radenhurst', 1, '4/9/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (679, 'Tammie Pettyfer', 0, '6/15/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (680, 'Florry Hyatt', 1, '12/28/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (681, 'Gare Gitsham', 0, '8/11/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (682, 'Amanda Calley', 0, '3/26/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (683, 'Muffin Chimes', 1, '6/8/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (684, 'Zola Grigsby', 1, '11/12/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (685, 'Marita Eloi', 0, '6/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (686, 'Agnella Paradise', 0, '2/20/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (687, 'Corty Danby', 0, '3/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (688, 'Bourke Beste', 1, '4/12/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (689, 'Aylmar Read', 1, '6/29/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (690, 'Leslie Treppas', 0, '4/13/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (691, 'Laurel Barnham', 1, '7/22/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (692, 'Wakefield Randle', 1, '10/8/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (693, 'Robby Chelsom', 1, '6/5/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (694, 'Ardelia Robichon', 1, '2/24/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (695, 'Maurie Torry', 1, '9/27/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (696, 'Hayley Summerlee', 0, '5/11/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (697, 'Quintina Colville', 0, '3/31/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (698, 'Tull Pentercost', 0, '2/8/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (699, 'Garth Duckerin', 1, '5/29/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (700, 'Evan Misson', 0, '7/16/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (701, 'Silvie Seccombe', 0, '3/19/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (702, 'Brodie Oxborrow', 0, '9/22/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (703, 'Lilllie Lunck', 0, '5/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (704, 'Byrle Bingall', 0, '8/16/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (705, 'Juli McMenamin', 0, '5/22/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (706, 'Darcey Berriball', 0, '3/15/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (707, 'Benjamin Duffy', 1, '11/28/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (708, 'Frasco Gerler', 1, '6/7/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (709, 'Guido Kunkel', 1, '3/2/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (710, 'Arlee Fletcher', 0, '8/12/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (711, 'Melitta Sells', 0, '4/9/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (712, 'Maxie Belcher', 1, '4/22/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (713, 'Frasquito Morcomb', 0, '5/12/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (714, 'Minnnie Hadleigh', 0, '1/27/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (715, 'Sonya Groneway', 1, '10/30/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (716, 'Gisele Rust', 0, '3/18/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (717, 'Robbie Wonham', 0, '9/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (718, 'Rad Liddington', 0, '2/1/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (719, 'Lian Goodby', 1, '12/6/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (720, 'Scarlett Miners', 1, '1/4/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (721, 'Domenico Binks', 1, '2/24/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (722, 'Lindy Beccero', 1, '8/3/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (723, 'Gwynne Howsley', 0, '7/16/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (724, 'Barbie Amorine', 1, '4/12/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (725, 'Mariska Giacobelli', 1, '7/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (726, 'Cora Coyett', 1, '9/27/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (727, 'Chas Balassi', 1, '3/23/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (728, 'Calida Rustich', 1, '5/1/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (729, 'Wendel Gullyes', 0, '10/31/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (730, 'Clement Walles', 0, '4/1/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (731, 'Maire Aston', 0, '3/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (732, 'Ninnetta Ibbeson', 1, '4/15/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (733, 'Alfredo Gini', 0, '8/15/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (734, 'Travus Paeckmeyer', 0, '11/1/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (735, 'Fenelia Mintrim', 0, '2/20/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (736, 'Dew Jurczyk', 1, '11/7/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (737, 'Stafani MacRierie', 0, '6/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (738, 'Khalil Gyde', 1, '5/8/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (739, 'Viole Ferrara', 0, '10/22/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (740, 'Darrelle Pittwood', 1, '10/18/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (741, 'Erminie Brayshaw', 0, '9/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (742, 'Tish Ruckert', 0, '10/4/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (743, 'Ellerey Pool', 1, '11/23/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (744, 'Roxie Perllman', 0, '12/18/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (745, 'Ginger Prise', 1, '11/12/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (746, 'Davy Penritt', 0, '9/6/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (747, 'Ezri Gritland', 0, '12/18/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (748, 'Arnaldo Alaway', 0, '10/26/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (749, 'Zea Godfree', 1, '2/18/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (750, 'Mahmoud Keates', 0, '5/18/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (751, 'Neall Mundee', 1, '4/8/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (752, 'Cathrin McBain', 1, '5/31/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (753, 'Gabi Foux', 0, '6/6/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (754, 'Maryl Bulfield', 1, '3/3/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (755, 'Ruggiero Wasson', 0, '1/11/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (756, 'Ronny Spenclay', 0, '7/27/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (757, 'Dolley Filyaev', 1, '5/29/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (758, 'Trevar Mayston', 1, '8/28/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (759, 'Andriette Nairns', 0, '5/8/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (760, 'Fields Loving', 0, '9/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (761, 'Blair Botcherby', 1, '9/8/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (762, 'Bail Ralphs', 1, '5/3/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (763, 'Sumner Hagley', 1, '3/15/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (764, 'Gladys Pringell', 0, '4/29/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (765, 'Nickolas Purkis', 1, '1/5/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (766, 'Melody Pulham', 0, '5/21/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (767, 'Sumner Zylberdik', 0, '9/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (768, 'Clement Lello', 0, '12/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (769, 'Dori Dykins', 0, '4/29/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (770, 'Mercedes Marguerite', 1, '10/12/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (771, 'Alan MacParlan', 0, '10/28/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (772, 'Torey Sinkings', 0, '2/24/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (773, 'Christie Loghan', 1, '1/19/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (774, 'Harlene Jewise', 0, '11/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (775, 'Nicola Laird', 1, '3/9/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (776, 'Blondy Cona', 0, '6/23/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (777, 'Arri Heatly', 1, '2/26/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (778, 'Willdon Cominotti', 0, '10/31/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (779, 'Porter Leverson', 0, '9/3/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (780, 'Amalia Dennison', 0, '4/2/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (781, 'Kipp Hardie', 1, '12/17/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (782, 'Jackie Blabey', 1, '12/24/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (783, 'Briney Luker', 0, '10/20/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (784, 'Brad Cosyns', 0, '12/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (785, 'Brigham Rosencwaig', 0, '10/6/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (786, 'Odell Wilshire', 1, '10/17/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (787, 'Fraser Clacson', 1, '10/26/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (788, 'Vin Neagle', 0, '1/11/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (789, 'Lynn Yurkiewicz', 0, '5/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (790, 'Frances Carslaw', 0, '2/17/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (791, 'Tamara Badsworth', 1, '7/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (792, 'Aaron Crisp', 0, '4/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (793, 'David McGeraghty', 1, '6/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (794, 'Iain Give', 1, '2/5/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (795, 'Broderick Dowbekin', 1, '11/1/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (796, 'Lay Gherarducci', 1, '5/18/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (797, 'Martina Magnus', 0, '2/1/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (798, 'Emmalynn Gout', 1, '8/1/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (799, 'Karil Cullington', 0, '3/9/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (800, 'Cullan Middis', 0, '12/13/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (801, 'Dannie Garcia', 0, '8/27/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (802, 'Saree Josephov', 0, '9/25/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (803, 'Grayce Chrystie', 1, '4/10/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (804, 'Shaina Pedrollo', 1, '3/19/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (805, 'Brose Dowzell', 1, '6/22/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (806, 'Clement Tooting', 0, '9/29/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (807, 'Ichabod Edgeson', 1, '5/3/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (808, 'Lucinda Caplis', 0, '1/3/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (809, 'Bordy Oattes', 1, '10/14/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (810, 'Jeanelle Harbach', 1, '2/1/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (811, 'Johnnie Grishaev', 0, '12/11/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (812, 'Berton Le Fevre', 0, '9/2/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (813, 'Adriane Propper', 0, '10/21/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (814, 'Almeda Robben', 0, '12/31/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (815, 'Clemmie Minghi', 1, '7/3/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (816, 'Sherri Treneman', 0, '8/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (817, 'Cacilie Mingey', 1, '11/23/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (818, 'Chad Greated', 1, '4/30/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (819, 'Merralee Shivell', 0, '5/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (820, 'Mitchell Flounders', 0, '5/18/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (821, 'Sherri Trustram', 0, '8/30/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (822, 'Karlotte Keesman', 1, '1/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (823, 'Allie Shwalbe', 1, '2/27/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (824, 'Tammie McMychem', 0, '7/23/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (825, 'Wendeline Hartwell', 0, '2/9/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (826, 'Katina Hedgeman', 0, '4/3/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (827, 'Betteann Giacobbo', 1, '2/16/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (828, 'Casandra Severns', 0, '5/22/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (829, 'Cyndy Abrahim', 1, '5/30/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (830, 'Cornelle Goullee', 1, '2/27/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (831, 'Chico Desseine', 0, '4/9/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (832, 'Yale Maas', 0, '5/12/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (833, 'Estell Sapson', 0, '11/10/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (834, 'Sergent Leyden', 0, '1/18/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (835, 'Derrick Waterman', 0, '3/10/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (836, 'Albertina Hawford', 0, '11/25/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (837, 'Shea Spurryer', 0, '12/10/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (838, 'Guenna Feronet', 0, '5/26/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (839, 'Malissa Davydzenko', 0, '10/2/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (840, 'Randa Oakwell', 1, '9/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (841, 'Jannel Janaszkiewicz', 1, '8/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (842, 'Gibbie Hoonahan', 0, '9/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (843, 'Grenville Giacopello', 0, '5/14/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (844, 'Diarmid Forcade', 1, '1/23/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (845, 'Alfonse Matis', 0, '11/2/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (846, 'Tanner Cudbertson', 0, '5/2/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (847, 'Sibelle Joicey', 1, '8/17/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (848, 'Cloris Hinkins', 1, '7/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (849, 'Marcela Pele', 0, '8/21/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (850, 'Morna Metcalf', 0, '5/28/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (851, 'Maggee Edmunds', 0, '5/5/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (852, 'Dominik Shewsmith', 0, '10/27/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (853, 'Frayda Turbat', 1, '2/8/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (854, 'Gweneth Gurden', 1, '6/24/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (855, 'Anne Mathewson', 1, '4/27/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (856, 'Ddene Gasking', 1, '10/8/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (857, 'Bronson Castro', 0, '10/7/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (858, 'Clyve Whaites', 0, '10/25/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (859, 'Erina Noah', 0, '9/14/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (860, 'Rance Addlestone', 1, '4/5/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (861, 'Salem Cumberbatch', 1, '12/30/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (862, 'Tersina Malden', 1, '4/17/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (863, 'Arly Maylam', 0, '12/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (864, 'Brnaba MacGauhy', 1, '7/7/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (865, 'Erminie MacGhee', 1, '7/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (866, 'Coriss Peealess', 1, '8/17/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (867, 'Maddy McKimm', 1, '3/22/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (868, 'Heriberto Bownas', 1, '12/14/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (869, 'Vitia Prinett', 1, '6/25/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (870, 'Lucas Joynson', 1, '1/6/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (871, 'Calley Catling', 0, '7/19/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (872, 'Tobit Sein', 0, '9/11/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (873, 'Perrine Paunsford', 1, '2/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (874, 'Gaynor Woodcroft', 0, '4/21/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (875, 'Saundra Uzzell', 0, '12/18/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (876, 'Celesta Clampton', 0, '11/15/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (877, 'Sarette Stubbeley', 0, '10/16/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (878, 'Jolie Monsey', 1, '11/30/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (879, 'Russell Aers', 0, '10/28/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (880, 'Yvette Sissland', 0, '1/10/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (881, 'Nikos Walding', 1, '1/6/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (882, 'Gayelord Astles', 0, '4/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (883, 'Jasmina Blasli', 1, '5/4/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (884, 'Bertie Fahrenbacher', 0, '11/10/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (885, 'Isobel Gierok', 0, '7/29/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (886, 'Conny Antushev', 0, '5/24/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (887, 'Royal Mathevet', 1, '8/28/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (888, 'Marissa Grassick', 1, '10/16/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (889, 'Constantine Muldrew', 0, '6/24/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (890, 'Brent Beckitt', 1, '8/2/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (891, 'Roderigo Ridgewell', 0, '7/23/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (892, 'Cody Arnaldy', 0, '2/7/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (893, 'Mirabel Goodboddy', 0, '10/29/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (894, 'Michaelina Yakobovitz', 1, '7/18/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (895, 'Enrika Zoane', 1, '12/12/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (896, 'Fritz Elph', 1, '8/3/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (897, 'Josh Eplate', 1, '1/24/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (898, 'Amber Buttrey', 0, '2/8/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (899, 'Maureen Swigg', 1, '3/20/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (900, 'Boot Mac', 0, '8/25/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (901, 'Tyler Giottoi', 1, '6/15/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (902, 'Polly Blewitt', 1, '5/15/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (903, 'Tymon Fawkes', 1, '11/3/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (904, 'Cristal Foister', 1, '9/19/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (905, 'Torrie Scurfield', 1, '6/3/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (906, 'Consuelo Winsborrow', 1, '9/13/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (907, 'Abran Lowers', 0, '7/10/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (908, 'Avictor Wallhead', 0, '9/12/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (909, 'Jeanna Devanny', 0, '1/29/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (910, 'Rustin Nanetti', 1, '2/28/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (911, 'Berte Lansdown', 1, '4/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (912, 'Caro Palphramand', 1, '12/19/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (913, 'Andeee Pipet', 0, '1/30/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (914, 'Marleen Eke', 1, '8/17/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (915, 'Corrinne Southern', 0, '2/19/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (916, 'Maurizio Tinsley', 0, '7/30/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (917, 'Boycey Pygott', 0, '1/23/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (918, 'Melania McCombe', 0, '6/1/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (919, 'Perla Hedden', 1, '8/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (920, 'Clerc Hurnell', 0, '11/26/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (921, 'Giulietta Dreakin', 0, '5/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (922, 'Candra Kinsey', 1, '7/31/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (923, 'Camellia Helkin', 1, '3/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (924, 'Wandie Minchinton', 0, '9/25/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (925, 'Jessee Meco', 1, '5/25/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (926, 'Kalindi Mott', 1, '2/14/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (927, 'Bernardine Baudouin', 1, '7/13/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (928, 'Dunc McAlinden', 0, '6/5/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (929, 'Adrienne Blanch', 1, '6/12/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (930, 'Fifine Whitham', 0, '5/7/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (931, 'Gabie Rushby', 1, '2/11/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (932, 'Fionna Ingledow', 1, '12/26/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (933, 'Deeann Linnard', 1, '12/22/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (934, 'Elka Blackey', 1, '8/15/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (935, 'Torey Sproson', 0, '1/25/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (936, 'Fields Torfin', 0, '2/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (937, 'Moishe Marcum', 0, '8/16/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (938, 'Phillida Quakley', 1, '7/21/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (939, 'Anson Flieg', 0, '5/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (940, 'Isidore Denisyev', 0, '9/2/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (941, 'Marve Dilleston', 1, '8/29/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (942, 'Lonnard Torel', 1, '6/7/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (943, 'Hanson Kenelin', 1, '1/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (944, 'Karleen Kemson', 0, '3/13/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (945, 'Shurwood Haston', 0, '7/4/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (946, 'Donielle Wagenen', 1, '4/26/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (947, 'Elyse Farley', 0, '8/6/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (948, 'Sax Cockett', 1, '11/16/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (949, 'Cynde Karolczyk', 1, '8/10/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (950, 'Bibi De Mitri', 0, '5/19/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (951, 'Janeen Lanigan', 1, '11/1/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (952, 'Susie Rodnight', 1, '11/7/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (953, 'Hanson Carson', 1, '7/30/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (954, 'Nananne Haberfield', 0, '6/18/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (955, 'Vale Skryne', 0, '12/3/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (956, 'Maryrose Kuller', 1, '7/6/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (957, 'Mireielle Tisun', 0, '11/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (958, 'Lisha Mill', 1, '12/16/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (959, 'Enoch Ginley', 0, '8/12/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (960, 'Augustine Wankling', 0, '10/31/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (961, 'Consuelo Wakely', 1, '2/21/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (962, 'Poppy Huetson', 0, '12/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (963, 'Brew McEttigen', 0, '11/28/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (964, 'Rey Seabon', 0, '12/4/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (965, 'Jamey Aicken', 1, '3/10/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (966, 'Lauri De Few', 0, '11/25/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (967, 'Gustie Butland', 1, '1/15/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (968, 'Edvard Wicken', 0, '1/23/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (969, 'Orrin Snasdell', 1, '7/9/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (970, 'Levy Assur', 0, '4/6/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (971, 'Jeremie Olerenshaw', 0, '8/28/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (972, 'Marlo Sonier', 0, '2/5/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (973, 'Jackqueline Peever', 0, '7/22/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (974, 'Renard Silbert', 0, '11/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (975, 'Josee Cannaway', 1, '9/16/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (976, 'Carie Cogdell', 1, '12/14/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (977, 'Steffie Gwin', 1, '12/16/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (978, 'Aluin Desvignes', 1, '1/8/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (979, 'Catie Dawdry', 0, '12/20/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (980, 'Adel Ellerman', 0, '8/27/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (981, 'Eziechiele Hucquart', 1, '7/5/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (982, 'Hamilton Melton', 0, '9/13/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (983, 'Catharine Lorentz', 0, '11/6/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (984, 'Leroi Trevan', 0, '9/14/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (985, 'Dalia Souten', 0, '5/8/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (986, 'Whitaker Pickerin', 1, '9/3/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (987, 'Gloriana Wrightam', 1, '3/2/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (988, 'Neysa Stathor', 0, '12/12/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (989, 'Reed Tampion', 0, '10/23/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (990, 'Templeton Hatley', 0, '5/7/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (991, 'Lonnie Penley', 1, '6/5/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (992, 'Modesty Linnit', 0, '4/6/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (993, 'Leontine Blowes', 0, '12/6/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (994, 'Kristien Gland', 0, '2/19/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (995, 'Edie Cleve', 0, '4/14/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (996, 'Cash Coveney', 0, '6/23/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (997, 'Rica Jewess', 1, '5/26/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (998, 'Arthur Basilio', 1, '5/30/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (999, 'Raquel Grinin', 1, '1/27/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1000, 'Prince Rittelmeyer', 1, '11/26/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1001, 'Raychel Tournay', 0, '12/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1002, 'Holden Churchyard', 1, '9/7/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1003, 'Betsy Lount', 0, '6/10/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1004, 'Zorana Human', 1, '12/18/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1005, 'Deloria Hasling', 0, '10/28/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1006, 'Serena Hallgath', 0, '12/9/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1007, 'Jaquelin Will', 0, '1/11/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1008, 'Cher Kuhnel', 0, '5/6/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1009, 'Connor Cleland', 0, '11/28/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1010, 'Burnard Buzzing', 0, '6/3/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1011, 'Siward Brotherhed', 0, '7/20/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1012, 'Conrado Swalough', 0, '2/6/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1013, 'Lucienne Hentzer', 1, '11/24/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1014, 'Aleksandr Kubatsch', 0, '10/8/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1015, 'Terence Nicholl', 1, '1/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1016, 'Shep Benfield', 0, '6/6/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1017, 'Borg Donohue', 1, '10/10/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1018, 'Veronike Tomaskov', 0, '4/18/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1019, 'Gracia Slatten', 0, '3/12/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1020, 'Shellie Kelly', 0, '9/26/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1021, 'Eden Handmore', 0, '6/21/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1022, 'Roby Baudasso', 1, '4/4/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1023, 'Reynard Surmeyer', 1, '1/1/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1024, 'Wye Stenning', 1, '3/2/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1025, 'Aguie Hark', 1, '1/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1026, 'Trenna Yersin', 0, '5/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1027, 'Maryl Goldsbury', 0, '9/22/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1028, 'Cedric Campbell', 0, '9/10/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1029, 'Lucius Singyard', 1, '11/18/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1030, 'Kellen Lawie', 1, '2/26/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1031, 'Dian Duthie', 1, '5/15/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1032, 'Verla Jakubovicz', 1, '3/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1033, 'Bentley Halifax', 0, '11/16/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1034, 'Anson Foxhall', 1, '1/29/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1035, 'Tybi Gidman', 0, '8/18/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1036, 'Brina Francillo', 0, '4/22/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1037, 'Prinz Rivalant', 1, '11/3/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1038, 'Lane Jeffry', 0, '2/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1039, 'Wanda Luetkemeyers', 0, '11/10/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1040, 'Pammie Boothebie', 0, '10/24/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1041, 'Adriena Shyram', 0, '12/10/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1042, 'Bartolomeo Halbeard', 0, '12/24/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1043, 'Allsun Molohan', 1, '2/12/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1044, 'Reine Cator', 1, '3/28/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1045, 'Katuscha Vuitton', 1, '7/11/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1046, 'Joan Tume', 1, '12/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1047, 'Beniamino Romao', 1, '10/29/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1048, 'Shae Faudrie', 1, '9/28/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1049, 'Trix Gapper', 1, '3/3/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1050, 'Skell Coard', 1, '2/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1051, 'Phineas Cleare', 1, '11/20/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1052, 'Christoph Siberry', 1, '5/12/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1053, 'Marion Moretto', 0, '7/5/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1054, 'Kaia Moffet', 0, '1/23/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1055, 'Retha Zebedee', 0, '4/2/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1056, 'Nicolais Fawbert', 1, '2/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1057, 'Ulick Bernhard', 1, '7/24/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1058, 'Tedda McVane', 1, '6/14/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1059, 'Salmon Wrotchford', 0, '8/18/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1060, 'Reginauld Showler', 1, '3/14/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1061, 'Danella Jurgenson', 0, '5/19/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1062, 'Jacquenetta Bussell', 1, '6/3/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1063, 'Mavis De Mars', 0, '4/29/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1064, 'Tedman MacIntosh', 1, '10/14/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1065, 'Auroora De L''Isle', 0, '12/26/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1066, 'Cherilyn Brumbye', 1, '7/1/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1067, 'Inga Hurdidge', 1, '7/19/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1068, 'Catherin Cotterill', 0, '5/14/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1069, 'Devon Wigglesworth', 1, '1/16/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1070, 'Ofilia Schulter', 1, '2/23/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1071, 'Clovis Navaro', 1, '11/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1072, 'Marcello Merrick', 0, '4/21/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1073, 'Bird Newrick', 1, '8/15/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1074, 'Zachery Stanislaw', 1, '3/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1075, 'Irena Robertsson', 1, '2/1/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1076, 'Caterina Luce', 1, '7/10/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1077, 'Christophorus Khrishtafovich', 1, '1/16/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1078, 'Sapphira Colloff', 0, '5/11/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1079, 'Daniella Braganza', 1, '7/23/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1080, 'Annadiane Loncaster', 0, '11/29/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1081, 'Normand Normanvell', 0, '11/1/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1082, 'Cal Jervois', 1, '1/6/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1083, 'Val Pidgen', 1, '4/11/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1084, 'Vyky Denecamp', 0, '1/22/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1085, 'Celle Lawden', 1, '5/8/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1086, 'Wheeler Blockley', 1, '6/8/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1087, 'Ulla Ballach', 0, '5/18/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1088, 'Stacy Levinge', 0, '7/6/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1089, 'Keriann Blader', 0, '1/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1090, 'Solomon Bewshaw', 0, '4/2/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1091, 'Rahal Stollery', 1, '4/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1092, 'Bram Fitch', 1, '12/24/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1093, 'Blondie Ajsik', 0, '6/3/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1094, 'Bertie Judkin', 0, '5/13/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1095, 'Annelise Burton', 0, '6/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1096, 'Denny Antoniou', 1, '9/27/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1097, 'Shellie Darrow', 0, '5/31/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1098, 'Merna Pittman', 0, '3/2/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1099, 'Otto Bridgeman', 0, '11/29/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1100, 'Justis Schruur', 1, '3/10/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1101, 'Grazia Pozer', 0, '3/16/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1102, 'Christoph Minear', 1, '1/25/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1103, 'Cally Flint', 0, '10/31/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1104, 'Lorri Thackray', 0, '4/3/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1105, 'Cully Blaksley', 1, '8/5/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1106, 'Clea Lowdwell', 1, '6/24/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1107, 'Haskel Mollindinia', 0, '6/24/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1108, 'Caro Sinnatt', 0, '4/19/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1109, 'Anabella Wing', 1, '7/15/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1110, 'Anny Dufty', 0, '9/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1111, 'Mallissa Bellis', 1, '7/6/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1112, 'Adriane Utridge', 1, '8/14/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1113, 'Maximo Greader', 0, '4/3/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1114, 'Gayel de Clerk', 1, '10/19/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1115, 'Reynolds Gilligan', 1, '5/17/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1116, 'Paolo Khoter', 1, '10/27/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1117, 'Romola Simoneschi', 1, '6/11/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1118, 'Kiele FitzAlan', 1, '10/2/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1119, 'Anica Gillice', 0, '12/26/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1120, 'Adolphus Hightown', 0, '6/14/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1121, 'Leonid Guite', 1, '12/23/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1122, 'Heddi Arthars', 1, '10/14/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1123, 'Ivie Beddin', 0, '1/13/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1124, 'Montgomery Dennis', 1, '6/5/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1125, 'Analise Stapleton', 1, '4/12/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1126, 'Carmelina Bichener', 1, '12/24/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1127, 'Andros McInnery', 0, '10/16/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1128, 'Bay Studdard', 0, '3/28/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1129, 'Karissa Reiling', 1, '12/5/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1130, 'Grayce Middlemist', 0, '1/26/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1131, 'Renate McKeating', 1, '7/13/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1132, 'Bunny Baptiste', 1, '6/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1133, 'Berny Aspole', 1, '7/7/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1134, 'Sid Fullager', 1, '7/30/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1135, 'Thomas Durban', 1, '11/18/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1136, 'Jasmin Degue', 1, '11/1/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1137, 'Ludvig Lafranconi', 1, '10/3/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1138, 'Clive Sweating', 1, '1/17/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1139, 'Ermina Blas', 1, '8/31/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1140, 'De witt McGannon', 1, '6/3/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1141, 'Giavani Lown', 1, '8/19/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1142, 'Wit Durkin', 1, '12/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1143, 'Iris Fawckner', 0, '5/2/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1144, 'Lib Dallywater', 0, '6/18/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1145, 'Abbe Hundell', 1, '12/24/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1146, 'Starr Iskowitz', 0, '11/23/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1147, 'Ginni Anthonsen', 0, '6/28/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1148, 'Terri-jo Fannon', 0, '9/13/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1149, 'Merrill Castaner', 0, '7/18/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1150, 'Caroline Chellam', 1, '6/13/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1151, 'Lucille Balnave', 1, '10/10/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1152, 'John Magnay', 1, '8/4/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1153, 'Blake Folca', 0, '5/2/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1154, 'Hyacinthe Lawles', 1, '8/25/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1155, 'Lionel O''Shaughnessy', 0, '12/7/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1156, 'Raynell Larner', 1, '9/3/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1157, 'Faythe de Glanville', 0, '11/13/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1158, 'Shelley Penkethman', 1, '12/22/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1159, 'Binnie O''Kane', 0, '11/30/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1160, 'Pennie Vivash', 1, '7/26/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1161, 'Marilee Henker', 0, '8/29/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1162, 'Waite Throssell', 0, '4/27/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1163, 'Sheelagh Camilio', 1, '5/29/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1164, 'Clea Vitler', 1, '5/10/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1165, 'Natka Scholig', 1, '12/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1166, 'Tova Massimo', 1, '2/9/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1167, 'Georgianne Possa', 1, '1/21/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1168, 'Coralyn Forsyth', 0, '6/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1169, 'Wallis Talks', 0, '3/14/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1170, 'Ashlee Salsberg', 1, '11/4/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1171, 'Amerigo Syddon', 1, '9/30/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1172, 'Celestina Hardiman', 1, '5/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1173, 'Concettina Arnaldy', 1, '7/26/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1174, 'Caresa Weitzel', 1, '4/16/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1175, 'Ermentrude Maevela', 0, '8/20/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1176, 'Leroy Norwood', 1, '4/10/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1177, 'Gilberta Derbyshire', 0, '10/27/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1178, 'Sheffield Jahns', 0, '10/20/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1179, 'Arnoldo MacFadzan', 1, '2/7/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1180, 'Yuma Griniov', 1, '11/2/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1181, 'Meta Dobkin', 1, '5/29/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1182, 'Bastien Atley', 0, '8/2/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1183, 'Giusto Mattiacci', 0, '2/7/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1184, 'Trula Stanwix', 0, '6/12/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1185, 'Bron Woodyer', 1, '2/15/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1186, 'Adena Kornyakov', 0, '6/20/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1187, 'Roanne Wellen', 0, '4/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1188, 'Buckie Guise', 1, '2/28/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1189, 'Cozmo Dishman', 1, '12/1/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1190, 'Zolly Guntrip', 0, '12/28/1970');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1191, 'Albie Boater', 0, '5/6/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1192, 'Sharl Leishman', 1, '12/6/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1193, 'Cicely Polet', 1, '3/25/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1194, 'Lorie Giercke', 1, '11/26/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1195, 'Isidora Cuddehy', 1, '10/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1196, 'Theresina Tixier', 0, '3/12/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1197, 'Raye Harteley', 0, '1/14/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1198, 'Pierre Stanwix', 0, '6/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1199, 'Peder Sabin', 1, '7/2/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1200, 'Netti Walbridge', 1, '4/29/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1201, 'Christopher Boothroyd', 1, '4/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1202, 'Alexa MacCumiskey', 1, '6/1/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1203, 'Vittorio Burwell', 1, '5/4/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1204, 'Giana Poynter', 1, '5/8/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1205, 'Court Sibery', 1, '8/26/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1206, 'Ryley Lovemore', 0, '5/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1207, 'Calla Stormouth', 0, '4/4/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1208, 'Erek Hinkley', 0, '9/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1209, 'Hieronymus Trickett', 0, '4/18/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1210, 'Helsa Bloxham', 0, '12/15/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1211, 'Linus Aldus', 0, '11/23/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1212, 'Jeanine Sandys', 1, '8/2/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1213, 'Carmon McTrustey', 1, '11/2/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1214, 'Helaina Turbard', 0, '11/12/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1215, 'Helyn Goff', 0, '12/18/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1216, 'Hillary McKerton', 0, '7/23/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1217, 'Sampson Hawtry', 0, '4/8/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1218, 'Milissent Andrzejczak', 0, '2/16/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1219, 'Purcell Fayter', 1, '8/19/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1220, 'Gannon Castano', 1, '12/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1221, 'Ginnie Como', 1, '10/31/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1222, 'Eldridge Klosa', 1, '2/14/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1223, 'Kendell Di Biagi', 1, '10/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1224, 'Tine Leap', 0, '7/18/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1225, 'Tansy Berni', 1, '11/24/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1226, 'Lindon Agneau', 0, '5/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1227, 'Constancia Budnk', 0, '3/13/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1228, 'Hadrian Bedford', 0, '6/9/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1229, 'Serena Giannotti', 1, '5/22/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1230, 'Courtney Ginty', 1, '9/8/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1231, 'Michaeline How', 0, '6/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1232, 'Griswold Raxworthy', 1, '9/5/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1233, 'Chester Verty', 0, '6/24/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1234, 'Janean Elan', 1, '12/20/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1235, 'Ivonne Dunmore', 0, '5/14/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1236, 'Park Tomashov', 0, '7/30/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1237, 'Cheri Georger', 0, '2/5/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1238, 'Elfrida Froschauer', 0, '10/10/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1239, 'Bea Landon', 1, '3/2/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1240, 'Ayn Fosserd', 1, '10/8/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1241, 'Dorice Brightie', 0, '4/3/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1242, 'Bernete Kuna', 0, '7/6/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1243, 'Regen Jenno', 1, '5/9/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1244, 'Laverna Spurman', 1, '2/17/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1245, 'Maggie Tabner', 0, '7/19/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1246, 'Verena Rainbow', 0, '9/5/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1247, 'Trish O''Sheeryne', 0, '5/9/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1248, 'Alma Garrie', 0, '11/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1249, 'Constantina Sendall', 1, '5/28/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1250, 'Georgeta Roeby', 1, '8/25/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1251, 'Kristin Dreini', 0, '11/24/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1252, 'Christopher Lamplugh', 0, '4/28/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1253, 'Brander Sendall', 1, '3/8/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1254, 'Ddene Solland', 1, '6/5/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1255, 'Janella Vickarman', 0, '10/4/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1256, 'Koressa Potebury', 1, '6/10/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1257, 'Barron Pittman', 1, '8/21/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1258, 'Shadow Roman', 1, '11/29/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1259, 'Winnah Troak', 0, '1/2/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1260, 'Craig Shadwick', 1, '9/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1261, 'Norah Deane', 1, '4/22/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1262, 'Lorilyn Ditzel', 0, '4/25/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1263, 'Darren Robardey', 1, '11/19/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1264, 'Deborah Ruffell', 0, '1/4/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1265, 'Kris Grima', 0, '5/29/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1266, 'Marv Lakeland', 0, '9/13/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1267, 'Alaric Lemmer', 1, '7/25/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1268, 'Hillard Weinham', 1, '4/1/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1269, 'Kassandra Jacobovitz', 1, '11/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1270, 'Gennifer Pagin', 0, '5/21/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1271, 'Cyndie McKoy', 1, '8/29/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1272, 'Rutledge Tinmouth', 1, '7/22/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1273, 'Lisle Francesco', 1, '6/22/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1274, 'Marshall Lahive', 1, '8/24/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1275, 'Madelin Stolte', 1, '6/23/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1276, 'Filippo Gouldstraw', 1, '1/26/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1277, 'Vivia Queste', 1, '4/15/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1278, 'Collen Burless', 0, '9/13/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1279, 'Tybalt Matthiae', 0, '1/13/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1280, 'Evyn Cronkshaw', 0, '2/7/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1281, 'Shelli Rimmington', 0, '7/29/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1282, 'Eilis McJury', 1, '4/1/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1283, 'Jacqui Folds', 0, '5/16/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1284, 'Findley Downey', 0, '10/7/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1285, 'Onfroi Gregoriou', 1, '6/21/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1286, 'Nathalia Hurley', 1, '10/10/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1287, 'Eugine Checklin', 1, '9/27/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1288, 'Mateo Dallywater', 0, '12/17/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1289, 'Lind Minghella', 1, '4/26/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1290, 'Sandor Habbes', 1, '11/13/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1291, 'Jarib Geard', 1, '11/21/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1292, 'Camellia Vye', 0, '7/29/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1293, 'Fulton Bruins', 0, '3/4/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1294, 'Jamill Bidmead', 1, '8/7/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1295, 'Lisette Dyble', 0, '1/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1296, 'Steffi Betchley', 0, '9/20/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1297, 'Keefe Pinchin', 1, '12/9/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1298, 'Sinclair Sheldrick', 0, '3/14/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1299, 'Harriot Ackery', 1, '12/25/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1300, 'Berkie Posnett', 0, '4/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1301, 'Clareta Von Welden', 0, '3/3/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1302, 'Fredrick Mussalli', 0, '3/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1303, 'Eunice Clissold', 0, '5/20/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1304, 'Clarie Penhallurick', 0, '11/30/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1305, 'Phillida Ollington', 1, '1/26/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1306, 'Cherye Bartaloni', 1, '12/29/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1307, 'Vaughn Bicksteth', 0, '4/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1308, 'Krispin Bardill', 1, '9/21/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1309, 'Gus McFall', 0, '3/2/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1310, 'Neely Baish', 1, '7/11/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1311, 'Dannie Drakard', 0, '10/22/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1312, 'Giacobo Hurtado', 1, '4/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1313, 'Tomasine M''Barron', 0, '4/3/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1314, 'Tabbie Jeanin', 0, '4/9/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1315, 'Jemmy Gruczka', 1, '11/18/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1316, 'Florina Delnevo', 1, '4/9/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1317, 'Carmen Roizn', 0, '8/21/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1318, 'Larissa Baiss', 0, '9/15/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1319, 'Erina Popeley', 1, '12/11/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1320, 'Lilah Gilham', 0, '4/30/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1321, 'Licha Robbeke', 0, '9/20/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1322, 'Webster Sand', 0, '10/14/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1323, 'Lindon Mathivon', 0, '11/14/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1324, 'Di Sandaver', 0, '8/28/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1325, 'Jamison Jackett', 1, '4/2/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1326, 'Ashla Blancowe', 1, '7/29/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1327, 'Mavis Aspland', 1, '7/26/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1328, 'Guillaume Iverson', 1, '10/30/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1329, 'Siusan Baselli', 0, '11/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1330, 'Clarita Akenhead', 0, '3/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1331, 'Twyla Smail', 0, '5/11/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1332, 'Chevy Patman', 0, '7/27/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1333, 'Brennen Kilshall', 1, '1/19/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1334, 'Dorine Lante', 0, '7/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1335, 'Lyman Bohje', 0, '8/10/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1336, 'Alvera Shakesby', 0, '8/9/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1337, 'Delainey MacInherney', 1, '4/22/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1338, 'Laurie Asipenko', 0, '6/16/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1339, 'Isadore Mumbeson', 0, '7/8/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1340, 'Hakim Varnam', 0, '1/12/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1341, 'Krishnah Scandred', 0, '7/24/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1342, 'Edgar Zucker', 0, '10/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1343, 'Redford Percifer', 0, '7/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1344, 'Ange Scrane', 1, '1/13/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1345, 'Theresina Sobieski', 0, '7/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1346, 'Codi Yakutin', 1, '12/4/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1347, 'Filippa Melledy', 0, '11/27/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1348, 'Gates Patrickson', 1, '10/1/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1349, 'Amil Dietsche', 0, '10/10/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1350, 'Norman Flamank', 0, '8/8/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1351, 'Clem Scarlett', 1, '10/31/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1352, 'Jessy DelaField', 1, '11/27/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1353, 'Maurine Cometti', 1, '5/14/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1354, 'Leif Yeoman', 0, '1/16/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1355, 'Winni Ellerman', 1, '8/28/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1356, 'Sibley Dionisetto', 1, '1/9/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1357, 'Franklyn Eglese', 1, '7/4/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1358, 'Danny Jeandot', 0, '1/31/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1359, 'Claybourne Swaisland', 1, '11/27/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1360, 'Mar Jerromes', 1, '12/8/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1361, 'Ode Goodacre', 1, '10/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1362, 'Murry Byne', 0, '6/22/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1363, 'Idell Brownsea', 0, '6/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1364, 'Etta Pembery', 0, '11/17/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1365, 'Steffane O''Teague', 0, '10/9/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1366, 'Ardella Barkley', 1, '6/7/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1367, 'Magdalene Tongs', 0, '2/9/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1368, 'Georgianne Brader', 1, '8/16/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1369, 'Hailee Ferry', 0, '11/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1370, 'Jaquelyn Myrie', 0, '6/12/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1371, 'Aeriela Matschoss', 0, '10/14/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1372, 'Lusa Pepperell', 0, '4/15/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1373, 'Tracie Buie', 1, '12/26/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1374, 'Jacquelynn Readie', 0, '5/27/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1375, 'Wittie MacPaike', 0, '5/30/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1376, 'Dicky Munton', 0, '7/7/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1377, 'Juditha Killbey', 1, '5/26/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1378, 'Susette Marconi', 0, '1/10/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1379, 'Joey Garmanson', 0, '5/7/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1380, 'Jay Paull', 1, '7/9/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1381, 'Valene Bissiker', 0, '12/22/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1382, 'Krissie Regardsoe', 0, '5/14/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1383, 'Benjie Jaqueme', 0, '10/27/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1384, 'Bron Cressey', 0, '4/2/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1385, 'Dewie Statham', 1, '12/17/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1386, 'Eran Eliff', 1, '6/18/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1387, 'Helene Riche', 1, '4/7/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1388, 'Felipe Slator', 1, '7/12/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1389, 'Antonietta Raith', 1, '11/12/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1390, 'Pace McKoy', 1, '1/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1391, 'Tybie Gookey', 0, '6/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1392, 'Marilyn Dupree', 1, '4/22/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1393, 'Linette Sallows', 0, '5/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1394, 'Lutero Diviney', 0, '11/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1395, 'Lynnelle Mylan', 0, '12/27/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1396, 'Leeann Woliter', 0, '6/16/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1397, 'Justina Vanyushin', 1, '8/12/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1398, 'Allin Hrynczyk', 1, '6/7/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1399, 'Mellisent Godly', 1, '1/2/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1400, 'Bing Manklow', 1, '6/15/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1401, 'Selene Morrissey', 0, '1/25/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1402, 'Peta Tilio', 1, '10/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1403, 'Lissa Lesper', 1, '2/18/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1404, 'Tammy Hibling', 1, '11/29/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1405, 'Gare Basini-Gazzi', 0, '12/29/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1406, 'Sianna Vannuccinii', 0, '6/7/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1407, 'Eunice Dixcee', 0, '6/8/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1408, 'Christoforo Wilmut', 0, '8/10/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1409, 'Camey Schiell', 1, '12/4/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1410, 'Gianna Farre', 0, '1/12/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1411, 'Maryl Boycott', 1, '4/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1412, 'Maire Blackston', 0, '10/4/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1413, 'Veradis Garfath', 0, '6/15/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1414, 'Starr Fautley', 0, '9/18/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1415, 'Francois Ibbitt', 1, '5/3/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1416, 'Rudiger Keeping', 0, '4/16/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1417, 'Leona Winnard', 1, '1/17/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1418, 'Obed Lampke', 0, '10/28/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1419, 'Richard Hardeman', 1, '9/1/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1420, 'Lulita Paolacci', 0, '9/18/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1421, 'Bettina Mahony', 0, '12/6/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1422, 'Claudina Sellors', 0, '12/5/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1423, 'Stanton Nottle', 0, '4/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1424, 'Barry Terbruggen', 0, '6/7/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1425, 'Alvinia Godsal', 0, '6/16/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1426, 'Rafaellle Willoughby', 0, '10/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1427, 'Far Harvie', 0, '6/1/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1428, 'Diarmid de Almeida', 1, '6/26/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1429, 'Lemmie Ickovic', 1, '6/11/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1430, 'Whitby Seth', 1, '6/24/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1431, 'Dorine Stannard', 1, '12/15/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1432, 'Phedra Berzen', 1, '7/2/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1433, 'Kirsten Rennicks', 0, '12/15/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1434, 'Mano Ashbee', 1, '10/14/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1435, 'Skell Axcell', 1, '12/2/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1436, 'Maurine Grint', 0, '11/11/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1437, 'Annmaria Jeste', 0, '1/9/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1438, 'Coriss Persse', 0, '7/17/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1439, 'Emilio Bragg', 1, '3/2/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1440, 'Brianne Kreutzer', 1, '3/1/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1441, 'Win Hammerson', 0, '12/10/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1442, 'Vernor Rigge', 1, '5/24/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1443, 'Norbert Mullaney', 1, '3/30/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1444, 'Powell Aleevy', 0, '12/30/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1445, 'Laureen Enden', 0, '7/14/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1446, 'Matelda Purkess', 1, '8/25/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1447, 'Ring Lording', 0, '2/20/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1448, 'Willyt Surphliss', 1, '2/11/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1449, 'Blythe Feares', 1, '1/11/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1450, 'Oralia Lightwing', 1, '4/30/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1451, 'Eula Bednall', 0, '8/3/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1452, 'Cassaundra Newlands', 1, '4/29/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1453, 'Idalia Ekins', 1, '6/13/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1454, 'Lars Halpen', 1, '9/5/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1455, 'Emile Kither', 1, '11/14/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1456, 'Stephanie Pallent', 0, '3/3/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1457, 'Newton Iannetti', 0, '2/3/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1458, 'Thaine Beverstock', 0, '6/16/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1459, 'Leshia Ocheltree', 0, '4/12/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1460, 'Neils Bland', 1, '1/19/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1461, 'Wait Haddrell', 0, '10/5/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1462, 'Bob Brame', 0, '8/26/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1463, 'Lucas Lewins', 1, '2/19/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1464, 'Dalli Ormrod', 1, '4/17/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1465, 'Seamus Benediktovich', 1, '6/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1466, 'Babette Maasz', 0, '1/10/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1467, 'Jewel Power', 0, '4/17/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1468, 'Gennifer Tremblot', 0, '3/22/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1469, 'Desiri MacAndreis', 1, '9/29/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1470, 'Saleem Baldcock', 1, '4/20/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1471, 'Jorry Beverage', 0, '12/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1472, 'Valentina Dies', 1, '12/27/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1473, 'Hyacintha Calloway', 1, '11/22/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1474, 'Jelene Treweek', 1, '8/10/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1475, 'Rene Sharphouse', 0, '7/8/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1476, 'Marlin Leeke', 1, '9/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1477, 'Jennette Lawlan', 1, '10/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1478, 'Harriot Snoddin', 0, '9/11/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1479, 'Teodoro Sommerton', 1, '5/11/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1480, 'Lothario Milmith', 0, '11/12/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1481, 'Gigi Bridgestock', 1, '2/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1482, 'Gamaliel Gagie', 0, '4/9/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1483, 'Nedi Balshaw', 0, '3/21/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1484, 'Felisha Conklin', 1, '4/30/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1485, 'Amie Sommerly', 1, '4/9/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1486, 'Joanie Laddle', 1, '8/15/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1487, 'Farris Scudamore', 0, '8/2/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1488, 'Charissa Awton', 1, '2/21/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1489, 'Evaleen Janko', 0, '3/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1490, 'Helge Kondratovich', 0, '10/7/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1491, 'Tan Slaght', 1, '9/14/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1492, 'Vernor Bolding', 0, '11/11/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1493, 'Ingaberg Charge', 0, '8/31/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1494, 'Dalton Waberer', 1, '5/7/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1495, 'Way Tonry', 0, '12/30/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1496, 'Abbe Bloan', 1, '9/30/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1497, 'Meriel Brimner', 0, '6/26/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1498, 'Caddric Zorzin', 0, '11/14/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1499, 'Lissy Baly', 0, '7/16/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1500, 'Jerrold Kermit', 1, '7/20/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1501, 'Juliet Stansell', 0, '8/24/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1502, 'Willetta Hillaby', 0, '1/18/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1503, 'Scarlet Sogg', 0, '9/8/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1504, 'Doti Danick', 1, '12/6/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1505, 'Alphonso McGrowther', 0, '8/16/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1506, 'Jonie Deeks', 1, '8/4/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1507, 'Garvey Brockway', 1, '2/5/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1508, 'Skip Klaaasen', 1, '7/12/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1509, 'Doralynne MacKean', 0, '11/11/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1510, 'Dori Oene', 1, '8/13/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1511, 'Annelise Ramble', 1, '6/21/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1512, 'Carolee Howsin', 1, '4/9/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1513, 'Heinrik Ragbourne', 0, '4/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1514, 'Lexi Venturoli', 1, '1/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1515, 'Eustace Quigley', 0, '1/20/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1516, 'Audrey Topp', 1, '1/22/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1517, 'Catlee Raselles', 1, '12/1/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1518, 'Sada Hynes', 0, '12/18/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1519, 'Hedwiga Tippett', 0, '2/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1520, 'Earle MacGibbon', 1, '8/15/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1521, 'Orella McCollum', 1, '3/15/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1522, 'Dwain Doak', 0, '1/30/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1523, 'Allan Potten', 0, '7/20/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1524, 'Cherey Alker', 1, '7/6/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1525, 'Hedy Duce', 1, '5/30/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1526, 'Thatcher Godfery', 1, '10/31/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1527, 'Randee Tuminelli', 0, '6/12/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1528, 'Tandi Rosenau', 1, '7/10/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1529, 'Elsi Birckmann', 1, '12/24/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1530, 'Ruddie Tenby', 1, '5/9/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1531, 'Maggie Ratledge', 0, '10/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1532, 'Addie Insull', 1, '7/25/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1533, 'Godiva Lovart', 0, '3/22/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1534, 'Silas McNeish', 0, '10/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1535, 'Abigale Sacco', 1, '8/26/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1536, 'Kennie Craythorn', 1, '3/31/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1537, 'Desirae Arbuckel', 1, '8/19/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1538, 'Selina Garfitt', 0, '11/26/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1539, 'Gale Kinchlea', 1, '2/25/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1540, 'Inga Jenman', 1, '8/21/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1541, 'Dallon Halden', 0, '12/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1542, 'Denys Malin', 0, '3/17/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1543, 'Betta Oades', 0, '1/19/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1544, 'King Riehm', 1, '11/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1545, 'Adrea Perrie', 0, '8/7/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1546, 'Boy Hambidge', 0, '3/31/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1547, 'Leonid Murrish', 0, '12/22/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1548, 'Rufe Murdoch', 1, '11/2/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1549, 'Lek Spere', 1, '3/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1550, 'Renelle Gildersleeve', 1, '9/10/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1551, 'Theresa Petren', 1, '12/29/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1552, 'Melodee Giggie', 1, '9/25/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1553, 'Nanny Syres', 0, '1/7/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1554, 'Eula Fourcade', 0, '5/9/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1555, 'Kori Duffil', 1, '6/11/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1556, 'Lisabeth Fitzsymons', 0, '4/20/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1557, 'Bryan Upcott', 1, '7/21/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1558, 'Clevey Ivashnikov', 0, '1/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1559, 'Gus Presnall', 0, '11/26/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1560, 'Chrisy Sweeting', 0, '6/25/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1561, 'Gena Parradice', 1, '5/31/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1562, 'Sharlene Fickling', 1, '5/7/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1563, 'Lorine Whitcher', 1, '5/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1564, 'Franzen Shafe', 0, '12/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1565, 'Renell Merryman', 1, '1/22/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1566, 'Suki Sandys', 1, '9/30/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1567, 'Jill Gartrell', 0, '9/25/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1568, 'Barrie Sambrok', 1, '12/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1569, 'Mendy Cockhill', 1, '1/22/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1570, 'Jabez Crenage', 1, '4/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1571, 'Merilee Searchfield', 1, '1/6/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1572, 'Fons Sherrum', 0, '10/20/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1573, 'Mike Hoggin', 1, '8/6/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1574, 'Nata Misk', 1, '11/19/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1575, 'Roth McGowing', 0, '10/14/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1576, 'Jourdain Macbane', 0, '8/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1577, 'Elinor Farnfield', 0, '6/20/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1578, 'Hedvig Basten', 1, '6/2/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1579, 'Lamond Phelp', 0, '9/28/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1580, 'Valli Lofting', 1, '8/26/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1581, 'Roxana Meaddowcroft', 1, '4/7/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1582, 'Vincents Corlett', 1, '3/19/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1583, 'Coletta Collick', 1, '5/14/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1584, 'Winslow Penlington', 0, '12/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1585, 'Chelsea Shepherdson', 1, '7/24/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1586, 'Carly Coupar', 1, '12/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1587, 'Binny Pavelin', 0, '1/25/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1588, 'Mildrid Duinbleton', 0, '11/4/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1589, 'Royal Grewar', 1, '7/9/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1590, 'Terry Goodbarr', 1, '11/22/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1591, 'Maris Calafate', 0, '11/26/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1592, 'Max Robertelli', 1, '4/1/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1593, 'Adel Innerstone', 0, '5/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1594, 'Abram Pietron', 0, '1/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1595, 'Gaston Labes', 0, '4/13/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1596, 'Davide Bingell', 1, '1/24/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1597, 'Daren Van Schafflaer', 0, '12/13/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1598, 'Win Sibary', 0, '9/16/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1599, 'Noah Amys', 0, '2/20/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1600, 'Benito Lichfield', 1, '11/2/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1601, 'Menard Batson', 1, '7/24/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1602, 'Koressa Lithcow', 1, '9/22/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1603, 'Alberto Eivers', 0, '2/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1604, 'Karen Barnett', 0, '11/29/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1605, 'Liana Tant', 1, '2/17/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1606, 'Rosalynd Latter', 1, '4/1/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1607, 'Justinian Menpes', 1, '3/7/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1608, 'Ambrosio Pedel', 0, '4/20/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1609, 'Victoir Lambirth', 1, '2/1/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1610, 'Nancie Seaborn', 1, '2/28/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1611, 'Pam Fray', 0, '10/21/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1612, 'Carmine Sponder', 1, '4/8/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1613, 'Kris Kilgrove', 1, '7/29/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1614, 'Fransisco Seagood', 1, '6/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1615, 'Ddene Smithies', 1, '4/13/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1616, 'Chelsey Thormann', 0, '4/2/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1617, 'Gregor Carson', 0, '1/16/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1618, 'Jameson Vasler', 1, '5/3/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1619, 'Morganica Monkleigh', 0, '12/14/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1620, 'Chiquita Boles', 0, '9/27/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1621, 'Joanie Trobe', 0, '10/19/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1622, 'Orland Wyleman', 1, '11/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1623, 'Brockie Prin', 0, '9/24/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1624, 'Gwenny McMurdo', 0, '12/8/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1625, 'Lu Treker', 0, '4/19/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1626, 'Jeffry Barton', 1, '10/31/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1627, 'Michelina Hoffman', 0, '6/22/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1628, 'Porter Attrey', 0, '5/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1629, 'Emilio Linnane', 0, '3/17/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1630, 'Sanson Jaime', 0, '4/22/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1631, 'Bordie Wurz', 1, '12/17/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1632, 'Batsheva Creus', 0, '12/22/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1633, 'Judye Bezley', 1, '10/25/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1634, 'Trude Lifton', 1, '9/2/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1635, 'Glen Botte', 1, '3/5/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1636, 'Car Ohm', 0, '5/2/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1637, 'Cathlene Broodes', 1, '11/22/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1638, 'Jan Bauckham', 1, '12/13/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1639, 'Jayson Tabb', 0, '2/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1640, 'Jaine Pembridge', 0, '6/9/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1641, 'Maxi Tempest', 1, '8/28/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1642, 'Sophie Bulley', 0, '2/11/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1643, 'Rickert Henrot', 1, '3/3/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1644, 'Corinne Reightley', 1, '3/26/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1645, 'Celeste Longridge', 1, '10/13/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1646, 'Jinny Savins', 1, '8/13/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1647, 'Brandice Kasman', 1, '2/11/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1648, 'Farand Cawthorne', 1, '8/6/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1649, 'Quincy Forrester', 1, '5/22/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1650, 'Ingmar Brew', 1, '2/7/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1651, 'Arri Resdale', 0, '12/23/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1652, 'Cassey Doutch', 0, '2/5/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1653, 'Hollyanne Pickersgill', 0, '4/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1654, 'Bernelle Rubinfajn', 0, '5/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1655, 'Doralia Schouthede', 1, '6/25/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1656, 'Penny Cominello', 1, '5/24/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1657, 'Terrence Evitts', 1, '3/15/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1658, 'Thomasina Sievewright', 0, '12/28/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1659, 'Cristi Coneau', 1, '5/23/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1660, 'Rae Moggle', 1, '3/7/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1661, 'Adan Thom', 0, '3/27/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1662, 'June Harcourt', 1, '5/27/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1663, 'Sauveur Benoiton', 0, '4/24/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1664, 'Mindy Stollberger', 1, '1/28/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1665, 'Francoise Bullin', 1, '12/13/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1666, 'Bailie Bayley', 1, '3/18/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1667, 'Nico Wythe', 0, '2/11/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1668, 'Hedy Skipping', 0, '4/11/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1669, 'Torrance Whitland', 1, '1/31/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1670, 'Chicky Odby', 0, '1/10/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1671, 'Syman Playford', 1, '6/24/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1672, 'Lindsy Coysh', 1, '12/27/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1673, 'Muhammad Thormann', 0, '4/28/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1674, 'Alissa Allbut', 1, '1/29/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1675, 'Hamlin Fiveash', 1, '4/8/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1676, 'Pansy Dolman', 1, '1/14/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1677, 'Loralie Timmes', 1, '5/7/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1678, 'Susana Dreakin', 0, '9/18/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1679, 'Bevan Hrinishin', 1, '7/29/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1680, 'Farrah McClinton', 1, '7/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1681, 'Grace Schneider', 0, '2/10/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1682, 'Katti Seater', 0, '12/30/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1683, 'Nikolas Crocken', 1, '10/11/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1684, 'Cyndie Bernasek', 0, '1/20/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1685, 'Winifred Ditty', 0, '5/18/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1686, 'Dino Noonan', 0, '7/16/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1687, 'Ronny Regan', 1, '5/29/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1688, 'Heidie Hinze', 1, '4/3/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1689, 'Moira Heinicke', 1, '12/21/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1690, 'Pauline De Witt', 1, '10/8/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1691, 'Leland Berrick', 0, '11/8/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1692, 'Melosa Rockhill', 0, '9/8/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1693, 'Broderic Vannuccinii', 0, '10/24/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1694, 'Kelli Vandrill', 0, '4/22/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1695, 'Loralee Gillet', 1, '11/12/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1696, 'Sam Tames', 1, '12/30/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1697, 'Morgan Robb', 0, '7/16/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1698, 'Kessiah Roycroft', 0, '9/29/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1699, 'Alfie McKevany', 0, '8/2/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1700, 'Terrance Rodinger', 0, '11/29/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1701, 'Vannie D''Arrigo', 0, '3/11/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1702, 'Benyamin Keig', 1, '10/30/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1703, 'Philippa Learmount', 1, '4/30/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1704, 'Carley Lukins', 1, '7/16/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1705, 'Jeffry Swanton', 1, '6/27/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1706, 'John Merrell', 1, '11/6/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1707, 'Marieann Dufaire', 1, '4/7/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1708, 'Isac Kobsch', 1, '11/29/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1709, 'Elka Aistrop', 1, '5/9/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1710, 'Darcey Lauxmann', 0, '5/1/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1711, 'Dreddy Kolak', 0, '8/2/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1712, 'Berget Duley', 0, '3/11/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1713, 'Inge Flewan', 1, '4/10/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1714, 'Simmonds Sikorsky', 1, '1/23/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1715, 'Garner Whittlesea', 1, '10/22/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1716, 'Major Oldroyde', 1, '4/1/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1717, 'Zenia Camlin', 0, '11/17/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1718, 'Jacenta Semper', 0, '9/25/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1719, 'Manny Chadband', 0, '3/11/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1720, 'Dilan Bellworthy', 1, '3/30/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1721, 'Neille Churly', 1, '9/8/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1722, 'Sheppard Poschel', 0, '9/25/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1723, 'Zebadiah Grainger', 0, '1/8/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1724, 'Chery Dochon', 0, '11/29/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1725, 'Charissa Haney', 1, '11/10/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1726, 'Cornela Voysey', 1, '7/11/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1727, 'Kingston Plaister', 0, '3/21/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1728, 'Bobette Vasilchenko', 0, '7/5/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1729, 'Kerwinn Stourton', 1, '5/29/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1730, 'Durante Crittal', 0, '10/23/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1731, 'Amelita Teacy', 1, '1/31/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1732, 'Karlotte Heelis', 0, '12/19/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1733, 'Lilla Luna', 0, '4/30/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1734, 'Nannette Bolderson', 0, '6/18/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1735, 'Marin Hepher', 1, '5/29/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1736, 'Ingrim Serrels', 1, '6/15/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1737, 'Binni Crowhurst', 0, '7/18/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1738, 'Roman Valett', 0, '11/28/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1739, 'Edmon Ickovits', 0, '5/20/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1740, 'Gwenora Baribal', 0, '7/7/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1741, 'Kimbell Powney', 1, '5/9/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1742, 'Alphonso Breazeall', 0, '3/9/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1743, 'Aurilia Wittman', 1, '3/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1744, 'Gardener Tsar', 0, '9/27/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1745, 'Dulcie D''Ambrogio', 0, '4/25/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1746, 'Serene Colecrough', 0, '5/6/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1747, 'Dylan Connell', 0, '12/20/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1748, 'Jenelle Smidmor', 1, '10/19/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1749, 'Brennan Gregh', 0, '4/10/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1750, 'Queenie Withrington', 0, '3/12/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1751, 'Sunshine Coiley', 1, '3/16/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1752, 'Whitman Danilin', 1, '10/18/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1753, 'Lisetta Burlingame', 1, '5/19/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1754, 'Taddeusz Brocklesby', 1, '2/3/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1755, 'Gregory Serrell', 1, '6/14/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1756, 'Michaela Hedin', 0, '10/21/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1757, 'Ellissa Shilton', 0, '1/31/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1758, 'Wileen Parmer', 0, '10/8/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1759, 'Ailina O''Sharkey', 0, '1/10/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1760, 'Cullin Custed', 1, '12/7/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1761, 'Amanda Arnell', 1, '7/20/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1762, 'Orazio Karolovsky', 0, '11/3/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1763, 'Perry Tinton', 1, '8/20/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1764, 'Karlen Haskayne', 1, '2/28/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1765, 'Vin Ayce', 0, '2/24/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1766, 'Analise Bendare', 1, '11/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1767, 'Lavinia Demsey', 1, '11/9/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1768, 'Cyb Schankel', 1, '4/9/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1769, 'Dorian Rutigliano', 1, '12/6/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1770, 'Danya Sparkwell', 0, '5/7/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1771, 'Aube Ibbotson', 0, '4/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1772, 'Jeni Pessold', 0, '1/31/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1773, 'Donnell Headly', 1, '9/26/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1774, 'Zorine Clackson', 1, '8/13/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1775, 'Godiva Carsberg', 0, '9/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1776, 'Hebert Overell', 1, '4/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1777, 'Sena Nevison', 1, '5/13/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1778, 'Carlen Strathdee', 0, '2/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1779, 'Nari Woolf', 1, '12/1/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1780, 'Elisha Caldroni', 0, '8/7/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1781, 'Lainey Dulton', 1, '6/5/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1782, 'Peggy Kirby', 0, '1/29/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1783, 'Vickie Warret', 0, '6/29/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1784, 'Gardener Penticoot', 0, '2/8/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1785, 'Eleni Gurry', 0, '5/27/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1786, 'Bidget Purvis', 0, '12/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1787, 'Eloisa Dayborne', 1, '4/21/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1788, 'Dani Tresise', 1, '11/20/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1789, 'Griff Giacoppoli', 0, '12/1/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1790, 'Stern Huton', 1, '11/29/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1791, 'Dom Leve', 1, '5/27/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1792, 'Veronique Skyrm', 0, '5/12/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1793, 'Remy Mathison', 0, '12/25/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1794, 'Hettie Kitney', 1, '6/12/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1795, 'Benedict Alvar', 0, '4/6/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1796, 'Katinka Tarbox', 1, '12/10/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1797, 'Kellsie Hammerson', 0, '10/7/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1798, 'Pattie Wilshin', 1, '6/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1799, 'Mimi Hollebon', 0, '3/16/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1800, 'Gottfried McCaughey', 0, '1/14/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1801, 'Olimpia Revington', 1, '9/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1802, 'Jephthah Lindsay', 0, '1/31/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1803, 'Saleem Mason', 1, '5/24/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1804, 'Valene Sallery', 0, '8/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1805, 'Pat Calbrathe', 1, '1/7/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1806, 'Cobb Kentwell', 0, '12/21/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1807, 'Suzy Mattisssen', 1, '5/16/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1808, 'Derrek Latliff', 1, '1/8/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1809, 'Madelaine Evamy', 0, '8/31/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1810, 'Pepi Beig', 1, '9/20/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1811, 'Raffarty Hizir', 0, '4/7/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1812, 'Tamqrah Martinelli', 0, '10/3/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1813, 'Kathye Melbert', 0, '6/15/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1814, 'Wandie Rowsel', 1, '4/21/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1815, 'Eloise Huntley', 0, '6/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1816, 'Mead Dedam', 1, '9/26/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1817, 'Lori Simchenko', 1, '12/10/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1818, 'Jerrie Bixley', 0, '6/25/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1819, 'Giffy Killelea', 0, '10/31/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1820, 'Nixie Storah', 0, '2/16/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1821, 'Ramonda Marrow', 1, '1/9/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1822, 'Franciska Vosper', 0, '12/26/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1823, 'Helena Dellenbroker', 1, '11/13/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1824, 'Reilly Volett', 1, '3/4/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1825, 'Garnette Harcus', 0, '12/12/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1826, 'Kamillah Iacomini', 0, '10/4/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1827, 'Windham Vauls', 0, '8/17/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1828, 'Ursola Deesly', 1, '12/3/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1829, 'Chrystal Laslett', 1, '1/20/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1830, 'Sibyl Pinnick', 1, '6/13/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1831, 'Almeta Drillot', 1, '8/19/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1832, 'Vern Chaplin', 1, '6/18/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1833, 'Cyrillus Starrs', 1, '11/12/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1834, 'Benita Castelyn', 0, '7/2/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1835, 'Abba Plampin', 0, '8/4/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1836, 'Zed Crayke', 0, '4/27/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1837, 'Devora Maryet', 0, '1/22/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1838, 'Annnora Dufour', 0, '3/31/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1839, 'Marnia Rivett', 1, '8/31/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1840, 'Guinna Fiorentino', 1, '2/20/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1841, 'Anatola Wraggs', 1, '2/28/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1842, 'Reuben Buzzing', 0, '9/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1843, 'Salvidor Griffe', 0, '4/10/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1844, 'Alexa Hartington', 1, '6/25/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1845, 'Elwira Morillas', 1, '7/7/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1846, 'Blondell Godman', 0, '8/5/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1847, 'Gerhardine Schuricke', 0, '10/20/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1848, 'Jilly Rubega', 0, '1/8/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1849, 'Bronny Kerswell', 1, '10/21/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1850, 'Marilin Zienkiewicz', 0, '6/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1851, 'Elvin Vondracek', 0, '1/13/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1852, 'Natassia Mellenby', 1, '11/26/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1853, 'Gradey Gleasane', 1, '7/5/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1854, 'Garner Dawe', 0, '12/6/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1855, 'Astra Ferrant', 1, '1/31/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1856, 'Tori Brydson', 0, '1/11/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1857, 'Lawry Woolford', 0, '12/30/1970');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1858, 'Pebrook Moyler', 1, '4/5/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1859, 'Wylie Hazleton', 0, '5/31/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1860, 'Merry Steutly', 0, '5/25/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1861, 'Aggie Cobbald', 1, '12/30/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1862, 'Symon Kemme', 1, '9/18/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1863, 'Richy Rawnsley', 0, '7/18/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1864, 'Lloyd Querree', 1, '12/9/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1865, 'Julianna Pollicatt', 1, '7/17/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1866, 'Thaddus Rubinek', 0, '7/19/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1867, 'Chickie Pawelec', 0, '1/27/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1868, 'Wini Tallyn', 0, '10/29/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1869, 'Marris Emmer', 1, '8/24/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1870, 'Brandy Attack', 0, '6/23/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1871, 'Jilli Yeates', 0, '1/21/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1872, 'Leola Rosie', 1, '6/17/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1873, 'Linn Baskerfield', 1, '12/26/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1874, 'Aimil Foxall', 0, '4/29/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1875, 'Chic O''Kinedy', 0, '4/26/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1876, 'Alf O''Kynsillaghe', 0, '1/21/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1877, 'Kasey Josuweit', 1, '7/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1878, 'Elly Norcott', 0, '11/20/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1879, 'Meaghan Geake', 1, '1/9/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1880, 'Gabbie Maydway', 0, '8/11/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1881, 'Torin Andrieu', 1, '2/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1882, 'Baudoin Graeme', 1, '1/12/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1883, 'Horton Brunke', 0, '1/12/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1884, 'Dermot Thews', 0, '11/7/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1885, 'Yorke Highway', 1, '1/17/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1886, 'Aldridge Meadows', 1, '12/10/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1887, 'Rennie Van Der Straaten', 0, '12/31/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1888, 'Bonnee Checcucci', 1, '6/21/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1889, 'Philis Ibberson', 1, '11/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1890, 'Ulrike Pratton', 0, '5/20/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1891, 'Winnie Fraine', 1, '12/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1892, 'Balduin Godart', 0, '12/31/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1893, 'Tabb Dubois', 0, '3/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1894, 'Conny Dodsley', 1, '2/5/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1895, 'Miranda Sarl', 0, '11/20/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1896, 'Caz Fowells', 0, '3/9/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1897, 'Riobard Yorston', 0, '9/30/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1898, 'Elisha Scain', 0, '12/13/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1899, 'Germaine Kunkel', 0, '9/8/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1900, 'Margret Sleite', 1, '3/15/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1901, 'Skipton Hilldrup', 0, '6/28/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1902, 'Lind Romi', 1, '5/15/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1903, 'Carolina Ivshin', 0, '4/23/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1904, 'Marisa Culham', 0, '9/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1905, 'Rebe Schulter', 1, '12/28/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1906, 'Adda Goodship', 1, '1/19/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1907, 'Lesley Ballantine', 0, '8/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1908, 'Dorothea Buckenhill', 0, '2/12/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1909, 'Maritsa Stefanovic', 1, '11/27/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1910, 'Keriann Cockett', 0, '9/29/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1911, 'Lonnie Copper', 0, '3/31/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1912, 'Stormi Schenkel', 1, '2/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1913, 'Tricia Proud', 1, '3/5/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1914, 'Starla Canfer', 0, '4/8/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1915, 'Sandra Lambregts', 0, '5/26/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1916, 'Merlina Harrop', 1, '3/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1917, 'Anatol Kerins', 0, '2/16/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1918, 'Morna Dorracott', 0, '6/4/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1919, 'Urban Mazillius', 0, '11/15/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1920, 'Tawsha Dagworthy', 0, '1/15/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1921, 'Shandeigh Phoenix', 1, '12/4/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1922, 'Blakelee Prier', 1, '12/12/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1923, 'Ines Clilverd', 0, '10/30/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1924, 'Cinda Smeal', 0, '5/24/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1925, 'Tricia Vanyushin', 0, '7/20/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1926, 'Garrard Balser', 1, '6/27/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1927, 'Ki Lithgow', 0, '7/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1928, 'Nicolle O''Doohaine', 0, '8/11/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1929, 'Parrnell Machel', 1, '7/19/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1930, 'Ezmeralda Ubanks', 0, '11/12/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1931, 'Emile Mulliner', 1, '12/13/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1932, 'Saunderson Di Biaggi', 0, '9/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1933, 'Trude Ilchenko', 0, '8/25/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1934, 'Adah Minichi', 1, '11/28/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1935, 'Nertie Treverton', 1, '1/21/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1936, 'Reggie Castanone', 1, '7/26/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1937, 'Talbot Isac', 1, '10/30/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1938, 'Whitney Lightbody', 0, '1/1/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1939, 'Noelyn Leadstone', 1, '1/30/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1940, 'Ariela Meakes', 0, '2/20/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1941, 'Pierson Bresman', 1, '7/27/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1942, 'Obadiah Danilyuk', 1, '9/1/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1943, 'Worden Gatteridge', 1, '3/10/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1944, 'Hilarius Benting', 0, '7/13/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1945, 'Emmey Burwin', 1, '6/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1946, 'Ebenezer Forgie', 1, '11/21/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1947, 'Solomon Leopard', 0, '6/30/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1948, 'Gustavo Mashal', 0, '8/9/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1949, 'Hamil McCutcheon', 1, '6/8/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1950, 'Bethanne Beadnell', 1, '7/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1951, 'Dulcea Baldoni', 1, '11/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1952, 'Stormie Kennler', 0, '9/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1953, 'Gnni Senchenko', 0, '6/15/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1954, 'Gwyneth Ripsher', 0, '9/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1955, 'Elinore Offield', 1, '11/19/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1956, 'Willie Ferentz', 0, '8/1/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1957, 'Edy Biddleston', 1, '3/5/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1958, 'Bliss Mollen', 0, '2/22/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1959, 'Christin Mertgen', 1, '5/4/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1960, 'Kalinda MacCahey', 1, '3/11/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1961, 'Obidiah Cary', 0, '7/30/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1962, 'Bart Davidow', 1, '7/13/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1963, 'Winni Presslee', 0, '9/13/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1964, 'Wolfie Penwright', 1, '12/4/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1965, 'Adolphus Gorden', 1, '12/4/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1966, 'Dunc Skinley', 1, '5/14/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1967, 'Beverie Dinesen', 0, '1/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1968, 'Brittney Langrick', 0, '5/2/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1969, 'Othella Kinde', 0, '10/12/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1970, 'Kilian Lawless', 1, '8/22/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1971, 'Rudd Spelsbury', 0, '9/7/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1972, 'Chiarra Pestricke', 1, '9/30/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1973, 'Janeva Brougham', 1, '1/2/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1974, 'Thedric Imlacke', 0, '6/15/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1975, 'Grethel Hullett', 0, '1/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1976, 'Shurlock Neale', 0, '7/2/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1977, 'Hermina Crolly', 1, '1/2/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1978, 'Shanta Filyakov', 0, '4/8/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1979, 'Brigit Wichard', 1, '6/19/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1980, 'Nicol Govern', 1, '5/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1981, 'Jasmin Kirby', 0, '7/22/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1982, 'Malissia Mews', 1, '3/7/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1983, 'Jobyna Bonavia', 1, '9/11/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1984, 'Theresina Huetson', 1, '10/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1985, 'Douglas Vella', 1, '7/3/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1986, 'Marianna Seiler', 1, '11/7/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1987, 'Delbert Kohneke', 0, '6/11/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1988, 'Douglas Garr', 1, '6/17/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1989, 'Carly Philippsohn', 1, '5/9/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1990, 'Pembroke Brimilcombe', 1, '2/8/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1991, 'Rikki Bachanski', 1, '5/24/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1992, 'Kayla Boribal', 1, '6/26/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1993, 'Corby Realph', 0, '5/17/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1994, 'Cheryl Laba', 1, '10/11/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1995, 'Jewel Rapelli', 0, '4/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1996, 'Donn Wilsdon', 1, '9/15/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1997, 'Dosi Brilon', 1, '3/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1998, 'Shadow Yankishin', 1, '1/15/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (1999, 'Timothea Wigfall', 1, '3/24/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2000, 'Dredi Currie', 1, '9/27/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2001, 'Vale Mungan', 1, '8/31/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2002, 'Corena Dackombe', 1, '4/20/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2003, 'Jany Margeram', 1, '3/29/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2004, 'Dionisio Cleatherow', 1, '7/26/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2005, 'Renado Stuchberry', 0, '1/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2006, 'Amalee Giannazzi', 1, '1/9/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2007, 'Frasier Kolinsky', 1, '7/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2008, 'Lynnette Yarwood', 1, '7/25/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2009, 'Lissa Usherwood', 1, '5/11/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2010, 'Ilene Bonellie', 0, '3/10/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2011, 'Daisie Kieff', 0, '9/1/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2012, 'Rozamond Krysztofiak', 0, '7/31/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2013, 'Delia Honeywood', 1, '2/27/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2014, 'Nixie Allston', 0, '8/4/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2015, 'Bernie Bouch', 1, '1/1/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2016, 'Greta Piggen', 0, '7/3/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2017, 'Mirella Pettman', 1, '6/28/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2018, 'Phineas Challice', 0, '6/25/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2019, 'Raven O''Flaherty', 0, '10/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2020, 'Esra Saffe', 0, '7/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2021, 'Salli Giacovazzo', 0, '5/8/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2022, 'Beauregard Dowthwaite', 0, '1/3/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2023, 'Deirdre Stokes', 0, '2/15/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2024, 'Arty Godbert', 1, '9/25/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2025, 'Killie Loidl', 1, '5/14/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2026, 'Luke Gibbons', 0, '1/18/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2027, 'Eamon Rasp', 1, '6/20/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2028, 'Maure Simoncini', 1, '12/25/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2029, 'Silvano Sutch', 1, '11/22/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2030, 'Halimeda Kinleyside', 1, '5/19/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2031, 'Khalil Nowill', 1, '3/29/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2032, 'Mair Dainty', 0, '3/15/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2033, 'Thaddeus Kik', 1, '12/4/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2034, 'Vassily Hewes', 1, '5/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2035, 'Hedy Hamly', 0, '10/2/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2036, 'Lolita Natalie', 1, '9/28/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2037, 'Randa Reville', 1, '12/19/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2038, 'Tabbitha Longfut', 0, '9/14/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2039, 'Rurik Carden', 0, '8/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2040, 'Jennie Suggey', 1, '4/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2041, 'Edgardo Stebbins', 0, '10/27/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2042, 'Merralee Dominelli', 0, '7/26/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2043, 'Aymer Lanchbery', 0, '8/21/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2044, 'Karlens Akaster', 0, '6/6/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2045, 'Devlen Badger', 1, '2/26/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2046, 'Saunderson Temperley', 0, '11/21/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2047, 'Bill Cartman', 0, '9/2/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2048, 'Glenden Ewen', 1, '2/28/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2049, 'Stafford Halgarth', 0, '7/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2050, 'Everett Bevir', 1, '2/26/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2051, 'Inga Favel', 0, '12/25/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2052, 'Augie Braisby', 0, '9/20/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2053, 'Kessiah Malletratt', 1, '10/22/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2054, 'Constantin Dalliwater', 0, '2/28/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2055, 'Arlene de Werk', 1, '2/22/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2056, 'Ward Douris', 1, '2/7/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2057, 'Kirstyn MacCaughey', 0, '4/2/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2058, 'Garvy Sword', 0, '9/12/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2059, 'Jeremias Cuthbert', 1, '12/16/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2060, 'Candice Dosdill', 0, '2/3/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2061, 'Kath Bolver', 0, '9/24/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2062, 'Arty de Amaya', 1, '6/17/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2063, 'Stephanus Heathcoat', 0, '6/13/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2064, 'Ryan Gookes', 0, '9/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2065, 'Willi Wager', 0, '4/13/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2066, 'Lianne Jee', 1, '1/30/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2067, 'Janean Mayer', 1, '7/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2068, 'Theresita Mahmood', 1, '9/22/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2069, 'Asa Ruoss', 0, '4/7/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2070, 'Cyb Demageard', 0, '9/15/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2071, 'Terence Antognazzi', 1, '10/7/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2072, 'Valaria Rowlett', 1, '10/31/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2073, 'Ham Polak', 0, '1/9/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2074, 'Ryun Prichet', 0, '5/29/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2075, 'Murray Puzey', 0, '7/23/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2076, 'Thoma Aikin', 0, '6/23/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2077, 'Billy Jakel', 1, '7/1/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2078, 'Sarita Fanshawe', 0, '4/28/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2079, 'Evaleen Tuddall', 0, '8/13/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2080, 'Yolande Kynoch', 0, '3/21/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2081, 'Evelina McDill', 1, '10/19/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2082, 'Aili Cossam', 0, '7/9/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2083, 'Bathsheba Dorwood', 1, '5/21/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2084, 'Patten McLardie', 0, '2/16/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2085, 'Aymer Heathcoat', 1, '2/10/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2086, 'Kristina Pavitt', 0, '9/19/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2087, 'Teddy Boylund', 0, '3/16/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2088, 'Emlen McQuilliam', 1, '12/13/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2089, 'Glynn Audenis', 0, '5/25/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2090, 'Ellerey Merveille', 1, '7/30/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2091, 'Nada Wyd', 1, '3/14/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2092, 'Shea Dorrian', 0, '12/3/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2093, 'Janela Woodwing', 0, '5/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2094, 'Selle Maffioni', 1, '12/5/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2095, 'Dwight Blemen', 0, '7/23/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2096, 'Terry Stockney', 1, '5/16/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2097, 'Bradford Quincey', 0, '5/13/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2098, 'Sidnee Woodham', 1, '9/28/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2099, 'Boyce O''Hanley', 0, '4/18/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2100, 'Jordanna Shercliff', 0, '1/25/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2101, 'Eunice Peter', 0, '7/25/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2102, 'Phineas Birth', 0, '11/20/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2103, 'Carlota Thornborrow', 0, '5/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2104, 'Jervis Sygroves', 0, '8/19/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2105, 'Jerrine Goreway', 0, '12/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2106, 'Brena Merigon', 0, '7/26/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2107, 'Dukie Duns', 0, '3/16/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2108, 'Analiese Kemball', 0, '4/22/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2109, 'Harlen Pretsell', 0, '5/5/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2110, 'Llywellyn Grissett', 0, '8/28/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2111, 'Berenice Schwartz', 0, '3/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2112, 'Dario Ortega', 0, '9/5/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2113, 'Alard Henner', 0, '11/19/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2114, 'Anatol Epple', 0, '12/8/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2115, 'Reginauld Rosgen', 0, '6/3/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2116, 'Michael Skuce', 0, '12/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2117, 'Ruttger Jeannenet', 0, '4/9/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2118, 'Candace Stanner', 0, '2/6/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2119, 'Aldon Orpwood', 0, '8/2/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2120, 'Shanna Cheal', 1, '12/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2121, 'Hercule McGrorty', 1, '9/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2122, 'Berna Ordish', 0, '10/29/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2123, 'Juliann O''Brogan', 1, '3/11/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2124, 'Ruperta Rodrig', 0, '7/24/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2125, 'Davide Payfoot', 0, '4/26/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2126, 'Yoko Geraghty', 1, '1/4/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2127, 'Todd Alred', 0, '5/13/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2128, 'Erick Leverington', 1, '5/11/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2129, 'Sauncho Cortnay', 1, '6/21/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2130, 'Clerissa Keer', 0, '7/16/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2131, 'Lorettalorna McCorley', 1, '4/23/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2132, 'Devi Marzellano', 1, '6/19/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2133, 'Krispin Brash', 0, '10/13/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2134, 'Vi MacTavish', 1, '8/27/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2135, 'Torr Clearley', 0, '12/15/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2136, 'Rhonda Cockill', 0, '8/22/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2137, 'Glen Maffini', 1, '10/11/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2138, 'Calla Josifovic', 1, '8/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2139, 'Albrecht Dottridge', 1, '8/13/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2140, 'Wandie Haking', 1, '8/28/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2141, 'Davida Brydell', 0, '12/9/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2142, 'Alair Sanbrooke', 1, '3/21/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2143, 'Olva Indruch', 1, '6/20/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2144, 'Dwayne Biggadike', 1, '12/14/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2145, 'Garwood Allom', 0, '5/26/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2146, 'Lulita Nitti', 1, '8/13/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2147, 'Whitney O''Glessane', 0, '12/28/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2148, 'Jory McReath', 1, '4/11/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2149, 'Warner Cowell', 0, '2/3/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2150, 'Jedidiah Beneteau', 1, '12/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2151, 'Opal Blacket', 1, '5/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2152, 'Carlina Denisot', 1, '4/17/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2153, 'Portie Venton', 0, '9/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2154, 'Filippo Eynald', 1, '12/21/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2155, 'Timmi Leagas', 0, '1/8/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2156, 'Ki Folling', 0, '4/22/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2157, 'Haslett Sarton', 0, '9/21/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2158, 'Hayward Lansdowne', 1, '3/12/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2159, 'Julieta Davidman', 1, '8/22/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2160, 'Lauren Cohr', 0, '10/29/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2161, 'Stormie Forge', 1, '8/22/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2162, 'Yoko Colisbe', 1, '1/16/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2163, 'Hedy Ianno', 1, '7/30/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2164, 'Granthem Bento', 1, '4/22/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2165, 'Honor Goodwill', 1, '4/26/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2166, 'Duke Eathorne', 1, '1/5/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2167, 'Conant Starr', 1, '6/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2168, 'Thomasa Denisovich', 0, '2/1/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2169, 'Hector Bleything', 0, '12/6/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2170, 'Kermie Jorg', 1, '12/9/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2171, 'Corbet Streat', 1, '12/14/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2172, 'Isa Raspin', 0, '10/9/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2173, 'Bayard Dugall', 0, '12/31/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2174, 'Trumann Albinson', 0, '1/4/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2175, 'Joana Garth', 1, '10/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2176, 'Bendix Hitzmann', 1, '11/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2177, 'Kamillah Swindells', 1, '11/23/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2178, 'Tami McKinnon', 1, '9/15/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2179, 'Matelda Wardingly', 0, '10/9/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2180, 'Georgie Izkovicz', 1, '6/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2181, 'Katrine Cromarty', 0, '10/15/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2182, 'Rhona Haycraft', 0, '1/16/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2183, 'Armin Mapletoft', 0, '4/21/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2184, 'Anita Basnett', 1, '10/27/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2185, 'Emelyne Fayers', 1, '11/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2186, 'Shae Miebes', 0, '4/6/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2187, 'Lexy Clendening', 1, '5/10/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2188, 'Nicola Elsmor', 1, '8/17/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2189, 'Wilden Hellis', 1, '8/15/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2190, 'Hamnet Welbrock', 0, '7/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2191, 'Bart Extil', 1, '4/15/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2192, 'Bron Vedikhov', 0, '3/29/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2193, 'Gunner Sauvain', 0, '3/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2194, 'Ron Bevir', 0, '3/10/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2195, 'Kelcey Montier', 1, '2/18/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2196, 'Bendicty Cranny', 1, '2/9/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2197, 'Glendon Kubicki', 1, '3/30/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2198, 'Cory Abden', 0, '2/22/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2199, 'Belvia Banbridge', 1, '8/13/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2200, 'Sherwin Pech', 1, '6/2/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2201, 'Constantin Charnick', 0, '3/23/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2202, 'Woodie Broadwell', 0, '6/2/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2203, 'Valentine Crace', 1, '10/28/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2204, 'Gerhardine Woodhouse', 1, '7/7/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2205, 'Reece Cartan', 1, '3/30/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2206, 'Jana Ninotti', 0, '11/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2207, 'Branden Desport', 0, '8/16/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2208, 'Annabella Lohan', 1, '12/5/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2209, 'Andrus Gaskin', 1, '11/25/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2210, 'Pavlov Mander', 1, '7/10/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2211, 'Filbert Kummerlowe', 0, '3/2/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2212, 'Kayne Storres', 1, '2/22/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2213, 'Rozalie Essex', 1, '3/8/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2214, 'Stefania Cassy', 1, '3/27/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2215, 'Midge Eake', 1, '2/16/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2216, 'Innis Strick', 0, '4/6/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2217, 'Bernadine Yvens', 0, '5/21/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2218, 'Elmer Lucia', 0, '10/21/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2219, 'Vincents Brouard', 0, '8/7/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2220, 'Nerte Manwell', 0, '9/5/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2221, 'Fanechka Pickard', 0, '8/22/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2222, 'Merilyn Leeke', 0, '10/27/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2223, 'Arlene Easson', 1, '9/21/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2224, 'Berte Hampton', 1, '7/17/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2225, 'Ardelis Ceschi', 1, '2/6/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2226, 'Aube Vasilyevski', 0, '2/1/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2227, 'Pier Bearham', 0, '4/14/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2228, 'Nissie Woodfin', 0, '8/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2229, 'Sancho Neggrini', 0, '4/12/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2230, 'Tabbitha Echalier', 0, '3/26/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2231, 'Cristie Whiles', 1, '2/10/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2232, 'Marion Piquard', 0, '1/22/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2233, 'Abraham Semrad', 0, '10/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2234, 'Janella Thornber', 1, '8/5/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2235, 'Godiva Roebottom', 1, '8/20/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2236, 'Sylas Sach', 0, '4/12/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2237, 'Rubia Mitford', 0, '10/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2238, 'Temple Bliben', 0, '4/16/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2239, 'Laurens Boays', 0, '11/18/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2240, 'Vincenty Bygrave', 0, '7/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2241, 'Mar Giacobbo', 0, '9/20/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2242, 'Adaline Killoran', 0, '7/17/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2243, 'Renard Ruseworth', 0, '9/18/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2244, 'Cesare Musico', 1, '4/10/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2245, 'Essie Dudney', 0, '5/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2246, 'Maryanna McKinie', 0, '1/28/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2247, 'Ysabel Shann', 1, '8/1/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2248, 'Bartholemy Labden', 1, '4/6/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2249, 'Abagail Foucar', 1, '11/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2250, 'Salli Jagels', 0, '4/22/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2251, 'Kristian L''Episcopi', 1, '12/26/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2252, 'Benyamin Dantesia', 0, '9/22/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2253, 'Kaela Shillabear', 0, '9/28/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2254, 'Claudianus Asquez', 0, '11/5/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2255, 'Claybourne Masters', 1, '7/18/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2256, 'Mariellen Tolliday', 0, '12/8/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2257, 'Leigh Petrelli', 1, '5/21/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2258, 'Madelene Robertucci', 0, '1/30/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2259, 'Mel Ickovits', 0, '1/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2260, 'Albertina Prest', 0, '1/19/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2261, 'Meredith Glassard', 1, '1/19/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2262, 'Arluene Sargint', 0, '7/6/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2263, 'Tasia Gebbie', 1, '7/8/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2264, 'Carmelita Pimer', 0, '6/27/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2265, 'Alyse Tappor', 0, '6/5/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2266, 'Kelley Kornes', 0, '5/29/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2267, 'Karie Codd', 0, '6/26/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2268, 'Chiquita Ketchell', 1, '2/3/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2269, 'Jeanne Vandenhoff', 1, '10/17/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2270, 'Roma Plester', 1, '7/12/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2271, 'Lonnie Chipman', 0, '7/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2272, 'Silvana Cardnell', 1, '4/11/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2273, 'Abbie Sherreard', 0, '1/19/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2274, 'Annabella Grolmann', 1, '8/18/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2275, 'Jeremie Galiero', 0, '11/10/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2276, 'Quinn Tosney', 1, '6/2/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2277, 'Susanetta Calafato', 1, '4/20/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2278, 'Anthony Cron', 1, '7/17/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2279, 'Bari Yate', 0, '2/25/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2280, 'Wadsworth Reddel', 0, '9/18/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2281, 'Benjie Kellart', 0, '9/6/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2282, 'Bamby Cottingham', 1, '11/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2283, 'Karleen Yukhnov', 0, '2/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2284, 'Gabriele Hillett', 0, '8/20/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2285, 'Jonah Berriball', 1, '3/17/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2286, 'Gusty Zanicchelli', 1, '3/14/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2287, 'Danna Lightfoot', 0, '4/6/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2288, 'Paule Gude', 1, '9/7/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2289, 'Gardner MacHoste', 1, '11/20/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2290, 'Nicolea Tiernan', 1, '4/30/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2291, 'Charmion Tuttle', 0, '10/18/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2292, 'Tamas Skyrm', 1, '1/30/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2293, 'Ines Dametti', 1, '6/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2294, 'Ahmad Greenroa', 0, '9/6/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2295, 'Rudiger Straneo', 1, '11/2/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2296, 'Desmond Templeman', 1, '5/10/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2297, 'Artie Kunath', 1, '3/21/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2298, 'Jabez McCaughran', 0, '8/24/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2299, 'Matthiew Pyffe', 0, '2/8/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2300, 'Trix Tiernan', 1, '5/21/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2301, 'Sim Chuck', 0, '8/21/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2302, 'Zonnya Goard', 1, '6/21/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2303, 'Sawyer Lehenmann', 1, '11/6/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2304, 'Goraud Casero', 0, '12/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2305, 'Arnuad Barthelme', 1, '6/4/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2306, 'Liz Lisle', 1, '9/2/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2307, 'Anabal Seale', 0, '5/20/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2308, 'Marcella Blazi', 1, '8/20/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2309, 'Jazmin Fasey', 1, '5/25/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2310, 'Ignaz McSaul', 0, '12/19/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2311, 'Sandy Frayling', 1, '5/13/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2312, 'Sax Aleevy', 1, '9/8/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2313, 'Godfree Horstead', 1, '3/11/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2314, 'Jinny Lashford', 1, '1/20/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2315, 'Robbin Penhalurick', 1, '8/7/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2316, 'Antonie Reckhouse', 1, '5/21/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2317, 'Guthry Michieli', 1, '7/3/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2318, 'Hendrik Klassman', 0, '11/13/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2319, 'Terence Cunningham', 1, '6/26/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2320, 'Maryann Paddison', 0, '7/9/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2321, 'Carlynne Kingswoode', 1, '9/30/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2322, 'Gabriella Cotty', 0, '5/12/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2323, 'Giacinta Dobkin', 0, '8/12/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2324, 'Man Djokic', 1, '7/27/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2325, 'Jacquette Gummer', 1, '9/23/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2326, 'Scott Gonnelly', 0, '5/21/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2327, 'Georgette Kittow', 1, '11/14/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2328, 'Sarette Brumwell', 0, '8/19/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2329, 'Lucia Joplin', 0, '10/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2330, 'Latrina Naulty', 0, '10/9/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2331, 'Kacey Snedker', 0, '7/24/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2332, 'Cyndy Shirlaw', 0, '6/12/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2333, 'Aveline Prestner', 0, '8/12/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2334, 'Melanie Gaul', 0, '3/28/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2335, 'Rodge Dallywater', 1, '9/10/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2336, 'Adrian Rait', 1, '8/21/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2337, 'Lorin Wauchope', 0, '10/20/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2338, 'Anatole Tidbald', 1, '5/29/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2339, 'Sibby Housego', 1, '1/17/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2340, 'Talia Winsbury', 1, '1/2/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2341, 'Jillana Haster', 0, '8/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2342, 'Edith Battison', 0, '5/28/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2343, 'Margeaux Tubbles', 0, '10/20/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2344, 'Conroy Padbury', 1, '12/6/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2345, 'Doria Fairhead', 0, '2/12/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2346, 'Jill Oakenfall', 1, '7/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2347, 'Wallas Lilloe', 0, '10/31/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2348, 'Currey Couronne', 1, '8/7/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2349, 'Cord Ellif', 0, '10/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2350, 'Miguel Massen', 1, '5/30/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2351, 'Melany MacGorley', 0, '10/10/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2352, 'Justino Matzel', 0, '12/3/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2353, 'Pauly Avramov', 0, '3/27/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2354, 'Cleopatra Bertin', 0, '11/11/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2355, 'Jacklin Jaggi', 1, '9/9/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2356, 'Anabelle Juliano', 1, '8/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2357, 'Derrek Daskiewicz', 0, '3/23/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2358, 'Maribeth Yoxall', 0, '12/19/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2359, 'Emelyne Brameld', 1, '11/7/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2360, 'Brandy Heaphy', 1, '6/29/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2361, 'Elise Englishby', 0, '5/2/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2362, 'Anitra McPake', 1, '6/1/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2363, 'Hewett Sherebrooke', 1, '11/10/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2364, 'Idalina Strank', 1, '8/2/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2365, 'Nanine Ridewood', 0, '11/1/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2366, 'Mireielle Loxdale', 0, '12/19/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2367, 'Kipper Jaze', 0, '4/29/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2368, 'Alika Haeslier', 0, '12/16/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2369, 'Constanta Divill', 0, '1/22/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2370, 'Merla Crolly', 1, '7/2/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2371, 'Trudey Vasyatkin', 1, '4/22/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2372, 'Obidiah Woodhead', 1, '5/31/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2373, 'Dael Ogilvie', 0, '2/5/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2374, 'Angelo Gannicleff', 1, '12/7/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2375, 'Willi D''Antonio', 1, '2/19/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2376, 'Henderson Lineen', 0, '11/26/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2377, 'Christiano Winkell', 1, '6/21/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2378, 'Freeman Gleeton', 1, '10/31/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2379, 'Kelcie Stump', 0, '7/23/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2380, 'Alfy Karlmann', 0, '6/28/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2381, 'Merci Banham', 0, '9/29/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2382, 'Agathe Butchers', 0, '5/13/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2383, 'Bail Cahalan', 1, '12/19/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2384, 'Gerrie Rosenkranc', 0, '8/19/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2385, 'Freddi Keijser', 1, '3/5/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2386, 'Christoper Perri', 0, '11/23/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2387, 'Costanza Ludgate', 1, '7/5/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2388, 'Doll Toor', 0, '12/4/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2389, 'Hatty Hinkins', 1, '9/9/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2390, 'Lorne Thain', 0, '10/31/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2391, 'Morten Bischop', 1, '4/24/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2392, 'Jillana Cade', 1, '7/2/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2393, 'Kristy Janecek', 0, '10/4/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2394, 'Sarge Tuminelli', 0, '1/20/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2395, 'Josephine Davers', 0, '8/14/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2396, 'Flin Antoniou', 1, '1/12/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2397, 'Alessandra Candelin', 1, '6/10/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2398, 'Kristien Ellwand', 1, '6/7/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2399, 'Geri Matfin', 1, '9/3/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2400, 'Paton Van der Brugge', 1, '10/1/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2401, 'Gianni Strowan', 1, '9/23/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2402, 'Geoffry Walkey', 1, '4/30/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2403, 'Monique Straughan', 1, '1/11/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2404, 'Aleen Finan', 1, '10/26/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2405, 'Asher D''Angeli', 0, '7/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2406, 'Ermina Carman', 1, '1/24/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2407, 'Katusha Tunbridge', 0, '12/21/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2408, 'Faulkner MacRirie', 0, '12/19/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2409, 'Frankie Keats', 0, '11/28/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2410, 'Belia O''Farris', 0, '4/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2411, 'Lorry Krollman', 0, '3/29/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2412, 'Casper Walmsley', 0, '10/12/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2413, 'Shaw Golby', 0, '11/29/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2414, 'Cally Helix', 0, '3/18/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2415, 'Teri Pickavant', 1, '11/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2416, 'Viola Moller', 0, '12/7/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2417, 'Ryon Cavilla', 0, '1/1/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2418, 'Julina D''Oyly', 0, '9/5/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2419, 'Camellia Scaplehorn', 1, '1/25/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2420, 'Karyl Boys', 0, '6/16/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2421, 'Alisander Mitkcov', 0, '10/3/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2422, 'Tine Filippozzi', 0, '4/14/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2423, 'Mavis Hefferan', 0, '9/19/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2424, 'Jourdain Coughlan', 0, '11/19/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2425, 'Andras Kempston', 0, '6/13/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2426, 'Cilka Huckfield', 1, '2/21/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2427, 'Tildi Broek', 0, '4/30/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2428, 'Leland Blade', 1, '6/28/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2429, 'Juieta Sellman', 1, '6/26/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2430, 'Gena Domnick', 0, '10/17/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2431, 'Robinetta Cardenoso', 0, '5/29/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2432, 'Chet Petrollo', 1, '4/6/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2433, 'Benedick Pendell', 1, '5/30/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2434, 'Brew Matuszinski', 1, '4/16/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2435, 'Teddie Chipman', 0, '10/24/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2436, 'Kiah Bull', 1, '7/23/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2437, 'Lilla Phelps', 0, '8/13/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2438, 'Elonore Younghusband', 0, '11/24/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2439, 'Fredrika Bratcher', 1, '1/14/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2440, 'Phelia Alonso', 0, '6/2/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2441, 'Niki Lorne', 0, '8/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2442, 'Toinette Batchellor', 0, '1/3/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2443, 'Curtis Castiglioni', 1, '4/8/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2444, 'Louis Tremberth', 0, '8/28/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2445, 'Madelle Cordelette', 1, '11/16/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2446, 'Elga Fooks', 1, '3/23/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2447, 'Darell Gatcliff', 1, '3/19/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2448, 'Early Cambden', 0, '10/16/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2449, 'Paco Gibbs', 0, '11/26/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2450, 'Perla Gritskov', 1, '11/13/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2451, 'Kathryn Riggeard', 0, '1/25/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2452, 'Eleonora Rabley', 0, '2/6/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2453, 'Joline Thornally', 1, '1/27/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2454, 'Marcile Sturley', 0, '12/2/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2455, 'Xenos Clashe', 0, '7/21/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2456, 'Tobie Danielsky', 0, '8/9/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2457, 'Charlot Mennear', 0, '2/24/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2458, 'Anitra Hartlebury', 1, '4/11/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2459, 'Dorolisa Stuke', 1, '3/1/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2460, 'Ronnica Morfey', 1, '3/5/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2461, 'Lidia Bartrum', 0, '3/23/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2462, 'Sandye Litchfield', 0, '7/15/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2463, 'Tiphani Hannibal', 0, '8/18/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2464, 'Liva Dainty', 1, '11/25/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2465, 'Kelley Berger', 1, '3/9/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2466, 'Kellyann MacGinley', 1, '6/25/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2467, 'Leon Pragnell', 1, '8/11/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2468, 'Bink Have', 1, '10/12/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2469, 'Babbie Brandli', 1, '9/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2470, 'Lilia Jenteau', 1, '3/17/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2471, 'Rasia Baldry', 0, '4/18/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2472, 'Virgie Schiementz', 1, '1/8/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2473, 'Magdalen Thomkins', 1, '8/31/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2474, 'Austine Coppenhall', 1, '12/11/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2475, 'Wally Feore', 0, '7/29/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2476, 'Christal Woollcott', 1, '3/18/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2477, 'Vita Benkhe', 1, '6/15/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2478, 'Harley Bezemer', 0, '3/20/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2479, 'Winne Sleicht', 0, '3/29/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2480, 'Paulette Vinten', 1, '3/29/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2481, 'Mikael Kinworthy', 1, '11/21/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2482, 'Margi Gearty', 1, '12/31/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2483, 'Ellie Cawkill', 0, '12/19/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2484, 'Kacy Waghorn', 1, '2/21/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2485, 'Orv Rickwood', 1, '2/28/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2486, 'Paddy Gonzalvo', 1, '4/27/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2487, 'Brianne Keates', 1, '6/3/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2488, 'Michaela Smeall', 1, '2/26/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2489, 'Amalita Scholer', 0, '2/7/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2490, 'Marcel Sturges', 1, '4/23/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2491, 'Kimberly Kennan', 0, '4/19/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2492, 'Bronnie Dupoy', 1, '9/2/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2493, 'Jens De la Yglesia', 0, '1/18/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2494, 'Emilee Carson', 0, '5/18/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2495, 'Milli Tallant', 1, '12/29/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2496, 'Kary Smaleman', 0, '6/22/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2497, 'Jazmin Mealand', 1, '12/14/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2498, 'Petrina Collacombe', 0, '9/1/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2499, 'Costa Dow', 0, '5/31/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2500, 'Ezequiel Farn', 1, '10/16/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2501, 'Elfrieda Clegg', 1, '1/24/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2502, 'Nettle Sapsforde', 1, '8/2/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2503, 'Colin Sandiland', 1, '3/22/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2504, 'Arley Hoodlass', 1, '4/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2505, 'Anabal Beumant', 0, '4/19/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2506, 'Nehemiah D''Onisi', 1, '9/30/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2507, 'Konstantin Paskins', 1, '9/2/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2508, 'Juli Cecchi', 0, '2/13/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2509, 'Klarika Mincher', 0, '12/28/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2510, 'Ellyn Denes', 1, '12/25/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2511, 'Marabel Kirkam', 0, '5/24/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2512, 'Meriel Verbeek', 1, '11/10/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2513, 'Danni Okie', 0, '8/17/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2514, 'Minette Doull', 0, '8/6/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2515, 'Freemon Oughtright', 1, '10/26/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2516, 'Maribelle Clulow', 1, '12/30/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2517, 'Cody Ruckhard', 0, '7/22/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2518, 'Leora Mallett', 0, '12/25/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2519, 'Karlene Goracci', 1, '3/3/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2520, 'Weston Ianiello', 1, '12/14/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2521, 'Chelsea Edgerley', 1, '2/15/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2522, 'Alleyn Hinze', 1, '1/27/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2523, 'Seumas Gorgler', 1, '11/13/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2524, 'Woodrow Brownill', 1, '9/26/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2525, 'Tallia MacVagh', 0, '4/4/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2526, 'Jacquelyn Wanne', 0, '4/26/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2527, 'Aime Petkovic', 1, '7/8/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2528, 'Kira Trittam', 0, '3/23/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2529, 'Mar Olley', 1, '2/15/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2530, 'Dillon Dymick', 0, '11/28/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2531, 'Bobinette Raynor', 1, '3/22/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2532, 'Fabio Dulin', 0, '2/27/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2533, 'Shaine Markushkin', 1, '11/3/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2534, 'Billie Riseborough', 0, '2/3/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2535, 'Katharina Tombleson', 1, '1/12/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2536, 'Rudie Laughlin', 1, '11/7/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2537, 'Ciro Whapples', 1, '10/21/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2538, 'Wenona Lorraway', 1, '6/4/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2539, 'Rowe Hassent', 0, '7/22/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2540, 'Kain Gives', 1, '6/4/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2541, 'Geordie Orht', 0, '7/17/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2542, 'Royall Jennison', 0, '2/25/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2543, 'Hatty Mc Kellen', 1, '8/11/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2544, 'Tobin Cluely', 0, '4/20/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2545, 'Lawry Bruckmann', 0, '2/27/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2546, 'Aura Maddams', 0, '1/18/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2547, 'Martelle Zavattero', 1, '10/24/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2548, 'Yvonne Girardoni', 1, '12/3/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2549, 'Maris Sherebrook', 0, '1/3/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2550, 'Bancroft Morde', 0, '8/7/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2551, 'Byrle Morrilly', 1, '12/23/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2552, 'Pollyanna Kwietak', 1, '5/11/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2553, 'Lorenzo McKeaney', 0, '6/13/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2554, 'Merlina Whitely', 0, '5/25/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2555, 'Danell Chimenti', 1, '10/16/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2556, 'Raleigh Glaserman', 0, '7/15/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2557, 'Ephraim Sowden', 0, '12/18/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2558, 'Hercules Gaspard', 1, '12/19/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2559, 'Loleta Bacup', 0, '3/5/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2560, 'Ezmeralda Bagnall', 0, '12/23/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2561, 'Walker Kivlehan', 0, '11/23/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2562, 'Hurleigh Barenski', 1, '11/20/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2563, 'Cori Edmunds', 1, '10/30/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2564, 'Dru Threadgold', 1, '7/2/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2565, 'Caresse Roxbee', 0, '3/12/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2566, 'Idaline Wimes', 0, '6/3/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2567, 'Abran Goforth', 0, '5/5/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2568, 'Netta Rubinfajn', 0, '8/1/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2569, 'Bonnee Edgar', 1, '1/18/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2570, 'Fax Aggis', 1, '3/17/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2571, 'Melony Lynnitt', 1, '7/6/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2572, 'Nickola Longhorn', 0, '7/19/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2573, 'Rosalind Stitfall', 0, '8/22/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2574, 'Georgeta Tight', 1, '2/27/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2575, 'Cristina Scrowby', 1, '7/4/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2576, 'Nona Wayper', 1, '6/14/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2577, 'Chet Marchington', 0, '10/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2578, 'Saxe Klimentov', 1, '11/17/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2579, 'Caldwell Semor', 0, '7/3/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2580, 'Tim Pittford', 0, '10/4/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2581, 'Marta Files', 1, '4/17/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2582, 'Marta Allcorn', 0, '12/15/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2583, 'Gonzales Benner', 1, '12/13/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2584, 'Wood Chazelle', 0, '3/19/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2585, 'Kellen Cherryman', 0, '1/13/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2586, 'Lou Swallow', 0, '12/24/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2587, 'Misha Raoult', 0, '10/19/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2588, 'Brennen Nielson', 0, '6/4/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2589, 'Iosep Cheel', 0, '4/5/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2590, 'Deck McDougald', 1, '6/22/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2591, 'Emlynn Anniwell', 0, '4/9/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2592, 'Emmott Tremmil', 0, '9/15/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2593, 'Jeremiah Dimic', 1, '12/10/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2594, 'Tasia Jedraszczyk', 1, '10/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2595, 'Catherine Jurkiewicz', 1, '8/30/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2596, 'Wilden Monketon', 1, '3/23/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2597, 'Hercule Palle', 0, '7/19/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2598, 'Jorge Perfect', 0, '8/23/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2599, 'Lanni Hubbock', 0, '6/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2600, 'Robinette Dash', 1, '9/28/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2601, 'Leila Hendrickson', 1, '12/13/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2602, 'Brandtr Semarke', 0, '5/23/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2603, 'David Ibbotson', 0, '4/2/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2604, 'Fionnula MacPhail', 1, '12/2/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2605, 'Rosco Dacke', 0, '11/27/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2606, 'Erny Mangenot', 0, '10/31/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2607, 'Andros Willmer', 0, '12/13/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2608, 'Steward Curnok', 1, '7/2/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2609, 'Welbie covino', 1, '3/26/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2610, 'Sergei Edwardson', 1, '4/18/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2611, 'Dido Tzuker', 0, '2/25/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2612, 'Joleen Borres', 1, '9/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2613, 'Valdemar Alfonsini', 0, '11/1/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2614, 'Basilio Rustidge', 0, '8/16/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2615, 'Cher Gordge', 1, '7/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2616, 'Brigit Creavan', 0, '9/30/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2617, 'Lorilyn Jenken', 1, '8/14/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2618, 'Zulema Simmins', 0, '6/3/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2619, 'Waylan Swinden', 0, '7/31/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2620, 'Aurie Poter', 0, '10/7/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2621, 'Pavia MacGinlay', 0, '2/28/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2622, 'Roshelle Darville', 0, '1/29/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2623, 'Tersina Mehaffey', 1, '5/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2624, 'Roarke Duerdin', 0, '9/22/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2625, 'Camella Caramuscia', 1, '6/18/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2626, 'Joelly Goley', 0, '10/8/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2627, 'Murielle Jaquin', 1, '4/15/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2628, 'Bradley Raunds', 0, '11/14/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2629, 'Diannne Kennett', 1, '8/25/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2630, 'Nanci Traite', 0, '7/1/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2631, 'Jehu Boxell', 0, '2/28/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2632, 'Udall Larkcum', 1, '9/22/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2633, 'Deane Dressel', 0, '9/24/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2634, 'Taddeusz Bosley', 0, '3/6/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2635, 'Christan McNeachtain', 0, '10/11/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2636, 'Selena Beveredge', 1, '9/28/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2637, 'Nickie Paulet', 0, '11/19/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2638, 'Josy Saffle', 0, '2/16/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2639, 'Hartwell Pothbury', 1, '5/12/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2640, 'Corly Crampsy', 1, '12/13/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2641, 'Lowell Skeermor', 0, '5/22/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2642, 'Nickey Acory', 0, '9/6/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2643, 'Tarrah Bolin', 0, '10/22/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2644, 'Massimo Ashe', 1, '1/1/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2645, 'Wayne Hadley', 1, '4/2/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2646, 'Maye Blazeby', 0, '10/31/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2647, 'Dillie Yarham', 1, '6/7/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2648, 'Ralph Titheridge', 1, '8/9/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2649, 'Bertina Merredy', 1, '3/12/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2650, 'Vi Ginnety', 0, '7/20/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2651, 'Camella Vaan', 0, '5/26/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2652, 'Prissie Burchatt', 1, '6/28/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2653, 'Anderson Everley', 1, '5/22/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2654, 'Fara Weippert', 0, '2/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2655, 'Marcy Fickling', 1, '7/11/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2656, 'Virgilio Threadgold', 1, '8/4/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2657, 'Clayton Clouter', 0, '2/4/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2658, 'Brok Paniman', 1, '6/5/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2659, 'Dagmar Dakhov', 1, '8/3/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2660, 'Kathe Isacsson', 0, '7/24/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2661, 'Wilie Snuggs', 1, '9/26/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2662, 'Quintus Truckett', 0, '4/3/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2663, 'Else Vela', 1, '8/23/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2664, 'Don Danigel', 0, '4/13/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2665, 'Zechariah Hathorn', 0, '2/9/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2666, 'Larry Cathrall', 1, '7/23/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2667, 'Vita Knagges', 0, '7/29/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2668, 'Mag Skepper', 1, '8/31/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2669, 'Mallissa Lamp', 1, '11/22/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2670, 'Chandal Mattusevich', 0, '10/27/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2671, 'Gael Bedin', 1, '11/19/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2672, 'Ferdie Mullane', 1, '7/16/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2673, 'Randell Prowse', 0, '6/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2674, 'Priscella Maffeo', 0, '5/9/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2675, 'Verine Worham', 0, '7/4/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2676, 'Judon Wallbrook', 0, '4/16/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2677, 'Elvira Kiehne', 0, '7/14/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2678, 'Netty Iacoboni', 0, '9/27/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2679, 'Austin Mourbey', 0, '12/1/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2680, 'Auberon Kernocke', 1, '5/8/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2681, 'Evangelia Toe', 0, '6/20/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2682, 'Terri-jo Gilhouley', 1, '9/20/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2683, 'Lynnell Niles', 1, '9/24/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2684, 'Marlo Bangiard', 1, '8/30/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2685, 'Timofei Canto', 1, '2/17/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2686, 'Myer Loach', 0, '4/24/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2687, 'Jeffy Grimmolby', 0, '7/10/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2688, 'Emera Matsell', 1, '10/14/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2689, 'Isac MacPaike', 0, '7/14/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2690, 'Case Cristoferi', 1, '6/22/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2691, 'Barney Matus', 0, '12/5/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2692, 'Clementine Caser', 1, '8/22/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2693, 'Ann Keeffe', 0, '5/9/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2694, 'Sidney Earingey', 1, '10/14/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2695, 'Dorian Degenhardt', 0, '2/9/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2696, 'Dicky Boyda', 0, '3/3/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2697, 'Chrisy Lilywhite', 1, '5/1/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2698, 'Meggi Snellman', 1, '4/4/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2699, 'Ariadne Nortunen', 0, '7/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2700, 'Riley Robion', 1, '9/4/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2701, 'Lise Wallwork', 0, '10/19/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2702, 'Ange Sexti', 0, '7/7/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2703, 'Harlene Banbury', 1, '4/21/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2704, 'Cassius Cavee', 0, '12/17/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2705, 'Tonnie Dicey', 1, '12/5/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2706, 'Joycelin Sikorsky', 1, '3/7/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2707, 'Maryrose Soppeth', 1, '1/11/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2708, 'Bonni Spataro', 0, '4/19/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2709, 'Chev Hazeltine', 0, '10/23/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2710, 'Darcey Gives', 1, '6/24/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2711, 'Barby Aronstam', 1, '2/13/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2712, 'Catie Jakuszewski', 1, '3/27/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2713, 'Chickie Ferrillio', 1, '8/17/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2714, 'Louis Melburg', 0, '3/23/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2715, 'Clayton Lowndes', 1, '6/8/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2716, 'Saundra Sighart', 1, '12/4/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2717, 'Beale Coventon', 1, '4/28/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2718, 'Hayward Briddle', 1, '10/7/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2719, 'Vassili McLaggan', 1, '4/17/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2720, 'Olag Bendixen', 1, '1/21/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2721, 'Mel Penticoot', 1, '1/15/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2722, 'Wallis Breit', 1, '2/22/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2723, 'Mareah Treadgall', 1, '2/13/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2724, 'Sibylla McAuley', 0, '2/12/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2725, 'Duane Clifford', 0, '9/15/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2726, 'Rosita Edinburgh', 1, '4/25/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2727, 'Issie Fabler', 1, '8/21/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2728, 'Griffin Kervin', 1, '5/28/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2729, 'Rafaelita Pallesen', 1, '6/16/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2730, 'Allis Grigorini', 0, '3/23/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2731, 'Lev Bartod', 1, '2/25/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2732, 'Rianon Mottinelli', 1, '11/3/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2733, 'Kristan Hamlin', 1, '7/10/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2734, 'Ernest Haggleton', 0, '1/20/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2735, 'Cassandre Hannis', 1, '7/14/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2736, 'Therine McCrann', 1, '2/25/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2737, 'Cornie Smorthit', 0, '8/25/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2738, 'Birch Templman', 1, '11/11/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2739, 'Essie Maryet', 1, '10/24/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2740, 'Griffie Doonican', 0, '10/13/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2741, 'Cahra Mc Elory', 0, '10/24/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2742, 'Marnia Teliga', 1, '12/8/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2743, 'Randy Gilhooly', 0, '1/9/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2744, 'Renard Commucci', 1, '8/28/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2745, 'Donaugh Obington', 0, '5/1/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2746, 'Ezmeralda Naire', 1, '11/3/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2747, 'Drusie Bunce', 1, '11/22/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2748, 'Fifine Romand', 1, '1/2/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2749, 'Paulina Okenden', 1, '5/16/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2750, 'Florinda Perfect', 1, '12/4/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2751, 'Romona Hasley', 1, '8/5/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2752, 'Lenette Lorimer', 1, '11/5/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2753, 'Jeddy Golson', 0, '2/26/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2754, 'Ashley Fenech', 1, '2/1/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2755, 'Tamqrah Kellog', 0, '4/23/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2756, 'Russ Mirfin', 0, '2/27/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2757, 'Andie Witz', 1, '2/28/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2758, 'Lyndsey Bulward', 1, '11/13/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2759, 'Kincaid Abercromby', 1, '7/11/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2760, 'Maje Huddy', 0, '3/29/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2761, 'Hubie Tordoff', 0, '3/5/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2762, 'Clive Tilmouth', 0, '10/14/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2763, 'Fenelia Stonhouse', 1, '11/24/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2764, 'Eadith Fairbairn', 0, '11/29/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2765, 'Maxi Janway', 0, '11/5/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2766, 'Krissie Mulholland', 0, '4/13/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2767, 'Shannon Djakovic', 1, '5/2/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2768, 'Samuele Breckin', 1, '5/14/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2769, 'Robinette Ribbens', 1, '10/21/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2770, 'Vannie Prettjohn', 1, '1/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2771, 'Sollie Spatarul', 1, '8/15/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2772, 'Natividad Landers', 0, '11/22/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2773, 'Jean Harome', 0, '10/5/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2774, 'Allistir Kneebone', 0, '12/17/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2775, 'Grantham Talby', 1, '7/16/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2776, 'Cicily Flawith', 1, '1/12/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2777, 'Leah Banasik', 0, '7/29/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2778, 'Cooper Jimes', 1, '7/28/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2779, 'Skell Cordet', 1, '2/27/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2780, 'Tessie Tugwell', 0, '6/24/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2781, 'Aileen Belward', 1, '10/26/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2782, 'Maurizia Sketchley', 1, '9/23/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2783, 'Ricky Farquharson', 0, '7/5/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2784, 'Agnesse Eicheler', 1, '7/25/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2785, 'Chase Erwin', 1, '9/1/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2786, 'Pearle Pauler', 1, '1/14/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2787, 'Isabelle Halleday', 0, '11/27/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2788, 'Norma Slayford', 0, '4/17/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2789, 'Ruthe Petch', 1, '11/3/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2790, 'Dillon Jerams', 1, '10/16/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2791, 'Correy Moxted', 0, '6/20/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2792, 'Vivi Callar', 0, '9/17/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2793, 'Karina Tampling', 1, '10/4/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2794, 'Kev Knapton', 0, '1/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2795, 'Brok Okey', 1, '2/5/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2796, 'Kellsie Christescu', 0, '4/29/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2797, 'Winny Fever', 0, '10/30/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2798, 'Sheff Neilly', 0, '5/4/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2799, 'Cymbre Dutt', 1, '4/10/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2800, 'Charin Tilte', 0, '3/16/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2801, 'Kalindi Mealiffe', 0, '8/5/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2802, 'Ring Barrick', 0, '12/23/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2803, 'Lillis Kendal', 0, '12/28/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2804, 'Tiff Weepers', 0, '3/5/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2805, 'Ambrosi Jurca', 0, '7/11/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2806, 'Letizia Carlino', 1, '3/26/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2807, 'Gillian Semmens', 1, '9/15/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2808, 'Austin Toms', 1, '8/14/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2809, 'Lottie Aikett', 0, '7/26/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2810, 'Alaric Oleszkiewicz', 1, '10/19/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2811, 'Oran Boshere', 0, '12/4/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2812, 'Fifi Cammell', 0, '12/17/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2813, 'Amalita Fielder', 0, '10/2/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2814, 'Dalston McLauchlin', 1, '2/20/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2815, 'Isabelle Rake', 1, '10/7/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2816, 'Wynnie Caffin', 1, '6/30/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2817, 'Lucia Christophe', 1, '11/20/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2818, 'Evelyn Lodevick', 0, '9/5/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2819, 'Adolf Larrat', 1, '1/26/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2820, 'Sam Lemoir', 1, '10/7/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2821, 'Kelly Deverick', 1, '3/21/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2822, 'Valry Burehill', 1, '7/8/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2823, 'Josselyn Lowndesbrough', 1, '1/8/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2824, 'Dorita Rymmer', 1, '7/2/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2825, 'Albrecht Buckenhill', 1, '8/6/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2826, 'Lizzie Flecknoe', 0, '9/26/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2827, 'Margot Nitto', 0, '12/30/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2828, 'Todd Mantle', 1, '5/7/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2829, 'Gertrud Pilfold', 0, '12/11/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2830, 'Stanton Bell', 0, '6/12/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2831, 'Lamar Closs', 1, '1/28/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2832, 'Prudence Van den Velde', 1, '4/8/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2833, 'Bliss Fadden', 1, '1/18/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2834, 'Diannne Bunton', 1, '12/19/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2835, 'Monah Keedy', 1, '4/22/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2836, 'Elora Warkup', 0, '7/14/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2837, 'Pall Pitkeathley', 0, '6/30/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2838, 'Irwinn Ayrton', 0, '9/3/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2839, 'Aubrie Tenant', 1, '3/24/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2840, 'Alicea Isacsson', 0, '11/11/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2841, 'Corene Ashwin', 1, '7/27/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2842, 'Alikee Bampfield', 1, '10/20/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2843, 'Llywellyn Hearnaman', 0, '10/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2844, 'Chloe Courtois', 0, '12/11/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2845, 'Benyamin Mustin', 1, '11/16/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2846, 'Gran Trowsdall', 0, '6/15/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2847, 'Wade Guirardin', 0, '12/3/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2848, 'Nikki Mullett', 0, '11/11/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2849, 'Angelico Leynton', 0, '7/14/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2850, 'Leisha MacAlpine', 0, '8/5/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2851, 'Sally Henrichs', 1, '9/11/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2852, 'Cristabel Axston', 0, '1/23/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2853, 'Lynn Moralee', 0, '12/14/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2854, 'Sascha Rijkeseis', 1, '1/23/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2855, 'Ilyssa Banham', 1, '12/9/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2856, 'Sisile Robins', 0, '4/22/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2857, 'Tristam Wandrey', 0, '9/1/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2858, 'Hogan Dingle', 0, '7/19/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2859, 'Tammy Winchcum', 0, '12/22/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2860, 'Sisile Danielian', 1, '12/2/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2861, 'Gene Labone', 0, '12/21/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2862, 'Rodolfo Breheny', 0, '1/6/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2863, 'Evered Palmar', 0, '6/6/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2864, 'Randal Kelleway', 1, '3/6/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2865, 'Ailyn Gatiss', 1, '4/15/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2866, 'Jannel Minet', 1, '6/8/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2867, 'Pammi Hauch', 1, '2/11/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2868, 'Zorana Ropp', 1, '8/15/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2869, 'Jaquelin Absolem', 1, '11/29/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2870, 'Hedi Schooling', 1, '9/13/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2871, 'Hervey Pleming', 0, '1/4/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2872, 'Gunilla Eatttok', 0, '5/6/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2873, 'Amalita Begwell', 0, '9/23/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2874, 'Ajay Stair', 0, '4/30/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2875, 'Elka Coniff', 1, '1/6/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2876, 'Inesita Grasner', 1, '5/12/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2877, 'Bennie Hatherley', 1, '1/17/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2878, 'Shaylah Sermin', 0, '10/3/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2879, 'Clyve Riccioppo', 0, '3/30/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2880, 'Cairistiona Shotboulte', 0, '8/4/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2881, 'Ashla Hallows', 1, '1/17/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2882, 'Adrianna Robroe', 0, '9/29/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2883, 'Erna Heindrick', 0, '11/30/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2884, 'Findlay Takos', 1, '5/15/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2885, 'Thane O''Rudden', 1, '6/10/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2886, 'Torre Pridgeon', 1, '6/4/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2887, 'Antonino Hugin', 0, '11/7/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2888, 'Georgia Weins', 1, '10/4/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2889, 'Magdalene Prue', 1, '3/31/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2890, 'Odelle Seilmann', 0, '5/1/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2891, 'Cynde Lent', 0, '8/25/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2892, '1man Hardistry', 1, '9/21/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2893, 'Doll Olive', 0, '1/18/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2894, 'Rube Haddow', 1, '7/13/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2895, 'Dannie Savile', 1, '12/14/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2896, 'Inglis Trimme', 0, '11/24/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2897, 'Shayne Donnison', 1, '11/21/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2898, 'Gerek Withams', 1, '3/31/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2899, 'Englebert Barribal', 0, '5/13/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2900, 'Klemens Veare', 0, '7/22/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2901, 'Margeaux Gatehouse', 1, '2/24/1986');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2902, 'Birgit Hemms', 1, '12/4/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2903, 'Laurene Adcocks', 0, '6/25/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2904, 'Tova Dearan', 1, '7/4/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2905, 'Albertine McGivena', 1, '9/21/1971');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2906, 'Francklyn Janus', 1, '4/8/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2907, 'Charis Rogans', 1, '12/8/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2908, 'Rochelle Kachel', 1, '9/18/1977');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2909, 'Meryl Wattingham', 1, '12/22/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2910, 'Rudolfo Parkins', 0, '8/6/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2911, 'Lonnie Visick', 0, '12/4/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2912, 'Pinchas Lewsy', 0, '12/24/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2913, 'Ardys McGrann', 0, '1/24/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2914, 'Merle Garber', 0, '6/3/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2915, 'Eileen Thackwray', 0, '10/31/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2916, 'Orsola Rosenbloom', 0, '1/11/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2917, 'Langston Farny', 1, '9/27/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2918, 'Robbin Dickins', 1, '10/1/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2919, 'Myrlene Luno', 0, '5/23/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2920, 'Leupold Ransfield', 1, '9/2/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2921, 'Lyndsay Clery', 1, '4/15/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2922, 'Frankie Sennett', 1, '11/7/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2923, 'Ronnie Vassar', 0, '3/17/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2924, 'Moselle Vizor', 0, '2/3/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2925, 'Vinita Ternent', 1, '1/11/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2926, 'Stanislas Morville', 1, '4/28/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2927, 'Gertrudis Arnaldy', 1, '2/24/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2928, 'Jeannine MacNeish', 0, '8/5/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2929, 'Ericha Warrell', 0, '2/10/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2930, 'Callie Jozsika', 1, '12/31/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2931, 'Allis Champion', 1, '11/9/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2932, 'Lori Teager', 1, '1/14/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2933, 'Quinta Duchart', 1, '10/23/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2934, 'Devon Feasby', 0, '7/7/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2935, 'Alejandro De Santos', 0, '9/26/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2936, 'Freddie Mundee', 1, '5/6/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2937, 'Vally Shewery', 0, '9/14/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2938, 'Otha Kilford', 0, '2/16/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2939, 'Loutitia Whear', 0, '12/11/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2940, 'Bettine Gout', 1, '4/3/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2941, 'Pamelina Bhatia', 1, '9/18/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2942, 'Yehudit Matschke', 0, '1/18/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2943, 'Missy Cardinal', 0, '7/22/1992');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2944, 'Cyrill Bergeau', 0, '10/20/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2945, 'Felicia Rustidge', 0, '7/29/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2946, 'Tome Veck', 1, '9/24/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2947, 'Clareta Orht', 0, '7/6/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2948, 'Adelaide De Normanville', 0, '12/27/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2949, 'Bayard Rimell', 1, '2/9/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2950, 'Barri Tytterton', 0, '6/21/1983');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2951, 'Siward Indruch', 0, '7/5/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2952, 'Valera Blanchet', 0, '5/13/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2953, 'Erina Merrell', 1, '1/28/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2954, 'Kellina Henriksson', 1, '11/23/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2955, 'Winifield Speedy', 0, '6/3/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2956, 'Karrah Queyeiro', 1, '6/22/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2957, 'Bab Dewer', 0, '11/20/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2958, 'Cassandre Gallanders', 0, '8/7/1975');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2959, 'Gare Ketteridge', 0, '3/6/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2960, 'Rowe Doiley', 0, '9/25/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2961, 'Danni Drewe', 0, '8/11/1987');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2962, 'Laurice Morden', 0, '7/7/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2963, 'Marty Rigard', 0, '8/22/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2964, 'Shirl Episcopi', 1, '9/7/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2965, 'Paten Delamere', 0, '4/2/1985');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2966, 'Berne Lethebridge', 1, '7/21/1982');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2967, 'Brose Tether', 1, '10/3/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2968, 'Meade Kalb', 0, '1/20/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2969, 'Dirk Klimshuk', 1, '1/17/1991');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2970, 'Linc Ching', 1, '8/7/1996');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2971, 'Cayla Gynni', 1, '11/6/2000');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2972, 'Stacia Pooly', 0, '7/15/1999');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2973, 'Julieta Ogborne', 0, '4/28/1989');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2974, 'Marsha Allawy', 0, '3/12/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2975, 'Berny Renison', 0, '10/9/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2976, 'Margarette Buzzing', 1, '8/13/1979');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2977, 'Lusa Waddicor', 0, '5/12/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2978, 'Romona Lindsell', 0, '2/1/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2979, 'Glenn Potteridge', 0, '1/31/1976');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2980, 'Tabina Beal', 1, '2/22/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2981, 'Henka Mosson', 1, '4/22/1994');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2982, 'Maxie Tremoille', 0, '3/1/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2983, 'Johannah Barr', 0, '4/2/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2984, 'Erwin Sands-Allan', 1, '9/22/1995');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2985, 'Lorin Freebury', 1, '6/20/1972');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2986, 'Marissa Rhule', 0, '9/19/1981');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2987, 'Sammy Grewer', 0, '12/16/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2988, 'Francklin Twinborough', 0, '1/24/1988');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2989, 'Nananne Thame', 0, '7/30/1978');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2990, 'Neale Pucknell', 0, '8/14/1973');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2991, 'Bonita Skipsea', 1, '10/8/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2992, 'Gerome Evenett', 0, '6/20/1980');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2993, 'Michelina Dabourne', 0, '1/24/1997');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2994, 'Arnoldo Karlsen', 1, '4/22/1993');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2995, 'Maire Tayt', 1, '10/28/1998');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2996, 'Charlotte Idale', 0, '11/9/1984');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2997, 'Etta Iggulden', 0, '1/10/1990');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2998, 'Lorain Midford', 1, '3/21/2001');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (2999, 'Morty Benoist', 0, '4/6/1974');
insert into CustomerInfo (Id_Customer, Customer_Name, Customer_Gender, Customer_Birthday) values (3000, 'Mal Methuen', 1, '5/9/1979');


DROP FUNCTION IF EXISTS goodtable
go
CREATE FUNCTION goodtable()
RETURNS table
AS
RETURN 
SELECT dbo.GoodPresented.*, Id_TG FROM dbo.TypeGood JOIN dbo.GoodPresented ON Product_Group LIKE ('%'+dbo.TypeGood.TG_Name+'%')

go

DROP PROCEDURE IF EXISTS gen_gooddetail
GO
CREATE PROCEDURE gen_gooddetail
AS
BEGIN
	DECLARE @Id_Good INT
	DECLARE @GD_Name NVARCHAR(255)
	DECLARE @GD_Price MONEY
	DECLARE @GD_Discount_Rate FLOAT
	DECLARE @GD_Rating_AVG FLOAT
	DECLARE @Thumbnail_URL NVARCHAR(MAX)
	DECLARE @Id_Supplier INT
	DECLARE @Supplier_Name NVARCHAR(255)
	DECLARE @Product_Group NVARCHAR(255)
	DECLARE @Id_TG INT
	DECLARE @remain INT
	DECLARE @sold INT
	DECLARE @color NVARCHAR(10)
	DECLARE @size NCHAR(4)
	DECLARE @count INT 

	DECLARE cursor1 CURSOR FOR SELECT * FROM dbo.goodtable()
	OPEN cursor1
	FETCH NEXT FROM cursor1 INTO  @Id_Good, @GD_Name, @GD_Price,
	@GD_Discount_Rate, @GD_Rating_AVG, @Thumbnail_URL, @Id_Supplier, 
	@Supplier_Name, @Product_Group, @Id_TG
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @count = 0;
		SET @size = CAST(FLOOR(RAND()*10 + 76)/2 AS nvarchar(4))
		SET @color = N'Vàng'
		WHILE @count < 2 
		BEGIN
			SET @remain = FLOOR(RAND()*100 + 100)
			SET @sold = FLOOR(RAND()*100 + 300)

			INSERT INTO dbo.GoodDetail
			(
			    GD_Name,
			    GD_Color,
			    GD_Size,
			    GD_Price,
			    GD_Remain,
			    GD_Sold,
			    GD_Discount_Rate,
			    GD_Rating_AVG,
			    Thumbnail_URL,
			    Thumbnail_width,
			    Thumbnail_height,
			    Id_Good,
			    Id_TG,
			    Id_Supplier,
			    Supplier_Name,
				specification_Type
			)
			VALUES
			(   @GD_Name,  -- GD_Name - nvarchar(255)
			    @color,  -- GD_Color - nvarchar(10)
			    @size,  -- GD_Size - nchar(4)
			    @GD_Price, -- GD_Price - money
			    @remain,    -- GD_Remain - int
			    @sold,    -- GD_Sold - int
			    @GD_Discount_Rate,  -- GD_Discount_Rate - float
			    @GD_Rating_AVG,  -- GD_Rating_AVG - float
			    @Thumbnail_URL,  -- Thumbnail_URL - ntext
			    280,  -- Thumbnail_width - float
			    280,  -- Thumbnail_height - float
			    @Id_Good,    -- Id_Good - int
			    @Id_TG,    -- Id_TG - int
			    @Id_Supplier,    -- Id_Supplier - int
			    @Supplier_Name,   -- Supplier_Name - nvarchar(255)
				@Product_Group
			    )			

			SET @size = CAST((CAST(@size AS FLOAT) +FLOOR(RAND()*2 + 2)/2) AS NVARCHAR(4))
			SET @color = N'Đỏ'
			SET @GD_Price += @GD_Price + FLOOR(RAND()*20000 + 20000)
			SET @count = @count + 1
        END
		FETCH NEXT FROM cursor1 INTO  @Id_Good, @GD_Name, @GD_Price,
	@GD_Discount_Rate, @GD_Rating_AVG, @Thumbnail_URL, @Id_Supplier, 
	@Supplier_Name, @Product_Group, @Id_TG
	END
	CLOSE cursor1              -- Đóng Cursor
DEALLOCATE cursor1
END



DROP  PROCEDURE IF EXISTS createTG
go
CREATE PROCEDURE createTG
AS
BEGIN
	DECLARE @table TABLE(
	Id_TG INT,
	TG_Name NVARCHAR(255)
	)
	DECLARE @id INT
	DECLARE @name NVARCHAR(100)
	DECLARE @URL NCHAR(50)
	DECLARE cursor1 CURSOR FOR SELECT Id_TG,TG_Name FROM dbo.TypeGood
	OPEN cursor1
	FETCH NEXT FROM cursor1 INTO  @id, @name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @name = (SELECT SUBSTRING(@name,1, CHARINDEX('/', @name) - 1))
		INSERT INTO @table
		(
		    Id_TG,
			TG_Name
		)
		VALUES
		(   @id,    -- Id_Good - int
		    @name  -- GD_Name - nvarchar(255)
		)
		FETCH NEXT FROM cursor1 INTO  @id, @name
    END
    CLOSE cursor1              -- Đóng Cursor
	DEALLOCATE cursor1


	DELETE FROM dbo.TypeGood
	DECLARE  @id1 INT
	SET @id1 = 1
	DECLARE cursor2 CURSOR FOR SELECT TG_Name FROM @table GROUP BY TG_Name
	OPEN cursor2
	FETCH NEXT FROM cursor2 INTO @name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO dbo.TypeGood
		(Id_TG,
		    TG_Name
		)
		VALUES
		(@id1,@name-- TG_Name - nvarchar(255)
		)
		SET @id1 = @id1 + 1
		FETCH NEXT FROM cursor2 INTO @name
    END
    CLOSE cursor2             -- Đóng Cursor
	DEALLOCATE cursor2
END

go


CREATE PROCEDURE RemoveUnusedData
AS
BEGIN
	DELETE FROM dbo.GoodPresented WHERE Product_Group LIKE N'%Thời trang%'
	DELETE FROM dbo.GoodPresented WHERE Product_Group LIKE N'%Giày%'
	DELETE FROM dbo.GoodPresented WHERE Product_Group LIKE N'%Balo%'
	DELETE FROM dbo.GoodPresented WHERE Product_Group LIKE N'%Đồng hồ%'
	DELETE FROM dbo.GoodPresented WHERE Product_Group LIKE N'%Túi%'
END
go
EXEC RemoveUnusedData
--------------------------------------------------------------------------------
GO
EXEC dbo.gen_typeGood
go
EXEC createTG
go
UPDATE dbo.TypeGood

SET TG_URL='dien-thoai-may-tinh-bang'
WHERE Id_TG = 3

UPDATE dbo.TypeGood
SET TG_URL='tivi-thiet-bi-nghe-nhin'
WHERE Id_TG = 4

UPDATE dbo.TypeGood
SET TG_URL='thiet-bi-kts-phu-kien-so'
WHERE Id_TG = 14

UPDATE dbo.TypeGood
SET TG_URL='laptop-may-vi-tinh-linh-kien'
WHERE Id_TG = 8
UPDATE dbo.TypeGood
SET TG_URL='may-anh'
WHERE Id_TG = 9
UPDATE dbo.TypeGood
SET TG_URL='dien-gia-dung'
WHERE Id_TG = 2
UPDATE dbo.TypeGood
SET TG_URL='nha-cua-doi-song'
WHERE Id_TG = 10
UPDATE dbo.TypeGood
SET TG_URL='bach-hoa-online'
WHERE Id_TG = 1
UPDATE dbo.TypeGood
SET TG_URL='do-choi-me-be'
WHERE Id_TG = 5
UPDATE dbo.TypeGood
SET TG_URL='lam-dep-suc-khoe'
WHERE Id_TG = 7
UPDATE dbo.TypeGood
SET TG_URL='the-thao'
WHERE Id_TG = 13
UPDATE dbo.TypeGood
SET TG_URL='o-to-xe-may-xe-dap'
WHERE Id_TG = 12
UPDATE dbo.TypeGood
SET TG_URL='hang-quoc-te'
WHERE Id_TG = 6
UPDATE dbo.TypeGood
SET TG_URL='nha-sach-tiki'
WHERE Id_TG = 11

UPDATE dbo.TypeGood
SET TG_URL='voucher-dich-vu'
WHERE Id_TG = 15
go
EXEC dbo.gen_gooddetail
go
