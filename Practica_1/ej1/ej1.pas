program fod_p01ej01;

Const
	FIN = 30000;
Type
	arch_enteros = file of integer;
	cadena30 = string[30];
Var
	arch: arch_enteros;
	num: integer;
	nombre_arch: string;
Begin
	writeln('Carga de números enteros. Introduzca números enteros. Para finalizar, ingrese el número 30000');
	write('Ingrese el nombre del archivo: '); readln(nombre_arch);
	{ vinculamos arch lógico con nombre }
	Assign(arch, nombre_arch);
	{ creamos el archivo lógico }
	Rewrite(arch);
	writeln('--------');
	write('Num: '); readln(num);
	while (num <> FIN) do begin
		write(arch, num);
		write('Num: '); readln(num);
	end;
	
	close(arch);
	writeln('Escritura finalizada');
	
End.
