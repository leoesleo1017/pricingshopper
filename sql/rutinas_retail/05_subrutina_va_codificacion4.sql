DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion4;
CREATE TABLE PUBLIC.temp_05_va_codificacion4 AS 

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'SABOR'
	AND "tipo_codificacion" = 'SEGM_PRECIO' 
	AND "tipo_codificacion" = 'SEGMENTO'
	AND "tipo_codificacion" = 'SEGMENTO_NOEL'
	AND "tipo_codificacion" = 'NIVELDEAZUCAR'
	AND "tipo_codificacion" = 'PRESENTACION'
)

SELECT a.*,
		 l."codificacion" AS "COD_NIVELDEAZUCAR",
		 ll."codificacion" AS "COD_PRESENTACION",
		 m."codificacion" AS "COD_SABOR",
		 n."codificacion" AS "COD_SEGM_PRECIO",
		 o."codificacion" AS "COD_SEGMENTO",
		 p."codificacion" AS "COD_SEGMENTO_NOEL"			
FROM PUBLIC.temp_05_va_codificacion3 a
LEFT JOIN _va_codificacion l ON a."NIVELDEAZUCAR" = l."descripcion" 
LEFT JOIN _va_codificacion ll ON a."PRESENTACION" = ll."descripcion" 
LEFT JOIN _va_codificacion m ON a."SABOR" = m."descripcion" 
LEFT JOIN _va_codificacion n ON a."SEGM_PRECIO" = n."descripcion" 
LEFT JOIN _va_codificacion o ON a."SEGMENTO" = o."descripcion" 
LEFT JOIN _va_codificacion p ON a."SEGMENTO_NOEL" = p."descripcion"