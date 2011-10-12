SELECT CASE
          WHEN     (PROJECT_DPT_TXT IS NULL OR R.COST_CENTER IS NULL)
               AND PROJ_TP_NM IS NULL
               AND CBK_PRD_CD IS NULL
          THEN
             'Invalid project cost center | Invalid project type | Missing product code'
          WHEN (PROJECT_DPT_TXT IS NULL OR R.COST_CENTER IS NULL)
               AND PROJ_TP_NM IS NULL
          THEN
             'Invalid project cost center | Invalid project type'
          WHEN (PROJECT_DPT_TXT IS NULL OR R.COST_CENTER IS NULL)
               AND CBK_PRD_CD IS NULL
          THEN
             'Invalid project cost center | Missing product code'
          WHEN PROJ_TP_NM IS NULL AND CBK_PRD_CD IS NULL
          THEN
             'Invalid project type | Missing product code'
          WHEN (PROJECT_DPT_TXT IS NULL OR R.COST_CENTER IS NULL)
          THEN
             'Invalid project cost center'
          WHEN PROJ_TP_NM IS NULL
          THEN
             'Invalid project type'
          WHEN CBK_PRD_CD IS NULL
          THEN
             'Missing product code'
          ELSE
             NULL
       END
          ERROR_MSG,
       CBK_ROW_TYPE,
       CYCLE_TYPE,
       CYCLE_DATE,
       CYCLE_YR_NO,
       CYCLE_DY_OF_MO_NO,
       GL_IR,
       CBK_IR,
       CBK_PRD_CD,
       CBK_PRD_NM,
       G.CODE CBK_ITEM_CD,
       G.NAME CBK_ITEM_NAME,
       PRODUCT_NM_ALIAS,
       COST_TYPE,
       GL_ACCT_ID,
       VCH_PRD_SHRT_DN,
       TRANSACTION_CLASS,
       TRANSACTION_NO,
       TRANSACTION_DATE,
       PROJECT_ID,
       PROJECT_NAME,
       PROJECT_TASK_NAME,
       PROJECT_MANAGER,
       PROJECT_ACTIVE_IR,
       PROJECT_CC_CD,
       PROJECT_DPT_TXT,
       PROJ_TP_NM,
       UNITS,
       BILLRATE,
       AMOUNT,
       RESOURCE_ID,
       RESOURCE_NAME,
       RESOURCE_MANAGER,
       RESOURCE_ROLE,
       RESOURCE_EXTERNAL_IR,
       RESOURCE_EMAIL,
       USER_NAME,
       RESOURCE_CC_CD,
       RESOURCE_DPT_TXT,
       PERSONNEL_ID,
       SAP_ID,
       TIME_REPORT_ID
  FROM (SELECT 'CHARGEBACK' CBK_ROW_TYPE,
               TO_CHAR (SYSDATE, 'YYYYMMDD') CYCLE_DATE,
               -- project facts
               WIP.PROJECT_CODE PROJECT_ID,
               CURRENT_PROJECTS.NAME PROJECT_NAME,
               TASKS.PRNAME PROJECT_TASK_NAME,
               PROJECT_MANAGERS.FULL_NAME PROJECT_MANAGER,
               CURRENT_PROJECTS.IS_ACTIVE PROJECT_ACTIVE_IR,
               WIP.PROJECT_DEPARTMENT PROJECT_CC_CD,
               WIP.QUANTITY UNITS,
               WIP_VALUES.BILLRATE,
               WIP_VALUES.AMOUNT,
               WIP.TRANSCLASS TRANSACTION_CLASS,
               WIP.TRANSDATE TRANSACTION_DATE,
               WIP.TRANSNO TRANSACTION_NO,
               CASE
                  WHEN PROJECT_CC.UNIQUE_NAME IN ('cid_external') THEN 'Y'
                  ELSE 'N'
               END
                  GL_IR,
               NULL TIER_NM,
               CASE
                  WHEN PROJECT_CC.UNIQUE_NAME IN ('cid_external') THEN 'Y'
                  ELSE 'N'
               END
                  CBK_IR,
               NULL ADJ_TXT,
               BUSINESS_UNIT.NAME PROJECT_DPT_TXT,
               PROJECT_TYPES.NAME PROJ_TP_NM,
               PROJECT_TYPES.LOOKUP_CODE PROJECT_TYPE_CODE,
               -- resource facts
               RESOURCES.UNIQUE_NAME RESOURCE_ID,
               RESOURCES.FULL_NAME RESOURCE_NAME,
               RESOURCE_MANAGERS.FULL_NAME RESOURCE_MANAGER,
               ROLES.FULL_NAME RESOURCE_ROLE,
               RESOURCES.IS_EXTERNAL RESOURCE_EXTERNAL_IR,
               USERS.USER_NAME,
               RESOURCE_UNIT.NAME RESOURCE_DPT_TXT,
               RESOURCE_CC.UNIQUE_NAME RESOURCE_CC_CD,
               RESOURCE_FACTS.PRUSERTEXT1 PERSONNEL_ID,
               RESOURCE_FACTS.PRUSERTEXT2 SAP_ID,
               RESOURCE_FACTS.PRUSERTEXT4 TIME_REPORT_ID,
               RESOURCES.EMAIL RESOURCE_EMAIL
          FROM WARM01.PPA_WIP WIP,
               WARM01.PPA_WIP_VALUES WIP_VALUES,
               WARM01.SRM_RESOURCES RESOURCES,
               WARM01.SRM_RESOURCES ROLES,
               WARM01.PRJ_RESOURCES RESOURCE_FACTS,
               WARM01.CMN_SEC_USERS USERS,
               WARM01.SRM_RESOURCES RESOURCE_MANAGERS,
               WARM01.SRM_RESOURCES PROJECT_MANAGERS,
               WARM01.INV_INVESTMENTS CURRENT_PROJECTS,
               WARM01.PRTASK TASKS,
               WARM01.ODF_CA_PROJECT PROJECT_FACTS,
               WARM01.DEPARTMENTS RESOURCE_DPT,
               WARM01.DEPARTMENTS PROJECT_DPT,
               (SELECT LOOKUP_CODE, NAME
                  FROM WARM01.CMN_LOOKUPS_V
                 WHERE LANGUAGE_CODE = 'en') PROJECT_TYPES,
               (SELECT UNIT_ID, UNIQUE_NAME, NAME
                  FROM WARM01.OBS_UNITS_V
                 WHERE DEPTH = 1 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') PROJECT_CC,
               (SELECT UNIT_ID, UNIQUE_NAME, NAME
                  FROM WARM01.OBS_UNITS_V
                 WHERE DEPTH = 5 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') RESOURCE_CC,
               (SELECT UNIT_ID, UNIQUE_NAME, NAME
                  FROM WARM01.OBS_UNITS_V
                 WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') BUSINESS_UNIT,
               (SELECT UNIT_ID, UNIQUE_NAME, NAME
                  FROM WARM01.OBS_UNITS_V
                 WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') RESOURCE_UNIT,
               (SELECT TO_CHAR (CYCLE_YR_NO)
                       || TO_CHAR (TO_DATE (CYCLE_DY_OF_MO_NO, 'MM'), 'MM')
                          CYCLE_DATE
                  FROM WARM01.ODF_CA_CID_FIN_CALENDAR
                 WHERE TO_CHAR (DT_VLU, 'YYYYMMDD') =
                          TO_CHAR (SYSDATE, 'YYYYMMDD')) CYCLES
         WHERE     WIP.RESOURCE_CODE = RESOURCES.UNIQUE_NAME
               AND WIP.ROLE_CODE = ROLES.UNIQUE_NAME(+)
               AND RESOURCES.USER_ID = USERS.ID
               AND RESOURCES.ID = RESOURCE_FACTS.PRID
               AND RESOURCES.MANAGER_ID = RESOURCE_MANAGERS.USER_ID(+)
               AND WIP.EMPLYHOMEDEPART = RESOURCE_DPT.DEPARTCODE
               AND WIP.PROJECT_DEPARTMENT = PROJECT_DPT.DEPARTCODE
               AND PROJECT_DPT.OBS_UNIT_ID = PROJECT_CC.UNIT_ID
               AND RESOURCE_DPT.OBS_UNIT_ID = RESOURCE_CC.UNIT_ID
               AND PROJECT_DPT.OBS_UNIT_ID = BUSINESS_UNIT.UNIT_ID(+)
               AND RESOURCE_DPT.OBS_UNIT_ID = RESOURCE_UNIT.UNIT_ID(+)
               AND WIP.INVESTMENT_ID = CURRENT_PROJECTS.ID
               AND WIP.TASK_ID = TASKS.PRID
               AND CURRENT_PROJECTS.MANAGER_ID = PROJECT_MANAGERS.USER_ID(+)
               AND WIP.TRANSNO = WIP_VALUES.TRANSNO
               AND CURRENT_PROJECTS.ID = PROJECT_FACTS.ID
               AND PROJECT_FACTS.OBJ_REQUEST_TYPE =
                      PROJECT_TYPES.LOOKUP_CODE(+)
               AND                                   -- wip values for billing
                  WIP_VALUES.CURRENCY_TYPE = 'BILLING'
               AND WIP_VALUES.CURRENCY_CODE = 'USD'
               AND                           -- ensure proper wip transactions
                  WIP.ENTITY = 'CID'
               AND WIP.TRANSTYPE = 'L'
               AND WIP.STATUS NOT IN (2, 8)
               AND WIP.ON_HOLD = 0
               AND TO_CHAR (WIP.MONTH_BEGIN, 'YYYYMM') = CYCLES.CYCLE_DATE) F,
       (SELECT B.CODE,
               B.NAME,
               B.PROJECT_TYPE_ID,
               B.VCH_PRD_DN,
               B.VCH_PRD_SHRT_DN,
               B.GL_ACCT_ID,
               B.PRODUCT_NM_ALIAS,
               B.COST_TYPE,
               B.CBK_PRD_CD,
               B.CBK_PRD_NM,
               B.ACTIVE_IR,
               C.TRANSCLASS
          FROM WARM01.ODF_CA_CID_CHARGEBACK_ITEMS B, WARM01.TRANSCLASS C
         WHERE     B.ACTIVE_IR = 1
               AND B.TRANSACTION_CLASS_ID = C.ID
               AND B.PARTITION_CODE = 'cid') G,
       (SELECT C.CODE,
               C.CYCLE_YR_NO,
               C.CYCLE_DY_OF_MO_NO,
               D.NAME CYCLE_TYPE
          FROM WARM01.ODF_CA_CID_FIN_CALENDAR C,
               (SELECT NAME, LOOKUP_CODE
                  FROM WARM01.CMN_LOOKUPS_V
                 WHERE LOOKUP_TYPE = 'CID_CBK_CYCLES'
                       AND LANGUAGE_CODE = 'en') D
         WHERE C.CBK_CYCLE_TYPE_CODE = D.LOOKUP_CODE) H,
       WARM01.CID_VALID_COST_CENTERS R
 WHERE     F.TRANSACTION_CLASS = G.TRANSCLASS(+)
       AND F.PROJECT_TYPE_CODE = G.PROJECT_TYPE_ID(+)
       AND F.PROJECT_CC_CD = R.COST_CENTER(+)
       AND F.CYCLE_DATE = H.CODE