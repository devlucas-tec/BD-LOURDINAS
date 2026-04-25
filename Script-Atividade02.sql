use db_academia_fitflow;

-- QUESTÃO 1 --
/* 
 * Selecione todos os nomes de equipamentos
 * da tabela exercicios sem repetir nenhum nome.
 */

select distinct equipamento from exercicios; 

-- QUESTÃO 2 --
/*
 * Liste o nome de todos os instrutores,
 * mas renomeie a coluna para Professor no resultado. 
 */

select nome "Professor" from instrutores;

-- QUESTÃO 3 --
/*
 * Qual é o maior peso registrado 
 * entre todos os alunos?
 * Renomeie a coluna de resultado
 * para Peso_Maximo
 */

select max(peso) as "Peso_Maximo" from alunos;

-- QUESTÃO 4 --
/*
 * Qual é o valor da mensalidade mais barata
 * oferecida pela academia?
 * */

select min(valor_mensal) as "Mensalidade_Minima" 
from planos;

-- QUESTÃO 5 --
/*
 * Selecione a data de nascimento do aluno
 * mais jovem (a data "maior" ou mais recente). 
*/

select max(data_nascimento) "Data_mais_Recente"
from alunos;

-- QUESTÃO 6 --
/*
 * Liste os nomes de todos os alunos e seus CPFs,
 * renomeando as colunas para Cliente e Documento. 
*/

select nome "Cliente", cpf "Documento"
from alunos order by nome;

-- QUESTÃO 7 --
/*
 * Calcule a média de altura
 * de todos os alunos cadastrados. 
*/

select round(avg(altura),2) as "Altura_Media" 
from alunos;

-- QUESTÃO 8 --
/*
 * Exiba uma lista de todos os objetivos
 * de treino (tabela treinos) sem duplicatas.
 */

select distinct objetivo from treinos;

-- QUESTÃO 9 --
/*
 * Conte quantos equipamentos distintos
 * existem na tabela de exercícios.
 */

select count(distinct(equipamento))
as "Quantidade_Equipamentos"
from exercicios;

-- QUESTÃO 10 --
/*
 * Qual a soma total de todas as mensalidades
 * se somarmos uma de cada plano disponível?
 */

select sum(valor_mensal) "Soma_Planos" from planos;

-- QUESTÃO 11 --
/*
 * Liste o nome do aluno
 *  e o nome do plano que ele possui.
 */

select a.nome "Auno", p.nome "Plano" 
from alunos a
join planos p
on a.id_plano = p.id;

-- QUESTÃO 12 --
/*
 * Exiba o nome de todos os alunos 
 * e o nome do plano deles.
 * Alunos sem plano devem aparecer com NULL
 * (Use LEFT JOIN)
 */
insert into alunos (nome, cpf,
data_nascimento, email, peso, altura)
values ('Lucas', '12345778902',
'2006-10-04', 'lucas@email.com', 77, 1.7);

select a.nome "Aluno", p.nome "Plano"
from alunos a
left join planos p
on a.id_plano = p.id;


-- QUESTÃO  13 --
/*
 * Liste o nome do instrutor
 * e o objetivo de cada treino que ele criou
 */

select i.nome "Instrutor", t.objetivo "Objetivo_treino"
from instrutores i 
join treinos t
on i.id = t.id_instrutor
order by i.nome ;

-- QUESTÃO 14 --
/*
 * Relacione o nome do aluno, o objetivo do seu treino
 * e o nome do instrutor responsável
 * (Múltiplos JOINs).
 */

select a.nome "Aluno",
t.objetivo "Objetivo_treino",
i.nome "Instrutor"
from alunos a 
join treinos t
on a.id = t.id_aluno 
join instrutores i 
on i.id = t.id_instrutor;

-- QUESTÃO 15 --
/*
 * Liste todos os exercícios (nome)
 * e as séries/repetições que pertencem ao treino
 * de ID número 2
 */

insert itens_treino 
values (5,2, 5, 6);

select e.nome_exercicio, it.series, it.repeticoes
from exercicios e 
join itens_treino it 
on e.id = it.id_exercicio
where it.id_exercicio = 2;

-- QUESTÃO 16 --
/*
 * Exiba o nome de cada aluno
 * e a data de criação do seu treino, 
 * usando apelidos a para alunos e t para treinos. 
*/

select a.nome "Aluno", t.data_criacao "Data_criacao_Treino"
from alunos a
join treinos t 
on a.id = t.id_aluno;

-- QUESTÃO 17 -- 
/*
 * Mostre o nome do aluno e o valor mensal do plano
 * que ele paga.
 */

select a.nome, p.valor_mensal "Valor_Plano_Mes"
from alunos a 
join planos p 
on a.id_plano = p.id;

-- QUESTÃO 18 --
/*
 * Liste o nome de todos os instrutores
 * e os IDs dos treinos que eles criaram.
 * Inclua instrutores que ainda não criaram 
 * nenhum treino (se não existir, crie um novo
 * instrutor sem treino para que ele apareça 
 * na consulta)
 */

select * from instrutores;
insert into instrutores (nome, especialidade, data_contratacao )
values ('Alexandre', 'Crossfit', '2026-01-01');

select i.nome, t.id from instrutores i 
left join treinos t 
on i.id = t.id_instrutor;


-- QUESTÃO 19 --
/*
 * Gere um relatório com: Nome do Aluno, 
 * Nome do Exercício e Repetições
 * (Exige 4 tabelas conectadas). 
*/

select a.nome, e.nome_exercicio, it.repeticoes
from alunos a 
join treinos t on a.id = t.id_aluno 
join itens_treino it on it.id_treino = t.id 
join exercicios e on it.id_exercicio = e.id;

-- QUESTÃO 20 --
/*
 * Exiba o nome do plano e o nome dos alunos 
 *  vinculados a ele, mas apenas para planos
 * que custem mais de 100 reais.
 */

select p.nome "Plano", p.valor_mensal,
a.nome "Aluno"
from alunos a
join planos p on a.id_plano = p.id
where p.valor_mensal > 100;