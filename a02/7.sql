select term, count(s.snum) numStudents 
from student s 
    join enrollment e 
        on s.snum = e.snum
    join class c
        on e.deptcode = c.deptcode
            and e.cnum = c.cnum
            and e.term = c.term 
            and e.section = c.section
    join professor p
        on c.pnum = p.pnum
where ( p.deptcode <> "CS" or p.deptcode <> "AM" )
group by term
order by numStudents desc
