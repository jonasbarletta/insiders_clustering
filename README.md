# Identificação de Clientes de Alto Valor

<p align="center">
  <img src="https://altamiraweb.net/wp-content/uploads/2020/07/tipos-de-clientes-y-como-tratarlos-1024x649.jpg" />
</p>

'Identificação de Clientes de Alto Valor' é um projeto de Ciências de Dados que utliza técnicas de agrupamento (clusterização) de clientes de um E-Commerce (fictício) via aprendizagem de máquina não supervisionada.

Esse projeto é uma proposta, da Comunidade DS, os dados que utilizaremos foram publicado pela 'The UCI Machine Learning Repository' e estão disponíveis em [Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data).

# 1 Contextualização e Questão de Negócio

**Antes de começar a leitura atente-se de que o contexto é completamento fictício, a empresa, o CEO, as perguntas de negócio, etc... tudo foi pensado para simular uma empresa real.**

A empresa All In One Place é uma empresa Outlet Multimarcas, ou seja, ela comercializa produtos de segunda linha de várias marcas a um preço menor, atraveś de um e-commerce. 

Em um pouco mais de 1 ano de operações, o time de marketing percebeu que alguns clientes compram produtos mais caros, com mais frequência e acabam contribuindo com uma parcela significativa do faturamento da empresa.

Baseado nesa percepção, o time de marketing vai lançar um programa de fidelidade para os melhores clientes da base, chamado Insiders. Mas eles não possuem um conhecimento avançado em análise de dados para eleger os participantes do programa.

Por esse motivo, o time de marketing requisitou ao time de dados uma seleção de clientes elegíveis ao programa, usando técnicas avançadas de manipulação de dados. 

1.1 Objetivos

- Entregar uma lista com indicações de pessoas para fazer parte do programa de fidelidade "INSIDERS".
- Relatório com as respostas para as seguintes perguntas:
   * Quem são as pessoas elegíveis para participar do programa de Insiders ?
   * Quantos clientes farão parte do grupo ?
   * Quais as principais características desses clientes ?
   * Qual a porcentagem de contribuição do faturamento, vinda do Insiders ?
   * Qual a expectativa de faturamento desse grupo para os próximos meses ?
   * Quais as condições para uma pessoa ser elegível ao Insiders ?
   * Quais as condições para uma pessoa ser removida do Insiders ?
   * Qual a garantia que o programa Insiders é melhor que o restante da base ?
   * Quais ações o time de marketing pode realizar para aumentar o faturamento ?

# 2 Planejamento da Solução

Para solução do desafio dividimos em algumas etapas cíclicas, utilizando a metodologia CRIPS-DS (como mostra a imagem abaixo). Até chegarmos no ciclo que será apresentado nesse texto fizemos diversos outros, de tal forma que em poucos dias já foi apresentada uma solução possível para o problema. Mas como já mencionado, falaremos apenas sobre as etapas do último ciclo.

