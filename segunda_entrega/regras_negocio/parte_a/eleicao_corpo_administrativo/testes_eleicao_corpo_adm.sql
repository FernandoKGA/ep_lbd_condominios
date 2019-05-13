-- nao deixa inserir pq subsindico ja foi eleito 2 vezes
INSERT INTO adm_condominio.corpo_administrativo
(id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3, data_eleicao) 
VALUES (8,17,31,32,44,'2032-05-12');

-- nao deixa inserir pq o corpo ja foi eleito naquele ano
INSERT INTO adm_condominio.corpo_administrativo
(id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3, data_eleicao) 
VALUES (8,17,31,32,44,'2030-05-12');

-- nao deixa inserir pq a data de eleicao eh anterior ao ano atual
INSERT INTO adm_condominio.corpo_administrativo
(id_sindico, id_subsindico, id_conselheiro_1, id_conselheiro_2, id_conselheiro_3, data_eleicao) 
VALUES (8,17,31,32,44,'2018-05-12');