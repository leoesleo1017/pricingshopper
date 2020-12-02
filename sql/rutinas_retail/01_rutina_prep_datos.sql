DROP TABLE IF EXISTS PUBLIC.temp_01_jerarquiacategorias;
CREATE TABLE PUBLIC.temp_01_jerarquiacategorias AS 

WITH 
periodo AS (
	SELECT *,
			 a."REGION" || '-' || a."CANAL" AS MERCADO_
	FROM PUBLIC.temp_s_min_level a
	JOIN PUBLIC.conf_fechas b ON b."fecha" = TO_DATE(a."PERIODO", 'YYYY/MM/DD')
),

reduc_cod_pdto1 AS ( --GARANTIZAR QUE EL NUEVO PRODUCTO_nls no esté repetido,en caso de estar repetido suspende el proceso
	SELECT *,
			"COD_TAG",'P' || SUBSTRING("COD_TAG", 13, 1) || RIGHT("COD_TAG",8) AS PRODUCTO_nls
	FROM periodo
	-- WHERE "DUP_CATEGORIA" = 'HELADOS'
),
/*
reduc_cod_pdto2 AS (
	SELECT *,
			"COD_TAG" AS "COD_TAG",
			"COD_TAG" AS "PRODUCTO_nls"
	FROM periodo
	WHERE "DUP_CATEGORIA" <> 'HELADOS'
),

reduc_cod_pdto AS (
	SELECT *
	FROM reduc_cod_pdto1
	UNION 
	SELECT *
	FROM reduc_cod_pdto2
),
*/
valores_problema AS ( 
	SELECT *,
		ROUND("ventas_valor_nls"::numeric,2) AS "_ventas_valor_nls",
		ROUND("ventas_volumen_nls"::numeric,2)	AS "_ventas_volumen_nls"
	FROM reduc_cod_pdto1
	WHERE "ventas_volumen_nls" > 0
	AND "ventas_valor_nls" > 0
),

ma_jerarquia_categorias AS (
	SELECT a.negocio,b.category,c.subcategory
	FROM PUBLIC.ma_negocio a
	JOIN PUBLIC.ma_category b ON a.idnegocio = b.idnegocio
	JOIN PUBLIC.ma_subcategory c ON b.idcategory = c.idcategory
),

jerarquia_categorias AS ( -- VAR ADI NUEVAS 
	SELECT *
	FROM valores_problema a
	LEFT JOIN ma_jerarquia_categorias b ON a."DUP_CATEGORIA" = b."subcategory"
),

