
create procedure sp_GetCustomerProfile
as
begin
 ;

    -- total spends and total orders per customer
    select 
        o.customer_id,
        sum(oi.list_price * oi.quantity * (1 - oi.discount)) as total_spends,
        count(o.order_id) as total_orders
    from sales.Orders o
    join sales.Order_items oi on o.order_id = oi.order_id
    group by o.customer_id
	order by customer_id;

    -- most bought items 
    select 
        customer_id,
        product_id,
        total_quantity
    from (
        select 
            o.customer_id,
            oi.product_id,
            sum(oi.quantity) as total_quantity,
            row_number() over (partition by o.customer_id order by sum(oi.quantity) desc) as rn
        from sales.Orders o
        join sales.Order_items oi on o.order_id = oi.order_id
        group by o.customer_id, oi.product_id
    ) ranked
    where rn <= 5
    order by customer_id, total_quantity desc;

end;

execute sp_GetCustomerProfile1



