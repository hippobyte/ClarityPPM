SELECT
  D.UUID,
  D.PERSONNEL_NUM,
  D.NAME,
  D.COST_CENTER,
  D.DATE_UID,
  CASE WHEN S.AMOUNT IS NULL OR S.AMOUNT = 0 THEN 0 ELSE D.AMOUNT/S.AMOUNT END AMOUNT
FROM 
 (SELECT CV.UUID,
         CV.PERSONNEL_NUM,
         CV.NAME,
         CV.COST_CENTER,
         CV.DATE_UID,
         SUM (CV.AMOUNT) AMOUNT
    FROM (SELECT N.PERSONNEL_NUM || N.YEAR || '01' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '01' DATE_UID,
                 JAN_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '02' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '02' DATE_UID,
                 FEB_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '03' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '03' DATE_UID,
                 MAR_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '04' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '04' DATE_UID,
                 APR_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '05' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '05' DATE_UID,
                 MAY_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '06' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '06' DATE_UID,
                 JUN_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '07' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '07' DATE_UID,
                 JUL_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '08' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '08' DATE_UID,
                 AUG_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '09' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '09' DATE_UID,
                 SEP_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '10' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '10' DATE_UID,
                 OCT_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '11' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '11' DATE_UID,
                 NOV_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '12' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '12' DATE_UID,
                 DEC_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N) CV
   WHERE CV.SCENARIO = 'salary current year'
GROUP BY CV.UUID,
         CV.PERSONNEL_NUM,
         CV.NAME,
         CV.DATE_UID,
         CV.COST_CENTER) D,
  (SELECT CV.COST_CENTER,
         CV.DATE_UID,
         SUM (CV.AMOUNT) AMOUNT
    FROM (SELECT N.PERSONNEL_NUM || N.YEAR || '01' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '01' DATE_UID,
                 JAN_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '02' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '02' DATE_UID,
                 FEB_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '03' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '03' DATE_UID,
                 MAR_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '04' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '04' DATE_UID,
                 APR_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '05' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '05' DATE_UID,
                 MAY_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '06' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '06' DATE_UID,
                 JUN_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '07' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '07' DATE_UID,
                 JUL_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '08' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '08' DATE_UID,
                 AUG_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '09' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '09' DATE_UID,
                 SEP_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '10' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '10' DATE_UID,
                 OCT_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '11' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '11' DATE_UID,
                 NOV_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N
          UNION ALL
          SELECT N.PERSONNEL_NUM || N.YEAR || '12' UUID,
                 N.PERSONNEL_NUM,N.NAME,
                 N.SCENARIO,
                 N.COST_CENTER,
                 N.YEAR || '12' DATE_UID,
                 DEC_AM AMOUNT
            FROM BPCL01OD.NYLSALARY_FTE N) CV
   WHERE CV.SCENARIO = 'salary current year'
GROUP BY CV.DATE_UID,
         CV.COST_CENTER) S
WHERE D.COST_CENTER = S.COST_CENTER
      AND D.DATE_UID = S.DATE_UID