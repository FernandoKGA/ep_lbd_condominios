-- conta a quantidade de reservas do espaco
SELECT fk_id_espaco, COUNT(fk_id_espaco) FROM adm_condominio.reserva
GROUP BY fk_id_espaco;

-- seleciona todas as reservas do espaco 62
SELECT * FROM adm_condominio.reserva WHERE fk_id_espaco = 62;

-- conta a quantidade de vezes que uma reserva foi feita por uma pessoa (total vida)
SELECT COUNT(*) FROM adm_condominio.reserva WHERE fk_id_pessoa = 67;

-- seleciona todas as reservas da pessoa com id 67
SELECT * FROM adm_condominio.reserva WHERE fk_id_pessoa = 67;

--  seleciona a quantidade de reservas feitas por uma pessoa em um determinado mes
SELECT COUNT(*) FROM adm_condominio.reserva
WHERE fk_id_pessoa = 67 AND DATE_PART('month',data) = 11;

