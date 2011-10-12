SELECT     S.PROJECT_ID,
           S.PROJECT_CODE,
           S.START_DATE,
           S.END_DATE,
           SUM(S.UNITS) UNITS,
           SUM(S.AMOUNT) AMOUNT
      FROM (
SELECT

SLICES.PROJECT_ID,SLICES.PROJECT_CODE,SLICES.START_DATE,SLICES.END_DATE,
ROUND(SLICES.UNITS,0) UNITS,MATRIX.BILL_RATE,ROUND(ROUND(SLICES.UNITS,0)*MATRIX.BILL_RATE,2) AMOUNT

FROM 

(SELECT PROJECTS.ID || TO_CHAR (SLICES.SLICE_DATE, 'YYYYMMDD') ID,
                     TEAMS.SLICE_STATUS,
                     TEAMS.PRID TEAM_ID,
                     PROJECTS.ID PROJECT_ID,
                     PROJECTS.UNIQUE_NAME PROJECT_CODE,
                     PROJECTS.NAME PROJECT_NAME,
                     RESOURCES.ID RESOURCE_ID,
                     RESOURCES.FULL_NAME RESOURCE_NAME,
                     RESOURCES.UNIQUE_NAME RESOURCE_CODE,
                     ROLES.FULL_NAME ROLE_NAME,
                     ROLES.UNIQUE_NAME ROLE_CODE,
                     TO_CHAR(SLICES.SLICE_DATE, 'YYYY-MM-DD') START_DATE,
                     TO_CHAR(LAST_DAY (SLICES.SLICE_DATE), 'YYYY-MM-DD') END_DATE,
                     SLICES.SLICE_DATE,
                     SUM (NVL (SLICES.SLICE, 0)) UNITS
                FROM WARM01.PRJ_BLB_SLICES SLICES,
                     WARM01.PRJ_BLB_SLICEREQUESTS REQUESTS,
                     WARM01.PRTEAM TEAMS,
                     WARM01.SRM_PROJECTS PROJECTS,
                     WARM01.SRM_RESOURCES RESOURCES,
                     WARM01.SRM_RESOURCES ROLES,
                     WARM01.PRJ_RESOURCES RESOURCE_DETAILS
               WHERE     REQUESTS.ID = SLICES.SLICE_REQUEST_ID
                     AND SLICES.PRJ_OBJECT_ID = TEAMS.PRID
                     AND TEAMS.PRPROJECTID = PROJECTS.ID
                     AND TEAMS.PRRESOURCEID = RESOURCES.ID
                     AND TEAMS.PRROLEID = ROLES.ID
                     AND RESOURCES.ID = RESOURCE_DETAILS.PRID
                     /* EXCLUDE RECORDS OUTSIDE OF THE PLAN START AND END DATES */
                     AND SLICES.SLICE_DATE BETWEEN (SELECT START_DATE
                                                      FROM WARM01.BIZ_COM_PERIODS
                                                     WHERE PERIOD_NAME = 'Jan 11')
                                               AND (SELECT START_DATE
                                                      FROM WARM01.BIZ_COM_PERIODS
                                                     WHERE PERIOD_NAME = 'Jan 14')
                     AND REQUESTS.FIELD = 4
                     AND REQUESTS.PERIOD = 3
                     AND REQUESTS.IS_ACTIVE = 1
                     AND REQUESTS.IS_TEMPLATE = 0
                     AND PROJECTS.ID = 5001567
            GROUP BY TEAMS.PRID,
                     TEAMS.SLICE_STATUS,
                     PROJECTS.ID,
                     PROJECTS.UNIQUE_NAME,
                     PROJECTS.NAME,
                     RESOURCES.ID,
                     RESOURCES.FULL_NAME,
                     RESOURCES.UNIQUE_NAME,
                     ROLES.FULL_NAME,
                     ROLES.UNIQUE_NAME,
                     SLICES.SLICE_DATE) SLICES,
            (SELECT PROJECT_ID,RESOURCE_ID,TEAM_ID,FROM_DATE,TO_DATE,BILL_RATE,TASK_ID FROM WARM01.NBI_PROJ_RES_RATES_AND_COSTS) MATRIX

WHERE
  SLICES.PROJECT_ID = MATRIX.PROJECT_ID(+)
  AND SLICES.RESOURCE_ID = MATRIX.RESOURCE_ID(+)
  AND SLICES.TEAM_ID = MATRIX.TEAM_ID(+)
  AND SLICES.SLICE_DATE > SYSDATE
  AND MATRIX.TASK_ID = -1
  AND SLICES.SLICE_DATE BETWEEN MATRIX.FROM_DATE AND MATRIX.TO_DATE
            UNION ALL
              SELECT W.INVESTMENT_ID,
                     W.PROJECT_CODE,
                     TO_CHAR (W.MONTH_BEGIN, 'YYYY-MM-DD'),
                     TO_CHAR (LAST_DAY (W.MONTH_BEGIN), 'YYYY-MM-DD'),
                     V.BILLRATE,
                     SUM (W.QUANTITY) UNITS,
                     SUM (V.AMOUNT) AMOUNT
                FROM WARM01.PPA_WIP W,
                     WARM01.PPA_WIP_VALUES V
               WHERE     W.TRANSNO = V.TRANSNO
                     AND V.CURRENCY_CODE = 'USD'
                     AND V.CURRENCY_TYPE = 'HOME'
                     AND W.INVESTMENT_ID = 5001567
                     AND W.IN_ERROR = 0
                     AND W.ON_HOLD = 0
                     AND W.STATUS NOT IN (2, 8)
                     AND W.TRANSTYPE = 'L'
                     AND W.MONTH_BEGIN BETWEEN (SELECT START_DATE
                                                  FROM WARM01.BIZ_COM_PERIODS
                                                 WHERE PERIOD_NAME = 'Jan 11')
                                           AND (SELECT START_DATE
                                                  FROM WARM01.BIZ_COM_PERIODS
                                                 WHERE PERIOD_NAME = 'Dec 13')
                     AND W.MONTH_END < SYSDATE
            GROUP BY V.BILLRATE,
                     W.INVESTMENT_ID,
                     W.PROJECT_CODE,
                     W.MONTH_BEGIN,
                     W.MONTH_BEGIN,
                     W.MONTH_END) S
    GROUP BY S.PROJECT_ID,
             S.PROJECT_CODE,
             S.START_DATE,
             S.END_DATE
    ORDER BY S.START_DATE ASC