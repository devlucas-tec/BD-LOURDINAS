use db_academia_fitflow;

-- AULA 06 --

/*
 * Listar todos os treinos, e ao lado,
 * mostrar o nome do instrutor que o criou
 * (SEM USAR JOIN)
 */

select t.objetivo, 
(select nome from instrutores i where i.id = t.id_instrutor) as 'nome_professores' 
from treinos t;


/*
 * Imagine que você queira listar os exercícios que ainda não foram incluídos 
 * em nenhum treino*/

--  NOT IN

select id, nome_exercicio from exercicios 
where id not in (select id_exercicio from itens_treino);

select id, nome_exercicio from exercicios 
where id in (1,1,3,4,7);

/*
 * Listar apenas os instrutores que possuem
 * pelo menos um treino criado.
 * Intrutores sem treinos devem ser omitidos*/

-- EXISTS

select nome, especialidade from instrutores i 
where exists (select 1 from treinos t 
				where t.id_instrutor = i.id);



-- DESAFIO DA AULA
/*
 * Imagine que o marketing quer saber quais planos
 * da academia estão sendo efetivamente utilizados
 * por algum aluno no momento.
 * 
 * LÓGICA DE SOLUÇÃO: O banco verifica cada plano
 * se existe pelo menos um registro na tabela alunos 
 * vinculado ao seu ID. Se houver, o plano é retornado
 */

select p.nome, p.valor_mensal from planos p
where exists (select 1 from alunos a 
where a.id_plano = p.id);




-- DESAFIO EM AULA
/*
 * Crie uma tabela chamada resumo_planos que contenha
 * o nome do plano e a quantidade de alunos de cada um.
 * 
 * DICA DE EXECUÇÃO: Utilize a cláusula CREATE TABLE 
 * combinada com um LEFT JOIN e GROUP BY para garantir
 * que todos os planos sejam listados, inclusive aqueles 
 * sem alunos
 */

create table resumo_planos as
(select p.nome, count(a.nome) as "alunos_plano" 
from planos p
left join alunos a on a.id_plano = p.id
group by p.nome);
	

select p.nome, count(a.nome) as "alunos_plano" from planos p
left join alunos a on a.id_plano = p.id
group by p.nome;
	

-- DESAFIO EM AULA
/*
 * Insira na tabela planos um novo plano chamado 'Plano VIP gold'*/


insert into planos (nome, valor_mensal, duracao_meses) 
select 'Plano VIP Gold', MAX(valor_mensal) * 1.5, 12
from planos;


select 'Plano VIP Gold', MAX(valor_mensal) * 1.5 as 'valor_mensal', 12
from planos;