
CREATE TABLE coffee_shop_sales (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(100),
    product_id INT,
    unit_price DECIMAL(10,2),
    product_category VARCHAR(100),
    product_type VARCHAR(100),
    product_detail VARCHAR(100)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/coffe_shop_sales_project1.csv'
INTO TABLE coffee_shop_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(transaction_id, transaction_date, transaction_time, transaction_qty, 
 store_id, store_location, product_id, unit_price, 
 product_category, product_type, product_detail);
 
 SET SQL_SAFE_UPDATES = 0;
 
-- remove the null value

delete from coffee_shop_sales
 where
 transaction_id is null
 or transaction_date is null
 or transaction_time is null
 or transaction_qty is null 
 or store_id is null
 or store_location is null
 or product_id is null
 or unit_price is null
 or product_category is null
 or product_type is null
 or product_detail is null;
 
 select * from coffee_shop_sales;
 
 # 1. Total Number of Transactions
 select count(*) as 'Total Number of Transactions'
 from coffee_shop_sales;
 
 
 -- 2. Total Sales Revenue
 select sum(transaction_qty * unit_price) as 'Total Sales Revenue'
 from coffee_shop_sales;
 
-- 3. Daily Sales 
select store_id,
 extract(day from transaction_date) as daily,
 sum(transaction_qty * unit_price) as daily_revenue
from coffee_shop_sales
group by daily,store_id;

-- 4. Best Selling Product
select product_type,
count(*) as 'Best_Selling_Product'
from coffee_shop_sales
group by product_type
order by count(*) desc
limit 5;

-- 5. Top Product Category
select product_category, count(*) as 'Best_Selling_Category'
from coffee_shop_sales 
group by product_category
order by count(*) desc;

-- 6. Sales by Time of Day
select 
      case
      when time(transaction_time) between '06:00:00' and '11:59:59' then 'Morning'
      when time(transaction_time) between '12:00:00' and '17:59:59' then 'Afternoon'
      when time(transaction_time) between '18:00:00' and '23:59:59' then 'Evening'
      else 'Night'
      end as time_period,
      sum(transaction_qty * unit_price) as 'total_sales',
      count(*) as 'total_transactions'
      from coffee_shop_sales
      group by time_period
      order by total_sales desc;
      
    -- 7. Sales by Store Location
    select store_location, sum(transaction_qty * unit_price) as 'Sales_by_Store_Location'
    from coffee_shop_sales
    group by store_location
    order by Sales_by_Store_Location desc;
    
   -- 8. Average Transaction Value
   select
    round(avg(transaction_value),2) as average_transaction_value
from (
    select 
        transaction_id,
        SUM(transaction_qty * unit_price) as transaction_value
    from coffee_shop_sales
    group by transaction_id
) as transaction_totals;
    
    -- 9. Highest Priced Products

    select 
    distinct(product_id),
    product_detail,
    unit_price
    from coffee_shop_sales
    order by unit_price desc
    limit 5;
    
    -- 10. Least Selling Products by Store
    
      select store_location,
      product_category,
      count(transaction_qty) as total_units_sold
      from coffee_shop_sales
      group by store_location,product_category
      order by count(transaction_qty) asc
      limit 3;
