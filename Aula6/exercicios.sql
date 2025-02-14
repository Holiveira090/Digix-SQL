create table Empregado (
    Nome varchar(50),
    Endereco varchar(500),
    CPF int primary key not null,
    DataNasc date,
    Sexo char(10),
    CartTrab int,
    Salario float,
    NumDep int,
    CPFSup int
    foreign key (NumDep) references Departamento(NumDep)
);

create table Departamento (
    NomeDep varchar(50),
    NumDep int primary key not null,
    CPFGer int,
    DataInicioGer date,
    foreign key (CPFGer) references Empregado(CPF)
);

create table Projeto (
    NomeProj varchar(50),
    NumProj int primary key not null,
    Localizacao varchar(50),
    NumDep int,
    foreign key (NumDep) references Departamento(NumDep)
);
create table Dependente (
    idDependente int primary key not null,
    CPFE int,
    NomeDep varchar(50),
    Sexo char(10),
    Parentesco varchar(50),
    foreign key (CPFE) references Empregado(CPF)
);
create table Trabalha_Em (
    CPF int,
    NumProj int,
    HorasSemana int,
    foreign key (CPF) references Empregado(CPF),
    foreign key (NumProj) references Projeto(NumProj)
);
-- Inserir os dados
insert into Departamento
values ('Dep1', 1, null, '1990-01-01');
insert into Departamento
values ('Dep2', 2, null, '1990-01-01');
insert into Departamento
values ('Dep3', 3, null, '1990-01-01');
insert into Empregado
values (
        'Joao',
        'Rua 1',
        123,
        '1990-01-01',
        'M',
        123,
        1000,
        1,
        null
    );
insert into Empregado
values (
        'Maria',
        'Rua 2',
        456,
        '1990-01-01',
        'F',
        456,
        2000,
        2,
        null
    );
insert into Empregado
values (
        'Jose',
        'Rua 3',
        789,
        '1990-01-01',
        'M',
        789,
        3000,
        3,
        null
    );
update Departamento
set CPFGer = 123
where NumDep = 1;
update Departamento
set CPFGer = 456
where NumDep = 2;
update Departamento
set CPFGer = 789
where NumDep = 3;
insert into Projeto
values ('Proj1', 1, 'Local1', 1);
insert into Projeto
values ('Proj2', 2, 'Local2', 2);
insert into Projeto
values ('Proj3', 3, 'Local3', 3);
insert into Dependente
values (1, 123, 'Dep1', 'M', 'Filho');
insert into Dependente
values (2, 456, 'Dep2', 'F', 'Filha');
insert into Dependente
values (3, 789, 'Dep3', 'M', 'Filho');
insert into Trabalha_Em
values (123, 1, 40);
insert into Trabalha_Em
values (456, 2, 40);
insert into Trabalha_Em
values (789, 3, 40);

-- 1. Função que retorna o salário de um empregado dado o CPF
CREATE OR REPLACE FUNCTION OBTER_SALARIO(CPF_EMPREGADO INTEGER) RETURNS FLOAT AS $$
DECLARE
    SalarioE FLOAT;
BEGIN
    SELECT Salario INTO SalarioE 
    FROM Empregado 
    WHERE CPF = CPF_EMPREGADO;

    IF NOT FOUND THEN
        RAISE NOTICE 'Empregado com CPF % não encontrado.', CPF_EMPREGADO;
        RETURN NULL;
    END IF;
    RETURN SalarioE;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_SALARIO(123);

-- 2. Função que retorna o nome do departamento de um empregado dado o CPF
CREATE OR REPLACE FUNCTION OBTER_DEPARTAMENTO(CPF_EMPREGADO INTEGER) 
RETURNS VARCHAR AS $$
DECLARE
    DepartamentoE VARCHAR(50);
BEGIN
    SELECT D.NomeDep INTO DepartamentoE 
    FROM Departamento D
    JOIN Empregado E ON D.NumDep = E.NumDep
    WHERE E.CPF = CPF_EMPREGADO;

    IF NOT FOUND THEN
        RAISE NOTICE 'Empregado com CPF % não encontrado.', CPF_EMPREGADO;
        RETURN NULL;
    END IF;
    
    RETURN DepartamentoE;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_DEPARTAMENTO(123);

