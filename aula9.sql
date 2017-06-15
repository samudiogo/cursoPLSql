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

create table alerta ( registro varchar2 (3000));

------------------------------------------------------------------------

create or replace procedure procvenda(vidproduto in number,
vquantidadeped in number, total out number, quantidadesaldo out number)
as 
vnomeprod varchar (50) :='';
vpreco number (15,2) :=0;
vquantidadeest number (5) :=0;
 begin

 select nome,preco into vnomeprod, vpreco   from produtos      
     where idproduto = vidproduto;
	 
 select quantidade into vquantidadeest from estoque 
   where id_Produto = vidproduto; 

   if (vquantidadeest >= vquantidadeped ) then
     
     total := vquantidadeped * vpreco;
    quantidadesaldo := vquantidadeest - vquantidadeped ;
   
   insert into venda values 
	   (seq_venda.nextval, systimestamp,vquantidadeped,vidproduto,total);
	   
     update estoque set  quantidade= quantidadesaldo,
         dataestoque=sysdate     where id_produto=vidProduto;  

    dbms_output.put_line('Venda Realizada :' || total || ',' ||
                 vnomeprod || ',' || vquantidadeped);
    commit;
	
  else
     dbms_output.put_line('Venda Nao Realizada  quantidade Insu8ficiente');
 
   end if;
   

exception when others then
  rollback;
  dbms_output.put_line('Error :' || sqlerrm);
  
end;

----------------- momento de teste

DECLARE
  VIDPRODUTO NUMBER;
  VQUANTIDADEPED NUMBER;
  TOTAL NUMBER;
  QUANTIDADESALDO NUMBER;
BEGIN
  VIDPRODUTO := 2;
  VQUANTIDADEPED := 2;

  PROCVENDA(
    VIDPRODUTO => VIDPRODUTO,
    VQUANTIDADEPED => VQUANTIDADEPED,
    TOTAL => TOTAL,
    QUANTIDADESALDO => QUANTIDADESALDO
  );
  DBMS_OUTPUT.PUT_LINE('TOTAL = ' || TOTAL);
  DBMS_OUTPUT.PUT_LINE('QUANTIDADESALDO = ' || QUANTIDADESALDO);
END;


---------------------------------------------------------------------


create or replace procedure alertaEstoque
 as 
 
  cursor linha is select idproduto, nome, dataestoque, quantidade 
    from produtos p inner join estoque e
	on  p.idProduto = e.id_produto;
	
   vregprod     produtos%rowtype;
   vregestoque  estoque%rowtype;
  begin
   
   open linha;
     loop
	  fetch linha into   vregprod.idProduto, vregprod.nome, 
  		                 vregestoque.dataestoque, vregestoque.quantidade;

     exit when linha%notfound;
	  
	if (vregestoque.quantidade <=5) then 
	  dbms_output.put_line('----------------------------------------');
	  dbms_output.put_line('----------------------------------------');
	  dbms_output.put_line('Alerta Produto em Baixa, Reponha Estoque');
	  dbms_output.put_line('codigo :' || vregprod.idProduto);
	  dbms_output.put_line('NOme   :' || vregprod.nome);
	  dbms_output.put_line('Data Estoque :' || vregestoque.dataestoque);
	  dbms_output.put_line('Quantidade   :' || vregestoque.quantidade);

	 insert into alerta values (
   'codigo :' || vregprod.idProduto || ',' || 	 vregprod.nome ||  ','
    ||  vregestoque.dataestoque || ',' ||  vregestoque.quantidade ||
    ',' || user || '-->' || systimestamp);
	  commit;
	  
    end if;
	
   end loop;
   close linha;
    
  exception when others then 
     dbms_output.put_line('Error :' || sqlerrm);
end;
---------------------------------------------------


 var numero number;

--Agendando  o JOB
 begin
  dbms_job.submit(:numero, 'alertaEstoque;', sysdate,
      'sysdate + (1/1440)');  
 end;
/

print numero;
select job from user_jobs;
--23

begin
 dbms_job.run(:numero);
end;
/
------------------------------------------
-----------------------------------------


 select job, to_char(last_date, 'dd/mm/yyyy hh24:mi:ss') last,
  to_char(next_date, 'dd/mm/yyyy hh24:mi:ss') next from user_jobs;



 JOB LAST                NEXT
