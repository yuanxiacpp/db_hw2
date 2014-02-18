/*
student(student_id, name)
books(isbn, title, author, publisher) 
loan(student_id, isbn, issue_date, due_date)
*/

--1. For each author, names of students who borrowed more than three books by that author. (3)
select T.author, T.name
from (
      select count(S.name) as readers_count, B.author, S.name
      from loan as L
      inner join student as S on S.student_id = L.student_id
      inner join books as B on B.isbn = L.isbn
      group by B.author, S.name
     ) as T
where T.readers_count > 3;


--2. Names of students who borrowed all books written by ‘Avi Silberschatz’. (5)
select S.name
from student as S
where not exists (
	  	  (select isbn from books as B where author = 'Avi Silberschatz')
		  except
		  (select L.isbn from loan as L where L.student_id = S.student_id)
      	  	 );


--3. Names of students who borrowed books written by anyone with the last name “Sade” (assume that names are stored as ‘first middle last’). (2)
select distinct S.name
from student as S
inner join loan as L on L.student_id = S.student_id
inner join books as B on B.isbn = L.isbn
where B.author like '%Sade';
