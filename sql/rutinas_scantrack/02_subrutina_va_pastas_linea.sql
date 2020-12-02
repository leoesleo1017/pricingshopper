DROP TABLE IF EXISTS PUBLIC.temp_02_va_pastas_linea;
CREATE TABLE PUBLIC.temp_02_va_pastas_linea AS

SELECT b."idcategory",
		 c."idsubcategory",
		 a."SEGMENTO",
		 a."FABRICANTE",
		 a."MARCA",
		 a."SUBMARCA",
		 a."SUBTIPO",
		 a."INTEGRALNOINTEGRAL" AS "INTEGRAL", 
		 a."SABOR",
		 a."TIPO",
		 -- a."linea",
		 CASE 
		 {REGLAS}
		 ELSE 'OTROS'
		 -- END AS "LINEA_nls_INICIAL_R"
		 END AS "linea"
FROM PUBLIC.temp_02_var_adi_negocios a
JOIN PUBLIC.ma_category b ON a."CATEGORY" = b."category"
JOIN PUBLIC.ma_subcategory c ON a."SUBCATEGORY" = c."subcategory"
WHERE a."SUBCATEGORY" = 'PASTAS'
AND a."linea" IS NULL