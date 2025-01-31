CREATE TABLE software (
    ID_Software INTEGER PRIMARY KEY NOT NULL,
    Produto VARCHAR(50) NOT NULL,
    Hard_Disk VARCHAR(50) NOT NULL,
    Memoria_Ram VARCHAR(50) NOT NULL
);

CREATE TABLE usuario (
    ID_Usuario INTEGER PRIMARY KEY NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Nome_Usuario VARCHAR(50) NOT NULL,
    Ramal INTEGER,
    Especialidade VARCHAR(50)
);

CREATE TABLE maquina (
    ID_Maquina INTEGER PRIMARY KEY NOT NULL,
    Tipo VARCHAR(50) NOT NULL,
    Velocidade VARCHAR(50) NOT NULL,
    Hard_Disk VARCHAR(50) NOT NULL,
    Placa_Rede VARCHAR(50) NOT NULL,
    Memoria_Ram VARCHAR(50) NOT NULL,
    ID_Usuario INTEGER, 
    ID_Software INTEGER, 
    CONSTRAINT fk_id_usuario FOREIGN KEY (ID_Usuario) REFERENCES usuario(ID_Usuario),
    CONSTRAINT fk_id_software FOREIGN KEY (ID_Software) REFERENCES software(ID_Software)
);

ALTER TABLE software
ADD COLUMN ID_Maquina INTEGER,
ADD CONSTRAINT fk_id_maquina FOREIGN KEY (ID_Maquina) REFERENCES maquina(ID_Maquina);

ALTER TABLE usuario 
ADD COLUMN ID_Maquina INTEGER,
ADD CONSTRAINT fk_id_maquina FOREIGN KEY (ID_Maquina) REFERENCES maquina(ID_Maquina);

SELECT * FROM maquina, software, usuario;

INSERT INTO software (ID_Software, Produto, Hard_Disk, Memoria_Ram) VALUES
(1, 'Windows 10', '50GB', '4GB'),
(2, 'Linux Ubuntu', '20GB', '2GB'),
(3, 'Microsoft Office', '5GB', '2GB'),
(4, 'Adobe Photoshop', '10GB', '8GB'),
(5, 'Visual Studio Code', '500MB', '1GB');

INSERT INTO usuario (ID_Usuario, Password, Nome_Usuario, Ramal, Especialidade) VALUES
(1, 'senha123', 'João Silva', 1001, 'tecnico'),
(2, 'senha456', 'Maria Oliveira', 1002, 'Desenvolvimento'),
(3, 'senha789', 'Carlos Souza', 1003, 'Redes'),
(4, 'senha101', 'Ana Lima', 1004, 'Banco de Dados'),
(5, 'senha202', 'Fernando Costa', 1005, 'Segurança');

INSERT INTO maquina (ID_Maquina, Tipo, Velocidade, Hard_Disk, Placa_Rede, Memoria_Ram, ID_Usuario, ID_Software) VALUES
(1, 'Core II', '3.5GHz', '1TB', 'Intel Gigabit', '16GB', 1, 1),
(2, 'Pentium', '2.8GHz', '500GB', 'Realtek', '8GB', 2, 2),
(3, 'Servidor', '4.0GHz', '2TB', 'Broadcom', '32GB', 3, 3),
(4, 'Workstation', '3.2GHz', '1TB', 'Intel Gigabit', '16GB', 4, 4),
(5, 'Tablet', '2.0GHz', '128GB', 'Qualcomm', '4GB', 5, 5);

-- Atualizando as tabelas usuario, software e maquina
UPDATE usuario SET ID_Maquina = 1 WHERE ID_Usuario = 1;
UPDATE usuario SET ID_Maquina = 2 WHERE ID_Usuario = 2;
UPDATE usuario SET ID_Maquina = 3 WHERE ID_Usuario = 3;
UPDATE usuario SET ID_Maquina = 4 WHERE ID_Usuario = 4;
UPDATE usuario SET ID_Maquina = 5 WHERE ID_Usuario = 5;

UPDATE software SET ID_Maquina = 1 WHERE ID_Software = 1;
UPDATE software SET ID_Maquina = 2 WHERE ID_Software = 2;
UPDATE software SET ID_Maquina = 3 WHERE ID_Software = 3;
UPDATE software SET ID_Maquina = 4 WHERE ID_Software = 4;
UPDATE software SET ID_Maquina = 5 WHERE ID_Software = 5;

UPDATE maquina SET ID_Usuario = 1, ID_Software = 1 WHERE ID_Maquina = 1;
UPDATE maquina SET ID_Usuario = 2, ID_Software = 2 WHERE ID_Maquina = 2;
UPDATE maquina SET ID_Usuario = 3, ID_Software = 3 WHERE ID_Maquina = 3;
UPDATE maquina SET ID_Usuario = 4, ID_Software = 4 WHERE ID_Maquina = 4;
UPDATE maquina SET ID_Usuario = 5, ID_Software = 5 WHERE ID_Maquina = 5;

-- 1
SELECT * FROM usuario u WHERE u.Especialidade = 'tecnico';

-- 2
SELECT m.Tipo, m.Velocidade FROM maquina m;

-- 3
SELECT m.Tipo, m.Velocidade FROM maquina m WHERE Tipo = 'Core II' OR Tipo = 'Pentium';

-- 4
SELECT m.ID_Maquina, m.Tipo, m.Placa_Rede FROM maquina m WHERE Placa_Rede = 'Intel Gigabit';

-- 5
SELECT u.Nome_Usuario FROM usuario u WHERE ID_Maquina = 1 or ID_Maquina =2;

-- 6
SELECT m.ID_Maquina FROM maquina m where id_software = 3 or id_software = 4;

-- 7
SELECT m.ID_Maquina, m.memoria_ram, m.hard_disk  FROM maquina m WHERE id_maquina < 4;

-- 8
SELECT u.Nome_Usuario, m.Velocidade FROM maquina m, usuario u;

-- 9
SELECT u.Nome_Usuario, u.ID_Usuario FROM usuario u WHERE u.ID_Usuario < (SELECT ID_Usuario FROM usuario WHERE Nome_Usuario = 'Maria Oliveira');

-- 10
SELECT m.count FROM maquina m WHERE m.id_maquina BETWEEN 1 and 4;

-- 11
select u.count from usuario u inner join maquina m on u.ID_Usuario = u.id_maquina;

-- 12
SELECT m.Tipo, COUNT(u.ID_Usuario) AS quantidade_usuarios
FROM maquina m
INNER JOIN usuario u ON m.ID_Maquina = u.ID_Maquina
GROUP BY m.Tipo;

-- 13
SELECT m.tipo, Count(u.ID_Usuario) AS quantidade_usuarios
FROM maquina m
INNER JOIN usuario u ON m.Tipo = 'Core II'
GROUP BY m.Tipo;

-- 14
SELECT count(m.Hard_Disk) from maquina m;

-- 15
SELECT m.Hard_Disk from maquina m;