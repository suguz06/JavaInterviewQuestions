WITH R(SUBMISSION_DATE, HACKER_ID) AS
  (SELECT DISTINCT SUBMISSION_DATE,
                   HACKER_ID
   FROM SUBMISSIONS
   WHERE SUBMISSION_DATE = TO_DATE('2016-03-01')
   UNION ALL SELECT CHILD.SUBMISSION_DATE,
                    CHILD.HACKER_ID
   FROM R PARENT,
        SUBMISSIONS CHILD
   WHERE PARENT.SUBMISSION_DATE + 1 = CHILD.SUBMISSION_DATE
     AND PARENT.HACKER_ID = CHILD.HACKER_ID),
     TOTAL AS
  (SELECT SUBMISSION_DATE,
          COUNT(DISTINCT HACKER_ID) AS TOTAL
   FROM R
   GROUP BY SUBMISSION_DATE),
     COUNTER AS
  (SELECT SUBMISSION_DATE,
          HACKER_ID,
          COUNT(HACKER_ID) AS N
   FROM SUBMISSIONS
   GROUP BY SUBMISSION_DATE,
            HACKER_ID),
     MAXPERDAY AS
  (SELECT C.SUBMISSION_DATE,
          MIN(C.HACKER_ID) AS HACKER_ID
   FROM COUNTER C
   WHERE C.N =
       (SELECT MAX(K.N)
        FROM COUNTER K
        WHERE C.SUBMISSION_DATE = K.SUBMISSION_DATE)
   GROUP BY SUBMISSION_DATE)
SELECT TOTAL.SUBMISSION_DATE,
       TOTAL.TOTAL,
       HACKERS.HACKER_ID,
       HACKERS.NAME
FROM TOTAL
JOIN MAXPERDAY ON TOTAL.SUBMISSION_DATE = MAXPERDAY.SUBMISSION_DATE
JOIN HACKERS ON MAXPERDAY.HACKER_ID = HACKERS.HACKER_ID
ORDER BY TOTAL.SUBMISSION_DATE;