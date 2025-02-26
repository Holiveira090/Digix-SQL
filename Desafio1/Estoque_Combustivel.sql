CREATE TABLE fornecedores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    cpnj VARCHAR(18),
    telefone VARCHAR(15),
    endereco VARCHAR(255)
);

CREATE TABLE clientes(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    cpf_cnpj VARCHAR(18),
    telefone VARCHAR(15),
    endereco VARCHAR(255)
);

CREATE TABLE produtos(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    descricao VARCHAR(255),
    tipo VARCHAR(255),
    preco_unitario FLOAT,
    unidade_medida VARCHAR(255)
);

CREATE TABLE estoque(
    id SERIAL PRIMARY KEY,
    quantidade INT,
    data_ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fk_produto INT,
    CONSTRAINT fk_produto_estoque FOREIGN KEY (fk_produto) REFERENCES produtos(id) ON DELETE CASCADE
);

CREATE TABLE compras(
    id SERIAL PRIMARY KEY,
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total FLOAT DEFAULT 0,
    fk_fornecedor INT,
    CONSTRAINT fk_fornecedor_compras FOREIGN KEY (fk_fornecedor) REFERENCES fornecedores(id) ON DELETE CASCADE
);

CREATE TABLE vendas(
    id SERIAL PRIMARY KEY,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total INT DEFAULT 0,
    fk_cliente INT,
    CONSTRAINT fk_cliente_vendas FOREIGN KEY (fk_cliente) REFERENCES clientes(id) ON DELETE CASCADE
);

CREATE TABLE vendas_produtos(
    id SERIAL PRIMARY KEY,
    quantidade INT,
    fk_venda INT,
    fk_produto INT,
    CONSTRAINT fk_venda_vendas_produtos FOREIGN KEY (fk_venda) REFERENCES vendas(id) ON DELETE CASCADE,
    CONSTRAINT fk_produto_vendas_produtos FOREIGN KEY (fk_produto) REFERENCES produtos(id) ON DELETE CASCADE
);

CREATE TABLE compras_produtos(
    id SERIAL PRIMARY KEY,
    quantidade INT,
    fk_compra INT,
    fk_produto INT,
    CONSTRAINT fk_compra_compras_produtos FOREIGN KEY (fk_compra) REFERENCES compras(id) ON DELETE CASCADE,
    CONSTRAINT fk_produto_compras_produtos FOREIGN KEY (fk_produto) REFERENCES produtos(id) ON DELETE CASCADE
);

-- Insert da tabela FORNECEDORES
INSERT INTO fornecedores (nome, cpnj, telefone, endereco) VALUES 
('Fornecedor A', '56.789.012/0001-78', '1234567890', 'Rua A, 123'),
('Fornecedor B', '98.765.432/0001-76', '9876543210', 'Rua B, 456'),
('Fornecedor C', '11.222.333/0001-99', '8765432109', 'Rua C, 789'),
('Fornecedor D', '44.555.666/0001-88', '1234567890', 'Rua D, 321'),
('Fornecedor E', '77.888.999/0001-77', '9876543210', 'Rua E, 654'),
('Fornecedor F', '12.345.678/0001-12', '8765432109', 'Rua F, 987');

-- Insert da tabela CLIENTES
INSERT INTO clientes (nome, cpf_cnpj, telefone, endereco) VALUES 
('Cliente G', '123.456.789-00', '1234567890', 'Rua A, 123'),
('Cliente L', '987.654.321-09', '9876543210', 'Rua B, 456'),
('Cliente P', '567.890.123-45', '8765432109', 'Rua C, 789'),
('Cliente Ç', '98.765.432/0001-76', '1234567890', 'Rua D, 321'),
('Cliente W', '56.789.012/0001-91', '9876543210', 'Rua E, 654'),
('Cliente Q', '12.345.678/0001-12', '8765432109', 'Rua F, 987');

-- Insert da tabela PRODUTOS
INSERT INTO produtos (nome, descricao, tipo, preco_unitario, unidade_medida) VALUES 
('DIESEL', 'S10', 'Combustível', 5.79, 'Litro'),
('GASOLINA', 'Comum', 'Combustível', 6.49, 'Litro'),
('ETANOL', 'Hidratado', 'Combustível', 4.99, 'Litro'),
('ÓLEO LUBRIFICANTE', 'Sintético 5W30', 'Lubrificante', 32.90, 'Litro'),
('ARLA 32', 'Redutor de emissões', 'Fluido automotivo', 3.50, 'Litro'),
('PNEU 185/65R15', 'Pneu para carros de passeio', 'Pneumático', 349.90, 'Unidade'),
('FILTRO DE ÓLEO', 'Filtro para motor 1.0 a 2.0', 'Peça automotiva', 45.00, 'Unidade'),
('BATERIA 60Ah', 'Bateria para veículos leves', 'Bateria automotiva', 420.00, 'Unidade'),
('PASTILHA DE FREIO', 'Dianteira - modelos variados', 'Peça automotiva', 120.00, 'Jogo'),
('ADITIVO PARA RADIADOR', 'Pronto para uso', 'Fluido automotivo', 25.90, 'Litro');


