create view vw_TopBrands as
select 
	brand_name,
	count(distinct order_id) CountOfOrders,
	count(*) ProductsSold,
	sum((quantity*o.list_price)*(1-discount)) TotalSales
from sales.Order_items o
join Production.Products p
on o.product_id = p.product_id
join Production.Brands b
on p.brand_id = b.brand_id
group by brand_name

--This view allows us to see the popularity of each brand by sold products of that brand. This may help the company identify whose products are best to sell and put more focus on that, and those brands that can be ignored due to their low popularity among customers
