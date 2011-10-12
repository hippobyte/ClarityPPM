SELECT F.CBK_ROW_TYPE,
         H.NAME CBK_CY_TP,
         F.PROJ_ID,
         F.CC_CD,
         SUM (F.UNITS) UNITS,
         F.BILLRATE,
         SUM (F.AMOUNT) AMOUNT,
         G.CBK_PRD_CD CBK_PRD_CD,
         G.CODE CBK_ITEM_CD,
         H.CBK_CDW_CYCLE_MO CY_MTH,
         H.CBK_CDW_CYCLE_YR CY_YR,
         F.GL_IR,
         F.TIER_NM,
         F.CBK_IR,
         F.ADJ_TXT,
         F.DPT_TXT,
         F.PROJ_TP_NM,
         NULL CREATED_AT
    FROM (SELECT 'CHARGEBACK' CBK_ROW_TYPE,
                 TO_CHAR (SYSDATE, 'YYYYMMDD') CYCLE_DATE,
                 WIP.PROJECT_CODE PROJ_ID,
                 PROJECT_DETAILS.DEPARTCODE CC_CD,
                 WIP.QUANTITY UNITS,
                 WIP_VALUES.BILLRATE,
                 WIP_VALUES.AMOUNT,
                 WIP.TRANSCLASS TRANCLASS_CODE,
                 CASE
                    WHEN PROJECT_CC.UNIQUE_NAME IN ('cid_external') THEN 'Y'
                    ELSE 'N'
                 END
                    GL_IR,
                 NULL TIER_NM,
                 'Y' CBK_IR,
                 NULL ADJ_TXT,
                 BUSINESS_UNIT.NAME DPT_TXT,
                 PROJECT_TYPES.NAME PROJ_TP_NM,
                 PROJECT_TYPES.LOOKUP_CODE PROJECT_TYPE_CODE
            FROM WARM01.PPA_WIP WIP,
                 WARM01.PPA_WIP_VALUES WIP_VALUES,
                 WARM01.SRM_RESOURCES RESOURCES,
                 WARM01.INV_INVESTMENTS CURRENT_PROJECTS,
                 WARM01.ODF_CA_PROJECT PROJECT_FACTS,
                 WARM01.PAC_MNT_PROJECTS PROJECT_DETAILS,
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
                   WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') BUSINESS_UNIT,
                 (SELECT TO_CHAR (CYCLE_YR_NO)
                         || TO_CHAR (TO_DATE (CYCLE_DY_OF_MO_NO, 'MM'), 'MM')
                            CYCLE_DATE
                    FROM WARM01.ODF_CA_CID_FIN_CALENDAR
                   WHERE TO_CHAR (DT_VLU, 'YYYYMMDD') =
                            TO_CHAR (SYSDATE, 'YYYYMMDD')) CYCLES
           WHERE     WIP.INVESTMENT_ID = CURRENT_PROJECTS.ID
                 AND WIP.INVESTMENT_ID = PROJECT_DETAILS.ID
                 AND WIP.TRANSNO = WIP_VALUES.TRANSNO
                 AND CURRENT_PROJECTS.ID = PROJECT_FACTS.ID
                 AND PROJECT_FACTS.OBJ_REQUEST_TYPE = PROJECT_TYPES.LOOKUP_CODE
                 AND WIP.RESOURCE_CODE = RESOURCES.UNIQUE_NAME
                 AND WIP.EMPLYHOMEDEPART = RESOURCE_DPT.DEPARTCODE
                 AND PROJECT_DETAILS.DEPARTCODE = PROJECT_DPT.DEPARTCODE
                 AND PROJECT_DPT.OBS_UNIT_ID = PROJECT_CC.UNIT_ID
                 AND PROJECT_DPT.OBS_UNIT_ID = BUSINESS_UNIT.UNIT_ID(+)
                 AND PROJECT_TYPES.LOOKUP_CODE NOT IN ('Production_Support')
                 -- ensure record has cost center
                 AND BUSINESS_UNIT.NAME IS NOT NULL
                 AND                                 -- wip values for billing
                    WIP_VALUES.CURRENCY_TYPE = 'BILLING'
                 AND WIP_VALUES.CURRENCY_CODE = 'USD'
                 AND                         -- ensure proper wip transactions
                    WIP.ENTITY = 'CID'
                 AND WIP.TRANSTYPE = 'L'
                 AND WIP.STATUS NOT IN (2, 8)
                 AND WIP.ON_HOLD = 0
                 AND TO_CHAR (WIP.MONTH_BEGIN, 'YYYYMM') = CYCLES.CYCLE_DATE
          UNION ALL
          SELECT 'CHARGEBACK' CBK_ROW_TYPE,
                 TO_CHAR (SYSDATE, 'YYYYMMDD') CYCLE_DATE,
                 INVESTMENTS.CODE PROJECT_ID,
                 OBS_DEPARTMENTS.COST_CENTER CC_CD,
                 PLAN_VALUES.UNITS,
                 CASE
                    WHEN PLAN_VALUES.UNITS = 0 THEN 0
                    ELSE ROUND (PLAN_VALUES.COSTS / PLAN_VALUES.UNITS, 2)
                 END
                    BILLRATE,
                 PLAN_VALUES.COSTS AMOUNT,
                 TRANSACTION_CLASSES.TRANSCLASS TRANCLASS_CODE,
                 CASE
                    WHEN OBS_DEPARTMENTS.DEPARTMENT_TYPE IN ('cid_external')
                    THEN
                       'Y'
                    ELSE
                       'N'
                 END
                    GL_IR,
                 NULL TIER_NM,
                 'Y' CBK_IR,
                 NULL ADJ_TXT,
                 OBS_DEPARTMENTS.BUSINESS_UNIT_NAME DPT_TXT,
                 PROJECT_TYPES.NAME PRJ_TP_NM,
                 PROJECT_TYPES.LOOKUP_CODE PROJECT_TYPE_CODE
            FROM WARM01.INV_INVESTMENTS INVESTMENTS,
                 WARM01.FIN_PLANS PLANS,
                 WARM01.FIN_COST_PLAN_DETAILS DETAILS,
                 WARM01.TRANSCLASS TRANSACTION_CLASSES,
                 WARM01.PRCHARGECODE CHARGE_CODES,
                 WARM01.ODF_CA_PROJECT PROJECT_FACTS,
                 (  SELECT PRJ_OBJECT_ID,
                           START_DATE,
                           FINISH_DATE,
                           SUM (UNITS) UNITS,
                           SUM (COSTS) COSTS
                      FROM (  SELECT PRJ_OBJECT_ID,
                                     START_DATE,
                                     FINISH_DATE,
                                     ROUND (
                                        (FINISH_DATE - START_DATE) * SUM (SLICE),
                                        2)
                                        UNITS,
                                     0 COSTS,
                                     0 ACTUALS
                                FROM WARM01.ODF_SSL_CST_DTL_UNITS
                            GROUP BY PRJ_OBJECT_ID, START_DATE, FINISH_DATE
                            UNION
                              SELECT PRJ_OBJECT_ID,
                                     START_DATE,
                                     FINISH_DATE,
                                     0 UNITS,
                                     ROUND (
                                        (FINISH_DATE - START_DATE) * SUM (SLICE),
                                        2)
                                        COSTS,
                                     0 ACTUALS
                                FROM WARM01.ODF_SSL_CST_DTL_COST
                            GROUP BY PRJ_OBJECT_ID, START_DATE, FINISH_DATE)
                  GROUP BY PRJ_OBJECT_ID, START_DATE, FINISH_DATE) PLAN_VALUES,
                 (SELECT LOOKUP_CODE ID, NAME
                    FROM WARM01.CMN_LOOKUPS_V
                   WHERE LOOKUP_TYPE = 'FIN_PLAN_BY_TYPE'
                         AND LANGUAGE_CODE = 'en') PLAN_GROUP,
                 (SELECT LOOKUP_CODE ID, NAME
                    FROM WARM01.CMN_LOOKUPS_V
                   WHERE LOOKUP_TYPE = 'FIN_PLAN_BY_TYPE'
                         AND LANGUAGE_CODE = 'en') PLAN_SUBGROUP,
                 (SELECT A.PRID ID, B.FULL_NAME NAME
                    FROM WARM01.PRJ_RESOURCES A, WARM01.SRM_RESOURCES B
                   WHERE A.PRID = B.ID AND PRISROLE = 1) ROLES,
                 (SELECT LOOKUP_CODE, NAME
                    FROM WARM01.CMN_LOOKUPS_V
                   WHERE LANGUAGE_CODE = 'en' AND PARTITION_CODE = 'cid') PROJECT_TYPES,
                 (SELECT INVESTMENTS_OBS_UNITS.INVESTMENT_ID,
                         DEPARTMENT_TYPES.NAME DEPARTMENT_TYPE,
                         BUSINESS_UNITS.UNIQUE_NAME BUSINESS_UNIT_ID,
                         BUSINESS_UNITS.NAME BUSINESS_UNIT_NAME,
                         COST_CENTERS.UNIQUE_NAME COST_CENTER,
                         COST_CENTERS.NAME COST_CENTER_NAME
                    FROM (SELECT INV_OBS_UNITS.INVESTMENT_ID,
                                 INV_OBS_UNITS.OBS_UNIT
                            FROM WARM01.INV_OBS_ONLY_V INV_OBS_UNITS,
                                 WARM01.PRJ_OBS_UNITS OBS_UNITS,
                                 WARM01.PRJ_OBS_TYPES OBS_TYPES
                           WHERE     INV_OBS_UNITS.OBS_UNIT = OBS_UNITS.ID
                                 AND OBS_UNITS.TYPE_ID = OBS_TYPES.ID
                                 AND OBS_TYPES.ID = 5000001) INVESTMENTS_OBS_UNITS,
                         (SELECT UNIT_ID, UNIQUE_NAME, NAME
                            FROM WARM01.OBS_UNITS_V
                           WHERE DEPTH = 1
                                 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') DEPARTMENT_TYPES,
                         (SELECT UNIT_ID, UNIQUE_NAME, NAME
                            FROM WARM01.OBS_UNITS_V
                           WHERE DEPTH = 3
                                 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') BUSINESS_UNITS,
                         (SELECT UNIT_ID, UNIQUE_NAME, NAME
                            FROM WARM01.OBS_UNITS_V
                           WHERE DEPTH = 5
                                 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') COST_CENTERS
                   WHERE INVESTMENTS_OBS_UNITS.OBS_UNIT =
                            DEPARTMENT_TYPES.UNIT_ID(+)
                         AND INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                BUSINESS_UNITS.UNIT_ID(+)
                         AND INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                COST_CENTERS.UNIT_ID(+)) OBS_DEPARTMENTS,
                 (SELECT TO_CHAR (CYCLE_YR_NO)
                         || TO_CHAR (TO_DATE (CYCLE_DY_OF_MO_NO, 'MM'), 'MM')
                            CYCLE_DATE
                    FROM WARM01.ODF_CA_CID_FIN_CALENDAR
                   WHERE TO_CHAR (DT_VLU, 'YYYYMMDD') =
                            TO_CHAR (SYSDATE, 'YYYYMMDD')) CYCLES
           WHERE INVESTMENTS.ID = PLANS.OBJECT_ID
                 AND INVESTMENTS.ID = PROJECT_FACTS.ID
                 AND PROJECT_FACTS.OBJ_REQUEST_TYPE =
                        PROJECT_TYPES.LOOKUP_CODE(+)
                 AND INVESTMENTS.ID = OBS_DEPARTMENTS.INVESTMENT_ID(+)
                 AND PLANS.ID = DETAILS.PLAN_ID
                 AND PLANS.PLAN_TYPE_CODE IN
                        (CASE
                            WHEN PROJECT_TYPES.LOOKUP_CODE IN
                                    ('Production_Support',
                                     'baseline',
                                     'Business_Baseline')
                            THEN
                               'BUDGET'
                         END)
                 AND PLANS.PLAN_TYPE_CODE IN ('BUDGET')
                 AND INVESTMENTS.ENTITY_CODE = 'CID'
                 AND TRANSACTION_CLASSES.TRANSCLASS = 'Labor'
                 AND PLANS.IS_PLAN_OF_RECORD = 1
                 AND DETAILS.ID = PLAN_VALUES.PRJ_OBJECT_ID
                 AND DETAILS.PRROLE_ID = ROLES.ID(+)
                 AND PLANS.PLAN_BY_1_CODE = PLAN_GROUP.ID(+)
                 AND PLANS.PLAN_BY_2_CODE = PLAN_SUBGROUP.ID(+)
                 AND DETAILS.TRANSCLASS_ID = TRANSACTION_CLASSES.ID(+)
                 AND DETAILS.PRCHARGECODE_ID = CHARGE_CODES.PRID(+)
                 AND TO_CHAR (PLAN_VALUES.START_DATE, 'YYYYMM') =
                        CYCLES.CYCLE_DATE) F,
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
                 C.CBK_CDW_CYCLE_MO,
                 C.CBK_CDW_CYCLE_YR,
                 D.NAME
            FROM WARM01.ODF_CA_CID_FIN_CALENDAR C,
                 (SELECT NAME, LOOKUP_CODE
                    FROM WARM01.CMN_LOOKUPS_V
                   WHERE LOOKUP_TYPE = 'CID_CBK_CYCLES'
                         AND LANGUAGE_CODE = 'en') D
           WHERE C.CBK_CYCLE_TYPE_CODE = D.LOOKUP_CODE) H,
         WARM01.CID_VALID_COST_CENTERS CC
   WHERE     F.TRANCLASS_CODE = G.TRANSCLASS
         AND F.PROJECT_TYPE_CODE = G.PROJECT_TYPE_ID
         AND F.CYCLE_DATE = H.CODE
         AND F.CC_CD = CC.COST_CENTER
GROUP BY F.CBK_ROW_TYPE,
         H.NAME,
         F.PROJ_ID,
         F.CC_CD,
         F.BILLRATE,
         G.CBK_PRD_CD,
         G.CODE,
         H.CBK_CDW_CYCLE_MO,
         H.CBK_CDW_CYCLE_YR,
         F.GL_IR,
         F.TIER_NM,
         F.CBK_IR,
         F.ADJ_TXT,
         F.DPT_TXT,
         F.PROJ_TP_NM
ORDER BY F.PROJ_ID ASC