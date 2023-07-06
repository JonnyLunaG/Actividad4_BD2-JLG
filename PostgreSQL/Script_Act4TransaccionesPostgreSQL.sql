
-- Punto 5.11
CREATE OR REPLACE FUNCTION actualizar_estado_credito()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE creditos
    SET estado = 'AL DIA'
    WHERE id = NEW.credito_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_actualizar_estado_credito
AFTER INSERT ON pagos
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_credito();

ALTER TABLE pagos
ENABLE TRIGGER trigger_actualizar_estado_credito;


INSERT INTO pagos (id, fecha, valor, credito_id)
VALUES (10,'2022-07-15', 19200, 2);

SELECT * FROM creditos;

--Punto 5.12
CREATE OR REPLACE FUNCTION actualizar_estado_credito()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE creditos
    SET estado = 'POR AUDITAR'
    WHERE id = OLD.credito_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_actualizar_estado_credito
AFTER DELETE ON pagos
FOR EACH ROW
EXECUTE FUNCTION actualizar_estado_credito();

ALTER TABLE pagos
ENABLE TRIGGER trigger_actualizar_estado_credito;

DELETE FROM pagos
WHERE id = 10;

SELECT * FROM creditos;

--Punto 5.13
ALTER TABLE deudores
ADD COLUMN puntos INT;

SELECT * FROM deudores;

-- Punto 5.15
CREATE OR REPLACE FUNCTION verificar_pago_completo()
RETURNS TRIGGER AS $$
DECLARE
    total_pagos FLOAT;
    total_deuda FLOAT;
BEGIN
    -- Se Obtiene la suma del total de los pagos del mismo deudor
    SELECT COALESCE(SUM(valor), 0) INTO total_pagos
    FROM pagos
    WHERE credito_id = NEW.credito_id;

    -- Se obtiene el valor total de la deuda del mismo crédito
    SELECT valor * (1+interes_mes) INTO total_deuda
    FROM creditos
    WHERE id = NEW.credito_id;

    -- Se verifica si la deuda ha sido cancelada en su totalidad
    IF total_pagos >= total_deuda THEN
        -- se actualiza el estado del crédito a 'TERMINADO'
        UPDATE creditos
        SET estado = 'TERMINADO'
        WHERE id = NEW.credito_id;

        -- Incrementar en 1 el valor de la columna 'puntos' en la tabla 'deudores'
        UPDATE deudores
        SET puntos = puntos + 1
        WHERE cc = (SELECT deudor_id FROM creditos WHERE id = NEW.credito_id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_verificar_pago_completo
AFTER INSERT ON pagos
FOR EACH ROW
EXECUTE FUNCTION verificar_pago_completo();

ALTER TABLE pagos
ENABLE TRIGGER trigger_verificar_pago_completo;   

SELECT * FROM creditos;

/**Se realizan 6 pagos en al credito con id = 4 para finalizarlo**/
CALL insertar_pagos(14,'2022-07-15',140000,4);
CALL insertar_pagos(15,'2022-08-15',140000,4);
CALL insertar_pagos(16,'2022-09-15',140000,4);
CALL insertar_pagos(17,'2022-10-15',140000,4);
CALL insertar_pagos(18,'2022-10-15',140000,4);
CALL insertar_pagos(19,'2022-10-15',140000,4);

/**verificamos el la tabla créditos**/
SELECT * FROM creditos;

/**Verificamos que en la tabla deudores el Trigger
halla colocado 1 punto en la columna puntos****/
SELECT * FROM deudores;

/**FIN**/

SELECT * FROM creditos;
SELECT * FROM pagos;
SELECT * FROM deudores;

UPDATE deudores
SET puntos = 0;


