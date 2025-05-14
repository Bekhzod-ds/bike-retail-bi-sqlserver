# SQL Server Agent Job Setup Documentation
=================================

Job Name: Load_CSV_and_Log_Audit

## Purpose:
--------
This SQL Agent Job loads sales data from a CSV file into a database table,
executes a data load stored procedure, and logs the activity in an audit table.
Steps:
------

1. Step Name: Bulk_insert
   Type: Transact-SQL
   Command:
       EXEC insert;

2. Step Name: RestockList
   Type: Transact-SQL
   Command:
       EXEC sp_RestockList;

3. Step Name: Customer Profile
Type: Transact-SQL
   Command:
       EXEC sp_GetCustomerProfile;


## Schedule:
---------
- Name: Weeklyload
- Frequency: Weekly, Every sunday
- Time: 12:00 AM
- Start Date: 14.05.2025

## File Info:
----------
### 1st table.
- Folder path: D:\Project
- CSV file: new_orders.csv
- Format: Comma-separated, with header row

### 2nd table.
- Folder path: D:\Project
- CSV file: new_order_items.csv
- Format: Comma-separated, with header row

## Stored Procedures:
------------------

1. sp_GenerateRestockList
   Retrieves the products running low on stock

2. sp_GetCustomerProfile
   Retrieves information about customers' purchases

## Tables:
-------

1. Sales.Orders
‌	order_id INT PRIMARY KEY,
‌	customer_id INT,
‌	order_status INT,
‌	order_date DATE null,
‌	required_date DATE null,
‌	shipped_date DATE null,
‌	store_id INT,
‌	staff_id INT

2. Sales.Order_items
‌	order_id INT,
‌	item_id INT,
‌	product_id INT,
‌	quantity INT,
‌	list_price DECIMAL(10, 2),
‌	discount DECIMAL(10, 2),
‌	PRIMARY KEY(order_id, item_id)

## Additional Notes:
-----------------

- Ensure the SQL Server Agent is running.
- Make sure SQL Server has permission to access the folder.
- BULK INSERT will fail if path or permissions are incorrect.
