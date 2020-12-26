use QL_BHOL


--********Nếu @Flag = 1 nghĩa là có lỗi, 0 thì ngược lại**********

-----------------------------------Thêm một Customer(Dùng để đăng ký tài khoản)-------------------------------------------- 
GO
DROP PROC IF EXISTS SP_Customer_CreateAccount 
GO
CREATE PROC SP_Customer_CreateAccount 
@Cus_Email char(30), @Cus_Phone char(10), 
@Cus_Pass char(25), @Cus_Name nvarchar(255),
@Cus_Gender bit, @Cus_Birthday date,
@Flag bit out, @Mess nvarchar(255) out
AS
BEGIN
	Declare @Cus_ID int = -1
	DECLARE @NewLine as char(2) = char(13) + char(10)
	Set @Flag = 1

	IF @Cus_Email is null or @Cus_Pass is null
	BEGIN 
		 Set @Mess = N'Để trống các trường bắt buộc'
		 return;
	END

	IF @Cus_Pass is null
	BEGIN
			Set @Mess = N'Để trống mật khẩu'
			return;
	END

	BEGIN TRAN
	SET TRAN ISOLATION LEVEL SERIALIZABLE

	IF exists (select * 
			   from Customer 
			   where Customer_Email = @Cus_Email)
	BEGIN
			   Set @Mess = N'Email đã có tài khoản tương ứng'
			   ROLLBACK TRAN
			   RETURN;
	END

	INSERT INTO Customer(Customer_Email, Customer_Phone, Customer_Password,Customer_Name, Customer_Gender, Customer_Birthday) values (@Cus_Email, @Cus_Phone, @Cus_Pass, @Cus_Name, @Cus_Gender, @Cus_Birthday)

	SET @Cus_ID = (SELECT Id_Customer FROM Customer WHERE Customer_Email = @Cus_Email)

	INSERT INTO DeliveryInformation(Id_Customer) VALUES (@Cus_ID)
	Set @Mess = N'Tạo tài khoản thành công'
	SET @Flag = 0;

	COMMIT TRAN
END



-----------------------------------Xem coi có phải tài khoản không?(dùng để đăng nhập)-------------------------------------------- 
GO
DROP PROC IF EXISTS SP_Customer_IsAccount 
GO
CREATE PROC SP_Customer_IsAccount 
@Cus_Email char(30), @Cus_Pass char(25),
@Flag bit out, @Mess nvarchar(255) out,
@Id_Customer int out
AS
BEGIN

	SET @Id_Customer = (SELECT Id_Customer FROM Customer WHERE Customer_Email = @Cus_Email and Customer_Password = @Cus_Pass)

	IF @Id_Customer is not null 
	BEGIN
		SET @Flag = 0;
		SET @Mess = N'Đăng nhập thành công'
	END
	ELSE 
	BEGIN
		SET @Flag = 1;
		SET @Mess = N'Email hoặc mật khẩu nhập vào không đúng'
		SET @Id_Customer = -1
	END
END	



-----------------------------------Thêm GoodDetail vào giỏ hàng -------------------------------------------- 
GO
DROP PROC IF EXISTS SP_Customer_AddToCart
GO
CREATE PROC SP_Customer_AddToCart 
@Id_Customer int, @Id_GD int, @Product_Number int,
@Flag bit out, @Mess nvarchar(255) out
AS
BEGIN
	
	IF NOT EXISTS (SELECT * FROM Customer, GoodDetail WHERE Id_Customer = @Id_Customer and Id_GD = @Id_GD)
	BEGIN
		SET @Flag = 1
		SET @Mess = N'Không tìm thấy thông tin'

		return;
	END

	IF @Product_Number <= 0 
	BEGIN
		SET @Flag = 1
		SET @Mess = N'Số lượng hàng không hợp lệ'

		return;
	END

	BEGIN TRAN
	SET TRAN ISOLATION LEVEL SERIALIZABLE

	IF EXISTS (SELECT * FROM Good_Cart WHERE Id_Customer = @Id_Customer AND Id_GD = @Id_GD)
	BEGIN
		UPDATE Good_Cart
		SET Product_Number += @Product_Number
		WHERE Id_Customer = @Id_Customer AND Id_GD = @Id_GD

		SET @Flag = 0
		SET @Mess =  N'Thêm vào giỏ hàng thành công'
	END
	ELSE 
	BEGIN
		INSERT INTO Good_Cart(Id_Customer, Id_GD, Product_Number) VALUES (@Id_Customer, @Id_GD, @Product_Number)

		SET @Flag = 0
		SET @Mess =  N'Thêm vào giỏ hàng thành công'
	END 
	COMMIT TRAN