-- Insert da tabela ESTOQUE
INSERT INTO estoque (quantidade, fk_produto) VALUES 
(10, 1),
(5, 2),
(20, 3),
(15, 4),
(8, 5),
(12, 6);

select * from estoque;

-- Insert da tabela COMPRAS
INSERT INTO compras (fk_fornecedor) VALUES 
(1),
(2),
(3),
(4),
(5),
(6);

-- Insert da tabela COMPRAS_PRODUTOS
INSERT INTO compras_produtos (quantidade, fk_compra, fk_produto) VALUES 
(10, 1, 1),
(5, 2, 2),
(20, 3, 3),
(15, 4, 4),
(8, 5, 5),
(12, 6, 6);

-- Insert da tabela VENDAS
INSERT INTO vendas (fk_cliente) VALUES 
(1),
(2),
(3),
(4),
(5),
(6);

-- Insert da tabela VENDAS_PRODUTOS
INSERT INTO vendas_produtos (quantidade, fk_venda, fk_produto) VALUES 
(5, 1, 1),
(3, 2, 2),
(8, 3, 3),
(2, 4, 4),
(6, 5, 5),
(4, 6, 6);

-- Verificando os dados
SELECT * FROM fornecedores;
SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM estoque;
SELECT * FROM compras;
SELECT * FROM compras_produtos;
SELECT * FROM vendas;
SELECT * FROM vendas_produtos;


-- 4.1
SELECT P.NOME AS PRODUTO, E.QUANTIDADE
FROM PRODUTOS P
JOIN ESTOQUE E ON P.ID = fk_produto;

-- 4.2
SELECT C.ID, F.NOME, C.data_compra
FROM compras C
JOIN fornecedores F ON C.fk_fornecedor = F.ID
WHERE C.data_compra > '2025-02-24' AND C.data_compra < '2025-02-25';

-- 4.3
SELECT C.NOME AS CLIENTES, VP.quantidade
FROM CLIENTES C
JOIN VENDAS V ON C.ID = V.fk_cliente
JOIN vendas_produtos VP ON V.ID = fk_venda
ORDER BY VP.quantidade DESC
LIMIT 3;

-- 4.4
SELECT P.NOME AS COMBUSTIVEL, COALESCE(SUM(P.PRECO_UNITARIO * VP.QUANTIDADE), 0) AS TOTAL_VENDAS
FROM PRODUTOS P
JOIN vendas_produtos VP ON P.id = VP.fk_produto
JOIN VENDAS V ON VP.fk_venda = V.ID
WHERE EXTRACT(QUARTER FROM V.DATA_VENDA) = EXTRACT(QUARTER FROM CURRENT_DATE)
GROUP BY P.NOME;

-- 4.5
SELECT P.NOME AS PRODUTOS, E.quantidade
FROM PRODUTOS P
JOIN estoque E ON P.ID = E.fk_produto
WHERE E.quantidade < 12;


-- 5.1
CREATE VIEW vw_relatorio AS
SELECT
    c.nome AS cliente,
    p.nome AS produto,
    vp.quantidade AS quantidade_vendida,
    v.data_venda AS data_venda,
    v.valor_total AS valor_total_venda
FROM
    vendas v
JOIN
    vendas_produtos vp ON v.id = vp.fk_venda
JOIN
    produtos p ON vp.fk_produto = p.id
JOIN
    clientes c ON v.fk_cliente = c.id;

    select * from vw_relatorio;

-- 5.2
create view vw_estoque_atual AS
SELECT
    p.nome AS produto,
    e.quantidade AS quantidade_estoque
    FROM
    estoque e
JOIN
    produtos p ON e.fk_produto = p.id;

    select * from vw_estoque_atual;


-- 6.1
create or replace procedure sp_registrar_compra(idCompra int ,quantidadeProd int,fkProduto int) as $$ 
begin
    insert into compras_produtos(quantidade, fk_compra, fk_produto) values (quantidadeProd, idCompra, fkProduto);
    update estoque set quantidade = quantidade - quantidadeProd where fk_produto = fkProduto; 
