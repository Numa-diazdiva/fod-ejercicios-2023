program p02ej08;
Const
	VALOR_ALTO = 32000;
Type
	cadena30 = string[30];
	
	t_cliente = record
		cod: integer;
		nombre: cadena30;
		apellido: cadena30;
	end;
	
	t_venta = record
		cliente: t_cliente;
		anio: integer;
		mes: 1..12;
		dia: 1..31;
		monto: real;
	end;
	
	{ va ordenado por codCliente, año y mes }
	arch_maestro = file of t_venta;

procedure leer(var ventas: arch_maestro; var venta: t_venta);
	begin
		if (not eof(ventas)) then
			read(ventas, venta);
		else
			venta.cod:= VALOR_ALTO;
	end;

procedure imprimirDatosCliente(c: t_cliente);
	begin
		writeln('-----------------');
		writeln('Cliente: ', c.cod);
		writeln('Nombre: ', c.nombre);
		writeln('Apellido: ', c.apellido);
	end;

function esMismoCliente(c: t_cliente; v: t_venta);
	begin
		esMismoCliente:= c.cod = v.cliente.cod;
	end;

procedure procesarVentas(var ventas: arch_maestro);
	var
		venta: t_venta;
		clienteActual: t_cliente;
		anioActual: integer;
		mesActual: 1..12;
		totalAnio: real;
		totalMes: real;
	begin
		reset(ventas);
		leer(ventas, venta);
		while(venta.cliente.cod <> VALOR_ALTO) do begin
			clienteActual:= venta.cliente;
			imprimirDatosCliente(clienteActual);
			while (esMismoCliente(clienteActual, venta)) do begin
				anioActual:= venta.anio;
				totalAnio:= 0;
				while(esMismoCliente(clienteActual, venta) and venta.anio = anioActual) do begin
					mesActual:= venta.mes;
					totalMes:= 0;
					while(esMismoCliente(clienteActual, venta) and (venta.anio = anioActual) and (venta.mes = mesActual)) do begin
						totalMes:= totalMes + venta.monto;
						leer(ventas, venta);
					end;
					writeln('El total de ventas del mes ', mesActual, ' fue de : $', totalMes:0:2);
					totalAnio:= totalAnio + totalMes;
				end;
				writeln('El total de ventas del anio ', anioActual, ' fue de : $', totalAnio:0:2);
			end;		
		end;
		close(ventas);
	end;

Var
	ventas: arch_maestro

Begin
	assign(ventas, 'maestro_ventas');
	procesarVentas(ventas);
End.
