; viernes 17 de junio.
; 3) Diseñe un programa que recibe dos variables de 8 bits cada una, la primera contiene el tiempo de
;    ensendido y la segunda el tiempo de apagado, utilice esos tiempos para encender y apagar un bit 
;    del puerto B con el TMR0 
;material: solo codigo no implementacion. 


; las entradas estaran por el port A y D y salida PB,0

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
	    CT0
	    TEMP
	    BANDERA
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
    ;MOVLW   B'00000000'
    ;MOVWF   TRISA   ; puerto A como salida
    ;MOVLW   B'00000000'
    ;MOVWF	TRISD   ; purto D como SALIDA
    BCF     TRISB,0 ; puerto B, 0 como salida 
	RETURN

CONFT0			; configuracion del tmr0 con salida en el port B
	MOVLW	47H
	MOVWF	T0CON
	BCF		RCON,IPEN
	BSF		INTCON,TMR0IE
	BSF		INTCON,TMR0IP
	BSF		INTCON,PEIE
   	MOVLW	.61			; dato sacado de la formula 
	MOVWF	TMR0L
	MOVLW	.40			; multiplicacion por 40 decimal apra acompletar 1 seg 
	MOVWF	T_OFF
    BCF		INTCON,TMR0IF ; limpiamos banderas
	RETURN


CTRL_ON_OFF
	MOVLW	.61			; dato sacado de la formula 
	MOVWF	TMR0L
	MOVLW	.40			; multiplicacion por 40 decimal apra acompletar 1 seg 
	MOVWF	T_OFF
	DECFSZ T_OFF,F	; si la bandera es 1 saltamos a la siguiente instruccion
	rcall	LED_ON		;si es 1 sigue contanto
	rcall	LED_OFF		;si es 0 para de contar y apaga
	RETURN

LED_ON
    BSF		INTCON,TMR0IF ; encendemos tmr0
    bsf     PORTB,0
    RETURN
    
LED_OFF
    bcf     PORTB,0
    BCF		INTCON,TMR0IF ; apagamos tmr0
    RETURN


INICIO
        rcall   CPORTS
    	rcall   CONFT0
MAIN    clrf    T_OFF
		rcall	CTRL_ON_OFF
        BSF		T0CON,TMR0ON
		BSF		INTCON,GIE
        
		bra     MAIN
        END
