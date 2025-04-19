Q-1 Date Correction

ALTER TABLE Transaction_Data
CHANGE trandaction_date Transaction_Date DATETIME;


##Data Prepration & Understanding##

Q 1
A. 
select COUNT(*) TotalNumOfRows from Customer;
select COUNT (*) TotalNumOfRows from prod_cat_info;
select COUNT (*) TotalNumOfRows from Transactions;


Q-2
SELECT COUNT(*) AS Total_Return_Transactions
FROM Transaction_Data 
WHERE 'Flagship store' = 1;

Q-3
SELECT CAST(transaction_date AS DATE) AS Dates
FROM Transaction_Data;

Q-4
SELECT 
    DATEDIFF(MAX(transaction_date), MIN(transaction_date)) AS NumberOfDays,
    TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) AS NumberOfMonths,
    TIMESTAMPDIFF(YEAR, MIN(transaction_date), MAX(transaction_date)) AS NumberOfYears
FROM Transaction_Data;

Q-5
SELECT DISTINCT Product_Sub_Cat
FROM product_category
WHERE Product_Sub_Cat = 'DIY';

##Data Analysis##

Q-1
SELECT Store_type, COUNT(transaction_id) AS CountOfId
FROM Transaction_Data
GROUP BY Store_type
ORDER BY COUNT(transaction_id) DESC
LIMIT 1;


Q-2
select Gender, count(customer_Id) as CountOfGender from customer_info
 where Gender in ('M' , 'F')
 group by Gender;
 
 
Q-3
SELECT 
    city_code, 
    COUNT(customer_id) AS cust_cnt
FROM 
    customer_info
GROUP BY 
    city_code
ORDER BY 
    cust_cnt DESC
LIMIT 1;

Q-4
select count(Product_Sub_Cat) as SubCategoriesCount from product_category
where Product_Category_code = 'Books'
group by Product_Category_code;


Q-5
SELECT 
    customer_id, 
    SUM(Quantity) AS QuantityMax
FROM 
    Transaction_Data
GROUP BY 
    customer_id;

Q-6
SELECT  
    SUM(t.Total_Amount) AS TotalAmount
FROM 
    Transaction_data t
INNER JOIN 
    product_category p 
    ON t.Product_Cat_Code = p.Product_Cat_Code 
    AND t.Product_Sub_Cat_Code = p.Product_Sub_Cat_Code
WHERE 
    p.Product_Category_code IN ('BOOKS', 'ELECTRONICS');



Q-7 
SELECT 
    COUNT(c.customer_id) AS CountOfCustomer
FROM 
    customer_info c
WHERE 
    c.customer_id IN (
        SELECT 
            t.customer_id
        FROM 
            Transaction_data t
        LEFT JOIN 
            Customer_Info c ON c.customer_id = t.customer_id
        WHERE 
            t.total_Amount NOT LIKE '-%'
        GROUP BY 
            t.customer_id
    );



Q-8
SELECT * 
FROM 
    Transaction_data t
INNER JOIN 
    product_category pci 
    ON t.Product_cat_code = pci.Product_cat_code
    AND t.Product_sub_cat_code = pci.Product_sub_cat_code
WHERE 
    pci.Product_Category_code IN ('Clothing', 'Electronics')
    AND t.Store_type = 'Flagship Store';



Q-9
SELECT 
    pci.Product_Sub_Cat,
    SUM(t.Total_Amount) AS Total_Revenue
FROM 
    Customer_info c
INNER JOIN
    Transaction_data t ON c.customer_Id = t.customer_Id
INNER JOIN 
    product_category  ON t.product_cat_code = pci.product_cat_code 
                         AND t.product_sub_cat_code = pci.product_sub_cat_code
WHERE 
    c.Gender = 'M' 
    AND pci.Product_Category_code = 'Electronics'
GROUP BY 
    pci.Product_Sub_Cat;



Q-10
SELECT  
    pci.Product_Sub_Cat, 
    (SUM(t.Total_Amount) / (SELECT SUM(Total_Amount) FROM Transaction_data)) * 100 AS SalesPercentage,
    (SUM(CASE WHEN t.Quantity < 0 THEN t.Quantity ELSE 0 END) / SUM(t.Quantity)) * 100 AS PercentageOfReturn
