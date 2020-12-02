-- consulta de apoyo del método ingresarRglas en el programa de python
SELECT b.variable_adicional,a.nombre,a.regla
FROM PUBLIC.conf_reglas a
JOIN PUBLIC.ma_variable_adicional b ON a.id = b.id