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
GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date)

--This view Calculates Total sales by quarter in each year. This allows for tracking trends over a period of time to see how well a company has been performing. It also migh help find correlations between performance on a specific quarter of a year and an event that previously was thought to have no relation to sales
