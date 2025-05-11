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

--This view allows us to see how popular each brand that supplies the company with products is. This may help the company identify strong brands whose products are best to sell and supply more of their products as customers are more likely ot buy them as opposed to products of those brands that are not so popular
--with this data, we can identify products that do well, which should be promoted or products the company should probably discontinue.
