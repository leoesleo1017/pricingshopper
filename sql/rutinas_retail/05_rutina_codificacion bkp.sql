DROP TABLE IF EXISTS PUBLIC.temp_05_codificacion;
CREATE TABLE PUBLIC.temp_05_codificacion AS 

WITH 
codificacion AS (
	SELECT *,
		CASE 
			WHEN b.tipo_codificacion = 'MARCA' AND RIGHT(a."descripcion",6) = '_NRCOM' THEN REPLACE(a."descripcion",'_NRCOM','')
			WHEN b.tipo_codificacion = 'MARCA' AND RIGHT(a."descripcion",5) = '_NRCL' THEN REPLACE(a."descripcion",'_NRCL','')
			WHEN b.tipo_codificacion = 'MARCA' AND RIGHT(a."descripcion",5) = '_NSCL' THEN REPLACE(a."descripcion",'_NSCL','')
		  ELSE a."descripcion"
		END AS "descripcion_"
	FROM PUBLIC.va_codificacion a
	JOIN PUBLIC.ma_tipo_codificacion b ON a.id_tipo_codificacion = b.id
)
					
SELECT a.*, 
		'05'             AS "COD_FUENTE",
		b."codificacion" AS "COD_CATEGORY",
		c."codificacion" AS "COD_CONSISTENCIA",
		d."codificacion" AS "COD_EMPAQUE",	
		e."codificacion" AS "COD_FABRICANTE",
		f."codificacion" AS "COD_FAMILIA",
		g."codificacion" AS "COD_FAMILIA_DE_EMPAQUE",
		h."codificacion" AS "COD_FORMA",
		i."codificacion" AS "COD_INTEGRALNOINTEGRAL",
		j."codificacion" AS "COD_LINEA",
		k."codificacion" AS "COD_MARCA",
		l."codificacion" AS "COD_NIVELDEAZUCAR",
		ll."codificacion" AS "COD_PRESENTACION",
		m."codificacion" AS "COD_SABOR",
		n."codificacion" AS "COD_SEGM_PRECIO",
		o."codificacion" AS "COD_SEGMENTO",
		p."codificacion" AS "COD_SEGMENTO_NOEL",
		q."codificacion" AS "COD_SEGMENTO_TMLUC",
		r."codificacion" AS "COD_SUBCATEGORY",
		s."codificacion" AS "COD_SUBLINEA",
		t."codificacion" AS "COD_SUBMARCA",
		u."codificacion" AS "COD_SUBSEGMENTO_NOEL",
		v."codificacion" AS "COD_SUBTIPO",
		w."codificacion" AS "COD_TAMANO_nls",
		x."codificacion" AS "COD_TIPO",
		y."codificacion" AS "COD_TIPO_CARNE",
		z."codificacion" AS "COD_TIPO_SALCHICHA",
		aa."codificacion" AS "COD_TIPO_SABOR",
		ab."codificacion" AS "COD_VARIEDAD",
		ac."codificacion" AS "COD_RANGO_PRECIO",
		ac."codificacion" AS "ATTRGEN4",
		ad."codificacion" AS "ATTRGEN5",
		ad."codificacion" AS "COD_RANGO_TAMANO",
		ae."codificacion" AS "ATTRGEN6",
		ae."codificacion" AS "COD_RANGO_PRECIO_INDIVIDUAL",
		af."codificacion" AS "ATTRGEN7",
		af."codificacion" AS "COD_RANGO_TAMANO_INDIVIDUAL",
		ag."codificacion" AS "COD_TIPONEG",
		ah."codificacion" AS "COD_NEGOCIO",
		ai."codificacion" AS "COD_OFERTA_PROMOCION",
		aj."codificacion" AS "ATTRGEN8",
		aj."codificacion" AS "COD_MUNDOS_SHOPPER",
		ak."COD_PRODUCTO"
