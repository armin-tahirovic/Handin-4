-- Declaring variables
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Indsætter værdier i database tmp
SELECT
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  Hire_date
  INTO #tmp
FROM northwindStage.dbo.Employee_Dimension EXCEPT
-- Tjekker ændringer
SELECT
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  Hire_date
FROM northwindDW.dbo.Employee_Dimension
WHERE ValidTo = '9999-01-01' EXCEPT
SELECT
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  Hire_date
FROM northwindStage.dbo.Employee_Dimension
WHERE EmployeeID in (
SELECT EmployeeID FROM northwindStage.dbo.Employee_Dimension EXCEPT
SELECT EmployeeID FROM northwindDW.dbo.Employee_Dimension
WHERE ValidTo = '9999-01-01')


-- Indsætter værdier fra tmp ind i Employee_Dimension
INSERT INTO northwindDW.dbo.Employee_Dimension(
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  ValidFrom,
  ValidTo)
SELECT
  EmployeeID,
  Title,
  First_Name,
  Last_Name,
  Hire_Date,
  @NewLoadDate,
  @FutureDate
FROM #tmp


-- updatere ValidTo i Employee_Dimension
UPDATE northwindDW.dbo.Employee_Dimension
SET ValidTo = DATEADD(DAY, -1, @NewLoadDate)
WHERE EmployeeID in (
SELECT EmployeeID FROM #tmp)
and
northwindDW.dbo.Employee_Dimension.ValidFrom < @NewLoadDate

DROP TABLE IF exists #tmp
