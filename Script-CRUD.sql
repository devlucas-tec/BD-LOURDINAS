use db_academia_fitflow;


-- INSERTS AULA 03 --

INSERT INTO planos (nome, valor_mensal, duracao_meses) VALUES 
('Plano Mensal Bronze', 90.00, 1),
('Plano Trimestral Prata', 150.00, 3),
('Plano Semestral Ouro', 250.00, 6),
('Plano Anual Black', 1200.00, 12),
('Plano de Teste', 0.00, 1);

INSERT INTO alunos (nome, cpf, data_nascimento, email, peso, altura, id_plano) VALUES 
('Carlos Silva', '12345678901', '1960-05-15', 'carlos@email.com', 95.50, 1.68, 4),
('Ana Souza', '23456789012', '2009-10-20', 'ana.souza@email.com', 55.00, 1.62, 1),
('Ricardo Oliveira', '34567890123', '1995-03-10', 'ricardo@email.com', 110.00, 1.85, 2),
('Mariana Costa', '45678901234', '1985-08-25', NULL, 62.00, 1.70, 3),
('Pedro Santos', '56789012345', '1965-12-30', 'pedro@email.com', 88.00, 1.75, 4),
('Julia Lima', '56789012343', '2010-01-05', 'julia@email.com', 48.00, 1.55, 1);

INSERT INTO instrutores (nome, especialidade, data_contratacao) VALUES 
('Renato Personal', 'Musculação', '2024-06-01'),
('Fabiana Zen', 'Yoga', '2025-02-15'),
('Marcos Iron', 'Crossfit', '2026-01-10'),
('Cláudia Dance', 'Zumba', '2025-11-20');

INSERT INTO treinos (id_aluno, id_instrutor, data_criacao, objetivo) VALUES 
(7, 1, '2026-04-01', 'Perda de Peso'),
(8, 3, '2026-04-10', 'Hipertrofia'),
(9, 1, '2026-04-12', 'Condicionamento'),
(10, 4, '2025-12-15', 'Fisioterapia');

INSERT INTO exercicios (nome_exercicio, equipamento) VALUES 
('Supino Reto', 'Barra'),
('Supino Inclinado', 'Haltere'),
('Agachamento Hack', 'Máquina'),
('Rosca Direta', 'Halter'),
('Leg Press 45', 'Máquina'),
('Desenvolvimento Articulado', 'Máquina'),
('Remada Curvada', 'Barra');

INSERT INTO itens_treino (id_treino, id_exercicio, series, repeticoes) VALUES 
(5, 1, 3, 12),
(6, 3, 4, 15),
(7, 1, 4, 8),
(8, 7, 3, 10);


-- SELECTS AULA 03 --

-- alunos
select * from alunos;

select * from alunos order by data_nascimento desc;

select * from alunos where id = 12;

select * from alunos
where id_plano = 4
order by data_nascimento asc;

select nome, email, peso, altura from alunos
where peso > 90 and altura < 1.70;

select nome, data_nascimento from alunos 
where data_nascimento > '2008-01-01'
or data_nascimento < '1966-01-01' 
order by data_nascimento desc;

-- exercicios
select * from exercicios;

-- 1.
select * from exercicios
where equipamento = 'halter'
or equipamento = 'barra';

-- 2.
select * from exercicios 
where equipamento in ('halter', 'barra');

select * from exercicios
where equipamento != 'maquina';


-- instrutores
select * from instrutores;

select nome, especialidade from instrutores 
where especialidade = 'crossfit'
or data_contratacao >= '2026-01-01';

-- sf + tab = select * from
select * from instrutores;


select * from alunos
where email is null;

select * from alunos
where email is not null;


-- UPDATES AULA 03 --
 
select * from planos;

update planos set nome = 'Plano Trimestal Bronze'
where id = 5;


select * from alunos;

update alunos set peso = 60
where id = 8;

-- DELETES -- 

delete from planos where id = 5;