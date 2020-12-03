-- actualizar tabla ventas
DROP TABLE IF EXISTS PUBLIC.temp_09_transaccional_;
CREATE TABLE PUBLIC.temp_09_transaccional_ AS 
SELECT *
FROM PUBLIC.temp_09_transaccional_ventas
UNION ALL 
SELECT *
FROM PUBLIC.temp_09_transaccional_ventas_historia;

DROP TABLE IF EXISTS PUBLIC.temp_09_transaccional_ventas_historia;
CREATE TABLE PUBLIC.temp_09_transaccional_ventas_historia AS 
SELECT *
FROM PUBLIC.temp_09_transaccional_;

DROP TABLE IF EXISTS PUBLIC.temp_09_transaccional_;