DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion3;
CREATE TABLE PUBLIC.temp_05_va_codificacion3 AS 

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'FAMILIA'
	AND "tipo_codificacion" = 'FAMILIA_DE_EMPAQUE' 
	AND "tipo_codificacion" = 'FORMA'
	AND "tipo_codificacion" = 'INTEGRALNOINTEGRAL'
	AND "tipo_codificacion" = 'LINEA'
	AND "tipo_codificacion" = 'MARCA'
)

SELECT a.*,
	   f."codificacion" AS "COD_FAMILIA",
	   g."codificacion" AS "COD_FAMILIA_DE_EMPAQUE",
	   h."codificacion" AS "COD_FORMA",
	   i."codificacion" AS "COD_INTEGRALNOINTEGRAL",
       j."codificacion" AS "COD_LINEA",
	   k."codificacion" AS "COD_MARCA"	   
FROM PUBLIC.temp_05_va_codificacion2 a
LEFT JOIN _va_codificacion f ON a."FAMILIA" = f."descripcion"
LEFT JOIN _va_codificacion g ON a."FAMILIA_DE_EMPAQUE" = g."descripcion" 
LEFT JOIN _va_codificacion h ON a."FORMA" = h."descripcion" 
LEFT JOIN _va_codificacion i ON a."INTEGRALNOINTEGRAL" = i."descripcion" 
LEFT JOIN _va_codificacion j ON a."LINEA" = j."descripcion" 
LEFT JOIN _va_codificacion k ON a."MARCA" = k."descripcion_" 