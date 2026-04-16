create database db_academia_fitflow;

use db_academia_fitflow;

create table planos (
	id int auto_increment primary key,
	nome varchar(50) not null,
	valor_mensal decimal(10, 2) not null,
	duracao_meses tinyint not null
);

create table alunos (
	id int auto_increment primary key,
	nome varchar(100) not null,
	cpf char(11) unique not null,
	data_nascimento date,
	email varchar(100),
	peso decimal(5, 2),
	altura decimal(3, 2),
	id_plano int,
	constraint fk_aluno_plano foreign key (id_plano)
	references planos(id)
);

create table instrutores (
	id int auto_increment primary key,
	nome varchar(100) not null,
	especialidade varchar(50),
	data_contratacao date
);

create table treinos (
	id int auto_increment primary key,
	id_aluno int not null,
	id_instrutor int not null,
	data_criacao date not null,
	objetivo varchar(100),
	constraint fk_treino_aluno foreign key (id_aluno)
	references alunos (id),
	constraint fk_treino_instrutor foreign key (id_instrutor)
	references instrutores (id)
);

create table exercicios (
	id int auto_increment primary key,
	nome_exercicio varchar(50) not null,
	equipamento varchar (50) 
);

create table itens_treino (
	id_treino int,
	id_exercicio int,
	series tinyint,
	repeticoes tinyint,
	primary key (id_treino, id_exercicio),
	constraint fk_item_treino foreign key(id_treino)
	references treinos(id),
	constraint fk_item_exercicio foreign key(id_exercicio)
	references exercicios(id)
);