SELECT
  PORTFOLIO_ID,
  PORTFOLIO_NAME,
  PORTFOLIO_START_DT,
  PORTFOLIO_FINISH_DT,
  PORTFOLIO_BUDGET,
  PORTFOLIO_BUDGET_m,
  EXECUTIVE_ID,
  BUCIO_GROUP_ID,
  INVESTMENT_PRID,
  INVESTMENT_ID,
  CHILD_INVESTMENT_ID,
  ENTITY_CODE,
  INVESTMENT_NAME,
  CHILD_INVESTMENT_NAME,
  INVESTMENT_TYPE,
  IS_ACTIVE,
  IS_ACTIVE_BOOL,
  MANAGER_ID,
  PRIORITY,
  PROGRESS_CODE,
  PROGRESS_NAME,
  MANAGER_NAME,
  OPEN_FOR_TE,
  OPEN_FOR_TE_BOOL,
  PROJECT_TYPE,
  PROJECT_TYPE_ID,
  ROW_TYPE,
  -- costs
  SUBMITTED_BUDGET_LABOR_COST,
  BUDGET_LABOR_COST,
  YTD_BUDGET_LABOR_COST,
  FORECAST_LABOR_COST,
  CASE
    WHEN PROJECTCLASS IN ('FIXED','BASELINE') THEN YTD_BUDGET_LABOR_COST
    ELSE ACTUAL_LABOR_COST
  END ACTUAL_LABOR_COST,
  BUDGET_FORECAST_LABOR_VAR,
  CASE
    WHEN PROJECTCLASS IN ('FIXED','BASELINE') THEN BUDGET_LABOR_COST - YTD_BUDGET_LABOR_COST
    ELSE FORECAST_ACTUAL_LABOR_VAR
  END FORECAST_ACTUAL_LABOR_VAR
  
