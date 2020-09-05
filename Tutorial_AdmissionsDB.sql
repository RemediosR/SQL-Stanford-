/* Let's start from the beginning */
.mode columns
.headers on
.nullvalue NULL

drop table if exists T;
create table T (A text, B text);
insert into T values ('Hello,', 'world!');
select * from T;

/* Solutions to the College Admissions questions */
/* Create the table */
create table College(cName text, state text, enrollment int);
create table Student(sID int, sName text, GPA real, sizeHS int);
create table Apply(sID int, cName text, major text, decision text);

delete from Student;
delete from College;
delete from Apply;

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (345, 'Craig', 3.5, 500);
insert into Student values (456, 'Doris', 3.9, 1000);
insert into Student values (567, 'Edward', 2.9, 2000);
insert into Student values (678, 'Fay', 3.8, 200);
insert into Student values (789, 'Gary', 3.4, 800);
insert into Student values (987, 'Helen', 3.7, 800);
insert into Student values (876, 'Irene', 3.9, 400);
insert into Student values (765, 'Jay', 2.9, 1500);
insert into Student values (654, 'Amy', 3.9, 1000);
insert into Student values (543, 'Craig', 3.4, 2000);

insert into College values ('Stanford', 'CA', 15000);
insert into College values ('Berkeley', 'CA', 36000);
insert into College values ('MIT', 'MA', 10000);
insert into College values ('Cornell', 'NY', 21000);

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (123, 'Stanford', 'EE', 'N');
insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (123, 'Cornell', 'EE', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');
insert into Apply values (345, 'MIT', 'bioengineering', 'Y');
insert into Apply values (345, 'Cornell', 'bioengineering', 'N');
insert into Apply values (345, 'Cornell', 'CS', 'Y');
insert into Apply values (345, 'Cornell', 'EE', 'N');
insert into Apply values (678, 'Stanford', 'history', 'Y');
insert into Apply values (987, 'Stanford', 'CS', 'Y');
insert into Apply values (987, 'Berkeley', 'CS', 'Y');
insert into Apply values (876, 'Stanford', 'CS', 'N');
insert into Apply values (876, 'MIT', 'biology', 'Y');
insert into Apply values (876, 'MIT', 'marine biology', 'N');
insert into Apply values (765, 'Stanford', 'history', 'Y');
insert into Apply values (765, 'Cornell', 'history', 'N');
insert into Apply values (765, 'Cornell', 'psychology', 'Y');
insert into Apply values (543, 'MIT', 'CS', 'N');

/* start with SELECT */
select sID, sName, GPA
from Student
where GPA > 3.6;

/* Same query without GPA */
select sID, sName
from Student
where GPA > 3.6;

select sName, major
from Student, Apply
where Student.sID = Apply.sID;

/*** Same query with Distinct, note difference from algebra ***/
select distinct sName, major
from Student, Apply
where Student.sID = Apply.sID;


/*  Names and GPAs of students with sizeHS < 1000 applying */
select sname, GPA, decision
from Student, Apply
where Student.sID = Apply.sID
  and sizeHS < 1000 and major = 'CS' and cname = 'Stanford';

/*  All large campuses with CS applicants */
select cName
from College, Apply
where College.cName = Apply.cName
  and enrollment > 20000 and major = 'CS';

/* Fix error */

select College.cName
from College, Apply
where College.cName = Apply.cName
  and enrollment > 20000 and major = 'CS';

/* Add Distinct */
select distinct College.cName
from College, Apply
where College.cName = Apply.cName
  and enrollment > 20000 and major = 'CS';

/*  Application information */
select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName;

/* Sort by decreasing GPA */
select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName
order by GPA desc;

/* Then by increasing enrollment */
select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName
order by GPA desc, enrollment;


/* Applicants to bio majors */
select sID, major
from Apply
where major like '%bio%';

/* Same query with Select */
select *
from Apply
where major like '%bio%';


/*  Select * cross-product */
select *
from Student, College;

/* Add scaled GPA based on sizeHS */
select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0)
from Student;

/* Rename result attribute */
select sID, sName, GPA, sizeHS, GPA*(sizeHS/1000.0) as scaledGPA
from Student;


/*  TABLE VARIABLES AND SET OPERATORS */

