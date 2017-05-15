# cursoPLSql Coti Informática - 17/05/2017

##Ementa:

###Introdução ao Oracle

SQL*Plus
Iniciando no SQL*Plus
Tipos de dados
Usando SQL*Plus
Exibindo a estrutura de uma tabela
Editando instruções SQL
Salvando, e recuperando arquivos
Formatando colunas
Definindo tamanho da pagina
Limpando formatação das colunas
Definindo o tamanho da linha
Usando variáveis
Variáveis temporárias
Variáveis definidas
Criando relatórios simples
Usando variáveis temporárias em scripts
Usando variáveis definidas em scripts
Entendo a ajuda do SQL*Plus
Obtendo ajuda do SQL*Plus
 

###Criação de objetos de banco de dados (Tabelas, índices, visões, seqüências)

Criando tabelas
Obtendo informações das tabelas
Alterando uma tabela
Mudando o nome de uma tabela
Truncando uma tabela
Excluindo uma tabela
Seqüência
Criando uma seqüência
Recuperando informações da seqüência
Preenchendo uma chave primaria com uma seqüência
Excluindo uma seqüência
Índices
Criando um índice de arvore
Criando um índice baseado em uma função
Excluindo um índice
Visões
Criando uma visão
Modificando uma visão
Excluindo uma visão
Visão Materializada
 

###Introdução a PL/SQL

Cursores
Cursores Explícitos
Cursores Implícitos
Exceções
Registros
Arquivos
Procedures
Functions
Pacotes
Triggers
Vetores
Gravação de  Arquivos com  BLOB, BFILE
Gerando XML a partir de dados relacionais
Atributos do XML
Recuperando XML
Atualizando XML
Trabalhando Com Associação da Dados Dataming utilizando Principio de Tabelas Hierarquicas
Connnect  BY  Prior
 

###Usando Funções do Oracle

Usando funções simples
Usando funções de uma linha
Funções de caractere
Funções numéricas
Funções de conversão
Funções de expressão regular
 

###Usando funções de agregação
Agrupando linhas
Usando GROUP BY
Usando HAVING para filtrar grupos de linhas
Usando WHERE e GROUP BY juntas
USANDO WHERE, GROUP BY e HAVING 
 

###Trabalhando com datas no Oracle
Armazenando e recuperando datas
Convertendo data/horário com TO_CHAR () e TO_DATE ()
Usando TO_CHAR () para converter em string
Usando TO_DATE () para converter em uma data
Configurando o padrão de data
Interpretando datas no Oracle
Usando funções de datas
ADD_MONTHS ()
LAST_DAY ()
MONTHS_BETWEEN ()
NEXT_DAY ()
SYSDATE
TRUNC
ROUND
 

###Trabalhando com fuso-horário
Fuso horário do banco e fuso horário da sessão
Diferença de fuso horário
Usando timestamp
Funções timestamp
Usando intervalo de tempo
INTERVAL YEAR TO MONTH
 INTERVAL DAY TO SECOND
Funções de intervalo de tempo
 

###Efetuando consultas em uma tabela no Oracle

Executando consultas (SELECT)
Executando consultas com campos específicos
Executando consultas com filtros WHERE
Identificadores de linhas
Numero de linhas
Efetuando cálculos aritméticos
Efetuando aritmética com datas
Usando apelidos para colunas
Concatenando saídas
Valores nulos
Usando operadores SQL
Usando operador LIKE, IN, BETWEEN
Usando operadores lógicos
Aprendendo a precedência de operadores
Classificando linhas com ORDER BY
SELECT em duas tabelas
Produtos cartesianos
SELECT em mais de duas tabelas
Condições de Junções (Joins)
Tipos de Joins
Joins não iguais
Autojoins
Sub-consultas
Tipos de sub-consultas
Escrevendo sub-consultas de uma única linha.
Sub-consulta em uma cláusula WHERE
Sub-Consulta em uma cláusula HAVING
Sub-Consulta em uma cláusula FROM (visões inline)
Sub-consultas de varias linhas
Usando IN em uma sub-consultas
Usando ANY
Usando ALL
Escrevendo sub-consultas de varias colunas
Escrevendo sub-consultas correlacionadas
Usando EXIST E NOT EXIST em uma sub-consulta correlacionada
Sub-consultas aninhadas
Efetuando consultas avançadas
Usando operadores de conjunto
UNION ALL
UNION
INTERSECT
Usando operador
MINUS
Combinando operadores de conjunto
Usando as funções TRASLATE (), DECODE()
Usando expressões CASE
Usando CASE Simples
Usando CASE pesquisadas
Consultas Hierárquicas
Usando as cláusulas CONNECT BY e START WITH
Usando peusdocoluna LEVEL
 

###OLAP
GROUP BY
ROLLUP
CUBE
GROUPING
GROUPING SETS
GROUPING_ID ()

###Usando funções analíticas

Funções de janela
Funções de relatório
Usando LAG () e LEAD ()
Usando FIRST e LAST
Usando a clausula  MODEL
Exemplo de MODEL
Usando notação posicional e simbólica para acessar células
Intervalos de células com BETWEEN e AND
Acessando todas as células com ANY e IS ANY
Obtendo o valor atual de uma dimensão com CURRENTV ()
Acessando células com loop FOR
 

###Usuários, privilégios e atribuições

Criando usuário
Alterando senha, excluindo usuário
Privilégios usuários
Concedendo privilégios
Verificando privilégios
Revogando privilégios
Privilégios de objetos
Concedendo privilégios de um objeto a um usuário;
Verificando privilégios de objeto concedidos
Utilizando privilégios de objeto
Sinônimo
Sinônimos públicos
Atribuições (ROLES)
Criando atribuições
Concedendo
Revogando

###Auditoria

Privilégios necessários para auditorias
Visões de trilha de auditoria
 

###Controle de transações

Confirmando e revertendo uma transação
Iniciando uma transação
Savepoints
Consultas Flashback
Concedendo o privilégio de usar flashback
Flashback de tempo Opções de backup e recuperação
Restaurando um arquivo de dados
Criando Backup  com Triggers
Criando Backup  com PLSQL
Criando Backup  com UTL_FILE Gerando Arquivos
Criando Json a partir das tabelas Geradas
Criando tabela Externa, com Importanção de uma Planilha
 Lendo e Varrendo arquivos TXT
Varrendo TXT com Tokens de Separação
Backup com Shedule e Com Job em BackGround
Eliminando nós e ramos de uma consulta hierárquica
Formatando os resultados de uma consulta Hierárquica
Usando uma sub-consulta em uma cláusula START WITH
Incluindo condições em uma consulta hierárquica
 

###Tablespaces, Datafiles e Control Files

Tablespace
Criando diversos tablespace
System
Users
Data Warehouse

###Conceitos de data warehouse
Tipos de modelos de dimensões
Modelo STAR
Conceito de Dimensões
Modelo snow flake
Data Mart
ETL (Processo de Carga)
Conversão de Uma Base como Mysql/POSTGRE Para dentro  do Oracle utilizando Recursos de ETL
Filtrando os dados Com ETL
Buscando os Dados para dentro do Oracle com ETL Excel sendo a fonte de referência dos dados
Gerando Árvore de Decisão com OLAP
 

###DataMining com Plsql e olap

####Introdução ao DataMining Utilizando PLS/SQL COM  Olap com Rotinas

K-Means,
Apriori
(Algoritmos Realizados em Aula)
 

###Gerando Relatórios de saída (XML, TXT, CSV)

XML
Gerando TXT
Criando um arquivo EXCEL
JSON
PDF
DOCS
