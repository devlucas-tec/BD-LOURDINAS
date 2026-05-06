use db_academia_fitflow;

-- AULA 08 
-- TRIGGERS

create trigger trg_padroniza_nome
before insert on alunos
for each row 
begin
	set new.nome = upper(new.nome);
end


insert into alunos (nome, cpf, data_nascimento, email, peso, altura)
values ('lucas barbosa', '77971234673', '2006-10-04', 'lucas@email.com', 78, 1.70);

select * from alunos;



-- DESAFIO EM AULA
/*
 * Crie uma trigger BEFORE UPDATE que impeça a redução 
 * do valor_mensal para menos de R$ 50,00
 */

create trigger trg_padroniza_valor_minimo
before
update
	on
	planos
for each row
begin
	if new.valor_mensal < 50 then 
		set
	new.valor_mensal = 50;
end if;
end



update
	planos
set
	valor_mensal = 40
where
	id = 9;



select
	*
from
	planos;


/*
 * Crie uma tabela de auditorias para preço de planos
 * use triggers para isso
 */

create table auditoria_precos(
	id int auto_increment primary key,
	id_plano int not null,
	valor_antigo decimal(10, 2),
	valor_novo decimal(10, 2),
	data_auditoria timestamp default CURRENT_TIMESTAMP,
	constraint fk_plano_auditoria foreign key (id_plano)
	references planos(id)
);

create trigger trg_auditoria_precos
after
update
	on
	planos
for each row
begin
	if old.valor_mensal <> new.valor_mensal then
		insert
	into
	auditoria_precos 
		(id_plano,
	valor_antigo,
	valor_novo,
	data_auditoria)
values (old.id,
old.valor_mensal,
new.valor_mensal,
now());
end if;
end



update planos
set valor_mensal = 75
where id = 6;

select * from auditoria_precos;


/*
 * Crie uma trigger AFTER INSERT na tabela treinos para registrar
 * a mensagem: Novo treino criado para o aluno ID_ALUNO, junto com
 * a data e a hora atual (utilize NOW())
 * 
 * Requisitos:
 *  1- Criar Tabela log - log_sistema
 *  2- Mensagem: Novo Treino */


create table log_sistema(
	id int auto_increment primary key,
	mensagem varchar(255),
	data_criacao timestamp default CURRENT_TIMESTAMP
);


create trigger trg_log_treinos_alunos
after insert 
on treinos 
for each row
begin 
	
	insert into log_sistema
	 (mensagem, data_criação)
	 values(concat('Novo treino criado para o aluno id ', new.id_aluno), now());
end



-- AULA 09
-- Continuação das Triggers
-- DELETE

-- questão apenas de exemplo de sintaxe
create trigger trg_backup_alunos
after delete 
on alunos
for each row
begin
	insert into backup_alunos
	(id_aluno, nome, cpf, data_exclsao)
	values (old.id_aluno, old.nome, old.cpf, now());
end




-- DESAFIOS PRÁTICOS - TRIGGERS E AUTOMAÇÃO

/*
 * 1- Auditoria de Alterações
 * 
 * Registrar alterações de nome ou especialidade
 * na tabela log_instrutores para auditoria da 
 * tabela instrutores (informar somente se foi
 * nome ou especialidade alterado).
 * 
 * */

select * from instrutores;

create table log_instrutores (
	id int auto_increment primary key,
	campo_alterado varchar(50) not null
);

create trigger trg_auditoria_instrutores
after update 
on instrutores 
for each row
begin
	if old.nome <> new.nome then
		insert into log_instrutores(campo_alterado)
		values('Campo nome alterado');
	elseif old.especialidade <> new.especialidade then
		insert into log_instrutores(campo_alterado)
		values('Campo especialidade alterada');
	end if;
end

update instrutores
set nome = 'Andre Doria'
where id = 2;

update instrutores
set especialidade = 'Levantamento de peso'
where id = 2;

select * from log_instrutores;



/*
 * 2- Bloqueio de Exclusão
 * 
 * Impedir a exclusão do exercício 'Supino Reto'
 * usando uma trigger BEFORE DELETE.
 * 
 * Utilize o codigo abaixo para cancelar a exclusão:
 * 		SIGNAL SQLATE '45000'
 * 		SET MESSAGE_TEXTE = 'Erro: Não é permitido
 * 		excluir o exercício Supino Reto!';
 * 
 * */

select * from exercicios;

create trigger trg_not_delete_exercicio
before delete 
on exercicios
for each row
begin
	if old.nome_exercicio = 'Supino Reto' then
	signal SQLSTATE '45000'
	set MESSAGE_TEXT = 'Erro: Não é permitido excluir o exercício Supino Reto';
	end if;
end

delete from exercicios
where nome_exercicio = 'Supino Reto';




/*
 * 3- Sincronização de Dados
 * 
 * Manter o total de alunos sincronizado na tabela 
 * estatistica_academia.
 * 
 * Lembre-se: Eu posso inserir e apagar alunos.
 * 
 * */


create table estatistica_academia(
	id int auto_increment primary key,
	total_alunos int not null
);

insert into estatistica_academia (total_alunos)
select count(id) from alunos;

select count(id) from alunos;
select * from estatistica_academia;

create trigger trg_sincroniza_alunos
after insert 
on alunos
for each row
begin
	
	update estatistica_academia
	set total_alunos = total_alunos + 1;
	
end

select * from alunos;

insert into alunos(nome, cpf, data_nascimento, email, peso, altura)
values('Teste', '94765723559', '2006-10-04', 'teste@email.com', 70, 1.70);

select * from estatistica_academia;


create trigger trg_sincroniza_alunos_del
after delete 
on alunos
for each row
begin
	
	update estatistica_academia
	set total_alunos = total_alunos -1;	
end


delete from alunos
where id = 20;




/*
 * 4- Gerenciamento e SQL
 * 
 * Escreva comandos SQL para listar apenas as triggers
 * da tabela alunos
 * 
 * */

show triggers where `Table` = 'alunos';