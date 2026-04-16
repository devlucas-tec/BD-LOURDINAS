use fitflow;

create table planos (
    id int auto_increment primary key,
    tipo varchar(50),
    valor_mensal decimal(10,2) not null,
    duracao_meses int not null
);

create table alunos (
	id int auto_increment primary key,
	nome_completo varchar(100) not null,
	cpf varchar(11) not null unique,
	data_nascimento date not null,
	email varchar(100) not null,
	peso decimal(3, 2),
	altura decimal(3, 2), 
	id_plano int not null,
	foreign key (id_plano) references planos(id)
	
);

create table treinos (
    id int auto_increment primary key,
    id_instrutor int not null,
    data_criacao date not null,
    id_aluno int not null,
    foreign key (id_aluno) references alunos(id)
);

create table instrutores (
    id int auto_increment primary key,
    nome varchar(100) not null,
    especialidade varchar(50) not null,
    id_treino int not null,
    foreign key (id_treino) references treinos(id)
);


create table exercicios (
    id int auto_increment primary key,
    nome varchar(100) not null,
    num_series int not null,
    repeticoes int not null,
    id_treino int not null,
    foreign key (id_treino) references treinos(id)
);



