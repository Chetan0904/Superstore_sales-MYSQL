use superstore_sales

/********************** EXPLORING THE TIMEFRAME AND DATES OF THE DATA********************************************/

# A1. How many years of transactions are there? select * from orders
SELECT DISTINCT YEAR(OrderDate) FROM orders;

/*
2009
2010
2011
2012
*/

# A2. What are the dates of the first and last orders placed? 

SELECT OrderDate FROM orders
order by OrderDate asc LIMIT 1;

-- 2009-01-01

SELECT OrderDate FROM orders
order by OrderDate desc LIMIT 1;

-- 2012-12-30

# A3 Are there consistent orders throughout the year for each year?

SELECT YEAR(OrderDate) as OrderYear, MONTH(OrderDate) as OrderMonth, DAY(OrderDate) as OrderDay
FROM orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate);

-- Results returning twelve distinct months per year and 28 to 31 days per month each year

/***************************** EXOPLORING TOP PROFIT, EXPENSES, SALES, ORDERS AND AVERAGES PER YEAR***************************************/

# B1 What is the total profit per year?
SELECT YEAR(OrderDate) as Year, SUM(Profit) as Total_profit FROM orders
GROUP BY Year
ORDER BY Year asc;

/*
2009	420337.16
2010	365587.04
2011	370909.72
2012	336847.45
*/

-- 2009 had the highest Total Profit while 2012 had the smallest.

# B2 What is the YoY Profit Growth rate?

-- from 2009 to 2010
SELECT ROUND((((SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate) = 2010) - (SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate) = 2009))/
(SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate)= 2009)),2) AS Profit_growth_rate FROM orders
ORDER BY Profit_growth_rate LIMIT 1;

-- -0.13

-- from 2010 to 2011
SELECT ROUND((((SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate) = 2011) - (SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate) = 2010))/
(SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate)= 2010)),2) AS Profit_growth_rate FROM orders
ORDER BY Profit_growth_rate LIMIT 1;

-- 0.01

-- from 2011 to 2012
SELECT ROUND((((SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate) = 2012) - (SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate) = 2011))/
(SELECT SUM(Profit) FROM orders WHERE YEAR(OrderDate)= 2011)),2) AS Profit_growth_rate FROM orders
ORDER BY Profit_growth_rate LIMIT 1;

-- -0.09

-- In terms of YOY profit growth rate, there has been a negative growth rate  for 2009-2010 and 2011-2012  years

# B3 With shipping cost being the only expense data available, what is the total shipping cost per year?

SELECT YEAR(OrderDate) AS Year, SUM(ShippingCost) AS Shipping_Cost FROM orders
GROUP BY Year ORDER BY Year desc;

/*
2012	24671.53
2011	22336.19
2010	24758.64
2009	26202.65
*/

# B4 What is the change in shipping cost YoY?

-- from 2009 to 2010

SELECT ROUND((((SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate) = 2010) - (SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate) = 2009))/
(SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate)= 2009)),2) AS Change_in_shipping_cost FROM orders
ORDER BY Change_in_shipping_cost LIMIT 1;

-- -0.06

-- from 2010 to 2011
SELECT ROUND((((SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate) = 2011) - (SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate) = 2010))/
(SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate)= 2010)),2) AS Change_in_shipping_cost FROM orders
ORDER BY Change_in_shipping_cost LIMIT 1;

-- -0.10

-- from 2011 to 2012
SELECT ROUND((((SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate) = 2012) - (SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate) = 2011))/
(SELECT SUM(ShippingCost) FROM orders WHERE YEAR(OrderDate)= 2011)),2) AS Profit_growth_rate FROM orders
ORDER BY Profit_growth_rate LIMIT 1;

-- 0.10

 /* 2011-2012 has the highest YOY shippingcost and 2010-2011 has the lowest
 
During consistent periods of negative growth rate YOY for profit, shipping costs (the only expense indicated) 
actually decreased from 2009-2011. Assuming there was no business expansion or big investments made, 
that means revenue in total had to have decreased. This can indicate that for 2009, 2010, and 2011 the 
number of items ordered and/or mass of items ordered decreased (leading to both decreased shipping costs and profits), 
the profit margins of the ordered products were smaller, the cost of shipping itself decreased (fuel costs, 
more efficient logistics routes etc) and/or the discounts used also increased (reducing the profit margins).
select * from orders */

