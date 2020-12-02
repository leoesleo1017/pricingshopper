DROP TABLE IF EXISTS PUBLIC.{tablatemp}; -- garantizar que no se tengan campos s/a ni vacios para que no se inserten 
CREATE TABLE PUBLIC.{tablatemp} AS 

WITH 
codificacion AS ( --Crear vista desnormalizada de la maestra de codificacion
	SELECT a.*,
           b.*,
		   CASE 
			  WHEN RIGHT(a."descripcion",char_length(c."descripcion")) = c."descripcion" THEN REPLACE(a."descripcion",c."descripcion",'')
			  ELSE a."descripcion"		 
		   END AS "descripcion_"
	FROM PUBLIC.va_codificacion a
	JOIN PUBLIC.ma_tipo_codificacion b ON a.id_tipo_codificacion = b.id
	LEFT JOIN PUBLIC.ma_extension c ON c.tipo_codificacion = b.tipo_codificacion AND RIGHT(a."descripcion",char_length(c."descripcion")) LIKE c."descripcion"
	WHERE b.tipo_codificacion = '{tipo_codificacion}'
),

filtro AS ( -- filtro para traer solo caracteristicas nuevas
	SELECT DISTINCT  
			 a."{tipo_codificacion}",
			 a."COD_FUENTE",
			 b."codificacion" AS "{cod_codificacion}"
	FROM PUBLIC.temp_04_rangos a
	LEFT JOIN codificacion b ON a."{tipo_codificacion}" = b."descripcion_"
	WHERE a."{tipo_codificacion}" IS NOT NULL
	AND a."{tipo_codificacion}" <> 'S/A'	
	AND a."{tipo_codificacion}" <> ''
	AND b."codificacion" IS NULL 
),

series AS ( -- crear un num autoincrementable 
	SELECT num
	FROM generate_series(1, (SELECT COUNT(1) FROM filtro)) num
),

max_cod AS (  -- hallar la maxima codificaion de la maestra para continuar con el consecutivo, en caso de ser null lo reinicia a uno
	SELECT CASE WHEN MAX(RIGHT("codificacion",3)::NUMERIC) IS NULL THEN 1 ELSE MAX(RIGHT("codificacion",3)::NUMERIC) END AS "COD_MAX"
	FROM codificacion
),

ceros AS ( -- controlar la cantidad de ceros de acuerdo al cod_max resultante del paso anterior
	SELECT CASE 
				WHEN "COD_MAX" BETWEEN 1 AND 9 THEN '0000'
				WHEN "COD_MAX" BETWEEN 10 AND 99 THEN '000'
				WHEN "COD_MAX" BETWEEN 100 AND 999 THEN '00'
				WHEN "COD_MAX" > 1000 THEN '0'
			 END AS "CEROS"	
	FROM max_cod
),

estructura_cod AS ( -- estructurar la codificacion, el num autoincrementable se suma de cod max para garantizar la codificacion consecutiva
	SELECT DISTINCT  
			 b."{tipo_codificacion}",
			 a."num",
			 '{inicial_codificacion}' || "COD_FUENTE" || d."CEROS" || (a."num" + c."COD_MAX") AS "{cod_codificacion}"
	FROM series a 
	CROSS JOIN filtro b
	CROSS JOIN max_cod c 
	CROSS JOIN ceros d
),

row_number AS ( -- garantizar registros unicos ordenado por autoincrementable, dado que el cross join anterior crea un cuadro cartesiano
	SELECT *,row_number() OVER (partition BY "num" ORDER BY "num") AS rownum 
	FROM estructura_cod
)

SELECT "{cod_codificacion}","{tipo_codificacion}"
FROM row_number
WHERE rownum = 1