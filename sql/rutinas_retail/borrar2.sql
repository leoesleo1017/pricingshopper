DROP TABLE IF EXISTS PUBLIC.temp_borrar;
CREATE TABLE PUBLIC.temp_borrar AS 
select *
from PUBLIC.ma_tipo_codificacion 
where estado_retail = 1
AND inicial = '{inicial}'