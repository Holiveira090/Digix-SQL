CREATE TABLE INSTRUTOR (
    IDINSTRUTOR INT PRIMARY KEY NOT NULL,
    RG INT,
    NOME VARCHAR(45),
    NASCIMENTO DATE,
    TITULACAO INT
);

CREATE TABLE TELEFONE_INSTRUTOR (
    IDTELEFONE INT PRIMARY KEY NOT NULL,
    NUMERO INT,
    TIPO VARCHAR(45),
    INSTRUTOR_IDINSTRUTOR INT NOT NULL,
    CONSTRAINT FK_IDINSTRUTOR FOREIGN KEY (INSTRUTOR_IDINSTRUTOR) REFERENCES INSTRUTOR(IDINSTRUTOR)
);

CREATE TABLE ATIVIDADE (
    IDATIVIDADE INT PRIMARY KEY NOT NULL,
    NOME VARCHAR(100)
);

CREATE TABLE TURMA (
    IDTURMA INT PRIMARY KEY NOT NULL,
    HORARIO TIME,
    DURACAO INT,
    DATAINICIO DATE,
    DATAFIM DATE,
    ATIVIDADE_IDATIVIDADE INT NOT NULL,
    INSTRUTOR_IDINSTRUTOR INT NOT NULL,
    CONSTRAINT FK_IDATIVIDADE FOREIGN KEY (ATIVIDADE_IDATIVIDADE) REFERENCES ATIVIDADE(IDATIVIDADE),
    CONSTRAINT FK_IDINSTRUTOR FOREIGN KEY (INSTRUTOR_IDINSTRUTOR) REFERENCES INSTRUTOR(IDINSTRUTOR)
);
ALTER TABLE turma
ADD NOME VARCHAR(45)

CREATE TABLE ALUNO (
    CODMATRICULA INT PRIMARY KEY NOT NULL,
    TURMA_IDTURMA INT NOT NULL,
    DATAMATRICULA DATE,
    NOME VARCHAR(45),
    ENDERECO TEXT,
    TELEFONE INT,
    DATANASCIMENTO DATE,
    ALTURA FLOAT,
    PESO INT,
    CONSTRAINT FK_IDTURMA FOREIGN KEY (TURMA_IDTURMA) REFERENCES TURMA(IDTURMA)
);

CREATE TABLE CHAMADA (
    IDCHAMADA INT PRIMARY KEY NOT NULL,
    DATA DATE,
    PRESENTE BOOLEAN,
    ALUNO_CODMATRICULA INT NOT NULL,
    TURMA_IDTURMA INT NOT NULL,
    CONSTRAINT FK_CODMATRICULA FOREIGN KEY (ALUNO_CODMATRICULA) REFERENCES ALUNO(CODMATRICULA),
    CONSTRAINT FK_IDTURMA FOREIGN KEY (TURMA_IDTURMA) REFERENCES TURMA(IDTURMA)
);

-- Inserindo dados na tabela INSTRUTOR
INSERT INTO INSTRUTOR (IDINSTRUTOR, RG, NOME, NASCIMENTO, TITULACAO) VALUES
(1, 12345678, 'Carlos Silva', '1980-05-10', 3),
(2, 23456789, 'Ana Souza', '1985-08-15', 4),
(3, 34567890, 'Marcos Lima', '1990-02-20', 2),
(4, 45678901, 'Fernanda Alves', '1978-11-25', 5),
(5, 56789012, 'Roberto Dias', '1982-07-30', 3),
(6, 56789012, 'KAUE', '1982-07-30', 3);

-- Inserindo dados na tabela TELEFONE_INSTRUTOR
INSERT INTO TELEFONE_INSTRUTOR (IDTELEFONE, NUMERO, TIPO, INSTRUTOR_IDINSTRUTOR) VALUES
(1, 1, 'Celular', 1),
(2, 2, 'Residencial', 2),
(3, 3, 'Celular', 3),
(4, 4, 'Comercial', 4),
(5, 5, 'Celular', 5);

-- Inserindo dados na tabela ATIVIDADE
INSERT INTO ATIVIDADE (IDATIVIDADE, NOME) VALUES
(1, 'Musculação'),
(2, 'Yoga'),
(3, 'Pilates'),
(4, 'Spinning'),
(5, 'Crossfit');

-- Inserindo dados na tabela TURMA
INSERT INTO TURMA (IDTURMA, HORARIO, DURACAO, DATAINICIO, DATAFIM, ATIVIDADE_IDATIVIDADE, INSTRUTOR_IDINSTRUTOR, NOME) VALUES
(1, '08:00:00', 60, '2024-01-10', '2024-06-10', 1, 1, 'Musculação Matutina'),
(2, '10:00:00', 45, '2024-02-15', '2024-07-15', 2, 2, 'Yoga Relax'),
(3, '18:00:00', 50, '2024-03-20', '2024-08-20', 3, 3, 'Pilates Avançado'),
(4, '19:30:00', 55, '2024-04-25', '2024-09-25', 4, 4, 'Spinning Noturno'),
(5, '20:00:00', 60, '2024-05-30', '2024-10-30', 5, 5, 'Crossfit Intenso');

