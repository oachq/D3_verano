__CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_ON & _LVP_OFF & _CPD_OFF & _CP_OFF
    LIST P=16F628A
    cblock 0x20
    CONTA
    endc
    #include <P16F628A.INC>
    org 0x00
    movlw 0x07
    movwf CMCON
    bsf STATUS,RP0
    clrf TRISB
    clrf TRISA
    bcf STATUS,RP0
    call LCD_INI
inicio   clrf CONTA
    call LCD_BORRAR
    movlw .14
    call LCD_DIRE
    movf CONTA,W
    call LCD_MOSTRAR_2H
    movlw .250
    call DELAY_MS
    incf CONTA,F
    movlw .100  ;W <== 100
    subwf CONTA,W  ;W <== CONTA-10
    btfss STATUS,Z
    goto $-.11
    goto inicio

cblock
    LCD_U
    LCD_D
    LCD_AUX1
    LCD_AUX2
endc
LCD_INI bcf PORTA,0 ;RS a 0, como comando
    bcf PORTA,1  ;RW a 0
    bsf PORTA,2  ; E=1
    movlw .32
    call DELAY_MS
    call LCD_4B
    movlw b'00101000' ; bus de 4,2 filas y 5*8
    call LCD_COMANDO
    movlw b'00001100' ; DIsplay ON, cursor OFF parpadeoC OFF
    call LCD_COMANDO
    return
LCD_4B bcf PORTB,7
    bcf PORTB,6
    bsf PORTB,5
    bcf PORTB,4
    bcf PORTA,2 ;E=0
    movlw .1
    call DELAY_MS
    bsf PORTA,2 ; E=1
    return
LCD_COMANDO bcf PORTA,0  ;RS=0
    call LCD_ESCRIBIR
    return
LCD_MOSTRAR bsf PORTA,0  ;RS=1
    call LCD_ESCRIBIR
    return
    
LCD_ESCRIBIR movwf LCD_AUX1
    bcf PORTA,1  ;RW=0
    movf LCD_AUX1,W
    call LCD_CM2   ;coge los 4 bits superiores y los envia
    swapf LCD_AUX1,W ;intercambio 4 bits y lo guardo en W
    call LCD_CM2
    return
LCD_CM2  andlw b'11110000' ;ponemos a 0 los 4 bits inferiores 
    movwf LCD_AUX2
    movf PORTB,W
    andlw b'00001111'
    iorwf LCD_AUX2,W   ;W <== LCD_AUX2 + W
    movwf PORTB
    bcf PORTA,2   ;E=0
    movlw .1
    call DELAY_MS
    bsf PORTA,2  ;E=1
    return
 
LCD_MOSTRAR_H addlw 0x30
    call LCD_MOSTRAR
    return

LCD_MOSTRAR_2H movwf LCD_U
    clrf LCD_D
LCD_CHECK    movlw .10
    subwf LCD_U,W  ;w <== LCD_U -10
    btfss STATUS,C ; C=0, SI SE PRESTA
    goto LCD_TER
    incf LCD_D,F
    movlw .10
    subwf LCD_U,F
    goto LCD_CHECK
LCD_TER movf LCD_D,W
    call LCD_MOSTRAR_H
    movf LCD_U,W
    call LCD_MOSTRAR_H
    return
    
M1   movlw 'H'
    call LCD_MOSTRAR
    movlw 'o'
    call LCD_MOSTRAR
    movlw 'l'
    call LCD_MOSTRAR
    movlw 'a'
    call LCD_MOSTRAR
    return
LCD_BORRAR movlw b'00000001'
    call LCD_COMANDO
    return
LCD_DIRE addlw .128  ; W <== W+L(.128)
    call LCD_COMANDO
    return
LCD_DP_I movlw b'00011100'
    call LCD_COMANDO
    return
    
    include <delay4.INC>
    end