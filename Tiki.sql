USE master
go
IF DB_ID('QL_BHOL') IS NOT NULL
	DROP DATABASE QL_BHOL

GO
CREATE DATABASE QL_BHOL
GO
USE QL_BHOL

CREATE TABLE Customer(
	Id_Customer INT,
	Customer_Email CHAR(30),
	Customer_Phone CHAR(10),
	Customer_Password CHAR(25)
	CONSTRAINT PK_C
	PRIMARY KEY (Id_Customer)
)

CREATE TABLE CustomerInfo (
	Id_Customer INT,
	Customer_Name CHAR(30),
	Customer_Gender BIT,
	Customer_Birthday DATE
	CONSTRAINT PK_CI
	PRIMARY KEY (Id_Customer)
)


CREATE TABLE Supplier (
	Id_Supplier INT,
	Supplier_Name CHAR(30),
	Supplier_Phone CHAR(11),
	Supplier_Address CHAR(30),
	Supplier_Website CHAR(30),
	Supplier_IdTax CHAR(30),
	CONSTRAINT PK_S
	PRIMARY KEY (Id_Supplier)
)


CREATE TABLE TypeGood (
	Id_TG INT,
	TG_Name CHAR(30)
	CONSTRAINT PK_TG
	PRIMARY KEY (Id_TG)
)

CREATE TABLE GoodDetail (
	Id_GD INT,
	GD_Name NVARCHAR(255),
	GD_Color NVARCHAR(30),
	GD_Size NVARCHAR(30),
	GD_Price MONEY,
	GD_Remain INT,
	GD_Sold INT,
	Id_Good INT,
	Id_TG INT,
	Id_Supplier INT,
	Supplier_Name CHAR(30)
	CONSTRAINT PK_GD
	PRIMARY KEY (Id_GD)
)


CREATE TABLE GoodPresented(
	Id_Good INT,
	GD_Name CHAR(30),
	GD_Price MONEY,
	Id_Supplier INT,
	Supplier_Name CHAR(30)
	CONSTRAINT PK_GP
	PRIMARY KEY (Id_Good)
)

CREATE TABLE Warehouse(
	Id_WH INT,
	WH_Name CHAR(30),
	WH_Address CHAR(30),
	WH_Hotline CHAR(11)
	CONSTRAINT PK_WH
	PRIMARY KEY (Id_WH)
)

CREATE TABLE Good_Warehouse(
	Id_Good_Warehouse INT,
	Id_GD INT,
	Id_WH INT,
	Supplier_Name CHAR(30),
	Number INT,
	CONSTRAINT PK_Good_Warehouse
	PRIMARY KEY (Id_Good_Warehouse)
)


CREATE TABLE Good_Cart(
	Id_Good_Cart INT,
	Id_GD INT,
	Id_Customer INT,
	GC_Number INT,
	WH_Hotline CHAR(11)
	CONSTRAINT PK_Good_Cart
	PRIMARY KEY (Id_Good_Cart)
)


CREATE TABLE TypePay(
	Id_TP INT,
	TP_Name CHAR(30)
	CONSTRAINT PK_TP
	PRIMARY KEY (Id_TP)
)


CREATE TABLE StatusInvoice(
	Id_StatusInvoice INT,
	StatusInvoice_Name CHAR(30)
	CONSTRAINT PK_SI
	PRIMARY KEY (Id_StatusInvoice)
)

CREATE TABLE DeliveryInformation(
	Id_DI INT,
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
	Id_TV INT,
	TV_Name CHAR(30) 
	CONSTRAINT PK_TV
	PRIMARY KEY (Id_TV)
)

CREATE TABLE Voucher(
	Id_Voucher INT,
	Voucher_Name CHAR(30),
	Voucher_StartDate DATE,
	Voucher_EndDate DATE,
	Id_TV INT
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

CREATE TABLE Invoice(
	Id_Invoice INT,
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
	Id_DO INT,
	Id_Invoice INT,
	DO_DateDelivery DATE,
	CONSTRAINT PK_DeliveryOrder
	PRIMARY KEY (Id_DO)
)

CREATE TABLE Good_Delivery(
	Id_Good_Warehouse INT,
	Id_DO INT,
	Id_PO INT,
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


