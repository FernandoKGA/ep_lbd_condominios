SET SCHEMA 'adm_condominio';

CREATE TRIGGER verifica_eleicao BEFORE INSERT ON adm_condominio.corpo_administrativo
    FOR EACH ROW EXECUTE PROCEDURE eleicao_corpo_adm();