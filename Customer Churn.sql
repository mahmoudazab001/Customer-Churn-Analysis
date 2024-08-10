

-- in this analysis i will answer the most important question in any company which is 
--Q : Why customers leave the company???

-- i will divide my analysis into 3 parts

--First Part related to employees
--1 Age 
select
		[Age Group],
		count([Customer ID]) as total_customers
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		[Age Group]
order by
		2 desc
--# the highest no. of customers that left are (Middle age group) from the age of 31 till 64 years old.

--2 State
select
		State,
		COUNT([Customer ID]) as total_customers
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		State
order by
		2 desc
--# there's a wide spread in customer churn amoung the states but wv is the state with the most customer left and dc is the least.

--3 Gender
select
		Gender,
		COUNT([Customer ID]) as total_customers
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		Gender
order by
		2 desc
--# gender has no effect in causing customer to leave the company.


-- Secound part related to contracts
--1 contract length
select
		Account_Length,
		COUNT([Account Length (in months)]) AS total_customers
from
(
select
		[Account Length (in months)],
		case 
		when [Account Length (in months)]>72 then '6+ years'
		when [Account Length (in months)]>60 then '6 years'
		when [Account Length (in months)]>48 then '5 years'
		when [Account Length (in months)]>36 then '4 years'
		when [Account Length (in months)]>24 then '3 years'
		when [Account Length (in months)]>12 then '2 years'
		else 'less that a year'
		end as Account_Length
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
) as al
group by
		Account_Length
order by
		2 desc
--# customers with an account length (less than a year) are the most prone to leave.

--2 contract type
select
		[Contract Type],
		count([Customer ID]) as total_customers,
		cast(count(*) * 100.0 / sum(count(*)) over()as decimal(7,2)) as Percentage_of_Total
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		[Contract Type]
order by
		1,2 desc
--# Month-to-Month contract is the main type of contract that have the highest number of customer left.

--3 local calls / mins
select
		[Churn Label],
		COUNT([Customer ID]) as total_customers,
		sum([Local Calls]) as total_local_calls,
		sum([Local Mins]) as total_local_mins,
		round(sum([Local Calls])/count([Customer ID]),2) as avg_local_calls_per_customer,
		round(sum([Local Mins])/sum([Local Calls]),2) as avg_min_per_local_call
from
		[Customer Churn]..[Databel - Data]
group by
		[Churn Label]
--# customers who left the company have less avg local calls that the ones that stayed which means that call quality and services may be an issue.

--4 int plan vs int calls/mins
select
		[Churn Label],
		[Intl Plan],
		COUNT([Customer ID]) as total_customers,
		round(sum([Intl Calls]),0) as total_int_calls,
		round(sum([Intl Mins]),2) as total_int_mins,
		round(sum([Intl Calls])/count([Customer ID]),2) as avg_int_calls_per_customer,
		round(sum([Intl Mins])/sum([Intl Calls]),2) as avg_min_per_int_call,
		round(SUM([Extra International Charges])/count([Customer ID]),2) as avg_ext_int_charges_per_customer
from
		[Customer Churn]..[Databel - Data]
group by
		[Churn Label],[Intl Plan]
--# this analysis is very important as it may contain one of the main causes for customer churn;
--# 1) customer may left the company as the avg cost of int charges per customer is high which may be the reason they leave.
--# 2) int plan ads and awareness must be foucsed on.


--5 Unlimited Data Plan
select
		[Churn Label],
		[Unlimited Data Plan],
		COUNT([Customer ID]) as total_customers,
		round(sum([Avg Monthly GB Download]),0) as Avg_Monthly_GB_Download,
		round(SUM([Extra Data Charges])/count([Customer ID]),2) as avg_ext_int_charges_per_customer
from
		[Customer Churn]..[Databel - Data]
group by
		[Churn Label],[Unlimited Data Plan]
--# Unlimited Data Plan has low effect on churn rate.

--6 customer service calls
select
		[Customer Service Calls],
		[Churn Label],
		count([Customer ID]) as total_customers

from
		[Customer Churn]..[Databel - Data]
group by
		[Customer Service Calls],[Churn Label]
order by
		1,2,3 desc
--# customer service calls is one of the major reasons why customer leave:
--# i've noticed that till the 2nd customer service call customers have tendancy to stay more that to leave
--# but in the 3rd or 4th customer service call the majority of the customers leave the company.
--# the 5th customer service call is the fall point as no customer stayed after the 5th customer service call.

--7 customers in a group
select
		[Group],
		count([Customer ID]) as total_customers,
		cast(count(*) * 100.0 / sum(count(*)) over()as decimal(7,2)) as Percentage_of_Total

from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		[Group],[Churn Label]
order by
		1,2 desc
--# 94.5% of customers who left the company wasn't in a group.

--8 Device Protection & Online Backup
select
		[Device Protection & Online Backup],
		count([Customer ID]) as total_customers,
		cast(count(*) * 100.0 / sum(count(*)) over()as decimal(7,2)) as Percentage_of_Total
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		[Device Protection & Online Backup]
order by
		1,2 desc
--# 70% of customer left has no Device Protection & Online Backup (may be a reason for customers to leave) (need more ads and awareness)

--9 payment method
select
		[Payment Method],
		[Churn Label],
		count([Customer ID]) as total_customers,
		cast(count(*) * 100.0 / sum(count(*)) over()as decimal(7,2)) as Percentage_of_Total
from
		[Customer Churn]..[Databel - Data]
group by
		[Payment Method],[Churn Label]
order by
		1,2,3 desc
--# payment methods have no effect on churn rate.

--third part related to churn reasons
--1 Churn Category
select
		[Churn Category],
		count([Customer ID]) as total_customers,
		cast(count(*) * 100.0 / sum(count(*)) over()as decimal(7,2)) as Percentage_of_Total
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		[Churn Category]
order by
		3 desc
--# Compatitor is the main reasons why customers leave.

--2 Churn Reason
select
		[Churn Reason],
		count([Customer ID]) as total_customers,
		cast(count(*) * 100.0 / sum(count(*)) over()as decimal(7,2)) as Percentage_of_Total
from
		[Customer Churn]..[Databel - Data]
where
		[Churn Label] = 'yes'
group by
		[Churn Reason]
order by
		3 desc
--# better offer, better devices and the attitude of support person is the 3 main reasons why customers leave.







--## Conclusion
--1) Customer demographics have a minor impact on churn rates.
--2) Key factors contributing to customer churn include:
		--1 Customers with month-to-month contract types.
		--2 Customers with contracts lasting less than a year.
		--3 Customers not part of a group.
		--4 Customers with international calls/minutes but no international plan.
		--5 Customers with more than two customer service calls showing a higher tendency to leave.
--3) Approximately 70% of departing customers lack Device Protection & Online Backup.


--## Recommendations
--1) Introduce attractive deals for yearly subscriptions to encourage longer customer retention.
--2) Enhance benefits for group members, making their decision to leave more challenging.
--3) Invest in technical and behavioral training for customer service employees to reduce service calls, improve customer satisfaction, and decrease churn.
--4) Increase awareness of international calling plans and promote the benefits of Device Protection & Online Backup.
--5) Continuously improve services and devices, offering competitive deals to retain existing customers and attract new ones.