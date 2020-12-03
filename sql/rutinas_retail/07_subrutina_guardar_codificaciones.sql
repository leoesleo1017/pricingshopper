SELECT DISTINCT b."tipo_codificacion",a."codificacion"
FROM PUBLIC.va_codificacion a
JOIN PUBLIC.ma_tipo_codificacion b ON a."id_tipo_codificacion" = b."id"
WHERE b."tipo_codificacion" = '{tipo_codificacion}'