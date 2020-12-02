DROP TABLE IF EXISTS PUBLIC.temp_02_va_carnicos_tipo_salchicha;
CREATE TABLE PUBLIC.temp_02_va_carnicos_tipo_salchicha AS 

SELECT b."idcategory",
		 c."idsubcategory",
		 a."SEGMENTO",
		 a."FABRICANTE",
		 a."MARCA",
		 a."VARIEDAD",
		 a."TAMANO_nls",
		 a."peso",
		 -- a."tiposalchicha",
		 CASE 
		 {REGLAS}
		 ELSE 'OTROS'
		 -- END AS "TIPO_SALCHICHA_nls_R"
		 END AS "tiposalchicha"
FROM PUBLIC.temp_02_var_adi_negocios a
JOIN PUBLIC.ma_category b ON a."CATEGORY" = b."category"
JOIN PUBLIC.ma_subcategory c ON a."SUBCATEGORY" = c."subcategory"
WHERE a."SUBCATEGORY" = 'CARNES FRIAS'
AND a."SEGMENTO" = 'SALCHICHAS'
AND a."tiposalchicha" IS NULL