![alt text](https://miro.medium.com/max/1400/1*z0U0taZoignUB7aQ4ZsOtg.png)

### 2.1 Produto Final

- Lista com as indicações de clientes 'Insiders'.
- Relatório com as respostas para as perguntas.
- Dashboard.
- Deploy do Notebook em produção na AWS: arquivos na S3, Banco de Dados Postgres (RDS), EC2 para rodar o Notebook.

## 2.2 Ferramentas Utilizadas
- Python 3.9.12
- Jupyter Notebook
- Github
- SQLite
- Postgres
- AWS (S3, RDS, EC2)
- Looker Studio

# 3 Etapas do Último Ciclo do Projeto

## 3.1 Entendimento do Negócio
Para entender o negócio começamos pelas perguntas realizadas, nesse sentido alguns tópicos foram listados para motivar a resolução do problema e encontrar possíveis caminhos.

1. **Quem são as pessoas elegíveis para participar do programa de Insiders ?**
    - O que é ser elegível? O que são clientes de maior valor?
    - Faturamento:
        - Alto Ticket Médio
        - Alto LTV (Life Time Value)
        - Baixo recência
        - Alto basket size (quantidade média de produtos comprados)
        - Baixa probabilidade de Churn
        - Previsão alta de LTV
        - Alta propensão de compra
    - Custo:
        - Baixa taxa de devolução
        
    - Experiência:
        - Alta média de avaliação
2. **Quantos clientes farão parte do grupo?**
     - Número de clientes
     - Porcentagem do total
     
3. **Quais as principais características desses clientes ?**
    - Escrever os principais atributos dos clientes
        - Idade
        - Localização
        - Salário
    - Escrever as principais característica de consumo
        - Atributos de Clusterização

4. **Qual a porcentagem de contribuição do faturamento, vinda do Insiders ?**
    - Faturamento total do ano
    - Faturamento do grupo de Insiders

5. **Qual a expectativa de faturamento desse grupo para os próximos meses ?**
    - LTV do grupo Insiders
    - Série temporais (ARMA, ARIMA, HoltWinter, etc)

6. **Quais as condições para uma pessoa ser elegível ao Insiders ?**
    - Definir a periodicidade (1 mês, 2 meses, 3 meses...)
    - A pessoa precisa de parecido/similiar com outras que já estão no grupo

7. **Quais as condições para uma pessoa ser removida do Insiders ?**
    - Definir a periodicidade (1 mês, 2 meses, 3 meses...)
    - A pessoa não ser parecido/similiar com outras que já estão no grupo    

8. **Qual a garantia que o programa Insiders é melhor que o restante da base ?**
    - Teste A/B
    - Teste A/B de Bayesiano
    - Teste de hipótese
        
9. **Quais ações o time de marketing pode realizar para aumentar o faturamento ?**
    - Desconto
    - Preferências de escolha
    - Produtos exclusivos

## 3.2 Coleta de Dados
Os dados já estavam coletados antes do início do projeto o que adiantou essa etapa do projeto. Vejamos então quais são as dados que possuímos.

| Atributo                          | Descrição                |  
| --------------------------------  | ------------------------ |
| InvoiceNo                         | Número da Compra         |   
| StockCode                         | Código do Produto        |
| Description                       | Descrição do Produto     |
| Quantity                          | Quantidade Comprada      |
| InvoiceDate                       | Data da Compra           |
| UnitPrice                         | Preço Unitário do Produto|
| CustomerID                        | ID do Cliente            |
| Country                           | País do Cliente          |

## 3.3 Análise Descritiva

Analisar os dados de uma forma global é importante para se entender que tipo de dados serão estudados e modelados. Nessa etapa, buscamos entender a quantidade de linhas e colunas do conjunto de dados, se há ou não valores faltantes, os tipos das variáveis, se as variáveis numéricas formam ou não uma distribuição normal e como estão distribuidas a variáveis categóricas. Nessa etapa não é esperado encontrar grandes resultados ou insights, mas é essencial para o entendimento dos dados. As principais ações que fizemos aqui foram:

- Troca nos nomes das colunas para o estilo 'snake_case';
- Acrescentar ID de clientes que estavam faltantes;
- Trocar os tipos dos dados;
- Estatística descritiva;
- Entendimento de alguns números de compra que possuíam letras:
  - Todos os invoice_no que começam com a letra 'C' possuem quantity negativo. Isso pode significar 'Cancel', 'Change' ou 'Chargeback'.
  - Todos os inovice_no que começam com 'A' são descritos como 'Adjust bad debt' e 2 deles possuem unit_price negativo. São apenas três linhas, excluiremos esses dados.
- Entendimento de alguns códigos de produto estranhos
  - stock_code = 'POST' pode representar envio de carta;
  - stock_code = 'D' representa algum tipo de desconto que o cliente recebeu;
  - stock_code = 'C2' pode representar algum tipo de frete;
  - stock_code = 'M' ou 'm' tem descrição 'Manual', talvez sejam itens que foram acrescentados manualmente;
  - stock_code = 'BANK CHARGES' deve ser alguma taxa de banco, porem são pouquissímos resultados com essa característica, podemos descarta-los sem nenhuma preocupação;
  - stock_code = 'PADS' podemos descartar sem nenhuma preocupação;
  - stock_code = 'DOT' é algum tipo de postagem, mas que diferente do 'POST' possui valores bem maiores e apenas um cliente utilizou esse tipo de postagem (cliente com customer_id = 14096);
  - CRUK (Cancer Research UK) Commission: Todos os 'stock_code' == 'CRUK' possuem quantity negativa, o que deve significar um desconto/taxa/doação para a instituição Cancer Research UK;
  - stock_code = 'S' possuem descrição 'SAMPLES', o que deve significar que são amostras de determinado produto. Todos as linhas são de clientes com customer_id > 18500, ou seja, são clientes que não estavam na base de dados inicialmenter;
  - 'AMAZONFEE' deve tratar sobre algumas taxa da Amazon. Todos as linhas são de clientes com customer_id > 18500, ou seja, são clientes que não estavam na base de dados inicialmente;
  - stock_code que começam com DCGS parecem compras normais. Todos as linhas são de clientes com customer_id > 18500, ou seja, são clientes que não estavam na base de dados inicialmente;
  - stock_code que começam com 'gift' são compras de voucher de presente. Todos as linhas são de clientes com customer_id > 18500, ou seja, são clientes que não estavam na base de dados inicialmente;
  - stock_code = 'B' são as mesmas linhas que possuem invoice_no começando com 'A', que já discutimos anteriormente e serão dropadas.

## 3.4 Limpeza dos Dados
Diante das informações geradas na Análise Descritiva faremos as seguintes considerações quanto a limpeza dos dados.

- Vamos 'dropar' as linhas com os stock_code: 'POST', 'C2', 'BANK CHARGES', 'PADS', 'DOT', 'CRUK', 'S', 'AMAZONFEE', 'B'.
- Vamos deixar as linhas com os stock_code: 'D', 'M', 'DCGS...', 'gift...'
- Não seguiremos com as compras que estavam sem ID de cliente incialmente.
- O cliente 14096 possui valores alto com 'DOT' e 'CRUK' que estamos dropando, ficaremos atentos nesse cliente em específico.

## 3.5 Preparação dos Dados

Baseado no contexto de negócio criamos alguns atributos que nos ajudarão na classificação dos clientes:
  - Faturamento 
  - Recência
  - Quantidade de compras realizada
  - Quantidade de produtos comprados
  - Quantidade de produtos únicos comprados
  - Ticket médio
  - Recência média entre compras
  - Frequência de compras
  - Números de compras retornadas
  - Média da quantidade de produtos por compra
  - Média da quantidade de produtos únicos por compra

## 3.6 Análise Exploratória dos Dados sem Agrupamento

Nessa etapa realizamos apenas a Análise Univarida dos atributos, pois se após o definirmos o modelo de ML que agruparará os dados faremos outra EDA e dessa vez com geração de hipóteses. Também realizamos o Estudo do Espaço utlizando ferramentas como PCA, UMAP, t-SNE e Embedding de Árvore.

### 3.6.1 Análise Univariada

Com o auxílio da biblioteca 'pandas_profiling' gerou um relatório (outputv2.html) completo sobre todos o atributos. Com isso em mãos avaliamos 

- Min, Max, Range
- Média, Mediana
- Desvio Padrão e Variância
- Coeficiente de Variação (CV)
- Distribuição
- Presença de Outliers

Assim pudemos retirar alguns clientes que não poderiam atrapalhar o modelo.

### 3.6.2 Estudo do Espaço

Com o objetivo de fazer um 'Estudo do Espaço' é entender como os dados estão dispostos espacialmente. Como cada atributo representa uma dimensão espacial temos que reduzir a dimensionalidade dos dados para conseguir visualizá-los, para isso utilizamos o PCA, UMAP e o t-SNE. 

Porém apenas a utilização dessas técnicas não nos permitiu uma visualização bem dividida dos dados, ou seja, não houve grupo bem definidos. Para isso utlizamos a técnica de Embedding de Árvore que consiste em treinar uma Random Forest de Regressão com relação a um dos atributos (no caso escolhemos o faturamento que no fundo é o atributo mais relevante) e salvar em um dataframe os índices das folhas de cada árvore da Random Forest para cada cliente. Utilizamos o modelo com 2000 árvores, ou seja, o dataframe resultando tinha 2000 colunas. Para visualizar esses dados utilizamos novamente o UMAP e o resultado da visualização foi o seguinte:

![download](https://user-images.githubusercontent.com/102927918/211903874-34136af5-b7ec-4b03-bd0b-0e06b767c6b7.png)

Com essa visualização conseguimos perceber claramente alguns grupos bem definidos no espaço.

## 3.7 Seleção dos Atributos

Após diversas análises optamos com utilizar todos os atributos.

## 3.8 Ajuste dos Hiperparâmetros

Por se tratar de um problema de agrupamento em que não sabemos a quantidade de grupos buscamos, é necessário investigar as melhores possibilidades. Testamos quatro modelos e calculamos o Silhouette-Score para diferentes quantidades de grupos.
- K-means
- GMM
- Clusterização Hierárquica
- DBSCAN
Os resultados encontrados foram:

| Modelo | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
| ------ | - | - | - | - | - | - | - | - | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
|K-Means |0.412361|	0.453998|	0.478776|	0.521904|	0.525653|	0.561198|	0.565688|	0.565172|	0.593253|	0.590211|	0.613277|	0.626506|	0.633926|	0.650972|	0.632148|	0.633645|	0.633933|	0.641634|	0.619455|
|GMM     |0.411627|	0.442742|	0.430280|	0.411864|	0.519308|	0.524349|	0.473878|	0.549574|	0.548056|	0.588109|	0.609684|	0.602823|	0.641990|	0.573931|	0.639040|	0.625853|	0.634174|	0.629917|	0.645682|
|HC	    |0.351464|	0.456040|	0.475842|	0.522344|	0.527884|	0.563879|	0.565799|	0.575760|	0.596701|	0.618978|	0.631933|	0.629037|	0.646092|	0.657518|	0.638436|	0.640209|	0.635644|	0.633423|	0.628518|
|DBSCAN |	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|	0.563870|	0.580778|	0.582588|	0.542229|	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|	0.000000|

Os melhores valores de Silhouette-Score foram para quantidade de grupos muito altas quando pensadas para o negócio, seria muito ruim para o time de marketing ter que analisar 20 grupos diferentes. Pensando nisso, buscamos uma quantidade mais reduzida de grupos mas sem diminuir muito a métrica. 

## 3.8 Algoritmos de Machine Learning

Após alguns teste optamos por treinar o modelo de Clusterização Hierárquica com 10 grupos. O resultado visual desee agrupamento ficou assim:

![image](https://user-images.githubusercontent.com/102927918/211909610-792835b2-d6af-41f4-bc4e-083d5345e766.png)

## 3.9 Análise dos Grupos

Para analisar os grupos calculamos o seguintes atributos para cada um deles:
- Números de clientes
- Número de clientes em porcentagem
- Faturamento médio 
- Valor devolvido
- Recễncia média em dias
- Quantidade de compras média
- Quantidade de itens comprados média
- Quantidade de produtos únicos comprados méidia
- Média do ticket médio
- Frequência média
- Quantidade de produtos retornados

Baseado nessas característica nomeamos os grupos da seguinte maneira:
- Grupo 02: Insiders
- Grupo 06: De Olho na Recência
- Grupo 03: Precisam Gastar Mais E Retornar Menos!
- Grupo 00: Atenção com a Recência!!
- Grupo 07: Comprem mais vezes
- Grupo 01: Baixa Frequência
- Grupo 09: Limbo entre Mediano e Ruim
- Grupo 05: Muita Gente, Com Retorno Relativamente Alto.
- Grupo 04: Gastam Pouco mas Retornam Pouco.
- Grupo 08: Poucos Clientes Que Quase Nunca Compram

## 3.10 Análise Exploratória dos Dados Agrupados

Agora com os grupos formados, utlizamos o seguinte mapa mental para gerar hipóteses de negócio e assim verificar a veracidade delas.

![Clusterizao_de_Clientes](https://user-images.githubusercontent.com/102927918/211912247-02f7a162-4231-4eed-90a3-7bbf78d7991a.png)

### 3.9.1 Principais Hipóteses de Negócio

- **H1 O grupo insiders possui um volume (itens) de compras acima de 10% do total de compras.**

Verdadeiro. O Volume de compras (items) do Grupo Insiders é 60.39 % do total.

- **H2 O cluster insiders possui um volume (faturamento) de compras acima de 10% do total de compras.**

Verdadeiro. O Volume de compras (faturamento) do Grupo Insiders é 58.96 % do total.

- **H3 Os clientes do cluster insiders tem um número de devolução abaixo da média da base total de clientes.**

Falso. A média do número de devoluções Grupo Insiders x média total é de 154.45 x 24.71

## 3.10 Perguntas de Negócio

Vamos agora voltar as perguntas iniciais para respondê-las com a solução encontrada. 

1. Quem são as pessoas elegíveis para participar do programa de Insiders ?
2. Quantos clientes farão parte do grupo ?
3. Quais as principais características desses clientes ?
4. Qual a porcentagem de contribuição do faturamento, vinda do Insiders ?
5. Qual a expectativa de faturamento desse grupo para os próximos meses ?
6. Quais as condições para uma pessoa ser elegível ao Insiders ?
7. Quais as condições para uma pessoa ser removida do Insiders ?
8. Qual a garantia que o programa Insiders é melhor que o restante da base ?
9. Quais ações o time de marketing pode realizar para aumentar o faturamento ?

As respostas para as perguntas 1, 2, 3, 4 estão respondidas nesse [Dashboard](https://datastudio.google.com/s/lp9DxpioCQg). Com relação as peguntas 6 e 7, a entrada e saída de clientes dos grupos são feitas pelo modelo. As perguntas 5, 8 e 9 ficarão para um próximo ciclo.

## 3.11 Deploy do Modelo em Produção

Para que o modelo possa ser rodado com mais dados no futuro e tal forma que novos clientes possam ser inseridos no grupo Insiders ou antigo clientes retirados, pensamos na seguinte estrutura de deploy utilizando ferramentas e recursos AWS.

![Estrutura de Deploy](https://user-images.githubusercontent.com/102927918/211918492-2f7c62ea-8b60-45ec-963b-172bf7af5bf8.png)

Começando pelo Notebook de Deploy, salvamos adicionamos ele no GitHub. Do GitHub, instanciamos uma máquina EC2 para rodar o modelo o notebook em nuvem, para isso utilizamos a S3 para armazenar os arquivos necessários juntament com o Papermill com Cronjob para rodar o Notebook de tempos em tempos. Após isso os dados finais são salvos em na AWS RDS (Banco de Dados Relacional Postgres), dessa forma agora os dados podem ser acessado por qualquer membro do time para gerar Insights ou Dashboards para apresentações.

A maior parte do processo funcionou perfeitamente, porém a máquina EC2 que é disponibilizada pela Amazon gratuitamente não tem memória RAM suficiente para rodar a etapa de redimensionalidade. Por esse motivo o notebook foi rodado localmente, utilizando os arquivo na S3 e criando o Banco de Dados. E assim foi possível gerar o Dashboard mostrado anteriormente.

# 4 Conclusão

O projeto foi bastante desafiador principalmente por se tratar de um problema de agrupamento que é natural não termos tantos parâmetros para analisar a performance do modelo. Mesmo assim, o agrupamento realizado cumpriu os objetivos de negócio e está pronto para guiar os futuros programas de fidelidade da empresa permitindo que o time de marketing aja de forma acertiva em cada grupo.

# 5 Próximos Passos

Para as próximas etapas:

- Adquirir uma máquina EC2 mais potente para finalizar o deploy do modelo;
- Testar a redimensionalização dos dados para três dimensões em vez de duas;
- Responder as perguntas faltantes;
- Inserir mais funcionalidades no dashboard.
 
# 6 Referências

[1] LOPES, Meigarom. Curso DS em Clusterização - Comunidade DS.

[2] The UCI Machine Learning Repository, http://archive.ics.uci.edu/ml/index.php, último acesso: 12/10/2023