end;
$$ language plpgsql;
CALL sp_registrar_compra(1, 5, 1);

select * from compras_produtos;
select * from estoque;

-- 6.2
CREATE OR REPLACE FUNCTION fn_calcular_valor_venda(p_quantidade INT, id_p int)
RETURNS FLOAT AS $$
BEGIN
    -- Calcula o valor total da venda
    RETURN p_quantidade * (SELECT preco_unitario FROM produtos WHERE id = id_p);
END;
$$ LANGUAGE plpgsql;

select * from fn_calcular_valor_venda(5, 1);

-- 6.3
CREATE OR REPLACE FUNCTION fn_percentual_vendas_produto(p_produto_id INT)
RETURNS FLOAT AS $$
DECLARE
    total_vendas_produto FLOAT;
    total_vendas_geral FLOAT;
    percentual FLOAT;
BEGIN
    -- total de vendas de um produto
    SELECT SUM(vp.quantidade * p.preco_unitario) INTO total_vendas_produto
    FROM vendas_produtos vp
    JOIN produtos p ON vp.fk_produto = p.id
    WHERE vp.fk_produto = p_produto_id;

    -- total de vendas geral
    SELECT SUM(vp.quantidade * p.preco_unitario) INTO total_vendas_geral
    FROM vendas_produtos vp
    JOIN produtos p ON vp.fk_produto = p.id;

    -- calcula o percentual
    IF total_vendas_geral > 0 THEN
        percentual := (total_vendas_produto / total_vendas_geral) * 100;
    ELSE
        percentual := 0;
    END IF;

    RETURN percentual;
END;
$$ LANGUAGE plpgsql;

select fn_percentual_vendas_produto(6);


CREATE OR REPLACE FUNCTION FN_CHECK_CLIENT_TYPE()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.CPF_CNPJ) = 14 THEN
        RAISE NOTICE 'CPF DETECTED: %', NEW.CPF_CNPJ;
        ELSIF LENGTH(NEW.CPF_CNPJ) = 18 THEN
            RAISE NOTICE 'CNPJ DETECTED: %', NEW.CPF_CNPJ;
    ELSE
        RAISE EXCEPTION 'THE VALUE OF CPF_CNPJ IS INVALID: LENGHT MUST BE 14 OR 18 CHARACTERS';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_CHECK_CPF_CNPJ
BEFORE INSERT OR UPDATE ON CLIENTES
FOR EACH ROW
EXECUTE PROCEDURE FN_CHECK_CLIENT_TYPE();



-- CHECK CNPJ OF THE SUPPLIER
CREATE OR REPLACE FUNCTION FN_CHECK_CNPJ()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.CPNJ) = 18 THEN
        RAISE NOTICE 'CNPJ DETECTED: %', NEW.CPNJ;
    ELSE
        RAISE EXCEPTION 'THE VALUE OF CNPJ IS INVALID: LENGHT MUST BE 18 CHARACTERS';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER TR_CHECK_CNPJ
BEFORE INSERT OR UPDATE ON FORNECEDORES
FOR EACH ROW
EXECUTE PROCEDURE FN_CHECK_CNPJ();

-- TRIGGER TO UPDATE THE TOTAL VALUE OF SALES
CREATE OR REPLACE FUNCTION FN_CALCULAR_VALOR_VENDA_TR()
RETURNS TRIGGER AS $$
DECLARE VALOR FLOAT;
BEGIN
    SELECT COALESCE(SUM(VP.QUANTIDADE * P.PRECO_UNITARIO), 0) INTO VALOR
    FROM VENDAS_PRODUTOS VP
    JOIN PRODUTOS P ON VP.FK_PRODUTO = P.ID
    WHERE VP.FK_VENDA = NEW.FK_VENDA;

    UPDATE VENDAS 
    SET VALOR_TOTAL = VALOR
    WHERE ID = NEW.FK_VENDA;
    RAISE NOTICE 'VALOR TOTAL ATUALIZADO: %', VALOR;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_VALOR_TOTAL_VENDA
AFTER INSERT OR UPDATE OR DELETE ON VENDAS_PRODUTOS
FOR EACH ROW
EXECUTE PROCEDURE FN_CALCULAR_VALOR_VENDA_TR();

