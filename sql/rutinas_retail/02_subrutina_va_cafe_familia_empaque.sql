DROP TABLE IF EXISTS PUBLIC.temp_02_va_cafe_familia_empaque;
CREATE TABLE PUBLIC.temp_02_va_cafe_familia_empaque AS 

SELECT b."idcategory",
   	   c."idsubcategory",
	   a."SEGMENTO",
	   a."FABRICANTE",
	   a."MARCA",
	   a."VARIEDAD",
	   a."EMPAQUE",
	   -- a."cafe_tamano_nls",
	   -- a."familiaempaque",
	   a."TAMANO_nls",	   
	   CASE 
		 {REGLAS}
	   ELSE 'OTROS'
	   -- END AS "FAMILIA_DE_EMPAQUE_nls_R"
	   END AS "familiaempaque"
FROM PUBLIC.temp_02_var_adi_negocios a
JOIN PUBLIC.ma_category b ON a."CATEGORY" = b."category"
JOIN PUBLIC.ma_subcategory c ON a."SUBCATEGORY" = c."subcategory"
WHERE a."CATEGORY" = 'CAFE'
AND "familiaempaque" IS NULL 

