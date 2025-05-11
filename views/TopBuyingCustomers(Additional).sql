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

--This view lists top 100 customers by sales. This allows us to identify customers that bring s the most profits compared to other customers and grant them different kinds of perks like discounts or bonuses to retain those clients for longer. This way they'll be encouraged to purchase goods from the company
