DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Laver Create til Employee_Dimension
INSERT INTO northwindDW.dbo.Employee_Dimension (
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  Hire_date,
  ValidFrom,
  ValidTo)
SELECT
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  Hire_date,
  @NewLoadDate,
  @FutureDate
FROM northwindStage.dbo.Employee_Dimension

-- Efterfølgende bliver brugt til at finde nye records
WHERE EmployeeID in (
SELECT EmployeeID FROM northwindStage.dbo.Employee_Dimension
EXCEPT
SELECT EmployeeID FROM northwindDW.dbo.Employee_Dimension
WHERE ValidTo = '9999-01-01')
