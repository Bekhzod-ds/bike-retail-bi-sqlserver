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
FROM 'D:\Project\customers.csv'
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
FROM 'D:\Project\orders.csv'
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
FROM 'D:\Project\order_items.csv'
WITH(
	ROWTERMINATOR = '\n',
	FIELDTERMINATOR = ',',
	FIRSTROW = 2,
	keepnulls
);	
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
create view vw_StaffPerformance as (
  select o.staff_id,
  		count(distinct o.order_id) as orders_per_staff,
    sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
from sales.Order_items oi
join sales.Orders o 
on oi.order_id = o.order_id
group by o.staff_id
 );

create view vw_RegionalTrends as (
select s.city,
s.state,
rev.total
from sales.stores s
join (
select o.store_id,
     sum((oi.quantity * oi.list_price) * (1 - oi.discount)) as total
from sales.order_items oi
join sales.orders o
on o.order_id=oi.order_id
group by o.store_id 
) rev
on rev.store_id=s.store_id);

CREATE VIEW vw_SalesByQuarter AS
SELECT 
	YEAR(order_date) Year,
	'Q' + CAST(DATEPART(QUARTER, order_date) AS VARCHAR(1)) Quarter,
	SUM((quantity*list_price)*(1-discount)) Sales
FROM Sales.Customers cus
JOIN sales.Orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.Order_items oi
ON ord.order_id = oi.order_id
GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date);

CREATE VIEW vw_StoreSalesSummary AS
SELECT 
	st.store_id,
	store_name, 
	round(sum((quantity * list_price)*(1-discount)), 2) Revenue, 
	COUNT(DISTINCT ord.order_id) Orders,
	round(sum((quantity * list_price)*(1-discount))/COUNT(DISTINCT ord.order_id), 2) AOV
FROM Sales.Stores st
JOIN Sales.Orders ord
ON st.store_id = ord.store_id
JOIN Sales.Order_items oi
ON ord.order_id = oi.order_id
GROUP BY 
	st.store_id,
	store_name;


CREATE VIEW vw_TopBuyingCustomers AS
SELECT TOP 100
	CONCAT(first_name, ' ', last_name) AS Full_Name,
	SUM((quantity * list_price) * (1-discount)) AS TotalSales
FROM Sales.Customers cus
JOIN sales.Orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.Order_items oi
ON ord.order_id = oi.order_id
GROUP BY CONCAT(first_name, ' ', last_name)
ORDER BY TotalSales DESC;

CREATE VIEW vw_InventoryStatus AS
SELECT S.store_id, store_name, P.product_id, product_name, quantity
FROM Production.Stocks St 
JOIN Sales.Stores S ON St.store_id = S.store_id
JOIN Production.Products P ON P.product_id = St.product_id
WHERE quantity < 10; -- threshold I chose it since // another table can be created too to find the threshold


create view vw_TopBrands as
select 
	brand_name,
	count(distinct order_id) CountOfOrders,
	sum(quantity) ProductsSold,
	sum((quantity*o.list_price)*(1-discount)) TotalSales
from sales.Order_items o
join Production.Products p
on o.product_id = p.product_id
join Production.Brands b
on p.brand_id = b.brand_id
group by brand_name

CREATE VIEW vw_SalesByCategory AS
SELECT 
    c.category_name,
    SUM(oi.quantity) AS TotalQuantity,
    SUM(oi.list_price * oi.quantity) AS TotalRevenue,
    SUM(p.list_price * oi.quantity) AS TotalCost,
    ROUND(
        (SUM(oi.list_price * oi.quantity) - SUM(p.list_price * oi.quantity)) 
        / NULLIF(SUM(oi.list_price * oi.quantity), 0) * 100, 2
    ) AS gross_margin_percent
FROM sales.order_items oi
JOIN production.products p ON p.product_id = oi.product_id
JOIN production.categories c ON c.category_id = p.category_id
GROUP BY c.category_name;




