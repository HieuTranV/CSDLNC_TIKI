USE QL_BHOL
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
GO
