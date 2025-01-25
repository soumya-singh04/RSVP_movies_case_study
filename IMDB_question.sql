USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
	COUNT(*) AS number_of_rows_director_mapping 
FROM 
	director_mapping;

SELECT 
	COUNT(*) AS number_of_rows_genre 
FROM 
	genre;

SELECT 
	COUNT(*) AS number_of_rows_movie 
FROM 
	movie;

SELECT 
	COUNT(*) AS number_of_rows_names 
FROM 
	names;

SELECT 
	COUNT(*) AS number_of_rows_ratings
FROM 
	ratings;

SELECT
	COUNT(*) AS number_of_rows_role_mapping 
FROM
	role_mapping;

-- Insight : number_of_rows_director_mapping = 3867  , number_of_rows_genre = 14662 , number_of_rows_movie = 7997  ,number_of_rows_names = 25735 
-- number_of_rows_ratings = 7997  ,number_of_rows_role_mapping = 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	SUM(CASE 
		WHEN id IS NULL THEN 1 ELSE 0 
        END) AS id_null_value,
	SUM(CASE 
		WHEN title IS NULL THEN 1 ELSE 0 
        END) AS title_null_value,
	SUM(CASE 
		WHEN year IS NULL THEN 1 ELSE 0 
        END) AS year_null_value,
	SUM(CASE 
		WHEN date_published IS NULL THEN 1 ELSE 0 
        END) AS date_published_null_value,
	SUM(CASE 
		WHEN duration IS NULL THEN 1 ELSE 0 
        END) AS duration_null_value,
	SUM(CASE 
		WHEN country IS NULL THEN 1 ELSE 0 
        END) AS country_null_value,
	SUM(CASE 
		WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 
        END) AS worlwide_gross_income_null_value,
	SUM(CASE 
		WHEN languages IS NULL THEN 1 ELSE 0 
        END) AS languages_null_value,
	SUM(CASE 
		WHEN production_company IS NULL THEN 1 ELSE 0 
        END) AS production_company_null_value
FROM 
	movie;
   
-- Insight :  We can see that  country ,worlwide_gross_income ,languages ,production_company have null values 20, 3724, 194, 528 RESPECTIVELY.


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	m.year , 
    COUNT(*) AS number_of_movies 
FROM 
	movie AS m
GROUP BY m.year;

-- 2017 year has maximum number of movies.

SELECT 
	MONTH(m.date_published) AS month_num , 
	COUNT(*) AS number_of_movies 
FROM 
	movie AS m
GROUP BY month_num
ORDER BY month_num;

-- Insight: Highest number of movies are produced in month of MARCH and lowest are in month of DECEMBER.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
	COUNT(*) AS num_of_movies 
FROM 
	movie 
WHERE year = 2019 AND (LOWER(country) LIKE '%usa%' OR LOWER(country) LIKE '%india%');

-- Insight :  We can see that INDIA and USA produced 1059 movies in the year 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
	g.genre 
FROM 
	genre AS g;

-- Insight : there are  13 UNIQUE genre as Drama ,Fantasy ,Thriller ,Comedy ,Horror ,Family , Romance ,Adventure ,Action ,Sci-Fi ,Crime ,Mystery ,Others .

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH genre_ranking AS
(
	SELECT 
		genre,
		COUNT(movie_id) AS movie_count,
		RANK () OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM
		genre 
	GROUP BY genre
)
SELECT 
    genre ,
    movie_count
FROM
    genre_ranking
WHERE
    genre_rank = 1;

-- Insight : DRAMA genre has highest number of movies. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH total_genre AS 
(    
SELECT 
	movie_id , 
	COUNT(genre) AS genre_count
FROM 
	genre
GROUP BY movie_id
)
SELECT 
	COUNT(DISTINCT movie_id) AS movies_belong_one_genre
FROM 
	total_genre
WHERE genre_count = 1;
      
-- Insight : We can see that there are 3289 movies which has one genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT
	g.genre,
	ROUND(AVG(m.duration),2) AS avg_duration_of_movies
