CREATE TABLE movies(
	id SERIAL PRIMARY KEY,
	movies TEXT,
	genre TEXT,
	rating TEXT,
	one_line TEXT,
	stars TEXT,
	votes TEXT,
	runtime TEXT,
	gross TEXT
);
--populating the table with data from the .csv file
COPY cafe (movies, genre, rating, one_line, stars, votes, runtime, gross)
	FROM 'C:\Program Files\PostgreSQL\dirty_cafe_sales.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE movie_sum AS 
SELECT  * 
FROM movies;


WITH moviie AS(
	select *,
	ROW_NUMBER() OVER( 
	 PARTITION BY movies, genre, rating, one_line, stars, votes, runtime, gross ) AS rw_nb
	 FROM movie_sum
)
SELECT * FROM movie_sum
--DELETE FROM layoffs
WHERE id IN(
 SELECT id from moviie where rw_nb >1
);

SELECT * FROM movies;