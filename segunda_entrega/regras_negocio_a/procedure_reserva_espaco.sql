CREATE OR REPLACE PROCEDURE reserva_espaco(
	id_pessoa INT,
	id_espaco INT,
	hora_inicial TIME,
	hora_final TIME,
	data_reserva DATE
)
LANGUAGE plpgsql    
AS $$
BEGIN
	IF 
	IF (
		SELECT COUNT(*) FROM adm_condominio.reserva
		WHERE fk_id_pessoa = id_pessoa AND 
		DATE_PART('month',data) = DATE_PART('month',data_reserva)
	) = 0 THEN
		INSERT INTO adm_condominio.reserva 
		VALUES(id_pessoa,id_espaco,hora_inicial,hora_final,data_reserva);
	ELSE IF (
		SELECT COUNT(*) FROM adm_condominio.reserva
		WHERE fk_id_pessoa = id_pessoa AND 
		DATE_PART('month',data) = DATE_PART('month',data_reserva)
	) < 3 THEN
		IF (SELECT COUNT(*) FROM adm_condominio.reserva WHERE data = data_reserva AND
		   fk_id_pessoa = id_pessoa) = 0 THEN
	END IF;
	COMMIT;
END;
$$;