FROM
	genre AS g
		LEFT JOIN 
	movie AS m 
		ON g.movie_id = m.id
GROUP BY g.genre;

-- Insight : Now we can see the average duration for genre DRAMA is 106.77 mins .

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_count AS 
(
    SELECT 
		g.genre , 
		COUNT(g.movie_id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(g.movie_id) DESC ) AS genre_rank
    FROM 
		genre AS g
	GROUP BY g.genre
)
SELECT *
FROM 
	genre_count
WHERE lower(genre) = 'thriller';

-- Insight : We can see that total no of movies under thriller genre are 1484 and rank is 3 .thriller movies are in top 3 among all.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating 
FROM 
	ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH top_10_movie AS
( 
	SELECT
	    m.title as title,
        r.avg_rating as avg_rating,
		RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
	FROM 
		movie AS m 
			LEFT JOIN 
		ratings AS r ON r.movie_id = m.id
)
SELECT *
FROM 
	top_10_movie
WHERE movie_rank <= 10;

-- Insight : yes we have FAN movie in top 10.

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
	r.median_rating, 
	COUNT(r.movie_id) AS movie_count
FROM 
	ratings AS r
GROUP BY r.median_rating
ORDER BY r.median_rating;

-- Insight : We can see that median rating 7 has highest number of movies.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH most_hit_movies AS
(
  SELECT 
	  m.production_company , 
	  COUNT(m.id) AS movie_count,
	  DENSE_RANK() OVER(ORDER BY COUNT(m.id) DESC) AS prod_company_dense_rank
  FROM 
	 movie AS m
		LEFT JOIN 
	 ratings AS r ON m.id = r.movie_id
  WHERE r.avg_rating > 8 
  AND m.production_company IS NOT NULL 
  GROUP BY m.production_company
) 
SELECT *
FROM 
	most_hit_movies 
WHERE prod_company_dense_rank = 1;

-- Insight : Dream Warrior Pictures and National Theatre Live production companies have produced maximum number of hit movies.

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	g.genre , 
	COUNT(g.movie_id) AS movie_count
FROM 
	genre AS g
		INNER JOIN 
	movie AS m ON g.movie_id = m.id
		INNER JOIN 
	ratings AS r ON m.id = r.movie_id
WHERE 
	MONTH(m.date_published) = 3
	AND m.year = 2017
	AND LOWER(m.country) LIKE '%usa%'
	AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

-- Insight: Drama genre has produced maximum number of movies.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	m.title , 
	r.avg_rating, 
	g.genre
FROM 
	movie AS m
		INNER JOIN 
	genre AS g ON m.id = g.movie_id
		INNER JOIN 
	ratings AS r ON m.id = r.movie_id
WHERE
	m.title LIKE 'The%' 
	AND r.avg_rating > 8
ORDER BY genre,r.avg_rating DESC;

-- Insight: Drama genre has highest rating .

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	COUNT(m.id) AS movie_count 
FROM 
	movie AS m
		INNER JOIN 
	ratings AS r ON m.id = r.movie_id
WHERE 
	r.median_rating = 8
	AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- Insight : 361 movies are released between 1 april 2018 and 1 april 2019 and also median rating is 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH total_votes AS
(
SELECT 
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN m.id END) AS german_movie_count,
	COUNT(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN m.id END) AS italian_movie_count,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%german%' THEN r.total_votes END) AS german_movie_votes,
	SUM(CASE WHEN LOWER(m.languages) LIKE '%italian%' THEN r.total_votes END) AS italian_movie_votes
FROM
    movie AS m 
	    INNER JOIN
	ratings AS r ON m.id = r.movie_id
)
SELECT 
    ROUND(german_movie_votes / german_movie_count, 2) AS german_votes_per_movie,
    ROUND(italian_movie_votes / italian_movie_count, 2) AS italian_votes_per_movie
FROM
    total_votes;
    
