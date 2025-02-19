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

















-- 3. Criar um Trigger para Atualizar Contagem de Softwares em Cada Máquina: Criar um
-- AFTER INSERT trigger que atualiza uma tabela auxiliar Maquina Software Count que
-- armazena a quantidade de softwares instalados em cada máquina.

-- 4. Criar um Trigger para Evitar Remoção de Usuários do Setor de Tl: Objetivo: Impedir a
-- remoção de usuários cuja Especialidade seja 'TI'.

-- 5. Criar um Trigger para Calcular o Uso Total de Memória por Máquina: Criar um AFTER
-- INSERT e AFTER DELETE trigger que calcula a quantidade total de memória RAM ocupada
-- pelos softwares em cada máquina.

-- 6. Criar um Trigger para Registrar Alterações de Especialidade em Usuários: Criar um
-- trigger que registre as mudanças de especialidade dos usuários na tabela Usuarios.

-- 7. Criar um Trigger para Impedir Exclusão de Softwares Essenciais: Criar um BEFORE
-- DELETE trigger que impeça a exclusão de softwares considerados essenciais (ex:
-- Windows).