# B5 What are the cumulative sales, quantity of items ordered, total number of orders, 
# average sales per order, average discount rate, and average unit price of items sold per year?

SELECT YEAR(OrderDate) AS Year,  SUM(Sales) AS Total_sales, SUM(OrderQuantity) AS Total_quantity, COUNT(OrderID) AS Total_orders,
SUM(Sales)/COUNT(OrderID) AS Avg_sales_per_order , AVG(Discount) AS Average_discount, AVG(UnitPrice) AS Avg_unitprice
from orders
GROUP BY Year ORDER BY Year asc;

/*
2009	3949005.33350	52534	2079	1899.473464886	0.048822	106.155224
2010	3184851.07250	52356	2060	1546.044209951	0.049350	71.366034
2011	3118796.48600	49547	1919	1625.219638353	0.050823	76.212137
2012	3369240.39600	52471	2025	1663.822417777	0.049837	90.349832
*/

-- The maximum of total sales occurred in 2009, followed by 2012, 2010, then 2011. 
-- The maximum count of orders occured in 2009, followed by 2010, 2012, then 2011.
-- The maximum average sales per order occured in 2009, followed by 2012, 2011, then 2010.
-- Generally, 2009 performed best in terms of sales and orders, which both overall declined in subsequent years.
-- Overall analysis:

# B6 How many orders got returned each year and what is the yearly revenue loss due to the product returns?

SELECT YEAR(OrderDate) AS Year, COUNT(DISTINCT(OrderID)) AS Order_returned, SUM(sales) AS sales_lost
FROM orders
WHERE OrderID IN (SELECT DISTINCT(OrderID) FROM returns)
GROUP BY Year ;

/*
2009	135	349251.16050
2010	133	190394.54050
2011	140	222012.84250
2012	145	247623.39800
*/

-- the number of orders returned decreased from 2009 to 2010 but suddenly incresed from 2010 to 2012
-- sales lost also decreased from 2009 to 2010 but suddenly incresed froM 2010 to 2012

/**************************** EXPLORING CUSTOMER DATA***************************************/

# C1 What is the biggest customer segment? 

SELECT CustomerSegment, COUNT(CustomerSegment) AS count FROM customer
GROUP BY CustomerSegment;

/*
Small Business	342
Home Office	380
Corporate	613
Consumer	348
*/

-- Corporate(613) is the largest followed by Home Office(380), Consumer(348) and Small Business(342)

# C2 Which customer segment did the top 10 customers with the most total orders belong to?

SELECT o.CustomerID, COUNT(DISTINCT(o.OrderID)) AS total_orders, c.CustomerSegment FROM orders o
INNER JOIN  customer c ON o.CustomerID = c.CustomerID
GROUP BY CustomerID
ORDER BY total_orders desc LIMIT 10;

/*
48452	5	Home Office
48772	5	Small Business
1444	5	Corporate
13540	5	Home Office
42528	5	Corporate
58470	5	Small Business
27106	5	Small Business
43875	5	Home Office
12067	5	Corporate
24132	5	Corporate
*/
#C3  How many total orders and sales were generated by each customer segment?

SELECT c.CustomerSegment, COUNT(o.OrderID) AS total_orders , SUM(sales) AS total_sales FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
GROUP BY CustomerSegment ORDER BY total_sales desc;

/*
Corporate	1105	1805019.78300
Consumer	591	1098135.23150
Home Office	676	1018184.70150
Small Business	614	897100.56950
*/

-- The Corporate Segment generated the most total sales and total number of orders,
-- followed by Consumer, Homeoffice and Small Business in last place.

# C4 How many total orders and sales were generated by each customer segment per year? 

SELECT YEAR(O.OrderDate) AS year, c.CustomerSegment, COUNT(o.OrderID) AS total_orders , SUM(sales) AS total_sales FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
GROUP BY CustomerSegment, year ORDER BY year asc, total_sales desc;

/*
2009	Corporate	288	506644.99200
2009	Home Office	172	351488.76750
2009	Consumer	145	302982.70100
2009	Small Business	166	265026.42050

2010	Corporate	294	417020.54000
2010	Consumer	152	279477.78800
2010	Home Office	208	227456.67900
2010	Small Business	150	222186.49500

2011	Corporate	266	471870.61650
2011	Consumer	151	227221.35650
2011	Home Office	156	194392.49300
2011	Small Business	139	148499.47000

2012	Corporate	257	409483.63450
2012	Consumer	143	288453.38600
2012	Small Business	159	261388.18400
2012	Home Office	140	244846.76200
*/

