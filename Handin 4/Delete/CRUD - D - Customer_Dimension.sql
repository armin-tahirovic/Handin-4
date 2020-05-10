-- Declaring variables
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Gør data ugyldig, bliver aldrig slettet
UPDATE northwindDW.dbo.Customer_Dimension
SET ValidTo = DATEADD(DAY, -1, @NewLoadDate)
WHERE CustomerID in (
SELECT CustomerID FROM northwindDW.dbo.Customer_Dimension
WHERE CustomerID in (
SELECT CustomerID FROM northwindDW.dbo.Customer_Dimension EXCEPT
SELECT CustomerID
FROM northwindStage.dbo.Customer_Dimension)) and ValidTo = '9999-01-01'


INSERT INTO LogFile ([Table], LastLoadDate) VALUES ('Customer_Dimension', @NewLoadDate)
