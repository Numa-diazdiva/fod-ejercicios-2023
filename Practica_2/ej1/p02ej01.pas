
program fod_p02ej01;


Type
	cadena30 = string[30];
	ingreso = record
		codigo: integer;
		nombre: cadena30;
		monto: real;
	end;
	
	arch_ingresos = file of ingreso;
	

procedure leerIngreso(var i: ingreso);
	begin
		writeln('-----------');
		write('codigo: '); readln(i.codigo);
		if (i.codigo <> -1) then begin
			write('nombres: '); readln(i.nombre);
			write('monto: '); readln(i.monto);
		end;
	end;
	

procedure cargarArchivoIngresos(var archI: arch_ingresos);
	var
		i: ingreso;
	begin
		rewrite(archI);
		writeln(); writeln('-----------CARGA DE ARCHIVO DE INGRESOS-----------');
		writeln('Cargue los datos de los ingresos. Para salir ingrese el código de empleado "-1"');
		leerIngreso(i);
		while(i.codigo <> -1) do begin
			write(archI, i);
			leerIngreso(i);
		end;
		writeln(); writeln('Carga Finalizada'); writeln();
		close(archI);
	end;

procedure leer(var archI: arch_ingresos; var i: ingreso);
	begin
		if(not eof(archI)) then
			read(archI,i)
		else
			i.codigo:= -1;
	end;

procedure compactarArchivoIngresos(var archI, archIC: arch_ingresos);
	var
		i, i2: ingreso;
	begin
		rewrite(archIC);
		reset(archI);
		leer(archI,i);
		while(i.codigo <> -1) do begin
			i2.codigo:= i.codigo;
			i2.nombre:= i.nombre;
			i2.monto:= 0;
			while(i.codigo = i2.codigo) do begin
				i2.monto:= i2.monto + i.monto;
				leer(archI,i);
			end;
			write(archIC, i2);
		end;
		close(archI);
		close(archIC);
	end;
	
procedure imprimirIngreso(i: ingreso);
	begin
		writeln(); writeln('-----------------');
		writeln('Codigo empleado: ', i.codigo);
		writeln('Nombre empleado: ', i.nombre);
		writeln('Monto: ', i.monto:0:2);
	end;
	
procedure imprimirArchivo(var a: arch_ingresos);
	var
		i: ingreso;
	begin
		reset(a);
		while(not eof(a)) do begin
			read(a, i);
			imprimirIngreso(i);
		end;
		close(a);
	end;
	
Var	
	ingresos, ingresosCompactado: arch_ingresos;
	nombreIngresos, nombreIngresosCompactado: cadena30;
	opcion: char;
Begin
	writeln('--Compactado de ingresos de ventas--');
	writeln('Ingrese el nombre del archivo de ingresos: '); readln(nombreIngresos);
	writeln('Ingrese el nombre del archivo de ingresos compactado: '); readln(nombreIngresosCompactado);
	assign(ingresos, nombreIngresos);
	assign(ingresosCompactado, nombreIngresosCompactado);
	
	writeln('Ingrese "1" para cargar ventas / Ingrese "2" para compactar el archivo de ventas / Ingrese "s" para salir');
	write('opción: '); readln(opcion);
	
	while(opcion <> 's') do begin
		if(opcion = '1') then begin
			cargarArchivoIngresos(ingresos);
		end else begin
			if(opcion = '2') then
				compactarArchivoIngresos(ingresos, ingresosCompactado);
		end;
		writeln('Ingrese "1" para cargar ventas / Ingrese "2" para compactar el archivo de ventas / Ingrese -1 para salir');
		write('opción: '); readln(opcion);
	end;
	
	writeln('Ingrese "3" para imprimir el archivo de ingresos original, o "4" para imprimir el archivo compactado. Ingrese 0 para salir');
	write('opción: '); readln(opcion);
	
	while(opcion <> '0') do begin
		if(opcion = '3') then begin
			imprimirArchivo(ingresos);
		end else begin
			imprimirArchivo(ingresosCompactado);
		end;
		writeln('Ingrese "3" para imprimir el archivo de ingresos original, o "4" para imprimir el archivo compactado. Ingrese 0 para salir');
		write('opción: '); readln(opcion);
	end;
End.
	
