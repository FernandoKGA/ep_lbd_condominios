--TRIGGER 1
CREATE OR REPLACE FUNCTION fc_insere_apartamentos()
RETURNS trigger AS $tr_apartamentos$
DECLARE
	id_m integer;
BEGIN
	SELECT max(id_moradia) into id_m from adm_condominio.Moradia;

	FOR i in 1 .. new.andares
	LOOP
		FOR j in 1 .. new.qtd_finais
		LOOP
		
			id_m := id_m + 1;
			

			INSERT INTO adm_condominio.Moradia (tipo_moradia, id_moradia) VALUES 
				('a', (id_m));

			INSERT INTO adm_condominio.Moradia_Edificio (fk_id_edificio, fk_id_moradia) VALUES 
				(new.id_edificio, (id_m));
			
					
					
			INSERT INTO adm_condominio.Condominio_Moradia (fk_id_condominio, fk_id_moradia) VALUES 
				(new.fk_id_condominio, (id_m));
							

			INSERT INTO adm_condominio.Apartamento (fk_id_moradia,andar, final, numero_ap) VALUES
				(id_m, i, j, CAST(CONCAT(CAST(i as varchar(10)), CAST(j as varchar(10))) AS INT));
		END LOOP;
	END LOOP;

RETURN NEW;
END;
$tr_apartamentos$ LANGUAGE plpgsql;

CREATE TRIGGER tr_insere_apartamentos
AFTER INSERT ON adm_condominio.Edificio
FOR EACH ROW
EXECUTE PROCEDURE fc_insere_apartamentos();

--TESTES DO TRIGGER 1
INSERT INTO adm_condominio.Edificio (nome_edificio,bloco,andares,qtd_finais,fk_id_condominio,id_edificio) VALUES 
('Edificio teste 1', 'Por do sol', 21, 4, 43, 51);

INSERT INTO adm_condominio.Edificio (nome_edificio,bloco,andares,qtd_finais,fk_id_condominio,id_edificio) VALUES 
('Edificio teste 2', 'Cantareira', 21, 8, 43, 52);

INSERT INTO adm_condominio.Edificio (nome_edificio,bloco,andares,qtd_finais,fk_id_condominio,id_edificio) VALUES 
('Edificio teste 2', 'Lazarus', 8, 1, 50, 53);



--TRIGGER 2 - ta errado!!!
CREATE OR REPLACE FUNCTION fc_deleta_apartamentos()
RETURNS trigger AS $tr_dapartamentos$
BEGIN 
	
	CREATE TABLE table_holder AS (SELECT fk_id_moradia FROM adm_condominio.Moradia_Edificio WHERE fk_id_edificio = old.id_edificio);

	
	DELETE FROM adm_condominio.Moradia_Pessoa WHERE fk_id_moradia IN 
		(SELECT id_moradia from adm_condominio.Moradia WHERE id_moradia IN (SELECT * FROM table_holder));

	DELETE FROM adm_condominio.Condominio_Moradia WHERE  fk_id_moradia IN (SELECT * FROM table_holder);
	DELETE FROM adm_condominio.Apartamento WHERE  fk_id_moradia IN (SELECT * FROM table_holder);
	DELETE FROM adm_condominio.Moradia_Edificio WHERE fk_id_edificio = old.id_edificio;
	DELETE FROM adm_condominio.Moradia WHERE  id_moradia IN (SELECT * FROM table_holder);
	DROP TABLE table_holder;
RETURN NEW;
END;
$tr_dapartamentos$ LANGUAGE plpgsql;

CREATE TRIGGER tr_deleta_apartamentos
AFTER DELETE ON adm_condominio.Edificio
FOR EACH ROW
EXECUTE PROCEDURE fc_deleta_apartamentos();

--TESTES DO TRIGGER 2
DELETE FROM adm_condominio.Edificio WHERE id_edificio = 51;
DELETE FROM adm_condominio.Edificio WHERE bloco = 'Cantareira';
DELETE FROM adm_condominio.Edificio WHERE fk_id_condominio = 50;
