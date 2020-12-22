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
				
SELECT  a.*, 	
		aa."codificacion" AS "COD_TIPO_SABOR",
		ab."codificacion" AS "COD_VARIEDAD",
		ac."codificacion" AS "COD_RANGO_PRECIO",
		ac."codificacion" AS "ATTRGEN4",
		ad."codificacion" AS "ATTRGEN5",
		ad."codificacion" AS "COD_RANGO_TAMANO",
		ae."codificacion" AS "ATTRGEN6",
		ae."codificacion" AS "COD_RANGO_PRECIO_INDIVIDUAL",
		af."codificacion" AS "ATTRGEN7",
		af."codificacion" AS "COD_RANGO_TAMANO_INDIVIDUAL",
		ag."codificacion" AS "COD_TIPONEG",
		ah."codificacion" AS "COD_NEGOCIO",
		ai."codificacion" AS "COD_OFERTA_PROMOCION",
		aj."codificacion" AS "ATTRGEN8",
		aj."codificacion" AS "COD_MUNDOS_SHOPPER",
		ak."COD_PRODUCTO"
FROM PUBLIC.temp_05_va_codificacion6 a
LEFT JOIN _va_codificacion aa ON a."TIPO_SABOR" = aa."descripcion" AND aa."tipo_codificacion" = 'TIPO_SABOR'
LEFT JOIN _va_codificacion ab ON a."VARIEDAD" = ab."descripcion" AND ab."tipo_codificacion" = 'VARIEDAD'
LEFT JOIN _va_codificacion ac ON a."RANGO_PRECIO" = ac."descripcion" AND ac."tipo_codificacion" = 'RANGO_PRECIO'
LEFT JOIN _va_codificacion ad ON a."RANGO_TAMANO" = ad."descripcion" AND ad."tipo_codificacion" = 'RANGO_TAMANO'
LEFT JOIN _va_codificacion ae ON a."RANGO_PRECIO_INDIVIDUAL" = ae."descripcion" AND ae."tipo_codificacion" = 'RANGO_PRECIO_INDIVIDUAL'
LEFT JOIN _va_codificacion af ON a."RANGO_TAMANO_INDIVIDUAL" = af."descripcion" AND af."tipo_codificacion" = 'RANGO_TAMANO_INDIVIDUAL'
LEFT JOIN _va_codificacion ag ON a."TIPONEG" = ag."descripcion" AND ag."tipo_codificacion" = 'TIPONEG'
LEFT JOIN _va_codificacion ah ON a."NEGOCIO" = ah."descripcion" AND ah."tipo_codificacion" = 'NEGOCIO'
LEFT JOIN _va_codificacion ai ON a."OFERTAPROMOCION" = ai."descripcion" AND ai."tipo_codificacion" = 'OFERTAPROMOCIONAL'
LEFT JOIN _va_codificacion aj ON a."MUNDOS_SHOPPER" = aj."descripcion" AND aj."tipo_codificacion" = 'MUNDOS_SHOPPER'
LEFT JOIN PUBLIC.sa_producto ak  ON a."PRODUCTO" = SUBSTRING(ak."COD_PRODUCTO",6)

