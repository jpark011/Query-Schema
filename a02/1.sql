select s.snum, s.sname
from student s join (
    select m1.snum
    from mark m1 join mark m2 on m1.snum = m2.snum
    where 90 < m1.grade 
        and 90 < m2.grade
        and ( m1.deptcode <> m2.deptcode or m1.cnum <> m2.cnum )
) on s.snum = m1.snum
where 2 <= s.year