---- ------------------- -------------------
  23 14/06/2017 20:50:01 14/06/2017 20:51:01

  --apagar o job
  
begin
 dbms_job.remove(23);
end;
/

-------------------------------------------------
declare
   data_atual date;
   data_atual_maisummes date;
   data_atual_menosummes date;
   ultimo_dia_mes  date;
   primeiro_dia_mes  date;
   qtde_mes number (15) :=0;
   arredonda_abaixo number (15):=0;
   arredonda_acima number (15):=0;
   valor_absoluto  number (15):=0;
   arredonda  number (15):=0;
   primeiro_dia_ano date;
   diaMes_extenso varchar(100);
   Mes_extenso varchar(100);
   hora_minuto varchar (35);
   mes_corrente varchar (35);
   dias_data date;
   idade number (15);
   dia_da_semana varchar (35);
  begin
    select sysdate into data_atual from dual;
	select add_months(sysdate,-1) into data_atual_menosummes from dual;
    select add_months(sysdate,+1) into data_atual_maisummes from dual;
    select last_day(sysdate) into ultimo_dia_mes  from dual;
	select trunc(sysdate,'MONTH') into primeiro_dia_mes  from dual;
select months_between(sysdate,'01-JAN-2016') into qtde_mes  from dual;

   select floor(months_between(sysdate,'01/06/2016')) into    arredonda_abaixo  from dual;
	select ceil(months_between(sysdate,'28/06/2016')) into   arredonda_acima  from dual;
	select ABS(months_between(sysdate,'14/06/2016')) into 
    valor_absoluto  from dual;
	
  select round((months_between(sysdate,'01-JAN-2016')),2) into 
    arredonda  from dual;
	
  select to_char(sysdate,'dd " de " FMMONTH " de " YYYY',
   'nls_date_language=portuguese') into diaMES_extenso from dual;
   
  select to_char(sysdate,'FMMONTH " de " YYYY',
   'nls_date_language=portuguese') into MES_extenso from dual;
  
  select trunc(sysdate,'year') into primeiro_dia_ano from dual;
  select to_char(sysdate,'HH24:MI') into hora_minuto from dual;
  select to_char(sysdate,'FMMONTH','nls_date_language=portuguese')
  into mes_corrente from dual;
----	
 select to_date(lpad(to_char(1234567),4,'0'),'hh24mi') 
  into dias_data from dual;
-----


 select floor(floor(months_between(sysdate,'28/01/1973'))/12)
  into idade from dual;
	
 select decode (to_number(to_char(sysdate,'D')),1,'domingo',2,
'segunda',3,'terca',4,'quarta',5,'quinta',6,'sexta',7,'sabado')
 into dia_da_semana from dual;
 
 dbms_output.put_line('Datas ...');
 dbms_output.put_line('Data Atual' || data_atual);
 dbms_output.put_line('Data Atual menos um mes :' || data_atual_menosummes);
 dbms_output.put_line('Data Atual mais um mes :' || data_atual_maisummes);
 dbms_output.put_line('Ultimo dia Mes :' || ultimo_dia_mes);
 dbms_output.put_line('Primeiro dia :' || primeiro_dia_mes);
 dbms_output.put_line('Quantidade Meses :' || qtde_mes);
 dbms_output.put_line('Arredondado cima :' || arredonda_acima);
 dbms_output.put_line('Arredondado Abaixo :' || arredonda_abaixo);
 dbms_output.put_line('Valor absoluto :' || valor_absoluto);
 dbms_output.put_line('Arredonda :' || arredonda);
 dbms_output.put_line('Primeiro dia Ano :' || primeiro_dia_ano);
 dbms_output.put_line('Dia Mes por extenso :' || diaMES_extenso);
 dbms_output.put_line('Mes por extenso :' || MES_extenso);
 dbms_output.put_line('Hora MInuto :' || hora_minuto);
 dbms_output.put_line('MEs Corrente :' || mes_corrente);
 dbms_output.put_line('Dias Data :' || dias_data);
 dbms_output.put_line('Idade :' || idade);
 dbms_output.put_line('dia da Semana :' || dia_da_semana);
 
 exception when others then  
   dbms_output.put_line('Error ' || sqlerrm);
 end;
