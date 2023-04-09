program fod_p02ej04;
Uses sysutils;

Const
	valor_alto = 32000;
	dimF = 5;
Type
	t_fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	log = record
		codUsr: integer;
		fecha: t_fecha;
		tiempoSesion: integer;
	end;
	
	usuario = record
		codUsr: integer;
		fecha: t_fecha;
		tiempoTotalDeSesion: integer;
	end;

	detalle = file of log;
	maestro = file of usuario;
	detalles = array[1..dimF] of detalle;
	logs_detalle = array[1..dimF] of log;

procedure resetTodos(var d: detalles);
	var
		i: integer;
	begin
		for i:= 1 to dimF do
			reset(d[i]);
	end;
	
procedure closeTodos(var d: detalles);	
	var
		i: integer;
	begin
		for i:= 1 to dimF do
			close(d[i]);
	end;
	
procedure leerDetalle(var aD: detalle; var l: log);
	begin
		if(not eof(aD)) then
			read(aD, l)
		else
			l.codUsr:= valor_alto;
	end;


procedure min(d: detalles; logs: logs_detalle; logMin: log);
	var
		i,iMin: integer;
	begin
		logMin.codUsr:= valor_alto;
		for i:= 1 to dimF do begin
			if(logs[i].codUsr < logMin.codUsr) then begin
				logMin:= logs[i];
				iMin:= i;
			end
		end;
		if(logMin.codUsr <> valor_alto) then begin
			leerDetalle(d[iMin], logs[iMin]);
		end;
	end;

procedure merge(var m: maestro; var d: detalles);
	var
		logs: logs_detalle;
		usr: usuario;
		logMin: log;
		i: integer;
	begin
		rewrite(m);
		resetTodos(d);
		for i:= 1 to dimF do
			leerDetalle(d[i], logs[i]);
		min(d, logs, logMin);
		while(logMin.codUsr <> valor_alto) do begin
			usr.codUsr:= logMin.codUsr;
			usr.tiempoTotalDeSesion:= 0;
			usr.fecha:= logMin.fecha; { no entiendo qué es este campo en el maestro, consultar }
			while(usr.codUsr = logMin.codUsr) do begin
				usr.tiempoTotalDeSesion:= usr.tiempoTotalDeSesion + logMin.tiempoSesion;
				min(d, logs, logMin);
			end;
			write(m, usr);
		end;
		close(m);
		closeTodos(d);
	end;

procedure assignDetalles(var d: detalles);	
	var
		i: integer;
	begin
		for i:= 1 to dimF do
			assign(d[i], 'detalle' + IntToStr(i));
	end;
	
	
Var
	d: detalles;
	m: maestro;
	opcion: integer;
Begin
	assign(m, '/var/log/maestro');
	assignDetalles(d);
	write('Ingrese 1 si quiere cargar el archivo de detalles para testeo: '); readln(opcion);
	if(opcion = 1) then begin
		writeln();
	end;
	merge(m, d);

End.
