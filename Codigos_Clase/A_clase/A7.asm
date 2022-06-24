;LCD 8 bits
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
	#DEFINE	LCD	LATD
	#DEFINE	RS	LATC,4
	#DEFINE	RW	LATC,5
	#DEFINE	E	LATC,6

	CBLOCK	0X20
	TEMP
	MILI
	MILI2
	ENDC
	
	ORG	0X0000
	GOTO INICIO
	
	ORG	0X0018
	GOTO INICIO

CPORTS
	MOVLW	0X0F
	MOVWF	ADCON1
	MOVLW	0X07
	MOVWF	CMCON
	MOVLW	0X62
	MOVWF	OSCCON
	CLRF	TRISD
	CLRF	TRISC
	CLRF	LCD
	BCF		RS
	BCF		RW 
	BCF		E
	RETURN

CLCD
	MOVLW	0X38
	RCALL	SEND_CMD
	MOVLW	0X0C
	RCALL	SEND_CMD
	MOVLW	0X06
	RCALL	SEND_CMD
	MOVLW	0X01
	RCALL	SEND_CMD
	RETURN

SEND_CMD
	BCF		RS
NEXT	MOVWF	TEMP
	MOVLW	.5
	MOVWF	MILI
	RCALL	RETARDO
	MOVF	TEMP,W
	MOVWF	LCD
	BSF		E
	BCF		E
	RETURN
SEND_CHAR
	BSF		RS
	BRA		NEXT
MENS
	MOVLW	0X80
	RCALL	SEND_CMD
	MOVLW	'S'
	RCALL	SEND_CHAR
	MOVLW	'I'
	RCALL	SEND_CHAR
	MOVLW	'S'
	RCALL	SEND_CHAR
	MOVLW	'T'
	RCALL	SEND_CHAR
	MOVLW	' '
	RCALL	SEND_CHAR
	MOVLW	'D'
	RCALL	SEND_CHAR
	MOVLW	'I'
	RCALL	SEND_CHAR
	MOVLW	'G'
	RCALL	SEND_CHAR
	MOVLW	0XC0
	RCALL	SEND_CMD
	MOVLW	'3'
	RCALL	SEND_CHAR
	RETURN
RETARDO
	MOVLW	0XF9
	MOVWF	MILI2
	NOP
OT	DECFSZ	MILI2,F
	BRA		OT
	DECFSZ	MILI,F
	BRA		RETARDO
	RETURN
INICIO
	RCALL	CPORTS
	RCALL	CLCD
	RCALL	MENS
	BRA		$
	END

    ;NOTA: el ciclo de trabajo del codigo es 4 / Frec. OSCILACION = 4MHz