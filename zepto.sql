Create database Zepto_Sql_Analysis;
use Zepto_Sql_Analysis;
create table zepto_sql(
serial INT PRIMARY KEY,
Category varchar(120),
name varchar(150) NOT NULL,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms Integer,
outOfStock Integer,
quantity Integer
);
select * from zepto_sql;
ALTER TABLE zepto_sql DROP COLUMN serial;

-- data exploration

-- count of rows
select count(*) from zepto_sql;

-- sample data
select * from zepto_sql
limit 10;

-- search for null values
select * from zepto_sql
where name is null
or
category is null
or 
mrp is null
or 
discountpercent is null
or 
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

-- different product in data
select distinct category 
from zepto_sql 
order by category;
-- how many products are in stock and out of stock 
select outOFStock ,count(category) 
from zepto_sql
group by outOfStock;
-- products name present multiple times
select name,count(category) as no_of_product
from zepto_sql
group by name
having count(category)>1
order by count(category) desc;

-- data cleaning
-- check for product where price might be zero 
select *
from zepto_sql 
where  mrp=0 or discountedSellingPrice=0;
delete from zepto_sql where mrp=0;

-- converting paisa to rupee
update zepto_sql
set mrp =mrp/100.0,
discountedSellingPrice= discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto_sql;

-- lets solve some buisness related queries
-- Q1.Find the top 10 best value products based on the discount percentage.
select distinct name,mrp,discountPercent
from zepto_sql 
order by discountPercent desc 
limit 10 ;

-- Q2.What are the products with high MRP but out of stock.
select distinct name, mrp,outOfStock
from zepto_sql 
where outOfStock=1 and mrp >300
order by mrp desc ;

-- Q3.Calculate estimated revenue for each category. 
select category , sum(discountedSellingPrice*availableQuantity) as total_revenue
from zepto_sql 
group by category
order by total_revenue;


-- Q4.Find all products where MRP is greater than 500 rupee and discount is less than 10%. 
select distinct name,mrp,discountPercent 
from zepto_sql 
where mrp>500 and discountPercent<10
order by mrp desc,discountPercent desc;


-- Q5.Identify the top 5 categories offering the highest average discount percentage.
select category,Round(avg(discountPercent),2) as avg_discount
from zepto_sql 
group by category
order by avg_discount desc
limit 5;

-- Q6.Find the price per gram for products above 100g and sort by best value.
select distinct name,weightInGms,discountedSellingPrice,
discountedSellingPrice/weightInGms As price_per_gram
from zepto_sql
where weightInGms >=100
order by price_per_gram desc;


-- Q7.Group the products into categories like low,medium,bulk.
select distinct name,weightInGms,
Case
	 when weightInGms<1000 then 'Low'
     when weightInGms<5000 then 'Medium'
     else 'Bulk'
     end as weight_category
from zepto_sql;     



-- Q8.What is the total inventory weight per category
select category,sum(weightInGms * availableQuantity) as total_weight
from zepto_sql 
group by category 
order by total_weight;

