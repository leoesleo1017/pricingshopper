DROP TABLE IF EXISTS PUBLIC.temp_03_var_adi_rangos;
CREATE TABLE PUBLIC.temp_03_var_adi_rangos AS 

WITH 
var_adi_sn AS (
	SELECT a.*,
			 b.segmento_noel,
			 c.familia,
			 CASE WHEN d.subsegmento_noel IS NULL THEN d.segmento_nutresa ELSE d.subsegmento_noel END AS "SUBSEGMENTO_NOEL"
	FROM PUBLIC.temp_02_var_adi_negocios a	
	LEFT JOIN PUBLIC.va_prod_seg_noel_galletas b ON a."PRODUCTO_nls" = b.producto_nls
	LEFT JOIN PUBLIC.va_prod_familia_helados c ON a."PRODUCTO_nls" = c.cod_producto
	LEFT JOIN scantrack.va_capsulas d ON a."PRODUCTO_nls" = d.producto
),

var_adi_mundoshopper AS (
	SELECT a.*,
		   b.mundos_shopper AS "MUNDOS_SHOPPER",
		   a.familiaempaque AS "FAMILIA_DE_EMPAQUE",
		   a.forma AS "FORMA",
		   a.linea AS "LINEA",
		   a.segmento_noel AS "SEGMENTO_NOEL",
		   a."TAMANO_cruce5" AS "TAMANO",
		   a.tiposalchicha AS "TIPO_SALCHICHA",
		   a.tiponeg AS "TIPONEG",
		   a."PRODUCTO_nls" AS "PRODUCTO",
		   '02'             AS "COD_FUENTE"
	FROM var_adi_sn a
	LEFT JOIN PUBLIC.va_mundos_shopper b ON a."PRODUCTO_nls" = b.producto
)

SELECT a."PRODUCTO_nls",
		 a."MERCADO_nls",
		 a."MERCADO",
		 a."DESCRIPCION_nls",
		 a."FUENTE",
		 a."UNIDAD",
		 a."AÑO",
		 a."GRUPO",
		 a."FECHA",
		 a."NEGOCIO",
		 a."SUBCATEGORY",
		 a."CATEGORY",
		 a."SUBTIPO",
		 a."TIPODESABOR" AS "TIPO_SABOR",
		 a."TIPO_CARNE",
		 a."NIVELDEAZUCAR",
		 a."INTEGRALNOINTEGRAL",
		 a."CONSISTENCIA",
		 a."TIPO",
		 a."SUBMARCA",
		 a."SEGMENTO",
		 a."SABOR",
		 a."PRESENTACION",
		 a."FABRICANTE",
		 a."EMPAQUE",
		 a."MARCA",
		 a."VARIEDAD",
		 a."FAMILIA",
		 a."SEGM_PRECIO",
		 a."SEGMENTO_TMLUC",
		 a."SUBCANAL",
		 a."RANGO_MIN",
		 a."RANGO_MAX",
		 a."REGION",
		 a."CANAL",
		 a."OFERTA_PROMOCION" AS "OFERTAPROMOCION",
		 a."ITEM",
		 a."SUBLINEA",
		 a."RANGO_SINPROC",
		 a."TAMANO_SINPROC",
		 a."BARCODE",
		 a."VENTAS_VALOR_nls",
		 a."VENTAS_VOLUMEN_nls",
		 a."DIST_NUM_nls",
		 a."UXE_3",
		 a."cafe_tamano_nls",
		 a."familiaempaque",
		 a."tiposalchicha",
		 a."tipo_ajuste",
		 a."SUBSEGMENTO_NOEL",
		 a."MUNDOS_SHOPPER",
		 a."FAMILIA_DE_EMPAQUE",
		 a."FORMA",
		 a."LINEA",
		 a."SEGMENTO_NOEL",
		 a."TAMANO",
		 a."TIPO_SALCHICHA",
		 a."TIPONEG",
		 a."PRODUCTO",
		 a."peso",
		 a."DIST_POND_nls",
		 a."COD_FUENTE",
	     REPLACE(a."DESCRIPCION_nls",RIGHT(a."DESCRIPCION_nls",21),'') AS "DES_PRODUCTO"
FROM var_adi_mundoshopper a