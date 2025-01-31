-- Criar tabela
create table usuario (
	id int primary key not null,
	nome varchar(50),
 	email varchar(50)
);

create table cargo (
	id int primary key not null,
	nome varchar(50),
	fk_usuario int,
	constraint fk_cargo_usuario foreign key(fk_usuario)
	references usuario(id)
);

-- Alterar tabela e adicionando a coluna salario
alter table cargo add column salario decimal(10,2);
alter table cargo alter column nome type varchar(100);
alter table cargo drop column salario;

-- Excluir tabela
drop table cargo;
drop table usuario;

-- inserir os dados no usuario
insert into usuario values (1, 'Joao', 'joao@gmail.com');
insert into usuario values (2, 'maria', 'maria@gmail.com');
insert into usuario values (3, 'josé', 'jose@gmail.com');

-- inserir os dados no cargo
insert into cargo values (1, 'Analista de sistemas', 1, 5000.00);
insert into cargo values (2, 'Analista de banco de dados', 1, 6000.00);
insert into cargo values (3, 'Analista de Redes', 2, 7000.00);

SELECT * FROM cargo;
SELECT * FROM usuario;

-- Imprimir somente o nome da tabela cargo
SELECT cargo.nome FROM cargo;
SELECT cargo.id FROM cargo;

-- Abreviação da tabela
SELECT c.nome from cargo c;
SELECT c.nome, u.nome from cargo c, usuario u;

-- Aplicação de Condições
SELECT c.nome from cargo c where id = 1; -- vai imprimir o nome do cargo com id 1
SELECT u.nome FROM usuario u WHERE u.nome = 'maria'; -- imprime todas as maria
SELECT u.id FROM usuario u WHERE u.nome = 'maria'; -- imprime apenas o id das maria

SELECT u.nome from usuario u WHERE u.id = 1 or u.id = 2;
SELECT u.nome from usuario u WHERE u.id = 1 AND u.id = 2;

-- selecionar uma lista de id
SELECT u.nome FROM usuario u WHERE id in (1,2,3); -- in quer dizer dentro
SELECT u.nome FROM usuario u WHERE id not in (1,2,3); -- quer dizer que nao é para imprimir os valores desses id

-- Utilizar o operador Between para ser usado entre os intervalos
SELECT u.nome FROM usuario u WHERE id BETWEEN 1 and 3; -- estou imprimindo os id de 1 a 3

-- Utilizar o operador Like que é para pesquisar partes de uma string(texto)
SELECT u.id, u.nome from usuario u WHERE nome like 'jo%'; -- % imprime qualquer coisa que comece com jo
SELECT u.id, u.nome from usuario u WHERE nome like '%ao'; -- % imprime qualquer coisa que termina com ao

-- Operadores de Comparação
SELECT u.id, u.nome from usuario u WHERE id > 1; -- maior que
SELECT u.id, u.nome from usuario u WHERE id >= 1; -- maior ou igual que

SELECT u.id, u.nome FROM usuario u WHERE id > 1 and id < 3; -- maior que 1 e menor que 3

-- Operadores de Ordenação
SELECT u.id, u.nome from usuario u ORDER BY id ASC; -- Ordem crescente
SELECT u.id, u.nome from usuario u ORDER BY id DESC; -- Ordem decrescente
SELECT u.id, u.nome from usuario u ORDER BY nome DESC; -- ordenado por indice de caracteres

-- Limitar os resultados
SELECT * FROM usuario LIMIT 1;

-- Agrupamento
SELECT c.nome, u.nome, count(c.id) from usuario u, cargo c WHERE u.id = c.fk_usuario GROUP BY c.nome, u.id; -- group by = agrupado por

	