/*  Application information */
select Student.sID, sName, GPA, Apply.cName, enrollment
from Student, College, Apply
where Apply.sID = Student.sID and Apply.cName = College.cName;

/* Introduce table variables */
select S.sID, S.sName, S.GPA, A.cName, C.enrollment
from Student S, College C, Apply A
where A.sID = S.sID and A.cName = C.cName;

/* Pairs of students with same GPA */
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA;

/* Get rid of self-pairings */
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID <> S2.sID;

/* Get rid of reverse-pairings */
select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;

/* List of college names and student names */
select cName from College
union
select sName from Student;

/* Add 'As name' to both sides */
select cName as name from College
union
select sName as name from Student;

/* Change to Union All */
select cName as name from College
union all
select sName as name from Student;

/* Some not sorted any more, add order by cName */
select cName as name from College
union all
select sName as name from Student
order by name;

/* IDs of students who applied to both CS and EE */
select sID from Apply where major = 'CS'
intersect
select sID from Apply where major = 'EE';

/* IDs of students who applied to both CS and EE */
select A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';

/* Why so many duplicates? Look at Apply table: Add Distinct */
select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major = 'EE';

/* IDs of students who applied to CS but not EE */
select sID from Apply where major = 'CS'
except
select sID from Apply where major = 'EE';

/* IDs of students who applied to CS but not EE */
select A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';

/* Add Distinct */
select distinct A1.sID
from Apply A1, Apply A2
where A1.sID = A2.sID and A1.major = 'CS' and A2.major <> 'EE';

/*  SUBQUERIES IN THE WHERE CLAUSE  */
/*  IDs and names of students applying to CS */
select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS');

/* Same query written without 'In' */
select sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/* to Fix error */
select Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/* Remove duplicates */
select distinct Student.sID, sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/* Just names of students applying to CS */
select sName
from Student
where sID in (select sID from Apply where major = 'CS');

/* Same query written without 'In' */
select sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/* Remove duplicates (still incorrect) */
select distinct sName
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Duplicates are important: average GPA of CS applicants
**************************************************************/

select GPA
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Alternative (incorrect) queries without 'In'
**************************************************************/

select GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

select distinct GPA
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/**************************************************************
  Students who applied to CS but not EE
  (query we used 'Except' for earlier)
**************************************************************/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and sID not in (select sID from Apply where major = 'EE');

/*** Change to 'not sID in' ***/

select sID, sName
from Student
where sID in (select sID from Apply where major = 'CS')
  and not sID in (select sID from Apply where major = 'EE');

/**************************************************************
  Colleges such that some other college is in the same state
**************************************************************/

select cName, state
from College C1
where exists (select * from College C2
              where C2.state = C1.state);

/*** Fix error ***/

select cName, state
from College C1
where exists (select * from College C2
              where C2.state = C1.state and C2.cName <> C1.cName);

/**************************************************************
  Biggest college
**************************************************************/

select cName
from College C1
where not exists (select * from College C2
                  where C2.enrollment > C1.enrollment);

/*** Similar: student with highest GPA  ***/

select sName
from Student C1
where not exists (select * from Student C2
                  where C2.GPA > C1.GPA);

/*** Add GPA ***/

select sName, GPA
from Student C1
where not exists (select * from Student C2
                  where C2.GPA > C1.GPA);

/**************************************************************
  Highest GPA with no subquery
**************************************************************/

select S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;

/*** Remove duplicates (still incorrect) ***/

select distinct S1.sName, S1.GPA
from Student S1, Student S2
where S1.GPA > S2.GPA;

/**************************************************************
  Highest GPA using ">= all"
**************************************************************/

select sName, GPA
from Student
where GPA >= all (select GPA from Student);

/**************************************************************
  Higher GPA than all other students
**************************************************************/

select sName, GPA
from Student S1
where GPA > all (select GPA from Student S2
                 where S2.sID <> S1.sID);

/*** Similar: higher enrollment than all other colleges  ***/

select cName
from College S1
where enrollment > all (select enrollment from College S2
                        where S2.cName <> S1.cName);

/*** Same query using 'Not <= Any' ***/

select cName
from College S1
where not enrollment <= any (select enrollment from College S2
                             where S2.cName <> S1.cName);

