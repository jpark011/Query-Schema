select p.pnum, p.pname 
from class c join professor p on c.pnum = p.pnum
where p.deptcode <> "PM"
    and c.deptcode = "CS"
    and c.cnum = 245
    and not exists (
        select c2.pnum 
        from class c2
        where c2.pnum = c.pnum
            and c2.deptcode = c.deptcode 
            and c2.cnum = c.cnum
            and ( c2.term <> c1.term or c2.section <> c2.term )
    )
