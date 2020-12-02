DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion2;
CREATE TABLE PUBLIC.temp_05_va_codificacion2 AS 				

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'CATEGORY'
	AND "tipo_codificacion" = 'CONSISTENCIA' 
	AND "tipo_codificacion" = 'EMPAQUE'
	AND "tipo_codificacion" = 'FABRICANTE'
)

SELECT   a.*,
		 b."codificacion" AS "COD_CATEGORY",
		 c."codificacion" AS "COD_CONSISTENCIA",
		 d."codificacion" AS "COD_EMPAQUE",	
		 e."codificacion" AS "COD_FABRICANTE"		
FROM PUBLIC.temp_03_var_adi_rangos a
LEFT JOIN _va_codificacion b ON a."CATEGORY" = b."descripcion" 
LEFT JOIN _va_codificacion c ON a."CONSISTENCIA" = c."descripcion" 
LEFT JOIN _va_codificacion d ON a."EMPAQUE" = d."descripcion" 
LEFT JOIN _va_codificacion e ON a."FABRICANTE" = REPLACE(e."descripcion",'.',' ') 