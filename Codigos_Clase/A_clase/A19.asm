; configurciuon del usart para el TX y RX

; transmite el tx reg y recibe el tc

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
	    TIPO
        LETRA
	    TEMP
	ENDC

	ORG		0X0000
	GOTO	INICIO

	ORG		0X0008
	GOTO	ISR_SCI


TAB_HOLA
    rlncf   LETRA,W
    addwf   PCL, F
    DT      "Hola Estyo listo", .10, .13, 0   ; envier 10 y 13 por puerto serie 

TAB_MEN1
    rlncf   LETRA,W
    addwf   PCL, F
    DT      "Precionaste el 1", .10, .13, 0   ; envier 10 y 13 por puerto serie 

TAB_MEN2
    rlncf   LETRA,W
    addwf   PCL, F
    DT      "Precionaste el 2", .10, .13, 0   ; envier 10 y 13 por puerto serie 

TAB_OTRO
    rlncf   LETRA,W
    addwf   PCL, F
    DT      "No es lo que tu quieres", .10, .13, 0   ; envier 10 y 13 por puerto serie 


CPORTS
    MOVLW	0X0F
	MOVWF	ADCON1
	MOVLW	0X07
	MOVWF	CMCON
	MOVLW	0X72
	MOVWF	OSCCON
	BSF		TRISC,7
	BCF		TRISC,6
	CLRF	LATC
	RETURN


CONF_SCI
    MOVLW	.12
	MOVWF	SPBRG
	BCF		BAUDCON,BRG16
	BCF		TXSTA,SYNC
	BCF		TXSTA,TX9
	BCF		TXSTA,BRGH
	BSF		RCSTA,SPEN
	BSF		RCSTA,CREN
	BCF		RCSTA,RX9
	BCF		RCON,IPEN
	BSF		INTCON,PEIE
	BSF		PIE1,RCIE
	BSF		PIR1,RCIF
    return

TX_BLOQUE
    clrf    LETRA
    bsf     TXSTA,TXEN
    return
TX_BYTE
    rlncf   TIPO,w
    addwf   PCL,F
    bra     M0
    bra     M1
    bra     M2
    bra     M3
    return

M0
    rcall   TAB_HOLA
    bra     SIGUE

M1
    rcall   TAB_MEN1
    bra     SIGUE

M2
    rcall   TAB_MEN2
    bra     SIGUE

M3
    rcall   TAB_OTRO
    ;bra     SIGUE
SIGUE
    movwf   TXREG
ESPERA
    btfss    TXSTA, TRMT
    bra      ESPERA
    xorlw   .0
    BZ      ULTIMO
    INCF    LETRA,f
    bra     TX_BYTE

ULTIMO
    bcf     TXSTA, TXEN
    movlw   0x04
    movwf   TIPO
    clrf    LETRA
    return

ISR_SCI
    btfss   PIR1,RCIF
    RETFIE
    bcf     RCSTA, CREN
    
    movf    RCREG,W
    xorlw   0x31
    btfss   STATUS, Z
    bra     N1
    movlw   0x01
    movwf   TIPO
    bra     SALIR

N1
    movf    RCREG,W
    xorlw   0x32
    btfss   STATUS, Z
    bra     N2
    movlw   0x02
    movwf   TIPO
    bra     SALIR

N1
  movlw 0x03
  movwf TIPO
SALIR
    bsf     RCSTA, CREN
    bcf     PIR1, RCIF
    RETFIE

INICIO
    rcall   CPORTS
    rcall   CONF_SCI
    clrf    TIPO
    bsf     INTCON,GIE
SND
    rcall   TX_BLOQUE
    rcall   TX_BYTE
    bra     SND
    
END