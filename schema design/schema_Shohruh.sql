CREATE DATABASE BikeStore
GO
USE BikeStore
GO
CREATE SCHEMA Production;
GO
CREATE SCHEMA Sales;
GO
CREATE TABLE Production.Brands(
	brand_id INT PRIMARY KEY,
	brand_name VARCHAR(100) NOT NULL
);

BULK INSERT Production.Brands 
FROM 'D:\Project\brands.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

CREATE TABLE Production.Categories(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL
);

BULK INSERT Production.Categories
FROM 'D:\Project\categories.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

CREATE TABLE Production.Products(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(100),
	brand_id INT,
	category_id INT,
	model_year DATE,
	list_price DECIMAL(10, 2)
	FOREIGN KEY (brand_id) REFERENCES Production.Brands(brand_id),
	FOREIGN KEY (category_id) REFERENCES Production.Categories(category_id)
);

BULK INSERT Production.Products 
FROM 'D:\Project\products.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

CREATE TABLE Sales.Stores(
	store_id INT PRIMARY KEY,
	store_name VARCHAR(100) NOT NULL,
	phone VARCHAR(50),
	email VARCHAR(50),
	street VARCHAR(70),
	city VARCHAR(50),
	state VARCHAR(50),
	zip_code VARCHAR(10)
);

BULK INSERT Sales.Stores 
FROM 'D:\Project\stores.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

CREATE TABLE Production.Stocks(
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES Sales.Stores(store_id),
	FOREIGN KEY (product_id) REFERENCES Production.Products(product_id)
);

BULK INSERT Production.Stocks
FROM 'D:\Project\stocks.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

CREATE TABLE Sales.Customers(
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	phone VARCHAR(50),
	email VARCHAR(256)
);

CREATE TABLE Sales.Customer_Address(
	customer_id INT PRIMARY KEY,
	street VARCHAR(100),
	city VARCHAR(50),
	state VARCHAR(50),
	zip_code VARCHAR(20)
	FOREIGN KEY (customer_id) REFERENCES Sales.Customers(customer_id)
);

CREATE TABLE Sales.Staff(
	staff_id INT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50),
	phone VARCHAR(50),
	active INT,
	store_id INT,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES sales.Stores(store_id),
	FOREIGN KEY (manager_id) REFERENCES Sales.Staff(staff_id)
);

BULK INSERT sales.Staff 
FROM 'D:\Project\staffs.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

CREATE TABLE Sales.Orders(
	order_id INT PRIMARY KEY,
	customer_id INT,
	order_status INT,
	order_date DATE null,
	required_date DATE null,
	shipped_date DATE null,
	store_id INT,
	staff_id INT,
	FOREIGN KEY (customer_id) REFERENCES Sales.Customers(customer_id),
	FOREIGN KEY (store_id) REFERENCES Sales.Stores(store_id),
	FOREIGN KEY (staff_id) REFERENCES Sales.Staff(staff_id)
);

CREATE TABLE Sales.Order_items(
	order_id INT,
	item_id INT,
	product_id INT,
	quantity INT,
	list_price DECIMAL(10, 2),
	discount DECIMAL(10, 2),
	PRIMARY KEY(order_id, item_id),
	FOREIGN KEY (product_id) REFERENCES Production.Products(product_id),
	FOREIGN KEY (order_id) REFERENCES Sales.Orders(order_id)
);

BULK INSERT Sales.Order_items 
FROM 'D:\Project\order_items.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	keepnulls
);	
