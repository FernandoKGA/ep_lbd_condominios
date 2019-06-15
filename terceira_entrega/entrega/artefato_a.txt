----------- CREATES -------------

SET SCHEMA 'adm_condominio';

CREATE TYPE adm_condominio.TPessoa AS
(
	cpf varchar(11),
	nome varchar(40),
	data_nascimento date,
	sexo char(1)
);

CREATE TYPE adm_condominio.TCondominio AS
(
	nome_condominio varchar(40),
	tipo_condominio char(1)
);

CREATE TYPE adm_condominio.TFuncionario AS
(
	pessoa TPessoa,
	funcao varchar(40),
	horario_entrada time,
	horario_saida time
);

CREATE TABLE adm_condominio.TipoCondominio
(
	id_condominio serial not null primary key,
	condominio TCondominio,
	fk_id_endereco int not null references adm_condominio.Endereco(id_endereco)
);

CREATE TABLE adm_condominio.TipoFuncionario
(
	id_funcionario serial not null primary key,
	funcionario TFuncionario,
	fk_id_condominio int not null references adm_condominio.TipoCondominio(id_condominio)
);

--------- INSERTS -------------

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

----------- SELECTS -----------

SELECT * FROM adm_condominio.tipofuncionario;

SELECT * from adm_condominio.tipocondominio;