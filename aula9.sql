sqlplus system/coti

create user sessao009 identified by coti
 default tablespace users
 quota 100m on users;
 

grant create table, create session, create procedure,
      create user,  create trigger, create sequence,
	   create view, create materialized view  to sessao009;
	   
conn sys/coti as sysdba
alter system set utl_file_dir='*'  scope=spfile;
grant execute on utl_file to sessao009;

shutdown immediate;
startup;

alter session set nls_date_format='dd/mm/yyyy';
set serveroutput on size 10000;
set long 10000;

--------------------------------

create table produtos(idProduto number(15) primary key,
nome varchar(50),
preco number(20,2));

create sequence seq_produto;


create table estoque (idEstoque number (20) primary key,
 dataestoque date,
 quantidade number (5),
 id_produto number (15) unique,
 foreign key(id_produto) references produtos);

create sequence seq_estoque;

create table venda (idVenda number (15) primary key,
 datavenda timestamp, quantidadevendido number (15,2),
  id_produto number (15),
  valorVenda number (15,2),
  foreign key(id_produto) references produtos
  );

create sequence seq_venda;

