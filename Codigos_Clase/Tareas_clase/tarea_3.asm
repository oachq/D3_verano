; viernes 17 de junio.
; 3) Diseñe un programa que recibe dos variables de 8 bits cada una, la primera contiene el tiempo de
;    ensendido y la segunda el tiempo de apagado, utilice esos tiempos para encender y apagar un bit 
;    del puerto B con el TMR0 
;material: solo codigo no implementacion. 

; las entradas estaran por el port A y D y salida PB,0
; Formula Timer0 8 bits.
; Tiempo requerido = Tosc*4*Pre_escaler*(256-TMR0)
; 8ms = (1/4MHz)*4*32*(256-TMR0).
; TMR0 = 6

    LIST	P=18F4550
	#INCLUDE	<P18F4550.INC>
	
	CONFIG	FOSC=INTOSCIO_EC
	CONFIG	BOR=OFF	
	CONFIG	CP0=OFF	
	CONFIG	CP1=OFF	
	CONFIG	CPB=OFF	
	CONFIG	DEBUG=OFF	
	CONFIG	LVP=OFF	
	CONFIG	MCLRE=OFF	
	CONFIG	PBADEN=OFF
	CONFIG	PWRT=ON
	CONFIG	XINST=OFF	
	CONFIG	WDT=OFF	

    CBLOCK	0X20
        T_ON
        T_OFF
	ENDC

    ORG		0X0000
	GOTO	INICIO

	ORG		0X0008
	GOTO	INICIO

CPORTS
	MOVLW	0FH
	MOVWF	ADCON1
	MOVLW	07H
	MOVWF	CMCON
	MOVLW	62H
	MOVWF	OSCCON
    BCF     TRISB,0 ; puerto B, 0 como salida 
	RETURN


; Programa principal:
INICIO: 
     rcall CPORTS
     rcall  TMR0_CONFIG		; Ir a la subrutina TMR0_CONFIG.
     
; Bucle infinito.     
LOOP:
     DECFSZ T_OFF,f
     bra    LOOP           ; T_OFF no es cero 
     ;bcf    LATB,0
     btfss INTCON,TMR0IF	; Si la bandera de TMR0IF=1, salta la siguiente instruccion, y T_OFF= 0
     bra  LOOP			; Ir a LOOP. 
     bcf   INTCON,TMR0IF	; Ponemos a 0 el bit TMR0IF del registro INTCON.
     movlw b'00000110'			; Cargamos el valor literal 6 en W.
     movwf TMR0L		; Cargamos el valor de W en el registro TMR0L.
     movlw  b'11111111'       ; Cargamos tiempo de apagado
     movwf  T_OFF             ; a variable T_OFF 
     btg   LATB,LATB0		; Conmutamos el estado del pin RB0.
     ;bsf    LATB,0
     bra  LOOP			; Ir a LOOP.
      
TMR0_CONFIG:
     ;bcf   T0CON,TMR0ON		; Deshabiliamos el Timer0.
     ;bsf   T0CON,T08BIT		; Configuramos el Timer0 a 8 bits.
     ;bcf   T0CON,T0CS		    ; Ciclo de instruccion interno. 
     ;bcf   T0CON,T0SE		    ; Incremento de Timer0 por flanco ascendente (deshabilitado).
     ;bcf   T0CON,PSA		    ; Habilitamos el escalador al timer0.
     ;bsf   T0CON,T0PS2		    ; Seleccionamos el escalador de 32.
     ;bcf   T0CON,T0PS1
     ;bcf   T0CON,T0PS0 
     ;bcf   INTCON,TMR0IF	    ; Deshabilitamos la bandera de interrupcion por desbordamiento de Timer0.
     ;movlw .6			        ; Cargamos el valor literal 6 a W.
     ;movwf TMR0L		        ; Cargamos el valor de W al registro TMR0L.
     ;bsf   T0CON,TMR0ON	    ; Habilitamos el Timer0.

     bcf   T0CON,TMR0ON		; Deshabiliamos el Timer0.
     bsf   T0CON,T08BIT		; Configuramos el Timer0 a 8 bits.
     bcf   T0CON,T0CS		; Ciclo de instruccion interno. 
     bcf   T0CON,T0SE		; Incremento de Timer0 por flanco ascendente (deshabilitado).
     bcf   T0CON,PSA		; Habilitamos el escalador al timer0.
     bsf   T0CON,T0PS2		; Seleccionamos el escalador de 32 ******o 256.
     bcf   T0CON,T0PS1
     bcf   T0CON,T0PS0 
     bcf   INTCON,TMR0IF	; Deshabilitamos la bandera de interrupcion por desbordamiento de Timer0.
     movlw .6			; Cargamos el valor literal 6 a W.
     movwf TMR0L		; Cargamos el valor de W al registro TMR0L.
     movlw  b'11111111'       ; Cargamos tiempo de apagado
     movwf  T_OFF             ; a variable T_OFF 
     bsf   T0CON,TMR0ON		; Habilitamos el Timer0.
    ;01000100
    ;01000111
     RETURN			
     
     END			
