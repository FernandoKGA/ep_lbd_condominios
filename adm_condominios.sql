-- Database: adm_condominio

-- DROP DATABASE adm_condominio;

CREATE DATABASE adm_condominio
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- entidades fortes

CREATE TABLE "Endereco" (
  "id_endereco" INT NOT NULL PRIMARY KEY SERIAL,
  "estado" VARCHAR(19) NOT NULL,
  "cidade" VARCHAR(30) NOT NULL,
  "logradouro" VARCHAR(100) NOT NULL,
  "numero" INT NOT NULL,
  "cep" INT(8) NOT NULL
);

CREATE TABLE "Administradora" (
  "id_adm" INT NOT NULL PRIMARY KEY SERIAL,
  "nome_administradora" VARCHAR(50) NOT NULL,
  "cnpj" INT(14) NOT NULL,
  "fk_id_endereco_matriz" INT NOT NULL REFERENCES Endereco (id_endereco)
);

CREATE TABLE "Filial" (
  "id_filial" INT NOT NULL PRIMARY KEY SERIAL,
  "nome_filial" VARCHAR(50) NOT NULL,
  "regiao" VARCHAR(20) NOT NULL,
  "fk_id_endereco" INT NOT NULL REFERENCES Endereco (id_endereco)
  "fk_id_administradora" INT NOT NULL REFERENCES Administradora (id_adm)
);

CREATE TABLE "Condominio" (
  "id_condominio" INT NOT NULL PRIMARY KEY SERIAL,
  "tipo_condominio" CHAR(1) NOT NULL,
  "fk_id_endereco" INT NOT NULL REFERENCES Endereco (id_endereco)
);

CREATE TABLE "Pessoa" (
  "cpf" INT(11) NOT NULL PRIMARY KEY,
  "nome" VARCHAR(40) NOT NULL,
  "data_nascimento" DATE NOT NULL,
  "sexo" CHAR(1) NOT NULL
);

CREATE TABLE "Veiculo" (
  "id_veiculo" INT NOT NULL PRIMARY KEY SERIAL,
  "placa" CHAR(7) NOT NULL,
  "cidade" VARCHAR(30) NOT NULL,
  "estado" VARCHAR(19) NOT NULL,
  "marca" VARCHAR(20) NOT NULL,
  "modelo" VARCHAR(20) NOT NULL,
  "cor" VARCHAR(20) NOT NULL
);

CREATE TABLE "Entrada_Saida" (
  "id_es" INT NOT NULL PRIMARY KEY SERIAL,
  "data_hora" TIMESTAMP NOT NULL,
  "acao" VARCHAR(7) NOT NULL,
  "tecnologia" VARCHAR(10) NOT NULL
);

CREATE TABLE "Edificio" (
  "id_edificio" INT NOT NULL PRIMARY KEY SERIAL,
  "nome_edificio" VARCHAR(100) NOT NULL,
  "bloco" CHAR() NOT NULL,
  "andares" INT NOT NULL,
  "qtd_finais" INT NOT NULL,
  "fk_id_condominio" INT FOREIGN KEY REFERENCES Condominio(id_condominio),
);

CREATE TABLE "Moradia" (
  "id_moradia" INT NOT NULL PRIMARY KEY SERIAL,
  "tipo_moradia" CHAR(1) NOT NULL
);

CREATE TABLE "Login" (
  "id_usuario" INT NOT NULL PRIMARY KEY SERIAL 
  "usuario" NOT NULL VARCHAR(30),
  "senha" NOT NULL TEXT
);

CREATE TABLE "Documento" (
  "id_documento" INT NOT NULL PRIMARY KEY SERIAL,
  "nome_documento" VARCHAR(150) NOT NULL,
  "status_documento" VARCHAR(20) NOT NULL,
  "data" NOT NULL TIMESTAMP,
  "caminho_documento" TEXT
);

-- entidades fracas

CREATE TABLE "Espaco" (
  "fk_id_condominio" FOREIGN KEY REFERENCES Condominio(id_condominio)
  "id_espaco" INT NOT NULL PRIMARY KEY SERIAL,
  "nome_epaco" VARCHAR(30) NOT NULL,
  "capacidade" INT(2),
  "reservavel" BOOLEAN NOT NULL,
);

CREATE TABLE "Assembleia" (
  "id_assembleia" <type>,
  "data" <type>,
  "id_sindico" <type>,
  "id_subsindico" <type>,
  "id_conselheiro_1" <type>,
  "id_conselheiro_2" <type>,
  "id_conselheiro_3" <type>,
  "assunto" <type>,
  "tipo" <type>
);

CREATE TABLE "Apartamento" (
  "id_apartamento" <type>,
  "andar" <type>,
  "final" <type>,
  "numero_ap" <type>
);

CREATE TABLE "Casa" (
  "id_casa" <type>,
  "area" <type>,
  "valor_imovel" <type>,
  "n_quartos" <type>,
  "bloco" <type>,
  "numero" <type>
);

-- relacionamentos

CREATE TABLE "Reserva" (
  "fk_id_pessoa" <type>,
  "fk_id_espaco" <type>,
  "hora_inicial" <type>,
  "hora_final" <type>,
  "data" <type>
);

CREATE TABLE "Comparece" (
  "fk_id_pessoa" <type>,
  "fk_id_assembleia" <type>
);

CREATE TABLE "Es_Veiculo" (
  "fk_id_es" <type>,
  "fk_id_veiculo" <type>
);

CREATE TABLE "Moradia_Pessoa" (
  "fk_id_moradia" <type>,
  "fk_id_pessoa" <type>
);

CREATE TABLE "Condominio_Filial" (
  "fk_id_filial" <type>,
  "fk_id_condominio" <type>
);

CREATE TABLE "Apartamento_Edificio" (
  "fk_id_edificio" <type>,
  "fk_id_apartamento" <type>
);

CREATE TABLE "Es_Pessoa" (
  "fk_id_es" <type>,
  "fk_id_pessoa" <type>
);

CREATE TABLE "Veiculo_Apartamento" (
  "fk_id_veiculo" <type>,
  "fk_id_apartamento" <type>
);

CREATE TABLE "Veiculo_Casa" (
  "fk_id_veiculo" <type>,
  "fk_id_casa" <type>
);

-- remover ligações de edificio com apartamento, e remover ligação de veiculo com casa, veiculo com apartamento
-- e ligar  veiculo com Moradia, assim como ligar edificio com Moradia
