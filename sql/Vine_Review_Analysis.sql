select * 
from vine_table 
limit 10;

--How many Vine reviews and non-Vine reviews were there?
--Total # of reviews
select TO_CHAR(count(*), 'FM9,999,999') as Total_No_Reviews 
from vine_table
where total_votes > 20;
--125,304

--Filter the data and create a new DataFrame or table to retrieve all the rows 
--where the total_votes count is equal to or greater than 20 to pick reviews that 
--are more likely to be helpful and to avoid having division by zero errors later on.
drop table tmpReviewsOverTwenty;
select *
into tmpReviewsOverTwenty
from vine_table
where total_votes > 20;

--Filter the new DataFrame or table created in Step 1 and create a new DataFrame or 
--table to retrieve all the rows where the number of helpful_votes divided by 
--total_votes is equal to or greater than 50%.
drop table tmpFiftyPercent;
select *, CAST(helpful_votes as FLOAT)/CAST(total_votes as FLOAT) as helpful_vote_percent
into tmpFiftyPercent
from tmpReviewsOverTwenty
where CAST(helpful_votes as FLOAT)/CAST(total_votes as FLOAT) >= 0.5;

Select count(*) from tmpFiftyPercent;

--Find total of reviews per Vine program
select Vine, TO_CHAR(count(*), 'FM9,999,999') as Total_No_Reviews 
from tmpFiftyPercent
group by vine;

-- Total # of Five-Star Reviews
select count(*) as Five_Star_Review_Count
from tmpFiftyPercent
where star_rating = 5;
--70,517

select * 
from tmpFiftyPercent
where star_rating = 5;

--How many Vine reviews were 5 stars? How many non-Vine reviews were 5 stars?
select Vine, count(*) as Five_Star_Review_Count
from tmpFiftyPercent
where star_rating = 5
group by Vine;

--What percentage of Vine reviews were 5 stars? What percentage of non-Vine reviews were 5 stars?
select Vine, count(*),
	TO_CHAR((CAST(count(*) as decimal)/(select count(*) from vine_table where star_rating = 5))*100, 'fm99D00%') as Percentage
from tmpFiftyPercent
where star_rating = 5
group by Vine