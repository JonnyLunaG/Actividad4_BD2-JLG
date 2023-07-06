
--Punto 5.5
/**Se crea la función**/
CREATE OR REPLACE FUNCTION verificar_mayoria_edad()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fechanac > (CURRENT_DATE - INTERVAL '18 years') THEN
        RAISE EXCEPTION 'El usuario debe ser mayor de edad.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/**se crea el trigger**/
CREATE OR REPLACE TRIGGER trigger_verificar_mayoria_edad
BEFORE INSERT ON usuarios
FOR EACH ROW
EXECUTE FUNCTION verificar_mayoria_edad();


/**se agrega el trigger a la tabla usuarios**/
ALTER TABLE usuarios
ENABLE TRIGGER trigger_verificar_mayoria_edad;


INSERT INTO usuarios (idusuario, documento, tipodoc, primernombre, segundonombre, apellido1, apellido2, genero, fechanac, rol)
VALUES (15, '123456789', 'TI', 'Johnny', 'Johnny', 'Luna', 'Urango', 'M', '1996-09-21', 'Docente');

INSERT INTO usuarios (idusuario, documento, tipodoc, primernombre, segundonombre, apellido1, apellido2, genero, fechanac, rol)
VALUES (15, '123456854', 'TI', 'Leidy', 'Johanna', 'Luna', 'Perez', 'F', '2011-07-29', 'Estudiante');


--Punto 5.6
/**Se crea la función**/
CREATE OR REPLACE FUNCTION manipular_datos_antiguos()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Datos antiguos: %', OLD;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/**se crea el trigger**/
CREATE OR REPLACE TRIGGER trigger_manipular_datos_antiguos
AFTER UPDATE ON asignaturas
FOR EACH ROW
EXECUTE FUNCTION manipular_datos_antiguos();

/**se asigna el trigger a la tabla asignaturas**/
ALTER TABLE asignaturas
ENABLE TRIGGER trigger_manipular_datos_antiguos;

/**Se prueba el trigger modificando la tabla asignaturas**/
UPDATE asignaturas
SET intensidadhs = 4
WHERE idasignatura = 4;

/**se verifican los cambios en la tabla asignaturas**/
SELECT * FROM asignaturas;

ALTER TABLE 


--Punto 5.7
/**Se crea la función**/
CREATE OR REPLACE FUNCTION auditar_actualizacion_contratos()
RETURNS TRIGGER AS $$
BEGIN
    -- Antes de la actualización
    RAISE NOTICE 'Antes de la actualización - Datos antiguos: %', OLD;

    -- Después de la actualización
    RAISE NOTICE 'Después de la actualización - Datos nuevos: %', NEW;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
/**Se crea el Triggerpara BEFORE UPDATE **/
CREATE OR REPLACE TRIGGER trigger_auditar_actualizacion_contratos_before
BEFORE UPDATE ON contratos
FOR EACH ROW
EXECUTE FUNCTION auditar_actualizacion_contratos();

/**Se crea el Triggerpara AFTER UPDATE **/
CREATE OR REPLACE TRIGGER trigger_auditar_actualizacion_contratos_after
AFTER UPDATE ON contratos
FOR EACH ROW
EXECUTE FUNCTION auditar_actualizacion_contratos();

/**Se asigna a la tabla contratos los triggers creados**/
ALTER TABLE contratos
ENABLE TRIGGER trigger_auditar_actualizacion_contratos_before;

ALTER TABLE contratos
ENABLE TRIGGER trigger_auditar_actualizacion_contratos_after;

/** Se prueban los triguers **/
UPDATE contratos
SET tipocontrato = 'PROPIEDAD'
WHERE tipocontrato = 'Propiedad';

-- Punto 5.8
SELECT trigger_name, event_object_table, action_timing, event_manipulation
FROM information_schema.triggers;

-- Punto 5.9
CREATE OR REPLACE FUNCTION auditar_actualizacion_contratos()
RETURNS TRIGGER AS $$
BEGIN
    -- Antes de la actualización
    RAISE NOTICE 'Antes de la actualización - Datos antiguos: %', OLD;

    -- Incrementar el salario en un 15%
    NEW.salario = OLD.salario * 1.15;

    -- Después de la actualización
    RAISE NOTICE 'Después de la actualización - Datos nuevos: %', NEW;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

UPDATE contratos
SET tipocontrato = 'propiedad'
WHERE tipocontrato = 'PROPIEDAD';

-- Punto 5.10
DROP TRIGGER trigger_manipular_datos_antiguos ON asignaturas;

















 
/****/
SELECT * FROM usuarios;
