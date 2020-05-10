-- Delcaring variables
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Indsætter værdier i database tmp
SELECT
  ProductID,
  Product_Name,
  Category
  INTO #tmp
FROM northwindStage.dbo.Product_Dimension EXCEPT
-- Tjekker ændringer
SELECT
  ProductID,
  Product_Name,
  Category
FROM northwindDW.dbo.Product_Dimension
WHERE ValidTo = '9999-01-01' EXCEPT
SELECT
  ProductID,
  Product_Name,
  Category
FROM northwindStage.dbo.Product_Dimension
WHERE ProductID in (
SELECT ProductID FROM northwindStage.dbo.Product_Dimension EXCEPT
SELECT ProductID FROM northwindDW.dbo.Product_Dimension
WHERE ValidTo = '9999-01-01')


-- Indsætter værdier fra tmp ind i Product_Dimension
INSERT INTO northwindDW.dbo.Product_Dimension (
  ProductID,
  Product_Name,
  Category,
  ValidFrom,
  ValidTo)
SELECT
  ProductID,
  Product_Name,
  Category,
  @NewLoadDate,
  @FutureDate
FROM #tmp

-- updatere ValidTo i Product_Dimension
UPDATE northwindDW.dbo.Product_Dimension
SET ValidTo = DATEADD(DAY, -1, @NewLoadDate)
WHERE ProductID in (
SELECT ProductID FROM #tmp)
and
northwindDW.dbo.Product_Dimension.ValidFrom < @NewLoadDate

DROP TABLE IF exists #tmp
