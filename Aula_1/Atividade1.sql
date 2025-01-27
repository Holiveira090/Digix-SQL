CREATE TABLE atividade1.aluno (
    id_aluno INTEGER PRIMARY KEY NOT NULL,
    des_nome VARCHAR(255),
    num_grau INTEGER
);

CREATE TABLE atividade1.curtida (
    fk_id_aluno1 INTEGER NOT NULL,
    fk_id_aluno2 INTEGER NOT NULL,
    CONSTRAINT fk_curtida_aluno1 FOREIGN KEY (fk_id_aluno1) REFERENCES atividade1.aluno(id_aluno),
    CONSTRAINT fk_curtida_aluno2 FOREIGN KEY (fk_id_aluno2) REFERENCES atividade1.aluno(id_aluno)
);

CREATE TABLE atividade1.amigo (
    fk_id_aluno1 INTEGER NOT NULL,
    fk_id_aluno2 INTEGER NOT NULL,
    CONSTRAINT fk_amigo_aluno1 FOREIGN KEY (fk_id_aluno1) REFERENCES atividade1.aluno(id_aluno),
    CONSTRAINT fk_amigo_aluno2 FOREIGN KEY (fk_id_aluno2) REFERENCES atividade1.aluno(id_aluno)
);

INSERT INTO atividade1.aluno VALUES (1, 'João', 1);
INSERT INTO atividade1.aluno VALUES (2, 'Maria', 1);
INSERT INTO atividade1.aluno VALUES (3, 'josé', 2);

INSERT INTO atividade1.curtida VALUES (1, 2);

INSERT INTO atividade1.amigo VALUES (1, 2);

SELECT * FROM atividade1.aluno;

SELECT * FROM atividade1.aluno LEFT JOIN atividade1.curtida ON aluno.id_aluno = curtida.fk_id_aluno1;
SELECT * FROM atividade1.aluno RIGHT JOIN atividade1.curtida ON aluno.id_aluno = curtida.fk_id_aluno1;
SELECT * FROM atividade1.aluno INNER JOIN atividade1.curtida ON aluno.id_aluno = curtida.fk_id_aluno1;
