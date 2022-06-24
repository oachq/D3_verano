; programa que enciende y apaga la mitad del port B durante 1 segundo si el PA_1=1, si es igual a 0 
; recorrer hacia la derecha el PB, pero si PA_2=1 no importa el PA_1, recorrerá a la izquierda 

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
    CONFIG MCLRE = ON
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
    PVPB
endc

org 0x000
goto INICIO

org 0x0018
goto INICIO


CONFIG_PORTS
    movlw 0x0F
    movwf ADDCON1
    movlw 0x007
    movwf CMCON
    movwf 0x62
    movwf OSCCON
    clrf TRISB
    bsf TRISA, 1
    bsf TRISA, 2
    clrf LATB
    clrf LATA
    return

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
    rcall CONFIG_PORTS
    ; incio del programa
    clrf    PVPB
CHK btfsc    PORTA, 2       ; CHK checar si port A 2 es 0 va a izq
    BRA     IZQ
    btfsc   PORTA, 1        ; si port A 1 es 0 va a port onoff
    BRA     ONOFF
DER  rrcf    PVPB, F
NEXT movf    PVPB, W
    movwf   LATB
    rcall   RETARDO
    bra     CHK
ONOFF
    movlw   0x0F
    movwf   PVPB
    movwf   LATB
    rcall   RETARDO
    swapf   PVPB,W
    movwf   LATB
    rcall   RETARDO
    bra     CHK
IZQ 
    rlcf    PVPB,F
    bra     NEXT
    
    END