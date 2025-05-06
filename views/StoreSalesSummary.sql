CREATE VIEW vw_StoreSalesSummary AS
SELECT 
	store_name, 
	round(sum((quantity * list_price)*(1-discount)), 2) Revenue, 
	COUNT(DISTINCT ord.order_id) Orders,
	round(sum((quantity * list_price)*(1-discount))/COUNT(DISTINCT ord.order_id), 2) AOV
FROM Sales.Stores st
JOIN Sales.Orders ord
ON st.store_id = ord.store_id
JOIN Sales.Order_items oi
ON ord.order_id = oi.order_id
GROUP BY store_name;