FROM 
    Transaction_data t
INNER JOIN 
    product_category pci ON t.Product_Cat_Code = pci.Product_Cat_Code 
                         AND t.Product_Sub_Cat_Code = pci.Product_Sub_Cat_Code
GROUP BY 
    pci.Product_Sub_Cat
ORDER BY 
    SUM(t.Total_Amount) DESC
LIMIT 5;


Q-11
SELECT 
    customer_id, 
    SUM(Total_Amount) AS TotalRevenue 
FROM 
    transaction_data
WHERE 
    customer_id IN (
        SELECT 
            customer_id 
        FROM 
            Customer_Info
        WHERE 
            TIMESTAMPDIFF(YEAR, STR_TO_DATE(DOB, '%d-%m-%Y'), CURDATE()) BETWEEN 25 AND 35
    )
    AND transaction_date BETWEEN 
        DATE_SUB((SELECT MAX(transaction_date) FROM Transaction_data), INTERVAL 30 DAY)
        AND (SELECT MAX(transaction_date) FROM Transaction_Data)
GROUP BY 
    Customer_ID;



Q-12
SELECT 
    pci.Product_Category_code AS ProductCategory, 
    SUM(t.Total_amount) AS TotalAmount
FROM 
    Transaction_Data t
INNER JOIN 
    product_category pci ON t.product_cat_code = pci.product_cat_code
                         AND t.product_sub_cat_code = pci.product_sub_cat_code
WHERE 
    t.Total_amount < 0 
    AND t.transaction_date BETWEEN 
        DATE_SUB((SELECT MAX(transaction_date) FROM Transaction_Data), INTERVAL 3 MONTH)
        AND (SELECT MAX(transaction_date) FROM Transaction_Data)
GROUP BY 
    pci.Product_Category_code
ORDER BY 
    TotalAmount DESC
LIMIT 1;




Q-13
SELECT 
    Store_type, 
    SUM(Total_Amount) AS TotalSales, 
    SUM(Quantity) AS TotalQuantity
FROM 
    Transaction_Data
GROUP BY 
    Store_type
HAVING 
    SUM(Total_Amount) >= ALL (SELECT SUM(Total_Amount) FROM Transaction_Data GROUP BY Store_type)
    AND SUM(Quantity) >= ALL (SELECT SUM(Quantity) FROM Transaction_Data GROUP BY Store_type);




Q-14
SELECT 
    pci.Product_Category_Code AS ProductCategory, 
    AVG(t.Total_Amount) AS AverageSales
FROM 
    Transaction_Data t
INNER JOIN 
    product_category pci 
    ON t.Product_Cat_Code = pci.Product_Cat_Code 
    AND t.Product_Sub_Cat_Code = pci.Product_Sub_Cat_Code
GROUP BY 
    pci.Product_Category_Code
HAVING 
    AVG(t.Total_Amount) > (SELECT AVG(Total_Amount) FROM Transaction_Data);




Q-15
-- Step 1: Find the top 5 categories
SELECT 
    pci.Product_Category_Code AS ProductCategory,
    pci.Product_Sub_Cat AS ProductSubCategory,
    AVG(t.Total_Amount) AS AverageRevenue,
    SUM(t.Total_Amount) AS TotalRevenue
FROM 
    Transaction_Data t
INNER JOIN 
    product_category pci 
    ON pci.Product_Cat_Code = t.Product_Cat_Code 
    AND pci.Product_Sub_Cat_Code = t.Product_Sub_Cat_Code
INNER JOIN (
    SELECT 
        pci1.Product_Category_Code
    FROM 
        Transaction_Data t1
    INNER JOIN 
        product_category pci1 
        ON pci1.Product_Cat_Code = t1.Product_Cat_Code 
        AND pci1.Product_Sub_Cat_Code = t1.Product_Sub_Cat_Code
    GROUP BY 
        pci1.Product_Category_Code
    ORDER BY 
        SUM(t1.Quantity) DESC
    LIMIT 5
) top5
ON pci.Product_Category_Code = top5.Product_Category_Code
GROUP BY 
    pci.Product_Category_Code, 
    pci.Product_Sub_Cat;	
	
	


