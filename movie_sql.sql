SELECT * FROM movie_copy;

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

CREATE TABLE movie_copy AS 
SELECT  * 
FROM movies;
--checking for duplicates using a cte
WITH film AS(
	select *,
	ROW_NUMBER() OVER( 
	 PARTITION BY movies,year, genre, rating, one_line, stars, votes, runtime, gross ) AS rw_nb
	 FROM movie_copy
)
DELETE FROM movie_copy
WHERE id IN(
 SELECT id from film where rw_nb >1
);

--removing leading and trailing spaces
UPDATE movie_copy
SET movies = TRIM(movies),
	year = TRIM(year),
	rating = TRIM(rating),
	one_line=TRIM(one_line),
	stars=TRIM(stars),
	votes=TRIM(votes),
	runtime=TRIM(runtime),
	gross=TRIM(gross);

--updating the feild names 
ALTER TABLE movie_copy
RENAME COLUMN movies TO movie_Title;

ALTER TABLE movie_copy
RENAME COLUMN year TO year_released;

ALTER TABLE movie_copy
RENAME COLUMN one_line TO movie_description;

--working on the year_released
--removes all non-alphanumeric character in the year_released
UPDATE movie_copy
SET year_released = REGEXP_REPLACE( year_released, '[^0-9]', '', 'g');
--SET year_released = REGEXP_REPLACE( year_released, '[^a-zA-Z0-9\s]', '', 'g');
 
 -- returning the first four digits of the year_released field
 UPDATE movie_copy
 SET year_released =SUBSTRING(year_released, 1, 4);

 --setting all cells with no valide year as null
 UPDATE  movie_copy
 SET year_released = NULL
 WHERE LENGTH(year_released) <4 OR;

--changing data types of the fields
ALTER TABLE movie_copy
ALTER COLUMN rating TYPE DECIMAL(2,1) 
USING rating::numeric(2,1);


ALTER TABLE movie_copy
ALTER COLUMN runtime TYPE 
USING runtime::integer;

ALTER TABLE movie_copy
ALTER COLUMN votes TYPE INT
USING votes::integer;


ALTER TABLE movie_copy
ALTER COLUMN year_released TYPE DATE 
USING TO_date(year_released, 'YYYY');


SELECT * FROM movie_copy ;