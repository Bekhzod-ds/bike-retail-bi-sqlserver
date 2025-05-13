
create procedure sp_GetCustomerProfile
as
begin
 
    	with CTE_MostBought as(
select
  o.customer_id,
  product_id,
  sum(quantity) orderqty,
  row_number() over (partition by customer_id order by sum(quantity) desc) rnk
from sales.Orders o
join sales.Order_items oi on o.order_id = oi.order_id
group by o.customer_id, product_id 
),

 CTE_Totals as(

select 
        o.customer_id,
        sum(oi.list_price * oi.quantity * (1 - oi.discount)) as total_spends,
        count(o.order_id) as total_orders
    from sales.Orders o
    join sales.Order_items oi on o.order_id = oi.order_id
	
    group by o.customer_id
	)


select
  mb.customer_id,
  t.total_spends,
  t.total_orders,
  mb.product_id as most_bought_product
from CTE_MostBought mb
join CTE_Totals t
on mb.customer_id=t.customer_id

where mb.rnk = 1
    
end;

execute sp_GetCustomerProfile
