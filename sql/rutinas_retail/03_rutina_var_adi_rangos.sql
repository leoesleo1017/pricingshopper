DROP TABLE IF EXISTS PUBLIC.temp_03_var_adi_rangos;
CREATE TABLE PUBLIC.temp_03_var_adi_rangos AS 

WITH 
var_adi_sn AS (
	SELECT a.*,
			 b.segmento_noel,
			 c.familia
	FROM PUBLIC.temp_02_var_adi_negocios a
	LEFT JOIN PUBLIC.va_prod_seg_noel_galletas b ON a."PRODUCTO_nls" = b.producto_nls
	LEFT JOIN PUBLIC.va_prod_familia_helados c ON a."PRODUCTO_nls" = c.cod_producto
),

var_adi_mundoshopper AS (
	SELECT a.*,
		    b.mundos_shopper,
		    CASE WHEN a."tiposalchicha" IS NULL THEN '' ELSE a."tiposalchicha" END AS "tiposalchicha_",
		    CASE WHEN a."MARCA" IS NULL THEN '' ELSE a."MARCA" END AS "MARCA_",
		    CASE WHEN a."VARIEDAD" IS NULL THEN '' ELSE a."VARIEDAD" END AS "VARIEDAD_",		    
		    CASE WHEN a."familiaempaque" IS NULL THEN '' ELSE a."familiaempaque" END AS "familiaempaque_",
		    CASE WHEN a."SEGMENTO" IS NULL THEN '' ELSE a."SEGMENTO" END AS "SEGMENTO_",
		    CASE WHEN a."peso_des" IS NULL THEN '' ELSE a."peso_des" END AS "peso_des_",		   
		    CASE WHEN a."EMPAQUE" IS NULL THEN '' ELSE a."EMPAQUE" END AS "EMPAQUE_",		   
		    CASE WHEN a."CONSISTENCIA" IS NULL THEN '' ELSE a."CONSISTENCIA" END AS "CONSISTENCIA_",
		    CASE WHEN a."FABRICANTE" IS NULL THEN '' ELSE a."FABRICANTE" END AS "FABRICANTE_",		   
		    CASE WHEN a."TIPO_CARNE" IS NULL THEN '' ELSE a."TIPO_CARNE" END AS "TIPO_CARNE_",
		    CASE WHEN a."SABOR" IS NULL THEN '' ELSE a."SABOR" END AS "SABOR_",		   
		    CASE WHEN a."SUBTIPO" IS NULL THEN '' ELSE a."SUBTIPO" END AS "SUBTIPO_",		   
		    CASE WHEN a."INTEGRALNOINTEGRAL" IS NULL THEN '' ELSE a."INTEGRALNOINTEGRAL" END AS "INTEGRALNOINTEGRAL_",		   
		    CASE WHEN a."TIPODESABOR" IS NULL THEN '' ELSE a."TIPODESABOR" END AS "TIPODESABOR_",
		    CASE WHEN a."TIPO" IS NULL THEN '' ELSE a."TIPO" END AS "TIPO_",		   
		    CASE WHEN a."segmento_noel" IS NULL THEN '' ELSE a."segmento_noel" END AS "segmento_noel_",
		    CASE WHEN a."PRESENTACION" IS NULL THEN '' ELSE a."PRESENTACION" END AS "PRESENTACION_",		   
		    CASE WHEN a."RANGO_MIN" IS NULL THEN 0 ELSE a."RANGO_MIN" END AS "RANGO_MIN_",
		    CASE WHEN a."NIVELDEAZUCAR" IS NULL THEN '' ELSE a."NIVELDEAZUCAR" END AS "NIVELDEAZUCAR_",
		    CASE WHEN a."SUBMARCA" IS NULL THEN '' ELSE a."SUBMARCA" END AS "SUBMARCA_"
	FROM var_adi_sn a
	LEFT JOIN PUBLIC.va_mundos_shopper b ON a."PRODUCTO_nls" = b.producto
),

var_h_producto AS ( 
	SELECT a.*,
			 b."producto"
	FROM var_adi_mundoshopper a
	JOIN PUBLIC.ma_h_productos b ON a."PRODUCTO_nls" = b.producto_nls
),

