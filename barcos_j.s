@;=============== Fichero fuente de la pr�ctica de los barcos  =================
@;== 	define las rutinas jugar() y sus rutinas auxiliares					  ==
@;== 	programador1: aleix.marine@estudiants.urv.cat							  ==
@;== 	programador2: daniel.diazf@estudiants.urv.cat							  ==


@;-- .text. c�digo de las rutinas ---
.text	
		.align 2
		.arm


@; jugar(int dim, char tablero_disparos[]):
@;	rutina para realizar los lanzamientos contra el tablero de barcos iniciali-
@;	zado con la �ltima llamada a B_incializa_barcos(), anotando los resultados
@;	en el tablero de disparos que se pasa por par�metro (por referencia), donde
@;	los dos tableros tienen el mismo tama�o (dim = dimensi�n del tablero de
@;	barcos). La rutina realizar� los disparos necesarios hasta hundir todos los
@;	barcos, devolviendo el n�mero total de disparos realizado.
@;	Par�metros:
@;		R0: dim; tama�o de los tableros (dimxdim)
@; 		R1: char tablero_disparos[]; direcci�n base del tablero de disparos
@;	Resultado:
@;		R0: n�mero total de disparos realizados para completar la partida
		.global jugar
jugar:
		push {r1-r7, lr}
		mov r4, #0
		.juga:							@;inici del bucle
		mov r1, r8 
		bl mod_random					@;carreguem un numero random de 0 a dim-1 a r0
		mov r2, r0						@;fila a disparar (r2)
		mov r0, r6						@;tornem a carregar la dimensio a r0
		bl mod_random					@;carreguem un numero random de 0 a dim-1 a r0
		mov r3, r0						@;columna a disparar (r3)
		mov r0, r6						@;tornem a carregar la dimensio a r0 
		bl desplmatriu					@;obtenim la direccio en memoria a la que apunta taulertrets[f][c], retorna per r1
		ldrb r7, [r1]
		cmp r7, #'?'
		bne .juga
		mov r1, r8						@;retornem la direccio del tauler de trets a r1
		bl efectuar_disparo				@;disparem, ara r0 te el resultat del tret
		cmp r0, #2						@;si resultat del tret=2 (tocat) suma 1 al nombre de vaixells ko
		addge r4, r4, #1  				@;suma 1 al comptador de vaixells si el resultat es tocat o tocat i enfonsat
		cmp r4, #20		
		bne .juga						@; si no has matat tots el vaixells (20 cops el resultat de tocat o tocat i enfonsat) torna a comen�ar un altre torn
		bl B_num_disparos				@;carreguem a r0 el nombre de trets i tal (trucades a la funcio dispara des de lultima invocacio a inicialitza taulell
		pop {r1-r7, pc}



@; efectuar_disparo(int dim, char tablero_disparos[], int f, int c):
@;	rutina para efectuar un disparo contra el tablero de barcos inicializado
@;	con la �ltima llamada a B_incializa_barcos(), anotando los resultados en
@;	el tablero de disparos que se pasa por par�metro (por referencia), donde los
@;	dos tableros tienen el mismo tama�o (dim = dimensi�n del tablero de barcos).
@;	La rutina realizar� el disparo llamando a la funci�n B_dispara(), y actuali-
@;	zar� el contenido del tablero de disparos consecuentemente, devolviendo
@;	el c�digo de resultado del disparo.
@;	Par�metros:
@;		R0: dim; tama�o de los tableros (dimxdim)
@; 		R1: tablero_disparos[]; direcci�n base del tablero de disparos
@;		R2: f; n�mero de fila (0..dim-1)
@;		R3: c; n�mero de columna (0..dim-1)
@;	Resultado:
@;		R0: c�digo del resultado del disparo (-1: ERROR, 0:REPETIT, 1: AGUA,
@;												2: TOCAT, 3: ENFONSAT)
efectuar_disparo:
		push {r1-r4, lr}
		bl desplmatriu
		mov r4, r1							@;salvem la direccio
		mov r0, r2							@;carreguem columnes
		mov r1, r3							@;carreguem files
		add r0, #65							@;factor correcci� filas
		add r1, #1							@;factor correcci� columnes
		bl B_dispara						@;ara disparem i actualitzem el taulell de vaixells, retorna per r0 el resultat del tret
		mov r2, #'.'						@;registre temporal per guardar aigua
		strb r2, [r4]						@;posa una aigua sempre
		cmp r0, #2
		blt .aigua							@;si el resultat del tret es aigua salta, sino no saltis
		mov r2, #'@'						@;registre temporal que emmagatzema @
		strb r2, [r4]						@;posa una @ a la posicio de l'ultima tirada si esta tocat
		.aigua:
		pop {r1-r4, pc}
		
		
@; Parametres: 
@; r0=dim
@; r1=@tauler 
@; r2=fila
@; r3=columna
@; retorn: r1=@tauler+dim*f+c
desplmatriu:
		push {r3, lr}
		mla r3, r0, r2, r3
		add r1, r3
		pop {r3, pc}
		
.end
