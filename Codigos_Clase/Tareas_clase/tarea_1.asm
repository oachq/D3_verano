; Jueves 9 de junio. 
;Programa 1:
;        programa que si el bit 0 del port A es igual a 1, enciende los bits pares del puerto B y si no 
;        enciendo los impares durante 1 seg. 
;*******************************************************************************
    LIST P = 18F4550
    INCLUDE <P18F4550.INC>
    RADIX HEX
    
;*******************************************************************************
;            BITS DE CONFIGURACION
;*******************************************************************************
;********     Configuracion del Oscilador  *************************************
;  oscilador interno, RA6 como pin, USB usa oscilador EC
    CONFIG FOSC = INTOSCIO_EC
    
;*********   Bits de configuracion mas usados   ********************************
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG WDT = OFF
    CONFIG MCLRE = OFF
    CONFIG PBADEN = OFF
    CONFIG LVP = OFF
    CONFIG DEBUG = OFF
    CONFIG XINST = OFF
    
;********  Bits de proteccion   ************************************************
    CONFIG CP0 = OFF
    CONFIG CP1 = OFF
    CONFIG CPB = OFF


    cblock 0x00 
; variables de timers por software
    CUENTA
    CUENTA2
    CUENTA3
    endc

	ORG		0X0000
	GOTO	INICIO
	
	ORG		0X018
	GOTO 	INICIO


; PUERTOS A COMO ENTRADA
CONFIG_PORTS
	movlw   0X0F
    movwf   ADCON1 ; PIN DIGITALES
    movlw   0X07
    movwf   CMCON   ;DES - ACT COMPARADORES ANALOGICOS 
    movlw   0x62    
    movwf   OSCCON  ; FOSC OSCILADOR 4 MHz. 
	clrf PORTA
	clrf PORTB
	; puertos A
	bsf TRISA, 0 ; poner en 1 el puerto A0 como entrada 
	;bsf TRISA, 1 ; poner en 1 el Puerto A1 como entrada
	; puertos B
	bcf TRISB, 0 ; puerto B0 como salida
	bcf	TRISB, 1 ; puerto B1 como salida
    bcf TRISB, 2 ; puerto B2 como salida
	bcf	TRISB, 3 ; puerto B3 como salida
    bcf TRISB, 4 ; puerto B4 como salida
	bcf	TRISB, 5 ; puerto B5 como salida
    bcf TRISB, 6 ; puerto B6 como salida
	bcf	TRISB, 7 ; puerto B7 como salida
    ;movlw B'0000000';
    ;movwf TRISB
	return

#define btn PORTA,0 


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
		RETURNTRO3
        return

INICIO
    call    CONFIG_PORTS
MAIN
    BTFSC   btn ; btn es 0?
    call     LEDS_IMPARES
    BTFSS   btn ; btn es 1?
    call     LEDS_PARES
    clrf    PORTB
    bra MAIN
    
LEDS_IMPARES 
     clrf    PORTB
     bsf     PORTB,1
     bsf     PORTB,3
     bsf     PORTB,5
     bsf     PORTB,7
     call RETARDO
    bra MAIN
LEDS_PARES 
    clrf    PORTB
    bsf     PORTB,0
    bsf     PORTB,2
    bsf     PORTB,4
    bsf     PORTB,6
    call RETARDO
    return
    END
   