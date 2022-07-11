;129 el PR2	Se obtiene de la f�rmula PWM Period, ah� no se pone 1/2
;CT = 260 -> 100000100	Se obtiene de la f�rmula PWM Duty Cycle
;CCP2RL= 41 -> 1000001
;MODO PWM = 0Fh -> 1111

	LIST	P=18F4550
	#INCLUDE	<P18F4550.INC>

	CONFIG	FOSC	=	INTOSCIO_EC
	CONFIG	LVP		=	OFF
	CONFIG	MCLRE	=	OFF
	CONFIG	DEBUG	=	OFF
	CONFIG	XINST	=	OFF
	CONFIG	PBADEN	=	OFF
	CONFIG	CP0		=	OFF
	CONFIG	CP1		=	OFF
	CONFIG	CPB		=	OFF
	CONFIG	BOR		=	OFF
	CONFIG 	WDT		=	OFF
	CONFIG	PWRT	=	ON
	CONFIG	CCP2MX	=	OFF

	CBLOCK	0X20
	NOSE
	TEMP
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
	BCF		TRISC,1
	BCF		LATC,1
	BCF		TRISB,3
	BCF		LATB,3
	RETURN

C_CCP
	MOVLW	0FH
	MOVWF	CCP2CON
	MOVLW	0X41
	MOVWF	CCPR2L
	MOVLW	.129
	MOVWF	PR2
	MOVLW	0X07
	MOVWF	T2CON
	RETURN

INICIO
	RCALL	CPORTS
	RCALL	C_CCP
	BRA		$
	END