-- Corporate sales is highest for each year
-- Consumer sales is third highest in 2010 and second highest for rest of the years
-- for small Business and Home Office sales are increasing and decreasing from 2009 to 2012

# C4 Which province has the most number of Corporate customers? 

SELECT province, COUNT(CustomerSegment) AS total_corporate_customers
FROM customer
WHERE CustomerSegment = 'Corporate'
GROUP BY province
ORDER BY total_corporate_customers desc LIMIT 1;

-- Ontario	113

-- Ontaria has the most number of corporate customers

/********************************EXPLORING THE TOP SALES,PRODUCTS AND CUSTOMER INFO PER YEAR***********************************/

-- 2009

#D1 How much sales was generated by the top five orders placed in 2009?

SELECT YEAR(OrderDate) AS year, OrderID, sales FROM orders
WHERE YEAR(OrderDate) = 2009
ORDER BY sales desc LIMIT 5;

/*
2009	5534	89061.05000
2009	5532	45923.76000
2009	5521	28359.40000
2009	5751	28180.08000
2009	3667	27820.34000
*/

# D2 What were the top products ordered in the above top sales orders for 2009?

SELECT o.OrderID , p.ProductName FROM orders o
INNER JOIN product p ON o.ProductID = p.ProductID
WHERE o.OrderID = 5534 
OR o.OrderID = 5532
OR o.OrderID = 5521
OR o.OrderID = 5751
OR o.OrderID = 3667;

/*
3667	Hewlett Packard LaserJet 3310 Copier
5521	Polycom ViaVideoª Desktop Video Communications Unit
5532	Polycom ViewStationª ISDN Videoconferencing Unit
5534	Polycom ViewStationª ISDN Videoconferencing Unit
5751	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish
*/

 # D3 Who were the top customers that placed these orders?

SELECT o.OrderID , c.CustomerName FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
WHERE o.OrderID = 5534 
OR o.OrderID = 5532
OR o.OrderID = 5521
OR o.OrderID = 5751
OR o.OrderID = 3667
;
-- 2010

#D4 How much sales was generated by the top five orders placed in 2010?

SELECT YEAR(OrderDate) AS year, OrderID, sales FROM orders
WHERE YEAR(OrderDate) = 2010
ORDER BY sales desc LIMIT 5;

/*
2010	2028	29884.60000
2010	2033	28761.52000
2010	5753	28389.14000
2010	2029	27875.54000
2010	5363	25313.34000
*/

# D5  What were the top products ordered in the above top sales orders for 2010?
SELECT o.OrderID , p.ProductName FROM orders o
INNER JOIN product p ON o.ProductID = p.ProductID
WHERE o.OrderID = 2028 
OR o.OrderID = 2033
OR o.OrderID = 5753
OR o.OrderID = 2029
OR o.OrderID = 5363
;
/*
2028	Canon Image Class D660 Copier
2029	Canon Image Class D660 Copier
2033	Canon imageCLASS 2200 Advanced Copier
5363	Okidata ML591 Wide Format Dot Matrix Printer
5753	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish
*/
 # D3 Who were the top customers that placed these orders?

SELECT o.OrderID , c.CustomerName FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
WHERE o.OrderID = 2028 
OR o.OrderID = 2033
OR o.OrderID = 5753
OR o.OrderID = 2029
OR o.OrderID = 5363
;
-- 2011
#D4 How much sales was generated by the top five orders placed in 2011?

SELECT YEAR(OrderDate) AS year, OrderID, sales FROM orders
WHERE YEAR(OrderDate) = 2011
ORDER BY sales desc LIMIT 5;

/*
2011	5758	29345.27000
2011	3699	29186.49000
2011	3672	28664.52000
2011	3674	27720.98000
2011	2034	27663.92000
*/

# D5  What were the top products ordered in the above top sales orders for 2011?
SELECT o.OrderID , p.ProductName FROM orders o
INNER JOIN product p ON o.ProductID = p.ProductID
WHERE o.OrderID = 5758
OR o.OrderID = 3669
OR o.OrderID = 3672
OR o.OrderID = 3674
OR o.OrderID = 2034
;
/*
2034	Canon imageCLASS 2200 Advanced Copier
3669	Hewlett Packard LaserJet 3310 Copier
3672	Hewlett Packard LaserJet 3310 Copier
3674	Hewlett Packard LaserJet 3310 Copier
5758	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish
*/
 # D3 Who were the top customers that placed these orders?

