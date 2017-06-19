sqlplus system/coti
conn sys/coti as sysdba

create user sessao010 identified by coti
 default tablespace users
 quota 10m on users;
grant create table, create user, create session,
      create view, create materialized view,
	  create procedure, create trigger,
	  create sequence to sessao010;
	  
create or replace directory DIR1 as 'c:temp';
grant read,write on directory DIR1 to sessao010;
conn sessao010/coti
exec dbms_java.set_output(10000);
set serveroutput on size 10000;
create  or replace and compile java source named "Output" as
 public class  Output{
    public static void  mostra(){
      System.out.println("Ola Turma teste Java PLSQL");
    }
}


create or replace procedure mostra
 as language java name 'Output.mostra()';


 exec mostra;
show user;
----------------------------------------------

create table setor(id number (15) primary key,
  vendedor varchar (50), setor varchar (15),
  datavenda date, valor number (20,2));
 insert into setor values (100,'thiago','ele',
   to_date('10/06/2016', 'dd/MM/yyyy'), 5000);
 insert into setor values (101,'thiago','ele',
   to_date('10/07/2016', 'dd/MM/yyyy'), 30000);
 insert into setor values (102,'thiago','ele',
   to_date('10/08/2016', 'dd/MM/yyyy'), 15000);
 insert into setor values (103,'lu','inf',
   to_date('10/06/2016', 'dd/MM/yyyy'),2000);
 insert into setor values (104,'lu','inf',
   to_date('10/07/2016', 'dd/MM/yyyy'),4000);
 insert into setor values (105,'lu','inf',
   to_date('10/08/2016', 'dd/MM/yyyy'),20000);
 commit;  
--------------------------------
create  or replace trigger gat_setor 
before insert or delete or update on setor
for each row
begin
 
  if (to_char(sysdate,'DY') in ('SAB','DOM'))
Or (to_CHAR (sysdate,'HH24:MI') not between '09:00' and '19:00') THEN

 IF    DELETING THEN
 RAISE_APPLICATION_ERROR(-20001,'Nao pode Excluir fora do expediente');
 elsif  UPDATING THEN
 RAISE_APPLICATION_ERROR(-20002,'Nao pode Alterar fora do expediente');
 else
 RAISE_APPLICATION_ERROR(-20003,'Nao pode Inserir fora do expediente');
 end if;
end if;
end;
/

--delete ou preserve
 drop table cliente;
 create global temporary table cliente(id number(15),
 nome varchar (50))
 on commit delete rows; -- hehehehe

insert into cliente values (100,'luis');
insert into cliente values (120,'luciana');
insert into cliente values (140,'maria');
insert into cliente values (160,'elo');


select * from cliente;

commit;
exit; --kkkkkkkkkkkkkkkkkkkk
--eha a morte dos dados 