/**************************************************************
  Students not from the smallest HS
**************************************************************/

select sID, sName, sizeHS
from Student
where sizeHS > any (select sizeHS from Student);

/**************************************************************
  Students not from the smallest HS
  Some systems don't support Any/All
**************************************************************/

select sID, sName, sizeHS
from Student S1
where exists (select * from Student S2
              where S2.sizeHS < S1.sizeHS);

/**************************************************************
  Students who applied to CS but not EE
**************************************************************/

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
  and sID <> any (select sID from Apply where major = 'EE');

/*** Subtle error, fix ***/

select sID, sName
from Student
where sID = any (select sID from Apply where major = 'CS')
  and not sID = any (select sID from Apply where major = 'EE');


/**************************************************************
  SUBQUERIES IN THE FROM AND SELECT CLAUSES
  Works for MySQL and Postgres
  SQLite doesn't support All
**************************************************************/

/**************************************************************
  Students whose scaled GPA changes GPA by more than 1
**************************************************************/

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where GPA*(sizeHS/1000.0) - GPA > 1.0
   or GPA - GPA*(sizeHS/1000.0) > 1.0;

/*** Can simplify using absolute value function ***/

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where abs(GPA*(sizeHS/1000.0) - GPA) > 1.0;

/*** Can further simplify using subquery in From ***/

select *
from (select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
      from Student) G
where abs(scaledGPA - GPA) > 1.0;

/**************************************************************
  Colleges paired with the highest GPA of their applicants
**************************************************************/

select College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);

/*** Add Distinct to remove duplicates ***/

select distinct College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);

/*** Use subquery in Select ***/

select distinct cName, state,
  (select distinct GPA
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID
     and GPA >= all
           (select GPA from Student, Apply
            where Student.sID = Apply.sID
              and Apply.cName = College.cName)) as GPA
from College;

/*** Now pair colleges with names of their applicants
    (doesn't work due to multiple rows in subquery result) ***/

select distinct cName, state,
  (select distinct sName
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID) as sName
from College;


/**************************************************************
  JOIN OPERATORS
  Works for Postgres
  MySQL doesn't support FULL OUTER JOIN
  SQLite doesn't support RIGHT or FULL OUTER JOIN
**************************************************************/

/**************************************************************
  INNER JOIN
  Student names and majors for which they've applied
**************************************************************/

select distinct sName, major
from Student, Apply
where Student.sID = Apply.sID;

/*** Rewrite using INNER JOIN ***/

select distinct sName, major
from Student inner join Apply
on Student.sID = Apply.sID;

/*** Abbreviation is JOIN ***/

select distinct sName, major
from Student join Apply
on Student.sID = Apply.sID;

/**************************************************************
  INNER JOIN WITH ADDITIONAL CONDITIONS
  Names and GPAs of students with sizeHS < 1000 applying to
  CS at Stanford
**************************************************************/

select sName, GPA
from Student, Apply
where Student.sID = Apply.sID
  and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** Rewrite using JOIN ***/

select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** Can move everything into JOIN ON condition ***/

select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
and sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/**************************************************************
  THREE-WAY INNER JOIN
  Application info: ID, name, GPA, college name, enrollment
**************************************************************/

select Apply.sID, sName, GPA, Apply.cName, enrollment
from Apply, Student, College
where Apply.sID = Student.sID and Apply.cName = College.cName;

/*** Rewrite using three-way JOIN ***/
/*** Works in SQLite and MySQL but not Postgres ***/

select Apply.sID, sName, GPA, Apply.cName, enrollment
from Apply join Student join College
on Apply.sID = Student.sID and Apply.cName = College.cName;

/*** Rewrite using binary JOIN ***/

select Apply.sID, sName, GPA, Apply.cName, enrollment
from (Apply join Student on Apply.sID = Student.sID) join College on Apply.cName = College.cName;

/**************************************************************
  NATURAL JOIN
  Student names and majors for which they've applied
**************************************************************/

select distinct sName, major
from Student inner join Apply
on Student.sID = Apply.sID;

/*** Rewrite using NATURAL JOIN ***/

select distinct sName, major
from Student natural join Apply;

/*** Like relational algebra, eliminates duplicate columns ***/

select *
from Student natural join Apply;

select distinct sID
from Student natural join Apply;

