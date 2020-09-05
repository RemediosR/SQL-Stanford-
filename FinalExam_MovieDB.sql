/* Find the titles of all movies directed by Steven Spielberg. */
SELECT title FROM MOVIE
WHERE director = 'Steven Spielberg';

/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order */
SELECT DISTINCT year
FROM Movie
INNER JOIN Rating
ON Movie.mid = Rating.mid
WHERE stars BETWEEN 4 AND 5
ORDER BY year ASC;

/* Find the titles of all movies that have no ratings. */
SELECT title
FROM Movie
LEFT OUTER JOIN Rating
ON Movie.mid = Rating.mid
WHERE stars IS NULL;

/* Some reviewers didn't provide a date with their rating. 
Find the names of all reviewers who have ratings with a NULL value for the date. */
SELECT name
FROM reviewer
LEFT OUTER JOIN rating
ON reviewer.rid = rating.rid
WHERE ratingdate IS NULL;

/* Write a query to return the ratings data in a more readable format: 
reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT reviewer.name, movie.title, rating.stars, rating.ratingdate
FROM movie, rating, reviewer
WHERE movie.mid = rating.mid AND rating.rid = reviewer.rid
ORDER BY reviewer.name, movie.title, rating.stars;

/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie. */
SELECT r.name, m.title
FROM movie m, reviewer r,
  (
    SELECT r1.rid, r1.mid
    FROM rating r1, rating r2
    WHERE r1.rid = r2.rid AND r1.mid = r2.mid
    AND r1.stars > r2.stars
    AND r1.ratingdate > r2.ratingdate
  ) AS a
WHERE m.mid = a.mid AND r.rid = a.rid;

/* For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie
-- title and number of stars. Sort by movie title. */
SELECT m.title, r.max_stars
FROM movie AS m,
  (
    SELECT mid, MAX(stars) AS max_stars
    FROM rating
    GROUP BY mid
    HAVING MAX(stars) > 0
  ) AS r
WHERE m.mid = r.mid
ORDER BY m.title ASC;

/* For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings
-- given to that movie. Sort by rating spread from highest to lowest, then by movie title. */
SELECT m.title, r.rating_spread
FROM movie AS m,
  (
    SELECT mid, MAX(stars)-MIN(stars) rating_spread
    FROM rating
    GROUP BY mid
  ) AS r
WHERE m.mid = r.mid
ORDER BY r.rating_spread DESC, m.title;

/* Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */
SELECT AVG(early_avgs.avgs) - AVG(later_avgs.avgs)
FROM
  (
    SELECT AVG(r.stars) AS avgs
    FROM rating AS r,
      (
        SELECT m.mid
        FROM movie AS m
        WHERE m.year < 1980
      ) AS m1
    WHERE m1.mid = r.mid
    GROUP BY m1.mid
  ) AS early_avgs,
  (
    SELECT AVG(r.stars) AS avgs
  	FROM rating AS r,
      (
        SELECT m.mid
        FROM movie AS m
        WHERE m.year >= 1980
      ) AS m1
    WHERE m1.mid = r.mid
    GROUP BY m1.mid
  ) AS later_avgs;


  /* Find the names of all reviewers who rated Gone with the Wind. */
  Select distinct Reviewer.name
from Movie, Reviewer, Rating
where Movie.mID=Rating.mID
and Reviewer.rID=Rating.rID
and title='Gone with the Wind';

/* For any rating where the reviewer is the same as the director of the movie,
 return the reviewer name, movie title, and number of stars.*/
select Reviewer.name, Movie.title, Rating.stars
from Movie, Reviewer, Rating
where Movie.mID=Rating.mID
and Reviewer.rID=Rating.rID
and Reviewer.name=Movie.director;

/* Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */
select name from Reviewer
union
select title from Movie
order by name

/* Find the titles of all movies not reviewed by Chris Jackson. */
select Movie.title
from Movie
where Movie.title not in (Select distinct Movie.title from Movie, Reviewer, Rating where Movie.mID=Rating.mID
and Rating.rID=Reviewer.rID
and Reviewer.name='Chris Jackson');

/* For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
For each pair, return the names in the pair in alphabetical order.*/
select distinct rv1.name as reviewer1, rv2.name as reviewer2
from Rating as rate1, Rating as rate2, Reviewer as rv1, Reviewer as rv2
where rate1.rID=rv1.rID
and rate2.rID=rv2.rID
and rate1.mID=rate2.mID
and rv1.name <> rv2.name
and rv1.name < rv2.name;

/* For each rating that is the lowest (fewest stars) currently in the database,
return the reviewer name, movie title, and number of stars. */
select Reviewer.name, Movie.title, Rating.stars
from Reviewer, Rating, Movie
where stars=(select min(stars) from Rating)
and Rating.rID=Reviewer.rID
and Rating.mID=Movie.mID;


/* List movie titles and average ratings, from highest-rated to lowest-rated. 
If two or more movies have the same average rating, list them in alphabetical order.*/
select Movie.title, avg(Rating.stars) as avg1
from Movie, Rating
where Movie.mID=Rating.mID
group by Movie.title
order by avg1 desc, Movie.title;

/* Find the names of all reviewers who have contributed three or more ratings. 
(As an extra challenge, try writing the query without HAVING or without COUNT.)*/
select Reviewer.name
from Reviewer, Rating
where Reviewer.rID=Rating.rID
group by Reviewer.name
having count(Reviewer.name) >=3;

/* Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. 
Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)*/
select title, director
from Movie
where director in(select director from movie
group by director
having count (director) > 1)
order by director, title;

/* Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
(Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)*/
select title, avg(stars)
from Movie, Rating
where Movie.mID=Rating.mID
group by title
having avg(stars)=(select max(AvgC.avgs)
from (select mID, avg(stars) as avgs from Rating group by mID) as AvgC)
order by title desc;

/* Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
(Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)*/
select title, avg(stars)
from Movie, Rating
where Movie.mID=Rating.mID
group by title
having avg(stars)=(select min(AvgC.avgs)
from (select mID, avg(stars) as avgs from Rating group by mID) as AvgC)
order by title desc;

/* For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. 
Ignore movies whose director is NULL.*/
select distinct M1.director, M1.title, R1.stars
from Movie M1, Rating R1
where M1.mID=R1.mID
and M1.director is not null
and R1.stars in 
(select max(R2.stars) 
from Movie M2, Rating R2
where M2.mID=R2.mID
and M2.director is not null
and M2.director=M1.director);

/* Add the reviewer Roger Ebert to your database, with an rID of 209.*/
insert into Reviewer(rID,name) values(209, 'Roger Ebert');

/* Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. */
insert into Rating(rID,stars,mID) select(select rID from reviewer where name='James Cameron'),5,mID from Movie

/* For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)*/
update Movie 
set year=year+25
where Movie.ID in (select X.mID from(select Movie.mID, avg(stars) from Movie, Rating where Movie.mID=Rating.mID group by Movie.mID having avg(stars)>=4) as X);

/* Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. */
delete from Rating
where Rating.mID in(select Movie.mID from Movie where year<1970 or year>2000)
and stars<4;







