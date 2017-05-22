 conn / as sysdba
 create user sessao3 identified by coti
   default tablespace users
   quota 100m on users;

 grant create table, create session, create user, create sequence,
        create procedure, create trigger, create view, 
        create materialized view, connect to sessao3;

 alter system set utl_file_dir='*' scope=spfile;
 grant execute on utl_file to sessao3;
 shutdown immediate;
 startup;
 conn / as sysdba
  show  parameters utl;
 
============================================

create or replace directory ARQUIVOS as '/tmp/'; 
 grant read, write on directory ARQUIVOS to sessao3;

 conn sessao3/coti
 select user from dual;
  
DROP TABLE ALUNO_DISCIPLINA CASCADE CONSTRAINT;
DROP TABLE ALUNO CASCADE CONSTRAINT;
DROP TABLE DISCIPLINA CASCADE CONSTRAINT;
 create table ALUNO(idAluno number (15) primary key,
                    nome varchar2 (50) not null,
                    email varchar2 (60) not null unique);
 create table DISCIPLINA (idDisciplina number(15) primary key,
                          disciplina varchar2 (50)
                          );
alter table disciplina add constraint FNK_DISCIPLINA_UNIQUE
    unique(disciplina);

create table ALUNO_DISCIPLINA(
								id_aluno number (15),
                                id_disciplina number (15),
                     primary key(id_aluno, id_disciplina),
						  nota1 number (15,2),
                          nota2 number (15,2),
                          data date,
       foreign key(id_aluno) references   aluno,        
       foreign key(id_disciplina) references disciplina);  

-- criar sequence
create sequence seq_aluno;
create sequence seq_disciplina;
create sequence seq_aluno_disciplina;
-- criar um pacote
-- FORMATANDO A VISUALIZAÇÃO NO CONSOLE:

 set linesize 400;
  column nome format a15;
  column email  format a25;
  column disciplina  format a10;

-- ALTERANDO O FORMATO DA DATA NA SESSÃO
ALTER SESSION SET NLS_DATE_FORMAT = 'dd/mm/yyyy';
COMMIT;


-- SEEDING

insert into aluno values (seq_aluno.nextval,'thiago','thiagho@ship.com');
insert into disciplina values (seq_disciplina.nextval,'plsql');
insert into aluno_disciplina values (seq_aluno.currval, seq_disciplina.currval, 5, 3,to_date('15/05/2017','dd/mm/yyyy') );
COMMIT;


-- CRIANDO VIEW SIMPLES

CREATE OR REPLACE VIEW V$ALUNODISCIPLINA AS
		select nome, email, disciplina, nota1, nota2, data 
		from 
		   Aluno a inner join aluno_disciplina ad
			  on a.idAluno = ad.id_aluno
		  inner join Disciplina d
			  on d.iddisciplina = ad.id_disciplina;

----------------------------------------------------

-- triggers

create or replace trigger gat_alunos
	before 
	insert on aluno 
		for each row begin 
		select seq_aluno.nextval 
	into :new.idAluno 
	from dual; 
end;
/

create or replace trigger gat_DISCIPLINA
	before 
	insert on DISCIPLINA 
		for each row begin 
		select seq_disciplina.nextval 
	into :new.idDisciplina 
	from dual; 
end;
/
-----------------------------------------------------

-- PL-SQL
-- definindo o cabeçalho (TIPO INTERFACE)

create or replace package PKG_Aluno is

	procedure gravaAluno(vnome in varchar2, vemail in varchar2);
	procedure gravaDisciplina(vdisciplina in varchar2);

	procedure alocar(vidAluno in number, vidDisciplina in number, vnota1 in number, vnota2 in number, vdata in date);
	
	function findByCodeAluno(vcod in number) return varchar2;

	function findByCodeDisciplina(vcod in number) return varchar2;

	function findAllAluno return sys_refcursor;

	function findAllDisciplina return sys_refcursor;

	function findAll return sys_refcursor;

