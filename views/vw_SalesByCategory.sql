CREATE VIEW vw_SalesByCategory AS
SELECT 
    c.category_name,
    SUM(oi.quantity) AS TotalQuantity,
    SUM(oi.list_price * oi.quantity) AS TotalRevenue,
    SUM(p.list_price * oi.quantity) AS TotalCost,
    ROUND(
        (SUM(oi.list_price * oi.quantity) - SUM(p.list_price * oi.quantity)) 
        / NULLIF(SUM(oi.list_price * oi.quantity), 0) * 100, 2
    ) AS gross_margin_percent
FROM sales.order_items oi
JOIN production.products p ON p.product_id = oi.product_id
JOIN production.categories c ON c.category_id = p.category_id
GROUP BY c.category_name;

select * from vw_SalesByCategory
