CREATE TABLE Usuarios (
    ID_Usuario INT PRIMARY KEY NOT NULL,
    Password VARCHAR(255),
    Nome_Usuario VARCHAR(255),
    Ramal INT,
    Especialidade VARCHAR(255)
);

CREATE TABLE Maquina (
    Id_Maquina INT PRIMARY KEY NOT NULL,
    Tipo VARCHAR(255),
    Velocidade INT,
    HardDisk INT,
    Placa_Rede INT,
    Memoria_Ram INT,
    Fk_Usuario INT,
    FOREIGN KEY (Fk_Usuario) REFERENCES Usuarios(ID_Usuario) ON DELETE CASCADE
);

CREATE TABLE Software (
    Id_Software INT PRIMARY KEY NOT NULL,
    Produto VARCHAR(255),
    HardDisk INT,
    Memoria_Ram INT,
    Fk_Maquina INT,
    FOREIGN KEY (Fk_Maquina) REFERENCES Maquina(Id_Maquina) ON DELETE CASCADE
);

insert into Maquina values (1, 'Desktop', 2, 500, 1, 4, 1);
insert into Maquina values (2, 'Notebook', 1, 250, 1, 2, 2);
insert into Maquina values (3, 'Desktop', 3, 1000, 1, 8, 3);
insert into Maquina values (4, 'Notebook', 2, 500, 1, 4, 4);
insert into Usuarios values (1, '123', 'Joao', 123, 'TI');
insert into Usuarios values (2, '456', 'Maria', 456, 'RH');
insert into Usuarios values (3, '789', 'Jose', 789, 'Financeiro');
insert into Usuarios values (4, '101', 'Ana', 101, 'TI');
insert into Software values (1, 'Windows', 100, 2, 1);
insert into Software values (2, 'Linux', 50, 1, 2);
insert into Software values (3, 'Windows', 200, 4, 3);
insert into Software values (4, 'Linux', 100, 2, 4);
insert into Software values (5, 'Linux', 100, 2, 4);

CREATE TABLE LOG_Maquina (
    ID SERIAL PRIMARY KEY,
    Maquina_ID INTEGER,
    ACAO VARCHAR(20),
    DATA TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Define a data e hora atuais automaticamente
);

-- 1. Criar um Trigger para Auditoria de Exclusão de Máquinas: Criar um trigger que
-- registre quando um registro da tabela Maquina for excluído.
CREATE OR REPLACE FUNCTION DELETE_LOG()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO LOG_Maquina(Maquina_ID, ACAO) VALUES ( NEW.ID_MAQUINA, 'DELETE');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER DELETE_LOG
AFTER DELETE ON MAQUINA
FOR EACH ROW
EXECUTE FUNCTION DELETE_LOG();

DELETE FROM MAQUINA WHERE ID_MAQUINA = 1;
SELECT * FROM log_maquina;

-- 2. Criar um Trigger para Evitar Senhas Fracas: Criar um BEFORE INSERT trigger para
-- impedir que um usuário seja cadastrado com uma senha menor que 6 caracteres.
CREATE OR REPLACE FUNCTION verificar_senha()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.Password) < 6 THEN
        RAISE EXCEPTION 'A senha deve ter pelo menos 6 caracteres';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_senha
BEFORE INSERT ON usuarios
FOR EACH ROW
EXECUTE FUNCTION verificar_senha();
    
insert into Usuarios values (7, '45A6', 'Maria', 456, 'RH');

