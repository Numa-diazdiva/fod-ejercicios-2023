program fod_p03ej03;

Const
	VALOR_ALTO = 32000;
Type
	cadena30 = string[30];
	tNovela = record
		cod: integer;
		genero: cadena30;
		nombre: cadena30;
		duracion: integer;
		director: cadena30;
		precio: real;
	end;
	
	arch_novelas = file of tNovela;



procedure leer(var arch: arch_novelas; var n: tNovela);
	begin
		if(not eof(arch)) then
			read(arch, n)
		else
			n.cod:= VALOR_ALTO;
	end;


procedure ingresarNovela(var n: tNovela);
	begin
		writeln();
		writeln('----------------------------');
		write('Ingrese código: '); readln(n.cod);
		if(n.cod <> VALOR_ALTO) then begin
			write('Ingrese genero: '); readln(n.genero);
			write('Ingrese nombre: '); readln(n.nombre);
			write('Ingrese duracion: '); readln(n.duracion);
			write('Ingrese director: '); readln(n.director);
			write('Ingrese precio: '); readln(n.precio);
		end;
	end;

procedure crearArchivo(var arch: arch_novelas);
	var
		n: tNovela;
	begin
		writeln();
		
		rewrite(arch);
		{ escribo el registro cabecera }
		n.cod:= 0;
		write(arch, n);
		{ cargo las novelas }
		writeln('---------- CARGANDO NOVELAS ----------');
		writeln('Ingrese los datos de las novelas. Para salir ingrese el código de novela 32000');
		ingresarNovela(n);
		while(n.cod <> VALOR_ALTO) do begin
			write(arch, n);
			ingresarNovela(n);
		end;
		close(arch);
	end;

procedure imprimirNovela(var n: tNovela);
	begin
		writeln(); writeln('------------------------');
		writeln('Código: ', n.cod);
		writeln('Género: ', n.genero);
		writeln('Nombre: ', n.nombre);
		writeln('Duracion: ', n.duracion);
		writeln('Director: ', n.director);
		writeln('Precio: ', n.precio);
	end;
	
procedure imprimirNovelas(var arch: arch_novelas);
	var
		n: tNovela;
	begin
		writeln('-----------> Imprimiendo novelas');
		reset(arch);
		while(not eof(arch)) do begin
			read(arch, n);
			imprimirNovela(n);
		end;
		close(arch);
	end;

procedure darDeAltaNovela(var arch: arch_novelas);
	var
		n, nNueva: tNovela;
		pos: integer;
	begin
		writeln();
		writeln('-----------ALTA----------');
		reset(arch);
		leer(arch, n);
		ingresarNovela(nNueva);
		{ evalúo si hay espacios libres por borrado lógico }
		if((n.cod < 0)) then begin
			pos:= n.cod * -1;
			seek(arch, pos);
			read(arch, n);
			seek(arch, 0);
			write(arch, n); { copio el tope de la lista invertida en el registro cabecera }
			seek(arch, pos);
			write(arch, nNueva); { escribo en el lugar libre }
		end
		else begin
			{ Si no hay huecos escribo al final }
			seek(arch, fileSize(arch));
			write(arch, nNueva);
		end;
		close(arch);
	end;


procedure modificarDatos(var arch: arch_novelas);
	var
		cod: integer;
		n: tNovela;
	begin
		reset(arch);
		writeln();
		writeln('---------------MODIFICAR DATOS-----------');
		write('Ingrese el código de la novela que desea editar: '); readln(cod);
		leer(arch, n);
		while((n.cod <> VALOR_ALTO) and (n.cod <> cod)) do begin
		 leer(arch, n);
		end; 
		if(n.cod = cod) then begin
			write('Nuevo género: '); readln(n.genero);
			write('Nuevo nombre: '); readln(n.nombre);
			write('Nuevo director: '); readln(n.director);
			write('Nueva duración: '); readln(n.duracion);
			write('Nuevo precio: '); readln(n.precio);
			seek(arch, filepos(arch) - 1);
			write(arch, n);
		end else begin
			writeln('No se encontró la novela buscada');
		end;
		close(arch);
	end;


procedure eliminarNovela(var arch: arch_novelas);
	var
		cod, pos: integer;
		n,n2: tNovela;
	begin
		reset(arch);
		writeln();
		writeln('---------------BORRAR NOVELA -----------');
		write('Ingrese el código de la novela que desea borrar: '); readln(cod);
		leer(arch, n);
		while((n.cod <> VALOR_ALTO) and (n.cod <> cod)) do begin
		 leer(arch, n);
		end; 
		if(n.cod = cod) then begin
			pos:= filePos(arch) - 1;  { guardo pos a borrar }
			seek(arch, 0);
			read(arch, n); { salvo contenido de reg cabecera (0, o pos del anteúltimo borrado) }
			seek(arch, 0); 
			n2.cod:= pos * -1;
			write(arch, n2); { guardo la nueva pos del último borrado }
			seek(arch, pos);
			write(arch, n); { guardo en el último borrado la pos del anteúltimo borrado }
		end else begin
			writeln('No se encontró la novela buscada');
		end;
		close(arch);
	end;


procedure imprimirMenuSecundario();
	begin
		writeln();
		writeln('Ingrese "1" para dar de alta una novela.');
		writeln('Ingrese "2" para modificar los datos de una novela.');
		writeln('Ingrese "3" para eliminar una novela.');
	end;

procedure mantenerArchivo(var arch: arch_novelas);
	var
		opcion: char;
	begin
		writeln(); writeln('---------MANTENIMIENTO DE ARCHIVO ---------');
		imprimirMenuSecundario();
		write('opcion: '); readln(opcion);
		case opcion of
			'1': darDeAltaNovela(arch);
			'2': modificarDatos(arch);
			'3': eliminarNovela(arch);
		end;
	end;


procedure imprimirMenuPrincipal();
	begin
		writeln();
		writeln('Para crear y cargar el archivo de novelas, ingrese "a"');
		writeln('Para abrir y mantener un archivo existente, ingrese "b"');
		writeln('Para listar todas las novelas, incluyendo las borradas, ingrese "c"');
		writeln('Para salir, ingrese "s"');
	end;

Var
	opcion: char;
	arch_nombre: cadena30;
	arch: arch_novelas;
Begin
	writeln('-------------ELIMINACIÓN DE REGISTROS CON LISTA INVERTIDA-----------');
	writeln('Ingrese el nombre del archivo con el que desea trabajar/crear');
	write('Nombre: '); readln(arch_nombre);
	assign(arch, arch_nombre);
	imprimirMenuPrincipal();
	write('opción: '); readln(opcion);
	while(opcion <> 's') do begin
		case opcion of
			'a': crearArchivo(arch);
			'b': mantenerArchivo(arch);
			'c': imprimirNovelas(arch);
		end;
		imprimirMenuPrincipal();
		write('opción: '); readln(opcion);
	end;
End.




