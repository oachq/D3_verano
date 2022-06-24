; TEMA: intterupciones externas 
 ; interrupciones por cambio de nivel 
; puerto B como entrada
; puerto C y D como salida 



	LIST	    P=18F4550
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


    cblock 20h
    TEMP
    ENDC

    org 0x00
    GOTO INICIO

    org 0x18
    GOTO ISR_INT_EXT ; si es rutina de interrupcion siempre pones ISR 

CPORTS
    movlw   0x0F
    movwf   ADCON1;
    movlw   0x07;
    movwf   CMCON
    movlw   0x62
    movwf   OSCCON
    ;bsf     TRISB,0
    movlw   0xFF
    movwf   TRISB
    clrf    TRISD
    clrf    TRISC
    clrf    LATB
    clrf    LATD
    clrf    LATC
    RETURN

CINT0       ; CONFIGURACION DE LOS bits PARA INTERRUPCION 
    bcf    RCON, IPEN
    bsf    INTCON, INT0IE
    bcf    INTCON, INT0IF 
    ;bcf    INTCON2, INTEDG0    ; con filo de bajada 0
    bsf    INTCON2, INTEDG0     ; con filo de subida 1
    RETURN

CRB
    bsf     INTCON, RBIE
    bsf     INTCON2, RBIP
    bcf     INTCON, RBIF
    return

ISR_INT_EXT 
    btfss   INTCON, INT0IF
    bra     OTRO
    comf    TEMP, F
    movwf   TEMP, W
    movwf   LATD
    bcf     INTCON, INT0IF  ; apagamos la banderas de la interrupcion.
    bra     FIN

OTRO    
    btfss   INTCON, RBIF
FIN retfie
    ;movlw   0xFF
    ;movwf   TEMP 
    incf    TEMP, F
    movf    TEMP, W
    movwf   LATC
    movf    PORTB,W
    bcf     INTCON, RBIF
    bra     FIN

INICIO
    rcall   CPORTS
    rcall   CINT0
    rcall   CRB
    movlw   0x0F
    movwf   TEMP    
    bsf     INTCON, GIE
    bra     $    ; signo de dolar es que se convierte en un ciclo osiciooso
    END

