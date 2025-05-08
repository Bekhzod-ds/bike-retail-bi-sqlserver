create view vw_RegionalTrends as (
select s.state,
     s.city,
rev.total
from sales.stores s
join (
select o.store_id,
     sum((oi.quantity * oi.list_price) * (1 - oi.discount)) as total
from sales.order_items oi
join sales.orders o
on o.order_id=oi.order_id
group by o.store_id 
) rev
on rev.store_id=s.store_id)
