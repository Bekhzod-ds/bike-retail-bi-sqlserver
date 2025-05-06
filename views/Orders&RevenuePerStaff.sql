create view vw_StaffPerformance as(
  select o.staff_id,
		count(distinct o.order_id) as orders_per_staff,
		sum(oi.list_price) as revenue_per_staff
  from sales.orders o
  join sales.order_items oi
  on o.order_id=oi.order_id
  group by o.staff_id)
