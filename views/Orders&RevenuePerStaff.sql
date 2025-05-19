create view vw_StaffPerformance as (
  select s.staff_id,
  		isnull(count(distinct o.order_id), 0) as orders_per_staff,
    isnull(sum(oi.quantity * oi.list_price * (1 - oi.discount)), 0) as total_revenue
from sales.Order_items oi
join sales.Orders o 
on oi.order_id = o.order_id
right join sales.Staff s
on o.staff_id = s.staff_id
group by s.staff_id
 )
