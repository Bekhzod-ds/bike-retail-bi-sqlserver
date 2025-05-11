CREATE VIEW vw_StoreSalesSummary AS
SELECT 
	store_id,
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
	store_id,
	store_name;

--This view allows us to see the performance (Revenue, Number of orders, and AOV) of each of the company's stores.
--AOV or Average Order Value is a crucial KPI indicator as it allows the company analyze customer spending behavior. This insight may help develop strategies to make customers purchase above that Average by setting a minimum cost for free shipping, or a bonus product, or a discount or sth else. In this case we have AOV of 4900, 4600 and 4700 for three stores store. We could offer free shipping or a discount if the order price is above 5000.
