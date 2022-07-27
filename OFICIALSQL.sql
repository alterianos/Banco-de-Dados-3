/*Estatística */

/*Mostrando uma quantidade de linhas limitadas */
select *from funcionarios
limit 2;

/*Qual o gasto total  se sálario pago pela empresa*/
select sum(salario) from funcionarios;

/*Qual o montante  total que cada departamento recebe  de sálario*/
select sum(salario) as "Total gasto por departamento", departamento from funcionarios
group by departamento;

/* Por departamento , qual  o total  e a média paga para os funcionários */

select sum(salario), avg(salario) as "Média", departamento from 
funcionarios
group by departamento;

/*Ordenando*/
select departamento, sum(salario), avg(salario) as "Média" from 
funcionarios
group by departamento
order by 3;

/* O servidor de máquinas gerou um arquivo de log csv.
Vamos importá-lo e analisá-lo dentro do nosso banco */

/*Importando CSV*/
CREATE TABLE MAQUINA(
MAQUINA VARCHAR(20),
    DIA INT,
    QUANTIDADE NUMERIC(10,2)
);



COPY MAQUINA 
FROM 'C:\Scripts SQL\LogMaquinas.csv'
DELIMITER ','
CSV HEADER;

select * from maquina;

DROP TABLE MAQUINA;

/*Qual a média de cada máquina */ 

select  maquina, avg(quantidade) as "Média de cada máquina"
from maquina
group by maquina
order by 2 desc;


/*Arredondando*/

select  maquina, round(avg(quantidade),2) as "Média de cada máquina"
from maquina
group by maquina
order by 2 desc;

/*Qual é a moda da quantidade */

select maquina, quantidade, count(*)moda
from maquina
group by maquina, quantidade
order by 3 desc;


/* Qual a moda das quantidades de cada máquina */
select maquina, quantidade, count(*) from maquina
where maquina  = 'Maquina 01'
group by maquina, quantidade 
order by 3 desc
limit 1;

/*Qual a moda do meu data ser inteiro */

select  quantidade, count(*) as "MODA" from maquina
group by  quantidade 
order by 2 desc;

/*Qual o máximo, mínimo e a amplitude de cada máquina*/

  select maquina,
         max(quantidade) as "MÁXIMO",
		 min(quantidade) as "MÍNIMO",
		 MAX(quantidade) - MIN(quantidade) as AMPLITUDE
		 FROM MAQUINA
		 GROUP BY MAQUINA 
		 ORDER BY 4 DESC;
		 
/* ACRESCENTE A MÉDIA AO RELATÓRIO*/
 select maquina,
         round(avg(quantidade),2) as MEDIA,
         max(quantidade) as "MÁXIMO",
		 min(quantidade) as "MÍNIMO",
		 MAX(quantidade) - MIN(quantidade) as AMPLITUDE
		 FROM MAQUINA
		 GROUP BY MAQUINA 
		 ORDER BY 4 DESC;
		 
		 
/*DESVIO PADRÃO E VARIÂNCIA */
STDDEV_POP(coluna)
var_pop(coluna)

 select maquina,
         round(avg(quantidade),2) as MEDIA,
         max(quantidade) as "MÁXIMO",
		 min(quantidade) as "MÍNIMO",
		 MAX(quantidade) - MIN(quantidade) as AMPLITUDE,
		 round(STDDEV_POP(quantidade),2) as DESVIO_PADRAO,
         round(var_pop(quantidade),2) as VARIÂNCIA
		 FROM MAQUINA
		 GROUP BY MAQUINA 
		 ORDER BY 4 DESC;
/*MEDIANA FUNÇÃO */
CREATE OR REPLACE FUNCTION _final_median(numeric[])
   RETURNS numeric AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;

/*FUNÇÃO AGREGADA QUE CHAMA A PRIMEIRA */
CREATE AGGREGATE median(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

/* mediana de cada máquina */
SELECT round(MEDIAN(QUANTIDADE),2) AS MEDIANA FROM MAQUINA
WHERE MAQUINA = 'Maquina 01'

SELECT round(MEDIAN(QUANTIDADE),2) AS MEDIANA FROM MAQUINA
WHERE MAQUINA = 'Maquina 02'

SELECT round(MEDIAN(QUANTIDADE),2) AS MEDIANA FROM MAQUINA
WHERE MAQUINA = 'Maquina 03'


INSERT INTO MAQUINA VALUES ('Maquina 01', 11, 15.9);
INSERT INTO MAQUINA VALUES ('Maquina 02', 11, 15.4);
INSERT INTO MAQUINA VALUES ('Maquina 03', 11, 15.7);
INSERT INTO MAQUINA VALUES ('Maquina 01', 12, 30);
INSERT INTO MAQUINA VALUES ('Maquina 02', 12, 24);
INSERT INTO MAQUINA VALUES ('Maquina 03', 12, 45);

/* FUNÇÃO E ANÁLISE DE MEDIANA  NO ARQUIVO - 02 FUNÇÃO DE MEDIANA.SQL*/
/*
  QUANTIDADE
  TOTAL
  MEDIA 
  MAXIMO
  MINIMO 
  AMPLITUDE
  */
  
  
SELECT MAQUINA,
  COUNT(QUANTIDADE) AS "QUANTIDADE",
  SUM(QUANTIDADE)   AS "SOMA",
  AVG(QUANTIDADE)   AS "MEDIA",
  MAX(QUANTIDADE)  AS "MAXIMO",
  MIN(QUANTIDADE) AS "MINIMO",
  MAX(QUANTIDADE) - MIN(QUANTIDADE) AS "AMPLITUDE, TOTAL",
  ROUND(VAR_POP(QUANTIDADE),2) AS "VARIÂNCIA",
  ROUND(STDDEV_POP(QUANTIDADE),2) AS "DESVIO PADRÃO",
  ROUND(MEDIAN(QUANTIDADE),2) AS "MEDIANA",
  ROUND((STDDEV_POP(QUANTIDADE) / AVG(QUANTIDADE)) * 100,2) AS "COF. VARIACAO"
  FROM MAQUINA
  GROUP BY MAQUINA
  ORDER BY 1



/*delete from maquina where dia = 11 or dia = 12;*/

select *from maquina
/*moda  - mode() within  group by (order by coluna)*/

SELECT MAQUINA, MODE() group(ORDER BY QUANTIDADE) AS "MODA" 
FROM MAQUINA
GROUP BY MAQUINA;



SELECT MAQUINA,
  COUNT(QUANTIDADE) AS "QUANTIDADE",
  SUM(QUANTIDADE)   AS "SOMA",
  AVG(QUANTIDADE)   AS "MEDIA",
  MAX(QUANTIDADE)  AS "MAXIMO",
  MIN(QUANTIDADE) AS "MINIMO",
  MAX(QUANTIDADE) - MIN(QUANTIDADE) AS "AMPLITUDE, TOTAL",
  ROUND(VAR_POP(QUANTIDADE),2) AS "VARIÂNCIA",
  ROUND(STDDEV_POP(QUANTIDADE),2) AS "DESVIO PADRÃO",
  ROUND(MEDIAN(QUANTIDADE),2) AS "MEDIANA",
  ROUND((STDDEV_POP(QUANTIDADE) / AVG(QUANTIDADE)) * 100,2) AS "COF. VARIACAO",
  MODE() WITHIN GROUP(ORDER BY QUANTIDADE) AS "MODA" 
  FROM MAQUINA
  GROUP BY MAQUINA
  ORDER BY 1
