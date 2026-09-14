use Netflix;

-- Business Problems & Solutions
SELECT * from netflix;
-- 1. Count the number of Movies vs TV Shows
SELECT type ,COUNT(*) AS Occurences 
FROM netflix
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows
SELECT type,rating,COUNT(*) AS rating_count
FROM netflix
GROUP BY type, rating
ORDER BY type, rating_count DESC;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT type,title,release_year 
FROM netflix 
WHERE type="Movie" AND release_year=2020;

-- 4. Find the top 5 countries with the most content on Netflix
SELECT country ,COUNT(*) as total_content
FROM netflix 
WHERE country is not null
GROUP BY country
ORDER BY total_content DESC 
LIMIT 5 ;

-- 5. Identify the longest movie
SELECT title ,duration 
FROM netflix 
where type = "Movie"
order by CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) desc 
LIMIT 1 ;

-- 6. Find content added in the last 5 years
SELECT title,type,date_added
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT type,title,director 
FROM netflix
WHERE director like  "%Rajiv Chilaka%"; 

-- 8. List all TV shows with more than 5 seasons
SELECT title ,duration 
FROM netflix 
where CAST(substring_index(duration," ",1) as unsigned) >=5
AND type="TV Show" ;

-- 9. Count the number of content items in each genre
SELECT listed_in, COUNT(*) as content_count 
FROM netflix 
where listed_in is not null
group by listed_in
order by content_count desc;

-- 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT release_year, count(*) as content_count,
AVG(count(*)) OVER() as avg_content
FROM netflix
WHERE country like "%India%"
GROUP BY release_year
order by content_count desc 
limit 5;

-- 11. List all movies that are documentaries
SELECT title,listed_in
FROM netflix
WHERE type="Movie"
AND listed_in LIKE "%Documentaries%";

-- 12. Find all content without a director
SELECT * FROM netflix 
WHERE director is null ;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT title,cast ,release_year
FROM netflix 
where type= "Movie"
and cast like "%Salman Khan%" 
and release_year >= year(curdate()) - 10 ;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT TRIM(j.actor) AS actor,COUNT(*) AS movie_count
FROM netflix n
JOIN JSON_TABLE(
    CONCAT('["', REPLACE(n.cast, ', ', '","'), '"]'),
    '$[*]' COLUMNS (
        actor VARCHAR(255) PATH '$'
    )
) j
WHERE n.type = 'Movie'
  AND n.country LIKE '%India%'
GROUP BY TRIM(j.actor)
ORDER BY movie_count DESC
LIMIT 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.*/
-- Q15. Categorize content based on keywords in description

SELECT 
CASE
WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
ELSE 'Good'
END AS content_category,
COUNT(*) AS total_content
FROM netflix
GROUP BY content_category;
