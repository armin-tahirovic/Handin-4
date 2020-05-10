-- Declaring variables
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Gør data ugyldig, bliver aldrig slettet
UPDATE northwindDW.dbo.Product_Dimension
SET ValidTo = DATEADD(DAY, -1, @NewLoadDate)
WHERE ProductID in (
SELECT ProductID FROM northwindDW.dbo.Product_Dimension
WHERE ProductID in (
SELECT ProductID FROM northwindDW.dbo.Product_Dimension EXCEPT
SELECT ProductID
FROM northwindStage.dbo.Product_Dimension)) and ValidTo = '9999-01-01'