create proc sp_StoreKPI @storeID int = null
as
	if @storeID is null
	begin
		with CTEMultipleVisits as(
		select
			store_id,
			Customer_id
		from sales.Orders
		group by 
			store_id,
			customer_id
		having count(*) > 1
		),
		CTECountRentn as(
		select store_id,
			round((cast(count(*) as float)/(select count(*) from sales.Orders where store_id = CTEMultipleVisits.store_id))*100, 2) Retention_rate
		from CTEMultipleVisits
		group by store_id
		)

		select sss.*, 
			Retention_rate,
			CountOfStaff
		from CTECountRentn cte
		join vw_StoreSalesSummary sss
		on cte.store_id = sss.store_id
		cross apply (select count(*) CountOfStaff from sales.Staff where store_id = sss.store_id) staff

	end
	else
	begin
		with CTEMultipleVisits as(
		select
			store_id,
			Customer_id
		from sales.Orders
		where store_id = @storeID
		group by 
			store_id,
			customer_id
		having count(*) > 1
		),
		CTECountRentn as(
		select store_id,
			round((cast(count(*) as float)/(select count(*) from sales.Orders where store_id = CTEMultipleVisits.store_id))*100, 2) Retention_rate
		from CTEMultipleVisits
		group by store_id
		)
		select sss.*, 
			Retention_rate,
			CountOfStaff
		from CTECountRentn cte
		join vw_StoreSalesSummary sss
		on cte.store_id = sss.store_id
		cross apply (select count(*) CountOfStaff from sales.Staff where store_id = sss.store_id) staff
	end

CREATE PROCEDURE sp_ComparebySales
    @Year1 INT,
    @Year2 INT
AS
BEGIN
    SELECT
        YEAR(o.order_date) AS SalesYear,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS TotalSales   -- 90% of the full sales value → which is the actual money the shop receives from the customer (i.e., net sales) after giving 10% discount from total(100%) sales
    FROM sales.order_items oi 
    JOIN sales.orders o ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) IN (@Year1, @Year2)
    GROUP BY YEAR(o.order_date);
END;

EXEC sp_ComparebySales @Year1 = 2017, @Year2 = 2018;

CREATE PROCEDURE sp_GenerateRestockList (@StoreID INT = NULL)
AS
BEGIN
    DECLARE @Threshold INT = 10;  -- I randomly chose it, we can also create a seperate table for it
    IF @StoreID IS NULL
    BEGIN
        SELECT s.store_id, s.product_id, p.product_name, s.quantity FROM Production.Stocks s
JOIN Production.Products p ON s.product_id = p.product_id WHERE s.quantity < @Threshold;
END
ELSE
    BEGIN
        SELECT s.store_id, s.product_id, p.product_name, s.quantity FROM Production.Stocks s
JOIN Production.Products p ON s.product_id = p.product_id 
WHERE s.store_id = @StoreID AND s.quantity < @Threshold;
END
END;




create procedure sp_GetCustomerProfile
as
begin
 
    	with CTE_MostBought as(
select
  o.customer_id,
  product_id,
  sum(quantity) orderqty,
  row_number() over (partition by customer_id order by sum(quantity) desc) rnk
from sales.Orders o
join sales.Order_items oi on o.order_id = oi.order_id
group by o.customer_id, product_id 
),

 CTE_Totals as(

select 
        o.customer_id,
        sum(oi.list_price * oi.quantity * (1 - oi.discount)) as total_spends,
        count(o.order_id) as total_orders
    from sales.Orders o
    join sales.Order_items oi on o.order_id = oi.order_id
	
    group by o.customer_id
	)


select
  mb.customer_id,
  t.total_spends,
  t.total_orders,
  mb.product_id as most_bought_product
from CTE_MostBought mb
join CTE_Totals t
on mb.customer_id=t.customer_id

where mb.rnk = 1
    
end;
