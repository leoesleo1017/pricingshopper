DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion3;
CREATE TABLE PUBLIC.temp_05_va_codificacion3 AS 

select   a.*,
		 g."codificacion" AS "COD_FAMILIA_DE_EMPAQUE",
		 h."codificacion" AS "COD_FORMA",
		 i."codificacion" AS "COD_INTEGRALNOINTEGRAL",
		 j."codificacion" AS "COD_LINEA",
		 k."codificacion" AS "COD_MARCA",
		 l."codificacion" AS "COD_NIVELDEAZUCAR",
		 ll."codificacion" AS "COD_PRESENTACION"			
from PUBLIC.temp_05_va_codificacion2 a
LEFT JOIN PUBLIC.temp_05_va_codificacion g ON a."FAMILIA_DE_EMPAQUE" = g."descripcion" AND g."tipo_codificacion" = 'FAMILIA_DE_EMPAQUE'  
LEFT JOIN PUBLIC.temp_05_va_codificacion h ON a."FORMA" = h."descripcion" AND h."tipo_codificacion" = 'FORMA'
LEFT JOIN PUBLIC.temp_05_va_codificacion i ON a."INTEGRALNOINTEGRAL" = i."descripcion" AND i."tipo_codificacion" = 'INTEGRALNOINTEGRAL'
LEFT JOIN PUBLIC.temp_05_va_codificacion j ON a."LINEA" = j."descripcion" AND j."tipo_codificacion" = 'LINEA'
LEFT JOIN PUBLIC.temp_05_va_codificacion k ON a."MARCA" = k."descripcion_" AND k."tipo_codificacion" = 'MARCA'
LEFT JOIN PUBLIC.temp_05_va_codificacion l ON a."NIVELDEAZUCAR" = l."descripcion" AND l."tipo_codificacion" = 'NIVELDEAZUCAR'
LEFT JOIN PUBLIC.temp_05_va_codificacion ll ON a."PRESENTACION" = ll."descripcion" AND ll."tipo_codificacion" = 'PRESENTACION'