DROP TABLE IF EXISTS {tabla_com};
CREATE TABLE {tabla_com} AS 
SELECT *
FROM {tabla_va}
UNION 
SELECT *
FROM {tabla_temp};

DROP TABLE IF EXISTS {tabla_va};
CREATE TABLE {tabla_va} AS 
SELECT *
FROM {tabla_com};

DROP TABLE IF EXISTS {tabla_com};