create database BikeStoreDB

use BikeStoreDB

create schema Sales

create schema Production

--brands table
create table Production.brands( 
brand_id int  primary key,
brand_name varchar(100)
)

bulk insert Production.brands
from 'D:\MAAB\Project 1\Sources\brands.csv'
with ( fieldterminator =',',
		rowterminator ='\n',
		firstrow=2)
	
---------------------------------------------------------
--categories table

create table Production.categories(
category_id int primary key,
category_name varchar(max))

bulk insert Production.categories
from 'D:\MAAB\Project 1\Sources\categories.csv'
with( fieldterminator = ',',
		rowterminator='\n',
		firstrow=2)


-----------------------------------------------------------------
--products table

create table Production.products(
product_id int primary key,
product_name varchar(max),
brand_id int ,
category_id int,
model_year int,
list_price decimal(10,2),
foreign key(brand_id) references Production.brands(brand_id),
foreign key(category_id) references Production.categories(category_id)
)

bulk insert Production.products
from 'D:\MAAB\Project 1\Sources\products.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2)


-------------------------------------------------------------
--stocks table

create table Production.stocks(
store_id int ,
product_id int ,
quantity int,
primary key(store_id,product_id),
foreign key(product_id) references Production.products(product_id),
foreign key(store_id) references Sales.stores(store_id))

bulk insert Production.stocks
from 'D:\MAAB\Project 1\Sources\stocks.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2)


-------------------------------------------------------------
--customers table

create table Sales.customers(
customer_id int primary key,
first_name varchar(100),
last_name varchar(100),
phone varchar(50),
email varchar(100),
street varchar(100),
city varchar(50),
state varchar(50),
zip_code int
)

bulk insert Sales.customers
from 'D:\MAAB\Project 1\Sources\customers.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2)


---------------------------------------------------------
--orders table

create table Sales.orders(
order_id int primary key,
customer_id int,
order_status int,
order_date date null,
required_date date null,
shipped_date date null ,
store_id int,
staff_id int,
foreign key(customer_id) references Sales.customers(customer_id),
foreign key(store_id) references Sales.stores(store_id),
foreign key(staff_id) references Sales.staffs(staff_id)
)

bulk insert Sales.orders
from 'D:\MAAB\Project 1\Sources\orders.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2,
		keepnulls)


-----------------------------------------------------------
--staffs table

create table Sales.staffs(
staff_id int primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(50),
phone varchar(50),
active int,
store_id int,
manager_id int null)


bulk insert Sales.staffs
from 'D:\MAAB\Project 1\Sources\staffs.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2,
		keepnulls)


---------------------------------------------------------------
--stores table

create table Sales.stores(
store_id int primary key,
store_name varchar(50),
phone varchar(50),
email varchar(50),
street varchar(50),
city varchar(50),
state varchar(50),
zip_code int
)

bulk insert Sales.stores
from 'D:\MAAB\Project 1\Sources\stores.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2)

----------------------------------------------------------
--order_items table

create table Sales.order_items(
order_id int primary key,
item_id int,
product_id int,
quantity int,
list_price decimal(10,2),
discount decimal(10,2),
foreign key (order_id) references Sales.orders(order_id),
foreign key(product_id) references Production.products(product_id))

bulk insert Sales.order_items
from 'D:\MAAB\Project 1\Sources\order_items.csv'
with ( fieldterminator=',',
		rowterminator='\n',
		firstrow=2)

