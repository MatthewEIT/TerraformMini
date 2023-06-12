CREATE TABLE [dbo].[Products](
	[ProductID] [int] NULL,
	[ProductName] [varchar](1000) NULL,
	[Quantity] [int] NULL,
	[ProductImage] [varchar](1000) NULL
) ON [PRIMARY]

INSERT INTO Products(ProductID,ProductName,Quantity,ProductImage) VALUES (1,'Mobile',100,'https://miniprojectstorage342.blob.core.windows.net/images/Mobile.jpg')

INSERT INTO Products(ProductID,ProductName,Quantity,ProductImage) VALUES (2,'Laptop',200,'https://miniprojectstorage342.blob.core.windows.net/images/Laptop.jpg')

INSERT INTO Products(ProductID,ProductName,Quantity,ProductImage) VALUES (3,'Tabs',300,'https://miniprojectstorage342.blob.core.windows.net/images/Tab.jpg')