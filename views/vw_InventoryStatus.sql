CREATE VIEW vw_InventoryStatus AS
SELECT S.store_id, store_name, P.product_id, product_name, quantity
FROM Production.Stocks St 
JOIN Sales.Stores S ON St.store_id = S.store_id
JOIN Production.Products P ON P.product_id = St.product_id
WHERE quantity < 10; -- threshold I chose it since // another table can be created too to find the threshold

SELECT * FROM vw_InventoryStatus

