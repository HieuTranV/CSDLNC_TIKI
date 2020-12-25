USE master
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
	Customer_Password VARCHAR(25),
	Customer_Name NVARCHAR(255),
	Customer_Gender BIT,
	Customer_Birthday DATE,
	CONSTRAINT PK_C
	PRIMARY KEY (Id_Customer)
)

CREATE NONCLUSTERED INDEX index_Pass ON dbo.Customer(Customer_Password)
go

CREATE TABLE Supplier (
	Id_Supplier INT,
	Supplier_Name NVARCHAR(255),
	Supplier_Phone CHAR(10),
	Supplier_Address NVARCHAR(30),
	Supplier_Website NVARCHAR(30),
	Supplier_IdTax CHAR(10),
	CONSTRAINT PK_S
	PRIMARY KEY (Id_Supplier)
)

CREATE NONCLUSTERED INDEX index_supplier ON dbo.Supplier(Supplier_Name)
GO 

CREATE TABLE TypeGood (
	Id_TG INT,
	TG_Name NVARCHAR(100),
	TG_URL VARCHAR(50) UNIQUE,
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
	Thumbnail_URL NTEXT NOT NULL, 
	Id_Good INT NOT NULL,
	Id_TG INT NOT NULL,
	Id_Supplier INT NOT NULL,
	Supplier_Name NVARCHAR(255),
	Specification_Type NVARCHAR(200) NOT NULL,
	CONSTRAINT PK_GD
	PRIMARY KEY (Id_GD)
)

CREATE TABLE GoodPresented(
	Id_Good INT IDENTITY(1, 1),
	GD_Name NVARCHAR(255),
	GD_Price MONEY,
	GD_Discount_Rate FLOAT,
	GD_Rating_AVG FLOAT,
	Thumbnail_URL NTEXT NOT NULL,
	Id_Supplier INT,
	Supplier_Name NVARCHAR(255),
	Product_Group NVARCHAR(255) NOT NULL,
	isStock BIT NOT NULL,
	CONSTRAINT PK_GP
	PRIMARY KEY (Id_Good)
)


CREATE TABLE Warehouse(
	Id_WH INT IDENTITY(1, 1),
	WH_Name NVARCHAR(255),
	WH_Address NVARCHAR(255),
	WH_Hotline CHAR(11) UNIQUE,
	CONSTRAINT PK_WH
	PRIMARY KEY (Id_WH)
)

CREATE TABLE Good_Warehouse(
	Id_Good_Warehouse INT IDENTITY(1, 1),
	Id_GD INT,
	Id_WH INT,
	Supplier_Name NVARCHAR(30),
	Number INT,
	CONSTRAINT PK_Good_Warehouse
	PRIMARY KEY (Id_Good_Warehouse)
)


CREATE TABLE Good_Cart(
	Id_Good_Cart INT IDENTITY(1, 1),
	Id_GD INT,
	Id_Customer INT,
	Product_Number INT,
	CONSTRAINT PK_Good_Cart
	PRIMARY KEY (Id_Good_Cart)
)


CREATE TABLE TypePay(
	Id_TP INT IDENTITY(1, 1),
	TP_Name NVARCHAR(128),
	CONSTRAINT PK_TP
	PRIMARY KEY (Id_TP)
)

CREATE TABLE StatusInvoice(
	Id_StatusInvoice INT IDENTITY(1, 1),
	StatusInvoice_Name NVARCHAR(30),
	CONSTRAINT PK_SI
	PRIMARY KEY (Id_StatusInvoice)
)

CREATE TABLE DeliveryInformation(
	Id_DI INT IDENTITY(1, 1),
	Id_Customer INT,
	DI_PhoneNumber VARCHAR(11),
	DI_Name NVARCHAR(30),
	DI_Address NVARCHAR(30),
	DI_Ward_Id INT,
	DI_Province_Id INT,
	DI_District_Id INT,
	DI_Ward_Name NVARCHAR(50),
	DI_District_Name NVARCHAR(50),
	DI_Province_Name NVARCHAR(50),
	CONSTRAINT PK_DI
	PRIMARY KEY (Id_DI)
)

