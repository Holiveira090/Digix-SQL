CREATE TABLE time (
id INTEGER PRIMARY KEY,
nome VARCHAR(50)
);
CREATE TABLE partida (
id INTEGER PRIMARY KEY,
time_1 INTEGER,
time_2 INTEGER,
time_1_gols INTEGER,
time_2_gols INTEGER,
FOREIGN KEY(time_1) REFERENCES time(id),
FOREIGN KEY(time_2) REFERENCES time(id)
);
INSERT INTO time(id, nome) VALUES
(1,'CORINTHIANS'),
(2,'SÃO PAULO'),
(3,'CRUZEIRO'),
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');
INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES
(1,4,1,0,4),
(2,3,2,0,1),
(3,1,3,3,0),
(4,3,4,0,1),
(5,1,2,0,0),
(6,2,4,2,2),
(7,1,5,1,2),
(8,5,2,1,2);

-- Tabela Temporaria: elas são para dados temporarios, e que são de unica sessão de banco de dados

CREATE TEMP TABLE TEMP_TIME AS SELECT * FROM TIME;

SELECT * FROM TEMP_TIME;

-- TRUNCATE APAGA OS DADOS MAS NÃO A TABELA
TRUNCATE TABLE TEMP_TIME;

