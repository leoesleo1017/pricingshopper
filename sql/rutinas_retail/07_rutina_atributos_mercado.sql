DROP TABLE IF EXISTS PUBLIC.temp_08_atributos_mercado;
CREATE TABLE PUBLIC.temp_08_atributos_mercado AS 

WITH 
_va_codificacion AS (
	SELECT *
	FROM PUBLIC.temp_05_va_codificacion
	WHERE "tipo_codificacion" = 'SUBCANAL'
	AND "tipo_codificacion" = 'CANAL'
	AND "tipo_codificacion" = 'REGION'
)

SELECT a.*,	
	   c."codificacion" AS "COD_SUBCANAL",
	   d."codificacion" AS "COD_CANAL",
	   e."codificacion" AS "COD_REGION",
	   b."cod_mercado",
	   a."FECHA" AS "COD_PERIODO"
FROM PUBLIC.temp_05_va_codificacion7 a
LEFT JOIN _va_codificacion c ON a."SUBCANAL" = BTRIM(REPLACE(c."descripcion",'.',' ')) 
LEFT JOIN _va_codificacion d ON a."CANAL" = BTRIM(REPLACE(d."descripcion",'.',' ')) 
LEFT JOIN _va_codificacion e ON a."REGION" = BTRIM(REPLACE(e."descripcion",'.',' ')) 
LEFT JOIN PUBLIC.ma_mercado_codificacion b ON BTRIM(a."MERCADO") = BTRIM(b."mercado") 


