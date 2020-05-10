ALTER TABLE [northwindDW].[dbo].[Customer_dimension]
ADD ValidFrom DATE, ValidTo DATE

ALTER TABLE [northwindDW].[dbo].[Employee_dimension]
ADD ValidFrom DATE, ValidTo DATE

ALTER TABLE [northwindDW].[dbo].[Product_dimension]
ADD ValidFrom DATE, ValidTo DATE

UPDATE [northwindDW].[dbo].[Customer_Dimension]
SET ValidFrom = '1996-01-01', ValidTo = '1997-12-31'

UPDATE [northwindDW].[dbo].[Employee_Dimension]
SET ValidFrom = '1996-01-01', ValidTo = '1997-12-31'

UPDATE [northwindDW].[dbo].[Product_Dimension]
SET ValidFrom = '1996-01-01', ValidTo = '1997-12-31'
