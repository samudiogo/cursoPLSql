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
 create table aluno(idAluno number (15) primary key,
                    nome varchar2 (50) not null,
                    email varchar2 (60) not null unique);
 create table disciplina (idDisciplina number(15) primary key,
                          disciplina varchar2 (50)
                          );

  create table aluno_disciplina(id_aluno number (15),
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

-- PL-SQL
-- definindo o cabeçalho (TIPO INTERFACE)

create or replace package PKG_Aluno is
	procedure inclusao(vnome in varchar2, vemail in varchar2, vdisciplina in varchar2, 
						vnota1 in number, vnota2 in number, vdata in date);
	
	function findByCodeAluno(vcod in number) return varchar2;

	function findByCodeDisciplina(vcod in number) return varchar2;

	function findAllAluno return sys_refcursor;

	function findAllDisciplina return sys_refcursor;

	function findAll return sys_refcursor;

end PKG_Aluno;

create or replace package PKG_Aluno body is

	create or replace procedure inclusao(vnome in varchar2, vemail in varchar2, vdisciplina in varchar2, 
							vnota1 in number, vnota2 in number, vdata in date)
	BEGIN

		INSERT INTO aluno VALUES (seq_aluno.nextval, vnome, vemail);

		INSERT INTO disciplina VALUES(seq_disciplina.nextval, vdisciplina);

		INSERT INTO aluno_disciplina VALUES (seq_aluno_disciplina.nextval,
											seq_aluno.currval,
											seq_disciplina.currval, vnota1,vnota2, vdata);
		COMMIT;
		dbms_output.putline('dados gravados');
	
		EXCEPTION WHEN OTHERS THEN;
			dbms_output.putline('ERRO AO GRAVAR: ' || SQLERRM);

	end;

 -- final de procedure

	CREATE OR REPLACE FUNCTION findByCodeAluno(vcod in number)
	RETURN varchar2
	AS
	vnome varchar2(50)    := '';
	vemail varchar2(50)    := ''; 
	BEGIN
		SELECT nome, email into vnome,vemail FROM aluno 
		WHERE idAluno = vcod;

		RETURN to_char(vcod) || ',' vnome || ',' || vemail;

		EXCEPTION WHEN OTHERS THEN;
			dbms_output.putline('ERRO AO buscar: ' || SQLERRM);
		RETURN -1;
	END;

 -- final de procedure
	CREATE OR REPLACE FUNCTION findByCodeDisciplina(vcod in number)
	RETURN varchar2
	AS 
	vdisciplina  varchar2(50)    := '';
	BEGIN

		SELECT disciplina INTO vdisciplina FROM disciplina 

		WHERE  idDisciplina = vcod;

		RETURN to_char(vcod) || ',' vdisciplina;

		EXCEPTION WHEN OTHERS THEN;
			dbms_output.putline('ERRO AO buscar: ' || SQLERRM);

		RETURN -1;

	END;


	 -- final de procedure

	CREATE OR REPLACE FUNCTION findAllAluno
	RETURN AS SYS_REFCURSOR
	AS
		VLINHA SYS_REFCURSOR;
		BEGIN
			OPEN VLINHA FOR SELECT * FROM ALUNO;
			RETURN VLINHA;
		END;

	 -- final de procedure

	CREATE OR REPLACE FUNCTION findAllDisciplina
	RETURN AS SYS_REFCURSOR
	AS
		VLINHA SYS_REFCURSOR;
		BEGIN
			OPEN VLINHA FOR SELECT * FROM DISCIPLINA;
			RETURN VLINHA;
		END;
	 -- final de procedure

	CREATE OR REPLACE FUNCTION findAll
	RETURN AS SYS_REFCURSOR
	AS
		VLINHA SYS_REFCURSOR;
		BEGIN
			OPEN VLINHA FOR SELECT * FROM V$ALUNODISCIPLINA;
			RETURN VLINHA;
		END;

	 -- final de procedure
END;




































