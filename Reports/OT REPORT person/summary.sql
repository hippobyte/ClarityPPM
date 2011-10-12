SELECT 
  DTL.RESOURCE_USER_ID,
  DTL.RESOURCE_NAME,
  DTL.RM_USER_ID,
  DTL.RM_NAME,
  DTL.L3_NAME,
  DTL.L4_NAME,
  DTL.L5_NAME,
  DTL.L6_NAME,
  CASE WHEN TO_CHAR({?date_param},'YYYY') = '2011' THEN TO_NUMBER(TO_CHAR({?date_param},'MM')) - 3 ELSE TO_NUMBER(TO_CHAR({?date_param},'MM')) END YTD_MONTH,
  -- total hours worked
  SUM (DTL."01_TOTAL_HRS") "01_TOTAL_HRS",
  SUM (DTL."02_TOTAL_HRS") "02_TOTAL_HRS",
  SUM (DTL."03_TOTAL_HRS") "03_TOTAL_HRS",
  SUM (DTL."04_TOTAL_HRS") "04_TOTAL_HRS",
  SUM (DTL."05_TOTAL_HRS") "05_TOTAL_HRS",
  SUM (DTL."06_TOTAL_HRS") "06_TOTAL_HRS",
  SUM (DTL."07_TOTAL_HRS") "07_TOTAL_HRS",
  SUM (DTL."08_TOTAL_HRS") "08_TOTAL_HRS",
  SUM (DTL."09_TOTAL_HRS") "09_TOTAL_HRS",
  SUM (DTL."10_TOTAL_HRS") "10_TOTAL_HRS",
  SUM (DTL."11_TOTAL_HRS") "11_TOTAL_HRS",
  SUM (DTL."12_TOTAL_HRS") "12_TOTAL_HRS",
  -- business days per month
  MAX (DTL."01_DAYS_MO") "01_DAYS_MO",
  MAX (DTL."02_DAYS_MO") "02_DAYS_MO",
  MAX (DTL."03_DAYS_MO") "03_DAYS_MO",
  MAX (DTL."04_DAYS_MO") "04_DAYS_MO",
  MAX (DTL."05_DAYS_MO") "05_DAYS_MO",
  MAX (DTL."06_DAYS_MO") "06_DAYS_MO",
  MAX (DTL."07_DAYS_MO") "07_DAYS_MO",
  MAX (DTL."08_DAYS_MO") "08_DAYS_MO",
  MAX (DTL."09_DAYS_MO") "09_DAYS_MO",
  MAX (DTL."10_DAYS_MO") "10_DAYS_MO",
  MAX (DTL."11_DAYS_MO") "11_DAYS_MO",
  MAX (DTL."12_DAYS_MO") "12_DAYS_MO",
  -- expected work hours - assumption: 7.5 x business days per month
  DTL.STD_HOURS * MAX (DTL."01_DAYS_MO") "01_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."02_DAYS_MO") "02_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."03_DAYS_MO") "03_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."04_DAYS_MO") "04_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."05_DAYS_MO") "05_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."06_DAYS_MO") "06_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."07_DAYS_MO") "07_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."08_DAYS_MO") "08_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."09_DAYS_MO") "09_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."10_DAYS_MO") "10_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."11_DAYS_MO") "11_EXP_HRS",
  DTL.STD_HOURS * MAX (DTL."12_DAYS_MO") "12_EXP_HRS",
  -- overtime hours per month
  CASE WHEN SUM (DTL."01_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."01_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."01_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."01_DAYS_MO")) END "01_OT_HRS",
  CASE WHEN SUM (DTL."02_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."02_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."02_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."02_DAYS_MO")) END "02_OT_HRS",
  CASE WHEN SUM (DTL."03_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."03_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."03_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."03_DAYS_MO")) END "03_OT_HRS",
  CASE WHEN SUM (DTL."04_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."04_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."04_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."04_DAYS_MO")) END "04_OT_HRS",
  CASE WHEN SUM (DTL."05_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."05_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."05_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."05_DAYS_MO")) END "05_OT_HRS",
  CASE WHEN SUM (DTL."06_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."06_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."06_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."06_DAYS_MO")) END "06_OT_HRS",
  CASE WHEN SUM (DTL."07_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."07_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."07_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."07_DAYS_MO")) END "07_OT_HRS",
  CASE WHEN SUM (DTL."08_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."08_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."08_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."08_DAYS_MO")) END "08_OT_HRS",
  CASE WHEN SUM (DTL."09_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."09_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."09_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."09_DAYS_MO")) END "09_OT_HRS",
  CASE WHEN SUM (DTL."10_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."10_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."10_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."10_DAYS_MO")) END "10_OT_HRS",
  CASE WHEN SUM (DTL."11_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."11_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."11_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."11_DAYS_MO")) END "11_OT_HRS",
  CASE WHEN SUM (DTL."12_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."12_DAYS_MO")) <= 0 THEN 0 ELSE SUM (DTL."12_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."12_DAYS_MO")) END "12_OT_HRS",
  -- overtime hours per day
  CASE WHEN SUM (DTL."01_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."01_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."01_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."01_DAYS_MO"))) /  MAX (DTL."01_DAYS_MO") END "01_OT_HRS_DAY",
  CASE WHEN SUM (DTL."02_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."02_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."02_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."02_DAYS_MO"))) /  MAX (DTL."02_DAYS_MO") END "02_OT_HRS_DAY",
  CASE WHEN SUM (DTL."03_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."03_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."03_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."03_DAYS_MO"))) /  MAX (DTL."03_DAYS_MO") END "03_OT_HRS_DAY",
  CASE WHEN SUM (DTL."04_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."04_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."04_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."04_DAYS_MO"))) /  MAX (DTL."04_DAYS_MO") END "04_OT_HRS_DAY",
  CASE WHEN SUM (DTL."05_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."05_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."05_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."05_DAYS_MO"))) /  MAX (DTL."05_DAYS_MO") END "05_OT_HRS_DAY",
  CASE WHEN SUM (DTL."06_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."06_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."06_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."06_DAYS_MO"))) /  MAX (DTL."06_DAYS_MO") END "06_OT_HRS_DAY",
  CASE WHEN SUM (DTL."07_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."07_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."07_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."07_DAYS_MO"))) /  MAX (DTL."07_DAYS_MO") END "07_OT_HRS_DAY",
  CASE WHEN SUM (DTL."08_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."08_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."08_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."08_DAYS_MO"))) /  MAX (DTL."08_DAYS_MO") END "08_OT_HRS_DAY",
  CASE WHEN SUM (DTL."09_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."09_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."09_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."09_DAYS_MO"))) /  MAX (DTL."09_DAYS_MO") END "09_OT_HRS_DAY",
  CASE WHEN SUM (DTL."10_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."10_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."10_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."10_DAYS_MO"))) /  MAX (DTL."10_DAYS_MO") END "10_OT_HRS_DAY",
  CASE WHEN SUM (DTL."11_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."11_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."11_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."11_DAYS_MO"))) /  MAX (DTL."11_DAYS_MO") END "11_OT_HRS_DAY",
  CASE WHEN SUM (DTL."12_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."12_DAYS_MO")) <= 0 THEN 0 ELSE (SUM (DTL."12_TOTAL_HRS") - (DTL.STD_HOURS * MAX (DTL."12_DAYS_MO"))) /  MAX (DTL."12_DAYS_MO") END "12_OT_HRS_DAY"
FROM (  
  
  SELECT USERS.ID RESOURCE_USER_ID,
         RESOURCES.FULL_NAME RESOURCE_NAME,
         RM.USER_ID RM_USER_ID,
         RM.FULL_NAME RM_NAME,
         STD_HOURS.HOURS STD_HOURS,
         -- cross tab view of total work hours per month
         CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '01' THEN WIP.QUANTITY ELSE 0
          END "01_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '02' THEN WIP.QUANTITY ELSE 0
          END "02_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '03' THEN WIP.QUANTITY ELSE 0
          END "03_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '04' THEN WIP.QUANTITY ELSE 0
          END "04_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '05' THEN WIP.QUANTITY ELSE 0
          END "05_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '06' THEN WIP.QUANTITY ELSE 0
          END "06_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '07' THEN WIP.QUANTITY ELSE 0
          END "07_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '08' THEN WIP.QUANTITY ELSE 0
          END "08_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '09' THEN WIP.QUANTITY ELSE 0
          END "09_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '10' THEN WIP.QUANTITY ELSE 0
          END "10_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '11' THEN WIP.QUANTITY ELSE 0
          END "11_TOTAL_HRS",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '12' THEN WIP.QUANTITY ELSE 0
          END "12_TOTAL_HRS",
          -- cross tab view of days per month
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '01' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "01_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '02' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "02_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '03' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "03_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '04' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "04_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '05' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "05_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '06' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "06_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '07' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "07_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '08' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "08_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '09' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "09_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '10' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "10_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '11' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "11_DAYS_MO",
          CASE
            WHEN TO_CHAR(WIP.MONTH_BEGIN,'MM') = '12' THEN MONTH_BEGIN.DAYS_MO ELSE 0
          END "12_DAYS_MO",
         L3.NAME L3_NAME,
         L4.NAME L4_NAME,
         L5.NAME L5_NAME,
         L6.NAME L6_NAME
    FROM WARM01.PPA_WIP WIP,
         WARM01.SRM_RESOURCES RESOURCES,
         WARM01.SRM_RESOURCES RM,
         WARM01.CMN_SEC_USERS USERS,
         WARM01.DEPARTMENTS DEPARTMENT,
         -- a dirty way of getting expected daily work hours - getting standard calendar
         -- better than hardcoding current 7.5 hours per day, however surely a better solution exists
         (SELECT HOURS_PER_DAY HOURS FROM PRCALENDAR WHERE PRID = 5000001) STD_HOURS,
         (SELECT TRUNC(DT_VLU,'MM') DT_BEGIN, COUNT(DT_VLU) DAYS_MO FROM ODF_CA_CID_FIN_CALENDAR WHERE DY_SHRT_NM NOT IN ('SAT','SUN') GROUP BY TRUNC(DT_VLU,'MM')) MONTH_BEGIN,
         (SELECT UNIT_ID, UNIQUE_NAME, NAME
            FROM WARM01.OBS_UNITS_V
           WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L3,
         (SELECT UNIT_ID, UNIQUE_NAME, NAME
            FROM WARM01.OBS_UNITS_V
           WHERE DEPTH = 4 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L4,
         (SELECT UNIT_ID, UNIQUE_NAME, NAME
            FROM WARM01.OBS_UNITS_V
           WHERE DEPTH = 5 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L5,
         (SELECT UNIT_ID, UNIQUE_NAME, NAME
            FROM WARM01.OBS_UNITS_V
           WHERE DEPTH = 6 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') L6
   WHERE     WIP.RESOURCE_CODE = RESOURCES.UNIQUE_NAME
         AND RESOURCES.USER_ID = USERS.ID
         AND RESOURCES.MANAGER_ID = RM.USER_ID(+)
         AND WIP.MONTH_BEGIN = MONTH_BEGIN.DT_BEGIN
         AND WIP.EMPLYHOMEDEPART = DEPARTMENT.DEPARTCODE
             -- tree-type structure of the obs
         AND DEPARTMENT.OBS_UNIT_ID = L3.UNIT_ID(+)
         AND DEPARTMENT.OBS_UNIT_ID = L4.UNIT_ID(+)
         AND DEPARTMENT.OBS_UNIT_ID = L5.UNIT_ID(+)
         AND DEPARTMENT.OBS_UNIT_ID = L6.UNIT_ID(+)
         AND -- ci entity only
             WIP.ENTITY = 'CID'
            -- labor transactions only
         AND WIP.TRANSTYPE = 'L'
             -- status should not include reversed or pending approval transactions
         AND WIP.STATUS NOT IN (2, 8)
         AND WIP.ON_HOLD = 0
             -- current year only
         AND WIP.MONTH_BEGIN BETWEEN CASE WHEN TO_CHAR(TRUNC({?date_param},'YYYY'),'YYYY') = '2011' THEN TO_DATE('20110401','YYYYMMDD') ELSE TRUNC({?date_param},'YYYY') END AND {?date_param}
         AND DEPARTMENT.OBS_UNIT_ID IN (SELECT LINKED_UNIT_ID FROM OBS_UNITS_V WHERE UNIT_ID = {?obs_unit_id} AND UNIT_MODE = 'OBS_UNIT_CHILD_AND_ANCESTORS') 
             -- include only employees
         AND RESOURCES.PERSON_TYPE = 300) DTL
         
GROUP BY
  DTL.STD_HOURS,
  DTL.RESOURCE_USER_ID,
  DTL.RESOURCE_NAME,
  DTL.RM_USER_ID,
  DTL.RM_NAME,
  DTL.L3_NAME,
  DTL.L4_NAME,
  DTL.L5_NAME,
  DTL.L6_NAME