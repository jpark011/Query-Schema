select count(e.snum) / count( select * from enrollment ) * 100 as percentage
from enrollment e 
    join class 
        on e.deptcode = c.deptcode 
            and e.cnum = c.cnum
            and e.term = c.term
            and e.section = c.section
    join professor p on c.pnum = p.pnum
where ( p.deptcode <> "CS" or p.deptcode <> "CO" )
order by e.term