-- Inserindo dados na tabela ALUNO
INSERT INTO ALUNO (CODMATRICULA, TURMA_IDTURMA, DATAMATRICULA, NOME, ENDERECO, TELEFONE, DATANASCIMENTO, ALTURA, PESO) VALUES
(1, 1, '2024-01-12', 'João Pereira', 'Rua A, 123', 12, '1995-06-15', 1.75, 70),
(2, 2, '2024-02-18', 'Maria Oliveira', 'Rua B, 456', 34, '1992-08-22', 1.65, 60),
(3, 3, '2024-03-22', 'Pedro Santos', 'Rua C, 789', 56, '1988-05-10', 1.80, 80),
(4, 4, '2024-04-28', 'Ana Clara', 'Rua D, 101', 78, '2000-02-14', 1.60, 55),
(5, 5, '2024-05-30', 'Lucas Ferreira', 'Rua E, 202', 91, '1997-11-30', 1.78, 75)
(6, 5, '2024-02-10', 'JOSE', 'Rua F, 303', 11, '1996-10-20', 1.78, 75),
(7, 5, '2024-01-12', 'GUILHERME', 'Rua G, 123', 123, '1995-06-15', 1.75, 70),
(8, 5, '2024-01-12', 'WILL', 'Rua H, 1243', 123, '1995-06-15', 1.75, 70);


-- Inserindo dados na tabela CHAMADA
INSERT INTO CHAMADA (IDCHAMADA, DATA, PRESENTE, ALUNO_CODMATRICULA, TURMA_IDTURMA) VALUES
(1, '2024-01-15', TRUE, 1, 1),
(2, '2024-02-20', FALSE, 2, 2),
(3, '2024-03-25', TRUE, 3, 3),
(4, '2024-04-30', TRUE, 4, 4),
(5, '2024-05-05', FALSE, 5, 5);

-- 1 Listar todos os alunos e os nomes das turmas em que estão matriculados
SELECT A.NOME AS ALUNO, T.NOME AS TURMA
FROM TURMA T
JOIN aluno A ON idturma = turma_idturma;

-- 2 Contar quantos alunos estão matriculados em cada turma
SELECT T.NOME AS TURMAS, COUNT(A.codmatricula) AS QTD_ALUNOS
FROM turma T
JOIN aluno A ON T.idturma = A.turma_idturma
GROUP BY T.NOME;

-- 3 Mostrar a média de idade dos alunos em cada turma JUSTIFY_INTERVAL()
SELECT NOME, ROUND(AVG(EXTRACT(YEAR FROM AGE (CURRENT_DATE, DATANASCIMENTO))), 2) AS idade
FROM aluno GROUP BY NOME;

-- 4 Encontrar as turmas com mais de 3️ alunos matriculados
SELECT T.NOME AS TURMAS, COUNT(A.codmatricula) AS QTD_ALUNOS
FROM turma T
JOIN aluno A ON T.idturma = A.turma_idturma
GROUP BY T.nome
HAVING COUNT(A.CODMATRICULA) > 3;

-- 5 Exibir os instrutores que orientam turmas e os que ainda não possuem turmas
SELECT I.NOME AS INSTRUTOR, T.NOME AS TURMA
FROM instrutor I
LEFT JOIN turma T ON T.instrutor_idinstrutor = I.idinstrutor;


-- 6 Encontrar alunos que frequentaram todas as aulas de sua turma
SELECT A.NOME AS ALUNO, T.idturma AS TURMA
FROM ALUNO A
JOIN chamada C ON A.codmatricula = C.aluno_codmatricula
JOIN TURMA T ON C.turma_idturma = T.idturma
GROUP BY A.codmatricula, T.idturma
HAVING COUNT(CASE WHEN C.presente = TRUE THEN 1 END) =
(SELECT COUNT(*) FROM CHAMADA C2 WHERE C2.TURMA_IDTURMA = T.IDTURMA)

-- 7 Mostrar os instrutores que ministram turmas de "Crossfit" ou "Yoga"
SELECT I.NOME AS INSTRUTOR, T.NOME AS TURMA
FROM instrutor I
JOIN turma T ON I.idinstrutor = T.instrutor_idinstrutor
WHERE T.nome = 'Crossfit Intenso' OR T.nome = 'Yoga Relax';

-- 8 Listar os alunos que estão matriculados em mais de uma turma
SELECT A.NOME AS ALUNO, COUNT(T.idturma)
FROM aluno A
JOIN turma T ON A.turma_idturma = T.idturma
GROUP BY ALUNO
HAVING COUNT(T.idturma) > 1

-- 9 Encontrar as turmas que possuem a maior quantidade de alunos
SELECT T.NOME AS TURMAS, COUNT(A.TURMA_IDTURMA) AS QTD_ALUNOS
FROM TURMA T
JOIN ALUNO A ON T.IDTURMA = A.TURMA_IDTURMA
GROUP BY T.NOME
ORDER BY COUNT(A.TURMA_IDTURMA)DESC
LIMIT 3;

-- 10 Listar os alunos que não compareceram a nenhuma aula
-- FFFFFFFFFFFFFFFFFFFFFF
SELECT A.NOME AS ALUNOS, C.PRESENTE AS PRESENCA
FROM ALUNO A
JOIN CHAMADA C ON A.CODMATRICULA = C.ALUNO_CODMATRICULA
WHERE C.PRESENTE = FALSE;