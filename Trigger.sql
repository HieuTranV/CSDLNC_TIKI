--trigger supplier name good detail
DROP TRIGGER IF EXISTS Trigger_Insert_SupplierID_GoodDetail
GO 
create trigger Trigger_Insert_SupplierID_GoodDetail on dbo.GoodDetail
for insert, update
as
BEGIN
	DECLARE @supplier_name NVARCHAR(255)
	DECLARE @supplier_id INT
    DECLARE @id_GD int
	DECLARE cursorTriggerGoodDetail CURSOR FOR SELECT DISTINCT Inserted.Supplier_Name, Inserted.Id_Supplier, Inserted.Id_GD FROM Inserted
	OPEN cursorTriggerGoodDetail
	FETCH NEXT FROM cursorTriggerGoodDetail INTO @supplier_name, @supplier_id, @id_GD
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@supplier_name IS NOT NULL AND @supplier_name != (SELECT Supplier_Name FROM dbo.Supplier WHERE @supplier_id = Id_Supplier)) 
		BEGIN 
			UPDATE dbo.GoodDetail
			SET Supplier_Name = NULL
			WHERE Id_GD = @id_GD
			PRINT 'Supplier name is setted to right value'
		END 
		IF (@supplier_id IS NOT NULL)
		BEGIN 

			UPDATE dbo.GoodDetail
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.Supplier WHERE Id_Supplier = @supplier_id)
			WHERE GoodDetail.Id_Supplier = @supplier_id AND GoodDetail.Supplier_Name IS NULL
		END 
		FETCH NEXT FROM cursorTriggerGoodDetail INTO @supplier_name, @supplier_id, @id_GD
    END
	CLOSE cursorTriggerGoodDetail
	DEALLOCATE cursorTriggerGoodDetail
END

--trigger supplier name good presented
DROP TRIGGER IF EXISTS Trigger_Insert_SupplierID_GoodPresented
GO 
create trigger Trigger_Insert_SupplierID_GoodPresented on dbo.GoodPresented
for insert, update
as
BEGIN
	DECLARE @supplier_name NVARCHAR(255)
	DECLARE @supplier_id INT
    DECLARE @id_Good int
	DECLARE cursorTriggerGoodPresented CURSOR FOR SELECT DISTINCT Inserted.Supplier_Name, Inserted.Id_Supplier, Inserted.Id_Good FROM Inserted
	OPEN cursorTriggerGoodPresented
	FETCH NEXT FROM cursorTriggerGoodPresented INTO @supplier_name, @supplier_id, @id_Good
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@supplier_name IS NOT NULL AND @supplier_name != (SELECT Supplier_Name FROM dbo.Supplier WHERE @supplier_id = Id_Supplier)) 
		BEGIN 
			UPDATE dbo.GoodPresented
			SET Supplier_Name = NULL
			WHERE Id_Good = @id_Good
			PRINT 'Supplier name is setted to right value'
		END 
		IF (@supplier_id IS NOT NULL)
		BEGIN 

			UPDATE dbo.GoodPresented
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.Supplier WHERE Id_Supplier = @supplier_id)
			WHERE GoodPresented.Id_Supplier = @supplier_id AND GoodPresented.Supplier_Name IS NULL
		END 
		FETCH NEXT FROM cursorTriggerGoodPresented INTO @supplier_name, @supplier_id, @id_Good
    END
	CLOSE cursorTriggerGoodPresented
	DEALLOCATE cursorTriggerGoodPresented
END