-- Insight : We can see that german movies get more votes .

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE 
		WHEN name IS NULL THEN 1 ELSE 0 
        END) AS name_nulls,
	SUM(CASE 
		WHEN height IS NULL THEN 1 ELSE 0 
        END) AS height_nulls,
	SUM(CASE
		WHEN date_of_birth IS NULL THEN 1 ELSE 0 
        END) AS date_of_birth_nulls,
	SUM(CASE 
    WHEN known_for_movies IS NULL THEN 1 ELSE 0 
    END) AS known_for_movies_nulls
FROM 
	names;
       
-- Insight: height , date_0f_birth, known_for_movies  columns have null values.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS
(
   SELECT 
	  g.genre , 
	  COUNT(g.movie_id) AS movie_count
   FROM 
	  genre AS g
		INNER JOIN 
	  ratings AS r ON g.movie_id = r.movie_id
   WHERE r.avg_rating > 8
   GROUP BY g.genre
   ORDER BY COUNT(g.movie_id) DESC
   LIMIT 3
) 
SELECT 
	n.name as director_name ,
    count( g.movie_id) AS movie_count
FROM 
	genre as g
		INNER JOIN 
	director_mapping as d ON g.movie_id = d.movie_id
		INNER JOIN 
	names as n ON d.name_id = n.id
		INNER JOIN 
	ratings as r ON d.movie_id = r.movie_id
where r.avg_rating > 8 
AND g.genre IN (SELECT genre FROM top_3_genre )
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;

-- Insight : James Mangold ,Joe Russo,Anthony Russo are Top 3 director. 


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	n.name AS actor_name, 
	COUNT(r.movie_id) AS movie_count
FROM 
	names AS n
		INNER JOIN 
	role_mapping AS rm ON n.id = rm.name_id
		INNER JOIN 
	ratings AS r ON rm.movie_id = r.movie_id
WHERE median_rating >= 8
AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

-- Insight : Mammootty ,Mohanlal  are top 2 actors.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_3_production_house AS 
(  
	SELECT 
		m.production_company, 
	    SUM(r.total_votes) AS vote_count,
	    DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
	FROM 
		movie AS m
			LEFT JOIN 
		ratings AS r ON m.id = r.movie_id
	WHERE m.production_company IS NOT NULL
	GROUP BY m.production_company
)
SELECT 
	*
FROM 
	top_3_production_house
WHERE prod_comp_rank <= 3;

-- Insight: Marvel Studios , Twentieth Century Fox ,Warner Bros. are the top 3 production houses.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actor AS
(
SELECT 
	n.name as actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) as movie_count,
	ROUND(SUM(r.avg_rating*r.total_votes)/ SUM(r.total_votes),2) AS actor_avg_rating
FROM
	names AS n
		INNER JOIN
	role_mapping AS a ON n.id=a.name_id
		INNER JOIN
	movie AS m ON a.movie_id = m.id
		INNER JOIN
	ratings AS r ON m.id=r.movie_id
WHERE 
	category = 'actor' AND LOWER(country) like '%india%'
GROUP BY actor_name
)
SELECT *,
	RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM
	top_actor
WHERE movie_count >= 5;

