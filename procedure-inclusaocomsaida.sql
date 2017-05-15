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
end;
