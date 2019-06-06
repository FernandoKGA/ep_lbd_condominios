-- ((nome, tipo condominio),id_endereco)
INSERT INTO adm_condominio.TipoCondominio(condominio,fk_id_endereco) 
VALUES
(('Ed. Molina','e'),31),
(('Ass. Rodrigues','a'),32),
(('Ed. Gomes','e'),33),
(('Ass. Mercadores','a'),34),
(('Ed. Carlos','e'),35),
(('Ed. Samuel','e'),36),
(('Ass. Juventos','a'),37),
(('Ass. Domingues','a'),38),
(('Ed. Jax','e'),39),
(('Ed. Simpar','e'),40);

-- pessoa(cpf,nome,data_nasciment,sexo)
-- (((cpf,nome,data_nascimento,sexo),funcao,horario_entrada,horario_saida),fk_id_endereco),
INSERT INTO adm_condominio.TipoFuncionario(funcionario,fk_id_condominio)
VALUES
((('1133344488','João da Silva','15-04-1975','M'),'Zelador','08:00','17:00'),1),
((('2354233841','Rodrigues Lopes','03-06-1969','M'),'Porteiro','21:00','06:00'),2),
((('4233021304','James Logrado','03-12-1987','M'),'Faxineiro','10:00','18:00'),3)
--(,4),
--(,5),
--(,6),
--(,7),
--(,8),
--(,9),
--(,10)
