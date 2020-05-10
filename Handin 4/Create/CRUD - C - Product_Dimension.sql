DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Laver Create til Product_Dimension
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
FROM northwindStage.dbo.Product_Dimension

-- Efterfølgende bliver brugt til at finde nye records
WHERE ProductID in (
SELECT ProductID FROM northwindStage.dbo.Product_Dimension
EXCEPT
SELECT ProductID FROM northwindDW.dbo.Product_Dimension
WHERE ValidFrom = '9999-01-01')
