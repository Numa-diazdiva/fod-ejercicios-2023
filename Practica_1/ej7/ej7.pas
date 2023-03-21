program fod_p01ej07;

Const
	VALOR_ALTO = 32000;
Type
	cadena30 = string[30];
	novela = record
		cod: integer;
		nombre: cadena30;
		genero: cadena30;
		precio: real;
	end;
	
	archivo_novelas = file of novela;


procedure importarDesdeTxt(var archLB: archivo_novelas; var archTxt: Text);
	var
		n: novela;
	begin
		writeln('----- Importar datos de novelas -----');
		rewrite(archLB);
		reset(archTxt);
		
		while not eof(archTxt) do begin
			readln(archTxt, n.cod, n.precio, n.genero);
			readln(archTxt, n.nombre);
			write(archLB, n);
		end;
		close(archLB);
		close(archTxt);
		writeln('Datos importados');
		writeln();
	end;

procedure leerNovela(var n: novela);
	begin
		writeln('- Leyendo novela -');
		write('Código: '); readln(n.cod);
		write('Nombre: '); readln(n.nombre);
		write('Género: '); readln(n.genero);
		write('Precio: '); readln(n.precio);
	end;

procedure agregarNovela(var archLB: archivo_novelas);
	var
		n: novela;
	begin
		writeln(); writeln('----Agregar novela----');
		reset(archLB);
		seek(archLB, filesize(archLB));
		leerNovela(n);
		write(archLB, n);
		close(archLB);
		writeln('Novela agregada');
	end;

procedure leer(var archLB: archivo_novelas; var n: novela);
	begin
		if not eof(archLB) then
			read(archLB, n)
		else
			n.cod:= VALOR_ALTO;
	end;

function buscarPos(var archLB: archivo_novelas; cod: integer): integer;
	var
		n: novela;
		pos: integer;
	begin
		pos:= -1;
		seek(archLB, 0);
		leer(archLB, n);
		while (n.cod <> VALOR_ALTO) and (n.cod <> cod) do
			leer(archLB, n);
		if (n.cod <> VALOR_ALTO) then
			pos:= filePos(archLB) - 1;
		buscarPos:= pos;
	end;
	
procedure editarNovela(var n: novela);
	var
		editar: char;
	begin
		writeln();
		writeln('Novela cod: ', n.cod);
		write('Editar nombre " ', n.nombre,' "(s/n)?: '); readln(editar);
		if (editar = 's') then begin
			write('Nuevo nombre: '); readln(n.nombre);
		end;
		write('Editar género " ', n.genero,' "(s/n)?: '); readln(editar);
		if (editar = 's') then begin
			write('Nuevo género: '); readln(n.genero);
		end;
		write('Editar precio " ', n.precio,' "(s/n)?: '); readln(editar);
		if (editar = 's') then begin
			write('Nuevo precio: '); readln(n.precio);
		end;
	end;

procedure modificarNovela(var archLB: archivo_novelas);
	var
		n: novela;
		cod, pos: integer;
	begin
		reset(archLB);
		writeln(); writeln('--------- MODIFICAR NOVELAS --------');
		write('Indique el código de la novela que desea modificar: '); readln(cod);
		pos:= buscarPos(archLB, cod);
		if (pos <> -1) then begin
			seek(archLB, pos);
			read(archLB, n);
			editarNovela(n);
			seek(archLB, pos);
			write(archLB, n);
			writeln('Novela editada');
		end
		else begin
			writeln('Novela no encontrada');
		end;
		writeln();
		close(archLB);
	end;
	
procedure editarArchivoBinario(var archLB: archivo_novelas);
	var
		opcion: char;
	begin
		writeln();
		writeln('-------- Edición de Archivo Binario ----------');
		writeln('Para agregar una novela, ingrese "1"');
		writeln('Para modificar una novela, ingrese "2"');
		writeln('Para salir, ingrese cualquier otro caracer.');
		write('Opcion: '); readln(opcion);
		if (opcion = '1') then
			agregarNovela(archLB)
		else
			modificarNovela(archLB);
		
	end;

procedure imprimirNovela(n: novela);
	begin
		writeln(); writeln('----------------------');
		writeln('Código: ', n.cod);
		writeln('Nombre: ', n.nombre);
		writeln('Genero: ', n.genero);
		writeln('Precio: ', n.precio:0:2);
		writeln();
	end;
	
procedure imprimirArchivoBinario(var archLB: archivo_novelas);
	var
		n: novela;
	begin
		writeln(); writeln('--------- Imprimiendo novelas ---------');
		reset(archLB);
		while not eof(archLB) do begin
			read(archLB, n);
			imprimirNovela(n);
		end;
		close(archLB);
	end;

procedure imprimirMenuPrincipal();
	begin
		writeln();
		writeln('------------Menú princial-----------');
		writeln('Ingrese "a" para crear un archivo binario importando las novelas de "novelas.txt"');
		writeln('Ingrese "b" para abrir el archivo binario y actualizarlo');
		writeln('Ingrese "s" para salir');
		writeln();
	end;

Var
	archLB: archivo_novelas;
	archTxt: Text;
	nombreF: cadena30;
	opcion: char;
Begin
	writeln('Manejo de archivo de novelas');
	write('Ingrese el nombre del archivo de registros con el que desea trabajar: '); readln(nombreF);
	assign(archLB, nombreF);
	assign(archTxt, 'novelas.txt');
	imprimirMenuPrincipal();
	write('Opcion: '); readln(opcion);
	
	while (opcion <> 's') do begin
		case opcion of
			'a': importarDesdeTxt(archLB, archTxt);
			'b': editarArchivoBinario(archLB);
			'c': imprimirArchivoBinario(archLB); { para ver que esté todo bien }
			else writeln('Opción inválida.');
		end;
		imprimirMenuPrincipal();
		write('Opcion: '); readln(opcion);
	end;
	
End.