estructura AS (  -- sumar ventas valor y ventas volumen y agrupar por todos los campos
	SELECT "PERIODO" 																									AS "PERIODO_NLS",
			 "producto_nls" 																							AS "PRODUCTO_nls",
			 "MERCADO"   	 																							AS "MERCADO_nls",
			 "mercado_"																									AS "MERCADO",
			 "TAMANO" 																									AS "TAMANO_nls_",
			 CASE WHEN "TAMANO_nls" = 'S/A' THEN 'OTROS TAMANOS' ELSE "TAMANO_nls" END 			AS "TAMANO_nls",
			 "DUP_PRODUCTO" 																							AS "DESCRIPCION_nls", 
			 'COLOMBIA_' || 'col_nls_retail' || '_MENSUAL'													AS "FUENTE",
			 'KG'																											AS "UNIDAD", -- APLICA SOLO PARA COLOMBIA
			 "anio" 																										AS "AÑO",
			 "mes" 																										AS "MES",
			 "fecha" 																									AS "FECHA",
			 "negocio" 																									AS "NEGOCIO",
			 CASE WHEN "DUP_MARCA" = 'CORONA FLASH' THEN 'CHOCOLATE DE MESA' ELSE "subcategory" END	AS "SUBCATEGORY",
			 "category" 																								AS "CATEGORY",
			 "DUP_SUBTIPO" 																							AS "SUBTIPO",
			 "DUP_TIPO_SABOR" 																						AS "TIPODESABOR",
			 "DUP_TIPOCARNE" 																							AS "TIPO_CARNE",
			 "DUP_NIVEL_AZUCAR" 																						AS "NIVELDEAZUCAR",
			 "DUP_INTEGRAL_NO_INTEGRAL" 																			AS "INTEGRALNOINTEGRAL",
			 "DUP_CONSISTENCIA" 																						AS "CONSISTENCIA",
			 "DUP_TIPO" 																								AS "TIPO",
			 "DUP_SUBMARCA" 																							AS "SUBMARCA",
			 "DUP_SEGMENTO" 																							AS "SEGMENTO",
			 "DUP_SABOR" 																								AS "SABOR",
			 "DUP_PRESENTACION" 																						AS "PRESENTACION",
			 "DUP_NOMBRE_FABRICANTE" 																				AS "FABRICANTE",
			 "DUP_EMPAQUE" 																							AS "EMPAQUE",
			 "DUP_MARCA" 																								AS "MARCA",
			 "DUP_VARIEDAD" 																							AS "VARIEDAD",
			 '' 																											AS "FAMILIA",
			 '' 																											AS "SEGM_PRECIO",
			 ''  																											AS "SEGMENTO_TMLUC",
			 '' 		 																									AS "SUBCANAL",
			 "RANGO_MIN", 
			 "RANGO_MAX",
			 "REGION"   																								AS "REGION", -- * --
			 "CANAL"    																								AS "CANAL", -- * --
			 "DUP_OFERTA_PROMOCIONAL" 																				AS "OFERTA_PROMOCION",
			 '' 																											AS "ITEM",
			 '' 																											AS "SUBLINEA",
			 '' 																											AS "SUBSEGMENTO_NOEL", 
			 "NIVEL"																										AS "NIVEL",	
			 "RANGO_SINPROC"																							AS "RANGO_SINPROC",
			 "TAMANO_SINPROC"																							AS "TAMANO_SINPROC",
			 SUM("_ventas_valor_nls")                             										AS "VENTAS_VALOR_nls",
			 SUM("_ventas_volumen_nls") 								   										AS "VENTAS_VOLUMEN_nls",
			 MAX("DIST_MANEJANTES_POND") 																			AS "DIST_POND_nls",
			 MAX("DIST_MANEJANTES_NUM") 																			AS "DIST_NUM_nls"
	FROM jerarquia_categorias
	GROUP BY  "PERIODO",
				 "producto_nls",
				 "MERCADO", 
				 "mercado_", 
				 "TAMANO", 
				 "TAMANO_nls",
				 "DUP_PRODUCTO", 
				 "FUENTE",
				 "anio", 
				 "mes",
				 "fecha", 
				 "negocio", 
				 "subcategory", 
				 "category", 
				 "DUP_SUBTIPO", 
				 "DUP_TIPO_SABOR", 
				 "DUP_TIPOCARNE", 
				 "DUP_NIVEL_AZUCAR", 
				 "DUP_INTEGRAL_NO_INTEGRAL", 
				 "DUP_CONSISTENCIA", 
				 "DUP_TIPO", 
				 "DUP_SUBMARCA", 
				 "DUP_SEGMENTO", 
				 "DUP_SABOR", 
				 "DUP_PRESENTACION", 
				 "DUP_NOMBRE_FABRICANTE", 
				 "DUP_EMPAQUE", 
				 "DUP_MARCA", 
				 "DUP_VARIEDAD", 
				 "CANAL",
				 "RANGO_MIN", 
				 "RANGO_MAX", 
				 "REGION", 
				 "CANAL", 
				 "DUP_OFERTA_PROMOCIONAL", 
				 "NIVEL",
				 "RANGO_SINPROC",
				 "TAMANO_SINPROC"
)

SELECT *
FROM estructura