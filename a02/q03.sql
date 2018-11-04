select s.snum, s.sname, s.year
from student s join mark m on s.snum = m.snum
where m.grade + 3 <= some (
    select m.grade
    from mark m
    where m.deptcode = "CS"
        and m.cnum = 240
        and m.grade >= all (
            select m2.grade
            from mark m2
            where m2.deptcode = m.deptcode
                and m2.cnum = m.cnum
        ) 
)
