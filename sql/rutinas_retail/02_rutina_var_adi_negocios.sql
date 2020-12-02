DROP TABLE IF EXISTS PUBLIC.temp_02_var_adi_negocios;
CREATE TABLE PUBLIC.temp_02_var_adi_negocios AS 

WITH 
ma_factor as (
	SELECT b.subcategory,a.factor,a.segmento
	FROM PUBLIC.ma_factor a
	JOIN PUBLIC.ma_subcategory b ON a.id_subcategoria = b.idsubcategory
),

peso_tamano AS ( --VAR ADI_PESO_UXE--
	SELECT a.*,
			 b.peso,			 
			 b.peso_des,
			 b.factor,
			 CASE 
			 	WHEN a."SUBCATEGORY" = c."subcategory" AND a."SEGMENTO" = c."segmento" AND b."peso"::NUMERIC > 0 THEN ROUND(b."peso"::NUMERIC/c."factor"::NUMERIC,2)
				ELSE b."factor"::NUMERIC
			 END AS FACTOR_AJUSTES,			
			 CASE
				WHEN BTRIM(a."TAMANO_nls") <> 'OTROS TAMANOS' THEN BTRIM(REPLACE(a."TAMANO_nls",'-','A')) ELSE BTRIM(b."peso_des")
			 END AS "TAMANO_cruce"	
			 			
	FROM PUBLIC.temp_01_jerarquiacategorias a
	JOIN PUBLIC.ma_peso b ON a."PRODUCTO_nls" = b."producto_nls"
	JOIN ma_factor c ON a."SUBCATEGORY" = c."subcategory"
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

tipo_salchicha_ajuste AS (
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
	FROM peso_tamano a
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
	LEFT JOIN tipo_salchicha_ajuste g_ ON BTRIM(a."PRODUCTO_nls") = BTRIM(g_."producto_nls")	
																									  							 						 
)

SELECT *
FROM var_adi_negocios