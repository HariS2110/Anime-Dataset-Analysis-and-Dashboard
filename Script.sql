-- View the anime table
SELECT * FROM anime; 
-- View the rating table
SELECT * FROM rating;

-- View how many animes we will be exploring
SELECT COUNT(anime_id) FROM anime;

-- View the different types of anime
SELECT 
	type, 
	count(type) as animetype_count
FROM 
	anime
GROUP BY 
	type
ORDER BY 
	animetype_count DESC;

-- View statistics on ratings
SELECT 
  AVG(rating) as average_rating,
  MIN(rating) as min_rating,
  MAX(rating) as max_rating,
  COUNT(*) as total_ratings
FROM anime
  WHERE
  	rating <> '';

-- View the different genres and genre count
SELECT 
    TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1)) AS single_genre,
    COUNT(*) AS genre_count
FROM
    anime
WHERE
    genre <> '' 
GROUP BY
    single_genre
ORDER BY 
    genre_count DESC;
   
-- View the most popular anime
 SELECT
 	name,
 	MAX(members)
 FROM anime;

-- View the highest rated anime
 SELECT 
 	name,
 	MAX(rating),
 	type
 FROM anime
WHERE
    rating <> '';
   
-- View how many users have seen atleast 50 anime
 SELECT
 	user_id,
 	COUNT(name) as total_watched,
 	TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1)) AS single_genre
 FROM anime
 INNER JOIN rating
 	ON anime.anime_id=rating.anime_id
 	GROUP BY user_id
 	HAVING total_watched >=50
 	ORDER BY user_id ASC;

 -- View what genres each noobie user has watched
 SELECT
    user_id,
    COUNT(name) AS total_watched,
    GROUP_CONCAT(DISTINCT TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1))) AS watched_genres
FROM
    anime
INNER JOIN rating ON anime.anime_id = rating.anime_id
GROUP BY user_id
HAVING total_watched < 50
ORDER BY user_id ASC;


-- View the noobies most watched genres
SELECT
    genre,
    COUNT(*) AS genre_count
FROM (
    SELECT
        user_id,
        COUNT(name) AS total_watched,
        GROUP_CONCAT(DISTINCT TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1))) AS watched_genres
    FROM
        anime
    INNER JOIN rating ON anime.anime_id = rating.anime_id
    GROUP BY user_id
    HAVING total_watched < 50
) AS noobie_genres
CROSS JOIN (
    SELECT DISTINCT TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1)) AS genre FROM anime
) AS all_genres
WHERE watched_genres LIKE '%' || all_genres.genre || '%'
GROUP BY genre
ORDER BY genre;

 -- View what genres each veteran user has watched
 SELECT
    user_id,
    COUNT(name) AS total_watched,
    GROUP_CONCAT(DISTINCT TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1))) AS watched_genres
FROM
    anime
INNER JOIN rating ON anime.anime_id = rating.anime_id
GROUP BY user_id
HAVING total_watched >= 50
ORDER BY user_id ASC;

-- View the veterans most watched genres
SELECT
    genre,
    COUNT(*) AS genre_count
FROM (
    SELECT
        user_id,
        COUNT(name) AS total_watched,
        GROUP_CONCAT(DISTINCT TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1))) AS watched_genres
    FROM
        anime
    INNER JOIN rating ON anime.anime_id = rating.anime_id
    GROUP BY user_id
    HAVING total_watched >=50
) AS noobie_genres
CROSS JOIN (
    SELECT DISTINCT TRIM(SUBSTR(genre, 1, INSTR(genre || ',', ',') - 1)) AS genre FROM anime
) AS all_genres
WHERE watched_genres LIKE '%' || all_genres.genre || '%'
GROUP BY genre
ORDER BY genre;