END

GO
declare @errFlag bit;
declare @mess nvarchar(255);


-----------------------------------Xóa GoodDetail vào giỏ hàng -------------------------------------------- 
GO
DROP PROC IF EXISTS SP_Customer_RemoveFromCart
GO
CREATE PROC SP_Customer_RemoveFromCart 
@Id_Customer int, @Id_GD int
AS
BEGIN
	DELETE FROM Good_Cart WHERE Id_Customer = @Id_Customer and Id_GD = @Id_GD
END




-----------------------------------Lấy tất cả các tất cả các mặt hàng trưng bày(GoodPresented)-------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetAllGoodPresented
GO
CREATE FUNCTION f_Customer_GetAllGoodPresented() 
RETURNS table
	RETURN (SELECT *
			FROM GoodPresented)

-----------------------------------Lấy tất cả các tất cả các chi tiết mặt hàng thuộc mặt hàng trưng bày-------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetGoodDetail
GO
CREATE FUNCTION f_Customer_GetGoodDetail(@Id_Good int) 
RETURNS table
	RETURN (SELECT gd.*
			FROM GoodDetail gd join GoodPresented gp
			ON gp.Id_Good = @Id_Good AND gp.Id_Good = gd.Id_Good)


-----------------------------------Lấy tất cả các tất cả các chi tiết mặt hàng trong giỏ hàng-------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetGoodDetail
GO
CREATE FUNCTION f_Customer_GetGoodDetail(@Id_Customer int) 
RETURNS table
	RETURN (SELECT gd.*, gc.Product_Number
			FROM GoodDetail gd join Good_Cart gc
			ON gc.Id_Customer = @Id_Customer AND gd.Id_GD = gc.Id_GD)

-----------------------------------Lấy tất cả các voucher to giao hàng -------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetShipVoucher
GO
CREATE FUNCTION f_Customer_GetShipVoucher(@Id_Customer int) 
RETURNS table
AS
	RETURN (SELECT v.Id_Voucher, v.Voucher_Name, v.Voucher_Value
			FROM Voucher v join TypeVoucher tv on tv.TV_Name = N'Giao hàng' and v.Id_TV = tv.Id_TV 
			WHERE v.Voucher_StartDate <= CONVERT(date, getdate()) AND  v.Voucher_EndDate >= CONVERT(date, getdate())
			AND (EXISTS(SELECT *
						FROM PersonalVoucher per_v join Customer_PersonalVoucher c_per_v 
						on per_v.Id_PersonalVoucher = v.Id_Voucher and c_per_v.Id_PersonalVoucher = per_v.Id_PersonalVoucher
						WHERE c_per_v.Id_Customer = @Id_Customer and c_per_v.Voucher_Remain > 0)
		    OR (EXISTS (SELECT *
						FROM PublicVoucher pub_v
						WHERE pub_v.Id_PublicVoucher = v.Id_Voucher AND pub_v.Voucher_Remain > 0 AND NOT EXISTS (SELECT *
																			   FROM Customer_PublicVoucher c_pub_v
																			   WHERE c_pub_v.Id_PublicVoucher = pub_v.Id_PublicVoucher
																			   AND c_pub_v.Id_Customer = @Id_Customer)))))
				



