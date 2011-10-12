SELECT BUDG_ROW_TYPE,
            CBK_CY_TP,
            CC_CD,
            PROJ_ID,
            CBK_PRD_CD,
            CBK_ITEM_CD,
            TIER_NM,
            CREATED_AT,
            CY_MTH,
            CY_YR,
            RATE,
            SUM (JAN_UNITS) JAN_UNITS,
            SUM (JAN_COST) JAN_COST,
            SUM (FEB_UNITS) FEB_UNITS,
            SUM (FEB_COST) FEB_COST,
            SUM (MAR_UNITS) MAR_UNITS,
            SUM (MAR_COST) MAR_COST,
            SUM (APR_UNITS) APR_UNITS,
            SUM (APR_COST) APR_COST,
            SUM (MAY_UNITS) MAY_UNITS,
            SUM (MAY_COST) MAY_COST,
            SUM (JUN_UNITS) JUN_UNITS,
            SUM (JUN_COST) JUN_COST,
            SUM (JUL_UNITS) JUL_UNITS,
            SUM (JUL_COST) JUL_COST,
            SUM (AUG_UNITS) AUG_UNITS,
            SUM (AUG_COST) AUG_COST,
            SUM (SEP_UNITS) SEP_UNITS,
            SUM (SEP_COST) SEP_COST,
            SUM (OCT_UNITS) OCT_UNITS,
            SUM (OCT_COST) OCT_COST,
            SUM (NOV_UNITS) NOV_UNITS,
            SUM (NOV_COST) NOV_COST,
            SUM (DEC_UNITS) DEC_UNITS,
            SUM (DEC_COST) DEC_COST,
            SRC_CREA_DT,
            DPT_TXT,
            PROJ_TP_NM
       FROM (SELECT F.TRANCLASS_CODE,
                    G.TRANSCLASS,
                    F.PROJECT_TYPE_CODE,
                    G.PROJECT_TYPE_ID,
                    CASE
                       WHEN F.CHARGEBACK_PLAN_TYPE = 'FORECAST'
                       THEN
                          'CURR_ANNL_REFORECAST'
                       WHEN F.CHARGEBACK_PLAN_TYPE = 'BUDGET'
                       THEN
                          'CURR_APPR_BUDG'
                       WHEN F.CHARGEBACK_PLAN_TYPE = 'EFFORT'
                       THEN
                          'CURR_EFFORT_PLAN'
                    END
                       BUDG_ROW_TYPE,
                    CASE
                       WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                    AND 31
                       THEN
                          'PRELIMINARY'
                       ELSE
                          'FINAL'
                    END
                       CBK_CY_TP,
                    F.COST_CENTER CC_CD,
                    F.INVESTMENT_ID PROJ_ID,
                    G.CBK_PRD_CD,
                    G.CODE CBK_ITEM_CD,
                    NULL TIER_NM,
                    SYSDATE CREATED_AT,
                    CASE
                       WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                    AND 31
                       THEN
                          TO_NUMBER (
                             TO_CHAR (SYSDATE - INTERVAL '1' MONTH, 'MM'))
                       ELSE
                          TO_NUMBER (
                             TO_CHAR (SYSDATE - INTERVAL '2' MONTH, 'MM'))
                    END
                       CY_MTH,
                    CASE
                       WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                    AND 31
                       THEN
                          TO_NUMBER (
                             TO_CHAR (SYSDATE - INTERVAL '1' MONTH, 'YYYY'))
                       ELSE
                          TO_NUMBER (
                             TO_CHAR (SYSDATE - INTERVAL '2' MONTH, 'YYYY'))
                    END
                       CY_YR,
                    0 RATE,
                    CASE WHEN F.START_MONTH = '01' THEN F.UNITS ELSE 0 END
                       JAN_UNITS,
                    CASE WHEN F.START_MONTH = '01' THEN F.COSTS ELSE 0 END
                       JAN_COST,
                    CASE WHEN F.START_MONTH = '02' THEN F.UNITS ELSE 0 END
                       FEB_UNITS,
                    CASE WHEN F.START_MONTH = '02' THEN F.COSTS ELSE 0 END
                       FEB_COST,
                    CASE WHEN F.START_MONTH = '03' THEN F.UNITS ELSE 0 END
                       MAR_UNITS,
                    CASE WHEN F.START_MONTH = '03' THEN F.COSTS ELSE 0 END
                       MAR_COST,
                    CASE WHEN F.START_MONTH = '04' THEN F.UNITS ELSE 0 END
                       APR_UNITS,
                    CASE WHEN F.START_MONTH = '04' THEN F.COSTS ELSE 0 END
                       APR_COST,
                    CASE WHEN F.START_MONTH = '05' THEN F.UNITS ELSE 0 END
                       MAY_UNITS,
                    CASE WHEN F.START_MONTH = '05' THEN F.COSTS ELSE 0 END
                       MAY_COST,
                    CASE WHEN F.START_MONTH = '06' THEN F.UNITS ELSE 0 END
                       JUN_UNITS,
                    CASE WHEN F.START_MONTH = '06' THEN F.COSTS ELSE 0 END
                       JUN_COST,
                    CASE WHEN F.START_MONTH = '07' THEN F.UNITS ELSE 0 END
                       JUL_UNITS,
                    CASE WHEN F.START_MONTH = '07' THEN F.COSTS ELSE 0 END
                       JUL_COST,
                    CASE WHEN F.START_MONTH = '08' THEN F.UNITS ELSE 0 END
                       AUG_UNITS,
                    CASE WHEN F.START_MONTH = '08' THEN F.COSTS ELSE 0 END
                       AUG_COST,
                    CASE WHEN F.START_MONTH = '09' THEN F.UNITS ELSE 0 END
                       SEP_UNITS,
                    CASE WHEN F.START_MONTH = '09' THEN F.COSTS ELSE 0 END
                       SEP_COST,
                    CASE WHEN F.START_MONTH = '10' THEN F.UNITS ELSE 0 END
                       OCT_UNITS,
                    CASE WHEN F.START_MONTH = '10' THEN F.COSTS ELSE 0 END
                       OCT_COST,
                    CASE WHEN F.START_MONTH = '11' THEN F.UNITS ELSE 0 END
                       NOV_UNITS,
                    CASE WHEN F.START_MONTH = '11' THEN F.COSTS ELSE 0 END
                       NOV_COST,
                    CASE WHEN F.START_MONTH = '12' THEN F.UNITS ELSE 0 END
                       DEC_UNITS,
                    CASE WHEN F.START_MONTH = '12' THEN F.COSTS ELSE 0 END
                       DEC_COST,
                    SYSDATE SRC_CREA_DT,
                    F.BUSINESS_UNIT_NAME DPT_TXT,
                    F.PROJECT_TYPE PROJ_TP_NM
               FROM (SELECT INVESTMENTS.ID INVESTMENT_PRID,
                            INVESTMENTS.CODE INVESTMENT_ID,
                            INVESTMENTS.ENTITY_CODE,
                            INVESTMENTS.NAME INVESTMENT_NAME,
                            INVESTMENTS.ODF_OBJECT_CODE INVESTMENT_TYPE,
                            INVESTMENTS.IS_ACTIVE,
                            INVESTMENTS.MANAGER_ID,
                            INVESTMENTS.IS_OPEN_FOR_TE,
                            PROJECT_TYPES.LOOKUP_CODE PROJECT_TYPE_CODE,
                            PROJECT_TYPES.NAME PROJECT_TYPE,
                            OBS_DEPARTMENTS.DEPARTMENT_TYPE,
                            OBS_DEPARTMENTS.BUSINESS_UNIT_ID,
                            OBS_DEPARTMENTS.BUSINESS_UNIT_NAME,
                            OBS_DEPARTMENTS.COST_CENTER,
                            OBS_DEPARTMENTS.COST_CENTER_NAME,
                            PLANS.CODE PLAN_ID,
                            PLANS.NAME PLAN_NAME,
                            PLANS.DESCRIPTION PLAN_DESCRIPTION,
                            PLANS.REVISION PLAN_REVISION,
                            PLANS.PLAN_TYPE_CODE PLAN_TYPE,
                            CASE
                               WHEN PLANS.PLAN_TYPE_CODE = 'FORECAST'
                                    AND PROJECT_TYPES.NAME IN
                                           ('Production Support',
                                            'Baseline',
                                            'Business Baseline')
                               THEN
                                  'EFFORT'
                               ELSE
                                  PLANS.PLAN_TYPE_CODE
                            END
                               CHARGEBACK_PLAN_TYPE,
                            PLANS.PERIOD_TYPE_CODE PLAN_PERIOD,
                            PLANS.IS_PLAN_OF_RECORD,
                            PLAN_GROUP.NAME PLAN_BY_GROUP,
                            PLAN_SUBGROUP.NAME PLAN_BY_SUBGROUP,
                            CHARGE_CODES.PRNAME CHARGECODE_NAME,
                            TRANSACTION_CLASSES.TRANSCLASS TRANCLASS_CODE,
                            TRANSACTION_CLASSES.DESCRIPTION TRANCLASS_NAME,
                            ROLES.NAME ROLE_NAME,
                            PLAN_VALUES.START_DATE,
                            PLAN_VALUES.FINISH_DATE,
                            TO_CHAR (PLAN_VALUES.START_DATE, 'MM') START_MONTH,
                            TO_CHAR (PLAN_VALUES.FINISH_DATE, 'MM') END_MONTH,
                            TO_CHAR (PLAN_VALUES.START_DATE, 'MM') START_YEAR,
                            TO_CHAR (PLAN_VALUES.FINISH_DATE, 'YYYY') END_YEAR,
                            PLAN_VALUES.UNITS,
                            PLAN_VALUES.COSTS
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
                                                   (FINISH_DATE - START_DATE)
                                                   * SUM (SLICE),
                                                   2)
                                                   UNITS,
                                                0 COSTS,
                                                0 ACTUALS
                                           FROM WARM01.ODF_SSL_CST_DTL_UNITS
                                       GROUP BY PRJ_OBJECT_ID,
                                                START_DATE,
                                                FINISH_DATE
                                       UNION
                                         SELECT PRJ_OBJECT_ID,
                                                START_DATE,
                                                FINISH_DATE,
                                                0 UNITS,
                                                ROUND (
                                                   (FINISH_DATE - START_DATE)
                                                   * SUM (SLICE),
                                                   2)
                                                   COSTS,
                                                0 ACTUALS
                                           FROM WARM01.ODF_SSL_CST_DTL_COST
                                       GROUP BY PRJ_OBJECT_ID,
                                                START_DATE,
                                                FINISH_DATE)
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
                               FROM WARM01.PRJ_RESOURCES A,
                                    WARM01.SRM_RESOURCES B
                              WHERE A.PRID = B.ID AND PRISROLE = 1) ROLES,
                            (SELECT LOOKUP_CODE, NAME
                               FROM WARM01.CMN_LOOKUPS_V
                              WHERE LANGUAGE_CODE = 'en'
                                    AND PARTITION_CODE = 'cid') PROJECT_TYPES,
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
                                      WHERE INV_OBS_UNITS.OBS_UNIT =
                                               OBS_UNITS.ID
                                            AND OBS_UNITS.TYPE_ID =
                                                   OBS_TYPES.ID
                                            AND OBS_TYPES.ID = 5000001) INVESTMENTS_OBS_UNITS,
                                    (SELECT UNIT_ID, UNIQUE_NAME, NAME
                                       FROM WARM01.OBS_UNITS_V
                                      WHERE DEPTH = 1
                                            AND UNIT_MODE =
                                                   'OBS_UNIT_AND_ANCESTORS') DEPARTMENT_TYPES,
                                    (SELECT UNIT_ID, UNIQUE_NAME, NAME
                                       FROM WARM01.OBS_UNITS_V
                                      WHERE DEPTH = 3
                                            AND UNIT_MODE =
                                                   'OBS_UNIT_AND_ANCESTORS') BUSINESS_UNITS,
                                    (SELECT UNIT_ID, UNIQUE_NAME, NAME
                                       FROM WARM01.OBS_UNITS_V
                                      WHERE DEPTH = 5
                                            AND UNIT_MODE =
                                                   'OBS_UNIT_AND_ANCESTORS') COST_CENTERS
                              WHERE INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                       DEPARTMENT_TYPES.UNIT_ID(+)
                                    AND INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                           BUSINESS_UNITS.UNIT_ID(+)
                                    AND INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                           COST_CENTERS.UNIT_ID(+)) OBS_DEPARTMENTS
                      WHERE INVESTMENTS.ID = PLANS.OBJECT_ID
                            AND INVESTMENTS.ID = PROJECT_FACTS.ID
                            AND PROJECT_FACTS.OBJ_REQUEST_TYPE =
                                   PROJECT_TYPES.LOOKUP_CODE(+)
                            AND INVESTMENTS.ID =
                                   OBS_DEPARTMENTS.INVESTMENT_ID(+)
                            AND PLANS.ID = DETAILS.PLAN_ID
                            AND DETAILS.ID = PLAN_VALUES.PRJ_OBJECT_ID
                            AND DETAILS.PRROLE_ID = ROLES.ID(+)
                            AND PLANS.PLAN_BY_1_CODE = PLAN_GROUP.ID(+)
                            AND PLANS.PLAN_BY_2_CODE = PLAN_SUBGROUP.ID(+)
                            AND DETAILS.TRANSCLASS_ID =
                                   TRANSACTION_CLASSES.ID(+)
                            AND DETAILS.PRCHARGECODE_ID = CHARGE_CODES.PRID(+)
                     UNION ALL
                     SELECT INVESTMENTS.ID INVESTMENT_PRID,
                            INVESTMENTS.CODE INVESTMENT_ID,
                            INVESTMENTS.ENTITY_CODE,
                            INVESTMENTS.NAME INVESTMENT_NAME,
                            INVESTMENTS.ODF_OBJECT_CODE INVESTMENT_TYPE,
                            INVESTMENTS.IS_ACTIVE,
                            INVESTMENTS.MANAGER_ID,
                            INVESTMENTS.IS_OPEN_FOR_TE,
                            PROJECT_TYPES.LOOKUP_CODE PROJECT_TYPE_CODE,
                            PROJECT_TYPES.NAME PROJECT_TYPE,
                            OBS_DEPARTMENTS.DEPARTMENT_TYPE,
                            OBS_DEPARTMENTS.BUSINESS_UNIT_ID,
                            OBS_DEPARTMENTS.BUSINESS_UNIT_NAME,
                            OBS_DEPARTMENTS.COST_CENTER,
                            OBS_DEPARTMENTS.COST_CENTER_NAME,
                            PLANS.CODE PLAN_ID,
                            PLANS.NAME PLAN_NAME,
                            PLANS.DESCRIPTION PLAN_DESCRIPTION,
                            PLANS.REVISION PLAN_REVISION,
                            PLANS.PLAN_TYPE_CODE PLAN_TYPE,
                            CASE
                               WHEN PLANS.PLAN_TYPE_CODE = 'BUDGET'
                                    AND PROJECT_TYPES.NAME IN
                                           ('Production Support',
                                            'Baseline',
                                            'Business Baseline')
                               THEN
                                  'FORECAST'
                               ELSE
                                  PLANS.PLAN_TYPE_CODE
                            END
                               CHARGEBACK_PLAN_TYPE,
                            PLANS.PERIOD_TYPE_CODE PLAN_PERIOD,
                            PLANS.IS_PLAN_OF_RECORD,
                            PLAN_GROUP.NAME PLAN_BY_GROUP,
                            PLAN_SUBGROUP.NAME PLAN_BY_SUBGROUP,
                            CHARGE_CODES.PRNAME CHARGECODE_NAME,
                            TRANSACTION_CLASSES.TRANSCLASS TRANCLASS_CODE,
                            TRANSACTION_CLASSES.DESCRIPTION TRANCLASS_NAME,
                            ROLES.NAME ROLE_NAME,
                            PLAN_VALUES.START_DATE,
                            PLAN_VALUES.FINISH_DATE,
                            TO_CHAR (PLAN_VALUES.START_DATE, 'MM') START_MONTH,
                            TO_CHAR (PLAN_VALUES.FINISH_DATE, 'MM') END_MONTH,
                            TO_CHAR (PLAN_VALUES.START_DATE, 'MM') START_YEAR,
                            TO_CHAR (PLAN_VALUES.FINISH_DATE, 'YYYY') END_YEAR,
                            PLAN_VALUES.UNITS,
                            PLAN_VALUES.COSTS
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
                                                   (FINISH_DATE - START_DATE)
                                                   * SUM (SLICE),
                                                   2)
                                                   UNITS,
                                                0 COSTS,
                                                0 ACTUALS
                                           FROM WARM01.ODF_SSL_CST_DTL_UNITS
                                       GROUP BY PRJ_OBJECT_ID,
                                                START_DATE,
                                                FINISH_DATE
                                       UNION
                                         SELECT PRJ_OBJECT_ID,
                                                START_DATE,
                                                FINISH_DATE,
                                                0 UNITS,
                                                ROUND (
                                                   (FINISH_DATE - START_DATE)
                                                   * SUM (SLICE),
                                                   2)
                                                   COSTS,
                                                0 ACTUALS
                                           FROM WARM01.ODF_SSL_CST_DTL_COST
                                       GROUP BY PRJ_OBJECT_ID,
                                                START_DATE,
                                                FINISH_DATE)
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
                               FROM WARM01.PRJ_RESOURCES A,
                                    WARM01.SRM_RESOURCES B
                              WHERE A.PRID = B.ID AND PRISROLE = 1) ROLES,
                            (SELECT LOOKUP_CODE, NAME
                               FROM WARM01.CMN_LOOKUPS_V
                              WHERE LANGUAGE_CODE = 'en'
                                    AND PARTITION_CODE = 'cid') PROJECT_TYPES,
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
                                      WHERE INV_OBS_UNITS.OBS_UNIT =
                                               OBS_UNITS.ID
                                            AND OBS_UNITS.TYPE_ID =
                                                   OBS_TYPES.ID
                                            AND OBS_TYPES.ID = 5000001) INVESTMENTS_OBS_UNITS,
                                    (SELECT UNIT_ID, UNIQUE_NAME, NAME
                                       FROM WARM01.OBS_UNITS_V
                                      WHERE DEPTH = 1
                                            AND UNIT_MODE =
                                                   'OBS_UNIT_AND_ANCESTORS') DEPARTMENT_TYPES,
                                    (SELECT UNIT_ID, UNIQUE_NAME, NAME
                                       FROM WARM01.OBS_UNITS_V
                                      WHERE DEPTH = 3
                                            AND UNIT_MODE =
                                                   'OBS_UNIT_AND_ANCESTORS') BUSINESS_UNITS,
                                    (SELECT UNIT_ID, UNIQUE_NAME, NAME
                                       FROM WARM01.OBS_UNITS_V
                                      WHERE DEPTH = 5
                                            AND UNIT_MODE =
                                                   'OBS_UNIT_AND_ANCESTORS') COST_CENTERS
                              WHERE INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                       DEPARTMENT_TYPES.UNIT_ID(+)
                                    AND INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                           BUSINESS_UNITS.UNIT_ID(+)
                                    AND INVESTMENTS_OBS_UNITS.OBS_UNIT =
                                           COST_CENTERS.UNIT_ID(+)) OBS_DEPARTMENTS
                      WHERE INVESTMENTS.ID = PLANS.OBJECT_ID
                            AND INVESTMENTS.ID = PROJECT_FACTS.ID
                            AND PROJECT_FACTS.OBJ_REQUEST_TYPE =
                                   PROJECT_TYPES.LOOKUP_CODE(+)
                            AND INVESTMENTS.ID =
                                   OBS_DEPARTMENTS.INVESTMENT_ID(+)
                            AND PLANS.ID = DETAILS.PLAN_ID
                            AND PLANS.PLAN_TYPE_CODE IN
                                   (CASE
                                       WHEN PROJECT_TYPES.NAME IN
                                               ('Production Support',
                                                'Baseline',
                                                'Business Baseline')
                                       THEN
                                          'BUDGET'
                                    END)
                            AND PLANS.PLAN_TYPE_CODE NOT IN ('FORECAST')
                            AND DETAILS.ID = PLAN_VALUES.PRJ_OBJECT_ID
                            AND DETAILS.PRROLE_ID = ROLES.ID(+)
                            AND PLANS.PLAN_BY_1_CODE = PLAN_GROUP.ID(+)
                            AND PLANS.PLAN_BY_2_CODE = PLAN_SUBGROUP.ID(+)
                            AND DETAILS.TRANSCLASS_ID =
                                   TRANSACTION_CLASSES.ID(+)
                            AND DETAILS.PRCHARGECODE_ID = CHARGE_CODES.PRID(+)) F,
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
                       FROM WARM01.ODF_CA_CID_CHARGEBACK_ITEMS B,
                            WARM01.TRANSCLASS C
                      WHERE     B.ACTIVE_IR = 1
                            AND B.TRANSACTION_CLASS_ID = C.ID
                            AND B.PARTITION_CODE = 'cid') G
              WHERE     F.TRANCLASS_CODE = G.TRANSCLASS
                    AND F.PROJECT_TYPE_CODE = G.PROJECT_TYPE_ID
                    AND F.IS_PLAN_OF_RECORD = 1
                    AND F.INVESTMENT_TYPE = 'project'
                    AND F.PLAN_BY_GROUP = 'Transaction Classes'
                    AND F.PLAN_BY_SUBGROUP = 'Charge Codes'
                    AND F.TRANCLASS_NAME = 'FTE - Labor'
                    AND F.COST_CENTER IS NOT NULL)
      WHERE BUDG_ROW_TYPE IS NOT NULL
   GROUP BY BUDG_ROW_TYPE,
            CBK_CY_TP,
            CC_CD,
            PROJ_ID,
            CBK_PRD_CD,
            CBK_ITEM_CD,
            TIER_NM,
            CREATED_AT,
            CY_MTH,
            CY_YR,
            RATE,
            SRC_CREA_DT,
            DPT_TXT,
            PROJ_TP_NM
   ORDER BY PROJ_ID ASC