/*** Would get ambiguity error with cross-product ***/

select distinct sID
from Student, Apply;

/**************************************************************
  NATURAL JOIN WITH ADDITIONAL CONDITIONS
  Names and GPAs of students with sizeHS < 1000 applying to
  CS at Stanford
**************************************************************/

select sName, GPA
from Student join Apply
on Student.sID = Apply.sID
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** Rewrite using NATURAL JOIN ***/

select sName, GPA
from Student natural join Apply
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/*** USING clause considered safer ***/

select sName, GPA
from Student join Apply using(sID)
where sizeHS < 1000 and major = 'CS' and cName = 'Stanford';

/**************************************************************
  SELF-JOIN
  Pairs of students with same GPA
**************************************************************/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1, Student S2
where S1.GPA = S2.GPA and S1.sID < S2.sID;

/*** Rewrite using JOIN and USING (disallowed) ***/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1 join Student S2 on S1.sID < S2.sID using(GPA);

/*** Without ON clause ***/

select S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA
from Student S1 join Student S2 using(GPA)
where S1.sID < S2.sID;

/**************************************************************
  SELF NATURAL JOIN
**************************************************************/

select *
from Student S1 natural join Student S2;

/*** Verify equivalence to Student ***/

select * from Student;

/**************************************************************
  LEFT OUTER JOIN
  Student application info: name, ID, college name, major
**************************************************************/

select sName, sID, cName, major
from Student inner join Apply using(sID);

/*** Include students who haven't applied anywhere ***/

select sName, sID, cName, major
from Student left outer join Apply using(sID);

/*** Abbreviation is LEFT JOIN ***/

select sName, sID, cName, major
from Student left join Apply using(sID);

/*** Using NATURAL OUTER JOIN ***/

select sName, sID, cName, major
from Student natural left outer join Apply;

/*** Can simulate without any JOIN operators ***/

select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from Student
where sID not in (select sID from Apply);

/*** Instead include applications without matching students ***/

insert into Apply values (321, 'MIT', 'history', 'N');
insert into Apply values (321, 'MIT', 'psychology', 'Y');

select sName, sID, cName, major
from Apply natural left outer join Student;

/**************************************************************
  RIGHT OUTER JOIN
  Student application info: name, ID, college name, major
**************************************************************/

/*** Include applications without matching students ***/

select sName, sID, cName, major
from Student natural right outer join Apply;

/**************************************************************
  FULL OUTER JOIN
  Student application info
**************************************************************/

/*** Include students who haven't applied anywhere ***/
/*** and applications without matching students ***/

select sName, sID, cName, major
from Student full outer join Apply using(sID);

/*** Can simulate with LEFT and RIGHT outerjoins ***/
/*** Note UNION eliminates duplicates ***/

select sName, sID, cName, major
from Student left outer join Apply using(sID)
union
select sName, sID, cName, major
from Student right outer join Apply using(sID);

/*** Can simulate without any JOIN operators ***/

select sName, Student.sID, cName, major
from Student, Apply
where Student.sID = Apply.sID
union
select sName, sID, NULL, NULL
from Student
where sID not in (select sID from Apply)
union
select NULL, sID, cName, major
from Apply
where sID not in (select sID from Student);

/**************************************************************
  THREE-WAY OUTER JOIN
  Not associative
**************************************************************/

create table T1 (A int, B int);
create table T2 (B int, C int);
create table T3 (A int, C int);
insert into T1 values (1,2);
insert into T2 values (2,3);
insert into T3 values (4,5);

select A,B,C
from (T1 natural full outer join T2) natural full outer join T3;

select A,B,C
from T1 natural full outer join (T2 natural full outer join T3);

drop table T1;
drop table T2;
drop table T3;


/**************************************************************
  AGGREGATION
  Works for SQLite, MySQL
  Postgres doesn't allow ambiguous Select columns in Group-by queries
**************************************************************/

/**************************************************************
  Average GPA of all students
**************************************************************/

select avg(GPA)
from Student;

/**************************************************************
  Lowest GPA of students applying to CS
**************************************************************/

select min(GPA)
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Average GPA of students applying to CS ***/

select avg(GPA)
from Student, Apply
where Student.sID = Apply.sID and major = 'CS';

/*** Fix incorrect counting of GPAs ***/

