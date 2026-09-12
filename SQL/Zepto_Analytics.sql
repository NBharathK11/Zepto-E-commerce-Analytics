
SELECT
    COUNT(*) AS Total_Products,
    COUNT(DISTINCT Category) AS Total_Categories,
    AVG(selling_price_rupees) AS Avg_Selling_Price,
    AVG(discountPercent) AS Avg_Discount_Percent,
    SUM(savings) AS Total_Customer_Savings
FROM dbo.zepto_cleaned_data;

SELECT
    Category,
    COUNT(*) AS Product_Count
FROM dbo.zepto_cleaned_data
GROUP BY Category
ORDER BY Product_Count DESC;

--DATA VALIDATION ---
SELECT
COLUMN_NAME,
DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'zepto_cleaned_data'
ORDER BY ORDINAL_POSITION;


-- 1. checking for the null/missing values ---
SELECT 
COUNT(*) AS total_rows,
COUNT(category) AS category_values,
COUNT(name) AS name_nalues,
COUNT(mrp) AS mrp_values,
COUNT(discountpercent) AS discount_values,
COUNT(availablequantity) AS quantity_values,
COUNT(discountedsellingPrice) AS selling_Price_values,
COUNT(weightingms) AS weight_values,
COUNT(outofstock) AS stock_values,
COUNT(quantity) AS quantity_values

FROM dbo.zepto_cleaned_data;
-----(category Analysis)---

--- 2. check for the duplicate products--
SELECT 
Category,
    name,
    mrp,
    discountPercent,
    availableQuantity,
    discountedSellingPrice,
    weightInGms,
    outOfStock,
    quantity,
    COUNT(*) AS Duplicate_count
 FROM dbo.zepto_cleaned_data
 GROUP BY
    Category,
    name,
    mrp,
    discountPercent,
    availableQuantity,
    discountedSellingPrice,
    weightInGms,
    outOfStock,
    quantity
HAVING COUNT(*)>1;

--- 3. average selling by category---


SELECT
    Category,
    AVG(selling_price_rupees) AS Avg_Selling_Price
FROM dbo.zepto_cleaned_data
GROUP BY Category
ORDER BY Avg_Selling_Price DESC;




---4 . average discount percentage--
SELECT
    Category,
    AVG(discountPercent) AS Avg_Discount_Percent
FROM dbo.zepto_cleaned_data
GROUP BY Category
ORDER BY Avg_Discount_Percent DESC;
---5 . outof stock products by category---
SELECT
    Category,
    COUNT(*) AS Out_of_Stock_Products
FROM dbo.zepto_cleaned_data
WHERE outOfStock = 1
GROUP BY Category
ORDER BY Out_of_Stock_Products DESC;
---PRODUCT ANALYSIS---

--- 6. which product provides highest savings to customers---
SELECT 
name,
category,
mrp_rupees,
selling_price_rupees,
savings
FROM dbo.zepto_cleaned_data
ORDER BY savings DESC;

---7. top 10 expensive products---
SELECT TOP 10
    name,
    Category,
    mrp_rupees,
    selling_price_rupees,
    discountPercent
FROM dbo.zepto_cleaned_data
ORDER BY selling_price_rupees DESC;

---8. top 10 discount products---
SELECT TOP 10
name,
category,
mrp_rupees,
selling_price_rupees,
discountPercent
From dbo.zepto_cleaned_data
ORDER BY discountPercent DESC;

---PRICING ANALYSIS---
---9. MIN ,MAX , AVG of selling_price_ products
SELECT 
MIN(selling_price_rupees) AS minimum_sellling_price_rupees,
MAX(selling_price_rupees) AS maximum_selling_price_rupees,
AVG(selling_price_rupees) AS average_selling_price_rupees
FROM dbo.zepto_cleaned_data
WHERE selling_price_rupees > 0;

---10 . price range by category---
SELECT 
category,
MIN(selling_price_rupees) AS Minimum_Price,
MAX(selling_price_rupees) AS Maximum_Price,
AVG(selling_price_rupees) AS Average_Price
FROM dbo.zepto_cleaned_data
WHERE selling_price_rupees > 0
GROUP BY category
ORDER BY Average_price DESC;

