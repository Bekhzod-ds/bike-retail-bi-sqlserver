CREATE PROCEDURE sp_GenerateRestockList (@StoreID INT = NULL)
AS
BEGIN
    DECLARE @Threshold INT = 10;  -- I randomly chose it, we can also create a seperate table for it
    IF @StoreID IS NULL
    BEGIN
        SELECT s.store_id, s.product_id, p.product_name, s.quantity FROM Production.Stocks s
JOIN Production.Products p ON s.product_id = p.product_id WHERE s.quantity < @Threshold;
END
ELSE
    BEGIN
        SELECT s.store_id, s.product_id, p.product_name, s.quantity FROM Production.Stocks s
JOIN Production.Products p ON s.product_id = p.product_id 
WHERE s.store_id = @StoreID AND s.quantity < @Threshold;
END
END;

EXEC sp_GenerateRestockList