select avg(GPA)
from Student
where sID in (select sID from Apply where major = 'CS');

/**************************************************************
  Number of colleges bigger than 15,000
**************************************************************/

select count(*)
from College
where enrollment > 15000;

/**************************************************************
  Number of students applying to Cornell
**************************************************************/

select count(*)
from Apply
where cName = 'Cornell';

/*** Show why incorrect result, fix using Count Distinct ***/

select *
from Apply
where cName = 'Cornell';

select Count(Distinct sID)
from Apply
where cName = 'Cornell';

/**************************************************************
  Students such that number of other students with same GPA is
  equal to number of other students with same sizeHS
**************************************************************/
select *
from Student S1
where (select count(*) from Student S2
       where S2.sID <> S1.sID and S2.GPA = S1.GPA) =
      (select count(*) from Student S2
       where S2.sID <> S1.sID and S2.sizeHS = S1.sizeHS);

/* Amount by which average GPA of students applying to CS
  exceeds average of students not applying to CS */
select CS.avgGPA - NonCS.avgGPA
from (select avg(GPA) as avgGPA from Student
      where sID in (
         select sID from Apply where major = 'CS')) as CS,
     (select avg(GPA) as avgGPA from Student
      where sID not in (
         select sID from Apply where major = 'CS')) as NonCS;

/*** Same using subqueries in Select ***/
select (select avg(GPA) as avgGPA from Student
        where sID in (
           select sID from Apply where major = 'CS')) -
       (select avg(GPA) as avgGPA from Student
        where sID not in (
           select sID from Apply where major = 'CS')) as d
from Student;

/*** Remove duplicates ***/
select distinct (select avg(GPA) as avgGPA from Student
        where sID in (
           select sID from Apply where major = 'CS')) -
       (select avg(GPA) as avgGPA from Student
        where sID not in (
           select sID from Apply where major = 'CS')) as d
from Student;

/* Number of applications to each college */
select cName, count(*)
from Apply
group by cName;

/*** First do query to picture grouping ***/
select *
from Apply
order by cName;

/*** Now back to query we want ***/
select cName, count(*)
from Apply
group by cName;

/* College enrollments by state */
select state, sum(enrollment)
from College
group by state;

/* Minimum + maximum GPAs of applicants to each college & major */
select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

/*** First do query to picture grouping ***/
select cName, major, GPA
from Student, Apply
where Student.sID = Apply.sID
order by cName, major;

/*** Now back to query we want ***/
select cName, major, min(GPA), max(GPA)
from Student, Apply
where Student.sID = Apply.sID
group by cName, major;

/*** Widest spread ***/
select max(mx-mn)
from (select cName, major, min(GPA) as mn, max(GPA) as mx
      from Student, Apply
      where Student.sID = Apply.sID
      group by cName, major) M;

/*  Number of colleges applied to by each student */
select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** First do query to picture grouping ***/
select Student.sID, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

/*** Now back to query we want ***/
select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Add student name ***/
select Student.sID, sName, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** First do query to picture grouping ***/
select Student.sID, sName, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

