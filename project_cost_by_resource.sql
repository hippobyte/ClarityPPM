SELECT  
  inv.id||''||r.id AS proj_res_int_id,
  r.id AS resource_int_id,
  r.last_name resource_name,
  v.name AS resource_type,
  r2.last_name AS project_role,
  inv.id AS project_int_id,
  inv.name AS project_name,
  SUM(NVL(BASEREC.COST_SUM,0)) AS base_cost,                                                         
	SUM(NVL(act_cost.actual_cost,0)) AS act_cost,
  SUM(NVL(a.prestsum/(case when r.resource_type < 2 then 3600 else  1 end),0)*NVL(rc.cost_rate,0)) AS etc_cost,
  SUM(NVL(act_cost.actual_cost,0)+ (NVL(a.prEstSum/(case when r.resource_type < 2 then 3600 else  1 end),0)*NVL(rc.cost_rate,0))) AS eac_cost,
	CASE WHEN SUM(NVL(BASEREC.COST_SUM,0)) = 0 THEN 0 ELSE ((SUM(NVL(ACT_COST.actual_cost,0)+ (NVL(a.prEstSum/(CASE WHEN r.resource_type < 2 	THEN 3600 ELSE 1 END),0)*NVL(rc.cost_rate,0))) - SUM(BASEREC.COST_SUM)) / SUM(BASEREC.COST_SUM)) * 100 END AS cv_percent,
  CASE WHEN SUM(NVL(BASEREC.COST_SUM,0)) = 0 THEN 0 ELSE ((SUM(NVL(ACT_COST.actual_cost,0)+ (NVL(a.prEstSum/(CASE WHEN r.resource_type < 2 	THEN 3600 ELSE 1 END),0)*NVL(rc.cost_rate,0))) - SUM(BASEREC.COST_SUM)) / SUM(BASEREC.COST_SUM)) * 100 END AS cv_percent_sl
FROM   inv_investments inv
INNER JOIN prteam tm ON inv.id = tm.prProjectID
INNER JOIN srm_resources r ON tm.prResourceID = r.id
LEFT OUTER JOIN cop_proj_task_assign_v x ON inv.id = x.project_id
LEFT OUTER JOIN COP_RES_ACT_COST_V act_cost
ON act_cost.res_id = r.id
                                                	and act_cost.inv_id = inv.id
                                                	AND act_cost.task_id = x.task_id 
                                                LEFT OUTER JOIN cmn_lookups_v v ON r.person_type = v.id 
                                                			AND v.lookup_type = 'SRM_RESOURCE_TYPE' 
                                                LEFT OUTER JOIN srm_resources r2 ON tm.prRoleID = r2.id
                                                LEFT OUTER JOIN nbi_proj_res_rates_and_costs rc ON x.project_id = rc.project_id
                                                			AND x.task_id = rc.task_id AND x.resource_id = rc.resource_id
                                                			AND x.task_finish_date BETWEEN rc.from_date AND rc.to_date
                                                LEFT OUTER JOIN prassignment a ON x.task_id = a.prTaskID
                                                			AND x.resource_id = a.prResourceID                               
                                                LEFT OUTER JOIN PRJ_BASELINE_DETAILS BASEREC ON A.PRID=BASEREC.OBJECT_ID
                                                       		AND 'ASSIGNMENT' = BASEREC.OBJECT_TYPE
                                                       		AND 1=BASEREC.IS_CURRENT
                                                WHERE  a.prresourceid = r.id
                                                GROUP BY r.id
                                                         , r.last_name
                                                         , r.first_name
                                                         , r.person_type
                                                         , v.name                                                    , r2.last_name
                                                         , inv.id
                                                         , inv.name