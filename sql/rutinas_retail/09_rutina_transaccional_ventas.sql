DROP TABLE IF EXISTS PUBLIC.temp_09_transaccional_ventas;
CREATE TABLE PUBLIC.temp_09_transaccional_ventas AS 

SELECT "COD_FUENTE",
		 "cod_mercado",
		 '' 	AS "COD_PTO_VTA",
		 "AÑO",
		 "COD_PERIODO",
		 "COD_PRODUCTO",
		 CASE
		 WHEN "COD_FUENTE" = '06' OR "COD_FUENTE" = '07' THEN 'CLP'
		 ELSE 'COP'
		 END AS "MONEDA",
		 "UNIDAD",
		 "VENTAS_VALOR_nls" AS "Vtas_Volumen",
		 "VENTAS_VOLUMEN_nls" AS "Vtas_Valor",
		 "DIST_NUM_nls" AS "DN",
		 "DIST_POND_nls" AS "DP"
FROM PUBLIC.temp_08_atributos_mercado