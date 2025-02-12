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

-- Função
-- Funções: são blocos de codigo que podem ser chamados para executar uma tarefa especifica.
-- As funções aceitam parametros.
-- As funções podem ser definidas pelo usuario ou podem ser chamadas as funções embutidas
-- Funções são as que estão disponiveis no banco de dados
-- são 3 tipos de funções: Matematicas, as Datas e as de String



-- Funções Matematicas
-- Exemplos:
SELECT ABS(-10); -- ELA RETORNA O VALOR ABSOLUTO DO NUMERO
SELECT ROUND(10.5); -- ELE ARREDONDA PARA O NUMERO INTEIRO MAIS PROXIMO
SELECT TRUNC(12.73543); -- ELE PEGA SOMENTE A PARTE INTEIRA DO NUMERO (SOMENTE NO POSTGRES)
SELECT POWER(2, 3); -- RETORNA OS VALORES EXPONENCIAIS DELIMITADOS
SELECT LN(4); -- RETORNA O LOGARITIMO NATURAL DO NUMERO
SELECT COS(30); -- RETORNA O COSSENO DO ANGULO RADIANO
SELECT ATAN(0.5); -- RETORNA O ARCO DA TANGENTE
SELECT ASINH(0.5); -- RETORNA O ARCO DO SENO HIPERBOLICO (POSTGRES)
SELECT SIGN(50); -- RETORNA O SINAL DO NUMERO



-- FUNÇÕES EMBUTIDAS DE MANIPULAÇÃO DE STRING
SELECT CONCAT('AFASF', 'FAS'); -- VAI CONCATENAR AS 2 STRINGS
SELECT LENGTH('ASDASF'); -- RETORNA O COMPRIMENTO
SELECT LOWER('GSD'); -- DEIXA TUDO MINUSCULO
SELECT UPPER('GSD'); -- DEIXA TUDO MAIUSCULO
SELECT LTRIM(' EGADG'); -- EXCLUI OS ESPAÇOS DA ESQUERDA
SELECT RTRIM('EGADG '); -- EXCLUI OS ESPAÇOS DA DIREITA
SELECT LPAD('EGEGE', 10, '*'); -- PREENCHE UM STRING COM AS CARACTERES APRESENTADAS PARA ESQUERDA
SELECT RPAD('EGEGE', 10, '*'); -- PREENCHE UM STRING COM AS CARACTERES APRESENTADAS PARA DIREITA
SELECT REVERSE('FAFWAD'); -- INVERTE



-- FUNÇÕES DA DATA
SELECT CURRENT_DATE; -- SELECIONA A DATA DO PC
SELECT EXTRACT(YEAR FROM CURRENT_DATE); -- PEGA SOMENTE O ANO
SELECT EXTRACT(DAY FROM CURRENT_DATE); -- PEGA SOMENTE O DIA
SELECT AGE('02-02-2025', '01-01-2025'); -- MOSTRA A DIFERENÇA ENTRE DUAS DATAS
SELECT INTERVAL '1 DAY'; -- RETORNA O INTERVALO


-- FUNÇÕES DEFINIDA PELO USUARIO:

-- (POSTGRES)
CREATE FUNCTION SOMA(A INTEGER, B INTEGER) RETURNS INTEGER AS $$ -- VARIAVEL, TIPO E O RETORNO
BEGIN -- COMEÇO A FUNÇÃO
    -- CORPO DA FUNÇÃO
    RETURN A + B;
END;
$$ LANGUAGE PLPGSQL


-- (MYSQL)
CREATE FUNCTION SOMA(A INTEGER, B INTEGER) RETURNS INTEGER AS -- VARIAVEL, TIPO E O RETORNO
DETERMINISTIC -- É UMA CLAUSULA OPCIONAL
BEGIN -- COMEÇO A FUNÇÃO
    -- CORPO DA FUNÇÃO
    RETURN A + B;
END;

-- CHAMAR A FUNÇÃO
SELECT SOMA(10, 20);

-- OPERAÇÃO DE INSERT NAS FUNÇÕES
CREATE OR REPLACE FUNCTION INSERE_PARTIDA (ID INTEGER,TIME_1 INTEGER, TIME_2 INTEGER, time_1_gols INTEGER, time_2_gols INTEGER) RETURNS VOID AS $$
BEGIN
    INSERT INTO PARTIDA(ID, time_1, time_2, time_1_gols, time_2_gols) VALUES (ID, time_1, time_2, time_1_gols, time_2_gols);
END;
$$ LANGUAGE PLPGSQL

-- CHAMANDO
SELECT INSERE_PARTIDA(10,1,2,1,2);

-- FUNÇÃO DE CONSULTA
CREATE OR REPLACE FUNCTION CONSULTA_TIME() RETURNS SETOF TIME AS $$ -- SETOF INDICA QUE A FUNÇÃO RETORNA UM CONJUNTO DE REGISTROS
BEGIN
    RETURN QUERY SELECT * FROM TIME;
END;
$$ LANGUAGE PLPGSQL

-- CHAMANDO
SELECT * FROM CONSULTA_TIME();



-- FUNÇÃO COM VARIAVEL INTERNA
CREATE OR REPLACE FUNCTION CONSULTA_VENCEDOR_POR_TIME(ID_TIME INTEGER) RETURNS VARCHAR(50) AS $$
DECLARE
    vencedor VARCHAR(50);
BEGIN
    SELECT CASE
        WHEN time_1_gols > time_2_gols THEN(SELECT NOME FROM TIME WHERE ID = TIME_1)
        WHEN time_1_gols < time_2_gols THEN(SELECT NOME FROM TIME WHERE ID = TIME_2)
        ELSE 'EMPATE'
        END INTO vencedor
        FROM PARTIDA
        WHERE TIME_1 = ID_TIME OR TIME_2 = ID_TIME;
        RETURN vencedor;
END;
$$ LANGUAGE PLPGSQL
