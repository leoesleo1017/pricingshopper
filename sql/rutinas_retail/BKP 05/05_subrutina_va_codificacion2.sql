DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion2;
CREATE TABLE PUBLIC.temp_05_va_codificacion2 AS 				

SELECT   a.*,
		 b."codificacion" AS "COD_CATEGORY",
		 c."codificacion" AS "COD_CONSISTENCIA",
		 d."codificacion" AS "COD_EMPAQUE",	
		 e."codificacion" AS "COD_FABRICANTE",
		 f."codificacion" AS "COD_FAMILIA"		
FROM PUBLIC.temp_04_rangos a
LEFT JOIN PUBLIC.temp_05_va_codificacion b ON a."CATEGORY" = b."descripcion" AND b."tipo_codificacion" = 'CATEGORY'
LEFT JOIN PUBLIC.temp_05_va_codificacion c ON a."CONSISTENCIA" = c."descripcion" AND c."tipo_codificacion" = 'CONSISTENCIA'
LEFT JOIN PUBLIC.temp_05_va_codificacion d ON a."EMPAQUE" = d."descripcion" AND d."tipo_codificacion" = 'EMPAQUE'
LEFT JOIN PUBLIC.temp_05_va_codificacion e ON a."FABRICANTE" = REPLACE(e."descripcion",'.',' ') AND e."tipo_codificacion" = 'FABRICANTE'   
LEFT JOIN PUBLIC.temp_05_va_codificacion f ON a."FAMILIA" = f."descripcion" AND f."tipo_codificacion" = 'FAMILIA'