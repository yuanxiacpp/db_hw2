/*
student(student_id, name)
books(isbn, title, author, publisher) 
loan(student_id, isbn, issue_date, due_date)
*/

--1. For each author, names of students who borrowed more than three books by that author. (3)
select count(t2.name) as readers_per_auther, t3.author
from loan t1
join student t2 on t1.student_id = t2.student_id
join books t3 on t3.isbn = t1.isbn
where readers_per_author > 3
group by t3.author
--2. Names of students who borrowed all books written by ‘Avi Silberschatz’. (5)

--3. Names of students who borrowed books written by anyone with the last name “Sade” (assume that names are stored as ‘first middle last’). (2)
select student.name
from student, books, loan
where student.student_id = loan.student_id and
      loan.isbn = books.isbn and
      books.author like '%Sade'
