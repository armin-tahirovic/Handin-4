-- DECLARING VARIABLE
DECLARE @LastLoadDate DATE
SET @LastLoadDate = '1997-12-31'

-- Indsætter alle værdier efter 1997-12-31 i Fact_sales
TRUNCATE TABLE northwindStage.dbo.Fact_sales
INSERT INTO northwindStage.dbo.Fact_sales(
  CustomerID,
  EmployeeID,
  ProductID,
  DateID,
  Quantity,
  SalesAmount)
SELECT
  CustomerID,
  EmployeeID,
  ProductID,
  OrderDate,
  Quantity,
  UnitPrice * Quantity
FROM northwindDB.dbo.Orders o
  inner join northwindDB.dbo.[Order Details] od
  ON o.OrderID = od.OrderID
  WHERE o.OrderDate > (@LastLoadDate)

-- Opdatere SalesFact på grund af surrogate nøglerne
Insert into [northwindDW].[dbo].[SalesFact] 
(      [P_ID]
      ,[C_ID]
      ,[E_ID]
      ,[D_ID]
      ,[Quantity]
      ,[SalesAmount])
      select p.[P_ID]
      ,c.[C_ID]
      ,e.[E_ID]
      ,od.[D_ID]
      ,f.[SalesAmount]
      ,f.[Quantity]

      from [northwindStage].[dbo].[Fact_sales] f 
      left join [northwindDW].[dbo].[Product_Dimension] as p
      on p.ProductId = f.ProductID
      left join [dbo].[Customer_Dimension] as c
      on c.CustomerId = f.CustomerId
      left join [dbo].[Employee_Dimension] as e
      on e.EmployeeId = f.EmployeeId
      left join [dbo].[Date_Dimension] as od
      on od.DateID = f.DateID
      WHERE p.ValidTo = '9999-01-01'
      and c.ValidTo = '1997-12-31'
      and e.ValidTo = '9999-01-01'
