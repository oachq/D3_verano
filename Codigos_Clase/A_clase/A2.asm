; configurar configuraciones iniciales.
; programa que intercambia los nibbles del puerto B
; cada segundo

list P=18f4550
#include <P18F4550.inc>

CONFIG FOSC         = INTOSCIO_EC
CONFIG BOR          = OFF
CONFIG PBADEN       = OFF
CONFIG PWRTE        = ON
CONFIG WDT          = OFF

CONFIG CP0          = OFF
CONFIG CP1          = OFF
CONFIG CPB          = OFF
CONFIG XINST        = OFF
CONFIG DEBUG        = OFF

cblock 0x00
    CUENTA
    CUENTA_2
    CUENTA_3
endc

org     0x000
goto    INICIO

org     0x018
goto    INICIO

CONFIG_PORTS
    movlw   0X0F
    movwf   ADDCON1 ; PIN DIGITALES
    movlw   0X07
    movwf   CMCON   ;DES - ACT COMPARADORES ANALOGICOS 
    movlw   0x62    
    movwf   OSCCON  ; FOSC OSCILADOR 4 MHz. 
    clrf    TRISB   ;; ESCRIBIR EN EL PUERTO
    clrf    LATB    ; LIMPIAR PUERTO B
    return

RETARDO
        movlw   .20
        movwf   CUENTA_3
OTRO3   movlw   .200
        movwf   CUENTA_2
OTRO2   movlw   .82
        movwf   CUENTA
OTRO    DECFSZ  CUENTA, F
        BRA     OTRO
        DECFSZ  CUENTA_2, F
        BRA     OTRO2
        DECFSZ  CUENTA_3, F
        BRA     OTRO3
        return

INICIO
    rcall   CONFIG_PORTS
    movlw   0x0F
    movwf   LATB

NEXT 
    rcall   RETARDO
    SWAPF   LATB, F
    BRA     NEXT
end