-----------------------------------Lấy tất cả các voucher to đơn hàng -------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetProductVoucher
GO 
CREATE FUNCTION f_Customer_GetProductVoucher(@Id_Customer int) 
RETURNS table
AS
	RETURN (SELECT v.Id_Voucher, v.Voucher_Name, v.Voucher_Value
			FROM Voucher v join TypeVoucher tv on tv.TV_Name = N'Đơn hàng' and v.Id_TV = tv.Id_TV 
			WHERE v.Voucher_StartDate <= CONVERT(date, getdate()) AND  v.Voucher_EndDate >= CONVERT(date, getdate())
			AND (EXISTS(SELECT *
						FROM PersonalVoucher per_v join Customer_PersonalVoucher c_per_v 
						on per_v.Id_PersonalVoucher = v.Id_Voucher and c_per_v.Id_PersonalVoucher = per_v.Id_PersonalVoucher
						WHERE c_per_v.Id_Customer = @Id_Customer and c_per_v.Voucher_Remain > 0)
		    OR (EXISTS (SELECT *
						FROM PublicVoucher pub_v
						WHERE pub_v.Id_PublicVoucher = v.Id_Voucher AND pub_v.Voucher_Remain > 0 AND NOT EXISTS (SELECT *
																			   FROM Customer_PublicVoucher c_pub_v
																			   WHERE c_pub_v.Id_PublicVoucher = pub_v.Id_PublicVoucher
																			   AND c_pub_v.Id_Customer = @Id_Customer)))))
				



-----------------------------------Lấy tất cả các loại thanh toán -------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetAllTypePay
GO 
CREATE FUNCTION f_Customer_GetAllTypePay() 
RETURNS table
AS
	RETURN (SELECT *
			FROM TypePay)

--SELECT * FROM f_Customer_GetAllTypePay()

-----------------------------------Lấy tất cả các loại thanh toán -------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetDeliveryInformation
GO 
CREATE FUNCTION f_Customer_GetDeliveryInformation(@Id_Customer int) 
RETURNS table
AS
	RETURN (SELECT *
			FROM DeliveryInformation
			WHERE Id_Customer = @Id_Customer)

--SELECT * FROM f_Customer_GetDeliveryInformation(1009)


-----------------------------------Lấy tất cả các tỉnh------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetAllProvince
GO 
CREATE FUNCTION f_Customer_GetAllProvince() 
RETURNS table
AS
	RETURN (SELECT *
			FROM Province)

--SELECT * FROM f_Customer_GetAllProvince()

-----------------------------------Lấy tất cả các quận------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetAllDistrict
GO 
CREATE FUNCTION f_Customer_GetAllDistrict() 
RETURNS table
AS
	RETURN (SELECT *
			FROM District)

--SELECT * FROM f_Customer_GetAllDistrict()

-----------------------------------Lấy tất cả các đường------------------------------------------- 
GO
DROP FUNCTION IF EXISTS f_Customer_GetAllDWard
GO 
CREATE FUNCTION f_Customer_GetAllDWard() 
RETURNS table
AS
	RETURN (SELECT *
			FROM Ward)

--SELECT * FROM f_Customer_GetAllDWard()

