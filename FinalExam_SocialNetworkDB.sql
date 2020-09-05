/* Find the names of all students who are friends with someone named Gabriel.*/
select Highschooler.name
from Highschooler, Highschooler H1, Friend
where Highschooler.ID=Friend.ID1
and H1.ID=Friend.ID2
and H1.name='Gabriel';

/* For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.*/
select Highschooler.name, Highschooler.grade, Fav.name, Fav.grade
from Highschooler, Highschooler Fav, Likes
where Highschooler.ID=Likes.ID1
and Likes.ID2=Fav.ID
and Highschooler.grade-Fav.grade>=2;

/* For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order.*/
select distinct Highschooler.name, Highschooler.grade, Fav.name, Fav.grade
from Highschooler, Highschooler Fav, Likes, Likes LikesBack
where Highschooler.ID=Likes.ID1
and Likes.ID2=Fav.ID
and(Fav.ID=LikesBack.ID1 and LikesBack.ID2=Highschooler.ID)
and LikesBack.ID2=Highschooler.ID
and Highschooler.name<fav.name;

/* Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
Sort by grade, then by name within each grade.*/
select distinct name, grade
from highschooler, likes
where ID not in (select ID1 from likes)
and ID not in (select ID2 from likes)
order by grade, name asc;

/* For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), 
return A and B's names and grades.*/
select distinct Highschooler.name, Highschooler.grade, Fav.name, Fav.grade
from Highschooler, Highschooler Fav, Likes
where Highschooler.ID=ID1
and Fav.ID=ID2
and Fav.ID not in(select ID1 from Likes);

/* Find names and grades of students who only have friends in the same grade. 
Return the result sorted by grade, then by name within each grade.*/
select distinct Highschooler.name, Highschooler.grade
from Highschooler, Highschooler Pal, Friend
where Highschooler.ID=ID1
and Pal.ID=ID2
and Highschooler.ID not in (select Highschooler.ID
from Highschooler, Highschooler Pal, Friend
where Highschooler.ID=ID1
and Pal.ID=ID2
and Highschooler.grade <> Pal.grade)
order by Highschooler.grade, Highschooler.name;

/* For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
For all such trios, return the name and grade of A, B, and C.*/
select distinct S1.name, S1.grade, S2.name, S2.grade, S3.name, S3.grade
from Highschooler S1, Highschooler S2, Highschooler S3, Friend, Likes
where S1.ID=Likes.ID1
and S2.ID=Likes.ID2
and S1.ID not in (select ID2 from Friend where ID1=S2.ID)
and S3.ID in (select ID2 from Friend where ID1=S1.ID)
and S3.ID in (select ID2 from Friend where ID1=S2.ID);

/* Find the difference between the number of students in the school and the number of different first names.*/
select count(*)
-(select count(distinct Copy.name) from Highschooler Copy) as difference
from Highschooler;

/* Find the name and grade of all students who are liked by more than one other student.*/
select distinct name, grade
from Highschooler, Likes
where (select count(ID1) from Likes where ID2=ID)>1;

/* For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.*/
select distinct S1.name, S1.grade, S2.name, S2.grade, S3.name, S3.grade
from Highschooler S1, Highschooler S2, Highschooler S3, Likes
where S1.ID=ID1
and S2.ID=ID2
and S3.ID in (select ID2 from Likes where ID1=S2.ID)
and S1.ID not in (select ID2 from Likes where ID1=S2.ID);

/* Find those students for whom all of their friends are in different grades from themselves. 
Return the students' names and grades.*/
select distinct name, grade
from Highschooler, Friend
where grade not in (select Copy.grade from Highschooler Copy, Friend where Highschooler.ID=ID1 and Copy.ID=ID2);

/* What is the average number of friends per student? (Your result should be just one number.)*/
select avg(X.Tally)
from (select ID, count(ID2) as Tally from Highschooler, Friend where ID=ID1 group by ID) as X;

/* Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
Do not count Cassandra, even though technically she is a friend of a friend.*/
select count(distinct F2.ID2)
from Friend F2
where F2.ID1=(select ID from Highschooler where name='Cassandra')
or F2.ID1 in (select ID2 from Friend where ID1=(select ID from Highschooler where name='Cassandra'))
and F2.ID2 <>(select ID from Highschooler where name='Cassandra');

/* Find the name and grade of the student(s) with the greatest number of friends.*/
select name, grade
from Highschooler, Friend
where ID=ID1
group by name, grade
having count(ID2)=(select max(X.Tally) from (select ID1, count(ID2) as Tally from Friend group by ID1) as X);

/* It's time for the seniors to graduate. Remove all 12th graders from Highschooler.*/
delete from Highschooler
where grade=12;

/* If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.*/
delete from Likes
where Likes.ID1 in(select Friend.ID2 from Friend where Friend.ID1=Likes.ID2)
and Likes.ID2 in(select Likes.ID2 from Likes LikeBack where LikeBack.ID1=Likes.ID1)
and Likes.ID1 not in (select LikeBack.ID2 from Likes Likeback where LikeBack.ID1=Likes.ID2);

/* For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 
(This one is a bit challenging; congratulations if you get it right.)*/
INSERT INTO friend (id1, id2)
SELECT DISTINCT f1.id1 AS id1, f3.id1 AS id2
FROM friend AS f1, friend AS f2, friend AS f3
WHERE f2.id1 IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = f1.id1
)
AND f2.id1 IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = f3.id1
)
AND f3.id1 NOT IN
(
    SELECT friend.id2
    FROM friend
    WHERE friend.id1 = f1.id1
)
AND f1.id1 != f3.id1;