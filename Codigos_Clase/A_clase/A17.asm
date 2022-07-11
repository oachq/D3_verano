    ; CCP captura. 
; el ccp compara sirve para verificar una señal cuando es su filo de subida o de bajada.

; port A se mide el numero de veces que se desbordo 
; en el port D y B es el valor obtenido del valor del CCP1R H y L 
; port D es H y port B es L                

    LIST P=18F4550
    #INCLUDE <P18f4550.inc>

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

    CBLOCK	0X20
        TEMP
		TEMP1
		TEMP2
		TEMP3
	ENDC

      ORG 0x0000
    GOTO    INICIO

    ORG 0x0008
    GOTO    ISR_CCP

C_PORTS
    movlw   0x0F
    movwf   ADCON1
    movlw   0x07
    movwf   CMCON
    movlw   72H     ; oscilador a 8 MHz
    movwf   OSCCON
    bsf     TRISC,2
    clrf    TRISA    
    clrf    TRISB
    clrf    TRISD
    ;bcf     LATC       
    return

CONF_CPP
    movlw   0x05    ; configurar CCP como captura, este valor se toma del datasheet
    movwf   CCP1CON
    clrf    CCPR1H
    clrf    CCPR1L

    bcf     RCON,IPEN
    bsf     PIE1, CCP1IE
    movlw   0x01
    movwf   CCPR1H
    movlw   0xF4
    movlw   CCPR1L
    bcf     PIR1, CCP1IF
    return

CONF_T3
    movlw   0xC8 
    movwf   T3CON
    clrf    TMR3L
    clrf    TMR3H
    return

INICIO
    rcall   C_PORTS
    rcall   CONF_CPP
    rcall   CONF_T3
    bsf     T3CON, TMR3ON
NO  btfsc   PIR1, CPP1IF
    bra     YA
    btfss   PIR2, TMR3IF
    bra     YA
    incf    TEMP,F
    bcf     PIR2, TMR3IF
    bra     NO
YA  bcf     T3CON, TMR3ON
    movf    TEMP,W
    movwf   LATA
    movf    CCPR1L, W
    movwf   LATB
    movf    CCPR1H,W
    movwf   CCPR1H, W
    movwf   LATD
    bra     $
    END
