;Programa que multiplica dos numeros de 1 byte
;por sumas sucesivas

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

	CBLOCK	0X00
	N1
	N2
	RL
	RH
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
	MOVWF	ADCON1
	MOVLW	0X07
	MOVWF	CMCON
	MOVLW	0X62
	MOVWF	OSCCON
	MOVLW	.255	;0XFF
	MOVWF	TRISB
	CLRF	TRISD
	CLRF	LATD
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
		RCALL	CPORTS
NEXT	CLRF	RL
		CLRF	RH
		MOVF	PORTB,W
		MOVWF	N1
		BTFSC	STATUS,Z	;SI NO ES 0 SE PASA A NEW
		BRA		NEW
		MOVWF	LATD
		RCALL	RETARDO
		MOVF	PORTB,W
		MOVWF	N2
		BTFSC	STATUS,Z	;SI NO ES 0 SE PASA A NEW
		BRA		NEW
		MOVWF	LATD
		RCALL	RETARDO
AQUI	MOVF	N1,W		;RL<-RL+N1
		ADDWF	RL,F
		BTFSC	STATUS,C
		INCF	RH,F
		DECFSZ	N2,F
		BRA		AQUI
		MOVF	RL,W
		MOVWF	LATD
		RCALL	RETARDO
		MOVF	RH,W
		MOVWF	LATD
		RCALL	RETARDO
		BRA		NEXT
NEW		CLRF	RL
		CLRF	RH
		CLRF	LATD
		RCALL	RETARDO
		BRA		NEXT
		END