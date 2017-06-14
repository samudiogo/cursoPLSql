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