SELECT o.OrderID , c.CustomerName FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
WHERE o.OrderID = 5758
OR o.OrderID = 3669
OR o.OrderID = 3672
OR o.OrderID = 3674
OR o.OrderID = 2034
;
-- 2012
#D4 How much sales was generated by the top five orders placed in 2012?

SELECT YEAR(OrderDate) AS year, OrderID, sales FROM orders
WHERE YEAR(OrderDate) = 2012
ORDER BY sales desc LIMIT 5;

/*
2012	5538	41343.21000
2012	2037	33367.85000
2012	3592	24701.12000
2012	5423	24559.91000
2012	5760	24391.16000
*/
;
# D5  What were the top products ordered in the above top sales orders for 2012?
SELECT o.OrderID , p.ProductName FROM orders o
INNER JOIN product p ON o.ProductID = p.ProductID
WHERE o.OrderID = 5538
OR o.OrderID = 2037
OR o.OrderID = 3592
OR o.OrderID = 5423
OR o.OrderID = 5760
;
/*
2037	Canon imageCLASS 2200 Advanced Copier
3592	Global Troyª Executive Leather Low-Back Tilter
5423	Panasonic KX-P3626 Dot Matrix Printer
5538	Polycom ViewStationª ISDN Videoconferencing Unit
5760	Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish
*/
 # D3 Who were the top customers that placed these orders?

SELECT o.OrderID , c.CustomerName FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
WHERE o.OrderID = 5538
OR o.OrderID = 2037
OR o.OrderID = 3592
OR o.OrderID = 5423
OR o.OrderID = 5760
;

#  On which day of week was the biggest sales order made? What was the product? 

SELECT DAYOFWEEK(o.OrderDate) as orderday, o.OrderDate, o.ProductID, P.ProductName
FROM orders o
INNER JOIN product p ON o.ProductID = p.ProductID
WHERE sales IN (SELECT MAX(sales) FROM orders)
;
/*
7  2009-03-21	147664	Polycom ViewStationª ISDN Videoconferencing Unit
*/


/***********************************
# G. Miscellaneous Queries
 ***********************************/
 
 # E1 What are the smallest and largest order quantities and sales by year and month?
 SELECT YEAR(OrderDate) AS year, MONTH(OrderDate) AS month ,
 MIN(sales) AS min_sales, MAX(sales) AS max_sales,
 MIN(OrderQuantity) AS min_orderquantity, MAX(OrderQuantity) AS max_orderquantity
 FROM orders
 GROUP BY year, month ORDER BY year desc, month desc;
 
 /*
 2012	12	14.15000	33367.85000	1	50
2012	11	6.77000	23300.12000	1	50
2012	10	7.56000	23516.31000	1	50
2012	9	10.65000	14383.83000	1	50
2012	8	17.72000	23775.56000	2	50
2012	7	5.68000	13934.53000	1	50
2012	6	8.49000	14753.08000	1	50
2012	5	9.70000	41343.21000	1	50
2012	4	3.96000	16269.82000	1	50
2012	3	4.94000	21205.50000	1	50
2012	2	6.93000	17965.45000	1	50
2012	1	3.63000	24701.12000	1	50
2011	12	10.59000	26622.55000	1	50
2011	11	3.20000	29345.27000	1	50
2011	10	7.15000	24233.54000	1	50
2011	9	12.49000	21046.74000	1	49
2011	8	2.24000	18235.47000	1	50
2011	7	8.60000	29186.49000	1	50
2011	6	10.48000	10854.83000	1	50
2011	5	10.48000	20701.92800	1	50
2011	4	21.07000	23281.05000	1	50
2011	3	7.64000	28664.52000	1	50
2011	2	7.98000	20265.22000	1	50
2011	1	8.48000	27663.92000	1	50
2010	12	5.73000	17717.34000	1	50
2010	11	4.97000	19109.61000	1	50
2010	10	6.34000	28761.52000	1	50
2010	9	6.75000	24051.49000	1	50
2010	8	5.31000	21062.91000	1	49
2010	7	3.23000	12719.70000	1	50
2010	6	12.20000	27875.54000	1	50
2010	5	4.99000	16073.03000	1	50
2010	4	15.64000	24639.80000	1	50
2010	3	7.75000	9574.82000	1	50
2010	2	5.63000	21506.77000	1	50
2010	1	3.41000	29884.60000	1	50
2009	12	11.51000	27820.34000	1	50
2009	11	8.34000	20872.16000	1	50
2009	10	9.40000	26126.92000	1	50
2009	9	11.35000	23106.46000	1	50
2009	8	10.94000	24105.87000	1	50
2009	7	11.16000	26095.13000	1	50
2009	6	10.48000	23792.93000	1	50
2009	5	10.12000	14451.75000	1	50
2009	4	3.42000	18092.66000	1	50
2009	3	12.01000	89061.05000	1	50
2009	2	3.77000	19100.45000	1	50
2009	1	6.76000	45923.76000	1	50
*/

