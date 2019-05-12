SET SCHEMA 'adm_condominio';

CREATE OR REPLACE FUNCTION reserva_espaco_unico() RETURNS TRIGGER AS $$
BEGIN
	-- verifica se o horario de encerramento da reserva eh superior a 22h
	IF 
	(SELECT NEW.hora_final) <= time '22:00:00' THEN
	
	-- verifica se a duracao da reserva eh maior que 6h
	IF
	(SELECT NEW.hora_final - NEW.hora_inicial) <= interval '06:00:00' THEN
	
	-- verifica se ele ja alugou um espaco no dia
	IF NOT EXISTS
	(
		SELECT * FROM adm_condominio.reserva adm_r 
		WHERE adm_r.fk_id_pessoa = NEW.fk_id_pessoa AND
		adm_r.data = NEW.data
	) THEN
	
	-- verifica se o espaco ja foi alugado naquele dia
	IF NOT EXISTS
	(
		SELECT * FROM adm_condominio.reserva adm_r 
		WHERE adm_r.fk_id_espaco = NEW.fk_id_espaco AND
		adm_r.data = NEW.data 
	) THEN
	
	-- verifica se ele ja alugou 3 espaços no mes do mesmo ano		
	IF 
	(
		SELECT COUNT(*) FROM adm_condominio.reserva adm_r
		WHERE adm_r.fk_id_pessoa = NEW.fk_id_pessoa AND 
		DATE_PART('month', adm_r.data) = DATE_PART('month', NEW.data) AND
		DATE_PART('year', adm_r.data) = DATE_PART('year', NEW.data)
	) < 3 THEN
			RETURN NEW;
	
	-- else pessoa ja tem mais que 3 reservas
	ELSE RAISE EXCEPTION 'O condômino já tem mais que 3 reservas!';
	END IF;
	-- else espaco reservado no dia
	ELSE RAISE EXCEPTION 'Esse espaço já foi reservado neste dia!';	
	END IF;
	-- else condomino ja reservou um espaco no dia
	ELSE RAISE EXCEPTION 'Este condômino já reservou um espaço hoje!';
	END IF;
	-- else duracao 6h
	ELSE RAISE EXCEPTION 'A duração da reserva ultrapassa 6 horas!';
	END IF;
	-- else hora final 22h
	ELSE RAISE EXCEPTION 'A hora final da reserva deve ser até 22h!';
	END IF;
END;
$$ LANGUAGE plpgsql;