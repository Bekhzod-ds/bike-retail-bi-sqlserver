CREATE DATABASE Project1
GO
USE Project1
GO
CREATE SCHEMA Production
GO
CREATE SCHEMA Sales
GO

-- Tables:

CREATE TABLE Production.Brands(
	brand_id INT PRIMARY KEY,
	brand_name VARCHAR(100) NOT NULL
);
BULK INSERT Production.Brands
FROM '/data/brands.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


CREATE TABLE Production.Categories(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL
);

BULK INSERT Production.Categories
FROM '/data/categories.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
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
FROM '/data/Products.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
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
FROM '/data/Stores.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
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
FROM '/data/Stocks.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
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

CREATE TABLE Sales.#Temp_Customers(
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	phone VARCHAR(50),
	email VARCHAR(256),
	street VARCHAR(100),
	city VARCHAR(50),
	state VARCHAR(50),
	zip_code VARCHAR(20)
);

BULK INSERT Sales.#Temp_Customers
FROM '/data/customers.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

insert into Sales.Customers
select 
	customer_id,
	first_name, 
	last_name, 
	iif(phone = 'NULL', null, phone) phone,
	email
from sales.#Temp_Customers

insert into Sales.Customer_Address
select 
	customer_id,
	street,
	city,
	state,
	zip_code
from sales.#Temp_Customers

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

BULK INSERT Sales.Staff
FROM '/data/staffs.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
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

CREATE TABLE Sales.#Orders_Staging(
	order_id INT PRIMARY KEY,
	customer_id INT,
	order_status INT,
	order_date VARCHAR(50),
	required_date VARCHAR(50),
	shipped_date VARCHAR(50),
	store_id INT,
	staff_id INT,
	FOREIGN KEY (customer_id) REFERENCES Sales.Customers(customer_id),
	FOREIGN KEY (store_id) REFERENCES Sales.Stores(store_id),
	FOREIGN KEY (staff_id) REFERENCES Sales.Staff(staff_id)
);

BULK INSERT Sales.#Orders_Staging
FROM '/data/orders.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2
);

INSERT INTO Sales.Orders
SELECT 
	order_id,
	customer_id,
	order_status, 
	TRY_CAST(order_date AS DATE) as order_date,
	TRY_CAST(required_date AS DATE) as required_date,
	TRY_CAST(shipped_date AS DATE) as shipped_date, 
	store_id,
	staff_id
FROM sales.#Orders_Staging

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
FROM '/data/order_items.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	keepnulls
);	





