-- o condomino ja reservou algum espaco naquele dia
INSERT INTO adm_condominio.reserva VALUES (67,62,'12:00:00','18:00:00','2019-05-11');

-- a duracao da reserva ultrapassa 6h
INSERT INTO adm_condominio.reserva VALUES (67,3,'12:00:00','19:00:00','2019-05-11');

-- o horario final excede o horario de silencio (22h)
INSERT INTO adm_condominio.reserva VALUES (67,4,'18:00:00','22:30:00','2019-05-12');