CREATE TABLE TypeVoucher(
	Id_TV INT IDENTITY(1,1),
	TV_Name NVARCHAR(255), 
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
	Voucher_Remain INT,
	CONSTRAINT PK_PublicVoucher
	PRIMARY KEY (Id_PublicVoucher)
)

CREATE TABLE PersonalVoucher(
	Id_PersonalVoucher INT,
	VoucherEachPerson INT,
	CONSTRAINT PK_PersonalVoucher
	PRIMARY KEY (Id_PersonalVoucher)
)

CREATE TABLE Customer_PersonalVoucher(
	Id_Customer INT,
	Id_PersonalVoucher INT,
	Voucher_Remain INT,
	CONSTRAINT PK_C_PersonalVoucher
	PRIMARY KEY (Id_Customer, Id_PersonalVoucher)
)


CREATE TABLE Customer_PublicVoucher(
	Id_Customer INT,
	Id_PublicVoucher INT,
	CONSTRAINT PK_C_PublicVoucher
	PRIMARY KEY (Id_Customer, Id_PublicVoucher)
)

CREATE TABLE Invoice(
	Id_Invoice INT IDENTITY(1, 1),
	Invoice_InvoiceDate DATETIME,
	Invoice_TotalPrice MONEY NOT NULL,
	Id_StatusInvoice INT NOT NULL,
	Id_ShipVoucher INT,
	Id_ProductVoucher INT,
	Id_TP INT,
	Id_DI INT,
	Id_Customer INT,
	CONSTRAINT PK_Invoice
	PRIMARY KEY (Id_Invoice)
)

CREATE NONCLUSTERED INDEX index_Invoice ON dbo.Invoice(Invoice_TotalPrice)


CREATE TABLE Good_Invoice(
	Id_GD INT,
	Id_Invoice INT,
	GD_Name NVARCHAR(255),
	GD_Price MONEY,
	Supplier_Name CHAR(30),
	GI_Number INT,
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
	GoodNumber INT,
	CONSTRAINT PK_Good_Delivery
	PRIMARY KEY (Id_Good_Warehouse, Id_DO)
)

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[District](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[LatiLongTude] [nvarchar](50) NULL,
	[ProvinceId] [int] NOT NULL,
	[SortOrder] [int] NULL,
	[IsPublished] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_District] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Province]    Script Date: 1/9/2017 8:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Province](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](20) NULL,
	[TelephoneCode] [int] NULL,
	[ZipCode] [nvarchar](20) NULL,
	[SortOrder] [int] NULL,
	[IsPublished] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Province] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ward]    Script Date: 1/9/2017 8:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ward](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](50) NULL,
	[LatiLongTude] [nvarchar](50) NULL,
	[DistrictID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsPublished] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Ward] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

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

ALTER TABLE dbo.DeliveryInformation
ADD CONSTRAINT FK_DI_DISTRICT
	FOREIGN KEY(DI_District_Id)
	REFERENCES DISTRICT

ALTER TABLE dbo.DeliveryInformation
ADD CONSTRAINT FK_DI_PROVINCE
	FOREIGN KEY(DI_Province_Id)
	REFERENCES Province

ALTER TABLE dbo.DeliveryInformation
ADD CONSTRAINT FK_DI_WARD
	FOREIGN KEY(DI_Ward_Id)
	REFERENCES WARD

ALTER TABLE [dbo].[Ward] ADD  CONSTRAINT [DF_Ward_SortOrder]  DEFAULT ((1)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Ward] ADD  CONSTRAINT [DF_Ward_IsPublished]  DEFAULT ((1)) FOR [IsPublished]
GO
ALTER TABLE [dbo].[District]  WITH CHECK ADD  CONSTRAINT [FK_District_Province] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([Id])
GO

ALTER TABLE [dbo].[District] CHECK CONSTRAINT [FK_District_Province]
GO
ALTER TABLE [dbo].[Ward]  WITH CHECK ADD  CONSTRAINT [FK_Ward_District] FOREIGN KEY([DistrictID])
REFERENCES [dbo].[District] ([Id])
GO
ALTER TABLE [dbo].[Ward] CHECK CONSTRAINT [FK_Ward_District]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kinh độ, vĩ độ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'District', @level2type=N'COLUMN',@level2name=N'LatiLongTude'
GO	

SELECT * FROM dbo.Supplier

SELECT * FROM dbo.GoodPresented