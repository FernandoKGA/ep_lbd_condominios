SET SCHEMA 'adm_condominio';

CREATE OR REPLACE FUNCTION eleicao_corpo_adm() RETURNS TRIGGER AS $$
BEGIN
	-- verifica se o horario de encerramento da reserva eh superior a 22h
	IF 
	(SELECT NEW.hora_final) <= time '22:00:00' THEN
	
	SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
    FROM adm_condominio.corpo_administrativo adm_ca
    WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', (NEW.data_eleicao - interval '1 year'))
    UNION	
    SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
    FROM adm_condominio.corpo_administrativo adm_ca
    WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', (NEW.data_eleicao - interval '2 years'));

	-- else hora final 22h
	ELSE RAISE EXCEPTION 'A hora final da reserva deve ser até 22h!';
	END IF;
END;
$$ LANGUAGE plpgsql;