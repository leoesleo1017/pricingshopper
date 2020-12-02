DROP TABLE IF EXISTS PUBLIC.temp_02_va_pastas_forma;
CREATE TABLE PUBLIC.temp_02_va_pastas_forma AS

SELECT b."idcategory",
  	   c."idsubcategory",
	   a."TIPO",
	   -- a."forma",		 
	   CASE 
	   {REGLAS}		 
	   ELSE 'OTROS'
	   -- END AS "FORMA_nls_R"
	   END AS "forma"
FROM PUBLIC.temp_02_var_adi_negocios a
JOIN PUBLIC.ma_category b ON a."CATEGORY" = b."category"
JOIN PUBLIC.ma_subcategory c ON a."SUBCATEGORY" = c."subcategory"
WHERE a."SUBCATEGORY" = 'PASTAS'
AND a."forma" IS NULL