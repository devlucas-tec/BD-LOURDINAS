-- AULA 07 -- 
-- FUNÇÕES --

use db_academia_fitflow;


-- LENGTH 

select
	nome,
	cpf
from
	alunos
where
	length(cpf) = 11;


-- LOWER e UPPER

select UPPER(email) from alunos;

select LOWER(nome) from alunos;


-- SUBSTRING / SUBTR

select
	nome,
	SUBSTR(data_nascimento, 1, 4) 'ano_nascimento'
from
	alunos;


-- INSTR

select
	email,
	INSTR(email, '@')
from
	alunos;


-- REPLACE 

select REPLACE(objetivo, 'a', '@') from treinos;


-- ROUND e TRUNCATE

select
	altura,
	ROUND(altura, 1)
from
	alunos;


select
	altura,
	TRUNCATE(altura, 1)
from
	alunos;


-- current_timestemp pega a data atual no insert

-- timestampdiff 
select
	nome,
	timestampdiff(year, data_nascimento, curdate()) as idade
	-- curdate é dia atual
from
	alunos;


-- IFNULL

select
	nome,
	IFNULL(email, 'Sem E-mail') email
from
	alunos;


--  criar função para calcular quanta agua uma pessoa precisa conforme seu peso

create function fn_calcula_agua(peso decimal(5, 2))
returns decimal(10, 2)
deterministic
begin
	return peso * 0.035;
end

select
	nome,
	peso,
	fn_calcula_agua(peso) as litros_agua
from
	alunos;


-- caso peso seja menos que 60 - leve
-- menor q 90 - medio
-- maior q 90 - pesado

create function fn_classifica_peso(peso decimal(5, 2))
returns varchar(10)
deterministic
begin
	declare categoria varchar(10);
	
	if peso < 60 then set categoria = 'LEVE';
	elseif peso <= 90 then set categoria = 'MÉDIO';
	else set categoria = 'PESADO';
	end if;
	
	return categoria;
end


select
	nome,
	peso,
	fn_classifica_peso(peso) classificacao
from
	alunos;




-- DESAFIO EM AULA
/*
 * Criar uma função chamada fn_status_imc para
 * calcular o IMC e retornar um status simplificado
 * 
 * Fórmula: IMC = peso/(altura*altura)
 * 
 * Regras de Negócio:
 *  Abaixo de 18.5 - Retorno "Abaixo do Peso"
 *  Entre 18.5 e 24.9 - Retorno "Peso Normal"
 *  25 ou mais - Retorno "Sobrepeso"
 */

create function fn_status_imc(peso decimal(5,2), altura decimal(3,2))
returns varchar(50)
deterministic
begin
	declare resultado varchar(30);
	declare imc decimal(5, 2);
	declare resultado_concat varchar(50);

	set imc = peso/(altura*altura);

	if imc < 18.5 then set resultado = 'Abaixo do peso';
	elseif imc >= 18.5 and imc < 25 then set resultado = 'Peso Normal';
	else set resultado = 'Sobrepeso';
	end if;
	
	set resultado_concat = concat('IMC: ', imc, ' - ', resultado);
	
	return resultado_concat;
end


select
	nome,
	peso,
	altura,
	fn_status_imc(peso, altura) imc
from
	alunos;



/*
 * Criar uma função fn_perfil_plano que receba o 
 * valor mensal e retorne a categoria do plano
 * 
 * Regras de Negócio:
 *  Menor que 100 - retorno "Econômico"
 * 	Entre 100 e 200 - retorno "Padrão"
 *  Acima de 200 - retorno "Premium"
 */

select * from planos;

create function fn_perfil_plano(valor_mensal decimal(10,2))
 returns varchar(20) deterministic
 begin
 	declare categoria varchar(20);

	case 
		when valor_mensal < 100 then set categoria = 'Econômico';
		when valor_mensal >= 100 and valor_mensal <= 200 then set categoria = 'Padrão';
		else set categoria = 'Premium';
	end case;
	
	return categoria;
 end
 
 select
	nome,
	valor_mensal,
	fn_perfil_plano(valor_mensal) perfil_plano
from
	planos;
 



