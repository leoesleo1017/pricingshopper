-- calcular tabla nuevos productos --
WITH 
ventas AS (
	SELECT  *,
			 (CASE WHEN "VENTAS_EN_VALOR_000000" = -1 THEN 0 ELSE "VENTAS_EN_VALOR_000000"*1000000 END) AS VENTAS_VALOR_nls,
			 (CASE WHEN "VENTAS_EN_VOLUMEN_KILOS_000" = -1 THEN 0 ELSE "VENTAS_EN_VOLUMEN_KILOS_000"*1000 END) AS VENTAS_VOLUMEN_nls,
			 "COD_TAG" AS "PRODUCTO_nls"
	FROM PUBLIC.nielsen_retail_jul_20
),

v_nuevos_productos AS (
	SELECT "PERIODO", 
			"PRODUCTO_nls",
		   "DUP_PRODUCTO",
		   "DUP_CATEGORIA",
		   "TAMANO",
		   SUM("ventas_valor_nls") AS ventas_valor_nls,
		   SUM("ventas_volumen_nls") AS ventas_volumen_nls
	FROM ventas
	GROUP BY "PERIODO","PRODUCTO_nls","DUP_PRODUCTO","DUP_CATEGORIA","TAMANO"
),

v_nuevos_productos2 AS (
	SELECT "PERIODO", 
			"DUP_CATEGORIA",
		   COUNT(1) AS "totalProductos"
	FROM ventas
	GROUP BY "PERIODO","DUP_CATEGORIA"
),

v_nuevos_productos3 AS (
	SELECT a."PERIODO",
			 a."DUP_CATEGORIA",
			 COUNT(1) AS "productosNuevos"
	FROM v_nuevos_productos a
	JOIN PUBLIC.ma_peso b ON a."PRODUCTO_nls" = b."producto_nls"
	GROUP BY a."PERIODO",a."DUP_CATEGORIA"
),

v_comparacion_nuevos_productos4 AS (
	SELECT *
	FROM v_nuevos_productos2 a
	JOIN v_nuevos_productos3 b ON a."DUP_CATEGORIA" = b."DUP_CATEGORIA"
)

SELECT *, 
		 "productosNuevos"/"totalProductos"::NUMERIC AS porcentaje
FROM v_comparacion_nuevos_productos4


---------------------------------------------------------------------------------------
-- porcentaje de ceros en valores problema

WITH 
ventas AS (
	SELECT  *,
			 (CASE WHEN "VENTAS_EN_VALOR_000000" = -1 THEN 0 ELSE "VENTAS_EN_VALOR_000000"*1000000 END) AS VENTAS_VALOR_nls,
			 (CASE WHEN "VENTAS_EN_VOLUMEN_KILOS_000" = -1 THEN 0 ELSE "VENTAS_EN_VOLUMEN_KILOS_000"*1000 END) AS VENTAS_VOLUMEN_nls,
			 "COD_TAG" AS "PRODUCTO_nls"
	FROM PUBLIC.nielsen_retail_jul_20
),

total_registros AS (
	SELECT COUNT(1) AS "totalRegistros"
	FROM ventas
),

ventasCero AS (
	SELECT COUNT(1) AS "ventasenCero"
	FROM ventas a,total_registros b
	WHERE "ventas_valor_nls" = 0
)

SELECT b."ventasenCero"/a."totalRegistros"::NUMERIC
FROM total_registros a,ventasCero b

----------------------
-- otros querys

/*
mercados AS ( -- validar dado que si tiene registros y debe dar cero
	SELECT a.*,
		   b.region_nls || '-' || b.canal_nls AS MERCADO_,	
		   b.mercado_nls,
		   b.region_nls,
		   b.canal_nls
	-- SUM(a."ventas_valor_nls"),SUM(a."ventas_volumen_nls")
	FROM PUBLIC.temp_s_min_level a
	JOIN PUBLIC.ma_mercado b ON a."MERCADO" = b."mercado_nls"
	WHERE b."select_" = 'TRUE'  
	-- OR b."select_" = 'TOTAL'
),
*/


/*
v_nuevos_productos AS (
	SELECT "producto_nls",
		   "DUP_PRODUCTO",
		   "DUP_CATEGORIA",
		   "TAMANO",
		   SUM("ventas_valor_nls") AS ventas_valor_nls,
		   SUM("ventas_volumen_nls") AS ventas_volumen_nls
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
			 COUNT(1) AS "totalProductos"
	FROM v_nuevos_productos a
	JOIN PUBLIC.ma_peso b ON a."producto_nls" = b."producto_nls"
	GROUP BY a."DUP_CATEGORIA"
),

v_nuevos_productos4 AS (
	SELECT *
	FROM v_nuevos_productos2 a
	JOIN v_nuevos_productos3 b ON a."DUP_CATEGORIA" = b."DUP_CATEGORIA"
),
Nota: las vistas: {
	v_nuevos_productos 
	v_nuevos_productos2
	v_nuevos_productos3
	v_nuevos_productos4
	}
se deben quitar y poner en un query a parte para que sean vistos por el usuario
*/
