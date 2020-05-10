-- Declaring variables
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'

-- Indsætter værdier i database tmp
SELECT
  CustomerID,
  City,
  Region,
  Country
  INTO #tmp
FROM northwindStage.dbo.Customer_Dimension EXCEPT
-- Tjekker ændringer
SELECT
  CustomerID,
  City,
  Region,
  Country
FROM northwindDW.dbo.Customer_Dimension
WHERE ValidTo = '9999-01-01' EXCEPT
SELECT
  CustomerID,
  City,
  Region,
  Country
FROM northwindStage.dbo.Customer_Dimension
WHERE CustomerID in (
SELECT CustomerID FROM northwindStage.dbo.Customer_Dimension EXCEPT
SELECT CustomerID FROM northwindDW.dbo.Customer_Dimension
WHERE ValidTo = '9999-01-01')

-- Indsætter værdier fra tmp ind i Customer_Dimension
INSERT INTO northwindDW.dbo.Customer_Dimension (
  CustomerID,
  City,
  Region,
  Country,
  ValidFrom,
  ValidTo)
SELECT
  CustomerID,
  City,
  Region,
  Country,
  @NewLoadDate,
  @FutureDate
FROM #tmp

-- updatere ValidTo i Customer_Dimension
UPDATE northwindDW.dbo.Customer_Dimension
SET ValidTo = DATEADD(DAY, -1, @NewLoadDate)
WHERE CustomerID in (
SELECT CustomerID FROM #tmp)
and
northwindDW.dbo.Customer_Dimension.ValidFrom < @NewLoadDate

DROP TABLE IF exists #tmp
