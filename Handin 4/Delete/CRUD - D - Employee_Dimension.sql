-- Declaring variable
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Gør data ugyldig, bliver aldrig slettet
UPDATE northwindDW.dbo.Employee_Dimension
SET ValidTo = DATEADD(DAY, -1, @NewLoadDate)
WHERE EmployeeID in (
SELECT EmployeeID FROM northwindDW.dbo.Employee_Dimension
WHERE EmployeeID in (
SELECT EmployeeID FROM northwindDW.dbo.Employee_Dimension EXCEPT
SELECT EmployeeID
FROM northwindStage.dbo.Employee_Dimension)) and ValidTo = '9999-01-01'


INSERT INTO LogFile ([Table], LastLoadDate) VALUES ('Employee_Dimension', @NewLoadDate)
