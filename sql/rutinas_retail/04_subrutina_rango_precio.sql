DROP TABLE IF EXISTS PUBLIC.temp_04_rango_precio;
CREATE TABLE PUBLIC.temp_04_rango_precio AS 

WITH 
rango_precio AS (
	SELECT *
	FROM PUBLIC.ca_rango_precio a
	JOIN PUBLIC.ma_subcategory b ON a.idsubcategory = b.idsubcategory
),

calculo_rango_precio AS (
	SELECT a.producto,
			 CASE 
				WHEN b."segmento" = '' AND a."precio_multiempaque" >= b."precio_multiempaque_ini" AND a."precio_multiempaque" < b."precio_multiempaque_fin" THEN b."rango_precio" 
				WHEN b."segmento" = a."SEGMENTO" AND  a."precio_multiempaque" >= b."precio_multiempaque_ini" AND a."precio_multiempaque" < b."precio_multiempaque_fin" THEN b."rango_precio" 
			 END AS RANGO_PRECIO
	FROM PUBLIC.temp_03_var_adi_rangos a
	JOIN rango_precio b ON a."SUBCATEGORY" = b."subcategory"
),

rango_precio_distinct AS (
	SELECT DISTINCT *
	FROM calculo_rango_precio
	WHERE RANGO_PRECIO IS NOT NULL
),

rango_precio_row_number AS (
	SELECT *,row_number() OVER (partition BY producto ORDER BY producto) AS rownum 
	FROM rango_precio_distinct
)

SELECT * 
FROM rango_precio_row_number
WHERE rownum = 1

