CREATE VIEW vw_StoreSalesSummary AS
select 
	store_name, 
	round(sum((quantity * list_price)*(1-discount)), 2) Revenue, 
	count(distinct ord.order_id) Orders,
	round(sum((quantity * list_price)*(1-discount))/count(distinct ord.order_id), 2) AOV
from Sales.Stores st
join Sales.Orders ord
on st.store_id = ord.store_id
join Sales.Order_items oi
on ord.order_id = oi.order_id
group by store_name;
