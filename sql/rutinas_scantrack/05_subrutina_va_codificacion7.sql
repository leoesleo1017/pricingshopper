DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion7;
CREATE TABLE PUBLIC.temp_05_va_codificacion7 AS 

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'TIPO_SABOR'
	AND "tipo_codificacion" = 'VARIEDAD'
	AND "tipo_codificacion" = 'TIPONEG'
	AND "tipo_codificacion" = 'NEGOCIO'
	AND "tipo_codificacion" = 'OFERTAPROMOCIONAL'
	AND "tipo_codificacion" = 'MUNDOS_SHOPPER'
)

SELECT a.*,
		 aa."codificacion" AS "COD_TIPO_SABOR",
		 ab."codificacion" AS "COD_VARIEDAD", 
		 ag."codificacion" AS "COD_TIPONEG",
		 ah."codificacion" AS "COD_NEGOCIO",
		 ai."codificacion" AS "COD_OFERTA_PROMOCION",
		 aj."codificacion" AS "ATTRGEN8",
		 aj."codificacion" AS "COD_MUNDOS_SHOPPER",
		 ak."COD_PRODUCTO"
FROM PUBLIC.temp_05_va_codificacion6 a
LEFT JOIN _va_codificacion aa ON a."TIPO_SABOR" = aa."descripcion" 
LEFT JOIN _va_codificacion ab ON a."VARIEDAD" = ab."descripcion" 
LEFT JOIN _va_codificacion ag ON a."TIPONEG" = ag."descripcion" 
LEFT JOIN _va_codificacion ah ON a."NEGOCIO" = ah."descripcion" 
LEFT JOIN _va_codificacion ai ON a."OFERTA_PROMOCION" = ai."descripcion" 
LEFT JOIN _va_codificacion aj ON a."MUNDOS_SHOPPER" = aj."descripcion" 
LEFT JOIN PUBLIC.sa_producto ak  ON a."PRODUCTO" = SUBSTRING(ak."COD_PRODUCTO",6)