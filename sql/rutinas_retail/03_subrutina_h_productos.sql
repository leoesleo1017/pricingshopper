DROP TABLE IF EXISTS PUBLIC.temp_03_ma_h_productos;
CREATE TABLE PUBLIC.temp_03_ma_h_productos AS 

WITH 
var_h_producto_nuevos AS ( -- traer solo los productos nuevos del periodo a correr
	SELECT a.*,		   
			 b."producto"
	FROM PUBLIC.temp_02_var_adi_negocios a
	LEFT JOIN PUBLIC.ma_h_productos b ON a."PRODUCTO_nls" = b.producto_nls
	WHERE b."producto" IS NULL 
),

estructura_h_producto_nuevos AS (
	SELECT DISTINCT
		   '' AS "producto",
		   a."PRODUCTO_nls",
	       '0' as duplicado,
	       CASE WHEN a."CATEGORY" = 'S/A' THEN '' ELSE a."CATEGORY" END,       
	       CASE WHEN a."NEGOCIO" = 'S/A' THEN '' ELSE a."NEGOCIO" END,
	       CASE WHEN a."SUBCATEGORY" = 'S/A' THEN '' ELSE a."SUBCATEGORY" END,
	       CASE WHEN a."FABRICANTE" = 'S/A' THEN '' ELSE a."FABRICANTE" END,
	       CASE WHEN a."MARCA" = 'S/A' THEN '' ELSE a."MARCA" END,
	       '' AS "BARCODE",
	       CASE WHEN a."CONSISTENCIA" = 'S/A' THEN '' ELSE a."CONSISTENCIA" END,
	       CASE WHEN a."EMPAQUE" = 'S/A' THEN '' ELSE a."EMPAQUE" END,
	       CASE WHEN a."INTEGRALNOINTEGRAL" = 'S/A' THEN '' ELSE a."INTEGRALNOINTEGRAL" END,
	       CASE WHEN a."NIVELDEAZUCAR" = 'S/A' THEN '' ELSE a."NIVELDEAZUCAR" END,
	       CASE WHEN a."PRESENTACION" = 'S/A' THEN '' ELSE a."PRESENTACION" END,
	       a."RANGO_MIN" || ' A ' || a."RANGO_MAX" || 'GRS' AS "RANGO",       
	       CASE WHEN a."SABOR" = 'S/A' THEN '' ELSE a."SABOR" END,
	       CASE WHEN a."SEGMENTO" = 'S/A' THEN '' ELSE a."SEGMENTO" END,
	       CASE WHEN a."SUBMARCA" = 'S/A' THEN '' ELSE a."SUBMARCA" END,
	       CASE WHEN a."SUBTIPO" = 'S/A' THEN '' ELSE a."SUBTIPO" END,
	       CASE WHEN a."TAMANO_nls" = 'S/A' THEN '' ELSE a."TAMANO_nls" END,
	       CASE WHEN a."TIPO" = 'S/A' THEN '' ELSE a."TIPO" END,
	       CASE WHEN a."TIPO_CARNE" = 'S/A' THEN '' ELSE a."TIPO_CARNE" END,
	       CASE WHEN a."TIPODESABOR" = 'S/A' THEN '' ELSE a."TIPODESABOR" END,
	       CASE WHEN a."VARIEDAD" = 'S/A' THEN '' ELSE a."VARIEDAD" END,
		   a.factor
	FROM var_h_producto_nuevos a
),

generar_producto_viejo AS ( -- traer el producto_nls de los productos que tengan las mismas caracteristicas, para asociarlo en la tabla 
	SELECT b.*,
		   a."PRODUCTO_nls" AS "PRODUCTO_VIEJO"
	FROM estructura_h_producto_nuevos a
	JOIN ma_h_productos b ON a."CATEGORY" = b."category"
						 AND a."NEGOCIO" = b."negocio"
						 AND a."SUBCATEGORY" = b."subcategory"
						 AND a."FABRICANTE" = b."fabricante"
						 AND a."MARCA" = b."marca"
						 AND a."CONSISTENCIA" = b."consistencia"
						 AND a."EMPAQUE" = b."empaque"
						 AND a."INTEGRALNOINTEGRAL" = b."integralnointegral"
						 AND a."NIVELDEAZUCAR" = b."niveldeazucar"
						 AND a."PRESENTACION" = b."presentacion"
						 AND a."SABOR" = b."sabor"
						 AND a."SEGMENTO" = b."segmento"
						 AND a."SUBMARCA" = b."submarca"
						 AND a."TAMANO_nls" = b."tamano"
						 AND a."TIPO" = b."tipo"
						 AND a."TIPO_CARNE" = b."tipo_carne"
						 AND a."TIPODESABOR" = b."tipodesabor"
						 AND a."VARIEDAD" = b."variedad"
),

