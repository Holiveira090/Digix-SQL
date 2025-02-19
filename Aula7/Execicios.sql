CREATE TABLE Maquina (
Id_Maquina INT PRIMARY KEY NOT NULL,
Tipo VARCHAR(255),
Velocidade INT,
HardDisk INT,
Placa_Rede INT,
Memoria_Ram INT,
Fk_Usuario INT,
FOREIGN KEY(Fk_Usuario) REFERENCES Usuarios(ID_Usuario)
);
CREATE TABLE Usuarios (
ID_Usuario INT PRIMARY KEY NOT NULL,
Password VARCHAR(255),
Nome_Usuario VARCHAR(255),
Ramal INT,
Especialidade VARCHAR(255)
);
CREATE TABLE Software (
Id_Software INT PRIMARY KEY NOT NULL,
Produto VARCHAR(255),
HardDisk INT,
Memoria_Ram INT,
Fk_Maquina INT,
FOREIGN KEY(Fk_Maquina) REFERENCES Maquina(Id_Maquina)
);
insert into Maquina values (1, 'Desktop', 2, 500, 1, 4, 1);
insert into Maquina values (2, 'Notebook', 1, 250, 1, 2, 2);
insert into Maquina values (3, 'Desktop', 3, 1000, 1, 8, 3);
insert into Maquina values (4, 'Notebook', 2, 500, 1, 4, 4);
insert into Maquina values (5, 'DESKTOP', 2, 500, 1, 4, 5);
insert into Maquina values (6, 'DESKTOP', 2, 500, 1, 4, 1);
insert into Usuarios values (1, '123', 'Joao', 123, 'TI');
insert into Usuarios values (2, '456', 'Maria', 456, 'RH');
insert into Usuarios values (3, '789', 'Jose', 789, 'Financeiro');
insert into Usuarios values (4, '101', 'Ana', 101, 'TI');
insert into Usuarios values (5, '102', 'KLEBER', 102, 'TI');
insert into Software values (1, 'Windows', 100, 2, 1);
insert into Software values (2, 'Linux', 50, 1, 2);
insert into Software values (3, 'Windows', 200, 4, 3);
insert into Software values (4, 'Linux', 100, 2, 4);
insert into Software values (5, 'Linux', 1000, 2, 5);
insert into Software values (6, 'Linux', 10000, 2, 1);
insert into Software values (7, 'Linux', 100000, 2, 1);


-- 1. Crie uma função chamada Espaco_Disponivel que recebe o ID da máquina e
-- retorna TRUE se houver espaço suficiente para instalar um software.
CREATE OR REPLACE FUNCTION Espaco_Disponivel(ID INTEGER) RETURNS BOOLEAN AS $$
DECLARE
    Total_HardDisk INTEGER;
    Uso_HardDisk INTEGER;
BEGIN
    -- Obtém o tamanho total do HD da máquina
    SELECT HardDisk INTO Total_HardDisk
    FROM MAQUINA
    WHERE Id_Maquina = ID;

    -- Obtém o espaço já utilizado pelos softwares instalados (ou 0 se não houver software)
    SELECT COALESCE(SUM(HardDisk), 0) INTO Uso_HardDisk
    FROM Software
    WHERE Fk_Maquina = ID;

    -- Verifica se há espaço disponível
    RETURN Total_HardDisk > Uso_HardDisk;
END;
$$ LANGUAGE PLPGSQL;


SELECT espaco_disponivel(3);


-- 2. Crie uma procedure Instalar_Software que só instala um software se houver
-- espaço disponível.
CREATE OR REPLACE PROCEDURE Instalar_Software(
    p_Id_Software INTEGER,
    p_Produto VARCHAR(255),
    p_HardDisk INTEGER,
    p_Memoria_Ram INTEGER,
    p_Fk_Maquina INTEGER
) AS $$
DECLARE
    Total_HardDisk INTEGER;
    Uso_HardDisk INTEGER;
BEGIN
    -- Obtém o tamanho total do HD da máquina
    SELECT HardDisk INTO Total_HardDisk
    FROM Maquina
    WHERE Id_Maquina = p_Fk_Maquina;

    -- Obtém o espaço já utilizado pelos softwares instalados
    SELECT COALESCE(SUM(HardDisk), 0) INTO Uso_HardDisk
    FROM Software
    WHERE Fk_Maquina = p_Fk_Maquina;

    -- Verifica se há espaço disponível
    IF (Total_HardDisk - Uso_HardDisk) >= p_HardDisk THEN
        INSERT INTO Software (Id_Software, Produto, HardDisk, Memoria_Ram, Fk_Maquina)
        VALUES (p_Id_Software, p_Produto, p_HardDisk, p_Memoria_Ram, p_Fk_Maquina);
    ELSE
        RAISE EXCEPTION 'Espaço insuficiente para instalar o software.';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CALL Instalar_Software(6, 'Photoshop', 200, 4, 1);

