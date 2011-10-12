SELECT 
  INVESTMENTS.CODE INVESTMENT_ID,
  INVESTMENTS.NAME INVESTMENT_NAME,
  RESOURCES.FULL_NAME MANAGER_NAME,
  OBS_DEPARTMENT.NAME DEPARTMENT_NAME,
  OBS_COSTCENTER.UNIQUE_NAME COST_CENTER,
  PROJECT_TYPES.NAME PROJECT_TYPE,
  CHARGE_CODES.PRNAME CHARGECODE_NAME,
  TRANSACTION_CLASSES.DESCRIPTION TRANCLASS_NAME,
  PLAN_VALUES.START_DATE,
  PLAN_VALUES.UNITS,
  PLAN_VALUES.COSTS
FROM 
  WARM01.INV_INVESTMENTS INVESTMENTS,
  WARM01.FIN_PLANS PLANS,
  WARM01.FIN_COST_PLAN_DETAILS DETAILS,
  WARM01.TRANSCLASS TRANSACTION_CLASSES,
  WARM01.PRCHARGECODE CHARGE_CODES,
  WARM01.ODF_CA_PROJECT PROJECTS,
  WARM01.SRM_RESOURCES RESOURCES,
  WARM01.INV_OBS_ONLY_V OBS_LOOKUP,
  (SELECT PRJ_OBJECT_ID,START_DATE,FINISH_DATE,SUM(UNITS) UNITS,SUM(COSTS) COSTS FROM (SELECT PRJ_OBJECT_ID,START_DATE,FINISH_DATE,ROUND((FINISH_DATE-START_DATE)*SUM(SLICE),2) UNITS,0 COSTS,0 ACTUALS FROM WARM01.ODF_SSL_CST_DTL_UNITS GROUP BY PRJ_OBJECT_ID,START_DATE,FINISH_DATE UNION SELECT PRJ_OBJECT_ID,START_DATE,FINISH_DATE,0 UNITS,ROUND((FINISH_DATE-START_DATE)*SUM(SLICE),2) COSTS,0 ACTUALS FROM WARM01.ODF_SSL_CST_DTL_COST GROUP BY PRJ_OBJECT_ID,START_DATE,FINISH_DATE) GROUP BY PRJ_OBJECT_ID,START_DATE,FINISH_DATE) PLAN_VALUES,
  (SELECT UNIT_ID, UNIQUE_NAME, NAME FROM WARM01.OBS_UNITS_V WHERE DEPTH = 5 AND TYPE_ID = 5000001 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') OBS_COSTCENTER,
  (SELECT UNIT_ID, UNIQUE_NAME, NAME FROM WARM01.OBS_UNITS_V WHERE DEPTH = 3 AND TYPE_ID = 5000001 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') OBS_DEPARTMENT,
  (SELECT LOOKUP_CODE ID,NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='FIN_PLAN_BY_TYPE' AND LANGUAGE_CODE='en') PLAN_GROUP,
  (SELECT LOOKUP_CODE ID,NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='FIN_PLAN_BY_TYPE' AND LANGUAGE_CODE='en') PLAN_SUBGROUP,
  (SELECT LOOKUP_CODE ID,NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='OBJ_IDEA_PROJECT_TYPE' AND LANGUAGE_CODE='en') PROJECT_TYPES,
  (SELECT A.PRID ID,B.FULL_NAME NAME FROM WARM01.PRJ_RESOURCES A,WARM01.SRM_RESOURCES B WHERE A.PRID = B.ID AND PRISROLE = 1) ROLES
WHERE 
  INVESTMENTS.ID = PLANS.OBJECT_ID AND
  INVESTMENTS.ID = PROJECTS.ID(+) AND
  INVESTMENTS.MANAGER_ID = RESOURCES.USER_ID(+) AND
  PLANS.ID = DETAILS.PLAN_ID AND 
  DETAILS.ID = PLAN_VALUES.PRJ_OBJECT_ID AND
  INVESTMENTS.ID  = OBS_LOOKUP.INVESTMENT_ID(+) AND
  OBS_LOOKUP.OBS_UNIT = OBS_COSTCENTER.UNIT_ID AND
  OBS_LOOKUP.OBS_UNIT = OBS_DEPARTMENT.UNIT_ID AND
  DETAILS.PRROLE_ID = ROLES.ID(+) AND
  PLANS.PLAN_BY_1_CODE = PLAN_GROUP.ID(+) AND
  PLANS.PLAN_BY_2_CODE = PLAN_SUBGROUP.ID(+) AND
  DETAILS.TRANSCLASS_ID = TRANSACTION_CLASSES.ID(+) AND
  DETAILS.PRCHARGECODE_ID = CHARGE_CODES.PRID(+) AND
  PROJECTS.OBJ_REQUEST_TYPE = PROJECT_TYPES.ID(+) AND
  /* FINANCE SPECIFIC - CHARGEBACK PURPOSE */
  INVESTMENTS.ENTITY_CODE = 'CID' AND
  PLANS.PLAN_TYPE_CODE = 'FORECAST' AND
  PLAN_GROUP.NAME = 'Charge Codes' AND
  PLANS.IS_PLAN_OF_RECORD = 1