--trigger supplier name good warehouse
DROP TRIGGER IF EXISTS Trigger_Insert_GoodWareHouse
GO 
create trigger Trigger_Insert_GoodWareHouse on dbo.Good_Warehouse
for insert, update
AS
BEGIN
	DECLARE @supplier_name NVARCHAR(255)
	DECLARE @GD_Name NVARCHAR(255)
    DECLARE @id_GD INT
    DECLARE @id INT 
	DECLARE cursorTriggerGoodWarehouse CURSOR FOR SELECT DISTINCT Inserted.Id_Good_Warehouse, Inserted.Id_GD, Inserted.GD_Name, Inserted.Supplier_Name FROM Inserted
	OPEN cursorTriggerGoodWarehouse
	FETCH NEXT FROM cursorTriggerGoodWarehouse INTO @id, @id_GD, @GD_Name, @supplier_name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@supplier_name IS NOT NULL AND @supplier_name != (SELECT Supplier_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)) 
		BEGIN 
			UPDATE dbo.Good_Warehouse
			SET Supplier_Name = NULL
			WHERE Id_Good_Warehouse = @id
			PRINT 'Supplier name is setted to right value'
		END 
		IF (@GD_Name IS NOT NULL AND @GD_Name != (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)) 
		BEGIN 
			UPDATE dbo.Good_Warehouse
			SET GD_Name = NULL
			WHERE Id_Good_Warehouse = @id
			PRINT 'Good name is setted to right value'
		END
		IF (@id_GD IS NOT NULL)
		BEGIN 
			UPDATE dbo.Good_Warehouse
			SET GD_Name = (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Warehouse.Id_GD = @id_GD AND Good_Warehouse.GD_Name IS NULL

			UPDATE dbo.Good_Warehouse
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Warehouse.Id_GD = @id_GD AND Good_Warehouse.Supplier_Name IS NULL
		END 
		FETCH NEXT FROM cursorTriggerGoodWarehouse INTO @id, @id_GD, @GD_Name, @supplier_name
    END
	CLOSE cursorTriggerGoodWarehouse
	DEALLOCATE cursorTriggerGoodWarehouse
END

-- trigger good cart
DROP TRIGGER IF EXISTS Trigger_Insert_GoodCart
GO 
create trigger Trigger_Insert_GoodCart on dbo.Good_Cart
for insert, update
as
BEGIN
	DECLARE @GD_Name NVARCHAR(255)
    DECLARE @id_GD INT
	DECLARE @id INT 
	DECLARE Trigger_Insert_GoodCart CURSOR FOR SELECT DISTINCT Inserted.Id_Good_Cart, Inserted.Id_GD, Inserted.GD_Name FROM Inserted
	OPEN Trigger_Insert_GoodCart
	FETCH NEXT FROM Trigger_Insert_GoodCart INTO @id, @id_GD, @GD_Name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@GD_Name IS NOT NULL AND @GD_Name != (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)) 
		BEGIN 
			UPDATE dbo.Good_Cart
			SET GD_Name = NULL
			WHERE @id = Id_Good_Cart

			PRINT 'Supplier name is setted to right value'
		END 
		IF (@id_GD IS NOT NULL)
		BEGIN 

			UPDATE dbo.Good_Cart
			SET GD_Name = (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Cart.Id_GD = @id_GD AND Good_Cart.GD_Name IS NULL
		END 
		FETCH NEXT FROM Trigger_Insert_GoodCart INTO @id, @id_GD, @GD_Name
    END
	CLOSE Trigger_Insert_GoodCart
	DEALLOCATE Trigger_Insert_GoodCart
END
--trigger supplier name good invoice
DROP TRIGGER IF EXISTS Trigger_Insert_GoodInvoice
GO 
create trigger Trigger_Insert_GoodInvoice on dbo.Good_Invoice
for insert, update
AS
BEGIN
	DECLARE @supplier_name NVARCHAR(255)
	DECLARE @GD_Name NVARCHAR(255)
    DECLARE @id_GD INT
    DECLARE @id_invoice INT 
	DECLARE cursorTriggerGoodInvoice CURSOR FOR SELECT DISTINCT Inserted.Id_Invoice, Inserted.Id_GD, Inserted.GD_Name, Inserted.Supplier_Name FROM Inserted
	OPEN cursorTriggerGoodInvoice
	FETCH NEXT FROM cursorTriggerGoodInvoice INTO @id_invoice, @id_GD, @GD_Name, @supplier_name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@supplier_name IS NOT NULL AND @supplier_name != (SELECT Supplier_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)) 
		BEGIN 
			UPDATE dbo.Good_Invoice
			SET Supplier_Name = NULL
			WHERE Id_Invoice = @id_invoice AND Id_GD = @id_GD
			PRINT 'Supplier name is setted to right value'
		END 
		IF (@GD_Name IS NOT NULL AND @GD_Name != (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)) 
		BEGIN 
			UPDATE dbo.Good_Invoice
			SET GD_Name = NULL
			WHERE Id_Invoice = @id_invoice AND Id_GD = @id_GD
			PRINT 'Good name is setted to right value'
		END
		IF (@id_GD IS NOT NULL)
		BEGIN 
			UPDATE dbo.Good_Invoice
			SET GD_Price = (SELECT GD_Price FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Invoice.Id_GD = @id_GD AND Id_Invoice = @id_invoice

			UPDATE dbo.Good_Invoice
			SET GD_Name = (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Invoice.Id_GD = @id_GD AND Good_Invoice.GD_Name IS NULL


			UPDATE dbo.Good_Invoice
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.GoodDetail WHERE @id_invoice = Id_GD)
			WHERE Good_Invoice.Id_GD = @id_GD AND Good_Invoice.Supplier_Name IS NULL
		END 
		FETCH NEXT FROM cursorTriggerGoodInvoice INTO @id_invoice, @id_GD, @GD_Name, @supplier_name
    END
	CLOSE cursorTriggerGoodInvoice
	DEALLOCATE cursorTriggerGoodInvoice
END
INSERT INTO dbo.Invoice
(
    Invoice_InvoiceDate,
    Invoice_TotalPrice,
    Id_StatusInvoice,
    Id_ShipVoucher,
    Id_ProductVoucher,
    Id_TP,
    Id_DI,
    Id_Customer
)
VALUES
(   GETDATE(), -- Invoice_InvoiceDate - datetime
    0,      -- Invoice_TotalPrice - money
    1,         -- Id_StatusInvoice - int
    NULL,         -- Id_ShipVoucher - int
    NULL,         -- Id_ProductVoucher - int
    NULL,         -- Id_TP - int
    NULL,         -- Id_DI - int
    1          -- Id_Customer - int
    )

--trigger good delivery
DROP TRIGGER IF EXISTS Trigger_Insert_GoodDelivery
GO 
create trigger Trigger_Insert_GoodDelivery on dbo.Good_Delivery
for insert, update
as
BEGIN
	DECLARE @GD_Name NVARCHAR(255)
	DECLARE @id_DO INT
    DECLARE @id_GoodWarehouse INT
    DECLARE @id_invoice INT 
	DECLARE cursorTriggerGoodDelivery CURSOR FOR SELECT DISTINCT Inserted.Id_Good_Warehouse, Inserted.Id_DO, Inserted.GD_Name, Inserted.Id_Invoice FROM Inserted
	OPEN cursorTriggerGoodDelivery
	FETCH NEXT FROM cursorTriggerGoodDelivery INTO @id_GoodWarehouse, @id_DO, @GD_Name, @id_invoice
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@GD_Name IS NOT NULL AND @GD_Name != (SELECT GD_Name FROM dbo.Good_Warehouse WHERE @id_GoodWarehouse = Id_Good_Warehouse)) 
		BEGIN 
			UPDATE dbo.Good_Delivery
			SET GD_Name = NULL
			WHERE @id_GoodWarehouse = Id_Good_Warehouse AND @id_DO = Id_DO
			PRINT 'Good name is setted to right value'
		END 

		IF (@id_invoice IS NOT NULL AND @id_invoice != (SELECT Id_Invoice FROM dbo.DeliveryOrder WHERE @id_DO = Id_DO)) 
		BEGIN 
			UPDATE dbo.Good_Delivery
			SET Id_Invoice = NULL
			WHERE @id_GoodWarehouse = Id_Good_Warehouse AND @id_DO = Id_DO
			PRINT 'Id invoice is setted to right value'
		END 

		IF (@id_GoodWarehouse IS NOT NULL)
		BEGIN 

			UPDATE dbo.Good_Delivery
			SET GD_Name = (SELECT GD_Name FROM dbo.Good_Warehouse WHERE @id_GoodWarehouse = Id_Good_Warehouse)
			WHERE Good_Delivery.Id_Good_Warehouse = @id_GoodWarehouse AND Good_Delivery.GD_Name IS NULL
		END 

		IF (@id_DO IS NOT NULL)
		BEGIN 

			UPDATE dbo.Good_Delivery
			SET Id_Invoice = (SELECT Id_Invoice FROM dbo.DeliveryOrder WHERE Id_DO = @id_DO)
			WHERE Good_Delivery.Id_DO = @id_DO AND Good_Delivery.Id_Invoice IS NULL
		END 
		FETCH NEXT FROM cursorTriggerGoodDelivery INTO @id_GoodWarehouse, @id_DO, @GD_Name, @id_invoice
    END
	CLOSE cursorTriggerGoodDelivery
	DEALLOCATE cursorTriggerGoodDelivery
