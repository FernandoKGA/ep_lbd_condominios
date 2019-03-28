-- Database: adm_condominio

-- DROP DATABASE adm_condominio;

-- criação de database só pode ser executada sem transação?

CREATE DATABASE adm_condominio
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- rodar dentro do Query Tools/Editor da Database

CREATE SCHEMA adm_condominio AUTHORIZATION postgres;
GRANT ALL ON SCHEMA adm_condominio TO postgres;

SET ROLE TO postgres;

-- enumeradores

CREATE TYPE tipo_assembleia AS ENUM('AGO','AGE');

-- entidades fortes

CREATE TABLE Endereco (
  id_endereco SERIAL NOT NULL PRIMARY KEY,
  estado VARCHAR(19) NOT NULL,
  cidade VARCHAR(30) NOT NULL,
  logradouro VARCHAR(100) NOT NULL,
  numero INT NOT NULL,
  cep INT NOT NULL,
  CONSTRAINT restricao_cep CHECK (cep < 100000000)
);

CREATE TABLE Administradora (
  cnpj INT NOT NULL PRIMARY KEY,
  nome_administradora VARCHAR(50) NOT NULL,
  fk_id_endereco_matriz INT NOT NULL REFERENCES Endereco(id_endereco),
  CONSTRAINT restricao_cnpj CHECK (cnpj < 100000000000000)
);

CREATE TABLE Filial (
  id_filial SERIAL NOT NULL PRIMARY KEY,
  nome_filial VARCHAR(50) NOT NULL,
  regiao VARCHAR(20) NOT NULL,
  fk_id_endereco INT NOT NULL REFERENCES Endereco(id_endereco),
  fk_id_administradora INT NOT NULL REFERENCES Administradora(cnpj)
);

CREATE TABLE Condominio (
  id_condominio SERIAL NOT NULL PRIMARY KEY,
  tipo_condominio CHAR(1) NOT NULL,
  fk_id_endereco INT NOT NULL REFERENCES Endereco(id_endereco)
);

CREATE TABLE Pessoa (
  cpf INT NOT NULL PRIMARY KEY,
  nome VARCHAR(40) NOT NULL,
  data_nascimento DATE NOT NULL,
  sexo CHAR(1) NOT NULL,
  CONSTRAINT restricao_cpf CHECK (cpf < 100000000000)
);

CREATE TABLE Veiculo (
  id_veiculo SERIAL NOT NULL PRIMARY KEY,
  placa CHAR(7) NOT NULL,
  cidade VARCHAR(30) NOT NULL,
  estado VARCHAR(19) NOT NULL,
  marca VARCHAR(20) NOT NULL,
  modelo VARCHAR(20) NOT NULL,
  cor VARCHAR(20) NOT NULL
);

CREATE TABLE Entrada_Saida (
  id_es SERIAL NOT NULL PRIMARY KEY,
  data_hora TIMESTAMP NOT NULL,
  acao VARCHAR(7) NOT NULL,
  tecnologia VARCHAR(10) NOT NULL
);

CREATE TABLE Edificio (
  id_edificio SERIAL NOT NULL PRIMARY KEY,
  nome_edificio VARCHAR(100) NOT NULL,
  bloco VARCHAR(10) NOT NULL,
  andares INT NOT NULL,
  qtd_finais INT NOT NULL
);

CREATE TABLE Moradia (
  id_moradia SERIAL NOT NULL PRIMARY KEY,
  tipo_moradia CHAR(1) NOT NULL
);

CREATE TABLE Login (
  id_usuario SERIAL NOT NULL PRIMARY KEY,
  usuario VARCHAR(30) NOT NULL,
  senha TEXT NOT NULL 
);

CREATE TABLE Documento (
  id_documento SERIAL NOT NULL PRIMARY KEY,
  nome_documento VARCHAR(150) NOT NULL,
  status_documento VARCHAR(20) NOT NULL,
  data TIMESTAMP NOT NULL,
  caminho_documento TEXT NOT NULL
);

-- entidades fracas

CREATE TABLE Espaco (
  fk_id_condominio INT NOT NULL REFERENCES Condominio,
  id_espaco SERIAL NOT NULL PRIMARY KEY,
  nome_espaco VARCHAR(30) NOT NULL,
  capacidade INT NOT NULL,
  reservavel BOOLEAN NOT NULL,
  CONSTRAINT restricao_capac CHECK (capacidade < 200)
);

