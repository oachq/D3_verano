; programa 2:  
;       programa que compara el dato del port A con el ultimo numero de tu ID y habra 3 posibilidades:
;       a) Si son iguales, se encienden todos los leds del port B 
;       b) Si el port A es mayor se enciende el port D 
;       c) Si el puerto A es menor se enciende los nibbles altos de los ports B y D 
    ;NOTA: no usar comparaciones        
    
    LIST	P=18F4550
	#INCLUDE	<P18F4550.inc>
    RADIX   HEX
    
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

	CBLOCK	0X00
        VAR_
        CUENTA
	    CUENTA2
	    CUENTA3
	ENDC

	ORG		0X0000
	GOTO	INICIO
	
	ORG		0X018
	GOTO 	INICIO

CPORTS
	MOVLW	0X0F
	MOVWF	ADCON1      ; pines digitales
	MOVLW	0X07
	MOVWF	CMCON
	MOVLW	0X62
	MOVWF	OSCCON      ; oscilador 4 MHz
	movlw   b'1111111'
	movwf   PORTA ; puerto A como entrada
    CLRF	TRISD       ; puerto D como salida
	CLRF	LATD        ; puerto D como salida
    clrf    TRISB       ; puerto B como salida       
    clrf    LATB        ; puerto B como salida
    RETURN

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

INICIO
    call CPORTS
    call MAIN
MAIN
;es igual
    movlw       04h     ;el valor de W
    CPFSEQ      PORTA    ; si es igual PORT_A que VAR_IGU
    GOTO        ESMAYOR_     ; no es identico
    GOTO        ESIGUAL  ; encendemos port B
    ;bra         MAIN
ESMAYOR_
    movlw       04h     ;el valor de PORT_A lo muevo a W
    CPFSGT      PORTA   ; si es mayor encendemos port D
    GOTO        ESMENOR_    ; no es mayor
    GOTO        ESMAYOR  ; encendemos port D
    ;bra         MAIN
ESMENOR_
    movlw       04h     ;el valor de PORT_A lo muevo a W
    CPFSLT      PORTA    ; es menor encendemos Nible alto PORT B y D
    GOTO        MAIN
    GOTO        ESMENOR  ; encendemos port D
    ;call        CLEAR
    bra         MAIN

ESIGUAL
    ;movlw   b'11111111'
    ;movwf   PORTB
    bsf     PORTB,0
    bsf     PORTB,1
    bsf     PORTB,2
    bsf     PORTB,3
    bsf     PORTB,4
    bsf     PORTB,5
    bsf     PORTB,6
    bsf     PORTB,7
    call    RETARDO
    call    RETARDO
    RETURN
   
ESMAYOR
    ;movlw   b'11111111'
    ;movwf   PORTD
    bsf     PORTD,0
    bsf     PORTD,1
    bsf     PORTD,2
    bsf     PORTD,3
    bsf     PORTD,4
    bsf     PORTD,5
    bsf     PORTD,6
    bsf     PORTD,7
    call    RETARDO
    call    RETARDO
    RETURN
ESMENOR
    bsf     PORTB,4
    bsf     PORTB,5
    bsf     PORTB,6
    bsf     PORTB,7
    ;port D
    bsf     PORTD,4
    bsf     PORTD,5
    bsf     PORTD,6
    bsf     PORTD,7
    call    RETARDO
    call    RETARDO

    RETURN

    END

;00000000    0 
;00000001    1
;00000010    2
;00000011    3
;00000100    4