---DISCOUNT ANALYSIS---

---11. total customers savings by category---
SELECT 
category,
SUM(savings) AS total_savings
FROM dbo.zepto_cleaned_data
WHERE savings > 0
GROUP BY category
ORDER BY total_savings DESC;
---INVENTORY ANALYSIS---
---12. low_stock products---
SELECT 
name,
category,
availableQuantity,
selling_price_rupees,
outofstock
FROM dbo.zepto_cleaned_data
WHERE outofstock = 0
AND availableQuantity>0
ORDER BY availableQuantity ASC;


---13. out of stock products percentage---
SELECT 
category,
count(*) AS total_products,
SUM (CASE WHEN outOfStock =1 THEN 1 ELSE 0 END) AS out_of_stock_products,
ROUND( 100.0 * SUM (CASE WHEN outOfStock = 1 THEN 1 ELSE 0 END) / COUNT(*),2) AS out_of_stock_percentage
FROM dbo.zepto_cleaned_data
GROUP BY category
ORDER BY out_of_stock_products DESC;


---14. products with high discount---
SELECT 
category,
name,
mrp_rupees,
selling_price_rupees,
discountPercent,
savings
FROM dbo.zepto_cleaned_data
WHERE discountPercent >40
ORDER BY discountPercent DESC;

---15. state of budget ---
SELECT 
CASE
WHEN selling_price_rupees <=50 THEN 'BUDGET'
WHEN selling_price_rupees <=100 THEN 'AFFORDABLE'
WHEN selling_price_rupees <=500 THEN 'MID-RANGE'
WHEN selling_price_rupees <=100 THEN 'PREMIUM'

ELSE 'HIGH-END'
END AS price_category,

COUNT(*) AS product_Count

FROM dbo.zepto_cleaned_data
WHERE selling_price_rupees > 0

GROUP BY
CASE
WHEN selling_price_rupees <=50 THEN 'BUDGET'
WHEN selling_price_rupees <=100 THEN 'AFFORDABLE'
WHEN selling_price_rupees <=500 THEN 'MID-RANGE'
WHEN selling_price_rupees <=100 THEN 'PREMIUM'

ELSE 'HIGH-END'
END
ORDER BY product_Count;


--- 16. to print all the products in each category with price_rank---
SELECT 
name,
category,
selling_price_rupees,

ROW_NUMBER() OVER(
PARTITION BY category 
ORDER BY selling_price_rupees DESC) AS price_rank
FROM dbo.zepto_cleaned_data
WHERE selling_price_rupees >0;

--- 17. to print the only one product which is having the highest selling price ruppes in each category---
WITH rankedproducts AS 
( 
SELECT 
name, 
category,
selling_price_rupees,
ROW_NUMBER() OVER(
PARTITION BY category
ORDER BY selling_price_rupees DESC ) AS price_rank
FROM dbo.zepto_cleaned_data
WHERE selling_price_rupees > 0
)

SELECT 
name,
category,
selling_price_rupees,
price_rank
FROM rankedproducts
WHERE price_rank =1 
ORDER BY category;


---17. the products whose discount percentage is higher than the average discount of their own category---
SELECT 
name,
category,
discountPercent,
(
SELECT AVG(discountPercent)
FROM dbo.zepto_cleaned_data
WHERE category = p.category
) AS AVG_category_discount
FROM dbo.zepto_cleaned_data AS P
WHERE discountPercent > ( 
SELECT AVG(discountPercent)
FROM dbo.zepto_cleaned_data
WHERE category = p.category
)
ORDER BY category,discountPercent DESC;



--- 18. find products that are priced higher than their categories average price---
SELECT 
name,
category,
selling_price_rupees ,
(
SELECT 
AVG(selling_price_rupees)
FROM dbo.zepto_cleaned_data
WHERE category = p.category
) AS average_selling_price

FROM dbo.zepto_cleaned_data AS p
WHERE selling_price_rupees > (
SELECT AVG(selling_price_rupees)
FROM dbo.zepto_cleaned_data
)
ORDER BY category,selling_price_rupees DESC;

