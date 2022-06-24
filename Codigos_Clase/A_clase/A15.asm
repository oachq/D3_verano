; T0INT0 programa que genere una señal cuadrada por medio del T0 y que si ocurre
; una interrupcion por el INT0 incremente en 1 segundo el periodo.

    LIST	P=18F4550
	#INCLUDE	<P18F4550.INC>
	
	CONFIG FOSC=INTOSCIO_EC
	CONFIG PWRT=ON
	CONFIG BOR=OFF
	CONFIG LVP=OFF
	CONFIG MCLRE=OFF
	CONFIG WDT=OFF
	CONFIG DEBUG=OFF
	CONFIG CP0=OFF
	CONFIG CP1=OFF
	CONFIG CPB=OFF
	CONFIG PBADEN=OFF

    CBLOCK  0x20   
        CTO
        CTOV
        TEMP
    ENDC

    ORG 0x0000
    GOTO    INICIO

    ORG 0x0008
    GOTO    ISR_T0_INT0

C_PORTS
    movlw   0x0F
    movwf   ADCON1
    movlw   0x07
    movwf   CMCON
    movlw   0x62
    movwf   OSCCON
    bsf     TRISB,0 ; ports como salida
    bcf     TRISC,0 ; ports como entrada
    return

CONFT0
    movlw   0xF8
    movwf   T0CON
    bcf     RCON,IPEN
    bsf     INTCON,TMR0IE
    bsf     INTCON, PEIE
    movlw   .61
    movwf   TMR0L
    movlw   .20
    movwf   CT0V
    movwf   CT0
    bcf     INTCON, TMR0IF
    return

CINT0
    BSF     INTCON,INT0IE
    BSF     INTCON2,INCTEDG0
    BCF     INTCON,INT0IF
    RETURN

ISR_T0_INT0
    btfsc   INTCON,INT0IF
    bra     CAMBIO
    btfss   INTCON, TMR0IF
    bra     FIN
    decfsz  CT0,F
    bra     FIN2
    btg     LATC,0
    movlw   CT0V
FIN2    MOVLW   .61
    movwf   TMR0L
    bcf     INTCON,TMR0IF
FIN    retfie

CAMBIO
    movlw   .10
    ADDWF   CT0, f
    bcf     INTCON,INT0IF
    retfie

INICIO
    rcall   C_PORTS
    RCALL   CONFT0
    rcall   CINT0
    BSF     T0CON,TMR0ON
    bsf     INTCON,GIE
    bra     $
    END     




