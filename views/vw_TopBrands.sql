create view vw_TopBrands as
select 
	brand_name,
	sum((quantity*o.list_price)*(1-discount)) TotalSales
from sales.Order_items o
join Production.Products p
on o.product_id = p.product_id
join Production.Brands b
on p.brand_id = b.brand_id
group by brand_name
