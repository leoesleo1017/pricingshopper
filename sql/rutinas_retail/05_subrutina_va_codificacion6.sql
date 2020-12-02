DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion6;
CREATE TABLE PUBLIC.temp_05_va_codificacion6 AS 

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'SUBTIPO'
	AND "tipo_codificacion" = 'TAMANO_nls' -- con el replace se garantiza la unidad de medida GR para el cruce de datos
	AND "tipo_codificacion" = 'TIPO'
	AND "tipo_codificacion" = 'TIPO_CARNE'
	AND "tipo_codificacion" = 'TIPO_SALCHICHA'
)

SELECT a.*,
		 v."codificacion" AS "COD_SUBTIPO",
		 w."codificacion" AS "COD_TAMANO_nls",
		 x."codificacion" AS "COD_TIPO",
		 y."codificacion" AS "COD_TIPO_CARNE",
		 z."codificacion" AS "COD_TIPO_SALCHICHA"	 
FROM PUBLIC.temp_05_va_codificacion5 a
LEFT JOIN _va_codificacion v ON a."SUBTIPO" = v."descripcion"
LEFT JOIN _va_codificacion w ON a."TAMANO" = REPLACE(REPLACE(w."descripcion",' ',''),'S','') 
LEFT JOIN _va_codificacion x ON a."TIPO" = x."descripcion" 
LEFT JOIN _va_codificacion y ON a."TIPO_CARNE" = y."descripcion" 
LEFT JOIN _va_codificacion z ON a."TIPO_SALCHICHA" = z."descripcion"