FROM (

SELECT
  PORTFOLIO_ID,
  PORTFOLIO_NAME,
  PORTFOLIO_START_DT,
  PORTFOLIO_FINISH_DT,
  PORTFOLIO_BUDGET,
  PORTFOLIO_BUDGET_m,
  EXECUTIVE_ID,
  BUCIO_GROUP_ID,
  PROJECTCLASS,
  INVESTMENT_PRID,
  INVESTMENT_ID,
  CHILD_INVESTMENT_ID,
  CASE WHEN ROW_TYPE = 'PARENT' THEN ENTITY_CODE ELSE CHILD_ENTITY_CODE END ENTITY_CODE,
  INVESTMENT_NAME,
  CHILD_INVESTMENT_NAME,
  CASE WHEN ROW_TYPE = 'PARENT' THEN INVESTMENT_TYPE ELSE CHILD_INVESTMENT_TYPE END INVESTMENT_TYPE,
  CASE WHEN ROW_TYPE = 'PARENT' THEN IS_ACTIVE ELSE CHILD_IS_ACTIVE END IS_ACTIVE,
  CASE WHEN ROW_TYPE = 'PARENT' THEN IS_ACTIVE_BOOL ELSE CHILD_IS_ACTIVE_BOOL END IS_ACTIVE_BOOL,
  CASE WHEN ROW_TYPE = 'PARENT' THEN MANAGER_ID ELSE CHILD_MANAGER_ID END MANAGER_ID,
  CASE WHEN ROW_TYPE = 'PARENT' THEN PRIORITY ELSE CHILD_PRIORITY END PRIORITY,
  CASE WHEN ROW_TYPE = 'PARENT' THEN PROGRESS_CODE ELSE CHILD_PROGRESS_CODE END PROGRESS_CODE,
  CASE WHEN ROW_TYPE = 'PARENT' THEN PROGRESS_NAME ELSE CHILD_PROGRESS_NAME END PROGRESS_NAME,
  CASE WHEN ROW_TYPE = 'PARENT' THEN MANAGER_NAME ELSE CHILD_MANAGER_NAME END MANAGER_NAME,
  CASE WHEN ROW_TYPE = 'PARENT' THEN OPEN_FOR_TE ELSE CHILD_OPEN_FOR_TE END OPEN_FOR_TE,
  CASE WHEN ROW_TYPE = 'PARENT' THEN OPEN_FOR_TE_BOOL ELSE CHILD_OPEN_FOR_TE_BOOL END OPEN_FOR_TE_BOOL,
  CASE WHEN ROW_TYPE = 'PARENT' THEN PROJECT_TYPE ELSE CHILD_PROJECT_TYPE END PROJECT_TYPE,
  CASE WHEN ROW_TYPE = 'PARENT' THEN PROJECT_TYPE_ID ELSE CHILD_PROJECT_TYPE_ID END PROJECT_TYPE_ID,
  ROW_TYPE,
  -- total costs
  SUM(FORECAST_TOTAL_COST) FORECAST_TOTAL_COST,
  SUM(BUDGET_TOTAL_COST) BUDGET_TOTAL_COST,
  SUM(SUBMITTED_BUDGET_TOTAL_COST) SUBMITTED_BUDGET_TOTAL_COST,
  SUM(ACTUAL_TOTAL_COST) ACTUAL_TOTAL_COST,
  -- submitted budget costs
  SUM(SUBMITTED_BUDGET_LABOR_COST) SUBMITTED_BUDGET_LABOR_COST,
  SUM(SUBMITTED_BUDGET_SOFTWARE_COST) SUBMITTED_BUDGET_SOFTWARE_COST,
  SUM(SUBMITTED_BUDGET_HARDWARE_COST) SUBMITTED_BUDGET_HARDWARE_COST,
  SUM(SUBMITTED_BUDGET_PROFSERV_COST) SUBMITTED_BUDGET_PROFSERV_COST,
  SUM(SUBMITTED_BUDGET_OTHER_COST) SUBMITTED_BUDGET_OTHER_COST,
  SUM(SUBMITTED_BUDGET_OTHERCOM_COST) SUBMITTED_BUDGET_OTHERCOM_COST,
  (SUM(SUBMITTED_BUDGET_LABOR_COST) + SUM(SUBMITTED_BUDGET_PROFSERV_COST)) SUBMITTED_BUDGET_CHARGE_COST,
  (SUM(SUBMITTED_BUDGET_SOFTWARE_COST) + SUM(SUBMITTED_BUDGET_HARDWARE_COST) + SUM(SUBMITTED_BUDGET_OTHER_COST) + SUM(SUBMITTED_BUDGET_OTHERCOM_COST)) SUBMITTED_BUDGET_SUMMARY_COST,
  -- budget costs
  SUM(BUDGET_LABOR_COST) BUDGET_LABOR_COST,
  SUM(BUDGET_SOFTWARE_COST) BUDGET_SOFTWARE_COST,
  SUM(BUDGET_HARDWARE_COST) BUDGET_HARDWARE_COST,
  SUM(BUDGET_PROFSERV_COST) BUDGET_PROFSERV_COST,
  SUM(BUDGET_OTHER_COST) BUDGET_OTHER_COST,
  SUM(BUDGET_OTHERCOM_COST) BUDGET_OTHERCOM_COST,
  (SUM(BUDGET_LABOR_COST) + SUM(BUDGET_PROFSERV_COST)) BUDGET_CHARGE_COST,
  (SUM(BUDGET_SOFTWARE_COST) + SUM(BUDGET_HARDWARE_COST) + SUM(BUDGET_OTHER_COST) + SUM(BUDGET_OTHERCOM_COST)) BUDGET_SUMMARY_COST,
  -- ytd budget costs
  SUM(YTD_BUDGET_LABOR_COST) YTD_BUDGET_LABOR_COST,
  SUM(YTD_BUDGET_SOFTWARE_COST) YTD_BUDGET_SOFTWARE_COST,
  SUM(YTD_BUDGET_HARDWARE_COST) YTD_BUDGET_HARDWARE_COST,
  SUM(YTD_BUDGET_PROFSERV_COST) YTD_BUDGET_PROFSERV_COST,
  SUM(YTD_BUDGET_OTHER_COST) YTD_BUDGET_OTHER_COST,
  SUM(YTD_BUDGET_OTHERCOM_COST) YTD_BUDGET_OTHERCOM_COST,
  (SUM(YTD_BUDGET_LABOR_COST) + SUM(YTD_BUDGET_PROFSERV_COST)) YTD_BUDGET_CHARGE_COST,
  (SUM(YTD_BUDGET_SOFTWARE_COST) + SUM(YTD_BUDGET_HARDWARE_COST) + SUM(YTD_BUDGET_OTHER_COST) + SUM(YTD_BUDGET_OTHERCOM_COST)) YTD_BUDGET_SUMMARY_COST,
  -- forecast costs
  SUM(FORECAST_LABOR_COST) FORECAST_LABOR_COST,
  SUM(FORECAST_SOFTWARE_COST) FORECAST_SOFTWARE_COST,
  SUM(FORECAST_HARDWARE_COST) FORECAST_HARDWARE_COST,
  SUM(FORECAST_PROFSERV_COST) FORECAST_PROFSERV_COST,
  SUM(FORECAST_OTHER_COST) FORECAST_OTHER_COST,
  SUM(FORECAST_OTHERCOM_COST) FORECAST_OTHERCOM_COST,
  (SUM(FORECAST_LABOR_COST) + SUM(FORECAST_PROFSERV_COST)) FORECAST_CHARGE_COST,
  (SUM(FORECAST_SOFTWARE_COST) + SUM(FORECAST_HARDWARE_COST) + SUM(FORECAST_OTHER_COST) + SUM(FORECAST_OTHERCOM_COST)) FORECAST_SUMMARY_COST,
  -- actual cost
  SUM(ACTUAL_LABOR_COST) ACTUAL_LABOR_COST,
  SUM(ACTUAL_SOFTWARE_COST) ACTUAL_SOFTWARE_COST,
  SUM(ACTUAL_HARDWARE_COST) ACTUAL_HARDWARE_COST,
  SUM(ACTUAL_PROFSERV_COST) ACTUAL_PROFSERV_COST,
  SUM(ACTUAL_OTHER_COST) ACTUAL_OTHER_COST,
  SUM(ACTUAL_OTHERCOM_COST) ACTUAL_OTHERCOM_COST,
  (SUM(ACTUAL_LABOR_COST) + SUM(ACTUAL_PROFSERV_COST)) ACTUAL_CHARGE_COST,
  (SUM(ACTUAL_SOFTWARE_COST) + SUM(ACTUAL_HARDWARE_COST) + SUM(ACTUAL_OTHER_COST) + SUM(ACTUAL_OTHERCOM_COST)) ACTUAL_SUMMARY_COST,
  -- actual cost for customer projects - external/non-ci projects
  CASE WHEN PROJECT_TYPE_ID IN 'Production_Support' THEN SUM(BUDGET_LABOR_COST) ELSE SUM(ACTUAL_LABOR_COST) END ACTUAL_EXT_LABOR_COST,
  SUM(ACTUAL_PROFSERV_COST) ACTUAL_EXT_PROFSERV_COST,
  CASE WHEN PROJECT_TYPE_ID IN 'Production_Support' THEN SUM(BUDGET_LABOR_COST) + SUM(ACTUAL_PROFSERV_COST) ELSE SUM(ACTUAL_LABOR_COST) END + SUM(ACTUAL_PROFSERV_COST) ACTUAL_EXT_CHARGE_COST,
  -- budget and forecast variance costs
  SUM(FORECAST_TOTAL_COST)-SUM(BUDGET_TOTAL_COST) BUDGET_FORECAST_TOTAL_VAR,
  SUM(FORECAST_LABOR_COST)-SUM(BUDGET_LABOR_COST) BUDGET_FORECAST_LABOR_VAR,    
  SUM(FORECAST_SOFTWARE_COST)-SUM(BUDGET_SOFTWARE_COST) BUDGET_FORECAST_SOFTWARE_VAR,
  SUM(FORECAST_HARDWARE_COST)-SUM(BUDGET_HARDWARE_COST) BUDGET_FORECAST_HARDWARE_VAR,
  SUM(FORECAST_PROFSERV_COST)-SUM(BUDGET_PROFSERV_COST) BUDGET_FORECAST_PROFSERV_VAR,
  SUM(FORECAST_OTHER_COST)-SUM(BUDGET_OTHER_COST) BUDGET_FORECAST_OTHER_VAR,
  SUM(FORECAST_OTHERCOM_COST)-SUM(BUDGET_OTHERCOM_COST) BUDGET_FORECAST_OTHERCOM_VAR,
  (SUM(FORECAST_LABOR_COST) + SUM(FORECAST_PROFSERV_COST))-(SUM(BUDGET_LABOR_COST) + SUM(BUDGET_PROFSERV_COST)) BUDGET_FORECAST_CHARGE_VAR,
  -- forecast and actual variance costs
  SUM(FORECAST_TOTAL_COST) - SUM(ACTUAL_TOTAL_COST) FORECAST_ACTUAL_TOTAL_VAR,
  SUM(FORECAST_LABOR_COST) - SUM(ACTUAL_LABOR_COST) FORECAST_ACTUAL_LABOR_VAR,    
  SUM(FORECAST_SOFTWARE_COST) - SUM(ACTUAL_SOFTWARE_COST) FORECAST_ACTUAL_SOFTWARE_VAR,
  SUM(FORECAST_HARDWARE_COST) - SUM(ACTUAL_HARDWARE_COST) FORECAST_ACTUAL_HARDWARE_VAR,
  SUM(FORECAST_PROFSERV_COST) - SUM(ACTUAL_PROFSERV_COST) FORECAST_ACTUAL_PROFSERV_VAR,
  SUM(FORECAST_OTHER_COST) - SUM(ACTUAL_OTHER_COST) FORECAST_ACTUAL_OTHER_VAR,
  SUM(FORECAST_OTHERCOM_COST) - SUM(ACTUAL_OTHERCOM_COST) FORECAST_ACTUAL_OTHERCOM_VAR,
  (SUM(FORECAST_LABOR_COST) + SUM(FORECAST_PROFSERV_COST)) - (SUM(ACTUAL_LABOR_COST) + SUM(ACTUAL_PROFSERV_COST)) FORECAST_ACTUAL_CHARGE_VAR
FROM (

SELECT 
  DEPARTMENTS.BRM_ID EXECUTIVE_ID,
  DEPARTMENT_DETAILS.BUCIO_GROUP BUCIO_GROUP_ID,
  PROJECTS.CLASS PROJECTCLASS,
  PROJECTS.WIPCLASS,
  P_CONTENTS.PORTFOLIO_ID PORTFOLIO_ID,
  PORTFOLIOS.NAME PORTFOLIO_NAME,
  PORTFOLIOS.START_DATE PORTFOLIO_START_DT,
  PORTFOLIOS.FINISH_DATE PORTFOLIO_FINISH_DT,
  PORTFOLIOS.BDGT_CST_TOTAL PORTFOLIO_BUDGET,
  (NVL(PORTFOLIOS.BDGT_CST_TOTAL,0)) PORTFOLIO_BUDGET_m,
  INVESTMENTS.ID INVESTMENT_PRID, 
  PROJECT_FINANCIALS.CHILD_ID,
  INVESTMENTS.CODE INVESTMENT_ID,
  CHILD_INVESTMENTS.CODE CHILD_INVESTMENT_ID,
  INVESTMENTS.ENTITY_CODE ENTITY_CODE,
  CHILD_INVESTMENTS.ENTITY_CODE CHILD_ENTITY_CODE,
  INVESTMENTS.NAME INVESTMENT_NAME,
  CHILD_INVESTMENTS.NAME CHILD_INVESTMENT_NAME,
  INVESTMENTS.ODF_OBJECT_CODE INVESTMENT_TYPE,
  CHILD_INVESTMENTS.ODF_OBJECT_CODE CHILD_INVESTMENT_TYPE,
  INVESTMENTS.IS_ACTIVE IS_ACTIVE,
  CHILD_INVESTMENTS.IS_ACTIVE CHILD_IS_ACTIVE,
  INVESTMENTS.IS_ACTIVE IS_ACTIVE_BOOL,
  CHILD_INVESTMENTS.IS_ACTIVE CHILD_IS_ACTIVE_BOOL,
  INVESTMENTS.MANAGER_ID MANAGER_ID,
  CHILD_INVESTMENTS.MANAGER_ID CHILD_MANAGER_ID,
  INVESTMENTS.PRIORITY PRIORITY,
  CHILD_INVESTMENTS.PRIORITY CHILD_PRIORITY,
  INVESTMENTS.PROGRESS PROGRESS_CODE,
  CHILD_INVESTMENTS.PROGRESS CHILD_PROGRESS_CODE,
  PROGRESS_LOOKUP.NAME PROGRESS_NAME,
  CHILD_PROGRESS_LOOKUP.NAME CHILD_PROGRESS_NAME,
  PROJECT_MANAGERS.FULL_NAME MANAGER_NAME,
  CHILD_PROJECT_MANAGERS.FULL_NAME CHILD_MANAGER_NAME,
  INVESTMENTS.IS_OPEN_FOR_TE OPEN_FOR_TE,
  CHILD_INVESTMENTS.IS_OPEN_FOR_TE CHILD_OPEN_FOR_TE,
  INVESTMENTS.IS_OPEN_FOR_TE OPEN_FOR_TE_BOOL,
  CHILD_INVESTMENTS.IS_OPEN_FOR_TE CHILD_OPEN_FOR_TE_BOOL,
  ODF_PROJ.OBJ_REQUEST_TYPE OBJ_REQUEST_TYPE,
  CHILD_ODF_PROJ.OBJ_REQUEST_TYPE CHILD_OBJ_REQUEST_TYPE,
  PROJ_TYPE.ID PROJECT_TYPE_ID,
  CHILD_PROJ_TYPE.ID CHILD_PROJECT_TYPE_ID,
  PROJ_TYPE.NAME PROJECT_TYPE,
  CHILD_PROJ_TYPE.NAME CHILD_PROJECT_TYPE,
  -- total costs
  FORECAST_TOTAL_COST,
  BUDGET_TOTAL_COST,
  SUBMITTED_BUDGET_TOTAL_COST,
  ACTUAL_TOTAL_COST,
  -- submitted budget costs
  SUBMITTED_BUDGET_LABOR_COST,
  SUBMITTED_BUDGET_SOFTWARE_COST,
  SUBMITTED_BUDGET_HARDWARE_COST,
  SUBMITTED_BUDGET_PROFSERV_COST,
  SUBMITTED_BUDGET_OTHER_COST,
  SUBMITTED_BUDGET_OTHERCOM_COST,
  -- budget costs
  BUDGET_LABOR_COST,
  BUDGET_SOFTWARE_COST,
  BUDGET_HARDWARE_COST,
  BUDGET_PROFSERV_COST,
  BUDGET_OTHER_COST,
  BUDGET_OTHERCOM_COST,
  -- ytd budget costs
  YTD_BUDGET_LABOR_COST,
  YTD_BUDGET_SOFTWARE_COST,
  YTD_BUDGET_HARDWARE_COST,
  YTD_BUDGET_PROFSERV_COST,
  YTD_BUDGET_OTHER_COST,
  YTD_BUDGET_OTHERCOM_COST,
  -- forecast costs
  FORECAST_LABOR_COST,
  FORECAST_SOFTWARE_COST,
  FORECAST_HARDWARE_COST,
  FORECAST_PROFSERV_COST,
  FORECAST_OTHER_COST,
  FORECAST_OTHERCOM_COST,
  -- actual cost
  ACTUAL_LABOR_COST,
  ACTUAL_SOFTWARE_COST,
  ACTUAL_HARDWARE_COST,
  ACTUAL_PROFSERV_COST,
  ACTUAL_OTHER_COST,
  ACTUAL_OTHERCOM_COST,
  -- row type
  PROJECT_FINANCIALS.ROW_TYPE
FROM
  WARM01.PMA_PORTFOLIO_CONTENTS P_CONTENTS,
  WARM01.PMA_PORTFOLIOS PORTFOLIOS,
  WARM01.INV_INVESTMENTS INVESTMENTS,
  WARM01.INV_INVESTMENTS CHILD_INVESTMENTS,
  WARM01.SRM_RESOURCES PROJECT_MANAGERS,
  WARM01.SRM_RESOURCES CHILD_PROJECT_MANAGERS,
  WARM01.ODF_CA_PROJECT ODF_PROJ,
  WARM01.ODF_CA_PROJECT CHILD_ODF_PROJ,
  WARM01.PAC_MNT_PROJECTS PROJECTS,
  WARM01.DEPARTMENTS DEPARTMENTS,
  WARM01.ODF_CA_DEPARTMENT DEPARTMENT_DETAILS,
  (SELECT LOOKUP_CODE ID,NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='OBJ_IDEA_PROJECT_TYPE' AND LANGUAGE_CODE='en') PROJ_TYPE,
  (SELECT LOOKUP_CODE ID,NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='OBJ_IDEA_PROJECT_TYPE' AND LANGUAGE_CODE='en') CHILD_PROJ_TYPE,
  (SELECT LOOKUP_ENUM ID, NAME NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='INVESTMENT_OBJ_PROGRESS' AND LANGUAGE_CODE='en') PROGRESS_LOOKUP,
  (SELECT LOOKUP_ENUM ID, NAME NAME FROM WARM01.CMN_LOOKUPS_V WHERE LOOKUP_TYPE='INVESTMENT_OBJ_PROGRESS' AND LANGUAGE_CODE='en') CHILD_PROGRESS_LOOKUP,
  (
    SELECT INVESTMENTS.ID PROJECT_ID,
           INVESTMENTS.ID CHILD_ID,
           COSTS.START_DATE,
           -- total costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_TOTAL_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_TOTAL_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_TOTAL_COST,
           0 ACTUAL_TOTAL_COST,
           -- submitted budget costs
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Labor' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_LABOR_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Software' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_SOFTWARE_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Hardware' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_HARDWARE_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'ProfServ' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_PROFSERV_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Other' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_OTHER_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'OtherCom' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END SUBMITTED_BUDGET_OTHERCOM_COST,
           -- budget costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND CLASSES.TRANSCLASS = 'Labor' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_LABOR_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND CLASSES.TRANSCLASS = 'Software' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_SOFTWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND CLASSES.TRANSCLASS = 'Hardware' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_HARDWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND CLASSES.TRANSCLASS = 'ProfServ' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_PROFSERV_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND CLASSES.TRANSCLASS = 'Other' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_OTHER_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND CLASSES.TRANSCLASS = 'OtherCom' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END BUDGET_OTHERCOM_COST,
           -- ytd budget costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Labor' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END YTD_BUDGET_LABOR_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Software' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END YTD_BUDGET_SOFTWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Hardware' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END YTD_BUDGET_HARDWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'ProfServ' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END YTD_BUDGET_PROFSERV_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Other' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END YTD_BUDGET_OTHER_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'OtherCom' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END YTD_BUDGET_OTHERCOM_COST,
           -- forecast costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Labor' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_LABOR_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Software' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_SOFTWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Hardware' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_HARDWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'ProfServ' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_PROFSERV_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Other' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_OTHER_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'OtherCom' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2) ELSE 0 END FORECAST_OTHERCOM_COST,
           -- actual cost
           0 ACTUAL_LABOR_COST,
           0 ACTUAL_SOFTWARE_COST,
           0 ACTUAL_HARDWARE_COST,
           0 ACTUAL_PROFSERV_COST,
           0 ACTUAL_OTHER_COST,
           0 ACTUAL_OTHERCOM_COST,
           -- row type
           'PARENT' ROW_TYPE
      FROM WARM01.ODF_SSL_CST_DTL_COST COSTS,
           WARM01.FIN_COST_PLAN_DETAILS DETAILS,
           WARM01.TRANSCLASS CLASSES,
           WARM01.FIN_PLANS PLANS,
           WARM01.INV_INVESTMENTS INVESTMENTS,
           (SELECT MAX (P.ID) ID
              FROM WARM01.FIN_PLANS P
             WHERE SUBSTR (P.NAME, 6, 9) IN ('Submitted', 'submitted')
                   AND P.PLAN_TYPE_CODE = 'BUDGET'
                   AND P.STATUS_CODE NOT IN ('SUBMITTED','REJECTED')
             GROUP BY P.OBJECT_ID) SUBMITTED
     WHERE     PLANS.ID = DETAILS.PLAN_ID
           AND DETAILS.ID = COSTS.PRJ_OBJECT_ID(+)
           AND PLANS.ID = SUBMITTED.ID(+)
           AND DETAILS.TRANSCLASS_ID = CLASSES.ID
           AND PLANS.OBJECT_ID = INVESTMENTS.ID
           AND PLANS.OBJECT_ID NOT IN (SELECT CHILD_ID FROM WARM01.INV_HIERARCHIES HIERARCHIES WHERE PARENT_ID IS NOT NULL)
         AND TO_CHAR(COSTS.START_DATE,'YYYY') = TO_CHAR({?date_param},'YYYY')
           
    UNION ALL
    
    SELECT WIP.INVESTMENT_ID,
           WIP.INVESTMENT_ID,
           WIP.MONTH_BEGIN,
           -- total costs
           0 TOTAL_PLAN_COST,
           0 TOTAL_BUDGET_COST,
           0 SUBMITTED_TOTAL_BUDGET_COST,
           NVL(WIP_VALUES.TOTALCOST,0) TOTAL_ACTUAL_COST,
           -- submitted_budget costs
           0 SUBMITTED_BUDGET_LABOR_COST,
           0 SUBMITTED_BUDGET_SOFTWARE_COST,
           0 SUBMITTED_BUDGET_HARDWARE_COST,
           0 SUBMITTED_BUDGET_PROFSERV_COST,
           0 SUBMITTED_BUDGET_OTHER_COST,
           0 SUBMITTED_BUDGET_OTHERCOM_COST,
           -- budget costs
           0 BUDGET_LABOR_COST,
           0 BUDGET_SOFTWARE_COST,
           0 BUDGET_HARDWARE_COST,
           0 BUDGET_PROFSERV_COST,
           0 BUDGET_OTHER_COST,
           0 BUDGET_OTHERCOM_COST,
           -- ytd budget costs
           0 YTD_BUDGET_LABOR_COST,
           0 YTD_BUDGET_SOFTWARE_COST,
           0 YTD_BUDGET_HARDWARE_COST,
           0 YTD_BUDGET_PROFSERV_COST,
           0 YTD_BUDGET_OTHER_COST,
           0 YTD_BUDGET_OTHERCOM_COST,
           -- forecast costs
           0 FORECAST_LABOR_COST,
           0 FORECAST_SOFTWARE_COST,
           0 FORECAST_HARDWARE_COST,
           0 FORECAST_PROFSERV_COST,
           0 FORECAST_OTHER_COST,
           0 FORECAST_OTHERCOM_COST,
           -- actual cost
           CASE WHEN WIP.TRANSCLASS = 'Labor' THEN NVL(WIP_VALUES.TOTALCOST,0) ELSE 0 END ACTUAL_LABOR_COST,
           CASE WHEN WIP.TRANSCLASS = 'Software' THEN NVL(WIP_VALUES.TOTALCOST,0) ELSE 0 END ACTUAL_SOFTWARE_COST,
           CASE WHEN WIP.TRANSCLASS = 'Hardware' THEN NVL(WIP_VALUES.TOTALCOST,0) ELSE 0 END ACTUAL_HARDWARE_COST,
           CASE WHEN WIP.TRANSCLASS = 'ProfServ' THEN NVL(WIP_VALUES.TOTALCOST,0) ELSE 0 END ACTUAL_PROFSERV_COST,
           CASE WHEN WIP.TRANSCLASS = 'Other' THEN NVL(WIP_VALUES.TOTALCOST,0) ELSE 0 END ACTUAL_OTHER_COST,
           CASE WHEN WIP.TRANSCLASS = 'OtherCom' THEN NVL(WIP_VALUES.TOTALCOST,0) ELSE 0 END ACTUAL_OTHERCOM_COST,
           -- row type
           'PARENT' ROW_TYPE
      FROM WARM01.PPA_WIP_VALUES WIP_VALUES, WARM01.PPA_WIP WIP
     WHERE     WIP_VALUES.TRANSNO = WIP.TRANSNO
           AND WIP.INVESTMENT_ID NOT IN (SELECT CHILD_ID FROM WARM01.INV_HIERARCHIES HIERARCHIES WHERE PARENT_ID IS NOT NULL)
           AND WIP.STATUS NOT IN (2, 8)
           AND WIP_VALUES.CURRENCY_TYPE = 'BILLING'
           AND TO_CHAR(WIP.MONTH_BEGIN,'YYYY') = TO_CHAR({?date_param},'YYYY')
           AND TO_CHAR(WIP.MONTH_BEGIN,'MM') <= TO_CHAR({?date_param},'MM')
     
    UNION ALL
 
    SELECT HIERARCHIES.PARENT_ID PROJECT_ID,
           HIERARCHIES.CHILD_ID,
           COSTS.START_DATE,
           -- total costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_TOTAL_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_TOTAL_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_TOTAL_COST,
           0 ACTUAL_TOTAL_COST,
           -- submitted budget costs
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Labor' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_LABOR_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Software' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_SOFTWARE_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Hardware' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_HARDWARE_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'ProfServ' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_PROFSERV_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'Other' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_OTHER_COST,
           CASE WHEN PLANS.ID = SUBMITTED.ID AND CLASSES.TRANSCLASS = 'OtherCom' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END SUBMITTED_BUDGET_OTHERCOM_COST,
           -- budget costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Labor' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_LABOR_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Software' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_SOFTWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Hardware' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_HARDWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'ProfServ' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_PROFSERV_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'Other' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_OTHER_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND CLASSES.TRANSCLASS = 'OtherCom' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END BUDGET_OTHERCOM_COST,
           -- ytd budget costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Labor' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END YTD_BUDGET_LABOR_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Software' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END YTD_BUDGET_SOFTWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Hardware' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END YTD_BUDGET_HARDWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'ProfServ' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END YTD_BUDGET_PROFSERV_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'Other' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END YTD_BUDGET_OTHER_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET' AND PLANS.IS_PLAN_OF_RECORD = 1 AND TO_CHAR(COSTS.START_DATE,'MM') <= TO_CHAR({?date_param},'MM') AND CLASSES.TRANSCLASS = 'OtherCom' THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END YTD_BUDGET_OTHERCOM_COST,
           -- forecast costs
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND CLASSES.TRANSCLASS = 'Labor' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_LABOR_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND CLASSES.TRANSCLASS = 'Software' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_SOFTWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND CLASSES.TRANSCLASS = 'Hardware' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_HARDWARE_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND CLASSES.TRANSCLASS = 'ProfServ' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_PROFSERV_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND CLASSES.TRANSCLASS = 'Other' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_OTHER_COST,
           CASE WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST' AND CLASSES.TRANSCLASS = 'OtherCom' AND PLANS.IS_PLAN_OF_RECORD = 1 THEN ROUND(COSTS.SLICE*(TO_DATE(COSTS.FINISH_DATE)-TO_DATE(COSTS.START_DATE)),2)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END FORECAST_OTHERCOM_COST,
           -- actual cost
           0 ACTUAL_LABOR_COST,
           0 ACTUAL_SOFTWARE_COST,
           0 ACTUAL_HARDWARE_COST,
           0 ACTUAL_PROFSERV_COST,
           0 ACTUAL_OTHER_COST,
           0 ACTUAL_OTHERCOM_COST,
           -- row type
           'CHILD' ROW_TYPE
      FROM WARM01.ODF_SSL_CST_DTL_COST COSTS,
           WARM01.FIN_COST_PLAN_DETAILS DETAILS,
           WARM01.TRANSCLASS CLASSES,
           WARM01.FIN_PLANS PLANS,
           WARM01.INV_INVESTMENTS INVESTMENTS,
           WARM01.INV_HIERARCHIES HIERARCHIES,
           (SELECT MAX (P.ID) ID
              FROM WARM01.FIN_PLANS P
             WHERE SUBSTR (P.NAME, 6, 9) IN ('Submitted', 'submitted')
                   AND P.PLAN_TYPE_CODE = 'BUDGET'
                   AND P.STATUS_CODE NOT IN ('SUBMITTED','REJECTED')
             GROUP BY P.OBJECT_ID) SUBMITTED
     WHERE     PLANS.ID = DETAILS.PLAN_ID
           AND DETAILS.ID = COSTS.PRJ_OBJECT_ID(+)
           AND PLANS.ID = SUBMITTED.ID(+)
           AND DETAILS.TRANSCLASS_ID = CLASSES.ID
           AND PLANS.OBJECT_ID = INVESTMENTS.ID
           AND INVESTMENTS.ID = HIERARCHIES.CHILD_ID
           AND HIERARCHIES.PARENT_ID IS NOT NULL
           AND TO_CHAR(COSTS.START_DATE,'YYYY') = TO_CHAR({?date_param},'YYYY')
           
    UNION ALL
    
    SELECT HIERARCHIES.PARENT_ID,
           HIERARCHIES.CHILD_ID,
           WIP.MONTH_BEGIN,
           -- total costs
           0 TOTAL_PLAN_COST,
           0 TOTAL_BUDGET_COST,
           0 SUBMITTED_TOTAL_BUDGET_COST,
           NVL(WIP_VALUES.TOTALCOST,0) TOTAL_ACTUAL_COST,
           -- submitted_budget costs
           0 SUBMITTED_BUDGET_LABOR_COST,
           0 SUBMITTED_BUDGET_SOFTWARE_COST,
           0 SUBMITTED_BUDGET_HARDWARE_COST,
           0 SUBMITTED_BUDGET_PROFSERV_COST,
           0 SUBMITTED_BUDGET_OTHER_COST,
           0 SUBMITTED_BUDGET_OTHERCOM_COST,
           -- budget costs
           0 BUDGET_LABOR_COST,
           0 BUDGET_SOFTWARE_COST,
           0 BUDGET_HARDWARE_COST,
           0 BUDGET_PROFSERV_COST,
           0 BUDGET_OTHER_COST,
           0 BUDGET_OTHERCOM_COST,
           -- ytd budget costs
           0 YTD_BUDGET_LABOR_COST,
           0 YTD_BUDGET_SOFTWARE_COST,
           0 YTD_BUDGET_HARDWARE_COST,
           0 YTD_BUDGET_PROFSERV_COST,
           0 YTD_BUDGET_OTHER_COST,
           0 YTD_BUDGET_OTHERCOM_COST,
           -- forecast costs
           0 FORECAST_LABOR_COST,
           0 FORECAST_SOFTWARE_COST,
           0 FORECAST_HARDWARE_COST,
           0 FORECAST_PROFSERV_COST,
           0 FORECAST_OTHER_COST,
           0 FORECAST_OTHERCOM_COST,
           -- actual cost
           CASE WHEN WIP.TRANSCLASS = 'Labor' THEN NVL(WIP_VALUES.TOTALCOST,0)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END ACTUAL_LABOR_COST,
           CASE WHEN WIP.TRANSCLASS = 'Software' THEN NVL(WIP_VALUES.TOTALCOST,0)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END ACTUAL_SOFTWARE_COST,
           CASE WHEN WIP.TRANSCLASS = 'Hardware' THEN NVL(WIP_VALUES.TOTALCOST,0)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END ACTUAL_HARDWARE_COST,
           CASE WHEN WIP.TRANSCLASS = 'ProfServ' THEN NVL(WIP_VALUES.TOTALCOST,0)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END ACTUAL_PROFSERV_COST,
           CASE WHEN WIP.TRANSCLASS = 'Other' THEN NVL(WIP_VALUES.TOTALCOST,0)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END ACTUAL_OTHER_COST,
           CASE WHEN WIP.TRANSCLASS = 'OtherCom' THEN NVL(WIP_VALUES.TOTALCOST,0)*HIERARCHIES.DEFAULT_ALLOC_PCT ELSE 0 END ACTUAL_OTHERCOM_COST,
           -- row type
           'CHILD' ROW_TYPE
      FROM WARM01.PPA_WIP_VALUES WIP_VALUES, 
           WARM01.PPA_WIP WIP,
           WARM01.INV_HIERARCHIES HIERARCHIES
     WHERE     WIP_VALUES.TRANSNO = WIP.TRANSNO
           AND WIP.INVESTMENT_ID = HIERARCHIES.CHILD_ID
           AND HIERARCHIES.PARENT_ID IS NOT NULL
           AND WIP.STATUS NOT IN (2, 8)
           AND WIP_VALUES.CURRENCY_TYPE = 'BILLING'
           AND TO_CHAR(MONTH_BEGIN,'YYYY') = TO_CHAR({?date_param},'YYYY')
           AND TO_CHAR(MONTH_BEGIN,'MM') <= TO_CHAR({?date_param},'MM')
     
        ) PROJECT_FINANCIALS
WHERE 
  P_CONTENTS.INVEST_ID = INVESTMENTS.ID
  AND PORTFOLIOS.ID = P_CONTENTS.PORTFOLIO_ID
  AND INVESTMENTS.PROGRESS = PROGRESS_LOOKUP.ID    
  AND INVESTMENTS.MANAGER_ID = PROJECT_MANAGERS.USER_ID(+)
  AND INVESTMENTS.ID = ODF_PROJ.ID
  AND ODF_PROJ.OBJ_REQUEST_TYPE = PROJ_TYPE.ID(+)
  AND INVESTMENTS.ID = PROJECT_FINANCIALS.PROJECT_ID(+)
  AND INVESTMENTS.ID = PROJECTS.ID(+)
  AND PROJECTS.DEPARTCODE = DEPARTMENTS.DEPARTCODE(+)
  AND DEPARTMENTS.ID = DEPARTMENT_DETAILS.ID
  AND PROJECT_FINANCIALS.CHILD_ID = CHILD_INVESTMENTS.ID
  AND CHILD_INVESTMENTS.MANAGER_ID = CHILD_PROJECT_MANAGERS.USER_ID(+)
  AND CHILD_INVESTMENTS.ID = CHILD_ODF_PROJ.ID
  AND CHILD_ODF_PROJ.OBJ_REQUEST_TYPE = CHILD_PROJ_TYPE.ID(+)
  AND CHILD_INVESTMENTS.PROGRESS = CHILD_PROGRESS_LOOKUP.ID   
  AND PROJECT_FINANCIALS.START_DATE BETWEEN PORTFOLIOS.START_DATE AND PORTFOLIOS.FINISH_DATE-1
  AND (
        PORTFOLIOS.ID = CASE WHEN {?portfolio_id} = 0 THEN 5008000 ELSE {?portfolio_id} END
      )
  AND (
        PROJECT_MANAGERS.USER_ID = CASE WHEN {?manager_id} = 0 THEN PROJECT_MANAGERS.USER_ID ELSE {?manager_id} END
      )
  AND (
        NVL(DEPARTMENT_DETAILS.BUCIO_GROUP,0) = CASE WHEN {?bucio_id} = 0 THEN NVL(DEPARTMENT_DETAILS.BUCIO_GROUP,0) ELSE {?bucio_id} END
      )
  AND (
        NVL(DEPARTMENTS.BRM_ID,0) = CASE WHEN {?exec_id} = 0 THEN NVL(DEPARTMENTS.BRM_ID,0) ELSE {?exec_id} END
      )
)
GROUP BY
  PORTFOLIO_ID,
  PORTFOLIO_NAME,
  PORTFOLIO_START_DT,
  PORTFOLIO_FINISH_DT,
  PORTFOLIO_BUDGET,
  PORTFOLIO_BUDGET_m,
  EXECUTIVE_ID,
  BUCIO_GROUP_ID,
  PROJECTCLASS,
  INVESTMENT_PRID,
  CHILD_INVESTMENT_ID,
  INVESTMENT_ID,
  ENTITY_CODE,
  CHILD_ENTITY_CODE,
  INVESTMENT_NAME,
  CHILD_INVESTMENT_NAME,
  INVESTMENT_TYPE,
  CHILD_INVESTMENT_TYPE,
  IS_ACTIVE,
  CHILD_IS_ACTIVE,
  IS_ACTIVE_BOOL,
  CHILD_IS_ACTIVE_BOOL,
  MANAGER_ID,
  CHILD_MANAGER_ID,
  PRIORITY,
  CHILD_PRIORITY,
  PROGRESS_CODE,
  CHILD_PROGRESS_CODE,
  PROGRESS_NAME,
  CHILD_PROGRESS_NAME,
  MANAGER_NAME,
  CHILD_MANAGER_NAME,
  OPEN_FOR_TE,
  CHILD_OPEN_FOR_TE,
  OPEN_FOR_TE_BOOL,
  CHILD_OPEN_FOR_TE_BOOL,
  PROJECT_TYPE_ID,
  CHILD_PROJECT_TYPE_ID,
  PROJECT_TYPE,
  CHILD_PROJECT_TYPE,
  ROW_TYPE
ORDER BY
  INVESTMENT_ID,ROW_TYPE DESC)