------------Tạo một đơn hàng và bỏ tất cả hàng trong giỏ vào(Chưa đặt phương thức thanh toán, voucher và lấy deliveryinformation có sẵn)----------------
GO
DROP PROC IF EXISTS SP_Customer_CreateInvoice
GO
CREATE PROC SP_Customer_CreateInvoice 
@Id_Customer int,
@Flag bit out, @Mess nvarchar(255) out, 
@Id_Invoice int out
AS
BEGIN

	DECLARE @Id_StatusInvoice int = (SELECT Id_StatusInvoice FROM StatusInvoice WHERE StatusInvoice_Name = N'Đang xác nhận')
	DECLARE @Id_TP int = (SELECT Id_TP FROM TypePay WHERE TP_Name = N'COD')
	DECLARE @Id_DI int = (SELECT Id_DI FROM DeliveryInformation WHERE Id_Customer = @Id_Customer)

	SET @Id_Invoice = -1;


	IF NOT EXISTS(SELECT * FROM Customer WHERE Id_Customer = @Id_Customer)
	BEGIN
		SET @Flag = 1;
		SET @Mess = N'Không tìm thấy thông tin của khách hàng'
		RETURN;
	END

	BEGIN TRY
	BEGIN TRANSACTION
	SET TRAN ISOLATION LEVEL SERIALIZABLE

	IF NOT EXISTS (SELECT * FROM Good_Cart WHERE Id_Customer = @Id_Customer)
	BEGIN
		SET @Flag = 1;
		SET @Mess = N'Giỏ hàng rỗng'
		RETURN;
	END
	ELSE 
	BEGIN
		INSERT INTO Invoice(Id_Customer, Id_StatusInvoice, Id_TP, Invoice_InvoiceDate, Id_DI) VALUES (@Id_Customer, @Id_StatusInvoice, @Id_TP, CONVERT(date, GETDATE()), @Id_DI)
		SET @Id_Invoice =  SCOPE_IDENTITY();

		DECLARE @Id_GD int
		DECLARE @Id_Good_Cart int
		DECLARE @Product_Number int
		DECLARE @GD_Name nvarchar(255)
		DECLARE @GD_Price money
		DECLARE @GD_Remain int
		DECLARE @SupplierName nvarchar(255)
		DECLARE @Invoice_TotalPrice money = 0

		DECLARE myCursor CURSOR FAST_FORWARD READ_ONLY
		FOR	
		SELECT Id_GD, Id_Good_Cart, Product_Number	
		FROM Good_Cart
		WHERE Id_Customer = @Id_Customer

		OPEN myCursor
		FETCH NEXT FROM myCursor
		INTO @Id_GD, @Id_Good_Cart, @Product_Number
		

		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			DELETE FROM Good_Cart
			WHERE Id_GD = @Id_GD 
			AND Id_Good_Cart = @Id_Good_Cart
			AND Product_Number = @Product_Number

			SELECT @GD_Name = gd.GD_Name, @GD_Price = gd.GD_Price, @GD_Remain = gd.GD_Remain, @SupplierName = gd.Supplier_Name
			FROM GoodDetail gd 
			WHERE gd.Id_GD = @Id_GD 

			print @Id_GD
			print @Id_Good_Cart
			print @Product_Number
			print @GD_Name
			print @GD_Price
			print @GD_Remain
			print @SupplierName

			if(@GD_Remain = 0)
			BEGIN
				FETCH NEXT FROM myCursor
				INTO @Id_GD, @Id_Good_Cart, @Product_Number

				CONTINUE;
			END

			if @Product_Number >= @GD_Remain
			BEGIN
				UPDATE GoodDetail
				SET GD_Remain -= @GD_Remain, GD_Sold += @GD_Remain
				WHERE Id_GD = @Id_GD

				SET @Product_Number = @GD_Remain;
			END
			ELSE 
			BEGIN
				UPDATE GoodDetail
				SET GD_Remain -= @Product_Number, GD_Sold += @Product_Number
				WHERE Id_GD = @Id_GD
			END

			INSERT Good_Invoice(Id_GD, Id_Invoice, GD_Name, GD_Price, Supplier_Name, GI_Number)
			VALUES (@Id_GD, @Id_Invoice, @GD_Name, @GD_Price, @SupplierName, @Product_Number)

			SET @Invoice_TotalPrice += @GD_Price * @Product_Number

			FETCH NEXT FROM myCursor
			INTO @Id_GD, @Id_Good_Cart, @Product_Number	
		END

		CLOSE myCursor
		DEALLOCATE myCursor

		UPDATE Invoice
		SET Invoice_TotalPrice = @Invoice_TotalPrice
		WHERE Id_Invoice = @Id_Invoice
	END

	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		SET @Flag = 1
		SET @Mess = N'Tạo đơn hàng không thành công'
		SET @Id_Invoice = -1;

		ROLLBACK TRANSACTION 
	END CATCH
