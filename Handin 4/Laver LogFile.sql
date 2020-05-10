CREATE TABLE LogFile (
  [Table] NVARCHAR(50) NULL,
  LastLoadDate DATE NULL) ON [PRIMARY]
GO


INSERT INTO LogFile ([Table], LastLoadDate) VALUES ('Customer_Dimension', '1997-12-31')
INSERT INTO LogFile ([Table], LastLoadDate) VALUES ('Employee_Dimension', '1998-12-31')
INSERT INTO LogFile ([Table], LastLoadDate) VALUES ('Product_Dimension', '1998-12-31')
INSERT INTO LogFile ([Table], LastLoadDate) VALUES ('SalesFact', '1998-12-31')
