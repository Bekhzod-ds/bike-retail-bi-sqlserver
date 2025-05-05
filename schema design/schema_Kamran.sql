
create database Projects

use Projects

create schema sales

create schema production


create table customers (
customer_id int primary key identity(1,1),
first_name varchar(20),
last_name varchar(20),
phone varchar(30),
email varchar(100),
street varchar(100),
city varchar(50),
state varchar(10),
zip_code varchar(10)

)

bulk insert customers
from 'C:\Users\munnaboy\Downloads\orders.csv'
with (
Fieldterminator=',',
Rowterminator='\n',
Firstrow= 2
);


CREATE TABLE orders (
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    order_status VARCHAR(30),
    order_date VARCHAR(20),
    required_date VARCHAR(20),
    shipped_date VARCHAR(20),  -- Will accept any format
    store_id VARCHAR(20),
    staff_id VARCHAR(20)
);

bulk insert orders
from 'C:\Users\munnaboy\Downloads\orders.csv'
with (
Fieldterminator=',',
Rowterminator='\n',
Firstrow= 2
);


create table order_items (
order_id int,
customer_id int,
product_id int,
quantity int,
list_price decimal(10,2),
discount decimal(10,2)
);


bulk insert order_items
from 'C:\Users\munnaboy\Downloads\order_items.csv'
with (
Fieldterminator =',',
Rowterminator = '\n',
Firstrow=2
);


select * from order_items

------------------------------------


create table staffs (
staff_id int primary key identity(1,1),
first_name varchar(50),
last_name varchar(50),
email varchar(50),
phone varchar(50),
active  char(10),
store_id int,
manager_id int
);


BULK INSERT staffs
FROM 'C:\Users\munnaboy\Downloads\staffs.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 3,
    KEEPNULLS
	)

select * from staffs

------------------------------------

create table stores (
store_id int primary key identity (1,1),
store_name varchar(30),
phone varchar(50),
email varchar(50),
street varchar(50),
city varchar(50),
state varchar(30),
zip_code varchar(10)
);


bulk insert stores
from 'C:\Users\munnaboy\Downloads\stores.csv'
with (
Fieldterminator=',',
rowterminator='\n',
firstrow=2
);


select * from stores

------------------------------


create table categories (
category_id int primary key identity(1,1),
category_name varchar(50)
)


bulk insert categories
from 'C:\Users\munnaboy\Downloads\categories.csv'
with (
Fieldterminator=',',
Rowterminator='\n',
Firstrow=2
)

select * from categories
---------------------------

create table products (
product_id int primary key identity (1,1),
product_name varchar(50),
brand_id int,
category_id int,
model_year int,
list_price decimal(10,2)
)

bulk insert products
from 'C:\Users\munnaboy\Downloads\products.csv'
with (
Fieldterminator=',',
Rowterminator='\n',
firstrow=2
)

ALTER TABLE products ALTER COLUMN product_name VARCHAR(255);


select * from products

-----------------------------
create table stocks (
store_id int,
product_id int,
quantity int
)


bulk insert stocks
from 'C:\Users\munnaboy\Downloads\stocks.csv'
with (
Fieldterminator=',',
Rowterminator='\n',
Firstrow=2
)

select * from stocks


create table brands (
brand_id int primary key identity(1,1),
brand_name varchar(50)
)

bulk insert brands
from 'C:\Users\munnaboy\Downloads\brands.csv'
with (
Fieldterminator=',',
Rowterminator='\n',
Firstrow=2
)

select * from brands



----------------------------


ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);                 -- here i added foreign key to join Orders and Customers tables




ALTER TABLE orders
ADD CONSTRAINT fk_orders_stores
FOREIGN KEY (store_id) REFERENCES stores(store_id);           -- here i made one to many relationship between orders  and stores tables

alter table staffs
add constraint fk_staffs_stores
foreign key (store_id) references stores(store_id);                        -- here i made one to many realtionship between stores and staffs tables



alter table orders
add constraint fk_orders_staffs                                       -- here i made a one to many relationship between stafs and orders tables
foreign key (staff_id) references staffs(staff_id);





alter table order_items
add constraint fk_order_items_orders
foreign key (order_id) references orders(order_id);                      


alter table order_items
add constraint fk_order_items_products
foreign key (product_id) references products(product_id);                    -- here i made many to many relationship between products and orders table through order_items table

-----------------------------------------------------------
alter table products 
add constraint fk_products_brands                                              -- here i made one to many realtionship between brands and products tables
foreign key (brand_id) references brands(brand_id);


ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (category_id) REFERENCES categories(category_id);


alter table order_items
add constraint fk_products_order_items
foreign key (product_id)references products(product_id);                         --here i made one to many relationship between products and order_items tables


alter table stocks
add constraint fk_stocks_products
foreign key (product_id) references products(product_id); 

alter table stocks
add constraint fk_stock_stores
foreign key (store_id) references stores(store_id);                            -- at the end there was a many to many relationship between products,stores and stocks tables.




