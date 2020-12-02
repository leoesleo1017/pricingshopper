DROP TABLE IF EXISTS PUBLIC.temp_02_va_pastas_tiponeg;
CREATE TABLE PUBLIC.temp_02_va_pastas_tiponeg AS

SELECT b."idcategory",
		 c."idsubcategory",
		 a."FABRICANTE",
		 a."MARCA",
		 -- a."tiponeg",
		 CASE 
		 {REGLAS}
		 ELSE 'OTRAS MARCAS'
		 -- END AS "TIPONEG_nls_R"
		 END AS "tiponeg"
FROM PUBLIC.temp_02_var_adi_negocios a
JOIN PUBLIC.ma_category b ON a."CATEGORY" = b."category"
JOIN PUBLIC.ma_subcategory c ON a."SUBCATEGORY" = c."subcategory"
WHERE a."SUBCATEGORY" = 'PASTAS'
AND a."tiponeg" IS NULL