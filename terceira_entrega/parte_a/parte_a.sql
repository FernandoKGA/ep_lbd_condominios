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

CREATE TABLE adm_condominio.TipoPessoas
(
	pessoa TPessoa
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