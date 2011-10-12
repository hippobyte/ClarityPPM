SELECT * FROM 

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
                     SLICES.SLICE_DATE START_DATE,
                     LAST_DAY (SLICES.SLICE_DATE) END_DATE,
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
  AND MATRIX.TASK_ID = -1
  AND SLICES.START_DATE BETWEEN MATRIX.FROM_DATE AND MATRIX.TO_DATE
  AND SLICES.PROJECT_ID = '5001567'
  AND SLICES.RESOURCE_ID = '5002019'