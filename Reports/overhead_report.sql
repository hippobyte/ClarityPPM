  SELECT Z.L2_NAME,
         Z.L3_NAME,
         Z.L4_NAME,
         Z.L5_NAME,
         Z.L2_UNIT,
         Z.L3_UNIT,
         Z.L4_UNIT,
         Z.L5_UNIT,
         SUM ("000COA-L2") * 100 "Company Administration L2",
         SUM ("000DEA-L2") * 100 "Departmental Administration L2",
         SUM ("000EDU-L2") * 100 "Education L2",
         SUM ("000EHR-L2") * 100 "Human Resource L2",
         SUM ("000PLA-L2") * 100 "Planned Absence L2",
         SUM ("000UPA-L2") * 100 "Unplanned Absence L2",
         (  SUM ("000COA-L2")
          + SUM ("000DEA-L2")
          + SUM ("000EDU-L2")
          + SUM ("000EHR-L2")
          + SUM ("000PLA-L2")
          + SUM ("000UPA-L2"))
         * 100
            "Total L2",
         SUM ("000COA-L3") * 100 "Company Administration L3",
         SUM ("000DEA-L3") * 100 "Departmental Administration L3",
         SUM ("000EDU-L3") * 100 "Education L3",
         SUM ("000EHR-L3") * 100 "Human Resource L3",
         SUM ("000PLA-L3") * 100 "Planned Absence L3",
         SUM ("000UPA-L3") * 100 "Unplanned Absence L3",
         (  SUM ("000COA-L3")
          + SUM ("000DEA-L3")
          + SUM ("000EDU-L3")
          + SUM ("000EHR-L3")
          + SUM ("000PLA-L3")
          + SUM ("000UPA-L3"))
         * 100
            "Total L3",
         SUM ("000COA-L4") * 100 "Company Administration L4",
         SUM ("000DEA-L4") * 100 "Departmental Administration L4",
         SUM ("000EDU-L4") * 100 "Education L4",
         SUM ("000EHR-L4") * 100 "Human Resource L4",
         SUM ("000PLA-L4") * 100 "Planned Absence L4",
         SUM ("000UPA-L4") * 100 "Unplanned Absence L4",
         (  SUM ("000COA-L4")
          + SUM ("000DEA-L4")
          + SUM ("000EDU-L4")
          + SUM ("000EHR-L4")
          + SUM ("000PLA-L4")
          + SUM ("000UPA-L4"))
         * 100
            "Total L4",
         SUM ("000COA-L5") * 100 "Company Administration L5",
         SUM ("000DEA-L5") * 100 "Departmental Administration L5",
         SUM ("000EDU-L5") * 100 "Education L5",
         SUM ("000EHR-L5") * 100 "Human Resource L5",
         SUM ("000PLA-L5") * 100 "Planned Absence L5",
         SUM ("000UPA-L5") * 100 "Unplanned Absence L5",
         (  SUM ("000COA-L5")
          + SUM ("000DEA-L5")
          + SUM ("000EDU-L5")
          + SUM ("000EHR-L5")
          + SUM ("000PLA-L5")
          + SUM ("000UPA-L5"))
         * 100
            "Total L5"
    FROM (SELECT L2_NAME,
                 L3_NAME,
                 L4_NAME,
                 L5_NAME,
                 L2_UNIT,
                 L3_UNIT,
                 L4_UNIT,
                 L5_UNIT,
                 -- LEVEL 2
                 CASE WHEN INVESTMENT_ID = '000COA' THEN OH_L2 ELSE 0 END
                    "000COA-L2",
                 CASE WHEN INVESTMENT_ID = '000DEA' THEN OH_L2 ELSE 0 END
                    "000DEA-L2",
                 CASE WHEN INVESTMENT_ID = '000EDU' THEN OH_L2 ELSE 0 END
                    "000EDU-L2",
                 CASE WHEN INVESTMENT_ID = '000EHR' THEN OH_L2 ELSE 0 END
                    "000EHR-L2",
                 CASE WHEN INVESTMENT_ID = '000PLA' THEN OH_L2 ELSE 0 END
                    "000PLA-L2",
                 CASE WHEN INVESTMENT_ID = '000UPA' THEN OH_L2 ELSE 0 END
                    "000UPA-L2",
                 -- LEVEL 3
                 CASE WHEN INVESTMENT_ID = '000COA' THEN OH_L3 ELSE 0 END
                    "000COA-L3",
                 CASE WHEN INVESTMENT_ID = '000DEA' THEN OH_L3 ELSE 0 END
                    "000DEA-L3",
                 CASE WHEN INVESTMENT_ID = '000EDU' THEN OH_L3 ELSE 0 END
                    "000EDU-L3",
                 CASE WHEN INVESTMENT_ID = '000EHR' THEN OH_L3 ELSE 0 END
                    "000EHR-L3",
                 CASE WHEN INVESTMENT_ID = '000PLA' THEN OH_L3 ELSE 0 END
                    "000PLA-L3",
                 CASE WHEN INVESTMENT_ID = '000UPA' THEN OH_L3 ELSE 0 END
                    "000UPA-L3",
                 -- LEVEL 4
                 CASE WHEN INVESTMENT_ID = '000COA' THEN OH_L4 ELSE 0 END
                    "000COA-L4",
                 CASE WHEN INVESTMENT_ID = '000DEA' THEN OH_L4 ELSE 0 END
                    "000DEA-L4",
                 CASE WHEN INVESTMENT_ID = '000EDU' THEN OH_L4 ELSE 0 END
                    "000EDU-L4",
                 CASE WHEN INVESTMENT_ID = '000EHR' THEN OH_L4 ELSE 0 END
                    "000EHR-L4",
                 CASE WHEN INVESTMENT_ID = '000PLA' THEN OH_L4 ELSE 0 END
                    "000PLA-L4",
                 CASE WHEN INVESTMENT_ID = '000UPA' THEN OH_L4 ELSE 0 END
                    "000UPA-L4",
                 -- LEVEL 5
                 CASE WHEN INVESTMENT_ID = '000COA' THEN OH_L5 ELSE 0 END
                    "000COA-L5",
                 CASE WHEN INVESTMENT_ID = '000DEA' THEN OH_L5 ELSE 0 END
                    "000DEA-L5",
                 CASE WHEN INVESTMENT_ID = '000EDU' THEN OH_L5 ELSE 0 END
                    "000EDU-L5",
                 CASE WHEN INVESTMENT_ID = '000EHR' THEN OH_L5 ELSE 0 END
                    "000EHR-L5",
                 CASE WHEN INVESTMENT_ID = '000PLA' THEN OH_L5 ELSE 0 END
                    "000PLA-L5",
                 CASE WHEN INVESTMENT_ID = '000UPA' THEN OH_L5 ELSE 0 END
                    "000UPA-L5"
            FROM (SELECT OH_L5.L2_NAME,
                         OH_L5.L3_NAME,
                         OH_L5.L4_NAME,
                         OH_L5.L5_NAME,
                         OH_L5.L2_UNIT,
                         OH_L5.L3_UNIT,
                         OH_L5.L4_UNIT,
                         OH_L5.L5_UNIT,
                         OH_L5.INVESTMENT_ID,
                         OH_L5.INVESTMENT_NAME,
                         OH_L2.OH_L2,
                         OH_L3.OH_L3,
                         OH_L4.OH_L4,
                         OH_L5.OH_L5
                    FROM (SELECT A.L2_NAME,
                                 A.L2_UNIT,
                                 A.L3_NAME,
                                 A.L3_UNIT,
                                 A.L4_NAME,
                                 A.L4_UNIT,
                                 A.L5_NAME,
                                 A.L5_UNIT,
                                 A.INVESTMENT_ID,
                                 A.INVESTMENT_NAME,
                                 CASE
                                    WHEN A.TOTAL_HOURS = 0
                                         OR A.TOTAL_HOURS IS NULL
                                    THEN
                                       0
                                    ELSE
                                       ROUND (
                                          (A.OH_HOURS / A.TOTAL_HOURS)
                                          / CASE WHEN TO_CHAR({?date_param},'YYYY') = '2011' THEN TO_NUMBER(TO_CHAR({?date_param},'MM')) - 4 ELSE TO_NUMBER(TO_CHAR({?date_param},'MM')) END,
                                          4)
                                 END
                                    OH_L5
                            FROM (  SELECT OH.L2_NAME,
                                           OH.L2_UNIT,
                                           OH.L3_NAME,
                                           OH.L3_UNIT,
                                           OH.L4_NAME,
                                           OH.L4_UNIT,
                                           OH.L5_NAME,
                                           OH.L5_UNIT,
                                           OH.INVESTMENT_ID,
                                           OH.INVESTMENT_NAME,
                                           SUM (OH.OH_HOURS) OH_HOURS,
                                           SUM (TOTAL.TOTAL_HOURS) TOTAL_HOURS
                                      FROM (  SELECT L2.NAME L2_NAME,
                                                     L2.LINKED_UNIT_ID L2_UNIT,
                                                     L3.NAME L3_NAME,
                                                     L3.LINKED_UNIT_ID L3_UNIT,
                                                     L4.NAME L4_NAME,
                                                     L4.LINKED_UNIT_ID L4_UNIT,
                                                     L5.NAME L5_NAME,
                                                     L5.LINKED_UNIT_ID L5_UNIT,
                                                     W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     W.PROJECT_CODE INVESTMENT_ID,
                                                     I.NAME INVESTMENT_NAME,
                                                     SUM (W.QUANTITY) OH_HOURS
                                                FROM WARM01.PPA_WIP W,
                                                     WARM01.INV_INVESTMENTS I,
                                                     WARM01.DEPARTMENTS D,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 2
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L2,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 3
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L3,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 4
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L4,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 5
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L5
                                               WHERE W.PROJECT_CODE = I.CODE
                                                     AND W.EMPLYHOMEDEPART =
                                                            D.DEPARTCODE
                                                     AND D.OBS_UNIT_ID = L2.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L3.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L4.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L5.UNIT_ID
                                                     AND W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND TO_CHAR(W.MONTH_BEGIN,'YYYY') = TO_CHAR({?date_param},'YYYY')
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                                     AND I.ODF_OBJECT_CODE IN
                                                            ('other')
                                            GROUP BY L2.NAME,
                                                     L2.LINKED_UNIT_ID,
                                                     L3.NAME,
                                                     L3.LINKED_UNIT_ID,
                                                     L4.NAME,
                                                     L4.LINKED_UNIT_ID,
                                                     L5.NAME,
                                                     L5.LINKED_UNIT_ID,
                                                     W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN,
                                                     W.PROJECT_CODE,
                                                     I.NAME,
                                                     I.ODF_OBJECT_CODE) OH,
                                           (  SELECT W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     SUM (W.QUANTITY) TOTAL_HOURS
                                                FROM WARM01.PPA_WIP W
                                               WHERE     W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                            GROUP BY W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN) TOTAL
                                     WHERE OH.EMPLYHOMEDEPART =
                                              TOTAL.EMPLYHOMEDEPART
                                           AND OH.MONTH_BEGIN = TOTAL.MONTH_BEGIN
                                           AND TO_DATE(OH.MONTH_BEGIN,'YYYYMMDD') < LAST_DAY({?date_param})
                                  GROUP BY OH.L2_NAME,
                                           OH.L2_UNIT,
                                           OH.L3_NAME,
                                           OH.L3_UNIT,
                                           OH.L4_NAME,
                                           OH.L4_UNIT,
                                           OH.L5_NAME,
                                           OH.L5_UNIT,
                                           OH.INVESTMENT_ID,
                                           OH.INVESTMENT_NAME) A) OH_L5,
                         (SELECT A.L3_UNIT,
                                 A.INVESTMENT_ID,
                                 CASE
                                    WHEN A.TOTAL_HOURS = 0
                                         OR A.TOTAL_HOURS IS NULL
                                    THEN
                                       0
                                    ELSE
                                       ROUND (
                                          (A.OH_HOURS / A.TOTAL_HOURS)
                                          / CASE WHEN TO_CHAR({?date_param},'YYYY') = '2011' THEN TO_NUMBER(TO_CHAR({?date_param},'MM')) - 4 ELSE TO_NUMBER(TO_CHAR({?date_param},'MM')) END,
                                          4)
                                 END
                                    OH_L3
                            FROM (  SELECT OH.L3_NAME,
                                           OH.L3_UNIT,
                                           OH.INVESTMENT_ID,
                                           OH.INVESTMENT_NAME,
                                           SUM (OH.OH_HOURS) OH_HOURS,
                                           SUM (TOTAL.TOTAL_HOURS) TOTAL_HOURS
                                      FROM (  SELECT L3.NAME L3_NAME,
                                                     L3.LINKED_UNIT_ID L3_UNIT,
                                                     L4.NAME L4_NAME,
                                                     L4.LINKED_UNIT_ID L4_UNIT,
                                                     L5.NAME L5_NAME,
                                                     L5.LINKED_UNIT_ID L5_UNIT,
                                                     W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     W.PROJECT_CODE INVESTMENT_ID,
                                                     I.NAME INVESTMENT_NAME,
                                                     SUM (W.QUANTITY) OH_HOURS
                                                FROM WARM01.PPA_WIP W,
                                                     WARM01.INV_INVESTMENTS I,
                                                     WARM01.DEPARTMENTS D,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 3
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L3,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 4
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L4,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 5
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L5
                                               WHERE W.PROJECT_CODE = I.CODE
                                                     AND W.EMPLYHOMEDEPART =
                                                            D.DEPARTCODE
                                                     AND D.OBS_UNIT_ID = L3.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L4.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L5.UNIT_ID
                                                     AND W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND TO_CHAR(W.MONTH_BEGIN,'YYYY') = TO_CHAR({?date_param},'YYYY')
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                                     AND I.ODF_OBJECT_CODE IN
                                                            ('other')
                                            GROUP BY L3.NAME,
                                                     L3.LINKED_UNIT_ID,
                                                     L4.NAME,
                                                     L4.LINKED_UNIT_ID,
                                                     L5.NAME,
                                                     L5.LINKED_UNIT_ID,
                                                     W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN,
                                                     W.PROJECT_CODE,
                                                     I.NAME,
                                                     I.ODF_OBJECT_CODE) OH,
                                           (  SELECT W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     SUM (W.QUANTITY) TOTAL_HOURS
                                                FROM WARM01.PPA_WIP W
                                               WHERE     W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                            GROUP BY W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN) TOTAL
                                     WHERE OH.EMPLYHOMEDEPART =
                                              TOTAL.EMPLYHOMEDEPART
                                           AND OH.MONTH_BEGIN = TOTAL.MONTH_BEGIN
                                           AND TO_DATE(OH.MONTH_BEGIN,'YYYYMMDD') < LAST_DAY({?date_param})
                                  GROUP BY OH.L3_UNIT, OH.INVESTMENT_ID) A) OH_L3,
                         (SELECT A.L4_UNIT,
                                 A.INVESTMENT_ID,
                                 CASE
                                    WHEN A.TOTAL_HOURS = 0
                                         OR A.TOTAL_HOURS IS NULL
                                    THEN
                                       0
                                    ELSE
                                       ROUND (
                                          (A.OH_HOURS / A.TOTAL_HOURS)
                                          / CASE WHEN TO_CHAR({?date_param},'YYYY') = '2011' THEN TO_NUMBER(TO_CHAR({?date_param},'MM')) - 4 ELSE TO_NUMBER(TO_CHAR({?date_param},'MM')) END,
                                          4)
                                 END
                                    OH_L4
                            FROM (  SELECT OH.L4_NAME,
                                           OH.L4_UNIT,
                                           OH.INVESTMENT_ID,
                                           OH.INVESTMENT_NAME,
                                           SUM (OH.OH_HOURS) OH_HOURS,
                                           SUM (TOTAL.TOTAL_HOURS) TOTAL_HOURS
                                      FROM (  SELECT L3.NAME L3_NAME,
                                                     L3.LINKED_UNIT_ID L3_UNIT,
                                                     L4.NAME L4_NAME,
                                                     L4.LINKED_UNIT_ID L4_UNIT,
                                                     L5.NAME L5_NAME,
                                                     L5.LINKED_UNIT_ID L5_UNIT,
                                                     W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     W.PROJECT_CODE INVESTMENT_ID,
                                                     I.NAME INVESTMENT_NAME,
                                                     SUM (W.QUANTITY) OH_HOURS
                                                FROM WARM01.PPA_WIP W,
                                                     WARM01.INV_INVESTMENTS I,
                                                     WARM01.DEPARTMENTS D,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 3
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L3,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 4
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L4,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 5
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L5
                                               WHERE W.PROJECT_CODE = I.CODE
                                                     AND W.EMPLYHOMEDEPART =
                                                            D.DEPARTCODE
                                                     AND D.OBS_UNIT_ID = L3.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L4.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L5.UNIT_ID
                                                     AND W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND TO_CHAR(W.MONTH_BEGIN,'YYYY') = TO_CHAR({?date_param},'YYYY')
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                                     AND I.ODF_OBJECT_CODE IN
                                                            ('other')
                                            GROUP BY L3.NAME,
                                                     L3.LINKED_UNIT_ID,
                                                     L4.NAME,
                                                     L4.LINKED_UNIT_ID,
                                                     L5.NAME,
                                                     L5.LINKED_UNIT_ID,
                                                     W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN,
                                                     W.PROJECT_CODE,
                                                     I.NAME,
                                                     I.ODF_OBJECT_CODE) OH,
                                           (  SELECT W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     SUM (W.QUANTITY) TOTAL_HOURS
                                                FROM WARM01.PPA_WIP W
                                               WHERE     W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                            GROUP BY W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN) TOTAL
                                     WHERE OH.EMPLYHOMEDEPART =
                                              TOTAL.EMPLYHOMEDEPART
                                           AND OH.MONTH_BEGIN = TOTAL.MONTH_BEGIN
                                           AND TO_DATE(OH.MONTH_BEGIN,'YYYYMMDD') < LAST_DAY({?date_param})
                                  GROUP BY OH.L4_UNIT, OH.INVESTMENT_ID) A) OH_L4,
                         (SELECT A.L2_UNIT,
                                 A.INVESTMENT_ID,
                                 CASE
                                    WHEN A.TOTAL_HOURS = 0
                                         OR A.TOTAL_HOURS IS NULL
                                    THEN
                                       0
                                    ELSE
                                       ROUND (
                                          (A.OH_HOURS / A.TOTAL_HOURS)
                                          / CASE WHEN TO_CHAR({?date_param},'YYYY') = '2011' THEN TO_NUMBER(TO_CHAR({?date_param},'MM')) - 4 ELSE TO_NUMBER(TO_CHAR({?date_param},'MM')) END,
                                          4)
                                 END
                                    OH_L2
                            FROM (  SELECT OH.L2_NAME,
                                           OH.L2_UNIT,
                                           OH.INVESTMENT_ID,
                                           OH.INVESTMENT_NAME,
                                           SUM (OH.OH_HOURS) OH_HOURS,
                                           SUM (TOTAL.TOTAL_HOURS) TOTAL_HOURS
                                      FROM (  SELECT L2.NAME L2_NAME,
                                                     L2.LINKED_UNIT_ID L2_UNIT,
                                                     W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     W.PROJECT_CODE INVESTMENT_ID,
                                                     I.NAME INVESTMENT_NAME,
                                                     SUM (W.QUANTITY) OH_HOURS
                                                FROM WARM01.PPA_WIP W,
                                                     WARM01.INV_INVESTMENTS I,
                                                     WARM01.DEPARTMENTS D,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 2
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L2,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 3
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L3,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 4
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L4,
                                                     (  SELECT O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME
                                                          FROM OBS_UNITS_V O,
                                                               PRJ_OBS_TYPES T
                                                         WHERE O.TYPE_ID = T.ID
                                                               AND O.DEPTH = 5
                                                               AND O.UNIT_MODE =
                                                                      'OBS_UNIT_AND_ANCESTORS'
                                                               AND T.ID = 5000001
                                                      GROUP BY O.UNIT_ID,
                                                               O.LINKED_UNIT_ID,
                                                               O.NAME) L5
                                               WHERE W.PROJECT_CODE = I.CODE
                                                     AND W.EMPLYHOMEDEPART =
                                                            D.DEPARTCODE
                                                     AND D.OBS_UNIT_ID = L2.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L3.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L4.UNIT_ID
                                                     AND D.OBS_UNIT_ID = L5.UNIT_ID
                                                     AND W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND TO_CHAR(W.MONTH_BEGIN,'YYYY') = TO_CHAR({?date_param},'YYYY')
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                                     AND I.ODF_OBJECT_CODE IN
                                                            ('other')
                                            GROUP BY L2.NAME,
                                                     L2.LINKED_UNIT_ID,
                                                     W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN,
                                                     W.PROJECT_CODE,
                                                     I.NAME,
                                                     I.ODF_OBJECT_CODE) OH,
                                           (  SELECT W.EMPLYHOMEDEPART,
                                                     TO_CHAR (W.MONTH_BEGIN,
                                                              'YYYYMMDD')
                                                        MONTH_BEGIN,
                                                     SUM (W.QUANTITY) TOTAL_HOURS
                                                FROM WARM01.PPA_WIP W
                                               WHERE     W.ENTITY = 'CID'
                                                     AND W.SOURCEMODULE NOT IN (50)
                                                     AND W.IN_ERROR = 0
                                                     AND W.ON_HOLD = 0
                                                     AND W.STATUS NOT IN (2, 8)
                                                     AND W.TRANSTYPE = 'L'
                                            GROUP BY W.EMPLYHOMEDEPART,
                                                     W.MONTH_BEGIN) TOTAL
                                     WHERE OH.EMPLYHOMEDEPART =
                                              TOTAL.EMPLYHOMEDEPART
                                           AND OH.MONTH_BEGIN = TOTAL.MONTH_BEGIN
                                           AND TO_DATE(OH.MONTH_BEGIN,'YYYYMMDD') < LAST_DAY({?date_param})
                                  GROUP BY OH.L2_NAME,
                                           OH.L2_UNIT,
                                           OH.INVESTMENT_ID,
                                           OH.INVESTMENT_NAME) A) OH_L2
                   WHERE     OH_L5.L3_UNIT = OH_L3.L3_UNIT
                         AND OH_L5.INVESTMENT_ID = OH_L3.INVESTMENT_ID
                         AND OH_L5.L4_UNIT = OH_L4.L4_UNIT
                         AND OH_L5.INVESTMENT_ID = OH_L4.INVESTMENT_ID
                         AND OH_L5.L2_UNIT = OH_L2.L2_UNIT
                         AND OH_L5.INVESTMENT_ID = OH_L2.INVESTMENT_ID) X) Z
GROUP BY Z.L2_NAME,
         Z.L3_NAME,
         Z.L4_NAME,
         Z.L5_NAME,
         Z.L2_UNIT,
         Z.L3_UNIT,
         Z.L4_UNIT,
         Z.L5_UNIT