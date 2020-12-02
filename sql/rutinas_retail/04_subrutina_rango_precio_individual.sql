DROP TABLE IF EXISTS PUBLIC.temp_04_rango_precio_individual;
CREATE TABLE PUBLIC.temp_04_rango_precio_individual AS 

WITH 
rango_precio_individual AS (
	SELECT *
	FROM PUBLIC.ca_rango_precio_individual a
	JOIN PUBLIC.ma_subcategory b ON a.idsubcategory = b.idsubcategory
),

calculo_rango_precio_individual AS (
	SELECT a.producto,			 
			 CASE 
				WHEN c."segmento" = '' AND a."precio_unidad" >= c."precio_unidad_ini" AND a."precio_unidad" < c."precio_unidad_fin" THEN c."rango_precio_individual" 
				WHEN c."segmento" = a."SEGMENTO" AND  a."precio_unidad" >= c."precio_unidad_ini" AND a."precio_unidad" < c."precio_unidad_fin" THEN c."rango_precio_individual" 
			 END AS RANGO_PRECIO_INDIVIDUAL			 
	FROM PUBLIC.temp_03_var_adi_rangos a
	JOIN rango_precio_individual c ON a."SUBCATEGORY" = c."subcategory"
),

rango_precio_individual_distinct AS (
	SELECT DISTINCT *
	FROM calculo_rango_precio_individual
	WHERE RANGO_PRECIO_INDIVIDUAL IS NOT NULL 
),

rango_precio_individual_row_number AS (
	SELECT *,row_number() OVER (partition BY producto ORDER BY producto) AS rownum 
	FROM rango_precio_individual_distinct
)

SELECT * 
FROM rango_precio_individual_row_number
WHERE rownum = 1