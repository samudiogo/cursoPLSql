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
