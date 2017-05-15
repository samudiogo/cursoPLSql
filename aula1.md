--profedsonbelem@gmail.com
--98199-0108

--lucianamedeiros.coti@gmail.com
--98201-2525

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
  before insert on vendas
  for each row
 begin
  select seq_vendas into :new.codigo  from dual;
 end;
































