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
		IF (@supplier_id IS NOT NULL)
		BEGIN 
			UPDATE dbo.GoodDetail
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.Supplier WHERE Id_Supplier = @supplier_id)
			WHERE GoodDetail.Id_Supplier = @supplier_id AND @id_GD = Id_GD
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
		 
		IF (@supplier_id IS NOT NULL)
		BEGIN 
			UPDATE dbo.GoodPresented
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.Supplier WHERE Id_Supplier = @supplier_id)
			WHERE GoodPresented.Id_Supplier = @supplier_id AND Id_Good = @id_Good
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
	DECLARE @id_warehouse INT 
	DECLARE @number INT 
	DECLARE cursorTriggerGoodWarehouse CURSOR FOR SELECT DISTINCT Inserted.Id_Good_Warehouse, Inserted.Id_GD, Inserted.GD_Name, Inserted.Supplier_Name, Inserted.Id_WH, Inserted.Number FROM Inserted
	OPEN cursorTriggerGoodWarehouse
	FETCH NEXT FROM cursorTriggerGoodWarehouse INTO @id, @id_GD, @GD_Name, @supplier_name, @id_warehouse, @number
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT COUNT(Id_Good_Warehouse) FROM dbo.Good_Warehouse WHERE Id_GD = @id_GD AND Id_WH = @id_warehouse) >= 2
		BEGIN
			DELETE FROM dbo.Good_Warehouse WHERE Id_Good_Warehouse =  @id
			UPDATE dbo.Good_Warehouse
			SET Number = @number + Number
            WHERE Id_GD = @id_GD AND Id_WH = @id_warehouse
        END 
		ELSE
		BEGIN 
			IF (@id_GD IS NOT NULL)
			BEGIN 
				UPDATE dbo.Good_Warehouse
				SET GD_Name = (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
				WHERE Good_Warehouse.Id_Good_Warehouse = @id

				UPDATE dbo.Good_Warehouse
				SET Supplier_Name = (SELECT Supplier_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
				WHERE Good_Warehouse.Id_Good_Warehouse = @id
			END 
		END
		FETCH NEXT FROM cursorTriggerGoodWarehouse INTO @id, @id_GD, @GD_Name, @supplier_name, @id_warehouse, @number
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
	DECLARE @id_Customer INT 
	DECLARE @id INT 
	DECLARE @number int
	DECLARE Trigger_Insert_GoodCart CURSOR FOR SELECT DISTINCT Inserted.Id_Good_Cart, Inserted.Id_GD, Inserted.GD_Name, Inserted.Id_Customer, Inserted.Product_Number FROM Inserted
	OPEN Trigger_Insert_GoodCart
	FETCH NEXT FROM Trigger_Insert_GoodCart INTO @id, @id_GD, @GD_Name, @id_Customer, @number
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (SELECT COUNT(Id_Good_Cart) FROM dbo.Good_Cart WHERE @id_GD = Id_GD AND @id_Customer = Id_Customer) >= 2
		BEGIN
			DELETE FROM dbo.Good_Cart WHERE Id_Good_Cart = @id 
			UPDATE dbo.Good_Cart
			SET Product_Number = @number
            WHERE Id_GD = @id_GD AND Id_Customer = @id_Customer
        END
		ELSE 
		BEGIN 
			IF (@id_GD IS NOT NULL)
			BEGIN 

				UPDATE dbo.Good_Cart
				SET GD_Name = (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
				WHERE Good_Cart.Id_GD = @id_GD AND Good_Cart.GD_Name IS NULL
			END 
		END
		FETCH NEXT FROM Trigger_Insert_GoodCart INTO @id, @id_GD, @GD_Name, @id_Customer, @number
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
	DECLARE cursorTriggerGoodInvoice CURSOR FOR SELECT Inserted.Id_Invoice, Inserted.Id_GD, Inserted.GD_Name, Inserted.Supplier_Name FROM Inserted
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
			SET GD_Price = (SELECT FLOOR(GD_Price * (100 - GD_Discount_Rate)/100000)*1000 FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Invoice.Id_GD = @id_GD AND Id_Invoice = @id_invoice

			UPDATE dbo.Good_Invoice
			SET GD_Name = (SELECT GD_Name FROM dbo.GoodDetail WHERE @id_GD = Id_GD)
			WHERE Good_Invoice.Id_GD = @id_GD AND Id_Invoice = @id_invoice


			UPDATE dbo.Good_Invoice
			SET Supplier_Name = (SELECT Supplier_Name FROM dbo.GoodDetail WHERE @id_invoice = Id_GD)
			WHERE Good_Invoice.Id_GD = @id_GD AND Id_Invoice = @id_invoice
		END 
		FETCH NEXT FROM cursorTriggerGoodInvoice INTO @id_invoice, @id_GD, @GD_Name, @supplier_name
    END
	CLOSE cursorTriggerGoodInvoice
	DEALLOCATE cursorTriggerGoodInvoice
END

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

--TRIGGER RATE INSERT
DROP TRIGGER IF EXISTS Trigger_Rate_insert
GO 
create trigger Trigger_Rate_insert on dbo.Customer_Rate_Good
for insert
AS

BEGIN TRAN
	SET TRAN ISOLATION LEVEL SERIALIZABLE
    DECLARE @id_customer INT
	SET @id_customer = (SELECT inserted.id_customer FROM inserted)
    DECLARE @id_GD INT
	SET @id_GD = (SELECT inserted.id_GD FROM inserted)
    DECLARE @rate INT
	SET @rate = (SELECT inserted.Rate FROM inserted)

	IF @id_GD in (SELECT Id_GD FROM dbo.Good_Invoice JOIN  dbo.Invoice ON Invoice.Id_Invoice = Good_Invoice.Id_Invoice 
		WHERE @id_customer = Id_Customer AND Id_StatusInvoice = 3)
		BEGIN 
			IF (@rate >=0 AND @rate <=5)
			BEGIN
				UPDATE dbo.GoodDetail
				SET GD_Rating_AVG = (GD_Rating_AVG* Number_Rating + @rate)/ (Number_Rating + 1)
				WHERE Id_GD = @id_GD
				UPDATE dbo.GoodDetail
				SET Number_Rating = Number_Rating + 1
				WHERE Id_GD = @id_GD
            END
			ELSE
            BEGIN
				ROLLBACK TRAN
            END
		END 
		ELSE 
		BEGIN
			ROLLBACK TRAN
		END
COMMIT


--TRIGGER RATE DELETE
DROP TRIGGER IF EXISTS Trigger_Rate_Delete
GO 
create trigger Trigger_Rate_Delete on dbo.Customer_Rate_Good
for DELETE
AS
BEGIN TRAN
	SET TRAN ISOLATION LEVEL SERIALIZABLE
    DECLARE @id_customer INT
	SET @id_customer = (SELECT deleted.id_customer FROM deleted)
    DECLARE @id_GD INT
	SET @id_GD = (SELECT deleted.id_GD FROM deleted)
    DECLARE @rate INT
	SET @rate = (SELECT deleted.Rate FROM deleted)
	                                              

	UPDATE dbo.GoodDetail
	SET GD_Rating_AVG = (GD_Rating_AVG* Number_Rating - @rate)/(Number_Rating - 1)
	WHERE @id_GD = Id_GD

	UPDATE dbo.GoodDetail
	SET Number_Rating = Number_Rating - 1
	WHERE @id_GD = Id_GD
COMMIT


DROP TRIGGER IF EXISTS Trigger_Insert_Invoice
go
CREATE trigger Trigger_Insert_Invoice on dbo.Invoice
FOR INSERT, UPDATE 
AS
BEGIN
	DECLARE @id_ship_voucher int
	DECLARE @id_invoice_voucher INT
	DECLARE @id_customer int
	DECLARE cur CURSOR FOR SELECT Inserted.Id_ShipVoucher, Inserted.Id_ProductVoucher, Inserted.Id_Customer FROM Inserted
	OPEN cur
	FETCH NEXT FROM cur INTO @id_ship_voucher, @id_invoice_voucher, @id_customer
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @id_invoice_voucher IS NOT NULL AND  EXISTS( SELECT * FROM dbo.PublicVoucher WHERE @id_invoice_voucher = Id_PublicVoucher)
		BEGIN
			UPDATE dbo.PublicVoucher
			SET  Voucher_Remain = Voucher_Remain - 1
			WHERE Id_PublicVoucher = @id_invoice_voucher
			INSERT INTO customer_publicVoucher
			VALUES (@id_customer, @id_invoice_voucher)
        END
		ELSE
        BEGIN
			UPDATE dbo.Customer_PersonalVoucher
			SET Voucher_Remain = Voucher_Remain - 1
            WHERE Id_Customer = @id_customer AND Id_PersonalVoucher = @id_invoice_voucher
        END
        
		IF  @id_ship_voucher IS NOT NULL AND EXISTS( SELECT * FROM dbo.PublicVoucher WHERE @id_ship_voucher = Id_PublicVoucher)
		BEGIN
			UPDATE dbo.PublicVoucher
			SET  Voucher_Remain = Voucher_Remain - 1
			WHERE Id_PublicVoucher = @id_ship_voucher

			INSERT INTO customer_publicVoucher
			VALUES (@id_customer,@id_ship_voucher)
        END
		ELSE
        BEGIN
			UPDATE dbo.Customer_PersonalVoucher
			SET Voucher_Remain = Voucher_Remain - 1
            WHERE Id_Customer = @id_customer AND Id_PersonalVoucher = @id_ship_voucher
        END
        FETCH NEXT FROM cur INTO @id_ship_voucher, @id_invoice_voucher, @id_customer
	END
    CLOSE cur
	DEALLOCATE cur
END

