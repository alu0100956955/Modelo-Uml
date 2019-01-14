-- El tipo direccion
CREATE TYPE direccion AS (
tipo VARCHAR(45),
nombre_via VARCHAR(45),
Poblacion INT,
CP INT,
Provincia VARCHAR(45)) ;
-- Alterar la columna direccion
ALTER TABLE mydb.jefeproyecto
ALTER COLUMN direccion TYPE direccion
USING direccion::direccion;

--El tipo puntos
CREATE TYPE puntos AS (
coord_X float,
coord_Y float);

-- NO SE PUEDE USAR EL ARRAY PARA DATOS CHAR
-- Actualizar la tabla jefeproyecto para introducir la direccion
START TRANSACTION;
--UPDATE mydb.jefeproyecto SET direccion = ARRAY['calle','san lorenzo',15623,37207,'laguna'] WHERE cod_jefeproyecto = 12;
UPDATE mydb.jefeproyecto SET direccion = '(calle,san_lorenzo,15623,37207,laguna)' WHERE cod_jefeproyecto = 12;
COMMIT;


START TRANSACTION;
UPDATE mydb.plano SET fecha_entrega = '2018-11-25' WHERE cod_plano = 333;
COMMIT;

-- Actualizar la tabla linea
START TRANSACTION;


COMMIT;

