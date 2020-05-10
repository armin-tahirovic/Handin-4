-- Declaring variable
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

DECLARE @NewLoadDate DATE
SET @NewLoadDate = GETDATE()

DECLARE @FutureDate DATE
SET @FutureDate = '9999-01-01'


-- Laver Create til Customer_Dimension
TRUNCATE TABLE northwindDW.dbo.Customer_Dimension
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
FROM [northwindStage].[dbo].[Customer_Dimension]

-- Efterfølgende bliver brugt til at finde nye records
WHERE CustomerID in (
SELECT [CustomerID] FROM [northwindStage].[dbo].[Customer_Dimension]
EXCEPT
SELECT [CustomerID] FROM [northwindDW].[dbo].[Customer_Dimension]
WHERE ValidTo = '1997-12-31')
