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





-- CRIANDO PROCEDURE NO POSTGRESSLQ
CREATE OR REPLACE PROCEDURE INSERIR_PARTIDA(
    ID INTEGER,
    TIME_1 INTEGER, 
    TIME_2 INTEGER, 
    TIME_1_GOLS INTEGER, 
    TIME_2_GOLS INTEGER
) AS $$
BEGIN
    INSERT INTO PARTIDA(ID, TIME_1, TIME_2, TIME_1_GOLS, TIME_2_GOLS)
    VALUES (ID, TIME_1, TIME_2, TIME_1_GOLS, TIME_2_GOLS);
END;
$$ LANGUAGE PLPGSQL;


-- EXECUTANDO PROCEDURE
CALL INSERIR_PARTIDA(9, 1, 2, 2, 1);

-- PROCEDURE UPDATE
CREATE OR REPLACE PROCEDURE ALTERAR_NOME_TIME(
    IDT INTEGER,
    NOME_OUTRO VARCHAR(50)
) AS $$
BEGIN
    UPDATE TIME SET NOME = NOME_OUTRO WHERE ID = IDT;
    IF NOT FOUND ID THEN
        RAISE EXCEPTION 'TIME NÃO ENCONTRADO';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CALL ALTERAR_NOME_TIME(1, 'TESTE');

-- EXCLUIR PARTIDA COM EXCEÇÃO CASO NÃO ENCONTRE
CREATE OR REPLACE PROCEDURE EXCLUIR_PARTIDA(
    IDP INTEGER
) AS $$
BEGIN
    DELETE FROM PARTIDA WHERE ID = IDP;
    IF NOT FOUND ID THEN
        RAISE EXCEPTION 'PARTIDA NÃO ENCONTRADA';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CALL EXCLUIR_PARTIDA(3);

SELECT * from partida;


