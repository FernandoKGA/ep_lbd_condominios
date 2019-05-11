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

-- rodar dentro do Query Tools da Database

CREATE SCHEMA adm_condominio AUTHORIZATION postgres;
GRANT ALL ON SCHEMA adm_condominio TO postgres;

SET ROLE TO postgres;

-- mudando de schema

SET search_path TO adm_condominio;

-- enumeradores

CREATE TYPE tipo_assembleia AS ENUM('AGO','AGE');