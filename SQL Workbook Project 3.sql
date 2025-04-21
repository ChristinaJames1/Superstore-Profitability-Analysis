
/* Project 3 - Tableau (PostgreSQL) - Superstore Dataset
--------------------------------------------------------------------------------------------------------------------------------------------
Business Problem Statement:
The Regional Sales Director has noticed that — even though sales continue to experience year-over-year growth — profitability in certain 
regions continues to decline. 

Objective:
Conduct an analysis to identify the root cause
1.) What is the problem in each region?
2.) Make data-driven recommendations based on region, customer segments, and product categories
---------------------------------------------------------------------------------------------------------------------------------------------
Hypothesis: Having high sales means that you should have high profit but if we drill down to look at the performance of products, we may 
discover there are outlier products high sales but is not profiting enough to make money back for their region.

--Region Questions; orders across region
-- Since orders equals sales, I started to ask, what are orders across regions, how many orders is each region getting across their product 
categories.

/*Question 1. Where were the lowest and highest overall number of orders placed by category?*/
--Note: -I utilized a join to retrieve category and orders on regions and orders*/


--By Furniture

select rg.region as "Region", rg.sub_region as "Subregion", p.category as "Category"
, count (o.order_id) as "Number of Orders"
from orders o 
join regions rg on rg.region_id = o.region_id 
join products p on p.product_id = o.product_id 
where category = 'Furniture' 
group by 1,2,3
order by 4 desc;

--By Office Supplies
select rg.region as "Region", rg.sub_region as "Subregion", p.category as "Category"
, count (o.order_id) as "Number of Orders"
from orders o 
join regions rg on rg.region_id = o.region_id 
join products p on p.product_id = o.product_id 
where category = 'Office Supplies' 
group by 1,2,3
order by 4 desc;

--By Technology
select rg.region as "Region", rg.sub_region as "Subregion", p.category as "Category"
, count (o.order_id) as "Number of Orders"
from orders o 
join regions rg on rg.region_id = o.region_id 
join products p on p.product_id = o.product_id 
where category = 'Technology' 
group by 1,2,3
order by 4 desc;

/*Furniture and technology faired lowest in orders across all years. Furniture accounted for less 19.31% in Americas,19.29% in EMEA, 
19.28% APAC regions considering total orders. Technology accounted for less than 20% of total orders across regions.*/


/*Question 2. Of those orders placed, across what product categories are they placed?
--4k in Furniture table orders were placed in the APAC region with the EMEA region accounting for 
just 6k in orders overall. Binders in office supplies is the highest selling in the office supplies 
category, and the best selling subcategory across all regions. 

/*Question 3. How much money in sales orders has each category generated?
The Technology category has generated $92,369,136 in sales to-date
The Office Supplies category has generated $73,874,894 in sales to-date
The Furniture category has generated $79,584,296 in sales to-date*/


/*Question 4: Of the sales generated, how much of it accounts for profit overall?*/
select category as "Category"
, sum (profit) as "Sum of Profit"          
from orders o
join products p on p.product_id = o.product_id
group by 1;

"Furniture" 330401.63
"Office Supplies" 621998.31
"Technology"   706209.15

/*Question 5: What were the highest and lowest profiting products across subcategory?*/

select to_char(order_date, 'YYYY')as "Year", concat(category, ':', sub_category) as "Categories"
, sum (profit) as "Total Profit" 
, round (100*(sum(o.profit)/(select sum(o.profit) from orders o)),2) as "Percent Profit"
from orders o
join products p on p.product_id = o.product_id
group by 1,2
order by 1 desc;

----------------
--Key Discovery:  Furnishings:Tables are displaying negative profit
----------------

 /*The furniture category and tables subcategory display negative profitability overall across the entire superstore dataset.
 Tables has negative 64,000 total profit overall.*/

---------------------------------------------------------------------


/*Based on past experience, I know that any business needs to pay attention to their profit margin to remain fiscally, or financially healthy
because profit margins measure how well a company is doing. So, high gross profit margin will indicate that a company is successfully 
meeting and exceeding its costs of operation, also known as overhead*/
--Note: I left joined the orders table with returns table, and calculated profit margin as sum(Profit)/sum(Sales)

/*Question 6. What is profit margin performance across region?*/
--Note - used join to get regions on orders

select rg.region as "Region"
, sum (profit) as "Profit"
, sum (sales) as "Sales"
from orders o 
join regions rg on rg.region_id = o.region_id
join products p on p.product_id = o.product_id 
group by 1
order by 3;

/*How much in Yearly sales and profit is each product category responsible for?*/

