CREATE TABLE zomato
(
    RestaurantID BIGINT PRIMARY KEY,
    RestaurantName TEXT,
    CountryCode INTEGER,
    City TEXT,
    Address TEXT,
    Locality TEXT,
    LocalityVerbose TEXT,
    Cuisines TEXT,
    Currency TEXT,
    Has_Table_booking VARCHAR(3),
    Has_Online_delivery VARCHAR(3),
    Is_delivering_now VARCHAR(3),
    Switch_to_order_menu VARCHAR(3),
    Price_range INTEGER,
    Votes INTEGER,
    Average_Cost_for_two INTEGER,
    Rating NUMERIC(2,1)
);


------------------- Problems-------------

------------ Question 01. Total NUmber of resturant
select * from zomato;


------------- Question 2. Top ten citeies with the most restaurant
select city, count(*) AS num_restaurants
from zomato
group by city
order by num_restaurants DESC
limit 10;

------------ Question 3. Average Rating of all restaurants

Select round(avg(rating),2) as avg_rating
from zomato;

------------ Question 4. Restaurant with rating above

Select RestaurantName , City, Rating
from zomato
where rating > 4.5
order by rating desc;

------------ Question 5.  Restaurants offering online delivery

select count(*) from zomato
where Has_Online_delivery = 'Yes';

--------------- Question 6. Restaurants having table booking facility
select count(*) from zomato
where Has_Table_booking = 'Yes';


---------------- Question 07. Average cost fro two per city

Select city, round(avg(Average_cost_fro_two),2) as avg_cost_for_two
from zomato
group by city
order by avg_cost_for_two desc;

----------------- Question 8. Most common cuisine types

select Unnest(String_to_array(cuisines, '|')) as cuisine_type, count(*) as count
from zomato
group by cuisine_type
order by count Desc
limit 10;


----------------- Question 9. Restaurants with highest votes

Select RestaurantName, City, Votes
from zomato
order by votes desc
limit 10;

------------------- Question 10. Distribution of price ranges

select price_range, count(*) as count
from zomato
group by price_range
order by price_range;

------------------- Question 11. Average rating by price range

select price_range, round(avg(rating), 2) as avg_rating
from zomato
group by price_range
order by price_range;

------------------- Question 12. Average rating by cuisine
select UNNest(string_to_array(cuisines,'|')) as cuisine_type,
round(AVG(rating),2) as avg_rating
from zomato
group by cuisine_type
order by avg_rating desc
limit 10;

----------------- Question 13. Restaurants currently delivering now
select count(*)
from zomato
where Is_delivering_now = 'yes';

------------------ Question14. Number of restaurant per country code
Select CountryCode, COUNT(*) as num_restaurants
from zomato
group by CountryCode
Order BY num_restaurants desc;


---------------- Question 15. Highest aaaverage rated city
Select city, Round(Avg(rating),2) as avg_rating
from zomato
group by city
order by avg_rating desc
limit 5;


------------------- Question 16. Cheapest restaurants (Lowest average cost)
select RestaurantName, City, Average_Cost_for_two
from zomato
order by Average_Cost_for_two Asc
limit 10;


------------------- Question 17. Most Expensive Restaurants
select RestaurantName, City , Average_Cost_for_two
From zomato
order by Average_Cost_for_two desc
limit 10;


------------------ Question 18. Number of restuarants with rating below three
select count(*)
from zomato
where rating <3;

------------------ Question 19. Average votes per city
Select city, round(avg(votes),2) as avg_votes
from zomato 
group by city
order by avg_votes desc
limit 10;

--------------- Question 20. Cuisines offered by top rated restaurant

Select RestaurantName, Cuisines, Rating
from zomato
where rating >= 4.5
order by rating desc
limit 20;

----------------- Question 21. Top 5 cuisines with the highest average rating across rataurants with the more than 100 votes

select cuisine_type,
round(avg(rating),2) as avg_rating,
count(*) as num_restaurants
from(
select UNNEST(string_to_array(cuisines,'|')) as cuisine_type, rating, votes
from zomato
) sub
where votes>100
group by cuisine_type
order by avg_rating desc
limit 5;


---------------- Question 22. Find the city with the most restaurants offering onlime delivery and ratings above 4
select city, count(*) as num_online_delivery
from zomato
where Has_Online_delivery = 'Yes' and rating >4
group by city
order by num_online_delivery desc
limit 1;


---------------- Question23. Average rating of restaurants per city, ranked with a window function

select city,
    round(avg(rating),2) as avg_rating,
	rank() over(order by avg(rating) desc) as city_rank
from zomato
group by city;


----------------Question 24. Find restaurant that are above the overall avegage rating
Select RestaurantName, City, Rating
from zomato
where Rating > (Select avg(Rating) from zomato)
order by Rating desc;


--------------- Question 25. Cities where average cost fro two is higher than the overall average cost 

select city,
round(avg(Average_cost_for_two),2) as avg_cost_for_two
from zomato
group by city
having avg(Average_Cost_for_two) > (Select avg(Average_Cost_for_two) from zomato)
order by avg_cost_for_two desc;


---------------- Question 26. Percentange of restaurants with table booking facility

select 
round(
(Select count(*) from zomato where Has_Table_booking= 'Yes')::numeric / count(*)*100,2
)
as percentage_with_table_booking
from zomato;



--------------- Question 27. Most common cuisines in restaurants with rating below three

select cuisine_type , count(*) as count
from(
select unnest(String_to_array(cuisines,'|')) as cuisine_type, rating
from zomato
where rating< 3
) sub
group by cuisine_type
order by count desc
limit 5;

------------ Question 28. average Price range per cuisine using window functions

select cuisine_type,
   avg(price_range) as avg_price_range
   from(
select unnest(string_to_array(cuisines, '|')) as cuisine_type, price_range
from zomato
   ) sub
   group by cuisine_type
   order by avg_price_range desc
   limit 10;


   -----------------Question 29. Identify duplicate restairant names in teh smae city
   Select RestaurantName, City , COunt(*) as occurrences
   from zomato
   group by RestaurantName, City
    having count(*) > 1
	order by occurrences desc;


------------------ Question 30. For each price range, find the restaurant with the hishest votes 

select distinct on (price_range)
price_range, RestaurantName , Votes
from zomato
order by price_range, Votes Desc;

   