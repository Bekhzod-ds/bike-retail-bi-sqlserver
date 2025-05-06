CREATE VIEW vw_PerformanceBySales AS
SELECT 
  YEAR(order_date) Year,
	SUM((quantity*list_price)*(1-discount)) Sales,
	isnull(SUM((quantity*list_price)*(1-discount))-LAG(SUM((quantity*list_price)*(1-discount))) OVER (ORDER BY YEAR(order_date)), 0) SalesDiff,
	COUNT(DISTINCT ord.order_id) Orders,
	ISNULL(COUNT(DISTINCT ord.order_id)-LAG(COUNT(DISTINCT ord.order_id)) OVER (ORDER BY YEAR(order_date)), 0) OrdersDiff
FROM Sales.Customers cus
JOIN sales.Orders ord
ON cus.customer_id = ord.customer_id
JOIN sales.Order_items oi
ON ord.order_id = oi.order_id
GROUP BY YEAR(order_date)
