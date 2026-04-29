-- ATIVIDADE 03 --
-- SUBQUERIES --

use db_academia_fitflow;

/*Tarefa 1 Auditoria 

Crie uma tabela auditoria_precos
com o nome do plano e a diferença de
valor para o plano mais caro.

*/

create table auditoria_precos (
	select nome, valor_mensal,
(select MAX(valor_mensal) from planos) - valor_mensal 'diferenca_plano'
from planos
);

select * from auditoria_precos;



/*Tarefa 2 Instrutores

O instrutor com o ID 1 foi demitido. Mova
todos os treinos dele para o instrutor
que foi contratado mais recentemente.

*/



select t.objetivo, i.nome from treinos t 
join (select id, nome from instrutores order by data_contratacao desc limit 1) i 
on t.id_instrutor = i.id;

select id from instrutores order by data_contratacao desc limit 1;

update treinos 
set id_instrutor = (select id from instrutores order by data_contratacao desc limit 1)
where id_instrutor = 1;

select * from treinos;



/*Tarefa 3 Limpeza

Apague todos os alunos que estão
matriculados em planos que custam
menos de 50 reais.

*/

insert into planos (nome, valor_mensal, duracao_meses)
values ('Plano Teste', 45.00, 1);

update alunos
set id_plano = 9
where id = 13;

select a.nome, p.id from alunos a
join planos p 
on a.id_plano = p.id
where p.valor_mensal < 50;

delete from alunos
where id_plano in (select id from planos 
where valor_mensal < 50);