/*** Now back to query we want ***/
select Student.sID, sName, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Add college (shouldn't work but does in some systems) ***/
select Student.sID, sName, count(distinct cName), cName
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Back to query to picture grouping ***/
select Student.sID, sName, cName
from Student, Apply
where Student.sID = Apply.sID
order by Student.sID;

/* Number of colleges applied to by each student, including
  0 for those who applied nowhere */
select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID;

/*** Now add 0 counts ***/
select Student.sID, count(distinct cName)
from Student, Apply
where Student.sID = Apply.sID
group by Student.sID
union
select sID, 0
from Student
where sID not in (select sID from Apply);

/* Colleges with fewer than 5 applications */
select cName
from Apply
group by cName
having count(*) < 5;

/*** Same query without Group-by or Having ***/
select cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

/*** Remove duplicates ***/
select distinct cName
from Apply A1
where 5 > (select count(*) from Apply A2 where A2.cName = A1.cName);

/*** Back to original Group-by form, fewer than 5 applicants ***/
select cName
from Apply
group by cName
having count(distinct sID) < 5;

/*  Majors whose applicant's maximum GPA is below the average */
select major
from Student, Apply
where Student.sID = Apply.sID
group by major
having max(GPA) < (select avg(GPA) from Student);


/* NULL Values */
insert into Student values (432, 'Kevin', null, 1500);
insert into Student values (321, 'Lori', null, 2500);

select * from Student;

/* All students with high GPA */
select sID, sName, GPA
from Student
where GPA > 3.5;

/*** Now low GPA ***/
select sID, sName, GPA
from Student
where GPA <= 3.5;

/*** Now either high or low GPA ***/
select sID, sName, GPA
from Student
where GPA > 3.5 or GPA <= 3.5;

/*** Now all students ***/
select sID, sName from Student;

/*** Now use 'is null' ***/
select sID, sName, GPA
from Student
where GPA > 3.5 or GPA <= 3.5 or GPA is null;

/* All students with high GPA or small HS */
select sID, sName, GPA, sizeHS
from Student
where GPA > 3.5 or sizeHS < 1600;

/*** Add large HS ***/
select sID, sName, GPA, sizeHS
from Student
where GPA > 3.5 or sizeHS < 1600 or sizeHS >= 1600;

/*  Number of students with non-null GPAs */
select count(*)
from Student
where GPA is not null;

/*** Number of distinct GPA values among them ***/
select count(distinct GPA)
from Student
where GPA is not null;

/*** Drop non-null condition ***/
select count(distinct GPA)
from Student;

/*** Drop count ***/
select distinct GPA
from Student;

/**************************************************************
  INSERT, DELETE, AND UPDATE STATEMENTS 
**************************************************************/

/*  Insert new college */
insert into College values ('Carnegie Mellon', 'PA', 11500);

/*  Have all students who didn't apply anywhere apply to
  CS at CMU */

/*** First see who will be inserted ***/
select *
from Student
where sID not in (select sID from Apply);

/*** Then insert them ***/
insert into Apply
  select sID, 'Carnegie Mellon', 'CS', null
  from Student
  where sID not in (select sID from Apply);

/*** Admit to Carnegie Mellon EE all students who were turned down
     in EE elsewhere ***/

/* First see who will be inserted */
select *
from Student
where sID in (select sID from Apply
              where major = 'EE' and decision = 'N');

/* Then insert them */
insert into Apply
  select sID, 'Carnegie Mellon', 'EE', 'Y'
  from Student
  where sID in (select sID from Apply
                where major = 'EE' and decision = 'N');

/*  Delete all students who applied to more than two different
  majors */

/*** First see who will be deleted ***/
select sID, count(distinct major)
from Apply
group by sID
having count(distinct major) > 2;

/*** Then delete them ***/
delete from Student
where sID in
  (select sID
   from Apply
   group by sID
   having count(distinct major) > 2);

/*** Delete same ones from Apply ***/
delete from Apply
where sID in
  (select sID
   from Apply
   group by sID
   having count(distinct major) > 2);

/*  Delete colleges with no CS applicants */

/* First see who will be deleted */
select * from College
where cName not in (select cName from Apply where major = 'CS');

/* Then delete them */
delete from College
where cName not in (select cName from Apply where major = 'CS');

/*  Accept applicants to Carnegie Mellon with GPA < 3.6 but turn
  them into economics majors */
/*** First see who will be updated ***/
select * from Apply
where cName = 'Carnegie Mellon'
  and sID in (select sID from Student where GPA < 3.6);

/* Then update them */
update Apply
set decision = 'Y', major = 'economics'
where cName = 'Carnegie Mellon'
  and sID in (select sID from Student where GPA < 3.6);

/*  Turn the highest-GPA EE applicant into a CSE applicant */
/* Validate who will be updated */
select * from Apply
where major = 'EE'
  and sID in
    (select sID from Student
     where GPA >= all
        (select GPA from Student
         where sID in (select sID from Apply where major = 'EE')));

/*update them */
update Apply
set major = 'CSE'
where major = 'EE'
  and sID in
    (select sID from Student
     where GPA >= all
        (select GPA from Student
         where sID in (select sID from Apply where major = 'EE')));

/* Give everyone the highest GPA and smallest HS */
update Student
set GPA = (select max(GPA) from Student),
    sizeHS = (select min(sizeHS) from Student);

/* Accept everyone */
update Apply
set decision = 'Y';

