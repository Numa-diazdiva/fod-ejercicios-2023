program fod_p01ej02;

Const
	LIMITE = 1500;
Type
	arch_enteros = file of integer;
	cadena30 = string[30];

Var
	arch: arch_enteros;
	nombre: cadena30;
	cantidad, num: integer;
Begin
	cantidad:= 0;
	write('Ingrese el nombre del archivo que desea procesar: '); readln(nombre);
	Assign(arch, nombre);
	reset(arch);
	
	while not eof(arch) do begin
		read(arch, num);
		if (num < LIMITE) then
			cantidad:= cantidad + 1;
	end;
	
	writeln('La cantidad de numeros menores a ', LIMITE, ' es: ', cantidad);

End.
