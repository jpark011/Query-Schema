SELECT * \
FROM publication Pu \
    LEFT JOIN proceedings Pr \
        ON Pr.pubid = Pu.pubid \
    LEFT JOIN journal J \
        ON J.pubid = Pu.pubid \
    LEFT JOIN book B \
        ON B.pubid = Pu.pubid \
    LEFT JOIN article A \ 
        ON A.pubid = Pu.pubid
