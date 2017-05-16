-- profedsonbelem@gmail.com
-- 98199-0108

-- lucianamedeiros.coti@gmail.com
-- 98201-2525

---------------------------------------------------------------

--entrando como DBA
--@XE
--Logando
--DBA
conn system/coti@XE
--Criando o Usuario
create user aluno001 identified by coti
 default tablespace users
 quota 100m on users;
  
grant create table, create sequence, create procedure,
      create view, create materialized view, create session,
      connect, create trigger to aluno001;  
--NOME DO USUARIO (dicionario de dados)
--DD

 SELECT USER FROM DUAL;
--system

 select name from v$database;
--nome do Banco

 select banner from v$version;
--Version
 
---------------- ?
--Virando usuario
----------------


 conn aluno001/coti

 create table vendas(codigo number(15) primary key,
vendedor varchar2(50),mes number(10),valorvenda number(20,2));

-- não tem identity, na verdade ele usa o sequence;
create sequence seq_vendas;

insert into vendas values(seq_vendas.nextval, 'samuel',1,1000);
insert into vendas values(seq_vendas.nextval, 'samuel',2,1000);
insert into vendas values(seq_vendas.nextval, 'samuel',3,1000);

-- lembre-se sempre de fazer commit;
commit

 create or replace trigger gat_Vendas
  before 
	insert on vendas
	  for each row
	 begin
	  select seq_vendas.nextval into :new.codigo  from dual;
	 end;/

-- como já foi feito o sequence no gatilho, agora basta colocar null em codigo pois o proprio gatilho fará a sequencia correta



insert into vendas values(null, 'Diogo',1,1000);
insert into vendas values(null, 'Diogo',2,1000);
insert into vendas values(null, 'Diogo',3,1000);
commit;

-- fazendo calculos com pl-sql:
select 10 + 9 from dual;
-- resultado: 19


--Relatorio
column vendedor format a15;
 set linesize 400;
 select * from vendas;

-- DD dicionario de dados
select * from cat;

--------------------------------------

PLSQL
--gravar com proc
--consultar com func
set serveroutput on size 5000;
create or replace procedure inclusao(vvendedor in varchar, vmes in number, vvalor in number) as
begin
 insert into vendas values(null,vvendedor, vmes,vvalor);
 commit;
 dbms_output.put_line('dados gravados');	

exception when others then	
	dbms_output.put_line('Error: ' || sqlerrm);
	rollback;
end;/

exec inclusao('samuel diogo',6,75000);
exec inclusao('samuel diogo',10,75000);
exec inclusao('samuel diogo',12,75000);

select text from user_source where type in ('PROCEDURE');
---------------------------------------------------------

var gnome varchar2(50);
var gmes number;   
var gvalor number;
declare
begin
set verify off;
:gnome := '&nome';
:gmes := &mes;
:gvalor := &valor;
inclusao(:gnome,:gmes,:gvalor);
end;
/
print gnome;
print gmes;
print gvalor;

create or replace procedure inclusaoComSaida(vvendedor in varchar, vmes in number, vvalor in number, vcodigo out number) as
begin
 insert into vendas values(null,vvendedor, vmes,vvalor);
 commit;
 select seq_vendas.currval int vcodigo from dual;
 dbms_output.put_line('dados gravados');	

exception when others then	
	dbms_output.put_line('Error: ' || sqlerrm);
	rollback;
	vcodigo: = -1;
end;/

var gcodigo number;
exec inclusaoComSaida('Diogo',11,45545,:gcodigo);

/home/aluno/Área de Trabalho/curso-plsql-coti/procedure-inclusaocomsaida.sql

-------------------------
-- sql ansi pra teste de valores
SELECT VENDEDOR, SUM(VALORVENDA) FROM VENDAS GROUP BY (VENDEDOR);
-- COM mes(ORASQL)
SELECT VENDEDOR, SUM(VALORVENDA), MES FROM VENDAS 
GROUP BY GROUPING SETS(VENDEDOR,MES);

--- COM ROLLUP
SELECT VENDEDOR, SUM(VALORVENDA), MES FROM VENDAS GROUP BY 
GROUPING SETS(ROLLUP(VENDEDOR), MES);


















