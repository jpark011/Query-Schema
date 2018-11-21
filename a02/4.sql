with markPerClass as (
    select maxM.snum snumMax, maxM.grade gradeMax, 
        minM.snum snumMin, minM.grade gradeMin,
        maxM.cnum cnum, maxM.term term, maxM.section section, 
        c.pnum pnum, p.pname pname
    from mark maxM
        join mark minM
        on maxM.deptcode = minM.deptcode
            and maxM.cnum = minM.cnum
            and maxM.term = minM.term
            and maxM.section = minM.section
        join class c
        on minM.deptcode = c.deptcode
            and minM.cnum = c.cnum
            and minM.term = c.term
            and minM.section = c.section
        join professor p
        on c.pnum = p.pnum
)
select mc1.gradeMax, mc1.gradeMin, mc2.gradeMax, mc2.gradeMin, 
    mc1.pnum, mc1.pname, mc2.pnum, mc2.pname
from markPerClass mc1, markPerClass mc2
where mc1.deptcode = mc2.deptcode
    and mc1.cnum = mc2.cnum
    and mc1.term = mc2.term
    and mc1.pnum <> mc2.pnum
    and not exists (
        select 
        from mark m
        where m.deptcode = mc1.deptcode
            and m.cnum = mc1.cnum
            and m.term = mc1.term
            and m.grade < mc1.gradeMin
            and m.grade > mc1.gradeMax
    )
    and not exists (
        select 
        from mark m
        where m.deptcode = mc2.deptcode
            and m.cnum = mc2.cnum
            and m.term = mc2.term
            and m.grade < mc2.gradeMin
            and m.grade > mc2.gradeMax
    )
