program fod_p02ej05;
uses sysutils;

Const
	VALOR_ALTO = 32000;
	DIMF = 50;
Type
	cadena30 = string[30];
	t_direccion = record
		calle: cadena30;
		nro: integer;
		piso: integer;
		depto: char;
		ciudad: cadena30;
	end;
	
	t_hora = record
		hora: 0..23;
		minutos: 1..60;
	end;
	
	t_fechaYHora = record
		anio: integer;
		dia: 1..31;
		mes: 1..12;
		hora: t_hora;
	end;
	
	t_nacimiento = record
		nroPartida: integer;
		nombre: cadena30;
		apellido: cadena30;
		direccion: t_direccion;
		matriculaMedico: integer;
		nombreMadre: cadena30;
		apellidoMadre: cadena30;
		DNIMadre: integer;
		nombrePadre: cadena30;
		apellidoPadre: cadena30;
		DNIPadre: integer;
		{ ver de agrupar datos de progenitores en registro }
	end;
	
	t_fallecimiento = record
		nroPartidaNac: integer;
		nombre: cadena30;
		apellido: cadena30;
		matriculaMedico: integer;
		fechaHora: t_fechaYHora;
		lugar: t_direccion; { o str? }
		DNI: integer;
	end;
	
	
	t_persona = record
		nroPartidaNac: integer;
		nombre: cadena30;
		apellido: cadena30;
		direccion: t_direccion;
		matriculaMedico: integer;
		nombreMadre: cadena30;
		apellidoMadre: cadena30;
		DNIMadre: integer;
		nombrePadre: cadena30;
		apellidoPadre: cadena30;
		DNIPadre: integer;
		fallecio: boolean;
		matriculaMedicoDeceso: integer;
		fechaHoraDeceso: t_fechaYHora;
		lugarDeceso: t_direccion;
	end;
	
	arch_nacimientos = file of t_nacimiento;
	arch_fallecimientos = file of t_fallecimiento;
	
	t_delegacion = record
		nacimientos: arch_nacimientos;
		fallecimientos: arch_fallecimientos;
	end;
	
	t_delegaciones = array[1..DIMF] of t_delegacion;
	t_maestro = file of t_persona;
	
	arregloNacimientos = array[1..DIMF] of t_nacimiento;
	arregloFallecimientos = array[1..DIMF] of t_fallecimiento;
	
	
procedure asignarDelegaciones(d: t_delegaciones);
	var
		i: integer;
	begin
		for i:= 1 to DIMF do begin
			assign(d[i].nacimientos, 'del/' + IntToStr(i) + '/nacimientos');
			assign(d[i].nacimientos, 'del/' + IntToStr(i) + '/fallecimientos');
		end;
	end;

procedure abrirArchDelegaciones(d: t_delegaciones);
	var
		i: integer;
	begin
		for i:= 1 to DIMF do begin
			reset(d[i].nacimientos);
			reset(d[i].fallecimientos);
		end;
	end;

procedure cerrarDetalles(d: t_delegaciones);
	var
		i: integer;
	begin
		for i:= 1 to DIMF do begin
			close(d[i].nacimientos);
			close(d[i].fallecimientos);
		end;
	end;
	
procedure leerNacimiento(var nacimientos: arch_nacimientos; var n: t_nacimiento);
	begin
		if (not eof(nacimientos)) then
			read(nacimientos, n)
		else
			n.nroPartida:= VALOR_ALTO;
	end;

procedure leerFallecimiento(var fallecimientos: arch_fallecimientos; var f: t_fallecimiento);
	begin
		if (not eof(fallecimientos)) then
			read(fallecimientos, f)
		else
			f.nroPartidaNac:= VALOR_ALTO;
	end;

