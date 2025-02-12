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

-- 1. Crie uma view vpartida que retorne a tabela de partida adicionando as colunas nome_time_1 e nome_time 2 com o nome dos times.
CREATE OR REPLACE VIEW vpartida as
SELECT 
    p.id, 
    p.time_1, 
    t1.nome AS nome_time_1, 
    p.time_2, 
    t2.nome AS nome_time_2, 
    p.time_1_gols, 
    p.time_2_gols
FROM partida p
JOIN time t1 ON p.time_1 = t1.id
JOIN time t2 ON p.time_2 = t2.id
ORDER BY P.ID ASC

-- 2. Realize uma consulta em vpartida que retorne somente os jogos times que possuem nome que comecam com A ou C participaram.
SELECT * 
FROM vpartida 
WHERE nome_time_1 LIKE 'A%' 
   OR nome_time_1 LIKE 'C%' 
   AND nome_time_2 LIKE 'A%' 
   OR nome_time_2 LIKE 'C%'
   order by nome_time_1, nome_time_2

-- 3. Crie uma view, utilizando a view vpartida que retorne uma coluna de classificação com o nome do ganhador da partida, ou a palavra 'EMPATE' em caso de empate.
CREATE OR REPLACE VIEW vclassificacao AS
SELECT 
    id,
    time_1, 
    nome_time_1, 
    time_2, 
    nome_time_2, 
    time_1_gols, 
    time_2_gols,
    CASE 
        WHEN time_1_gols > time_2_gols THEN nome_time_1
        WHEN time_1_gols < time_2_gols THEN nome_time_2
        ELSE 'EMPATE'
    END AS vencedor
FROM vpartida
order by vencedor desc

-- 4. Crie uma view vtime que retorne a tabela de time adicionando as colunas partidas, vitorias, derrotas, empates e pontos.
CREATE OR REPLACE VIEW vtime AS
SELECT 
    t.id, 
    t.nome, 
    COALESCE(SUM(p.partidas), 0) AS partidas,
    COALESCE(SUM(p.vitorias), 0) AS vitorias,
    COALESCE(SUM(p.derrotas), 0) AS derrotas,
    COALESCE(SUM(p.empates), 0) AS empates,
    COALESCE(SUM(p.vitorias) * 3 + SUM(p.empates), 0) AS pontos
FROM time t
LEFT JOIN (
    SELECT 
        time_1 AS time_id,
        COUNT(*) AS partidas,
        SUM(CASE WHEN time_1_gols > time_2_gols THEN 1 ELSE 0 END) AS vitorias,
        SUM(CASE WHEN time_1_gols < time_2_gols THEN 1 ELSE 0 END) AS derrotas,
        SUM(CASE WHEN time_1_gols = time_2_gols THEN 1 ELSE 0 END) AS empates
    FROM partida
    GROUP BY time_1

    UNION ALL

    SELECT 
        time_2 AS time_id,
        COUNT(*) AS partidas,
        SUM(CASE WHEN time_2_gols > time_1_gols THEN 1 ELSE 0 END) AS vitorias,
        SUM(CASE WHEN time_2_gols < time_1_gols THEN 1 ELSE 0 END) AS derrotas,
        SUM(CASE WHEN time_2_gols = time_1_gols THEN 1 ELSE 0 END) AS empates
    FROM partida
    GROUP BY time_2
) p ON t.id = p.time_id
GROUP BY t.id, t.nome
order by pontos desc;

-- Outra maneira da 4:
CREATE OR REPLACE VIEW VTIME AS
SELECT T.ID, T.NOME,

-- PARTIDAS
(SELECT COUNT(*) FROM PARTIDA WHERE TIME_1 = T.ID) +
(SELECT COUNT(*) FROM PARTIDA WHERE TIME_2 = T.ID) AS PARTIDAS,

-- VITORIAS
(SELECT SUM(CASE WHEN time_2_gols > time_1_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_2 = T.ID) +
(SELECT SUM(CASE WHEN time_1_gols > time_2_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_1 = T.ID) AS VITORIAS,

-- EMPATES
(SELECT SUM(CASE WHEN time_2_gols = time_1_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_2 = T.ID) +
(SELECT SUM(CASE WHEN time_1_gols = time_2_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_1 = T.ID) AS EMPATES,

-- DERROTAS
(SELECT SUM(CASE WHEN time_2_gols < time_1_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_2 = T.ID) +
(SELECT SUM(CASE WHEN time_1_gols < time_2_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_1 = T.ID) AS DERROTAS,

-- PONTOS
(SELECT SUM(CASE WHEN time_2_gols > time_1_gols THEN 3 ELSE 0 END) FROM PARTIDA WHERE TIME_2 = T.ID) +
(SELECT SUM(CASE WHEN time_1_gols > time_2_gols THEN 3 ELSE 0 END) FROM PARTIDA WHERE TIME_1 = T.ID) +
(SELECT SUM(CASE WHEN time_1_gols = time_2_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_1 = T.ID) +
(SELECT SUM(CASE WHEN time_1_gols = time_2_gols THEN 1 ELSE 0 END) FROM PARTIDA WHERE TIME_2 = T.ID) AS PONTOS

FROM TIME T
ORDER BY PONTOS DESC;



-- 5. Realize uma consulta na view vpartida_classificacao
SELECT * FROM vclassificacao;
-- 6. Apague a view vpartida.
DROP VIEW vclassificacao;
DROP VIEW vpartida;
