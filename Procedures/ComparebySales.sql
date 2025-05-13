CREATE PROCEDURE sp_ComparebySales
    @Year1 INT,
    @Year2 INT
AS
BEGIN
    SELECT
        YEAR(o.order_date) AS SalesYear,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS TotalSales   -- 90% of the full sales value → which is the actual money the shop receives from the customer (i.e., net sales) after giving 10% discount from total(100%) sales
    FROM sales.order_items oi 
    JOIN sales.orders o ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) IN (@Year1, @Year2)
    GROUP BY YEAR(o.order_date);
END;

EXEC sp_ComparebySales @Year1 = 2017, @Year2 = 2018;