-- 7.1
CREATE OR REPLACE FUNCTION FN_ATUALIZAR_ESTOQUE_VENDA()
RETURNS TRIGGER AS $$
DECLARE QTD INT;
BEGIN
    SELECT QUANTIDADE INTO QTD FROM ESTOQUE WHERE FK_PRODUTO = NEW.FK_PRODUTO;

    IF NEW.QUANTIDADE > QTD THEN
        RAISE EXCEPTION 'NÃO HÁ ESTOQUE SUFICIENTE DO PRODUTO %: SOLICITADO = %; ESTOQUE: %', NEW.FK_PRODUTO, NEW.QUANTIDADE, QTD;
    ELSE 
        UPDATE ESTOQUE SET QUANTIDADE = (QUANTIDADE - NEW.QUANTIDADE),
        DATA_ULTIMA_ATUALIZACAO = CURRENT_TIMESTAMP
        WHERE FK_PRODUTO = NEW.FK_PRODUTO;
        RAISE NOTICE 'SUCESSO NA VENDA % ', NEW.FK_VENDA;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_ATUALIZAR_ESTOQUE_VENDA
BEFORE INSERT OR UPDATE ON VENDAS_PRODUTOS
FOR EACH ROW
EXECUTE PROCEDURE FN_ATUALIZAR_ESTOQUE_VENDA();

-- 7.2
CREATE OR REPLACE FUNCTION FN_ATUALIZAR_ESTOQUE_COMPRA()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE ESTOQUE SET QUANTIDADE = (QUANTIDADE + NEW.QUANTIDADE),
    DATA_ULTIMA_ATUALIZACAO = CURRENT_TIMESTAMP
    WHERE FK_PRODUTO = NEW.FK_PRODUTO;
    RAISE NOTICE 'SUCESSO NA COMPRA % ', NEW.FK_COMPRA;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TR_ATUALIZAR_ESTOQUE_COMPRA
BEFORE INSERT OR UPDATE ON COMPRAS_PRODUTOS
FOR EACH ROW
EXECUTE PROCEDURE FN_ATUALIZAR_ESTOQUE_COMPRA();



-- 7.3
create table Monitoramento_Banco(

    Id SERIAL primary key,
    AcaoRealizada VARCHAR(50),
    NomeTabela VARCHAR(50),
    DataAcao  DATE DEFAULT CURRENT_DATE,
    Usuario VARCHAR(50) 
);

-- 7.4
CREATE OR REPLACE FUNCTION Monitoramento_Banco() 
RETURNS TRIGGER AS $$  
BEGIN 
    IF TG_OP = 'INSERT' THEN
        INSERT INTO Monitoramento_Banco (AcaoRealizada, NomeTabela, Usuario) 
        VALUES ('INSERT', TG_TABLE_NAME, CURRENT_USER);

    ELSIF TG_OP = 'UPDATE' THEN 
        INSERT INTO Monitoramento_Banco (AcaoRealizada, NomeTabela, Usuario) 
        VALUES ('UPDATE', TG_TABLE_NAME, CURRENT_USER);

    ELSIF TG_OP = 'DELETE' THEN 
        INSERT INTO Monitoramento_Banco (AcaoRealizada, NomeTabela, Usuario) 
        VALUES ('DELETE', TG_TABLE_NAME, CURRENT_USER);

    ELSE
        RAISE EXCEPTION 'Operação desconhecida no trigger';
    END IF;

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;


create trigger Monitoramento_Banco_Trigger
after insert or update or delete on fornecedores
for each row
execute function Monitoramento_Banco();


create trigger Monitoramento_Banco_Trigger
after insert or update or delete on clientes
for each row
execute function Monitoramento_Banco();


create trigger Monitoramento_Banco_Trigger
after insert or update or delete on produtos
for each row
execute function Monitoramento_Banco();


create trigger Monitoramento_Banco_Trigger
after insert or update or delete on estoque
for each row
execute function Monitoramento_Banco();


create trigger Monitoramento_Banco_Trigger
after insert or update or delete on compras
for each row
execute function Monitoramento_Banco();


create trigger Monitoramento_Banco_Trigger
after insert or update or delete on compras_produtos
for each row
execute function Monitoramento_Banco();


CREATE TRIGGER Monitoramento_Banco_Trigger
AFTER INSERT OR UPDATE OR DELETE ON vendas
FOR EACH ROW
EXECUTE FUNCTION Monitoramento_Banco();


CREATE TRIGGER Monitoramento_Banco_Trigger
AFTER INSERT OR UPDATE OR DELETE ON vendas_produtos
FOR EACH ROW
EXECUTE FUNCTION Monitoramento_Banco();

INSERT INTO vendas (fk_cliente) VALUES 
(3);

SELECT * from Monitoramento_Banco;