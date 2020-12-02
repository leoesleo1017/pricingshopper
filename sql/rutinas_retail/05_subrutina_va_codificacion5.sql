DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion5;
CREATE TABLE PUBLIC.temp_05_va_codificacion5 AS 

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'SEGMENTO_TMLUC'
	AND "tipo_codificacion" = 'SUBCATEGORY'
	AND "tipo_codificacion" = 'SUBCLINEA'
	AND "tipo_codificacion" = 'SUBMARCA'
	AND "tipo_codificacion" = 'SUBSEGMENTO_NOEL'
)

SELECT a.*,
		 q."codificacion" AS "COD_SEGMENTO_TMLUC",
		 r."codificacion" AS "COD_SUBCATEGORY",
		 s."codificacion" AS "COD_SUBLINEA",
         t."codificacion" AS "COD_SUBMARCA",
		 u."codificacion" AS "COD_SUBSEGMENTO_NOEL"		 
FROM PUBLIC.temp_05_va_codificacion4 a
LEFT JOIN _va_codificacion q ON a."SEGMENTO_TMLUC" = q."descripcion" 
LEFT JOIN _va_codificacion r ON a."SUBCATEGORY" = r."descripcion" 
LEFT JOIN _va_codificacion s ON a."SUBLINEA" = s."descripcion" 
LEFT JOIN _va_codificacion t ON a."SUBMARCA" = t."descripcion" 
LEFT JOIN _va_codificacion u ON a."SUBSEGMENTO_NOEL" = u."descripcion"