--- 19. which category has highest discount and highest customer savings---
SELECT 
category,
AVG(discountPercent) AS average_discount_percent,
SUM(savings) AS total_savings
FROM dbo.zepto_cleaned_data
GROUP BY category
ORDER BY average_discount_percent DESC;

---20.which products are low_in_stock and out_of_stock --
SELECT 
name,
category,
outOfStock,
availableQuantity,
CASE 
WHEN outOfStock =1 THEN 'OUTOFSTOCK'
WHEN availableQuantity <=5 THEN 'LOWSTOCK'
ELSE 'INSTOCK'
END AS 'outofstock_status'

FROM dbo.zepto_cleaned_data
ORDER BY 
CASE 
WHEN outOfStock = 1 THEN 1
WHEN availableQuantity <=5 THEN 2
ELSE 3
END,
availableQuantity ASC;


---21. which products has the most inventory problems--
SELECT
category,
COUNT(*) total_products,
SUM (CASE WHEN outOfStock =1 THEN 1 ELSE 0 END ) AS 'outofstock',
SUM (CASE WHEN outOfStock =0 AND availableQuantity <=5 THEN 1 ELSE 0 END) AS 'instock'
FROM dbo.zepto_cleaned_data
GROUP BY category
ORDER BY outofstock DESC , instock DESC;



--- create another table---
CREATE TABLE dbo.category_details
(
category NVARCHAR(100) PRIMARY KEY,
Department NVARCHAR(100),
Category_Type NVARCHAR(50)
);

--- adding the columns to the new table--
UPDATE dbo.category_details
SET
    Department =
        CASE
            WHEN Category IN (
                'Beverages',
                'Biscuits',
                'Cooking Essentials',
                'Dairy, Bread & Batter',
                'Munchies',
                'Packaged Food',
                'Ice Cream & Desserts',
                'Chocolates & Candies',
                'Paan Corner'
            )
                THEN 'Food & Beverages'

            WHEN Category IN (
                'Fruits & Vegetables',
                'Meats, Fish & Eggs'
            )
                THEN 'Fresh Food'

            WHEN Category IN (
                'Personal Care',
                'Health & Hygiene'
            )
                THEN 'Health & Personal Care'

            WHEN Category = 'Home & Cleaning'
                THEN 'Home & Cleaning'
        END,

    Category_Type =
        CASE
            WHEN Category IN (
                'Fruits & Vegetables',
                'Dairy, Bread & Batter',
                'Meats, Fish & Eggs'
            )
                THEN 'Fresh'

            WHEN Category = 'Ice Cream & Desserts'
                THEN 'Frozen'

            WHEN Category IN (
                'Personal Care',
                'Health & Hygiene'
            )
                THEN 'Personal Care'

            WHEN Category = 'Home & Cleaning'
                THEN 'Household'

            ELSE 'Packaged'
        END;

        SELECT *
FROM dbo.category_details
ORDER BY Category;

---joining two tables (inner join)---
SELECT *
FROM dbo.zepto_cleaned_data
INNER JOIN dbo.category_details
 ON dbo.zepto_cleaned_data.category = dbo.category_details.category;

 ---inner join ---
 SELECT 
 p.name,
 p.category,
 p.selling_price_rupees,
 c.Department,
 c.Category_Type
 FROM dbo.zepto_cleaned_data AS p
 INNER JOIN dbo.category_details AS c
 ON p.category = c.category


 --- left join---
 SELECT 
 p.name,
 p.category,
 p.selling_price_rupees,
 c.Department,
 c.Category_Type

 FROM dbo.zepto_cleaned_data AS p
 LEFT JOIN dbo.category_details AS c
 ON p.category = c.category;

 --- how many products are there in each departments and what is the average selling price---
 SELECT 
 c.Department,
 COUNT(*) AS product_count,
 AVG(p.selling_price_rupees) AS average_selling_price_rupees 
 FROM dbo.zepto_cleaned_data AS p
 LEFT JOIN dbo.category_details AS c
 ON p.category = c.category
 WHERE selling_price_rupees > 0
 GROUP BY c.department
 ORDER BY product_count;