-- Insight: Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_actress AS
(
SELECT 
	n.name as actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) as movie_count,
	ROUND(SUM(r.avg_rating * r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating
FROM
	names AS n
		INNER JOIN
	role_mapping AS a ON n.id=a.name_id
		INNER JOIN
	movie AS m ON a.movie_id = m.id
		INNER JOIN
	ratings AS r ON m.id=r.movie_id
WHERE 
	category = 'actress' AND LOWER(languages) like '%hindi%'
GROUP BY actress_name
)
SELECT *,
	DENSE_RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM
	top_actress
WHERE movie_count>=3
LIMIT 5;

-- Insight: Taapsee pannu is top actress having avg_rating 7.74.


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

SELECT 
    m.title AS movie_name,
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One time watch'
        ELSE 'Flop'
    END AS movie_category
FROM
    movie AS m
        LEFT JOIN
    ratings AS r ON m.id = r.movie_id
        LEFT JOIN
    genre AS g ON m.id = g.movie_id
WHERE LOWER(genre) = 'thriller'
AND total_votes > 25000
ORDER BY r.avg_rating desc;

-- Insight : Joker ,Andhadhun,Contratiempo are top 3.

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_vise_data AS
(
SELECT 
    g.genre,
    ROUND(AVG(duration),2) AS avg_duration
FROM
    genre AS g
        LEFT JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY g.genre
)
SELECT *,
	SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM
	genre_vise_data;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_3_genre AS
(
SELECT 
    g.genre,
    COUNT(m.id) AS movie_count,
	RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM
    genre AS g
        LEFT JOIN
    movie AS m ON g.movie_id = m.id
GROUP BY g.genre
),
movies_from_genre AS
(
SELECT 
    g.genre,
	m.year,
	m.title as movie_name,
    worlwide_gross_income,
    RANK() OVER (PARTITION BY g.genre, m.year ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM
	movie AS m
		INNER JOIN
	genre AS g ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_3_genre WHERE genre_rank <= 3)
)
SELECT * 
FROM
	movies_from_genre
WHERE movie_rank<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_house AS
(
SELECT 
    m.production_company,
    COUNT(m.id) AS movie_count,
    DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
    movie AS m
        LEFT JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
	median_rating>=8 
    AND m.production_company IS NOT NULL 
    AND POSITION(',' IN languages)>0
GROUP BY m.production_company
)
SELECT *
FROM
    production_house
WHERE
    prod_company_rank <= 2;
-- Star Cinema,Twentieth Century Fox are top 2 production 


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH top_actress_rank AS
(
	SELECT
		n.name AS actress_name,
		sum(r.total_votes) AS total_votes, 
		COUNT(rm.movie_id) AS movie_count, 
		ROUND(SUM(r.total_votes*r.avg_rating) /SUM(r.total_votes),2) AS actress_avg_rating,
		RANK() OVER(ORDER BY ROUND(SUM(r.total_votes*r.avg_rating) /sum(r.total_votes),2) DESC, 
		SUM(r.total_votes) DESC, n.name ) AS actress_rank 
	FROM 
		names as n
			INNER JOIN 
		role_mapping as rm ON n.id = rm.name_id
			INNER JOIN 
		ratings as r ON rm.movie_id = r.movie_id
			INNER JOIN  
		genre as g ON r.movie_id = g.movie_id
	WHERE r.avg_rating > 8 
	AND g.genre = 'Drama' 
	AND  rm.category = 'actress'
	GROUP BY actress_name
)
SELECT * 
FROM 
	top_actress_rank
WHERE actress_rank <= 3;

-- Sangeetha Bhat ,Adriana Matoshi ,Fatmire Sahiti are top 3 actresses.

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top_9_directors AS
(
SELECT 
	n.id as director_id,
    n.name as director_name,
	COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) as director_rank
FROM
	names AS n
		INNER JOIN
	director_mapping AS d ON n.id=d.name_id
		INNER JOIN
	movie AS m ON d.movie_id = m.id
GROUP BY n.id
),
movie_next_date AS
(
SELECT
	n.id as director_id,
    n.name as director_name,
    m.id AS movie_id,
    m.date_published,
	r.avg_rating,
    r.total_votes,
    m.duration,
    LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published) AS next_date_published,
    DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published),date_published) AS inter_movie_days
FROM
	names AS n
		INNER JOIN
	director_mapping AS d ON n.id=d.name_id
		INNER JOIN
	movie AS m ON d.movie_id = m.id
		INNER JOIN
	ratings AS r ON m.id=r.movie_id
WHERE n.id IN (SELECT director_id FROM top_9_directors WHERE director_rank <= 9)
)
SELECT 
	director_id,
	director_name,
	COUNT(DISTINCT movie_id) as number_of_movies,
	ROUND(AVG(inter_movie_days),0) AS avg_inter_movie_days,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM 
movie_next_date
GROUP BY director_id
ORDER BY number_of_movies DESC, avg_rating DESC;
-- Insight:  A.L. Vijay ,Andrew Jones , Steven Soderbergh,Sam Liu , Sion Sono,Jesse V.Johnson, Justin Price,,Chris Stokes ,Özgür Bakar