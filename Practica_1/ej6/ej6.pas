program p01ej06;

Const
	VALOR_BAJO = -32000;
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
		writeln();
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

procedure leerCelular(var c: celular);
	begin
		writeln();
		write('Código: '); readln(c.codigo);
		if (c.codigo <> -1) then begin
			write('Nombre: '); readln(c.nombre);
			write('Marca: '); readln(c.marca);
			write('Descripción: '); readln(c.descripcion);
			write('Precio: '); readln(c.precio);
			write('Stock actual: '); readln(c.stockActual);
			write('Stock mínimo: '); readln(c.stockMin);
		end;
		writeln();
	end;

procedure agregarAlFinal(var archLB: archivo_celulares);
	var
		c: celular;
	begin
		reset(archLB);
		seek(archLB, fileSize(archLB));
		writeln(); writeln('------- Carga de celulares -------');
		writeln('Ingrese los datos de los celulares. Para salir ingrese el código de celular -1.');
		leerCelular(c);
		while (c.codigo <> -1) do begin
			write(archLB, c);
			leerCelular(c);
		end;
		close(archLB);
		writeln();
		writeln('Lectura finalizada.');
	end;
	
procedure leer(var archLB: archivo_celulares; var c: celular);
	begin
		if(not eof(archLB)) then
			read(archLB, c)
		else
			c.nombre:= 'fin';
	end;

procedure modificarStock(var archLB: archivo_celulares);
	var
		c: celular;
		nombre: cadena30;
	begin
		{ se puede modularizar más la búsqueda, como en el ejercicio 4 }
		reset(archLB);
		writeln();
		writeln('-------- Modificación de stock ---------');
		write('Ingrese el nombre del celular cuyo stock quiere modificar: '); readln(nombre);
		leer(archLB, c);
		while (c.nombre <> 'fin') and (c.nombre <> nombre) do
			leer(archLB, c);
		if (c.codigo <> VALOR_BAJO) then begin
			write('Ingrese el nuevo stock (stock previo: ', c.stockActual, '): ');
			readln(c.stockActual);
			seek(archLB, filepos(archLB) - 1);
			write(archLB, c);
		end else begin
			writeln('No se encontró el celular de nombre ', nombre);
		end;
		close(archLB);
	end;

procedure exportarSinStock(var archLB: archivo_celulares);
	var
		c: celular;
		archTxt: Text;
	begin
		reset(archLB);
		assign(archTxt, 'SinStock.txt');
		rewrite(archTxt);
		writeln(); writeln('--------- Exportar celulares sin stock ------------');
		while not eof(archLB) do begin
			read(archLB, c);
			if (c.stockActual = 0) then
				writeln(archTxt, 'Cod: ', c.codigo, ' Nombre: ', c.nombre, ' Marca: ', c.marca);				
		end;
		close(archTxt);
		close(archLB);
	end;

procedure imprimirMenu();
	begin
		writeln();	
		writeln('Para crear un archivo de registros a partir de un archivo de textos ingrese "a"');
		writeln('Para listar en pantalla los celulares con stock menor al stock mínimo ingrese "b"');
		writeln('Para listar en pantalla los celulares que tengan una descripción ingrese "c"');
		writeln('Para exportar el archivo binario a otro archivo de texto ingrese "d"');
		writeln('Para añadir más celulares al archivo, ingrese "e"');
		writeln('Para modificar el stock de un celular, ingrese "f"');
		writeln('Para exportar los celulares sin stock a un archivo de texto ingrese "g"');
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
			'e': agregarAlFinal(archLB);
			'f': modificarStock(archLB);
			'g': exportarSinStock(archLB);
		end;
		writeln();
		imprimirMenu();
		write('Opción: '); readln(opcion);
	end;
End.
