;Ejemplo CPP 1 y 2 
; ccp_compara es para ingresar al archivo de datasheet
; el ccp compara sirve para generar una señal 
; Programa que genera una señal cuadrada por medio el CCP1 en modo comparación 
; ccp1rH = 1 ccp1rL = F4

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
    bcf     TRISC,2
    clrf    LATC    
    return

CONF_CPP
    movlw   0x09    ; configurar CCP  en modo comparador
    movwf   CCP1CON
    bcf     RCON,IPEN
    bsf     PIE1, CCP1IE
    movlw   0x01
    movwf   CCPR1H
    movlw   0xF4
    movlw   CCPR1L
    bcf     PIR1, CCP1IF
    return

CONF_T3
    movlw   0xF8    ; esta es para configurar timer 3
    movwf   T3CON
    clrf    TMR3H
    clrf    TMR3L
    return

ISR_CCP
    btfss    PIR1, CCP1IF
    retfie
    btg     CCP1CON,0
    clrf    TMR3H
    clrf    TMR3L
    bcf     PIR1,CCP1IF
    retfie

INICIO
    rcall   C_PORTS
    rcall   CONF_CPP
    rcall   CONF_T3
    bsf     T3CON, TMR3ON   ; encendemos bandera de tmr3
    bsf     INTCON, GIE 
    bra     $
    END 



;Modulo ccp
;1. modo captura 
;2. modo comparador
;3. modo PWM
;
;
;el pic 18f4550 posee dos ccp 
;
;Nota el pwm trabaja solo en tmr2. 
;
;el ccp1 se compone de dos registros de 8 bits, denominados ccpr1H 16h es la parte mas significativa 
;y ccpr1L 15h es la parte menos significativa. la operacion del modulo se controla mediante el registro 
;CCP1CON.
;
;se trabajara como pwm y asignar frecuencia y ciclo de tabajo 
;
;;Modo de captura
;
;si se trabaja con el ccp1 entra por el pin 1 o ccp2 con pin2
;
;
;PWM_periodo = [(pr2)+1 ] * 4 * Tosc * (tmr2 prescaler value(16 valor de datasheet)).
;
;PWM_dutyCycle = (CCPRxL : cppxCON<5:4>* Tosc * ( TMR2 prescaler value ))






