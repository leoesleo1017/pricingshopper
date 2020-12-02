DROP TABLE IF EXISTS PUBLIC.temp_04_rango_tamano;
CREATE TABLE PUBLIC.temp_04_rango_tamano AS 

WITH 
rango_tamano AS (
	SELECT *
	FROM PUBLIC.ca_rango_tamano a
	JOIN PUBLIC.ma_subcategory b ON a.idsubcategory = b.idsubcategory
),

calculo_rango_tamano AS (
	SELECT a.producto,
			 CASE 
				WHEN d."segmento" = '' AND a."peso"::NUMERIC >= d."peso_ini" AND a."peso"::NUMERIC < d."peso_fin" THEN d."rango_tamano" 
				WHEN d."segmento" = a."SEGMENTO" AND  a."peso"::NUMERIC >= d."peso_ini" AND a."peso"::NUMERIC < d."peso_fin" THEN d."rango_tamano" 
			 END AS RANGO_TAMANO
	FROM PUBLIC.temp_03_var_adi_rangos a
	JOIN rango_tamano d ON a."SUBCATEGORY" = d."subcategory"
),

rango_tamano_distinct AS (
	SELECT DISTINCT *
	FROM calculo_rango_tamano
	WHERE RANGO_TAMANO IS NOT NULL 
	-- AND producto = 'N40068565'
),

rango_tamano_row_number AS (
	SELECT *,row_number() OVER (partition BY producto ORDER BY producto) AS rownum 
	FROM rango_tamano_distinct
)

SELECT * 
FROM rango_tamano_row_number
WHERE rownum = 1