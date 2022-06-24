__CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
    LIST P=16F628A
    #include <P16F628A.INC>
    org 0x00
    movlw b'00000111'  ; W <== 00000111
    movwf CMCON   ;CMCON <== W
    bsf STATUS,5  ;Ir al banco 1
    clrf TRISB    ;Todo el PORTB como salida
    bsf TRISA,0  ;RA0 es entrada
    bsf TRISA,1  ;RA1 es entrada
    bcf STATUS,5  ;Ir al banco 0
    clrf PORTB
    
preg    btfsc PORTA,0
    goto incre
    btfsc PORTA,1
    goto decre
    goto preg
incre incf PORTB,1   ;PORTB <== PORTB+1
    btfsc PORTA,0
    goto $-1
    goto preg
decre decf PORTB,1   ;PORTB <== PORTB-1
    btfsc PORTA,1
    goto $-1
    goto preg
    end