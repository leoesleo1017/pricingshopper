DROP TABLE IF EXISTS PUBLIC.temp_05_va_codificacion;
CREATE TABLE PUBLIC.temp_05_va_codificacion AS 

SELECT a.id_tipo_codificacion,
	   a.descripcion,
	   a.codificacion,
	   b.tipo_codificacion,
	   b.inicial,
	   b.estado_retail,
	   b.estado_scantrack,
	   CASE 
		WHEN RIGHT(a."descripcion",char_length(c."descripcion")) = c."descripcion" THEN REPLACE(a."descripcion",c."descripcion",'')
		ELSE a."descripcion"		 
	   END AS "descripcion_"
FROM PUBLIC.va_codificacion a
JOIN PUBLIC.ma_tipo_codificacion b ON a.id_tipo_codificacion = b.id
LEFT JOIN PUBLIC.ma_extension c ON c.tipo_codificacion = b.tipo_codificacion AND RIGHT(a."descripcion",char_length(c."descripcion")) LIKE c."descripcion"