-- 3. Crie uma função chamada Maquinas_Do_Usuario que retorna uma lista de
-- máquinas associadas a um usuário.
CREATE OR REPLACE FUNCTION Maquinas_Do_Usuario(ID INTEGER) 
RETURNS TABLE(Id_Maquina INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT M.Id_Maquina
    FROM maquina M
    WHERE M.fk_usuario = ID;
END;
$$ LANGUAGE PLPGSQL;

SELECT Maquinas_Do_Usuario(1);

-- 4. Crie uma procedure Atualizar_Recursos_Maquina que aumenta a memória RAM e
-- o espaço em disco de uma máquina específica.
CREATE OR REPLACE PROCEDURE Atualizar_Recursos_Maquina(
    IDM INTEGER,
    NRAM INTEGER,
    NHARD INTEGER
) AS $$
BEGIN
    UPDATE maquina SET harddisk = NHARD, memoria_ram = NRAM WHERE id_maquina = IDM;
END;
$$ LANGUAGE PLPGSQL;

CALL Atualizar_Recursos_Maquina(1, 32, 4000);

-- 5. Crie uma procedure chamada Transferir_Software que transfere um software de
-- uma máquina para outra. Antes de transferir, a procedure deve verificar se a
-- máquina de destino tem espaço suficiente para o software.
CREATE OR REPLACE PROCEDURE Transferir_Software(
    IdSoftware INTEGER,
    IdOrigem INTEGER,
    IdDestino INTEGER
) 
AS $$
DECLARE
    EspacoNecessario INTEGER;
    EspacoDisponivelDestino BOOLEAN;
BEGIN
    -- Obtém o espaço necessário para o software
    SELECT HardDisk INTO EspacoNecessario
    FROM Software
    WHERE Id_Software = IdSoftware AND Fk_Maquina = IdOrigem;

    -- Verifica se a máquina de destino tem espaço suficiente
    EspacoDisponivelDestino := Espaco_Disponivel(IdDestino);

    IF EspacoDisponivelDestino THEN
        -- Atualiza o software para a nova máquina
        UPDATE Software
        SET Fk_Maquina = IdDestino
        WHERE Id_Software = IdSoftware;

        RAISE NOTICE 'Software % transferido da máquina % para a máquina %', IdSoftware, IdOrigem, IdDestino;
    ELSE
        RAISE EXCEPTION 'Espaço insuficiente na máquina de destino';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CALL Transferir_Software(2, 2, 1);
SELECT * FROM software;

-- 6. Crie uma função Media_Recursos que retorna a média de Memória RAM e
-- HardDisk de todas as máquinas cadastradas.
CREATE OR REPLACE FUNCTION Media_Recursos () RETURNS INT AS $$
DECLARE
    TOTAL_RAM INTEGER := 0;
    QTD_MAQUINAS INTEGER := 0;
BEGIN
    -- Obtém a quantidade de máquinas e a soma da memória RAM
    SELECT COUNT(ID_MAQUINA), COALESCE(SUM(Memoria_Ram), 0) 
    INTO QTD_MAQUINAS, TOTAL_RAM
    FROM maquina;

    -- Evita divisão por zero
    IF QTD_MAQUINAS = 0 THEN
        RETURN 0;
    ELSE
        RETURN TOTAL_RAM / QTD_MAQUINAS;
    END IF;
END;
$$ LANGUAGE PLPGSQL;

SELECT media_recursos();

-- 7. Crie uma procedure chamada Diagnostico_Maquina que faz uma avaliação
-- completa de uma maquina e sugere um upgrade se os recursos dela nao forem
-- suficientes para rodar os softwares instalados.
CREATE OR REPLACE FUNCTION Diagnostico_Maquina (IDM INTEGER) RETURNS VARCHAR AS $$
DECLARE
    MEMORIA_M INTEGER;
    MEMORIA_S INTEGER;
BEGIN
    SELECT M.HARDDISK, COALESCE(SUM(S.HARDDISK), 0)
    INTO MEMORIA_M, MEMORIA_S
    FROM maquina M
    JOIN software S ON M.id_maquina = S.Fk_Maquina
    WHERE M.id_maquina = IDM
    GROUP BY m.harddisk;

    IF MEMORIA_M IS NULL OR MEMORIA_S IS NULL THEN
        RETURN 'MÁQUINA OU SOFTWARE NÃO ENCONTRADOS';
    END IF;

    IF MEMORIA_S > MEMORIA_M THEN
        RETURN 'PRECISA DE UPGRADE';
    ELSE
        RETURN 'NÃO PRECISA DE UPGRADE';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

SELECT Diagnostico_Maquina (1)
