create view vw_StaffPerformance as (
  select o.staff_id,
  		count(distinct o.order_id) as orders_per_staff,
    sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
from sales.Order_items oi
join sales.Orders o 
on oi.order_id = o.order_id
group by o.staff_id
 )
