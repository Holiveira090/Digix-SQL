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
(5,1,2,0,0);

-- AS TRIGGERS SÃO GATILHOS AUTOMATICOS QUE SÃO EXECUTADOS ANTES OU DEPOIS DE UMA OPERAÇÃO DE INSERT, UPDATE OU DELETE

-- AS TRIGGRES SÃO MUITO UTILIZADAS PARA GARANTIR A INTEGRIDADE DOS DADOS

-- QUANDO AS TRIGGERS SÃO NECESSARIAS?
-- 1 - QUANDO É NECESSARIO GARANTIR A INTEGRIDADE DOS DADOS
-- 2 - QUANDO É NECESSARIO GARANTIR A CONSISTENCIA DOS DADOS
-- 3 - PARA VALIDAR REGRAS DE NEGOCIO ANTES DE INSERIR, ATUALIZAR OU DELETAR DADOS
-- 4 - PARA AUTOMATIZAR TAREFAS QUE DEVEM SER EXECUTADAS

-- PARA MOSTRAR COMO ACONTECE NAS AUDITORIAS, VOU FAZER UMA TABELA QUE REGISTRA OS EVENTEOS DAS OUTRAS TABELAS
CREATE TABLE LOG_PARTIDA (
    ID SERIAL PRIMARY KEY,
    PARTIDA_ID INTEGER,
    ACAO VARCHAR(20),
    DATA TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Define a data e hora atuais automaticamente
);


-- CRIAÇÃO DE TRIGGER COM SINTAXE MYSQL
CREATE TRIGGER LOG_PARTIDA_INSERT
AFTER INSERT ON PARTIDA -- AFTER QUER DIZER QUE ACONTECE DEPOIS DA OPERAÇÃO NAS TABELAS
FOR EACH ROW -- PARA CADA LINHA INSERIDA
BEGIN
    INSERT INTO LOG_PARTIDA_INSERT(PARTIDA_ID, ACAO) VALUES (NEW.ID, 'INSERT'); -- NEW ID É O ID DA LINHA QUE FOI INSERIDA
END;


-- NO POSTGRES
-- A GENTE VAI CRIAR A FUNÇÃO E DEPOIS A TRIGGER QUE CHAMA A FUNÇÃO

CREATE OR REPLACE FUNCTION LOG_PARTIDA_INSERT()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LOG_PARTIDA(PARTIDA_ID, ACAO) VALUES (NEW.ID, 'INSERT'); -- NEW ID É O ID DA LINHA QUE FOI INSERIDA
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER LOG_PARTIDA_INSERT
AFTER INSERT ON PARTIDA
FOR EACH ROW
EXECUTE FUNCTION LOG_PARTIDA_INSERT();



-- VAMOS TESTAR
INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES
(12,1,2,1,0);

SELECT * FROM log_partida;

-- CRIANDO TRIGGER DE RESTRIÇÃO (MYSQL)
CREATE TRIGGER INSERT_PARTIDA
BEFORE INSERT ON PARTIDA -- BEFORE QUER DIZER QUE ACONTECE ANTES DA OPERAÇÃO NAS TABELAS
FOR EACH ROW
BEGIN
    IF NEW.TIME_1 = NEW.TIME_2 THEN
    -- SIGNAL SQLSTATE É UMA FUNÇÃO QUE VAI GERAR UM ERRO
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NÃO É PERMITIDO JOGOS ENTRE O MESMO TIME';
    END IF;
END;

-- POSTGRES
CREATE OR REPLACE FUNCTION INSERT_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.TIME_1 = NEW.TIME_2 THEN
        raise EXCEPTION 'NÃO É PERMITIDO JOGOS ENTRE O MESMO TIME';
    END IF;
end;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER INSERT_PARTIDA
BEFORE INSERT ON PARTIDA
FOR EACH ROW
EXECUTE FUNCTION INSERT_PARTIDA();

-- TESTAR
INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES
(147,1,1,1,0);

-- EXMPLO DE INSTEAD OF NO POSTGRES QUE É O UNICO QUE SUPORTA
CREATE VIEW PARTIDAS_V AS
SELECT id, time_1, time_2, time_1_gols, time_2_gols FROM partida;

CREATE OR REPLACE FUNCTION INSERT_PARTIDA_V()
RETURNS TRIGGER AS $$
BEGIN
    -- Se o ID for autoincrementado, não deve ser incluído no INSERT
    INSERT INTO partida(time_1, time_2, time_1_gols, time_2_gols)
    VALUES (NEW.time_1, NEW.time_2, NEW.time_1_gols, NEW.time_2_gols);
    
    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER INSERT_PARTIDA_V
INSTEAD OF INSERT ON PARTIDAS_V
FOR EACH ROW
EXECUTE FUNCTION INSERT_PARTIDA_V();


-- TESTAR
INSERT INTO PARTIDAS_V(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES (111, 1, 2, 1, 0);


-- UPDATE
-- MYSQL
CREATE TRIGGER UPDATE_PARTIDA
AFTER UPDATE ON PARTIDA
FOR EACH ROW
BEGIN
    INSERT INTO LOG_PARTIDA(PARIDA_ID, ACAO) VALUES (NEW.ID, 'UPDATE');
END;

-- POSTGRESSQL
CREATE OR REPLACE FUNCTION UPDATE_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LOG_PARTIDA(PARIDA_ID, ACAO) VALUES (NEW.ID, 'UPDATE');
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER UPDATE_PARTIDA
AFTER UPDATE ON PARTIDA
FOR EACH ROW
EXECUTE FUNCTION UPDATE_PARTIDA();

-- TESTAR
UPDATE partida SET TIME_1_GOLS = 2 WHERE ID == 11;
SELECT * FROM log_partida;

-- FAZER UMA TRIGGER QUE IMPESSA DE FAZER UPDATE EM PARTIDAS QUE JA FORAM FINALIZADAS
CREATE OR REPLACE FUNCTION impedir_update_partida()
RETURNS TRIGGER AS $$
BEGIN
        RAISE EXCEPTION 'NÃO É POSSÍVEL FAZER UPDATE EM PARTIDAS FINALIZADAS';
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER IMPEDIR_UPDATE_PARTIDA
BEFORE UPDATE ON PARTIDA
FOR EACH ROW
EXECUTE FUNCTION IMPEDIR_UPDATE_PARTIDA();

UPDATE partida SET TIME_1_GOLS = NULL WHERE ID = 90;

-- DELETE
CREATE OR REPLACE FUNCTION DELETE_PARTIDA()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LOG_PARTIDA(PARTIDA_ID, ACAO) VALUES ( OLD.ID, 'DELETE');
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER DELETE_PARTIDA
BEFORE DELETE ON PARTIDA
FOR EACH ROW
EXECUTE FUNCTION DELETE_PARTIDA();

DELETE FROM PARTIDA WHERE ID = 1;

SELECT * FROM log_partida