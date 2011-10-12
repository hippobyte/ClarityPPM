SELECT department "Department",
         exec_name "Executive",
         code "Investment ID",
         pm_name "Project Manager",
         investment_name "Investment Name",
         full_name "Resource Name",
         cc_cd "Resource CC",
         month_begin "Month of Actuals",
         SUM (units) "Units",
         SUM (costs) "Cost"
    FROM (SELECT pdept.name department,
                 exmem.full_name exec_name,
                 i.code,
                 i.name investment_name,
                 r.full_name,
                 pm.full_name pm_name,
                 cc.name cc_cd,
                 month_begin,
                 -- actual cost
                 CASE
                    WHEN wip.transclass = 'Labor'
                    THEN
                       NVL (WIP_VALUES.totalcost, 0) / 94.16
                    ELSE
                       0
                 END
                    units,
                 CASE
                    WHEN wip.transclass = 'Labor'
                    THEN
                       NVL (wip_values.totalcost, 0)
                    ELSE
                       0
                 END
                    costs
            FROM warm01.ppa_wip_values wip_values,
                 warm01.ppa_wip wip,
                 warm01.inv_investments i,
                 warm01.srm_resources pm,
                 warm01.srm_resources r,
                 warm01.srm_resources exmem,
                 warm01.odf_ca_project odf_proj,
                 (SELECT lookup_code id, NAME
                    FROM warm01.cmn_lookups_v
                   WHERE lookup_type = 'OBJ_IDEA_PROJECT_TYPE'
                         AND language_code = 'en') proj_type,
                 WARM01.DEPARTMENTS d,
                 WARM01.DEPARTMENTS pd,
                 (SELECT UNIT_ID, UNIQUE_NAME, NAME
                    FROM WARM01.OBS_UNITS_V
                   WHERE DEPTH = 3 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') pdept,
                 (SELECT UNIT_ID, UNIQUE_NAME, NAME
                    FROM WARM01.OBS_UNITS_V
                   WHERE DEPTH = 5 AND UNIT_MODE = 'OBS_UNIT_AND_ANCESTORS') cc
           WHERE     wip_values.transno = wip.transno
                 AND WIP.INVESTMENT_ID = i.id
                 AND i.id = odf_proj.id
                 AND i.manager_id = pm.user_id(+)
                 AND odf_proj.obj_request_type = proj_type.id(+)
                 AND WIP.RESOURCE_CODE = R.UNIQUE_NAME(+)
                 AND WIP.EMPLYHOMEDEPART = d.DEPARTCODE(+)
                 AND d.OBS_UNIT_ID = cc.UNIT_ID(+)
                 AND WIP.departcode = pd.DEPARTCODE(+)
                 AND pd.OBS_UNIT_ID = pdept.UNIT_ID(+)
                 AND pd.brm_id = exmem.user_id(+)
                 AND wip.status NOT IN (2, 8)
                 AND wip.entity = 'CID'
                 AND wip_values.currency_type = 'BILLING'
                 AND TO_CHAR (wip.month_begin, 'YYYY') =
                        TO_CHAR (SYSDATE, 'YYYY')
                 AND TO_CHAR (wip.month_begin, 'MM') <= TO_CHAR (SYSDATE, 'MM'))
GROUP BY department,
         exec_name,
         code,
         month_begin,
         investment_name,
         pm_name,
         full_name,
         cc_cd
ORDER BY exec_name ASC