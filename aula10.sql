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

---------------------------------------------------
 ---------------------------------------------
 
 conn sys/coti as sysdba
 alter system set utl_file_dir='*' scope=spfile;
 shutdown immediate;
 startup;
 grant execute on utl_file to sessao010;
 conn sys/coti as sysdba
 show parameters utl;

 conn sessao010/coti
create table produto(id number (15) primary key,
  nome varchar (15), preco number (15,2));
  insert into produto values (100,'xanxung',200);
  insert into produto values (200,'galaxia',230);
  insert into produto values (300,'rasus',130);
  insert into produto values (400,'iphone pera',310);
commit;
 
create or replace procedure geraHTML as
  arquivo utl_file.file_type;
  cursor linhas is select * from produto;
  reg produto%rowtype;
 begin
  htp.print('<h3>Listagem dos Produtos</h3>');
  htp.print('<hr/>');
  open linhas;
   loop
    fetch linhas into reg;
	exit when linhas%notfound;
	htp.print('<ul>');
	htp.print('<li>' || reg.id || ',' || reg.nome 
	           || ',' || reg.preco || '</li>');
	htp.print('</ul>');
  end loop;
  close linhas;	
   dbms_output.put_line('Dados gerados com sucesso');
   exception when others then
   dbms_output.put_line('Error :' || sqlerrm);
 end;
/ 
 
 -----------------------------
 set serveroutput on size 15000;
 create or replace procedure gravaHTML
  as  
  l_thepage  htp.htbuf_arr;
  l_output utl_file.file_type;
  l_lines  number default 999999999;
  begin
   l_output := utl_file.fopen('c:temp','produto.html','w');
   owa.get_page(l_thepage, l_lines);
    for i in 1..l_lines loop 
        utl_file.put(l_output, l_thepage(i));
    end loop;
   utl_file.fclose(l_output);
   dbms_output.put_line('Arquivo Armazenado ');
   exception when others then
   dbms_output.put_line('Error :' || sqlerrm);
 end;
/ 
 
 declare
   nm owa.vc_arr;
   vl owa.vc_arr;
 begin

    owa.init_cgi_env(nm.count, nm, vl);
          geraHTML;
          gravaHTML;   		  
     dbms_output.put_line('site gerado');
 exception when others then	 
    dbms_output.put_line('Error :' || sqlerrm);
end;
/	
 
 
----------------------------------------------

create table estat (
id number (15),
nome varchar (50),
email varchar (50));
declare
begin
for i in 1..5000 loop
insert into estat values (i, 'nome' || i, 'email' || i);
end loop;
commit;
end;
/

set timing on;
select * from estat;

53.72 segundos

create unique ndx_nome_email on estat (nome, email);
tablespace users;
alter table estat add constraint cnk_chave primary key (id);

set timing on;
select * from estat;

52.38 segundos

set pagesize 50000;
set linesize 1000;

set timing on;
select * from estat;

12.77 segundos

set autotrace traceonly;
select * from estat;

set autotrace off;

--------------------------------------------

create table cliente(
idCliente number(15) primary key,
nome varchar (50),
email varchar (50) unique,
sexo varchar (1));

insert into cliente values (10, 'lu', 'lu@gmail.com', 'f');
insert into cliente values (11, 'helio', 'helio@gmail.com', 'm');
insert into cliente values (12, 'thiago', 'thiago@gmail.com', 'm');
insert into cliente values (13, 'thalita', 'thalita@gmail.com', 'f');
insert into cliente values (14, 'fernando1', 'fernando1@gmail.com', 'm');

commit;

select * from cliente;

create or replace procedure criaView (vsexo in varchar2)



-----------------------------------------------
