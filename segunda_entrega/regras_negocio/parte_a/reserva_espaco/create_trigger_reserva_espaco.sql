SET SCHEMA 'adm_condominio';

CREATE TRIGGER reserva_espacos BEFORE INSERT ON adm_condominio.reserva
    FOR EACH ROW EXECUTE PROCEDURE reserva_espaco_unico();
