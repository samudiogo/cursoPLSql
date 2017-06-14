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