# E2 Which Shipping Mode has the highest average order shipping cost? 

SELECT ShipMode, AVG(ShippingCost) AS avg_shipping_cost FROM orders
GROUP BY ShipMode ORDER BY avg_shipping_cost desc LIMIT 1;

-- Delivery Truck	43.838932

# E3 Which Product SubCategory has the highest average base margin?

SELECT ProductCategory, ProductSubcategory, AVG(ProductBaseMargin) AS avg_basemargin FROM product
GROUP BY ProductCategory, ProductSubcategory ORDER BY avg_basemargin desc LIMIT 1;

-- Furniture	Tables	0.665000

# E4 How many orders were placed each month between 2011 and 2012?

SELECT YEAR(OrderDate) AS year, MONTH(OrderDate) AS month, COUNT(DISTINCT(OrderID)) AS total_orders
FROM orders
WHERE YEAR(OrderDate) BETWEEN 2011 AND 2012
GROUP BY year, month
ORDER BY year, month desc;

/*
2011	12	178
2011	11	160
2011	10	157
2011	9	155
2011	8	147
2011	7	162
2011	6	159
2011	5	176
2011	4	164
2011	3	148
2011	2	166
2011	1	147
2012	12	150
2012	11	125
2012	10	193
2012	9	189
2012	8	177
2012	7	162
2012	6	148
2012	5	204
2012	4	176
2012	3	192
2012	2	143
2012	1	166
*/
# E5  Which customers made more than 3 orders in 2009?
select CustomerID, 
       count(distinct OrderID) as cnt_Order
from orders
where year(OrderDate) = 2009
group by CustomerID
having cnt_Order >= 3;

SELECT CustomerID, COUNT(CustomerID) AS count FROM orders
WHERE YEAR(OrderDate) = 2009
GROUP BY CustomerID 
Having COUNT(CustomerID) > 3;

/*
1444	5
2790	4
3395	4
4647	4
8646	4
12258	4
13313	4
24003	4
24132	5
25824	4
26567	4
29187	5
30567	4
31873	4
32611	4
32869	4
33317	4
33797	4
35364	4
36355	4
42631	4
47108	4
48772	5
49216	4
50656	4
51266	4
51619	4
53152	4
53476	4
53891	4
55040	4
56002	4
57253	4
58784	5
59072	4
59170	4
*/
# E6 What is the highest single day sales figure? 

SELECT MAX(TotSalesByDay) FROM (SELECT OrderDate, SUM(sales) AS TotSalesByDay
		FROM orders
        GROUP BY OrderDate
        ORDER BY sum(sales) asc) A ;
        
-- 114488.88400
        
# E7  Which customers purchased products on New Years Eve in either 2009 and 2010?

SELECT o.OrderDate, o.orderID, c.CustomerID, c.CustomerName FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
WHERE OrderDate = '2009-12-31' 
OR  OrderDate = '2010-12-31' ;

-- 2010-12-31	7302	28262	David Kendrick

# E8 How many orders were placed each year, with years listed as column headers?

SELECT SUM(CASE WHEN YEAR(OrderDate) = 2009 THEN 1 ELSE 0 END) AS orders_2009,
	   SUM(CASE WHEN YEAR(OrderDate) = 2010 THEN 1 ELSE 0 END) AS orders_2010,
       SUM(CASE WHEN YEAR(OrderDate) = 2011 THEN 1 ELSE 0 END) AS orders_2011,
       SUM(CASE WHEN YEAR(OrderDate) = 2012 THEN 1 ELSE 0 END) AS orders_2012
FROM(SELECT DISTINCT OrderID, OrderDate FROM orders) o ;

-- 2079	 2060	1919	2025

/**************END*****************/
