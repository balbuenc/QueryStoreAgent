-- export_query_store.sql
SET NOCOUNT ON;

SELECT 
    qt.query_sql_text,
    q.query_id,
    p.plan_id,
    rs.avg_duration,
    rs.execution_type_desc,
    rs.count_executions,
    rs.last_execution_time,
    p.query_plan,
    ws.wait_category_desc,
    ws.total_query_wait_time_ms,
    ws.total_query_wait_time_ms / NULLIF(rs.count_executions, 0) AS avg_wait_ms
FROM 
    sys.query_store_query_text AS qt
JOIN 
    sys.query_store_query AS q ON qt.query_text_id = q.query_text_id
JOIN 
    sys.query_store_plan AS p ON q.query_id = p.query_id
JOIN 
    sys.query_store_runtime_stats AS rs ON p.plan_id = rs.plan_id
LEFT JOIN 
    sys.query_store_wait_stats AS ws ON rs.runtime_stats_interval_id = ws.runtime_stats_interval_id
    AND p.plan_id = ws.plan_id
WHERE 
    rs.last_execution_time >= DATEADD(MINUTE, -60, GETDATE());