asociar_producto_viejo AS ( -- crear estructura h_producto, traer: 1.nuevos productos con caracteristicas iguales en viejos productos y 2.nuevos productos sin caracteristicas iguales 
	SELECT CASE WHEN b."PRODUCTO_VIEJO" IS NULL THEN a."PRODUCTO_nls" ELSE b."PRODUCTO_VIEJO"  END AS "producto",
		    a."PRODUCTO_nls" AS producto_nls,
			CASE WHEN b."PRODUCTO_VIEJO" IS NULL THEN '0' ELSE '1' END AS duplicado,
			a."CATEGORY" AS category,       
			a."NEGOCIO" AS negocio,
			a."SUBCATEGORY" AS subcategory,
			a."FABRICANTE" AS fabricante,
			a."MARCA" AS marca,
			a."BARCODE" AS barcode,
			a."CONSISTENCIA" AS consistencia,
			a."EMPAQUE" AS empaque,
			a."INTEGRALNOINTEGRAL" AS integralnointegral,
			a."NIVELDEAZUCAR" AS niveldeazucar,
			a."PRESENTACION" AS presentacion,
			a."RANGO" AS rango, 
			a."SABOR" AS sabor,
			a."SEGMENTO" AS segmento,
			a."SUBMARCA" AS submarca,
			a."SUBTIPO" AS subtipo,
			a."TAMANO_nls" AS tamano,
			a."TIPO" AS tipo,
			a."TIPO_CARNE" AS tipo_carne,
			a."TIPODESABOR" AS tipodesabor,
			a."VARIEDAD" AS variedad,
			a.factor			 
	FROM generar_producto_viejo b
	RIGHT JOIN estructura_h_producto_nuevos a ON a."CATEGORY" = b."category"
											 AND a."NEGOCIO" = b."negocio"
											 AND a."SUBCATEGORY" = b."subcategory"
											 AND a."FABRICANTE" = b."fabricante"
											 AND a."MARCA" = b."marca"
											 AND a."CONSISTENCIA" = b."consistencia"
											 AND a."EMPAQUE" = b."empaque"
											 AND a."INTEGRALNOINTEGRAL" = b."integralnointegral"
											 AND a."NIVELDEAZUCAR" = b."niveldeazucar"
											 AND a."PRESENTACION" = b."presentacion"
											 AND a."SABOR" = b."sabor"
											 AND a."SEGMENTO" = b."segmento"
											 AND a."SUBMARCA" = b."submarca"
											 AND a."TAMANO_nls" = b."tamano"
											 AND a."TIPO" = b."tipo"
											 AND a."TIPO_CARNE" = b."tipo_carne"
											 AND a."TIPODESABOR" = b."tipodesabor"
											 AND a."VARIEDAD" = b."variedad"
)

SELECT *
FROM asociar_producto_viejo;

-- añadir los productos nuevos en la tabla ma_h_productos
DROP TABLE IF EXISTS PUBLIC.temp_ma_h_productos;
CREATE TABLE PUBLIC.temp_ma_h_productos AS 
SELECT *
FROM PUBLIC.temp_03_ma_h_productos
UNION 
SELECT *
FROM PUBLIC.ma_h_productos;

DROP TABLE IF EXISTS PUBLIC.ma_h_productos;
CREATE TABLE PUBLIC.ma_h_productos AS 
SELECT *
FROM PUBLIC.temp_ma_h_productos;

DROP TABLE IF EXISTS PUBLIC.temp_ma_h_productos;