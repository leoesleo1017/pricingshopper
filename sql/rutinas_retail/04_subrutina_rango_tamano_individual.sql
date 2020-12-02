DROP TABLE IF EXISTS PUBLIC.temp_04_rango_tamano_individual;
CREATE TABLE PUBLIC.temp_04_rango_tamano_individual AS 

WITH 
rango_tamano_individual AS (
	SELECT *
	FROM PUBLIC.ca_rango_tamano_individual a
	JOIN PUBLIC.ma_subcategory b ON a.idsubcategory = b.idsubcategory		
),

calculo_rango_tamano_individual AS (
	SELECT a.producto,
			 CASE 
				WHEN e."segmento" = '' AND a."peso_individual" >= e."peso_individual_ini" AND a."peso_individual" < e."peso_individual_fin" THEN e."rango_tamano_individual" 
				WHEN e."segmento" = a."SEGMENTO" AND  a."peso_individual" >= e."peso_individual_ini" AND a."peso_individual" < e."peso_individual_fin" THEN e."rango_tamano_individual" 
			 END AS RANGO_TAMANO_INDIVIDUAL			 
	FROM PUBLIC.temp_03_var_adi_rangos a
	JOIN rango_tamano_individual e ON a."SUBCATEGORY" = e."subcategory"
),

rango_tamano_individual_distinct AS (
	SELECT DISTINCT *
	FROM calculo_rango_tamano_individual
	WHERE RANGO_TAMANO_INDIVIDUAL IS NOT NULL 
),

rango_tamano_individual_row_number AS (
	SELECT *,row_number() OVER (partition BY producto ORDER BY producto) AS rownum 
	FROM rango_tamano_individual_distinct
)

SELECT * 
FROM rango_tamano_individual_row_number
WHERE rownum = 1