DROP TABLE IF EXISTS PUBLIC.temp_01_jerarquiacategorias;
CREATE TABLE PUBLIC.temp_01_jerarquiacategorias AS 

WITH 
reduc_cod_pdto1 AS ( 
	SELECT *,			
			"COD_TAG",'P' || SUBSTRING("COD_TAG", 13, 1) || RIGHT("COD_TAG",8) AS PRODUCTO_nls
	FROM PUBLIC.temp_s_min_level
	-- WHERE "DUP_CATEGORIA" = 'HELADOS'
),
/*
reduc_cod_pdto2 AS (
	SELECT *,
			"COD_TAG" AS "COD_TAG",
			"COD_TAG" AS "PRODUCTO_nls"
	FROM PUBLIC.temp_s_min_level
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
valores_problema AS ( -- pendiente sacar el porcentaje de ceros
	SELECT *,
	   "REGION_NLS" || '-' || "CANAL_NLS" AS MERCADO_,  -- los mercados son ciudades principales y no regiones como en retail
		ROUND("VENTAS_VALOR_nls"::numeric,2) AS "_ventas_valor_nls",
		ROUND("VENTAS_VOLUMEN_nls"::numeric,2)	AS "_ventas_volumen_nls"
	FROM reduc_cod_pdto1
	WHERE "VENTAS_VOLUMEN_nls" > 0
	AND "VENTAS_VALOR_nls" > 0
),

v_nuevos_productos AS (
	SELECT "producto_nls",
		   "DUP_PRODUCTO",
		   "DUP_CATEGORIA",
		   "TAMANO",
		   SUM("VENTAS_VALOR_nls") AS ventas_valor_nls,
		   SUM("VENTAS_VOLUMEN_nls") AS ventas_volumen_nls
	FROM valores_problema
	GROUP BY "producto_nls","DUP_PRODUCTO","DUP_CATEGORIA","TAMANO"
),

v_nuevos_productos2 AS (
	SELECT "DUP_CATEGORIA",
		   COUNT(1) AS "totalProductos"
	FROM valores_problema
	GROUP BY "DUP_CATEGORIA"
),

v_nuevos_productos3 AS (
	SELECT a."DUP_CATEGORIA",
			 COUNT(1) AS "totalProductos"
	FROM v_nuevos_productos a
	JOIN scantrack.ma_peso b ON a."producto_nls" = b."producto_nls"
	GROUP BY a."DUP_CATEGORIA"
),

v_nuevos_productos4 AS ( -- esta vista debe ir en una tabla para ir consolidando cada vez que corra el proceso en retail y scantrack, garantizar registros unicos en la tabla por categoria, para los casos que se necesite correr un mes de nuevo por algún error
	SELECT *
	FROM v_nuevos_productos2 a
	JOIN v_nuevos_productos3 b ON a."DUP_CATEGORIA" = b."DUP_CATEGORIA"
),

ma_jerarquia_categorias AS (
	SELECT a.negocio,b.category,c.subcategory
	FROM PUBLIC.ma_negocio a
	JOIN PUBLIC.ma_category b ON a.idnegocio = b.idnegocio
	JOIN PUBLIC.ma_subcategory c ON b.idcategory = c.idcategory
	JOIN PUBLIC.ma_fuente_categoria d ON b.idcategory = d.idcategory
	JOIN PUBLIC.ma_fuente e ON d.idfuente = e.id
	WHERE e.fuente = 'col_nls_scantrack'
),

jerarquia_categorias AS ( -- VAR ADI NUEVAS --
	SELECT *
	FROM valores_problema a
	LEFT JOIN ma_jerarquia_categorias b ON a."DUP_CATEGORIA" = b."subcategory"
),

estructura AS (  -- sumar ventas valor y ventas volumen y agrupar por todos los campos
	SELECT 
			 -- "PERIODO" 																								AS "PERIODO_NLS",
			 "producto_nls" 																							AS "PRODUCTO_nls",
			 "MERCADO_DL" 	 																							AS "MERCADO_nls",
			 "mercado_" 	 																							AS "MERCADO",
			 "TAMANO" 																									AS "TAMANO_nls_",
			 "TAMANO_SINPROC"																				 			AS "TAMANO_nls",
			 "DUP_PRODUCTO" 																							AS "DESCRIPCION_nls", 
			 'COLOMBIA_' || 'col_nls_scantrack' || '_MENSUAL'												AS "FUENTE",
			 'KG'																											AS "UNIDAD", -- APLICA SOLO PARA COLOMBIA
			 "ANIO" 																										AS "AÑO",
			 "GRUPO" 																									AS "GRUPO",
			 "ANO" || '-' || "MES" || '-' || '01'  															AS "FECHA",
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
			 "RANGO_MIN", -- * VALIDAR CON CARLOS -- 
			 "RANGO_MAX", -- * --
			 "REGION_NLS" 																								AS "REGION", -- * --
			 "CANAL_NLS"  																								AS "CANAL", -- * --
			 CASE WHEN "DUP_PRODUCTO" LIKE '%]%' OR "DUP_PRODUCTO" LIKE '%+%' THEN 'OFERTA' 
			 ELSE 'REGULAR' END 																						AS "OFERTA_PROMOCION",
			 '' 																											AS "ITEM",
			 '' 																											AS "SUBLINEA",
			 -- "NIVEL"																										AS "NIVEL",	
			 "RANGO_SINPROC"																							AS "RANGO_SINPROC",
			 "TAMANO_SINPROC"																							AS "TAMANO_SINPROC",	
			 RIGHT("DUP_PRODUCTO",20)   																		   AS "BARCODE",
			 SUM("_ventas_valor_nls")                             												AS "VENTAS_VALOR_nls",
			 SUM("_ventas_volumen_nls") 								   										AS "VENTAS_VOLUMEN_nls",
			 MAX("DIST_TIENDAS_VENDEDORAS_POND") 																AS "DIST_POND_nls",
			 MAX("DIST_TIENDAS_VENDEDORAS_NUM") 																AS "DIST_NUM_nls"
	FROM jerarquia_categorias
	GROUP BY  -- "PERIODO",
				 "producto_nls",
				 "MERCADO_DL", 
				 "mercado_", 
				 "TAMANO", 
				 "TAMANO_nls",
				 "DUP_PRODUCTO", 
				 "FUENTE",
				 "ANIO", 
				 "GRUPO",
				 "MES",
				 "ANO", 
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
				 -- "NIVEL",
				 "RANGO_SINPROC",
				 "TAMANO_SINPROC",
				 "DUP_PRODUCTO"
)

SELECT *
FROM estructura