select to_char(order_date, 'YYYY')as "Year", category as "Category"
, sum (profit) as "Total Profit" 
, sum (sales) as "Total Sales"
, round (sum(profit)/sum(sales),5) as "Profit Margin"
from orders o
join products p on p.product_id = o.product_id
group by 1,2
order by 1 desc;

--by subcategory

select to_char(order_date, 'YYYY')as "Year", concat(category, ':', sub_category) as "Categories"
, sum (profit) as "Total Profit" 
, sum (sales) as "Total Sales"
, round (sum(profit)/sum(sales),5) as "Profit Margin"
from orders o
join products p on p.product_id = o.product_id
group by 1,2
order by 1 desc;

--by quarter

select to_char(order_date, 'YYYY')as "Year"
,to_char( order_date, 'Q') as "Quarter"
   ,date_trunc('year', order_date) as "Date"
, sum (profit) as "Total Profit" 
, sum (sales) as "Total Sales"
, round (sum(profit)/sum(sales),5) as "Profit Margin"
from orders o
join products p on p.product_id = o.product_id
group by 1,2,3
order by 1 desc
limit 20;

-------------------------------------------------------------------------------------------------

/*Findings: 

Furniture and Technology accounted for less than 20% of total orders over all years and regions.
-4k in Furniture table orders were placed in the APAC region with the EMEA region not trailing far behind as it accountedfor just 6k in furniture 
orders overall. Binders is the highest selling in the office supplies category, and the best selling subcategory across all regions Americas, EMEA, APAC.

 After breaking information down into category in the where statement, I found that the Americas U.S. region placed the highest number of orders, over 60%,
 in the office supplies category,and the region had the most orders across all categories:furniture, office supplies, technology.
 The Americas regions not only placed the largest amout of orders per category overall across regions, but also returned the largest profit margin.

Recommendations: 
Furniture is not a popular category for orders outside of the Americas in any year.Should the store wish to increase orders, 
they will benefit from looking into their market presence and improving it in foreign regions as well as increasing advertisment of furniture
in the APAC and EMEA regions respectively. Superstores continued approach to customer procurement in their office supplies category has been
successful. In the Americas region, Superstore has consistently fared well in highlighting themselves as a one-stop-shop for office supplies, 
and in doing such, they continue to make themselves visible to buyers.  */

/*Question 7. What is the relationship between areas with low profit margin, and discount? 
Discounts given exceed the amount of profit made on products. For some subcategories,
a discount of 50% over profit margin is being offered. This is a substanial amount in discounts
in relation to how much is being made. Superstore is essentially paying customers to shop there.





/*Question 8: Do tables have high returns?*/
 --  not all orders had returns I used not null to find the orders with return reason

--Furnishings and Tables had the highest percentage of returns and had the same percentage of returns 


select p.sub_category, count(*) as num_returns, rt.reason_returned
from orders o
join products p on p.product_id = o.product_id  
left join returns rt on rt.order_id = o.order_id
where rt.reason_returned is not null and p.category = 'Furniture'
 and sub_category in ('Furnishings', 'Tables')
group by 1,3
order by 2 desc;

/*Question 10: What is going on with shipping of Furniture:Tables if this is the most returned?*/

select distinct ship_mode
, sum(sales) as sum_sales
,sum(profit) as sum_profits
, count (order_id) as num_orders 
from orders   
group by 1 
order by 3 desc;

--by Subcategory
select p.sub_category, count(*) as num_returns, rt.reason_returned
from orders o
join products p on p.product_id = o.product_id  
left join returns rt on rt.order_id = o.order_id
where rt.reason_returned is not null and p.category = 'Furniture'
 and sub_category in ('Furnishings', 'Tables')
group by 1,3
order by 2 desc;

--Note I used sum to find total sales and profits based on number of orders and ship mode*/

/*Findings- The other sub-categories in the furniture category are doing much better than Tables in Superstore. To increase profit,
start with promoting tables across segments including corporate clients who historically make occassional large purposes of tables,
desks and furniture for office staffing purposes as this will begin to encourage customers to buy more tables.

Because it had higher cost, it was expected that tables would yield higher profit, but i suspected that the further away a region is, 
the more expensive shipping heavy items become.A table is a heavy furniture item, so maybe that is why tables is not a best seller. 

Standard class was the most profitable shipping mode overall. But, large items like furniture
cost more to ship, and take longer to get to far away regions outside of the America region. If a 
consumer is living outside of the contiguous U.S., and choosing standard shipping then it may be taking too
long for them to receive their item. They may choose to buy furniture from a closer location instead
causing the needs for returns. Additionally, since stantard shipping is not designed to be quick when
long distances are considered,this leaves large table and furnishing items open to being damaged in transit.





