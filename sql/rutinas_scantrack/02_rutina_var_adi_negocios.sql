DROP TABLE IF EXISTS PUBLIC.temp_02_var_adi_negocios;
CREATE TABLE PUBLIC.temp_02_var_adi_negocios AS 

WITH 
peso_tamano AS ( --VAR ADI_PESO_UXE
	SELECT a.*,
			 b.peso,
			 b.peso_des,
			 b.factor,
			 CASE 
			 	WHEN a."SUBCATEGORY" = 'CAFE MOLIDO' AND a."SEGMENTO" = 'REGULAR' AND b."peso"::NUMERIC > 0 THEN b."peso"::NUMERIC/5
			 	WHEN a."SUBCATEGORY" = 'CAFE SOLUBLE' AND a."SEGMENTO" = 'CAFE' AND b."peso"::NUMERIC > 0 THEN ROUND(b."peso"::NUMERIC/1.5,2)
				ELSE b."factor"::NUMERIC
			 END AS FACTOR_AJUSTES,			
			 CASE
				WHEN BTRIM(a."TAMANO_nls") <> 'OTROS TAMANOS' THEN BTRIM(REPLACE(a."TAMANO_nls",'-','A'))
				ELSE BTRIM(b."peso_des")				
			 END AS "TAMANO_cruce"				
	FROM PUBLIC.temp_01_jerarquiacategorias a
	LEFT JOIN scantrack.ma_peso b ON a."PRODUCTO_nls" = b."producto_nls" --validar porque se debe hacer este cruce para scantrack, y del porque no cruza nada de información
	-- WHERE a."TAMANO_nls" = 'S/A'
),

peso_tamano2 AS (
	SELECT *,
			CASE 
			WHEN BTRIM("TAMANO_cruce") LIKE '%GR%' THEN BTRIM("TAMANO_cruce") ELSE BTRIM("peso_des")
			END AS "TAMANO_cruce2"
	FROM peso_tamano
),

peso_tamano3 AS ( -- validar uxe y mejorar tamano
	SELECT *,
			CASE 
				WHEN ("TAMANO_cruce2" IS NULL or "TAMANO_cruce2" LIKE '%OTROS%') THEN REPLACE(substr(substr("DESCRIPCION_nls",(POSITION('GR ' IN "DESCRIPCION_nls")-5)),POSITION(' ' IN substr("DESCRIPCION_nls",(POSITION('GR ' IN "DESCRIPCION_nls")-5))),10),' 000','')
				ELSE "TAMANO_cruce2"
			END AS "TAMANO_cruce3",
			CASE 
				WHEN "DESCRIPCION_nls" LIKE '% X%' THEN SUBSTR("DESCRIPCION_nls",POSITION(' X' IN "DESCRIPCION_nls"),4) 
				WHEN "DESCRIPCION_nls" LIKE '%(X%' THEN SUBSTR("DESCRIPCION_nls",POSITION('(X' IN "DESCRIPCION_nls"),4)	
			   -- REPLACE(substr(substr("DESCRIPCION_nls",(POSITION(' X' IN "DESCRIPCION_nls")-5)),POSITION(' ' IN substr("DESCRIPCION_nls",(POSITION(' X' IN "DESCRIPCION_nls")-5))),10),' 000','') AS "UXE"
			END AS "UXE"
	FROM peso_tamano2
),

peso_tamano4 AS (
	SELECT *,
			 CASE
			 WHEN "TAMANO_cruce3" LIKE '%GR%' THEN BTRIM(substr("TAMANO_cruce3",0,(POSITION('GR ' IN "TAMANO_cruce3")+2)))
			 ELSE '0' 
			 END AS "TAMANO_cruce4",
			 BTRIM(REPLACE(REPLACE("UXE",'(',''),')','')) AS "UXE_2"		 
	FROM peso_tamano3
),

peso_tamano5 AS (
	SELECT *,
			 CASE
			 WHEN "TAMANO_cruce4" <> '0'THEN BTRIM(substr("TAMANO_cruce4",POSITION(' ' IN "TAMANO_cruce4"),10))
			 ELSE '0'		  
			 END AS "TAMANO_cruce5",
			 CASE
			 WHEN "UXE_2" IS NULL THEN '1' ELSE "UXE_2" 
			 END AS "UXE_3"		 
	FROM peso_tamano4
),

-- var_adi_negocios_(v1) --
cafe_familia_empaque AS (
	SELECT d.negocio,
			 b.category,
			 c.subcategory,
			 a.segmento,
			 a.fabricante,
			 a.marca,
			 a.variedad,
			 a.empaque,
			 a.tamano_nls AS cafe_tamano_nls,
			 a.familiaempaque
	FROM PUBLIC.va_cafe_familia_empaque a
	JOIN PUBLIC.ma_category b ON a.idcategory = b.idcategory
	JOIN PUBLIC.ma_subcategory c ON a.idsubcategoria = c.idsubcategory
	JOIN PUBLIC.ma_negocio d ON b.idnegocio = d.idnegocio
),

carnicos_tipo_salchicha AS (
	SELECT d.negocio,
			 b.category,
			 c.subcategory,
			 a.segmento,
		     a.fabricante,
			 a.marca,
			 a.variedad,
			 a.tamano_nls AS carnicos_tamano_nls,
			 -- a.peso::NUMERIC AS peso,
			 a.peso,
			 a.tiposalchicha
	FROM PUBLIC.va_carnicos_tipo_salchicha a
	JOIN PUBLIC.ma_category b ON a.idcategory = b.idcategory
	JOIN PUBLIC.ma_subcategory c ON a.idsubcategoria = c.idsubcategory
	JOIN PUBLIC.ma_negocio d ON b.idnegocio = d.idnegocio
),