var_descrip_prod AS ( -- la idea es que este quede en el front
	SELECT   *,
				CASE 
				 	WHEN "SUBCATEGORY" = 'CAFE MOLIDO' THEN "MARCA_"|| ',' || "VARIEDAD_"|| ',' || "familiaempaque_"|| ',' || "SEGMENTO_" || ',' || "peso_des_"
				 	WHEN "SUBCATEGORY" = 'CAFE SOLUBLE' THEN "MARCA_"|| ',' || "VARIEDAD_"|| ',' || "EMPAQUE_"|| ',' || "CONSISTENCIA_" || ',' || "peso_des_"
					WHEN "SUBCATEGORY" = 'CARNES FRIAS' THEN "FABRICANTE_"|| ',' || "SEGMENTO_"|| ',' || "MARCA_"|| ',' || "tiposalchicha_" || ',' || "TIPO_CARNE_"|| ',' || "VARIEDAD_" || ',' || "SABOR_" || ',' || "RANGO_MIN_" || ',' || "peso_des_"
					WHEN "SUBCATEGORY" = 'PASTAS' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SUBMARCA_"|| ',' || "TIPO_" || ',' || "SUBTIPO_"|| ',' || "SABOR_" || ',' || "INTEGRALNOINTEGRAL_" || "peso_des_"
					WHEN "SUBCATEGORY" = 'CHOCOLATE DE MESA' THEN "MARCA_"|| ',' || "SUBMARCA_"|| ',' || "SABOR_"|| ',' || "TIPODESABOR_" || ',' || "TIPO_"|| ',' || "VARIEDAD_" || ',' || "PRESENTACION_" || ',' || "peso_des_"		
					WHEN "SUBCATEGORY" = 'MODIFICADORES DE LECHE' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SUBMARCA_"|| ',' || "SABOR_" || ',' || "VARIEDAD_"|| ',' || "PRESENTACION_" || ',' || "NIVELDEAZUCAR_" || ',' || "SEGMENTO_" || ',' || "peso_des_"
					WHEN "SUBCATEGORY" = 'CHOCOLATINAS' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SEGMENTO_"|| ',' || "VARIEDAD_" || ',' || "SABOR_" || "peso_des_"
					WHEN "SUBCATEGORY" = 'MANI' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "PRESENTACION_"|| ',' || "VARIEDAD_" || ',' || "SABOR_"|| ',' || "peso_des_"
					WHEN "SUBCATEGORY" = 'SALCHICHAS Y CARNICOS EN CONSE' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SUBTIPO_"|| ',' || "TIPO_" || ',' || "peso_des_"
					WHEN "SUBCATEGORY" = 'VEGETALES EN CONSERVA' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SUBTIPO_"|| ',' || "EMPAQUE_" || ',' || "SABOR_"|| ',' || "TIPO_" || ',' || "RANGO_MIN_" || "peso_des_"
					WHEN "SUBCATEGORY" = 'GALLETAS' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "VARIEDAD_"|| ',' || "SABOR_" || ',' || "PRESENTACION_"|| ',' || "SEGMENTO_" || ',' || "segmento_noel_" || "peso_des_"				
					WHEN "SUBCATEGORY" = 'CEREALES EN BARRA' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SABOR_"|| ',' || "SUBMARCA_" || ',' || "VARIEDAD_"|| ',' || "PRESENTACION_" || ',' || "peso_des_"
					WHEN "SUBCATEGORY" = 'HELADOS' THEN "FABRICANTE_"|| ',' || "MARCA_"|| ',' || "SEGMENTO_"|| ',' || "TIPO_" || ',' || "TIPO_"|| ',' || "SUBMARCA_" || ',' || "SABOR_" || ',' ||  "RANGO_MIN_" || ',' || "peso_des_"
					ELSE ''
				END AS "DES_PRODUCTO"
	FROM var_h_producto 
),

var_adi_rangos1 AS (
	SELECT "AÑO",
			 "MES",	
			 "producto",
			 SUM("VENTAS_VALOR_nls") AS VENTAS_VALOR_nls, 
			 SUM("VENTAS_VOLUMEN_nls") AS VENTAS_VOLUMEN_nls,
			 COUNT(1) AS Record_Count,
			 MIN("factor_ajustes") AS FACTOR_Min,
			 MAX("factor_ajustes") AS FACTOR_Max,
			 MIN("peso") AS PESO_Min,
			 MAX("peso") AS PESO_Max 		 
	FROM var_descrip_prod 
	WHERE "producto" IS NOT NULL 
	GROUP BY "AÑO","MES","producto"
	-- ORDER BY "producto" ASC 
),

var_adi_rangos2 AS ( -- pendiente por verificar
	SELECT * 
	FROM var_adi_rangos1 a
	ORDER BY a."AÑO",a."MES" DESC
),	

var_adi_rangos3 AS (
	SELECT DISTINCT 
					 a."producto",
					 a."AÑO",
					 a."MES",
					 a."ventas_valor_nls",
					 a."ventas_volumen_nls",
					 a."record_count",
					 b."factor_min",
					 b."factor_max",
					 b."peso_min",
					 b."peso_max",
					 round(((a."ventas_volumen_nls"/a."ventas_valor_nls")*1000),2) AS precio_kilo,
					 round(((a."ventas_volumen_nls"/a."ventas_valor_nls")*(b."peso_min"::NUMERIC/1000)*1000),2)AS precio_multiempaque,
					 round((((a."ventas_volumen_nls"/a."ventas_valor_nls")*(b."peso_min"::NUMERIC/1000)/b."factor_max"::NUMERIC)*1000),2) AS precio_unidad,
					 round((b."peso_max"::NUMERIC/b."factor_max"::NUMERIC),2) AS peso_individual
	FROM var_adi_rangos2 a
	JOIN var_adi_rangos1 b ON a.producto = b.producto
	-- ORDER BY a."ventas_valor_nls" DESC 
	-- ORDER BY a."producto" ASC
),


var_adi_rangos AS (  -- VALIDAR DADO QUE CAMBIA POR LOS DECIMALES DE LA FUENTE PARA HELADOS
	SELECT DISTINCT a.*,
			 b."ventas_valor_nls",
			 b."ventas_volumen_nls",
			 b."record_count",
			 b."factor_min",
			 b."factor_max",
			 b."peso_min",
			 b."peso_max",
			 b."precio_kilo",
			 b."precio_multiempaque",
			 b."precio_unidad",
			 b."peso_individual"
	FROM var_descrip_prod a
	JOIN var_adi_rangos3 b ON a.producto = b.producto
)

SELECT *
FROM var_adi_rangos