END


-----------------------------------Thêm voucher sản phẩm cho một đơn hàng--------------------------------------------

GO
DROP PROC IF EXISTS SP_Customer_AddProcductVoucherToInvoice
GO
CREATE PROC SP_Customer_AddProcductVoucherToInvoice
@Id_Invoice int, @Id_ProcductVoucher int, @Id_Customer int,
@Flag bit out, @Mess nvarchar(255) out
AS
BEGIN
	BEGIN TRANSACTION
		SET TRAN ISOLATION LEVEL REPEATABLE READ
		SET @Flag = 1

		IF NOT EXISTS (SELECT * FROM Invoice WHERE Id_Invoice = @Id_Invoice)
		BEGIN
			SET @Flag = 1
			SET @Mess = N'Không tìm thấy thông tin'

			ROLLBACK TRANSACTION

			return;
		END

		IF NOT EXISTS (SELECT * FROM f_Customer_GetProductVoucher(@Id_Customer) WHERE Id_Voucher = @Id_ProcductVoucher)
		BEGIN
			SET @Flag = 1
			SET @Mess = N'Voucher cho sản phẩm không khả dụng'

			ROLLBACK TRANSACTION

			return;
		END
		
		IF EXISTS (SELECT * FROM Customer_PersonalVoucher WHERE Id_PersonalVoucher = @Id_ProcductVoucher AND Voucher_Remain > 0)
		BEGIN
			UPDATE Customer_PersonalVoucher
			SET Voucher_Remain -= 1
			WHERE Id_Customer = @Id_Customer AND Id_PersonalVoucher = @Id_ProcductVoucher

			UPDATE Invoice
			SET Id_ProductVoucher = @Id_ProcductVoucher
			WHERE Id_Invoice = @Id_Invoice 

			SET @Flag = 1
			SET @Mess = N'Thêm voucher cho sản phẩm thành công'

		END
		ELSE IF EXISTS (SELECT * FROM PublicVoucher WHERE Id_PublicVoucher = @Id_ProcductVoucher AND Voucher_Remain > 0)
		BEGIN
			UPDATE PublicVoucher
			SET Voucher_Remain -= 1
			WHERE Id_PublicVoucher = @Id_ProcductVoucher
			
			INSERT INTO Customer_PublicVoucher(Id_Customer, Id_PublicVoucher) VALUES (@Id_Customer, @Id_ProcductVoucher)

			UPDATE Invoice
			SET Id_ProductVoucher = @Id_ProcductVoucher
			WHERE Id_Invoice = @Id_Invoice 

			SET @Flag = 1
			SET @Mess = N'Thêm voucher cho sản phẩm thành công'

		END

		COMMIT TRANSACTION 
END


-----------------------------------Thêm voucher giao hàng cho một đơn hàng--------------------------------------------

