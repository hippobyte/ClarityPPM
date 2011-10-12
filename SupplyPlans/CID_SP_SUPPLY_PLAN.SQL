DROP TABLE WARM01.CID_SP_SUPPLY_PLAN;

CREATE TABLE WARM01.CID_SP_SUPPLY_PLAN
AS
   SELECT SUBSTR (A.DATE_UID, 0, 4) YEAR,
          SUBSTR (A.DATE_UID, 3, 2) MONTH,
          TO_DATE (A.DATE_UID, 'YYYYMM') MONTH_BEGIN,
          LAST_DAY (TO_DATE (A.DATE_UID, 'YYYYMM')) MONTH_END,
          A.DATE_UID,
          A.NAME,
          L3.NAME ORGANIZATION,
          L4.NAME SUB_ORGANIZATION,
          A.COST_CENTER,
          L5.NAME DIVISION,
          A.PROJECT_ID,
          A.PROJECT_NAME,
          A.PROJECTCLASS,
          A.AMOUNT,
          A.ROW_TYPE
     FROM (SELECT C.DATE_UID,
                  C.NAME,
                  C.COST_CENTER,
                  F.PROJECT_ID,
                  F.PROJECT_NAME,
                  F.PROJECTCLASS,
                  ROUND (C.FTE_AMOUNT * F.RECOVERED_AMOUNT, 2) AMOUNT,
                  '2 - PROJECT FUNDING' ROW_TYPE
             FROM CID_SP_CLARITY C, CID_SP_WARM_FINANCIALS F
            WHERE     C.PERSONNEL_NUM = F.PRUSERTEXT1(+)
                  AND C.DATE_UID = F.DATE_UID(+)
                  AND F.PROJECTCLASS NOT IN ('BASELINE')
           UNION ALL
             SELECT C.DATE_UID,
                    'BASELINE' NAME,
                    C.COST_CENTER,
                    'BASELINE' PROJECT_ID,
                    'BASELINE' PROJECT_NAME,
                    'BASELINE' PROJECTCLASS,
                    ROUND (SUM (C.CC_PERCENT * B.AMOUNT), 2) AMOUNT,
                    '1 - BASELINE FUNDING' ROW_TYPE
               FROM CID_SP_CLARITY C, CID_SP_BASELINE_BUDGETS B
              WHERE C.COST_CENTER = B.CC AND C.DATE_UID = B.DATE_UID
           GROUP BY C.DATE_UID, C.COST_CENTER
           UNION ALL
           SELECT WF.DATE_UID,
                  R.FULL_NAME,
                  WF.CC,
                  WF.PROJECT_ID,
                  WF.PROJECT_NAME,
                  WF.PROJECTCLASS,
                  WF.RECOVERED_AMOUNT AMOUNT,
                  '3 - PROJECTED FUNDING' ROW_TYPE
             FROM CID_SP_WARM_FINANCIALS WF, WARM01.SRM_RESOURCES R
            WHERE     WF.RESOURCE_CODE = R.UNIQUE_NAME
                  AND ISROLE = 1
                  AND CC IS NOT NULL
           UNION ALL
           SELECT C.DATE_UID,
                  C.NAME,
                  C.COST_CENTER,
                  'LIABILITY' PROJECT_ID,
                  'LIABILITY' PROJECT_NAME,
                  'LIABILITY' PROJECTCLASS,
                  ROUND (C.FTE_AMOUNT * (-161578.56 / 12), 2) AMOUNT,
                  '4 - LIABILITY' ROW_TYPE
             FROM CID_SP_CLARITY C) A,
          WARM01.DEPARTMENTS D,
          (SELECT UNIT_ID, UNIQUE_NAME, NAME
             FROM WARM01.OBS_UNITS_V
            WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L3,
          (SELECT UNIT_ID, UNIQUE_NAME, NAME
             FROM WARM01.OBS_UNITS_V
            WHERE DEPTH = 4 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L4,
          (SELECT UNIT_ID, UNIQUE_NAME, NAME
             FROM WARM01.OBS_UNITS_V
            WHERE DEPTH = 5 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L5
    WHERE     A.COST_CENTER = D.DEPARTCODE
          AND D.OBS_UNIT_ID = L3.UNIT_ID
          AND D.OBS_UNIT_ID = L4.UNIT_ID
          AND D.OBS_UNIT_ID = L5.UNIT_ID