-- entidades fortes

CREATE TABLE adm_condominio.Endereco (
  id_endereco SERIAL NOT NULL PRIMARY KEY,
  estado VARCHAR(50) NOT NULL,
  cidade VARCHAR(255) NOT NULL,
  logradouro VARCHAR(255) NOT NULL,
  numero INT NOT NULL,
  cep INT NOT NULL,
  CONSTRAINT restricao_cep CHECK (cep < 100000000)
);

CREATE TABLE adm_condominio.Administradora (
  id_administradora SERIAL NOT NULL,
	cnpj VARCHAR(14) NOT NULL,
	nome_administradora VARCHAR(50) NOT NULL,
	fk_id_endereco_matriz INT NOT NULL REFERENCES adm_condominio.Endereco(id_endereco),
	CONSTRAINT pk_administradora PRIMARY KEY (id_administradora)
);

CREATE TABLE adm_condominio.Filial (
  id_filial SERIAL NOT NULL PRIMARY KEY,
  nome_filial VARCHAR(50) NOT NULL,
  regiao VARCHAR(20) NOT NULL,
  fk_id_endereco INT NOT NULL REFERENCES adm_condominio.Endereco(id_endereco),
  fk_id_administradora INT NOT NULL REFERENCES adm_condominio.Administradora(id_administradora)
);

-- A = associação e E = edificio
CREATE TABLE adm_condominio.Condominio (
  id_condominio SERIAL NOT NULL PRIMARY KEY,
  tipo_condominio CHAR(1) NOT NULL,
  fk_id_endereco INT NOT NULL REFERENCES adm_condominio.Endereco(id_endereco)
);

CREATE TABLE adm_condominio.Pessoa (
  id_pessoa SERIAL NOT NULL PRIMARY KEY,
  cpf VARCHAR(11) NOT NULL,
  nome VARCHAR(40) NOT NULL,
  data_nascimento DATE NOT NULL,
  sexo CHAR(1) NOT NULL
);

CREATE TABLE adm_condominio.Veiculo (
  id_veiculo SERIAL NOT NULL PRIMARY KEY,
  placa CHAR(7) NOT NULL,
  cidade VARCHAR(30) NOT NULL,
  estado VARCHAR(19) NOT NULL,
  marca VARCHAR(20) NOT NULL,
  modelo VARCHAR(20) NOT NULL,
  cor VARCHAR(20) NOT NULL
);

-- "E" para entrada; "S" para saída
CREATE TABLE adm_condominio.Entrada_Saida (
  id_es SERIAL NOT NULL PRIMARY KEY,
  data_hora TIMESTAMP NOT NULL,
  acao CHAR(1) NOT NULL,
  tecnologia VARCHAR(50) NOT NULL
);

CREATE TABLE adm_condominio.Edificio (
  id_edificio SERIAL NOT NULL PRIMARY KEY,
  nome_edificio VARCHAR(255) NOT NULL,
  bloco VARCHAR(10) NOT NULL,
  andares INT NOT NULL,
  qtd_finais INT NOT NULL,
  fk_id_condominio INT NOT NULL REFERENCES adm_condominio.Condominio(id_condominio)
);

-- "c" para casa e "a" para apartamento
CREATE TABLE adm_condominio.Moradia (
  id_moradia SERIAL NOT NULL PRIMARY KEY,
  tipo_moradia CHAR(1) NOT NULL
);

CREATE TABLE adm_condominio.Login (
  id_usuario SERIAL NOT NULL PRIMARY KEY,
  usuario VARCHAR(30) NOT NULL,
  senha TEXT NOT NULL 
);

CREATE TABLE adm_condominio.Documento (
  id_documento SERIAL NOT NULL PRIMARY KEY,
  nome_documento VARCHAR(150) NOT NULL,
  status_documento VARCHAR(20) NOT NULL, -- Quantos? Quais? (1 - Aprovado, 2 - Recusado, 3 - Em Aprovação, 4 - Em Processamento, 5 - Não Disponível)
  data TIMESTAMP NOT NULL,
  caminho_documento TEXT NOT NULL
);

-- entidades fracas

CREATE TABLE adm_condominio.Espaco (
  fk_id_condominio INT NOT NULL REFERENCES adm_condominio.Condominio(id_condominio),
  id_espaco SERIAL NOT NULL UNIQUE,
  nome_espaco VARCHAR(30) NOT NULL,
  capacidade INT NOT NULL,
  reservavel BOOLEAN NOT NULL,
  CONSTRAINT restricao_capac CHECK (capacidade < 200),
  PRIMARY KEY (fk_id_condominio, id_espaco)
);

