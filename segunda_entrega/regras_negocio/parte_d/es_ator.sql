CREATE VIEW es_ator AS 
	SELECT	entrada_saida.id_es AS id_es,
			entrada_saida.data_hora AS data_hora, 
			(CASE WHEN entrada_saida.acao = 'e'
				  THEN 'Entrada'
				  WHEN entrada_saida.acao = 's'
				  THEN 'Saída'
				  ELSE NULL
				  END
			 ) AS acao,
			COALESCE(pessoa.id_pessoa, veiculo.id_veiculo) AS fk_id_ator,
			COALESCE(pessoa.cpf, veiculo.placa) AS registro_ator
			FROM adm_condominio.entrada_saida AS entrada_saida
			LEFT JOIN adm_condominio.es_pessoa AS es_pessoa
				   ON es_pessoa.fk_id_es = entrada_saida.id_es	
			LEFT JOIN adm_condominio.pessoa AS pessoa
				   ON pessoa.id_pessoa = es_pessoa.fk_id_pessoa
			LEFT JOIN adm_condominio.es_veiculo AS es_veiculo
				   ON es_veiculo.fk_id_es = entrada_saida.id_es
			LEFT JOIN adm_condominio.veiculo AS veiculo
				   ON veiculo.id_veiculo = es_veiculo.fk_id_veiculo
				
			ORDER BY 2 DESC
			