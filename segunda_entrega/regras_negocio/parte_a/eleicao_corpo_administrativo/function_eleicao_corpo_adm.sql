SET SCHEMA 'adm_condominio';

CREATE OR REPLACE FUNCTION eleicao_corpo_adm() RETURNS TRIGGER AS $$
BEGIN
	DROP TABLE IF EXISTS elec_dois_ult_anos;
	CREATE TEMP TABLE elec_dois_ult_anos 
	(
		id_corpo INT,
		id_sindico INT,
		id_subsindico INT,
		id_conselheiro_1 INT,
		id_conselheiro_2 INT,
		id_conselheiro_3 INT
	);
	
	INSERT INTO elec_dois_ult_anos
	SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
    FROM adm_condominio.corpo_administrativo adm_ca
    WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', (NEW.data_eleicao - interval '1 year'))
    UNION	
    SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
    FROM adm_condominio.corpo_administrativo adm_ca
    WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', (NEW.data_eleicao - interval '2 years'));

	
	-- verificar ano de eleicao
	IF (DATE_PART('year', NEW.data_eleicao) >= DATE_PART('year',NOW())) THEN
	
	-- verifica se ja ocorreu uma eleicao naquele ano
	IF NOT EXISTS
	(
		SELECT * 
		FROM adm_condominio.corpo_administrativo adm_ca
		WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', NEW.data_eleicao)
	)
	THEN
	
	-- verifica síndico ja foi eleito 2 vezes
	IF 
	(
		SELECT COUNT(*) FROM elec_dois_ult_anos edua
		WHERE edua.id_sindico = NEW.id_sindico
	) < 2 THEN
	
	-- verifica sub-síndico ja foi eleito 2 vezes
	IF 
	(
		SELECT COUNT(*) FROM elec_dois_ult_anos edua
		WHERE edua.id_subsindico = NEW.id_subsindico
	) < 2 THEN
	
	-- verifica conselheiro 1 ja foi eleito 2 vezes
	IF 
	(
		SELECT COUNT(*) FROM elec_dois_ult_anos edua
		WHERE edua.id_conselheiro_1 = NEW.id_conselheiro_1
	) < 2 THEN
	
	
	-- verifica conselheiro 2 ja foi eleito 2 vezes
	IF 
	(
		SELECT COUNT(*) FROM elec_dois_ult_anos edua
		WHERE edua.id_conselheiro_2 = NEW.id_conselheiro_2
	) < 2 THEN
	
	
	-- verifica conselheiro 3 ja foi eleito 2 vezes
	IF 
	(
		SELECT COUNT(*) FROM elec_dois_ult_anos edua
		WHERE edua.id_conselheiro_3 = NEW.id_conselheiro_3
	) < 2 THEN
	
		RETURN NEW;
	
	-- else conselheiro 3 ja eleito
	ELSE RAISE EXCEPTION 'O conselheiro 3 já foi eleito duas vezes seguidas nos últimos anos!';
    END IF;
	-- else conselheiro 2 ja eleito
	ELSE RAISE EXCEPTION 'O conselheiro 2 já foi eleito duas vezes seguidas nos últimos anos!';
    END IF;
	-- else conselheiro 1 ja eleito
	ELSE RAISE EXCEPTION 'O conselheiro 1 já foi eleito duas vezes seguidas nos últimos anos!';
    END IF;
	-- else subsindico ja eleito
	ELSE RAISE EXCEPTION 'O sub-síndico já foi eleito duas vezes seguidas nos últimos anos!';
    END IF;
	-- else sindico ja eleito
	ELSE RAISE EXCEPTION 'O síndico já foi eleito duas vezes seguidas nos últimos anos!';
    END IF;
	-- else ja ocorreu eleicao
	ELSE RAISE EXCEPTION 'Um corpo já foi eleito esse ano!';
	END IF;
	-- else ano anterior ao atual
	ELSE RAISE EXCEPTION 'Você não pode eleger um corpo para um ano anterior ao atual!';
	END IF;
	
	DROP TABLE IF EXISTS elec_dois_ult_anos;
END;
$$ LANGUAGE plpgsql;