CREATE TABLE adm_condominio.Assembleia (
  fk_id_condominio INT NOT NULL REFERENCES adm_condominio.Condominio(id_condominio),
  id_assembleia SERIAL NOT NULL,
  data DATE NOT NULL,
  -- separar em outra tabela?
  id_sindico INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  id_subsindico INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  id_conselheiro_1 INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  id_conselheiro_2 INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  id_conselheiro_3 INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  -- tabela corpo administrativo
  assunto VARCHAR(100) NOT NULL,
  tipo tipo_assembleia NOT NULL,
  PRIMARY KEY (fk_id_condominio, id_assembleia)
);

CREATE TABLE adm_condominio.Apartamento (
  fk_id_moradia INT NOT NULL REFERENCES adm_condominio.Moradia(id_moradia),  
  andar INT NOT NULL,
  final INT NOT NULL,
  numero_ap INT NOT NULL,
  PRIMARY KEY (fk_id_moradia)
);

CREATE TABLE adm_condominio.Casa (
  fk_id_moradia INT NOT NULL REFERENCES adm_condominio.Moradia(id_moradia),
  numero_casa INT NOT NULL,
  PRIMARY KEY (fk_id_moradia)
);

-- relacionamentos

CREATE TABLE adm_condominio.Reserva (
  fk_id_pessoa INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  fk_id_espaco INT NOT NULL REFERENCES adm_condominio.Espaco(id_espaco),
  hora_inicial TIME NOT NULL,
  hora_final TIME NOT NULL,
  data DATE NOT NULL
);

CREATE TABLE adm_condominio.Comparece (
  fk_id_pessoa INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa),
  fk_id_assembleia INT NOT NULL,
  fk_id_condominio INT NOT NULL,
  FOREIGN KEY (fk_id_assembleia, fk_id_condominio) REFERENCES adm_condominio.Assembleia
);

CREATE TABLE adm_condominio.Condominio_Filial (
  fk_id_filial INT NOT NULL REFERENCES adm_condominio.Filial(id_filial),
  fk_id_condominio INT NOT NULL REFERENCES adm_condominio.Condominio(id_condominio)
);

CREATE TABLE adm_condominio.Condominio_Moradia (
  fk_id_condominio INT NOT NULL REFERENCES adm_condominio.Condominio(id_condominio),
  fk_id_moradia INT NOT NULL REFERENCES adm_condominio.Moradia(id_moradia)
);

CREATE TABLE adm_condominio.Moradia_Pessoa (
  fk_id_moradia INT NOT NULL REFERENCES adm_condominio.Moradia(id_moradia),
  fk_id_pessoa INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa)
);

CREATE TABLE adm_condominio.Moradia_Edificio (
  fk_id_edificio INT NOT NULL REFERENCES adm_condominio.Edificio(id_edificio),
  fk_id_moradia INT NOT NULL REFERENCES adm_condominio.Moradia(id_moradia)
);

CREATE TABLE adm_condominio.Es_Pessoa (
  fk_id_es INT NOT NULL REFERENCES adm_condominio.Entrada_Saida(id_es),
  fk_id_pessoa INT NOT NULL REFERENCES adm_condominio.Pessoa(id_pessoa)
);

CREATE TABLE adm_condominio.Es_Veiculo (
  fk_id_es INT NOT NULL REFERENCES adm_condominio.Entrada_Saida(id_es),
  fk_id_veiculo INT NOT NULL REFERENCES adm_condominio.Veiculo(id_veiculo)
);

CREATE TABLE adm_condominio.Veiculo_Moradia (
  fk_id_veiculo INT NOT NULL REFERENCES adm_condominio.Veiculo(id_veiculo),
  fk_id_moradia INT NOT NULL REFERENCES adm_condominio.Moradia(id_moradia)
);

-- relacoes de documento e outros

CREATE TABLE adm_condominio.Administradora_Documento (
  fk_cnpj INT NOT NULL REFERENCES adm_condominio.Administradora(id_administradora),
  fk_id_documento INT NOT NULL REFERENCES adm_condominio.Documento(id_documento)  
);

CREATE TABLE adm_condominio.Assembleia_Documento (
  fk_id_assembleia INT NOT NULL,
  fk_id_condominio INT NOT NULL,
  fk_id_documento INT NOT NULL REFERENCES adm_condominio.Documento(id_documento),
  FOREIGN KEY (fk_id_assembleia, fk_id_condominio) REFERENCES adm_condominio.Assembleia
);

CREATE TABLE adm_condominio.Condominio_Documento (
  fk_id_condominio INT NOT NULL REFERENCES adm_condominio.Condominio(id_condominio),
  fk_id_documento INT NOT NULL REFERENCES adm_condominio.Documento(id_documento)
);