pastas_linea AS (
	SELECT d.negocio,
			 b.category,
			 c.subcategory,
			 a.segmento,
			 a.fabricante,
			 a.marca,
			 a.submarca,
			 a.subtipo,
			 a.integral,
			 a.sabor,
			 a.tipo,
			 a.linea
	FROM PUBLIC.va_pastas_linea a
	JOIN PUBLIC.ma_category b ON a.idcategory = b.idcategory
	JOIN PUBLIC.ma_subcategory c ON a.idsubcategoria = c.idsubcategory
	JOIN PUBLIC.ma_negocio d ON b.idnegocio = d.idnegocio
),

pastas_forma AS (
	SELECT *
	FROM PUBLIC.va_pastas_forma a
	JOIN PUBLIC.ma_category b ON a.idcategory = b.idcategory
	JOIN PUBLIC.ma_subcategory c ON a.idsubcategory = c.idsubcategory
	JOIN PUBLIC.ma_negocio d ON b.idnegocio = d.idnegocio
),

pastas_tiponeg AS (
	SELECT *
	FROM PUBLIC.va_pastas_tiponeg a
	JOIN PUBLIC.ma_category b ON a.idcategory = b.idcategory
	JOIN PUBLIC.ma_subcategory c ON a.idsubcategoria = c.idsubcategory
	JOIN PUBLIC.ma_negocio d ON b.idnegocio = d.idnegocio
),

tipo_ajuste AS (
	SELECT *
	FROM PUBLIC.va_tipo_salchicha_ajuste a
	JOIN PUBLIC.ma_category b ON a.idcategory = b.idcategory
	JOIN PUBLIC.ma_subcategory c ON a.idsubcategoria = c.idsubcategory
	JOIN PUBLIC.ma_negocio d ON b.idnegocio = d.idnegocio
),

var_adi_negocios AS (
	SELECT DISTINCT a.*,
						 b."cafe_tamano_nls",
						 b."familiaempaque",					 
						 c."tiposalchicha",
						 -- c."carnicos_tamano_nls",
						 d."linea",
						 e."forma",
						 f."tiponeg",
						 g_."tipo_ajuste" -- se le da prioridad a este ajuste, en caso de quedar en OTROS pasa por la regla de la variable adicional--
	FROM peso_tamano5 a
	LEFT JOIN cafe_familia_empaque b ON BTRIM(a."FABRICANTE") = BTRIM(b."fabricante")
										 		AND BTRIM(a."MARCA") = BTRIM(b."marca")
										 		AND BTRIM(a."SEGMENTO") = BTRIM(b."segmento")		
											 	AND BTRIM(a."VARIEDAD") = BTRIM(b."variedad")	
											 	AND BTRIM(a."SUBCATEGORY") = BTRIM(b."subcategory")
											 	AND BTRIM(a."CATEGORY") = BTRIM(b."category")
											 	AND BTRIM(a."EMPAQUE") = BTRIM(b."empaque")
										 		AND a."TAMANO_cruce" = BTRIM(b."cafe_tamano_nls") 
	LEFT JOIN carnicos_tipo_salchicha c ON BTRIM(a."FABRICANTE") = BTRIM(c."fabricante")
										 		AND BTRIM(a."MARCA") = BTRIM(c."marca")
										 		AND BTRIM(a."SEGMENTO") = BTRIM(c."segmento")		
										 		AND BTRIM(a."VARIEDAD") = BTRIM(c."variedad")	
												AND BTRIM(a."SUBCATEGORY") = BTRIM(c."subcategory")
												AND BTRIM(a."CATEGORY") = BTRIM(c."category")
												-- AND a."peso_des" = c."peso" || ' ' || 'GRS' 
										 		AND BTRIM(a."peso") = BTRIM(c."peso")										 		
	LEFT JOIN pastas_linea d ON BTRIM(a."FABRICANTE") = BTRIM(d."fabricante")
											  AND BTRIM(a."SUBCATEGORY") = BTRIM(d."subcategory")
											  AND BTRIM(a."CATEGORY") = BTRIM(d."category")
											  AND BTRIM(a."SEGMENTO") = BTRIM(d."segmento")	
											  AND BTRIM(a."SABOR") = BTRIM(d."sabor")
											  AND BTRIM(a."MARCA") = BTRIM(d."marca")
											  AND BTRIM(a."INTEGRALNOINTEGRAL") = BTRIM(d."integral")
											  AND BTRIM(a."SUBMARCA") = BTRIM(d."submarca")
											  AND BTRIM(a."SUBTIPO") = BTRIM(d."subtipo")
											  AND BTRIM(a."TIPO") = BTRIM(d."tipo")
	LEFT JOIN pastas_forma e ON BTRIM(a."CATEGORY") = BTRIM(e."category")
								   AND BTRIM(a."SUBCATEGORY") = BTRIM(e."subcategory")
									AND BTRIM(a."TIPO") = BTRIM(e."tipo")	
	LEFT JOIN pastas_tiponeg f ON BTRIM(a."CATEGORY") = BTRIM(f."category")
										AND BTRIM(a."SUBCATEGORY") = BTRIM(f."subcategory")
										AND BTRIM(a."FABRICANTE") = BTRIM(f."fabricante")
										AND BTRIM(a."MARCA") = BTRIM(f."marca")		
	LEFT JOIN tipo_ajuste g_ ON BTRIM(a."PRODUCTO_nls") = BTRIM(g_."producto_nls")	-- se hace para remplazar el tipo de ajuste como la variable adicional
																									  							 						 
)

SELECT *
FROM var_adi_negocios			

			
