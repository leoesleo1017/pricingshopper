DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion5;
CREATE TABLE PUBLIC.temp_05_va_codificacion5 AS 

select   a.*,		 
		 t."codificacion" AS "COD_SUBMARCA",
		 u."codificacion" AS "COD_SUBSEGMENTO_NOEL",
		 v."codificacion" AS "COD_SUBTIPO",
		 w."codificacion" AS "COD_TAMANO_nls",
		 x."codificacion" AS "COD_TIPO",
		 y."codificacion" AS "COD_TIPO_CARNE",
		 z."codificacion" AS "COD_TIPO_SALCHICHA"		
from PUBLIC.temp_05_va_codificacion4 a
LEFT JOIN PUBLIC.temp_05_va_codificacion t ON a."SUBMARCA" = t."descripcion" AND t."tipo_codificacion" = 'SUBMARCA'
LEFT JOIN PUBLIC.temp_05_va_codificacion u ON a."SUBSEGMENTO_NOEL" = u."descripcion" AND u."tipo_codificacion" = 'SUBSEGMENTO_NOEL'
LEFT JOIN PUBLIC.temp_05_va_codificacion v ON a."SUBTIPO" = v."descripcion" AND v."tipo_codificacion" = 'SUBTIPO'
LEFT JOIN PUBLIC.temp_05_va_codificacion w ON a."TAMANO" = REPLACE(REPLACE(w."descripcion",' ',''),'S','') AND w."tipo_codificacion" = 'TAMANO_nls' -- con el replace se garantiza la unidad de medida GR para el cruce de datos
LEFT JOIN PUBLIC.temp_05_va_codificacion x ON a."TIPO" = x."descripcion" AND x."tipo_codificacion" = 'TIPO'
LEFT JOIN PUBLIC.temp_05_va_codificacion y ON a."TIPO_CARNE" = y."descripcion" AND y."tipo_codificacion" = 'TIPO_CARNE'
LEFT JOIN PUBLIC.temp_05_va_codificacion z ON a."TIPO_SALCHICHA" = z."descripcion" AND z."tipo_codificacion" = 'TIPO_SALCHICHA'
