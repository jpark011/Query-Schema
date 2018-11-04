select count( p.pnum ) / count( select distinct p.pnum from professor p )
from professor p join class c on p.pnum = c.pnum
where not exists (
    select 
    from class c1 
    where c1.pnum = c.pnum
        and ( c1.deptcode <> c.deptcode or c1.cnum <> c.cnum )
        and c1.term = c.term
)
