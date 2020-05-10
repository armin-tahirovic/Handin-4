UPDATE northwindStage.dbo.Customer_Dimension
SET Region = 'UNKNOWN'
WHERE Region is null