end PKG_Aluno;
/
--- CRIANDO O CORPO DO PACKAGE
create or replace package body PKG_Aluno is
	
	procedure gravaAluno(vnome in varchar2, vemail in varchar2)as
	begin
		INSERT INTO aluno VALUES (null, vnome, vemail);
		COMMIT;
		dbms_output.put_line('dados gravados');
	
		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line('ERRO AO GRAVAR: ' || SQLERRM);
	end;

	procedure gravaDisciplina(vdisciplina in varchar2)as
	begin
		INSERT INTO disciplina VALUES(null, vdisciplina);
		COMMIT;
		dbms_output.put_line('dados gravados');
	
		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line('ERRO AO GRAVAR: ' || SQLERRM);
	end;


	procedure alocar(vidAluno in number, vidDisciplina in number, vnota1 in number, vnota2 in number, vdata in date) AS
	vnome varchar2(50);
	vdisciplina varchar2(50);
	BEGIN
		select nome into vnome from aluno where idaluno = vidaluno;
		select disciplina into vdisciplina from disciplina where iddisciplina = viddisciplina;
		INSERT INTO aluno_disciplina VALUES (vidAluno,vidDisciplina, vnota1,vnota2,vdata);
		COMMIT;
		dbms_output.put_line('dados gravados');
	
		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line('ERRO AO GRAVAR: ' || SQLERRM);

	end;

 -- final de procedure

	FUNCTION findByCodeAluno(vcod in number) RETURN varchar2
	AS
	vnome varchar2(50)    := '';
	vemail varchar2(50)    := ''; 
	BEGIN
		SELECT nome, email into vnome,vemail FROM aluno 
		WHERE idAluno = vcod;

		RETURN to_char(vcod) || ',' || vnome || ',' || vemail;

		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line('ERRO AO buscar: ' || SQLERRM);
		RETURN -1;
	END;

 -- final de procedure
	FUNCTION findByCodeDisciplina(vcod in number)
	RETURN varchar2
	AS 
	vdisciplina  varchar2(50)    := '';
	BEGIN

		SELECT disciplina INTO vdisciplina FROM disciplina 

		WHERE  idDisciplina = vcod;

		RETURN to_char(vcod) || ',' || vdisciplina;

		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line('ERRO AO buscar: ' || SQLERRM);

		RETURN -1;

	END;


	 -- final de procedure

	FUNCTION findAllAluno
	RETURN SYS_REFCURSOR
	AS
		VLINHA SYS_REFCURSOR;
		BEGIN
			OPEN VLINHA FOR SELECT * FROM ALUNO;
			RETURN VLINHA;
		END;

	 -- final de procedure

	FUNCTION findAllDisciplina
	RETURN SYS_REFCURSOR
	AS
		VLINHA SYS_REFCURSOR;
		BEGIN
			OPEN VLINHA FOR SELECT disciplina FROM DISCIPLINA;
			RETURN VLINHA;
		END;
	 -- final de procedure

	FUNCTION findAll
	RETURN SYS_REFCURSOR
	AS
		VLINHA SYS_REFCURSOR;
		BEGIN
			OPEN VLINHA FOR SELECT * FROM V$ALUNODISCIPLINA;
			RETURN VLINHA;
		END;

	 -- final de procedure
END PKG_Aluno;
/

-- testando

exec PKG_ALuno.gravaAluno('jose','jose@gmail.com');
exec PKG_ALuno.gravaDisciplina('oracle dba');
exec PKG_ALuno.gravaDisciplina('oracle sql');


select PKG_ALuno.findALl from dual;
select  PKG_ALuno.findAllALuno from dual;
select  PKG_ALuno.findAllDisciplina from dual;


exec  PKG_ALuno.alocar(3,1, 6,4,to_date('05/04/2017','dd/mm/yyyy'));

-------------------  pronto! ---------------------



































