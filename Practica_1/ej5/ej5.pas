program fod_p01ej05;

Type
	cadena30 = string[30];
	cadena150 = string[150];
	celular = record
		codigo: integer;
		nombre: cadena30;
		descripcion : cadena150;
		marca: cadena30;
		precio: real;
		stockMin: integer;
		stockActual: integer;
	end;

	archivo_celulares = file of celular;

procedure cargarArchivo(var archLB: archivo_celulares; var archTexto: Text);
	var
		c: celular;
	begin
		rewrite(archLB);
		reset(archTexto);
		while not eof(archTexto) do begin
			readln(archTexto, c.codigo, c.precio, c.marca);
			readln(archTexto, c.stockActual, c.stockMin, c.descripcion);
			readln(archTexto, c.nombre);
			write(archLB, c);
		end;
		close(archLB);
		close(archTexto);
	end;

procedure imprimirCelular(c: celular);
	begin
		writeln('--------Celular: ', c.nombre);
		writeln('-> código: ', c.codigo);
		writeln('-> descripción: ', c.descripcion);
		writeln('-> marca: ', c.marca);
		writeln('-> precio: ', c.precio:0:2);
		writeln('-> stock mínimo: ', c.stockMin);
		writeln('-> stock actual: ', c.stockActual);
	end;

procedure listarStockBajo(var archLB: archivo_celulares);
	var
		c: celular;
	begin
		writeln(); writeln('-------- Celulares con bajo stock ----------');
		{ con este orden en este caso sencillo no hace falta usar el procedimiento leer() }
		reset(archLB);
		while not eof(archLB) do begin
			read(archLB, c);
			if(c.stockActual < c.stockMin) then
				imprimirCelular(c);
		end;
		close(archLB);
	end;

procedure listarCelularesConDescripcion(var archLB: archivo_celulares);
	var
		descripcion: cadena150;
		c: celular;
	begin
		writeln(); writeln('-------- Búsqueda de celulares por descripción --------');
		write('Ingrese la descripción a buscar: '); readln(descripcion);
		descripcion:= ' ' + descripcion;
		reset(archLB);
		while not eof(archLB) do begin
			read(archLB, c);
			if (c.descripcion = descripcion) then
				imprimirCelular(c);
		end;
		close(archLB);
	end;

procedure exportarATexto(var archLB: archivo_celulares);
	var
		c: celular;
		archTxt: Text;
	begin
		assign(archTxt, 'texto_alt.txt');
		rewrite(archTxt);
		reset(archLB);
		while not eof(archLB) do begin
			read(archLB, c);
			writeln(archTxt, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
			writeln(archTxt, c.stockActual, ' ', c.stockMin, ' ', c.descripcion);
			writeln(archTxt, c.nombre);
		end;
		close(archLB);
		close(archTxt);
	end;

procedure imprimirMenu();
	begin
		writeln();	
		writeln('Para crear un archivo de registros a partir de un archivo de textos ingrese "a"');
		writeln('Para listar en pantalla los celulares con stock menor al stock mínimo ingrese "b"');
		writeln('Para listar en pantalla los celulares que tengan una descripción ingrese "c"');
		writeln('Para exportar el archivo binario a otro archivo de texto ingrese "d"');
		writeln('Para salir ingrese "s"');
		writeln();
	end;

Var
	archLB: archivo_celulares;
	archTexto: Text;
	archNombre: cadena30;
	opcion: char;
Begin
	writeln('Carga de archivo binario de celulares');
	writeln();
	write('Ingrese el nombre del archivo con el que desea trabajar: '); readln(archNombre);
	assign(archLB, archNombre);
	assign(archTexto, 'celulares.txt');
	
	imprimirMenu();
	write('Opción: '); readln(opcion);
	
	while (opcion <> 's') do begin
		case opcion of
			'a': cargarArchivo(archLB, archTexto);
			'b': listarStockBajo(archLB);
			'c': listarCelularesConDescripcion(archLB);
			'd': exportarATexto(archLB);
		end;
		writeln();
		imprimirMenu();
		write('Opción: '); readln(opcion);
	end;
End.
