DROP TABLE IF EXISTS PUBLIC.va_pastas_tiponeg;
CREATE TABLE PUBLIC.va_pastas_tiponeg AS 
SELECT *
FROM PUBLIC.va_pastas_tiponeg_o;

DROP TABLE IF EXISTS PUBLIC.va_pastas_linea;
CREATE TABLE PUBLIC.va_pastas_linea AS 
SELECT *
FROM PUBLIC.va_pastas_linea_o;

DROP TABLE IF EXISTS PUBLIC.va_pastas_forma;
CREATE TABLE PUBLIC.va_pastas_forma AS 
SELECT *
FROM PUBLIC.va_pastas_forma_o;

DROP TABLE IF EXISTS PUBLIC.va_cafe_familia_empaque;
CREATE TABLE PUBLIC.va_cafe_familia_empaque AS 
SELECT *
FROM PUBLIC.va_cafe_familia_empaque_o;

DROP TABLE IF EXISTS PUBLIC.va_carnicos_tipo_salchicha;
CREATE TABLE PUBLIC.va_carnicos_tipo_salchicha AS 
SELECT *
FROM PUBLIC.va_carnicos_tipo_salchicha_o;

DROP TABLE IF EXISTS PUBLIC.sa_maproducto;
CREATE TABLE PUBLIC.sa_maproducto AS 
SELECT *
FROM PUBLIC.sa_maproducto_o;

DROP TABLE IF EXISTS PUBLIC.sa_producto;
CREATE TABLE PUBLIC.sa_producto AS 
SELECT *
FROM PUBLIC.sa_producto_o;

DROP TABLE IF EXISTS PUBLIC.ma_h_productos;
CREATE TABLE PUBLIC.ma_h_productos AS 
SELECT *
FROM PUBLIC.ma_h_productos_o