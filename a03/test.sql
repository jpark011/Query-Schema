WITH unionPub AS (
    (SELECT pubid, year, NULL AS volume, NULL AS number, NULL AS publisher, NULL AS appearsin, NULL AS startpage, NULL AS endpage
    FROM proceedings)
    UNION
    (SELECT pubid, year, volume, number, NULL AS publisher, NULL AS appearsin, NULL AS startpage, NULL AS endpage
    FROM journal)
    UNION
    (SELECT pubid, year, NULL AS volume, NULL AS number, publisher, NULL AS appearsin, NULL AS startpage, NULL AS endpage
    FROM book)
    UNION
    (SELECT pubid, NULL AS year, NULL AS volume, NULL AS number, NULL AS publisher, appearsin, startpage, endpage
    FROM article)
)
SELECT Au.name name, Pu.title title, Pu.pubid pubid \
        P.year year, P.volume volume, P.number number, P.publisher publisher,
        P.appearsin appearsin, P.startpage startpage, P.endpage endpage
FROM author Au \
    JOIN wrote W \
        ON W.aid = Au.aid \
    JOIN publication Pu \
        ON Pu.pubid = W.pubid \
    JOIN unionPub P
        ON P.pubid = Pu.pubid \
WHERE Au.name LIKE "Peter Bumbulis" 

SELECT Au.name name
FROM book B \
    JOIN publication Pu
        ON Pu.pubid = B.pubid
    LEFT JOIN wrote W
        ON W.pubid = Pu.pubid
    JOIN author Au
        ON Au.aid = W.aid
WHERE B.pubid = :pubid


SELECT count(aid) numAuthors
FROM author Au
    JOIN wrote W
        ON W.aid = Au.aid
WHERE W.pubid = 


ORDER BY startpage

SELECT Pu.pubid pubid, Pu.title title, unionPJ.year year,
        unionPJ.volume volume, unionPJ.number number
FROM publication Pu
    JOIN (
        SELECT pubid, year, NULL AS volume, NULL AS number
        FROM proceedings
        UNION
        SELECT pubid, year, volume, number
        FROM journal
    ) unionPJ
    LEFT JOIN (
        SELECT appearsin
        FROM article A
        WHERE A.pubid = :pubid
    ) Ap
        ON Ap.appearsin = Pu.pubid
ORDER BY Ap.startpage