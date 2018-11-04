select *
from class c 
    join enrollment e 
    on c.deptcode = e.deptcode
        and c.cnum = e.deptcode
        and c.term = e.term
        and c.section = e.section
where c.deptcode = "CS"
    and c.cnum = 245
    and ( m.deptcode, m.cnum, m.term, m.section ) in (
        select m2.deptcode, m2.cnum, m2.term, m2.section
        from mark m2
        where  m2.deptcode = m.deptcode
            and m2.cnum = m.cnum
            and m2.term = m.term
            and m2.section = m.section
            and m2.grade in (
                select max(m3.grade)
                from mark m3
                where m3.deptcode = m2.deptcode
                    and m3.cnum = m2.cnum
                    and m3.term = m2.term
                    and m3.section = m2.section
            )
            and not exists (
                select m4.snum
                from mark m4
                where m4.deptcode = m2.deptcode
                    and m4.cnum = m2.cnum
                    and m4.term = m2.term
                    and m4.section = m2.section
                    and m4.grade <= m2.grade - 20
                    and m4.snum <> m2.snum 
            )
        group by m2.deptcode, m2.cnum, m2.term, m2.section, m2.grade
        having count(*) = 3
    )

