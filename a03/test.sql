SELECT Au.name name, Pu.title title, Pu.pubid pubid \
FROM author Au \
    JOIN wrote W \
        ON W.aid = Au.aid \
    JOIN publication Pu \
        ON Pu.pubid = W.pubid \
    LEFT JOIN proceedings Pr \
        ON Pr.pubid = Pu.pubid \
    LEFT JOIN journal J \
        ON J.pubid = Pu.pubid \
    LEFT JOIN book B \
        ON B.pubid = Pu.pubid \
    LEFT JOIN article A \ 
        ON A.pubid = Pu.pubid \
WHERE Au.name LIKE "Peter Bumbulis" 

-- SELECT Au.name name
-- FROM book B \
--     JOIN publication Pu
--         ON Pu.pubid = B.pubid
--     LEFT JOIN wrote W
--         ON W.pubid = Pu.pubid
--     JOIN author Au
--         ON Au.aid = W.aid
-- WHERE B.pubid = :pubid