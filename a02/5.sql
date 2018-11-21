with maxGradeCS245 as (
    select m.snum snum, m.deptcode deptcode, m.cnum cnum, m.term term, m.section section
    from mark m join student s m.snum = s.snum
    where m.deptcode = "CS"
        and m.cnum = 245
        and not exists (
            select m1.grade
            from mark m1
                where m1.deptcode = m.deptcode
                    and m1.cnum = m.cnum
                    and m1.grade > m.grade
        )
)
select p.pnum, p.pname
from professor p join class c on p.pnum = c.cnum
    join (
    select mg1.deptcode, mg1.cnum, mg1.term, mg1.section
    from maxGradeCS245 mg1, maxGradeCS245 mg2, maxGradeCS245 mg3
    where mg1.snum <> mg2.snum
        and mg1.snum <> mg3.snum
        and mg2.snum <> mg3.snum
        and not exists (
            select
            from maxGradeCS245 mg1
            where mg.snum <> mg1.snum
                and mg.snum <> mg2.snum
                and mg.snum <> mg3.snum
        )
) mg on c.deptcode = mg.deptcode
    and c.cnum = mg.cnum
    and c.term = mg.term
    and c.section = mg.section