FROM PUBLIC.temp_04_rangos a
LEFT JOIN codificacion b ON a."CATEGORY" = b."descripcion" AND b."tipo_codificacion" = 'CATEGORY'
LEFT JOIN codificacion c ON a."CONSISTENCIA" = c."descripcion" AND c."tipo_codificacion" = 'CONSISTENCIA'
LEFT JOIN codificacion d ON a."EMPAQUE" = d."descripcion" AND d."tipo_codificacion" = 'EMPAQUE'
LEFT JOIN codificacion e ON a."FABRICANTE" = REPLACE(e."descripcion",'.',' ') AND e."tipo_codificacion" = 'FABRICANTE'   
LEFT JOIN codificacion f ON a."FAMILIA" = f."descripcion" AND f."tipo_codificacion" = 'FAMILIA'
LEFT JOIN codificacion g ON a."FAMILIA_DE_EMPAQUE" = g."descripcion" AND g."tipo_codificacion" = 'FAMILIA_DE_EMPAQUE'  
LEFT JOIN codificacion h ON a."FORMA" = h."descripcion" AND h."tipo_codificacion" = 'FORMA'
LEFT JOIN codificacion i ON a."INTEGRALNOINTEGRAL" = i."descripcion" AND i."tipo_codificacion" = 'INTEGRALNOINTEGRAL'
LEFT JOIN codificacion j ON a."LINEA" = j."descripcion" AND j."tipo_codificacion" = 'LINEA'
LEFT JOIN codificacion k ON a."MARCA" = k."descripcion_" AND k."tipo_codificacion" = 'MARCA'
LEFT JOIN codificacion l ON a."NIVELDEAZUCAR" = l."descripcion" AND l."tipo_codificacion" = 'NIVELDEAZUCAR'
LEFT JOIN codificacion ll ON a."PRESENTACION" = ll."descripcion" AND ll."tipo_codificacion" = 'PRESENTACION'
LEFT JOIN codificacion m ON a."SABOR" = m."descripcion" AND m."tipo_codificacion" = 'SABOR'
LEFT JOIN codificacion n ON a."SEGM_PRECIO" = n."descripcion" AND n."tipo_codificacion" = 'SEGM_PRECIO' 
LEFT JOIN codificacion o ON a."SEGMENTO" = o."descripcion" AND o."tipo_codificacion" = 'SEGMENTO' 
LEFT JOIN codificacion p ON a."SEGMENTO_NOEL" = p."descripcion" AND p."tipo_codificacion" = 'SEGMENTO_NOEL' 
LEFT JOIN codificacion q ON a."SEGMENTO_TMLUC" = q."descripcion" AND q."tipo_codificacion" = 'SEGMENTO_TMLUC' 
LEFT JOIN codificacion r ON a."SUBCATEGORY" = r."descripcion" AND r."tipo_codificacion" = 'SUBCATEGORY'
LEFT JOIN codificacion s ON a."SUBLINEA" = s."descripcion" AND s."tipo_codificacion" = 'SUBCLINEA'
LEFT JOIN codificacion t ON a."SUBMARCA" = t."descripcion" AND t."tipo_codificacion" = 'SUBMARCA'
LEFT JOIN codificacion u ON a."SUBSEGMENTO_NOEL" = u."descripcion" AND u."tipo_codificacion" = 'SUBSEGMENTO_NOEL'
LEFT JOIN codificacion v ON a."SUBTIPO" = v."descripcion" AND v."tipo_codificacion" = 'SUBTIPO'
LEFT JOIN codificacion w ON a."TAMANO" = REPLACE(REPLACE(w."descripcion",' ',''),'S','') AND w."tipo_codificacion" = 'TAMANO_nls' -- con el replace se garantiza la unidad de medida GR para el cruce de datos
LEFT JOIN codificacion x ON a."TIPO" = x."descripcion" AND x."tipo_codificacion" = 'TIPO'
LEFT JOIN codificacion y ON a."TIPO_CARNE" = y."descripcion" AND y."tipo_codificacion" = 'TIPO_CARNE'
LEFT JOIN codificacion z ON a."TIPO_SALCHICHA" = z."descripcion" AND z."tipo_codificacion" = 'TIPO_SALCHICHA'
LEFT JOIN codificacion aa ON a."TIPO_SABOR" = aa."descripcion" AND aa."tipo_codificacion" = 'TIPO_SABOR'
LEFT JOIN codificacion ab ON a."VARIEDAD" = ab."descripcion" AND ab."tipo_codificacion" = 'VARIEDAD'
LEFT JOIN codificacion ac ON a."RANGO_PRECIO" = ac."descripcion" AND ac."tipo_codificacion" = 'RANGO_PRECIO'
LEFT JOIN codificacion ad ON a."RANGO_TAMANO" = ad."descripcion" AND ad."tipo_codificacion" = 'RANGO_TAMANO'
LEFT JOIN codificacion ae ON a."RANGO_PRECIO_INDIVIDUAL" = ae."descripcion" AND ae."tipo_codificacion" = 'RANGO_PRECIO_INDIVIDUAL'
LEFT JOIN codificacion af ON a."RANGO_TAMANO_INDIVIDUAL" = af."descripcion" AND af."tipo_codificacion" = 'RANGO_TAMANO_INDIVIDUAL'
LEFT JOIN codificacion ag ON a."TIPONEG" = ag."descripcion" AND ag."tipo_codificacion" = 'TIPONEG'
LEFT JOIN codificacion ah ON a."NEGOCIO" = ah."descripcion" AND ah."tipo_codificacion" = 'NEGOCIO'
LEFT JOIN codificacion ai ON a."OFERTA_PROMOCION" = ai."descripcion" AND ai."tipo_codificacion" = 'OFERTAPROMOCIONAL'
LEFT JOIN codificacion aj ON a."MUNDOS_SHOPPER" = aj."descripcion" AND aj."tipo_codificacion" = 'MUNDOS_SHOPPER'
LEFT JOIN PUBLIC.sa_producto ak  ON a."PRODUCTO" = SUBSTRING(ak."COD_PRODUCTO",6)

