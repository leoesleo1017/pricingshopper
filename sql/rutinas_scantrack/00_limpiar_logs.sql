DROP TABLE IF EXISTS PUBLIC.temp_conf_log_historico;
CREATE TABLE PUBLIC.temp_conf_log_historico AS 
SELECT *
FROM PUBLIC.conf_logs
UNION 
SELECT *
FROM PUBLIC.conf_log_historico;

DROP TABLE IF EXISTS PUBLIC.conf_log_historico;
CREATE TABLE PUBLIC.conf_log_historico AS 
SELECT *
FROM PUBLIC.temp_conf_log_historico;

DROP TABLE IF EXISTS PUBLIC.temp_conf_log_historico;
DELETE FROM PUBLIC.conf_logs; 