GO
DROP PROC IF EXISTS SP_Customer_AddShipVoucherToInvoice
GO
CREATE PROC SP_Customer_AddShipVoucherToInvoice
@Id_Invoice int, @Id_ShipVoucher int, @Id_Customer int,
@Flag bit out, @Mess nvarchar(255) out
AS
BEGIN
	BEGIN TRANSACTION
		SET TRAN ISOLATION LEVEL REPEATABLE READ
		SET @Flag = 1

		IF NOT EXISTS (SELECT * FROM Invoice WHERE Id_Invoice = @Id_Invoice)
		BEGIN
			SET @Flag = 1
			SET @Mess = N'Không tìm thấy thông tin'

			ROLLBACK TRANSACTION

			return;
		END

		IF NOT EXISTS (SELECT * FROM f_Customer_GetShipVoucher(@Id_Customer) WHERE Id_Voucher = @Id_ShipVoucher)
		BEGIN
			SET @Flag = 1
			SET @Mess = N'Voucher cho giao hàng không khả dụng'

			ROLLBACK TRANSACTION

			return;
		END
		
		IF EXISTS (SELECT * FROM Customer_PersonalVoucher WHERE Id_PersonalVoucher = @Id_ShipVoucher AND Voucher_Remain > 0)
		BEGIN
			UPDATE Customer_PersonalVoucher
			SET Voucher_Remain -= 1
			WHERE Id_Customer = @Id_Customer AND Id_PersonalVoucher = @Id_ShipVoucher

			UPDATE Invoice
			SET Id_ShipVoucher = @Id_ShipVoucher
			WHERE Id_Invoice = @Id_Invoice 

			SET @Flag = 1
			SET @Mess = N'Thêm voucher cho giao hàng thành công'

		END
		ELSE IF EXISTS (SELECT * FROM PublicVoucher WHERE Id_PublicVoucher = @Id_ShipVoucher AND Voucher_Remain > 0)
		BEGIN
			UPDATE PublicVoucher
			SET Voucher_Remain -= 1
			WHERE Id_PublicVoucher = @Id_ShipVoucher
			
			INSERT INTO Customer_PublicVoucher(Id_Customer, Id_PublicVoucher) VALUES (@Id_Customer, @Id_ShipVoucher)

			UPDATE Invoice
			SET Id_ShipVoucher = @Id_ShipVoucher
			WHERE Id_Invoice = @Id_Invoice 

			SET @Flag = 1
			SET @Mess = N'Thêm voucher cho giao hàng thành công'

		END

		COMMIT TRANSACTION 
END



-----------------------------------Chọn phương thức thanh toán cho một đơn hàng--------------------------------------------

GO
DROP PROC IF EXISTS SP_Customer_UpdateTypePay
GO
CREATE PROC SP_Customer_UpdateTypePay
@Id_Invoice int, @Id_TP int, 
@Flag bit out, @Mess nvarchar(255) out
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM Invoice WHERE Id_Invoice = @Id_Invoice	)
	BEGIN
		SET @Flag = 1
		SET @Mess = N'Không tìm thấy đơn hàng'

		return;
	END

	IF NOT EXISTS (SELECT * FROM TypePay WHERE Id_TP = @Id_TP)
	BEGIN
		SET @Flag = 1
		SET @Mess = N'Không tìm thấy phương thức thanh toán'

		return;
	END

	UPDATE Invoice
	SET Id_TP = @Id_TP
	WHERE Id_Invoice = @Id_Invoice

	SET @Flag = 1
	SET @Mess = N'Đã cập nhật phương thức thanh toán'
END




-----------------------------------Cập nhật thông tin giao hàng cho một đơn hàng--------------------------------------------


GO
DROP PROC IF EXISTS SP_Customer_UpdateDeliveryInformation
GO
CREATE PROC SP_Customer_UpdateDeliveryInformation
@Id_Customer int, @DI_PhoneNumber nvarchar(11),
@DI_Name nvarchar(30), @DI_Address nvarchar(30),
@DI_Ward_Id int, @DI_District_Id int,
@DI_Province_Id int
AS
BEGIN
	DECLARE @Id_DI int = (SELECT Id_DI FROM DeliveryInformation WHERE Id_Customer = @Id_Customer)
	DECLARE @DI_Ward_Name nvarchar(50) = (SELECT Name FROM Ward WHERE id = @DI_Ward_Id)
	DECLARE @DI_District_Name nvarchar(50) = (SELECT Name FROM District WHERE id = @DI_District_Id)
	DECLARE @DI_Province_Name nvarchar(50) = (SELECT Name FROM Province WHERE id = @DI_Province_Id)

	UPDATE DeliveryInformation
	SET DI_PhoneNumber = @DI_PhoneNumber,
	DI_Name = @DI_Name,
	DI_Address = @DI_Address,
	DI_Ward_Id = @DI_Ward_Id,
	DI_District_Id = @DI_District_Id,
	DI_Province_Id = @DI_Province_Id,
	DI_Ward_Name = @DI_Ward_Name,
	DI_District_Name = @DI_District_Name,
	DI_Province_Name = @DI_Province_Name
	WHERE Id_Customer = @Id_Customer
	
END

