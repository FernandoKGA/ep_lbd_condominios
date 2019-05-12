SELECT * FROM adm_condominio.corpo_administrativo ORDER BY id_corpo DESC;

--INSERT INTO adm_condominio.corpo_administrativo(id_corpo,id_sindico, id_subsindico, id_conselheiro_1,
--											   id_conselheiro_2, id_conselheiro_3, data_eleicao)
--VALUES(102,7,12,30,38,43,'2018-05-12');

SELECT id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
FROM adm_condominio.corpo_administrativo adm_ca
WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', timestamp '2018-05-12');

SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
FROM adm_condominio.corpo_administrativo adm_ca
WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', timestamp '2019-05-12');

-- select que puxa os dois ultimos anos com base no ano parametro e 
SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
FROM adm_condominio.corpo_administrativo adm_ca
WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', timestamp '2019-05-12')
UNION	
SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
FROM adm_condominio.corpo_administrativo adm_ca
WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', timestamp '2018-05-12');

-- select como table
SELECT * FROM 
(
	SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
	FROM adm_condominio.corpo_administrativo adm_ca
	WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', timestamp '2019-05-12')
	UNION	
	SELECT id_corpo, id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3
	FROM adm_condominio.corpo_administrativo adm_ca
	WHERE DATE_PART('year', adm_ca.data_eleicao) = DATE_PART('year', timestamp '2018-05-12')
) AS elec_dois_ult_anos;