procedure minimoNacimiento(var d: t_delegaciones; var nAct: arregloNacimientos; var nMin: t_nacimiento);
	var
		i, iMin: integer;
	begin
		nMin.nroPartida:= VALOR_ALTO;
		for i:= 1 to DIMF do begin
			if(nAct[i].nroPartida < nMin.nroPartida) then begin
				nMin:= nAct[i];
				iMin:= i;
			end;
		end;
		if (nMin.nroPartida <> VALOR_ALTO) then begin
			leerNacimiento(d[iMin].nacimientos, nAct[i]);
		end;
	end;
	
procedure minimoFallecimiento(var d: t_delegaciones; var fAct: arregloFallecimientos; var fMin: t_fallecimiento);
	var
		i, iMin: integer;
	begin
		fMin.nroPartidaNac:= VALOR_ALTO;
		for i:= 1 to DIMF do begin
			if(fAct[i].nroPartidaNac < fMin.nroPartidaNac) then begin
				fMin:= fAct[i];
				iMin:= i;
			end;
		end;
		if (fMin.nroPartidaNac <> VALOR_ALTO) then begin
			leerFallecimiento(d[iMin].fallecimientos, fAct[i]);
		end;
	end;

procedure asignarDatosNacimiento(var p: t_persona; n: t_nacimiento);
	begin
		p.nroPartidaNac:= n.nroPartida;
		p.nombre:= n.nombre;
		p.apellido:= n.apellido;
		p.direccion:= n.direccion;
		p.matriculaMedico:= n.matriculaMedico;
		p.nombreMadre:= n.nombreMadre;
		p.apellidoMadre:= n.apellidoMadre;
		p.DNIMadre:= n.DNIMadre;
		p.nombrePadre:= n.nombrePadre;
		p.apellidoPadre:= n.apellidoPadre;
		p.DNIPadre:= n.DNIPadre;
	end;
	
procedure asignarDatosFallecimiento(var p: t_persona; f: t_fallecimiento);
	begin
		p.fallecio:= true;
		p.matriculaMedicoDeceso:= f.matriculaMedico;
		p.fechaHoraDeceso:= f.fechaHora;
		p.lugarDeceso:= f.lugar;
	end;

procedure asignarNoFallecido(var p: t_persona);
	begin
		p.fallecio:= false;
		p.matriculaMedicoDeceso:= 0;
	end;
procedure merge(var m: t_maestro; var d: t_delegaciones);
	var
		nacimientosAct: arregloNacimientos;
		fallecimientosAct: arregloFallecimientos; 
		nacimientoMin: t_nacimiento;
		fallecimientoMin: t_fallecimiento;
		nuevaPersona: t_persona;
		i: integer;
	begin
		rewrite(m);
		abrirArchDelegaciones(d);
		
		for i:= 1 to DIMF do begin
			leerNacimiento(d[i].nacimientos, nacimientosAct[i]);
			leerFallecimiento(d[i].fallecimientos, fallecimientosAct[i]);
		end;
		
		minimoNacimiento(d, nacimientosAct, nacimientoMin);
		minimoFallecimiento(d, fallecimientosAct, fallecimientoMin); { creo que así me ahorro buscar una y otra vez por coincidencia }
		
		while(nacimientoMin.nroPartida <> VALOR_ALTO) do begin
			asignarDatosNacimiento(nuevaPersona, nacimientoMin);
			
			if(nacimientoMin.nroPartida = fallecimientoMin.nroPartidaNac) then begin
				asignarDatosFallecimiento(nuevaPersona, fallecimientoMin);
				minimoFallecimiento(d, fallecimientosAct, fallecimientoMin);
			end else begin
				asignarNoFallecido(nuevaPersona);
			end;
			write(m, nuevaPersona);
			minimoNacimiento(d, nacimientosAct, nacimientoMin);
		end;
		
		close(m);
		cerrarDetalles(d);
	end;
	
Var
	delegaciones: t_delegaciones;
	maestro: t_maestro;
Begin
	assign(maestro, 'maestro');
	asignarDelegaciones(delegaciones);
	merge(maestro, delegaciones);
End.