-- 3. Criar um Trigger para Atualizar Contagem de Softwares em Cada Máquina: Criar um
-- AFTER INSERT trigger que atualiza uma tabela auxiliar Maquina Software Count que
-- armazena a quantidade de softwares instalados em cada máquina.
CREATE TABLE MAQUINA_SOFTWARE(
    ID SERIAL PRIMARY KEY,
    FK_MAQUINA INTEGER NOT NULL UNIQUE,
    QTD_SOFTWARE INTEGER DEFAULT 0,
    FOREIGN KEY (FK_MAQUINA) REFERENCES MAQUINA(Id_Maquina) ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION atualizar_contagem_software()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO MAQUINA_SOFTWARE (FK_MAQUINA, QTD_SOFTWARE)
    VALUES (NEW.FK_MAQUINA, (SELECT COUNT(*) FROM SOFTWARE WHERE FK_MAQUINA = NEW.FK_MAQUINA))
    ON CONFLICT (FK_MAQUINA)
    DO UPDATE SET QTD_SOFTWARE = EXCLUDED.QTD_SOFTWARE;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER after_insert_atualizar_contagem
AFTER INSERT ON SOFTWARE
FOR EACH ROW
EXECUTE FUNCTION atualizar_contagem_software();

SELECT * FROM MAQUINA_SOFTWARE;

-- 4. Criar um Trigger para Evitar Remoção de Usuários do Setor de Tl: Objetivo: Impedir a
-- remoção de usuários cuja Especialidade seja 'TI'.
CREATE OR REPLACE FUNCTION IMPEDIR_TI()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Especialidade = 'TI' THEN
        RAISE EXCEPTION 'Não é permitido excluir usuários do setor de TI';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER IMPEDIR_TI
BEFORE DELETE ON USUARIOS
FOR EACH ROW
EXECUTE FUNCTION IMPEDIR_TI();

DELETE FROM USUARIOS WHERE ID_Usuario = 1;

-- 5. Criar um Trigger para Calcular o Uso Total de Memória por Máquina: Criar um AFTER
-- INSERT e AFTER DELETE trigger que calcula a quantidade total de memória RAM ocupada
-- pelos softwares em cada máquina.
CREATE TABLE RAM_USADA(
    ID SERIAL PRIMARY KEY,
    FK_MAQUINA INTEGER NOT NULL UNIQUE,
    RAM_USADA INTEGER DEFAULT 0,
    FOREIGN KEY (FK_MAQUINA) REFERENCES MAQUINA(Id_Maquina) ON DELETE CASCADE
);
CREATE OR REPLACE FUNCTION CALCULAR_RAM()
RETURNS TRIGGER AS $$
DECLARE RAMS INTEGER;
BEGIN
    SELECT COALESCE(SUM(S.Memoria_Ram), 0) INTO RAMS
    FROM SOFTWARE S
    WHERE S.FK_MAQUINA = NEW.FK_MAQUINA;

    INSERT INTO RAM_USADA (FK_MAQUINA, RAM_USADA)
    VALUES (NEW.FK_MAQUINA, RAMS)
    ON CONFLICT (FK_MAQUINA) 
    DO UPDATE SET RAM_USADA = EXCLUDED.RAM_USADA;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER CALCULAR_RAM
AFTER DELETE OR INSERT OR UPDATE ON SOFTWARE
FOR EACH ROW
EXECUTE FUNCTION CALCULAR_RAM();

insert into Software values (7, 'Linux', 100, 2, 4);
SELECT * FROM ram_usada

-- 6. Criar um Trigger para Registrar Alterações de Especialidade em Usuários: Criar um
-- trigger que registre as mudanças de especialidade dos usuários na tabela Usuarios.
CREATE TABLE Log_Especialidade (
    ID SERIAL PRIMARY KEY,
    Usuario_ID INT NOT NULL,
    Especialidade_Antiga VARCHAR(255),
    Especialidade_Nova VARCHAR(255),
    Data_Alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Usuario_ID) REFERENCES Usuarios(ID_Usuario) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION registrar_alteracao_especialidade()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Especialidade IS DISTINCT FROM NEW.Especialidade THEN
        INSERT INTO Log_Especialidade (Usuario_ID, Especialidade_Antiga, Especialidade_Nova)
        VALUES (OLD.ID_Usuario, OLD.Especialidade, NEW.Especialidade);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_especialidade
AFTER UPDATE ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION registrar_alteracao_especialidade();
UPDATE USUARIOS SET ESPECIALIDADE = 'TESTE' WHERE ID_USUARIO = 2;
SELECT * FROM log_especialidade;

-- 7. Criar um Trigger para Impedir Exclusão de Softwares Essenciais: Criar um BEFORE
-- DELETE trigger que impeça a exclusão de softwares considerados essenciais (ex:
-- Windows).
CREATE OR REPLACE FUNCTION impedir_exclusao()
RETURNS TRIGGER AS $$
BEGIN
    -- Impedir exclusão se o software for essencial
    IF OLD.Produto ILIKE 'WINDOWS' THEN
        RAISE EXCEPTION 'Não é permitido excluir softwares essenciais como Windows';
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER impedir_exclusao
BEFORE DELETE ON Software
FOR EACH ROW
EXECUTE FUNCTION impedir_exclusao();


DELETE FROM SOFTWARE WHERE Id_Software = 3;