END

DROP TRIGGER IF EXISTS Trigger_Insert_Delivery_Info
GO 
create trigger Trigger_Insert_Delivery_Info on dbo.DeliveryInformation
for insert, update
as
BEGIN
	DECLARE @Id_DI int 
	DECLARE @DI_Ward_Id INT
	DECLARE @DI_Province_Id INT
	DECLARE @DI_District_Id INT
	DECLARE @DI_Ward_Name NVARCHAR(50)
	DECLARE @DI_District_Name NVARCHAR(50)
	DECLARE @DI_Province_Name NVARCHAR(50)


	DECLARE cursorTriggerDeliveryInfo CURSOR FOR SELECT DISTINCT Inserted.Id_DI, Inserted.DI_Ward_Id, Inserted.DI_Province_Id, Inserted.DI_District_Id, Inserted.DI_Ward_Name, Inserted.DI_District_Name, Inserted.DI_Province_Name  FROM Inserted
	OPEN cursorTriggerDeliveryInfo
	FETCH NEXT FROM cursorTriggerDeliveryInfo INTO @Id_DI, @DI_Ward_Id, @DI_Province_Id, @DI_District_Id, @DI_Ward_Name, @DI_District_Name, @DI_Province_Name

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF ((SELECT ProvinceId FROM dbo.District WHERE Id =@DI_District_Id) != @DI_Province_Id) 
		BEGIN
			PRINT 'Wrong district input'
			ROLLBACK TRAN
        END

		IF ((SELECT DistrictID FROM dbo.Ward WHERE Id =@DI_Ward_Id) != @DI_District_Id) 
		BEGIN
			PRINT 'Wrong ward input'
			ROLLBACK TRAN
        END

		IF (@DI_Ward_Name IS NOT NULL AND @DI_Ward_Name != (SELECT Name FROM dbo.Ward WHERE @DI_Ward_Id = Id)) 
		BEGIN 
			PRINT 'Ward is setted to right value'
		END 

		IF (@DI_Province_Name IS NOT NULL AND @DI_Province_Name != (SELECT Name FROM dbo.Province WHERE @DI_Province_Id = Id)) 
		BEGIN 
			PRINT 'Province is setted to right value'
		END 

		IF (@DI_District_Name IS NOT NULL AND @DI_District_Name != (SELECT Name FROM dbo.District WHERE @DI_District_Id = Id)) 
		BEGIN 
			PRINT 'District is setted to right value'
		END 

		IF (@DI_Ward_Id IS NOT NULL)
		BEGIN 

			UPDATE dbo.DeliveryInformation
			SET DI_Ward_Name = (SELECT Name FROM dbo.Ward WHERE @DI_Ward_Id = Id)
			WHERE Id_DI = @Id_DI
		END 

		IF (@DI_Province_Id IS NOT NULL)
		BEGIN 

			UPDATE dbo.DeliveryInformation
			SET DI_Province_Name = (SELECT Name FROM dbo.Province WHERE @DI_Province_Id = Id)
			WHERE Id_DI = @Id_DI
		END 

		IF (@DI_District_Id IS NOT NULL)
		BEGIN 

			UPDATE dbo.DeliveryInformation
			SET DI_District_Name = (SELECT Name FROM dbo.District WHERE @DI_District_Id = Id)
			WHERE Id_DI = @Id_DI
		END  
		FETCH NEXT FROM cursorTriggerDeliveryInfo INTO @Id_DI, @DI_Ward_Id, @DI_Province_Id, @DI_District_Id, @DI_Ward_Name, @DI_District_Name, @DI_Province_Name
    END
	CLOSE cursorTriggerDeliveryInfo
	DEALLOCATE cursorTriggerDeliveryInfo
END
