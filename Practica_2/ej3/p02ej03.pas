program fod_p02ej03;
Uses sysutils;

Const
	valor_alto = 32000;
	dimF = 30;
Type
	cadena30 = string[30];
	cadena150 = string[150];
	producto = record
		cod: integer;
		nombre: cadena30;
		descripcion: cadena150;
		precio: real;
		stockActual: integer;
		stockMin: integer;
	end;
	productoDetalle = record
		cod: integer;
		cantVendido: integer;
	end;

	arch_maestro = file of producto;
	arch_detalle = file of productoDetalle;
	detalles = array[1 .. dimF] of arch_detalle;
	productosDetalle = array[1 .. dimF] of productoDetalle;


procedure assignTodos(var aD: detalles);
	var
		i: integer;
	begin
		for i:= 1 to dimF do
			assign(aD[i], 'detalle' + IntToStr(i));
	end;

procedure resetTodos(var aD: detalles);
	var
		i: integer;
	begin
		for i:= 1 to dimF do
			reset(aD[i]);
	end;
	
procedure closeTodos(var aD: detalles);
	var
		i: integer;
	begin
		for i:= 1 to dimF do
			close(aD[i]);
	end;

procedure leer(var aD: arch_detalle; var d: productoDetalle);
		begin
			if (not eof(aD)) then
				read(aD, d)
			else
				d.cod:= valor_alto;
		end;

{ Si no hay más mínimos que extraer, el procedimiento devuelve el código del registro en valor_alto }
procedure min(var aD: detalles; var productos: productosDetalle; var d: productoDetalle);
	var
		min: productoDetalle;
		i, iMin: integer;
	begin
		min.cod:= valor_alto;
		for i:= 1 to dimF do begin
			if (productos[i].cod < min.cod) then begin
				min:= productos[i];
				iMin:= i;
			end;
		end;
		
		if(min.cod <> valor_alto) then begin
			d:= min;
			leer(aD[iMin], productos[iMin]);
		end;
	end;

procedure actualizarMaestroDetalle(var aM: arch_maestro; var aD: detalles);
	var
		productos: productosDetalle;
		pM: producto;
		pD: productoDetalle;
		i: integer;
	begin
		reset(aM);
		resetTodos(aD);
		for i:= 1 to dimF do
			leer(aD[i], productos[i]);
		min(aD, productos, pD);
		read(aM, pM);
		while(pD.cod <> valor_alto) do begin
			{ busco el producto en el maestro }
			while(pD.cod <> pM.cod) do
				read(aM, pM);
			
			while(pM.cod = pD.cod) do begin
				pM.stockActual:= pM.stockActual - pD.cantVendido;
				min(aD, productos, pD);
			end;
			seek(aM, filepos(aM) - 1);
			write(aM, pM);
		end;
		close(aM);
		closeTodos(aD);
	end;


Var
	aM: arch_maestro;
	aD: detalles;
Begin
	assign(aM, 'maestro');
	assignTodos(aD);
	actualizarMaestroDetalle(aM, aD);
End.
