  SELECT P.UUID,
         P.PERSONNEL_NUM,
         P.RESOURCE_CODE,
         P.NAME,
         P.COST_CENTER,
         P.DATE_UID,
         P.YR_DT,
         P.MO_DT,
         ROUND (P.AMOUNT * R.AMOUNT, 2) FTE_EXPENSES,
         P.PROJECT_REVENUE,
         ROUND (P.AMOUNT * B.AMOUNT, 2) BASELINE_REVENUE,
         P.PROJECT_REVENUE + ROUND (P.AMOUNT * B.AMOUNT, 2) TOTAL_REVENUE,
         ROUND (P.AMOUNT * R.AMOUNT, 2) -  (P.PROJECT_REVENUE + ROUND (P.AMOUNT * B.AMOUNT, 2)) VARIANCE
    FROM (  SELECT C.UUID,
                   C.PERSONNEL_NUM,
                   V.RESOURCE_CODE,
                   C.NAME,
                   C.COST_CENTER,
                   C.DATE_UID,
                   SUBSTR(C.DATE_UID,0,4) YR_DT,
                   SUBSTR(C.DATE_UID,5,2) MO_DT,
                   NVL (C.AMOUNT, 0) AMOUNT,
                   SUM (NVL (V.AMOUNT, 0)) PROJECT_REVENUE
              FROM WARM01.CID_SP_CLARITY C, WARM01.CID_SP_VALUES V
             WHERE C.UUID = V.UUID(+)
          GROUP BY C.UUID,
                   C.PERSONNEL_NUM,
                   V.RESOURCE_CODE,
                   C.NAME,
                   C.COST_CENTER,
                   C.DATE_UID,
                   C.AMOUNT) P,
         (  SELECT DEPARTCODE, DATE_UID, SUM (NVL (AMOUNT, 0)) AMOUNT
              FROM WARM01.CID_SP_PROJECT_BUDGET_SUM
             WHERE PROJECTCLASS = 'BASELINE'
          GROUP BY DEPARTCODE, DATE_UID) B,
         (  SELECT DEPARTCODE, DATE_UID, SUM (NVL (AMOUNT, 0)) AMOUNT
              FROM WARM01.CID_SP_PROJECT_REVISED_SUM
             WHERE PROJECTCLASS = 'BASELINE'
          GROUP BY DEPARTCODE, DATE_UID) R
   WHERE     P.COST_CENTER = B.DEPARTCODE(+)
         AND P.DATE_UID = B.DATE_UID(+)
         AND P.COST_CENTER = R.DEPARTCODE(+)
         AND P.DATE_UID = R.DATE_UID(+)
         AND P.COST_CENTER = '1037331010'
         AND SUBSTR (P.DATE_UID, 0, 4) = '2011'
ORDER BY P.DATE_UID