create proc sp_StoreKPI @storeID int = null
as
	if @storeID is null
	begin
		with CTEMultipleVisits as(
		select
			store_id,
			Customer_id
		from sales.Orders
		group by 
			store_id,
			customer_id
		having count(*) > 1
		),
		CTECountRentn as(
		select store_id,
			round((cast(count(*) as float)/(select count(*) from sales.Orders where store_id = CTEMultipleVisits.store_id))*100, 2) Retention_rate
		from CTEMultipleVisits
		group by store_id
		)

		select sss.*, 
			Retention_rate,
			CountOfStaff
		from CTECountRentn cte
		join vw_StoreSalesSummary sss
		on cte.store_id = sss.store_id
		cross apply (select count(*) CountOfStaff from sales.Staff where store_id = sss.store_id) staff

	end
	else
	begin
		with CTEMultipleVisits as(
		select
			store_id,
			Customer_id
		from sales.Orders
		where store_id = @storeID
		group by 
			store_id,
			customer_id
		having count(*) > 1
		),
		CTECountRentn as(
		select store_id,
			round((cast(count(*) as float)/(select count(*) from sales.Orders where store_id = CTEMultipleVisits.store_id))*100, 2) Retention_rate
		from CTEMultipleVisits
		group by store_id
		)
		select sss.*, 
			Retention_rate,
			CountOfStaff
		from CTECountRentn cte
		join vw_StoreSalesSummary sss
		on cte.store_id = sss.store_id
		cross apply (select count(*) CountOfStaff from sales.Staff where store_id = sss.store_id) staff
	end

exec sp_StoreKPI


--This Stored Procedure show us information about a specific store. It shows, its is, name, revenue it has made, count of order made in that store, AOV, retention rate(rate of customers that return to the shop to make even more purchases), and also how many workers there are.
--this insight helps ou identify strong and weak stores, their effectiveness and likeability. For example, company might wanna improve customer service, or offer discounts or bonuses to improveretention rate of customers.
