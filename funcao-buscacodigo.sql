create or replace function buscacodigo (vcod in number)
return varchar2
as 
	pnome varchar(50) := '';
	pmes number(15) := 0;
	pvalor number(15) := 0;
begin
	select vendedor, mes,valorvenda into pnome,pmes,pvalor
	from vendas
	where codigo = vcod;
	return pnome || ',' ||  to_char(pmes) || ',' || to_char(pvalor);

exception when others then
return 'Error :' || sqlerrm;

end;
/
