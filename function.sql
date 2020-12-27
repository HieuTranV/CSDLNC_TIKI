DROP PROCEDURE IF EXISTS RatingGood
GO 
CREATE PROCEDURE RatingGood @id_customer INT, @id_GD INT, @rate int 
AS
BEGIN
	IF @id_GD in (SELECT Id_GD FROM dbo.Good_Invoice JOIN  dbo.Invoice ON Invoice.Id_Invoice = Good_Invoice.Id_Invoice 
		WHERE @id_customer = Id_Customer AND Id_StatusInvoice = 3)
		BEGIN
			IF (EXISTS (SELECT * FROM dbo.Customer_Rate_Good WHERE @id_customer = Id_Customer AND @id_GD = Id_GD)
				AND (@rate >= 0 AND @rate <=5))
			BEGIN
				DELETE FROM Customer_Rate_Good WHERE @id_customer = Id_Customer AND @id_GD = Id_GD

				INSERT INTO dbo.Customer_Rate_Good
				VALUES (@id_customer, @id_GD, @rate)
			END
			ELSE
			BEGIN
				INSERT INTO dbo.Customer_Rate_Good
				VALUES (@id_customer, @id_GD, @rate)
			END
        END
		ELSE
        BEGIN
			PRINT 'You can not rate this product or the rate value is false'
        END 
END 




DROP FUNCTION IF EXISTS getVoucherByType
GO 
CREATE FUNCTION getVoucherByType (@id_TypeVoucher INT, @id_Customer INT)
RETURNs TABLE
AS 
RETURN 	
	SELECT Voucher.* FROM Voucher JOIN 
	(SELECT Id_Voucher FROM Voucher JOIN Customer_PersonalVoucher ON Id_Voucher = Id_PersonalVoucher WHERE Id_TV = @id_TypeVoucher AND Id_customer = @id_Customer AND Voucher_Remain >0
	UNION
	SELECT Id_Voucher FROM Voucher JOIN dbo.PublicVoucher ON PublicVoucher.Id_PublicVoucher = Voucher.Id_Voucher
	WHERE NOT EXISTS (SELECT * FROM dbo.Customer_PublicVoucher JOIN dbo.PublicVoucher ON PublicVoucher.Id_PublicVoucher = Customer_PublicVoucher.Id_PublicVoucher
						WHERE (Voucher_Remain <= 0 OR Id_Customer = @id_Customer) AND Id_Voucher = PublicVoucher.Id_PublicVoucher) AND Id_TV = @id_TypeVoucher)
						result ON  result.Id_Voucher = Voucher.Id_Voucher

