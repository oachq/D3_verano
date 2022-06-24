__CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
    LIST P=16F628A
    VAR EQU 0x20
    VAR2 EQU 0x21
    #include <P16F628A.INC>
    org 0x00
    bsf STATUS,5
    clrf TRISB
    bcf STATUS,5
    bsf PORTB,0
    call Tiempo3
    bcf PORTB,0
    call Tiempo3
    goto $-4
Tiempo3 call Tiempo
    call Tiempo
    call Tiempo
    call Tiempo
    return
Tiempo clrf VAR
    btfsc VAR,7
    return
    call Tiempo2  ;646us
    incf VAR,1  ; VAR <== VAR+1
    goto $-4
    
Tiempo2 clrf VAR2
    btfsc VAR2,7
    return
    incf VAR2,1
    goto $-3
    end

    ;18/05/22 SUTITSON Jorge Sánchez Rodriguez. 
    