-- 3. Função que retorna o nome do gerente de um departamento dado o NumDep
CREATE OR REPLACE FUNCTION OBTER_GERENTE(NUM_DEPARTAMENTO INTEGER) 
RETURNS VARCHAR AS $$
DECLARE
    gerente_NOME VARCHAR(50);
BEGIN 
    SELECT E.NOME INTO gerente_NOME 
    FROM Empregado E
    JOIN Departamento D ON D.CPFGer = E.CPF
    WHERE D.NumDep =  NUM_DEPARTAMENTO;

    IF NOT FOUND THEN
        RAISE NOTICE 'NUMERO DO DEPARTAMENTO: % NÃO ENCONTRADO', NUM_DEPARTAMENTO;
        RETURN NULL;
    END IF;
    RETURN gerente_NOME;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_GERENTE(1);

-- 4. Função que retorna o nome do projeto de um empregado dado o CPF
CREATE OR REPLACE FUNCTION OBTER_PROJETO(CPF_EMPREGADO INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    PROJETOE VARCHAR(50);
BEGIN
    SELECT P.NomeProj INTO PROJETOE 
    FROM PROJETO P
    JOIN DEPARTAMENTO D ON P.NumDep = D.NumDep
    JOIN Empregado E ON D.NumDep = E.NumDep
    WHERE E.CPF = CPF_EMPREGADO;

    IF NOT FOUND THEN
        RAISE NOTICE 'CPF: % NÃO ENCONTRADO', CPF_EMPREGADO;
        RETURN NULL;
    END IF;
    RETURN PROJETOE;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_PROJETO(123);

-- 5. Função que retorna o nome do dependente de um empregado dado o CPF
CREATE OR REPLACE FUNCTION OBTER_DEPENDENTE(CPF_EMPREGADO INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    DependenteE VARCHAR(50);
BEGIN
    SELECT D.NomeDep INTO DependenteE
    FROM Dependente D
    JOIN Empregado E ON E.CPF = D.CPFE
    WHERE E.CPF = CPF_EMPREGADO;

    IF NOT FOUND THEN
        RAISE NOTICE 'CPF: % NÃO ENCONTRADO', CPF_EMPREGADO;
        RETURN NULL;
    END IF;
    RETURN DependenteE;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_DEPENDENTE(123);

-- 6. Função que retorna o nome do gerente de um empregado dado o CPF
CREATE OR REPLACE FUNCTION OBTER_NOME_GERENTE(CPF_EMPREGADO INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    GERENTEE VARCHAR(50);
BEGIN
    SELECT E.NOME INTO GERENTEE
    FROM Empregado E
    JOIN DEPARTAMENTO D ON D.CPFGer = E.CPF
    WHERE E.CPF = CPF_EMPREGADO;

    IF NOT FOUND THEN
        RAISE NOTICE 'CPF: % NÃO ENCONTRADO', CPF_EMPREGADO;
        RETURN NULL;
    END IF;
    RETURN GERENTEE;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_NOME_GERENTE(123);

-- 7. Função que retorna a quantidade de horas que um empregado trabalha em um projeto dado o CPF
CREATE OR REPLACE FUNCTION OBTER_HORAS_TRABALHADAS(CPF_EMPREGADO INTEGER) 
RETURNS INT AS $$
DECLARE
    HorasTotal INT;
BEGIN
    SELECT COALESCE(SUM(HorasSemana), 0) INTO HorasTotal 
    FROM Trabalha_Em 
    WHERE CPF = CPF_EMPREGADO;

    IF NOT FOUND THEN
        RAISE NOTICE 'Empregado com CPF % não encontrado.', CPF_EMPREGADO;
        RETURN 0;
    END IF;

    RETURN HorasTotal;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_HORAS_TRABALHADAS(123);

-- 8. Função com Exception que retorna o salário de um empregado dado o CPF
CREATE OR REPLACE FUNCTION OBTER_SALARIO_EXCEPT(CPF_EMPREGADO INTEGER) 
RETURNS FLOAT AS $$
DECLARE
    SalarioE FLOAT;
BEGIN
    BEGIN
        SELECT Salario INTO SalarioE 
        FROM Empregado 
        WHERE CPF = CPF_EMPREGADO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE NOTICE 'NENHUM REGISTRO ENCONTRADO PARA O CPF %', CPF_EMPREGADO;
            RETURN NULL;
    END;

    RETURN SalarioE;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTER_SALARIO_EXCEPT(123);

