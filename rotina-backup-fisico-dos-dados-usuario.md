--in 'TABLE' . '
--Rotina de BACKUP FISICO DOS DADOS DO USUÁRIO ...
 declare

  v_exporta  CLOB;
 begin

  for reg in (select object_name, object_type from user_objects
      where object_type in ('VIEW','TABLE','SEQUENCE'))  Loop
  
  v_exporta := dbms_metadata.get_ddl(reg.object_type, reg.object_name);
dbms_xslprocessor.clob2file(v_exporta,'ARQUIVOS',reg.object_name||'.sql');
   
 dbms_Output.put_line('arquivo:'||reg.object_name);

 end loop;

end;
/
