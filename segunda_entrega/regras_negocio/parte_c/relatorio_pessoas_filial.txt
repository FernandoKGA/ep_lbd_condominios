CREATE VIEW relatorio_pessoas_filial AS 
	SELECT  pessoa.nome AS nome,
			pessoa.cpf AS cpf,
			(CASE WHEN moradia.tipo_moradia = 'c'
			 	THEN 'Casa'
			 	  WHEN moradia.tipo_moradia = 'a'
			 	THEN 'Apartamento'
				ELSE NULL
			 	END
			 ) AS tipo_moradia,
			(CASE WHEN tipo_moradia = 'Casa'
				THEN casa.numero_casa
				ELSE apartamento.numero_ap --Assumindo que toda moradia que não é uma casa, é um apartamento
				END
			) AS numero,
			apartamento.andar,
			apartamento.final, 
			veiculo.placa,
			veiculo.marca,
			veiculo.modelo--,
			--COALESCE(condominio_moradia.fk_id_condominio, edificio.fk_id_condominio) 
			--	AS final_fk_id_condominio --Auxiliar para nossa query abaixo

			FROM adm_condominio.pessoa AS pessoa

			--Dando JOIN na parte de moradia
			JOIN adm_condominio.moradia_pessoa AS moradia_pessoa
			  ON moradia_pessoa.fk_id_pessoa = pessoa.id_pessoa
			JOIN adm_condominio.moradia AS moradia
			  ON moradia.id_moradia = moradia_pessoa.fk_id_moradia
			 --Temos LEFT JOIN aqui, pois a pessoa só terá um deles
	   LEFT JOIN adm_condominio.casa AS casa
			  ON casa.fk_id_moradia = moradia.id_moradia
	   LEFT JOIN adm_condominio.apartamento AS apartamento
			  ON apartamento.fk_id_moradia = moradia.id_moradia

			  -- Bloco de JOINs para conseguirmos testar o condominio e a filial na qual ele pertence
			JOIN adm_condominio.condominio_moradia AS condominio_moradia
			  ON condominio_moradia.fk_id_moradia = moradia.id_moradia
			JOIN adm_condominio.condominio AS condominio
			  ON condominio.id_condominio  = condominio_moradia.fk_id_condominio
			JOIN adm_condominio.condominio_filial AS condominio_filial
			  ON condominio_filial.fk_id_condominio = condominio.id_condominio

			 -- Temos LEFT JOIN porque a pessoa pode não ter veiculo
	   LEFT JOIN adm_condominio.veiculo_moradia AS veiculo_moradia
			  ON veiculo_moradia.fk_id_moradia = moradia.id_moradia
	   LEFT JOIN adm_condominio.veiculo AS veiculo
			 ON veiculo.id_veiculo = veiculo_moradia.fk_id_veiculo

			-- LIMITADOR DE SEGURANÇA: vemos apenas a lista de pessoas ligada a essa filial 
			WHERE condominio_filial.fk_id_filial = 5