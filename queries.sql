-- QUERY 1
-- 

SELECT Pessoa.nome, 
		MAX(assembleia.data) AS ultima_assembleia
	FROM adm_condominio.Pessoa AS Pessoa
	JOIN adm_condominio.Corpo_Administrativo AS Corpo_Administrativo 
	  ON Pessoa.id_pessoa IN (Corpo_Administrativo.id_sindico, Corpo_Administrativo.id_subsindico,
							  Corpo_Administrativo.id_conselheiro_1, Corpo_Administrativo.id_conselheiro_2, 
							  Corpo_Administrativo.id_conselheiro_3)
	JOIN adm_condominio.Assembleia AS Assembleia 
	  ON Corpo_Administrativo.id_corpo = Assembleia.fk_id_corpo_admin
	WHERE data_eleicao <= CAST(NOW() AS DATE) - interval '2 years'
	GROUP BY 1;



-- QUERY 2
-- Listar as 5 pessoas e suas respectivas cidades com o maior número de ocorrências de entrada e saída

WITH sum_entradas AS (
		SELECT pessoa.id_pessoa AS id_pessoa, SUM(Entrada_Saida.data_hora)
		JOIN adm_condominio.Es_Pessoa AS Es_Pessoa ON Pessoa.id_pessoa = Es_Pessoa.fk_id_pessoa
		JOIN adm_condominio.Entrada_Saida AS Entrada_Saida ON Entrada_Saida.id_es = Es_Pessoa.fk_id_es
		WHERE Entrada_Saida.acao = 'e'
		GROUP BY 1
),

sum_saidas AS (
		SELECT pessoa.id_pessoa AS id_pessoa, SUM(Entrada_Saida.data_hora)
		JOIN adm_condominio.Es_Pessoa AS Es_Pessoa ON Pessoa.id_pessoa = Es_Pessoa.fk_id_pessoa
		JOIN adm_condominio.Entrada_Saida AS Entrada_Saida ON Entrada_Saida.id_es = Es_Pessoa.fk_id_es
		WHERE Entrada_Saida.acao = 's'
		GROUP BY 1
)

top_five AS (
	SELECT Pessoa.id_pessoa, SUM(sum_entradas.soma - sum_saidas.soma)
		FROM adm_condominio.Pessoa AS Pessoa
		JOIN sum_entradas AS sum_entradas.id_pessoa = Pessoa.id_pessoa
		JOIN sum_saidas AS sum_saidas.id_pessoa = Pessoa.id_pessoa
		GROUP BY 1 ORDER BY 2 DESC
		LIMIT 5
)

SELECT Pessoa.nome, Endereco.cidade
	FROM adm_condominio.Pessoa AS Pessoa
	JOIN adm_condominio.Moradia_Pessoa AS Moradia_Pessoa 
	  ON Moradia_Pessoa.fk_id_pessoa = Pessoa.id_pessoa
	JOIN adm_condominio.Moradia AS Moradia
	  ON Moradia.id_moradia = Moradia_Pessoa.fk_id_moradia
	JOIN adm_condominio.Condominio AS Condominio
	  ON Condominio.id_condominio = Moradia.fk_id_condominio
	JOIN adm_condominio.Endereco AS Endereco
	  ON Endereco.id_endereco = Condominio.fk_id_endereco
	JOIN top_five
	  ON top_five.id_pessoa = Pessoa.id_pessoa