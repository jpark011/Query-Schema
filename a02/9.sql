select s.snum, s.sname, 
    avg( m.grade ) as avgCS, 
    avg( select m.grade from mark m join student s where m.snum = s.snum  ) as avgAll, 
    count( m.snum ) * 100 / count( select s.snum from student s join mark m on s.snum = m.snum ) as percentage  
from student s 
    join mark m 
    on m.snum = s.snum
        and m.deptcode = s.deptcode
        and m.cnum = s.cnum
        and m.term = s.term
        and m.section = s.section
where s.year = 4
    and m.deptcode = "CS"
group by s.snum, s.sname