DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion4;
CREATE TABLE PUBLIC.temp_05_va_codificacion4 AS 

select   a.*,
		 m."codificacion" AS "COD_SABOR",
		 n."codificacion" AS "COD_SEGM_PRECIO",
		 o."codificacion" AS "COD_SEGMENTO",
		 p."codificacion" AS "COD_SEGMENTO_NOEL",
		 q."codificacion" AS "COD_SEGMENTO_TMLUC",
		 r."codificacion" AS "COD_SUBCATEGORY",
		 s."codificacion" AS "COD_SUBLINEA"			
from PUBLIC.temp_05_va_codificacion3 a
LEFT JOIN PUBLIC.temp_05_va_codificacion m ON a."SABOR" = m."descripcion" AND m."tipo_codificacion" = 'SABOR'
LEFT JOIN PUBLIC.temp_05_va_codificacion n ON a."SEGM_PRECIO" = n."descripcion" AND n."tipo_codificacion" = 'SEGM_PRECIO' 
LEFT JOIN PUBLIC.temp_05_va_codificacion o ON a."SEGMENTO" = o."descripcion" AND o."tipo_codificacion" = 'SEGMENTO' 
LEFT JOIN PUBLIC.temp_05_va_codificacion p ON a."SEGMENTO_NOEL" = p."descripcion" AND p."tipo_codificacion" = 'SEGMENTO_NOEL' 
LEFT JOIN PUBLIC.temp_05_va_codificacion q ON a."SEGMENTO_TMLUC" = q."descripcion" AND q."tipo_codificacion" = 'SEGMENTO_TMLUC' 
LEFT JOIN PUBLIC.temp_05_va_codificacion r ON a."SUBCATEGORY" = r."descripcion" AND r."tipo_codificacion" = 'SUBCATEGORY'
LEFT JOIN PUBLIC.temp_05_va_codificacion s ON a."SUBLINEA" = s."descripcion" AND s."tipo_codificacion" = 'SUBCLINEA'