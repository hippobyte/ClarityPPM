SELECT WIP.INVESTMENT_ID,
       WIP.PROJECT_CODE PROJ_ID,
       WIP.TASK_ID,
       WIP.PROJECT_DEPARTMENT CC_CD,
       WIP.QUANTITY UNITS,
       WIP_VALUES.BILLRATE,
       WIP_VALUES.AMOUNT,
       WIP.TRANSCLASS TRANCLASS_CODE,
       BUSINESS_UNIT.NAME DPT_TXT,
       PROJECT_TYPES.NAME PROJ_TP_NM,
       PROJECT_TYPES.LOOKUP_CODE PROJECT_TYPE_CODE
  FROM WARM01.PPA_WIP WIP,
       WARM01.PPA_WIP_VALUES WIP_VALUES,
       WARM01.SRM_RESOURCES RESOURCES,
       WARM01.INV_INVESTMENTS CURRENT_PROJECTS,
       WARM01.ODF_CA_PROJECT PROJECT_FACTS,
       WARM01.DEPARTMENTS RESOURCE_DPT,
       WARM01.DEPARTMENTS PROJECT_DPT,
       (SELECT LOOKUP_CODE, NAME
          FROM WARM01.CMN_LOOKUPS_V
         WHERE LANGUAGE_CODE = 'en' AND PARTITION_CODE = 'cid') PROJECT_TYPES,
       (SELECT UNIT_ID, UNIQUE_NAME, NAME
          FROM WARM01.OBS_UNITS_V
         WHERE DEPTH = 1 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') PROJECT_CC,
       (SELECT UNIT_ID, UNIQUE_NAME, NAME
          FROM WARM01.OBS_UNITS_V
         WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') BUSINESS_UNIT
 WHERE     WIP.RESOURCE_CODE = RESOURCES.UNIQUE_NAME
       AND WIP.EMPLYHOMEDEPART = RESOURCE_DPT.DEPARTCODE
       AND WIP.PROJECT_DEPARTMENT = PROJECT_DPT.DEPARTCODE
       AND PROJECT_DPT.OBS_UNIT_ID = PROJECT_CC.UNIT_ID
       AND PROJECT_DPT.OBS_UNIT_ID = BUSINESS_UNIT.UNIT_ID(+)
       AND WIP.INVESTMENT_ID = CURRENT_PROJECTS.ID
       AND WIP.TRANSNO = WIP_VALUES.TRANSNO
       AND CURRENT_PROJECTS.ID = PROJECT_FACTS.ID
       AND PROJECT_FACTS.OBJ_REQUEST_TYPE = PROJECT_TYPES.LOOKUP_CODE
       -- ensure record has cost center
       AND BUSINESS_UNIT.NAME IS NOT NULL
       AND 
       -- wip values for billing
           WIP_VALUES.CURRENCY_TYPE = 'BILLING'
       AND WIP_VALUES.CURRENCY_CODE = 'USD'
       AND 
       -- ensure proper wip transactions
           WIP.ENTITY = 'CID'
       AND WIP.TRANSTYPE = 'L'
       AND WIP.STATUS NOT IN (2, 8)
       AND WIP.ON_HOLD = 0