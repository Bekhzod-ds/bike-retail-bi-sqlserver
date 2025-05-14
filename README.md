# bike-retail-bi-sqlserver
A Business Intelligence system for a fictional bike retail chain using SQL Server — includes normalized schema design, ETL processes, business insights via views, stored procedures, and scheduled jobs.

# 🚴‍♂️ BikeStore Business Intelligence Project

**Database:** Microsoft SQL Server   
**Project Type:** Data Warehousing, SQL Automation, Business Intelligence  
**Status:** ✅ Completed  

---

## Business Scenario

**BikeStore** is a fast-growing retail chain selling bikes and accessories across multiple locations. The company collects operational data on:

- Orders, Customers, and Products  
- Store Locations, Inventory, and Staff  
- Product Categories and Brands

To support data-driven decision-making, we had to build a SQL-based Business Intelligence system with automated reporting, KPIs, and insights.

---

## Project Goals

- Load CSV-based retail data into SQL Server  
- Automate ingestion using `BULK INSERT` + `SQL Server Agent`  
- Normalize and transform data into clean relational schema  
- Create views and stored procedures for reusable business insights  
- Implement automated KPIs for performance monitoring

---

##  Data Files

- `products.csv`  
- `orders.csv`, `order_items.csv`  
- `stores.csv`, `stocks.csv`, `staffs.csv`  
- `customers.csv`, `brands.csv`, `categories.csv`  

All files were staged and imported using `BULK INSERT`.

---

##  Tech Stack

- Microsoft SQL Server  
- SQL Server Management Studio (SSMS)  
- SQL Server Agent (for automation)  
- T-SQL

---

##  Database Design

- Data was cleaned and normalized into 3NF  
- Foreign keys and constraints ensured data integrity  
- Tables created: `Customers`, `Orders`, `Order_Items`, `Products`, `Categories`, `Brands`, `Stores`, `Staffs`, `Stocks`  

---

##  Key Views

| View | Description |
|------|-------------|
| `vw_StoreSalesSummary` | Revenue, #Orders, AOV per store |
| `vw_TopSellingProducts` | Rank products by sales |
| `vw_InventoryStatus` | Low-stock items |
| `vw_StaffPerformance` | Staff-wise order/revenue |
| `vw_RegionalTrends` | Revenue by city/region |
| `vw_SalesByCategory` | Margin and volume by category |

---

##  Stored Procedures

| Stored Procedure | Description |
|------------------|-------------|
| `sp_CalculateStoreKPI` | Returns full KPI metrics by store ID |
| `sp_GenerateRestockList` | Shows low-stock items per store |
| `sp_CompareSalesYearOverYear` | Revenue comparison between two years |
| `sp_GetCustomerProfile` | Customer spend and product history |

---

##  Business KPIs

| KPI | Insight |
|-----|--------|
| Total Revenue | Overall performance |
| AOV (Avg Order Value) | Customer spending behavior |
| Inventory Turnover | Stock flow efficiency |
| Revenue by Store | Top-performing branches |
| Gross Profit by Category | Margin by product line |
| Sales by Brand | Vendor/product performance |
| Staff Revenue Contribution | Individual productivity |

Each KPI was calculated using the created views and procedures.

---

## 🤖 Automation with SQL Server Agent

- Created a job to auto-load updated `.csv` files
- Scheduled to run weekly
- Executes `sp_CalculateStoreKPI` and `sp_GenerateRestockList`
- Results are saved in tables

 *See screenshots in* `/Automation/screenshots.md`

---

##  Files in This Repository

/Automation/ .... – Screenshots of automation job/needed queries for the automation and the diagrams
/schema design/  .... - All table scripts done by 4 project members and the final table desing fitting in NF standards
/views/ ... - All view scripts
/Procedures/ ... - All stored procedures script

---

## Possible Future Improvements

- Integrate with Power BI for live dashboards  
- Implement logging and role-based access  





