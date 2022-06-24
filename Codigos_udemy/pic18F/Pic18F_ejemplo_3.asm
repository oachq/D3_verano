; prende y apaga un led usando retardos por software 

    LIST	P=18F4550
	#INCLUDE	<P18F4550.inc>

	CONFIG	FOSC	=	INTOSCIO_EC
	CONFIG	MCLRE	=	OFF
	CONFIG	PBADEN	=	OFF
	CONFIG	LVP		=	OFF
	CONFIG	XINST	=	OFF
	CONFIG	DEBUG	=	OFF
	CONFIG	BOR		=	OFF
	CONFIG	PWRT	=	ON
	CONFIG	CP0		=	OFF
	CONFIG	CP1		=	OFF
	CONFIG	CPB		=	OFF
	CONFIG	WDT		=	OFF
; 

	ORG		0X0000
	GOTO	INICIO
	
	ORG		0X018
	GOTO 	INICIO

CONFIG_PORTS
	; PUERTOS A COMO ENTRADA
	movlw   0X0F
    movwf   ADDCON1 ; PIN DIGITALES
    movlw   0X07
    movwf   CMCON   ;DES - ACT COMPARADORES ANALOGICOS 
    movlw   0x62    
    movwf   OSCCON  ; FOSC OSCILADOR 4 MHz. 
	clrf PORTA
	;clrf PORTB
	; puertos A
	bsf TRISA, 0 ; puerto A0 como entrada 
	;bsf TRISA, 1 ; Puerto A1 como entrada
	; puertos B
	;bcf TRISB, 0 ; puerto B0 como salida
	;bcf	TRISB, 1 ; puerto B1 como salida
	return

INICIO
	call CONFIG_PORTS
	;prende apaga leds con btn del port A 
	bsf PORTA, 0; 	encendemos led 
	call RETARDO
	call RETARDO
	bcf PORTA, 0; apagamos led

RETARDO
		MOVLW	.20
		MOVWF	CUENTA3
OTRO3	MOVLW	.200
		MOVWF	CUENTA2
OTRO2	MOVLW	.82
		MOVWF	CUENTA
OTRO	DECFSZ	CUENTA,F
		BRA		OTRO
		DECFSZ	CUENTA2,F
		BRA		OTRO2
		DECFSZ	CUENTA3,F
		BRA		OTRO3
		RETURN
end
