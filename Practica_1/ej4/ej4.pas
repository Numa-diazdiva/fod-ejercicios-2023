program fod_p01ej03;

Const
	VALOR_ALTO = 32000;

Type
	cadena30 = string[30];
	empleado = record
		nro: integer;
		apellido: cadena30;
		nombre: cadena30;
		edad: integer;
		dni: integer; {revisar este tipo para cumplir con la consigna}
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

procedure leer(var arch: archivo_empleados; var e: empleado);
	begin
		if not(eof(arch)) then begin
			read(arch, e);
		end else begin
			e.nro:= VALOR_ALTO;
		end;
	end;
	
{Recorre el archivo buscando el registro con el nro correspondiente}
{Le puse param por referencia a una función}
function contieneCodEmpleado(var arch: archivo_empleados; nro: integer): boolean;
	var
		e: empleado;
		contiene: boolean;
	begin
		contiene:= false;
		seek(arch, 0);
		leer(arch, e);
		while ((e.nro <> VALOR_ALTO) and (e.nro <> nro)) do begin
			leer(arch, e);
		end;
		{ checkeo si salió porque encontró algo }
		if (e.nro <> VALOR_ALTO) then
			contiene:= true;
		contieneCodEmpleado:= contiene;
	end;

procedure agregarEmpleado(var arch: archivo_empleados);
	var
		e: empleado;
	begin
		reset(arch);
		writeln();
		writeln('Agregarndo empleados. Ingrese el apellido "fin" para salir');
		writeln();
		LeerEmpleado(e);
		while(e.apellido <> 'fin') do begin
			if(not contieneCodEmpleado(arch,e.nro)) then begin
				seek(arch, filesize(arch));
				write(arch, e);
			end
			else
				writeln('El nro de empleado ya se encuentra registrado');
			LeerEmpleado(e);
		end;
		close(arch);
		writeln('**********************');
	end;


function buscarPos(var arch: archivo_empleados; nro: integer): integer;
	var
		e: empleado;
		pos: integer;
	begin
		pos:= -1;
		seek(arch, 0);
		leer(arch, e);
		while (e.nro <> VALOR_ALTO) and (e.nro <> nro) do
			leer(arch, e);
		if (e.nro <> VALOR_ALTO) then
			pos:= filePos(arch) - 1;
		buscarPos:= pos;
	end;
	
procedure modificarEdad (var arch: archivo_empleados);
	var
		nro, pos: integer;
		e: empleado;
	begin
		reset(arch);
		pos:= -1;
		if (contieneCodEmpleado(arch, 453)) then
			writeln('andaaa');
		writeln();
		writeln('-----------Modificar Edad ----------');
		write('Ingrese el nro de empleado cuya edad desea modificar (para salir ingrese -4): '); readln(nro);
		while (nro <> -4) do begin
			pos:= buscarPos(arch, nro);
			if (pos <> -1) then begin
				seek(arch, pos);
				read(arch, e);
				seek(arch, pos);
				write('Ingrese la nueva edad: '); readln(e.edad);
				write(arch, e);
			end;
			write('Ingrese el nro de empleado cuya edad desea modificar (para salir ingrese -4): '); readln(nro);		
		end;
		close(arch);
	end;
	
procedure exportarArchivoDeTexto(var arch: archivo_empleados);
	var
		archTexto: Text;
		e: empleado;
	begin
		assign(archTexto, 'todos_empleados.txt');
		rewrite(archTexto);
		reset(arch);
		leer(arch, e);
		while (e.nro <> VALOR_ALTO) do begin
			writeln(archTexto, e.apellido, ' ', e.nombre, ' ', e.nro, ' ', e.dni, ' ', e.edad, ' ');
			leer(arch, e);
		end;
		close(archTexto);
		close(arch);
	end;


procedure exportarEmpleadosSinDNI(var arch: archivo_empleados);
	var
		archTexto: Text;
		e: empleado;
	begin
		assign(archTexto, 'faltaDNIEmpleado.txt');
		rewrite(archTexto);
		reset(arch);
		leer(arch, e);
		while (e.nro <> VALOR_ALTO) do begin
			if(e.dni = 0) then
				writeln(archTexto,e.apellido, ' ', e.nombre, ' ', e.nro, ' ', e.dni, ' ', e.edad, ' ');
			leer(arch, e);
		end;
		close(archTexto);
		close(arch);
	end;

