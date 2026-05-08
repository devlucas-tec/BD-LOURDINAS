use db_academia_fitflow;

-- AULA 10
-- SCRIPTS DE MANUTENÇÃ


-- adicionar campos em tabelas criadas

alter table alunos 
add column whatsapp varchar(20) after email;

select * from alunos;


-- MODIFICAR TAMANHO DE CAMPO

alter table alunos 
modify column nome varchar(150) not null;


-- ALTERAR CAMPO E TIPO DE UMA VEZ SO

alter table alunos
change column documento_fiscal cpf varchar(14);


-- EXCLUIR COLUNAS

alter table alunos 
drop column whatsapp;



-- truncate - reseta tudo na tabela, até mesmo o contador

create table backup_alunos 
select * from alunos;

select * from backup_alunos;

truncate table backup_alunos;



-- DESAFIO EM AULA

/*
 * 1- Expansão
 * 
 * Adicione uma nova coluna temporal para rastrear novos
 * registros na base de alunos (coluna data_cadastro) 
 * 
 * */

alter table alunos
add column data_cadastro timestamp after data_nascimento;

select * from alunos;


/*
 * 2- Limpeza
 * 
 * Remova a nova coluna criada para a tabela de alunos
 * 
 * */

alter table alunos
drop column data_cadastro;


/*
 * 3- Reset
 * 
 * Teste a limpeza rápida de tabelas e observe o comportamento
 * do contador de incremento (Truncate)
 * 
 * */

create table backup_alunos
select * from alunos;

select * from backup_alunos;

truncate backup_alunos;


/*
 * 4- Refatoração
 * 
 * Renomeie o nome da tabela auditoria_precos para auditoria_planos 
 * para melhor organizacao e ajuste as dependências do sistema.
 * 
 * */

alter table auditoria_precos 
rename to auditoria_planos;



-- PROCEDURES

create table pagamentos(
	id int auto_increment primary key,
	id_aluno int not null,
	id_plano int not null,
	valor_pago decimal(10,2),
	data_vencimento date not null,
	data_pagamento date,
	status enum('Pendente', 'Pago', 'Atrasado', 'Cancelado') default 'Pendente',
	metodo_pagamento varchar(50),
	constraint fk_aluno_pagamento
	foreign key(id_aluno) references alunos(id) on delete cascade,
	constraint fk_plano_pagamento 
	foreign key(id_plano) references planos(id)
);


insert into pagamentos (id_aluno, id_plano, data_vencimento, status)
values 
(7, 1, DATE_ADD(CURDATE(), interval 5 day), 'Pendente'),
(8, 2, DATE_ADD(CURDATE(), interval 5 day), 'Atrasado'),
(9, 3, curdate(), 'Pago');

select * from alunos;
select * from planos;




-- AUTOMATIZAR PROCESSO DE INSERT DE ALUNOS E PAGAMENTOS

create procedure p_matricular_aluno(
	in p_nome varchar(150),
	in p_cpf varchar(14),
	in p_id_plano int)
	
begin
	
	-- PASSO 1
	-- insert na tabela alunos
	insert into alunos(nome, cpf, id_plano)
	values(p_nome, p_cpf, p_id_plano);

	-- PASSO 2
	-- recuperar o id e gerar pagamento inicial
	insert into pagamentos(id_aluno, id_plano, data_vencimento, status)
	values(LAST_INSERT_ID(), p_id_plano, DATE_ADD(CURDATE(), interval 5 day), 'Pendente');
	
	-- PASSO 3
	-- mensagem de confirmação
	select 'Matricula e Pagamento criados com sucesso' as resultado;
end


call p_matricular_aluno('ALUNO TAL', '209939994888', 1);

select * from pagamentos ;



-- ATIVIDADE 5 - PROCEDURES

/* 1- A partir da presença dos alunos, vamos criar uma automação
 * para dar pontos aos alunos dependendo do tempo que foi utilizado
 * na academia. Crie uma procedure sp_registrar_presenca(id_plano, 
 * duracao_minutos) com as seguintes regras:
 * 
 * REQUISITOS DA PROCEDURE
 * 
 * 1- Estrutura de Dados:
 * Crie as tabelas necessárias
 * 
 * 	* prensencas: id_aluno, data, duracao_minutos
 *  * perfil_aluno: id_aluno, e o fitpoints
 * 
 * 2- Registro de Atividade:
 * Insira os dados da sessão na tabela presencas.
 * 
 * 3- Regras de Bônus:
 * Se duracao_minutos > 60, adicione 10 FitPoints ao perfil do aluno.
 * 
 * 
 * 
 * Dica Técnica
 * 
 * A tabela perfil_aluno possui 1:1 com alunos. O perfil deve existir
 * previamente para a procedure funcionar.
 * 
 * Carga inicial sugerida:
 * 
 * INSERT INTO perfil_aluno (id_aluno)
 * SELECT id FROM alunos;
 * 
 */

create table presencas(
	id int auto_increment primary key,
	id_aluno int not null,
	data date not null,
	duracao_minutos int not null,
	constraint fk_presenca_aluno 
	foreign key(id_aluno) references alunos(id)
);


create table perfil_aluno(
	id int auto_increment primary key,
	id_aluno int not null unique,
	fitpoints int default 0,
	constraint fk_aluno_perfil
	foreign key(id_aluno)
	references alunos(id)
);

select id_plano from alunos;
select * from planos;


insert into perfil_aluno(id_aluno)
select id from alunos;

select * from presencas;
select * from perfil_aluno;

create procedure st_registrar_presenca(
		in p_id_aluno int, 
		in p_duracao_minutos int
)
begin
	
	insert into presencas(id_aluno, data, duracao_minutos)
	values(p_id_aluno, now(), p_duracao_minutos);

	if p_duracao_minutos > 60 then
	update perfil_aluno
	set fitpoints = fitpoints + 10
	where id_aluno = p_id_aluno;
	select 'Parabéns, você ganhou 10 fitpoints' as mensagem;
	
	else
	select 'Presenca registrada' as mensagem;
	end if;
	
	
end

select * from alunos;

call st_registrar_presenca(7, 50);

select * from perfil_aluno;
