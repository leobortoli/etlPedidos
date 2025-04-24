SELECT product_id, SUM(sale_price) AS sales 
FROM pedidos_dataframe
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;
-- o group by faz com que some todos os preços de cada produto, ao invés de somar todos os preços a um produto; a order é definida pelo valor da venda em order descending (decrescente), crescente seria (asc) e o limit 10 faz com que o limite (inclusivo), de itens seja 10, ou seja, os 10 maiores valores dos produtos somados! No mariaDB não existe top 10 diferente do sql server

WITH cte AS( 
SELECT region, product_id, 
SUM(sale_price) AS sales 
FROM pedidos_dataframe
GROUP BY region, product_id
ORDER BY region, sales DESC
)
SELECT * FROM(
SELECT *, ROW_NUMBER()
OVER(PARTITION BY region ORDER BY sales DESC) AS row_num
FROM cte) A
WHERE row_num<= 5
;
--O A é simplesmente um nome pra representar a subquery (inner select) que a permite ser utilizada por outer queries (como um cte, é um set de resultados!). Isso é aliasing.
--cte são expressões temporárias que representam resultados de uma query, podendo ser referenciados e só existem durante a execução! O resultado da query é essencialmente uma tabela virtual derivada de outra utilizando comandos select. Boa prática é definí-las no início, é como se fosse uma função, quebra em pedaços menores pra facilitar 
--nesse caso, mantém-se uma tabela temporária (cte), similar à primeira consulta, com o with e o select interno da segunda metade pega todas as colunas do cte (region, product_id, sales) e utiliza a função ROW_NUMBER() pra adicionar um index em cada linha sobre (over()) PARTITION BY region, o que faz com que ROW_NUMBER() trate cada valor unico em region como uma partição separada, por isso que recomeça em 1 quando muda a região, se não iria de 1 a 20! em order decrescente de sales e nomeia esse index como row_num, tirando esses dados do cte e não do pedidos_dataframe pq houveram alterações! O select externo pega e mostra todas essas colunas!

with cte as (
select YEAR(order_date) as order_year, MONTH(order_date) as order_month,
sum(sale_price) as sales
from pedidos_dataframe
group by YEAR(order_date), MONTH(order_date))
select order_month,
    sum(case when order_year=2022 then sales else 0 end) as sales_2022 ,
    sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month;
--cria o cte onde são criadas as variáveis ano e mês, que juntamente de sales são pegas e agrupadas na tabela virtual. São selecionados os meses e a soma o valor de sales (retorna o valor de sales) SE o ano for 2022 e 2023, caso não, soma 0 (nada), separando cada uma em uma variável, que são selecionadas e agrupadas e ordenadas (para serem comparadas) com base no order_month!

with cte as (
select category,DATE_FORMAT(order_date,'%Y%m') as order_year_month
, sum(sale_price) as sales 
from pedidos_dataframe
group by category,DATE_FORMAT(order_date,'%Y%m')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as row_num
from cte
) a
where row_num=1
--cria o cte onde são mantidas, categoria e a variável nova de ano e mes formatadas como ex: 202212 e as vendas, agrupadas por categoria e data. Inner select pega da cte, os selects (pq eles passam de uma pra outra, herdam) e adiciona row_num como explicado anteriormente e seleciona o maior valor de cada. Outer select seleciona todos esses (herda os selects do inner).

with cte as (
select sub_category,YEAR(order_date) as order_year,
sum(sale_price) as sales
from pedidos_dataframe
group by sub_category,YEAR(order_date))
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) DESC
LIMIT 1;
--cte1 separa valores de data, sub_category e sales como result set, agrupados por sub_category e data. Cte2 seleciona a sub_category e a soma condicional dos anos de 2022 e 2023 de cada, pegando dados da cte1. No final, seleciona da cte2(que seleciona da cte1) todos os dados e a subtração das vendas de 23 e 22 da subcategoria, herda os selects do cte2 e adiciona a subtração, mostra o maior resultado restante da subtração em ordem decresente (maior->menor) com o limite de 1, ou seja, o maior de todos!