{---------------- Listar/ Imprimir ----------------}

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
		reset(arch);
		write('Ingrese el nombre o apellido a buscar: '); readln(nombreAp);
		while not(eof(arch)) do begin
			read(arch, e);
			if((e.apellido = nombreAp) or (e.nombre = nombreAp)) then
				ImprimirEmpleado(e);
		end;
		close(arch);
	end;
	
procedure ListarEmpleados(var arch: archivo_empleados);
	var
		e: empleado;
	begin
		reset(arch);
		while not(eof(arch)) do begin
			read(arch, e);
			ImprimirEmpleado(e);
		end;
		close(arch);
	end;

procedure ListarEmpleadosMayores(var arch: archivo_empleados);
	var
		e: empleado;
	begin
		reset(arch);
		while not(eof(arch)) do begin
			read(arch, e);
			if (e.edad > 70) then
				ImprimirEmpleado(e);
		end;
		close(arch);
	end;

{------------MENU---------------}

procedure ImprimirMenuPrincipal();
	begin
		writeln(); writeln();
		writeln('**********************************');
		writeln('Carga y procesamiento de empleados');
		writeln('Para crear un archivo nuevo ingrese a'); 
		writeln('Para procesar un archivo ingrese b');
		writeln('Para modificar un archivo o extraer sus datos ingrese c');
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
	
procedure ImprimirMenuModificar();
	begin
		writeln();
		writeln('-------- Modificación y generación de archivos --------');
		writeln('Ingrese "1" para Añadir uno o más empleados al final del archivo.');
		writeln('Ingrese "2" para Modificar la edad de uno o más empleados.');
		writeln('Ingrese "3" para exportar el contenido del archivo a un archivo de texto.');
		writeln('Ingrese "4" para exportar aquellos empleados que no tengan dni cargado.');
		writeln('Ingrese cualquier otro caracter para salir.');
	end;

{----------------------------------}

procedure ProcesarArchivo();
	var 
		opcion: char;
		arch: archivo_empleados;
		arch_nombre: cadena30;
	begin
		writeln();
		write('---> Insterte el nombre del archivo a procesar: '); readln(arch_nombre);
		assign(arch, arch_nombre);
		ImprimirMenuSecundario();
		write('opcion: '); readln(opcion);
		{ muevo el reset y close a los procedimientos }
		case opcion of
			'1': ListarNombreAp(arch);
			'2': ListarEmpleados(arch);
			'3': ListarEmpleadosMayores(arch);
			else writeln('saliendo ...');
		end;
	end;

procedure ModificarArchivo();
	var
		opcion: char;
		arch: archivo_empleados;
		arch_nombre: cadena30;
	begin
		writeln();
		write('---> Insterte el nombre del archivo a procesar: '); readln(arch_nombre);
		assign(arch, arch_nombre);
		ImprimirMenuModificar();
		write('opcion: '); readln(opcion);
		case opcion of
			'1': agregarEmpleado(arch);
			'2': modificarEdad(arch);
			'3': exportarArchivoDeTexto(arch);
			'4': exportarEmpleadosSinDNI(arch);
		end;
		writeln();
	end;

Var
	arch: archivo_empleados;
	arch_nombre: cadena30;
	opcion: char;
Begin
	ImprimirMenuPrincipal();
	write('Opcion: '); readln(opcion);
	while (opcion <> 's') do begin
		case opcion of
			'a': CargarEmpleados(arch_nombre, arch);
			'b': ProcesarArchivo();
			'c': ModificarArchivo();
		end;
		ImprimirMenuPrincipal();
		write('Opcion: '); readln(opcion);
	end;
	
	writeln('Fin del programa');
End.




{
* Otro módulo para buscar que no anda de todas formas
* 
* procedure buscar(var arch: archivo_empleados; var e: empleado; var pos: integer; nro: integer);
	begin
		seek(arch, 0);
		leer(arch, e);
		while (e.nro <> VALOR_ALTO) and (e.nro <> nro) do begin
			leer(arch, e);
		end;
		if (e.nro <> VALOR_ALTO) then
			pos:= filepos(arch) - 1
		else
			pos:= -1;
	end;
	
* 
* 
* 
* 
* 
* }
