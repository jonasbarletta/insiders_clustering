# Identificação de Clientes de Alto Valor

<p align="center">
  <img src="https://altamiraweb.net/wp-content/uploads/2020/07/tipos-de-clientes-y-como-tratarlos-1024x649.jpg" />
</p>

'Identificação de Clientes de Alto Valor' é um projeto de Ciências de Dados que utliza técnicas de agrupamento (clusterização) de clientes de um E-Commerce (fictício).

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

## 3.6 Análise Exploratória dos Dados

### 3.6.1 Análise Univariada



### 3.6.2 Análise Bivariada


## 3.7 Seleção dos Atributos



## 3.8 Algoritmos de Machine Learning



### 3.8.1 KNN (K-Nearest Neighbors)



### 3.8.2 Regressão Logística


### 3.8.3 Extra Tree 


### 3.8.4 Random Forest



### 3.8.5 Light Gradient Boost Machine (LGBM)


## 3.9 Avaliação do Algoritmo

### 3.9.1 Performance de Negócio


### 3.9.2 Performance do Modelo


## 3.10 Deploy do Modelo em Produção



# 4 Etapas do Segundo Ciclo do Projeto

## 4.1 Features Engineering 

## 4.2 Performance dos Modelos

## 4.3 Performance de Negócio

## 4.4 Deploy do Modelo em Produção

# 5 Conclusão

# 6 Próximos Passos
 
# 6 Referências


