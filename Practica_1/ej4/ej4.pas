program fod_p01ej03;

Type
	cadena30 = string[30];
	empleado = record
		nro: integer;
		apellido: cadena30;
		nombre: cadena30;
		edad: integer;
		dni: integer;
	end;

	archivo_empleados = file of empleado;


procedure LeerEmpleado(var e: empleado);
	begin
		writeln('Leyendo empleado');
		write('Ingrese el apellido: '); readln(e.apellido);
		if (e.apellido <> 'fin') then begin
			write('Ingrese el nombre: '); readln(e.nombre);
			write('Ingrese el nro: '); readln(e.nro);
			write('Ingrese la edad: '); readln(e.edad);
			write('Ingrese el dni: '); readln(e.dni);
		end;
		writeln('-----------------');
	end;

{ Crea un archivo nuevo con el nombre especificado, lo carga y lo guarda }
procedure CargarEmpleados(var arch_nombre:cadena30; var arch: archivo_empleados);
	var
		emp: empleado;
	begin
		writeln('---------------------------');
		write('Ingrese el nombre del archivo que desea generar: '); readln(arch_nombre);
		assign(arch, arch_nombre);
		rewrite(arch);
		LeerEmpleado(emp);
		while(emp.apellido <> 'fin') do begin
			write(arch, emp);
			LeerEmpleado(emp);
		end;
		close(arch);
		writeln('Carga finalizada');
	end;

procedure ImprimirEmpleado(e: empleado);
	begin
		writeln();
		writeln('-------------------');
		writeln('Nombre: ', e.nombre);
		writeln('Apellido: ', e.apellido);
		writeln('Nro: ', e.nro);
		writeln('DNI: ', e.dni);
		writeln('Edad: ', e.edad);
		writeln();
	end;

procedure ListarNombreAp(var arch: archivo_empleados);
	var
		e: empleado;
		nombreAp: cadena30;
	begin
		write('Ingrese el nombre o apellido a buscar: '); readln(nombreAp);
		while not(eof(arch)) do begin
			read(arch, e);
			if((e.apellido = nombreAp) or (e.nombre = nombreAp)) then
				ImprimirEmpleado(e);
		end;
	end;
	
procedure ListarEmpleados(var arch: archivo_empleados);
	var
		e: empleado;
	begin
		while not(eof(arch)) do begin
			read(arch, e);
			ImprimirEmpleado(e);
		end;
	end;

procedure ListarEmpleadosMayores(var arch: archivo_empleados);
	var
		e: empleado;
	begin
		while not(eof(arch)) do begin
			read(arch, e);
			if (e.edad > 70) then
				ImprimirEmpleado(e);
		end;
	end;

procedure ImprimirMenuPrincipal();
	begin
		writeln(); writeln();
		writeln('**********************************');
		writeln('Carga y procesamiento de empleados');
		writeln('Para crear un archivo nuevo ingrese a'); 
		writeln('Para procesar un archivo ingrese b');
		writeln('Para salir ingrese s');
	end;

procedure ImprimirMenuSecundario();
	begin
		writeln();
		writeln('--------Consulta de registros de archivo --------');
		writeln('Ingrese "1" para Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('Ingrese "2" para listar los datos de los empleados por línea.');
		writeln('Ingrese "3" para listar en pantalla los empleados mayores de 70 años próximos a jubilarse.');
		writeln('Ingrese cualquier otro caracter para salir.');
	end;

Var
	arch: archivo_empleados;
	arch_nombre: cadena30;
	opcion: char;
Begin
	ImprimirMenuPrincipal();
	write('Opcion: '); readln(opcion);
	while (opcion <> 's') do begin
		if (opcion = 'a') then begin
			CargarEmpleados(arch_nombre, arch);
		end
		else begin
			if(opcion = 'b') then begin 
				writeln();
				write('---> Insterte el nombre del archivo a procesar: '); readln(arch_nombre);
				assign(arch, arch_nombre);
				ImprimirMenuSecundario();
				write('opcion: '); readln(opcion);
				reset(arch);
				case opcion of
					'1': ListarNombreAp(arch);
					'2': ListarEmpleados(arch);
					'3': ListarEmpleadosMayores(arch);
					else writeln('saliendo ...');
				end;
				close(arch);
			end;
		end;
		ImprimirMenuPrincipal();
		write('Opcion: '); readln(opcion);
	end;
	
	writeln('Fin del programa');
	
	
End.
