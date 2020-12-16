DROP TABLE IF EXISTS PUBLIC.temp_01_productos_nuevos;
CREATE TABLE PUBLIC.temp_01_productos_nuevos AS 

WITH 
reduc_cod_pdto1 AS ( 
	SELECT *,			
			"COD_TAG",'P' || SUBSTRING("COD_TAG", 13, 1) || RIGHT("COD_TAG",8) AS PRODUCTO_nls
	FROM PUBLIC.temp_s_min_level
),

valores_problema AS ( -- pendiente sacar el porcentaje de ceros
	SELECT *,
	   "REGION_NLS" || '-' || "CANAL_NLS" AS MERCADO_,  -- los mercados son ciudades principales y no regiones como en retail
		ROUND("VENTAS_VALOR_nls"::numeric,2) AS "_ventas_valor_nls",
		ROUND("VENTAS_VOLUMEN_nls"::numeric,2)	AS "_ventas_volumen_nls"
	FROM reduc_cod_pdto1
	WHERE "VENTAS_VOLUMEN_nls" > 0
	AND "VENTAS_VALOR_nls" > 0
),

v_nuevos_productos AS (
	SELECT "producto_nls",
		   "DUP_PRODUCTO",
		   "DUP_CATEGORIA",
		   "TAMANO",
		   SUM("VENTAS_VALOR_nls") AS ventas_valor_nls,
		   SUM("VENTAS_VOLUMEN_nls") AS ventas_volumen_nls
	FROM valores_problema
	GROUP BY "producto_nls","DUP_PRODUCTO","DUP_CATEGORIA","TAMANO"
),

v_nuevos_productos2 AS (
	SELECT "DUP_CATEGORIA",
		   COUNT(1) AS "totalProductos"
	FROM valores_problema
	GROUP BY "DUP_CATEGORIA"
),

v_nuevos_productos3 AS (
	SELECT a."DUP_CATEGORIA",
			 COUNT(1) AS "totalProductosb"
	FROM v_nuevos_productos a
	JOIN scantrack.ma_peso b ON a."producto_nls" = b."producto_nls"
	GROUP BY a."DUP_CATEGORIA"
),

v_nuevos_productos4 AS ( -- esta vista debe ir en una tabla para ir consolidando cada vez que corra el proceso en retail y scantrack, garantizar registros unicos en la tabla por categoria, para los casos que se necesite correr un mes de nuevo por algún error
	SELECT a."DUP_CATEGORIA",a."totalProductos",b."totalProductosb"
	FROM v_nuevos_productos2 a
	JOIN v_nuevos_productos3 b ON a."DUP_CATEGORIA" = b."DUP_CATEGORIA"
)

SELECT *
FROM v_nuevos_productos4;

-- actualizar tabla ma_productos_nuevos
DROP TABLE IF EXISTS PUBLIC.temp_01_productos_nuevos_;
CREATE TABLE PUBLIC.temp_01_productos_nuevos_ AS 
SELECT *
FROM scantrack.ma_productos_nuevos -- tabla pendient por crear
UNION ALL
SELECT *
FROM PUBLIC.temp_01_productos_nuevos;

DROP TABLE IF EXISTS PUBLIC.ma_productos_nuevos;
CREATE TABLE PUBLIC.ma_productos_nuevos AS 
SELECT *
FROM PUBLIC.temp_01_productos_nuevos_;

