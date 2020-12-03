DROP TABLE IF EXISTS PUBLIC.temp_06_productos;
CREATE TABLE PUBLIC.temp_06_productos AS 

WITH 
periodo_act_ordenado AS ( -- VALIDAR ORDENADO DADO QUUE SOLO HAY CARGADO UN MES
	SELECT "PRODUCTO","FECHA","COD_NEGOCIO","COD_FUENTE","DES_PRODUCTO"
	FROM PUBLIC.temp_05_va_codificacion7
	ORDER BY "FECHA" DESC
	-- LIMIT 10
),

periodo_act_ordenado2 AS (
	SELECT DISTINCT  -- VALIDAR, ESTA CONSULTA SE DEBE GUARDAR COMO PRODUCTO, HACE PARTE DE LOS ENTREGABLES
			 'P' || "COD_FUENTE" || RIGHT("COD_NEGOCIO",2) || "PRODUCTO" AS "COD_PRODUCTO",			 
			 "PRODUCTO",
			 "DES_PRODUCTO",			 
			 1 AS "PERDIODO_ACT"
	FROM periodo_act_ordenado
	-- WHERE "producto" = 'N40011384'
),

periodo_ant_ordenado AS (
	SELECT "COD_PRODUCTO",
			 SUBSTRING("COD_PRODUCTO",6) AS "PRODUCTO", 
			 "DES_PRODUCTO",
			 0 AS "PERDIODO_ACT"
	FROM sa_producto
),

producto AS ( -- validar dado que se debe garantizar un productos unicos de acuerdo con el periodo_act = 1 para garantizar las caracteristicas recientes
	SELECT *
	FROM periodo_act_ordenado2
	UNION
	SELECT *
	FROM periodo_ant_ordenado
),

producto_row_number AS (
	SELECT *,row_number() OVER (partition BY "COD_PRODUCTO" ORDER BY "COD_PRODUCTO","DES_PRODUCTO" DESC) AS rownum 
	FROM producto
)

SELECT "COD_PRODUCTO","DES_PRODUCTO"
FROM producto_row_number
WHERE rownum = 1;

-- actualizar tabla sa_producto
DROP TABLE IF EXISTS PUBLIC.temp_06_productos_;
CREATE TABLE PUBLIC.temp_06_productos_ AS 
SELECT "COD_PRODUCTO","DES_PRODUCTO"
FROM PUBLIC.sa_producto
UNION ALL
SELECT *
FROM PUBLIC.temp_06_productos;

DROP TABLE IF EXISTS PUBLIC.sa_producto;
CREATE TABLE PUBLIC.sa_producto AS 
SELECT *
FROM PUBLIC.temp_06_productos_;

DROP TABLE IF EXISTS PUBLIC.temp_06_productos_;