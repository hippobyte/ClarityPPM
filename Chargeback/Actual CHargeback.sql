SELECT F.CBK_ROW_TYPE,
            F.CBK_CY_TP,
            F.PROJ_ID,
            F.CC_CD,
            SUM (F.UNITS) UNITS,
            F.BILLRATE,
            SUM (F.AMOUNT) AMOUNT,
            G.CBK_PRD_CD CBK_PRD_CD,
            G.CODE CBK_ITEM_CD,
            F.CREATED_AT,
            F.CY_MTH,
            F.CY_YR,
            F.GL_IR,
            F.TIER_NM,
            F.CBK_IR,
            F.ADJ_TXT,
            F.DPT_TXT,
            F.PROJ_TP_NM
       FROM (SELECT 'CHARGEBACK' CBK_ROW_TYPE,
                    CASE
                       WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                    AND 31
                       THEN
                          'PRELIMINARY'
                       ELSE
                          'FINAL'
                    END
                       CBK_CY_TP,
                    WIP.PROJECT_CODE PROJ_ID,
                    WIP.PROJECT_DEPARTMENT CC_CD,
                    WIP.QUANTITY UNITS,
                    WIP_VALUES.BILLRATE,
                    WIP_VALUES.AMOUNT,
                    WIP.TRANSCLASS TRANCLASS_CODE,
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
                    CASE
                       WHEN PROJECT_CC.NAME IN ('External Departments')
                       THEN
                          'Y'
                       ELSE
                          'N'
                    END
                       GL_IR,
                    NULL TIER_NM,
                    CASE
                       WHEN PROJECT_CC.NAME IN ('External Departments')
                       THEN
                          'Y'
                       ELSE
                          'N'
                    END
                       CBK_IR,
                    NULL ADJ_TXT,
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
                    AND PROJECT_FACTS.OBJ_REQUEST_TYPE =
                           PROJECT_TYPES.LOOKUP_CODE
                    -- ensure record has cost center
                    AND BUSINESS_UNIT.NAME IS NOT NULL
                    AND                              -- wip values for billing
                       WIP_VALUES.CURRENCY_TYPE = 'BILLING'
                    AND WIP_VALUES.CURRENCY_CODE = 'USD'
                    AND                      -- ensure proper wip transactions
                       WIP.ENTITY = 'CID'
                    AND WIP.TRANSTYPE = 'L'
                    AND WIP.STATUS NOT IN (2, 8)
                    AND WIP.ON_HOLD = 0
                    AND TO_CHAR (WIP.MONTH_BEGIN, 'YYYYMM') =
                           CASE
                              WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                           AND 31
                              THEN
                                 TO_NUMBER (
                                    TO_CHAR (SYSDATE - INTERVAL '1' MONTH,
                                             'YYYYMM'))
                              ELSE
                                 TO_NUMBER (
                                    TO_CHAR (SYSDATE - INTERVAL '2' MONTH,
                                             'YYYYMM'))
                           END
             UNION ALL
             SELECT 'PREV _MO_ACTUALS' CBK_ROW_TYPE,
                    CASE
                       WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                    AND 31
                       THEN
                          'PRELIMINARY'
                       ELSE
                          'FINAL'
                    END
                       CBK_CY_TP,
                    WIP.PROJECT_CODE PROJ_ID,
                    WIP.PROJECT_DEPARTMENT CC_CD,
                    WIP.QUANTITY UNITS,
                    WIP_VALUES.BILLRATE,
                    WIP_VALUES.AMOUNT,
                    WIP.TRANSCLASS TRANCLASS_CODE,
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
                    CASE
                       WHEN PROJECT_CC.NAME IN ('External Departments')
                       THEN
                          'Y'
                       ELSE
                          'N'
                    END
                       GL_IR,
                    NULL TIER_NM,
                    CASE
                       WHEN PROJECT_CC.NAME IN ('External Departments')
                       THEN
                          'Y'
                       ELSE
                          'N'
                    END
                       CBK_IR,
                    NULL ADJ_TXT,
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
                    AND PROJECT_FACTS.OBJ_REQUEST_TYPE =
                           PROJECT_TYPES.LOOKUP_CODE
                    -- ensure record has cost center
                    AND BUSINESS_UNIT.NAME IS NOT NULL
                    AND                              -- wip values for billing
                       WIP_VALUES.CURRENCY_TYPE = 'BILLING'
                    AND WIP_VALUES.CURRENCY_CODE = 'USD'
                    AND                      -- ensure proper wip transactions
                       WIP.ENTITY = 'CID'
                    AND WIP.TRANSTYPE = 'L'
                    AND WIP.STATUS NOT IN (2, 8)
                    AND WIP.ON_HOLD = 0
                    AND TO_CHAR (WIP.MONTH_BEGIN, 'YYYYMM') =
                           CASE
                              WHEN TO_NUMBER (TO_CHAR (SYSDATE, 'DD')) BETWEEN 10
                                                                           AND 31
                              THEN
                                 TO_NUMBER (
                                    TO_CHAR (SYSDATE - INTERVAL '2' MONTH,
                                             'YYYYMM'))
                              ELSE
                                 TO_NUMBER (
                                    TO_CHAR (SYSDATE - INTERVAL '3' MONTH,
                                             'YYYYMM'))
                           END) F,
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
              WHERE B.ACTIVE_IR = 1 AND B.TRANSACTION_CLASS_ID = C.ID AND B.PARTITION_CODE = 'cid') G
      WHERE F.TRANCLASS_CODE = G.TRANSCLASS
            AND F.PROJECT_TYPE_CODE = G.PROJECT_TYPE_ID
   GROUP BY F.CBK_ROW_TYPE,
            F.CBK_CY_TP,
            F.PROJ_ID,
            F.CC_CD,
            F.BILLRATE,
            G.CBK_PRD_CD,
            G.CODE,
            F.CREATED_AT,
            F.CY_MTH,
            F.CY_YR,
            F.GL_IR,
            F.TIER_NM,
            F.CBK_IR,
            F.ADJ_TXT,
            F.DPT_TXT,
            F.PROJ_TP_NM
   ORDER BY F.PROJ_ID ASC