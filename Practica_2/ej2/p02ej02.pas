program fod_p02ej02;

Type
	cadena30 = string[30];
	alumno = record
		cod: integer;
		apellido: cadena30;
		nombre: cadena30;
		cantAprobadas: integer;
		cantCursadas: integer;	
	end;
	
	materia = record
		cod: integer;
		aproboCursada: boolean;
		aproboFinal: boolean;
	end;
	
	{ ordenados por código de alumno }
	arch_alumnos = file of alumno;
	arch_materias = file of materia;


procedure leerAlumno(var a: alumno);
	begin
		writeln(); writeln('-------');
		write('Código: '); readln(a.cod);
		if(a.cod <> -1) then begin
			write('Apellido: '); readln(a.apellido);
			write('Nombre: '); readln(a.nombre);
			write('CantAprobadas: '); readln(a.cantAprobadas);
			write('CantCursadas: '); readln(a.cantCursadas);
		end;
	end;

procedure cargarArchivo(var archAlumnos: arch_alumnos);
	var
		a: alumno;
	begin
		writeln();
		writeln('---------- CARGANDO ALUMNOS -----------');
		rewrite(archAlumnos);
		writeln('Ingrese los datos de los alumnos. Para salir ingrese el código de alumno -1');
		leerAlumno(a);
		while(a.cod <> -1) do begin
			write(archAlumnos, a);
			leerAlumno(a);
		end;
		close(archAlumnos);
		writeln();
	end;

procedure imprimirAlumno(a: alumno);
	begin
		writeln(); writeln('------------');
		writeln('Código: ', a.cod); 
		writeln('Apellido: ', a.apellido);
		writeln('Nombre: ', a.nombre);
		writeln('CantAprobadas: ', a.cantAprobadas);
		writeln('CantCursadas: ', a.cantCursadas);
	end;


procedure imprimirArchivo(var archAlumnos: arch_alumnos);
	var
		a: alumno;
	begin
		writeln();
		writeln('---------- IMPRIMIENDO ALUMNOS -----------');
		reset(archAlumnos);
		while(not eof(archAlumnos)) do begin
			read(archAlumnos, a);
			imprimirAlumno(a);
		end;
		close(archAlumnos);
		writeln();
	end;

procedure leerMateria(var m: materia);
	var
		aprobo: char;
	begin
		writeln(); writeln('-------');
		m.aproboCursada:= false;
		m.aproboFinal:= false;
		write('Código: '); readln(m.cod);
		if(m.cod <> -1) then begin
			write('Ingrese 1 si aprobó la cursada: '); readln(aprobo);
			if (aprobo = '1') then begin
				write('Ingrese 2 si aprobó el final: '); readln(aprobo);
				if (aprobo = '2') then
					m.aproboFinal:= true;
				m.aproboCursada:= true;
			end;
		end;
	end;


procedure cargarDetalle(var archDetalle: arch_materias);
	var
		m: materia;
	begin
		rewrite(archDetalle);
		writeln(); writeln('----------- CARGANDO MATERIAS ---------');
		writeln('Ingrese los datos de las materias. Para salir, ingrese el código -1.');
		leerMateria(m);
		while(m.cod <> -1) do begin
			write(archDetalle, m);
			leerMateria(m);
		end;
		close(archDetalle);
		writeln();
	end;


procedure leerDetalle(var aD: arch_materias; var m: materia);
	begin
		if (not eof(aD)) then
			read(aD, m)
		else
			m.cod:= -1;
	end;

procedure actualizarMaestroDetalle(var aM: arch_alumnos; var aD: arch_materias);
	var
		a: alumno;
		m: materia;
	begin
		reset(aM); reset(aD);
		writeln();
		writeln('------------ ACTUALIZANDO MAESTRO -------------');
		read(aM, a);
		leerDetalle(aD, m);
		while(m.cod <> -1) do begin
			while(a.cod <> m.cod) do begin
				read(aM, a);
			end;
			
			while(a.cod = m.cod) do begin
				if(m.aproboCursada) then begin
					if (m.aproboFinal) then
						a.cantAprobadas:= a.cantAprobadas + 1;
					a.cantCursadas:= a.cantCursadas + 1;
				end;
				leerDetalle(aD, m);
			end;
			seek(aM, filepos(aM) - 1);
			write(aM, a);
		end;
		close(aM); close(aD);
	end;

procedure listarAlumnesCondicion(var aM: arch_alumnos);
	var
		a: alumno;
	begin
		writeln(); writeln('------------ ALUMNES QUE TIENEN MÁS DE 4 CURSADAS SIN FINAL APROBADO ----------');
		reset(aM);
		while(not eof(aM)) do begin
			read(aM, a);
			if ((a.cantCursadas - a.cantAprobadas) > 4) then
				imprimirAlumno(a);
		end;
		close(aM);
		writeln();
	end;

procedure imprimirOpciones();
	begin
		writeln();
		writeln('------------------- OPCIONES');
		writeln('Ingrese 1 para crear y cargar un archivo de alumnos');
		writeln('Ingrese 2 para crear y cargar un archivo de materias');
		writeln('Ingrese 3 para actualizar el archivo de alumnos con las materias aprobadas');
		writeln('Ingrese 4 para imprimir el archivo de alumnos');
		writeln('Ingrese 5 para listar alumnos que tengan más de cuatro cursadas aprobadas sin final');
		writeln('Para salir ingrese "s"');
	end;

Var
	archAlumnos: arch_alumnos;
	archDetalle: arch_materias;
	nombreAl, nombreMat: cadena30;
	opcion: char;
Begin
	writeln('-------------- ACTUALIZACIÓN MAESTRO - DETALLE CON ALUMNOS --------------');
	write('Ingrese el nombre del archivo de alumnos: '); readln(nombreAl);
	write('Ingrese el nombre del archivo de materias: '); readln(nombreMat);
	assign(archAlumnos, nombreAl);
	assign(archDetalle, nombreMat);
	imprimirOpciones();
	write('opción: '); readln(opcion);
	while (opcion <> 's') do begin
		case opcion of
			'1': cargarArchivo(archAlumnos);
			'2': cargarDetalle(archDetalle);
			'3': actualizarMaestroDetalle(archAlumnos, archDetalle);
			'4': imprimirArchivo(archAlumnos);
			'5': listarAlumnesCondicion(archAlumnos);
		end;
		imprimirOpciones();
		write('opción: '); readln(opcion);
	end;
End.