CREATE TABLE Assembleia (
  fk_id_condominio INT NOT NULL REFERENCES Condominio(id_condominio),
  id_assembleia SERIAL NOT NULL,
  data DATE NOT NULL,
  -- separar em outra tabela?
  id_sindico INT NOT NULL REFERENCES Pessoa(cpf),
  id_subsindico INT NOT NULL REFERENCES Pessoa(cpf),
  id_conselheiro_1 INT NOT NULL REFERENCES Pessoa(cpf),
  id_conselheiro_2 INT NOT NULL REFERENCES Pessoa(cpf),
  id_conselheiro_3 INT NOT NULL REFERENCES Pessoa(cpf),
  --
  assunto VARCHAR(100) NOT NULL,
  tipo tipo_assembleia NOT NULL,
  PRIMARY KEY (fk_id_condominio, id_assembleia)
);

CREATE TABLE Apartamento (
  fk_id_moradia INT NOT NULL REFERENCES Moradia(id_moradia),
  id_apartamento SERIAL NOT NULL,
  andar INT NOT NULL,
  final INT NOT NULL,
  numero_ap INT NOT NULL,
  PRIMARY KEY (fk_id_moradia, id_apartamento)
);

CREATE TABLE Casa (
  fk_id_moradia INT NOT NULL REFERENCES Moradia(id_moradia),
  id_casa SERIAL NOT NULL,
  fk_id_endereco INT NOT NULL REFERENCES Endereco(id_endereco),
  PRIMARY KEY (fk_id_moradia,id_casa)
);

-- relacionamentos

CREATE TABLE Reserva (
  fk_id_pessoa INT NOT NULL REFERENCES Pessoa(cpf),
  fk_id_espaco INT NOT NULL REFERENCES Espaco(id_espaco),
  hora_inicial TIME NOT NULL,
  hora_final TIME NOT NULL,
  data DATE NOT NULL
);

CREATE TABLE Comparece (
  fk_id_pessoa INT NOT NULL REFERENCES Pessoa(cpf),
  fk_id_assembleia INT NOT NULL,
  fk_id_condominio INT NOT NULL,
  FOREIGN KEY (fk_id_assembleia, fk_id_condominio) REFERENCES Assembleia
);

CREATE TABLE Condominio_Filial (
  fk_id_filial INT NOT NULL REFERENCES Filial(id_filial),
  fk_id_condominio INT NOT NULL REFERENCES Condominio(id_condominio)
);

CREATE TABLE Condominio_Moradia (
  fk_id_condominio INT NOT NULL REFERENCES Condominio(id_condominio),
  fk_id_moradia INT NOT NULL REFERENCES Moradia(id_moradia)
);

CREATE TABLE Moradia_Pessoa (
  fk_id_moradia INT NOT NULL REFERENCES Moradia(id_moradia),
  fk_id_pessoa INT NOT NULL REFERENCES Pessoa(cpf)
);

CREATE TABLE Moradia_Edificio (
  fk_id_edificio INT NOT NULL REFERENCES Edificio(id_edificio),
  fk_id_moradia INT NOT NULL REFERENCES Moradia(id_moradia)
);

CREATE TABLE Es_Pessoa (
  fk_id_es INT NOT NULL REFERENCES Entrada_Saida(id_es),
  fk_id_pessoa INT NOT NULL REFERENCES Pessoa(cpf)
);

CREATE TABLE Es_Veiculo (
  fk_id_es INT NOT NULL REFERENCES Entrada_Saida(id_es),
  fk_id_veiculo INT NOT NULL REFERENCES Veiculo(id_veiculo)
);

CREATE TABLE Veiculo_Moradia (
  fk_id_veiculo INT NOT NULL REFERENCES Veiculo(id_veiculo),
  fk_id_moradia INT NOT NULL REFERENCES Moradia(id_moradia)
);

-- relacoes de documento e outros

CREATE TABLE Administradora_Documento (
  fk_cnpj INT NOT NULL REFERENCES Administradora(cnpj),
  fk_id_documento INT NOT NULL REFERENCES Documento(id_documento)  
);

CREATE TABLE Assembleia_Documento (
  fk_id_assembleia INT NOT NULL,
  fk_id_condominio INT NOT NULL,
  fk_id_documento INT NOT NULL REFERENCES Documento(id_documento),
  FOREIGN KEY (fk_id_assembleia, fk_id_condominio) REFERENCES Assembleia
);

CREATE TABLE Condominio_Documento (
  fk_id_condominio INT NOT NULL REFERENCES Condominio(id_condominio),
  fk_id_documento INT NOT NULL REFERENCES Documento(id_documento)
);