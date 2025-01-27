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

-- alterar os dados
update cargo set salario = 6500.00 where id = 1;
update usuario set nome = 'ciclano' where id = 1;

-- excluir os dados
DELETE FROM usuario WHERE id = 2;

-- consultar a tabela
select * from usuario
select * from cargo

-- Left Join que retorna todos os usuarios e seus cargos, ou seja os registros da tabela da esquerda (usuario) e os registros da tabela da direita (cargo)
select * from usuario left join cargo on usuario.id = cargo.fk_usuario; -- começa a pesquisa da esquerda para a direita
-- Right Join que retorna todos os usuarios e seus cargos, ou seja os registros da tabela da direita (cargo) e os registros da tabela da esquerda (usuario)
select * from usuario right join cargo on usuario.id = cargo.fk_usuario;

-- Inner Join que retorna os registros que possuem o mesmo id na tabela da esquerda (usuario) e na tabela da direita (cargo)
select * from usuario inner join cargo on usuario.id = cargo.fk_usuario;
