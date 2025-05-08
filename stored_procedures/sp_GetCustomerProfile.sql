--sp_GetCustomerProfile : Total spend, total orders, and most bought product

create procedure sp_GetCustomerProfile
as 
begin

--total spend
declare @total_spend decimal(15,2)
select @total_spend=sum(quantity*list_price*(1-discount))
from sales.Order_items
 
-- total order
declare @total_order int
select @total_order=count(distinct order_id)
from sales.Order_items

--most bought product
declare @most_bought_product_id int
declare @most_bought_pr_qty int
select top 1 @most_bought_product_id=product_id,
		@most_bought_pr_qty=sum(quantity)
from sales.Order_items
group by product_id
order by sum(quantity) desc

select @total_spend as total_spend,
		@total_order as total_order,
		@most_bought_product_id as most_bought_product_id,
		@most_bought_pr_qty as most_bought_product_qty
end

execute sp_GetCustomerProfile
