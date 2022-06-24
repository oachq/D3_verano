; configurar configuraciones iniciales.

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

; configuraciones de cajon 


cblock 0x00 
VAR 
endc

org 0x000
goto INICIO

org 0x0018
goto INICIO

conf_puertos
    movlw 0x0F
    movwf ADDCON1
    movlw 0x007
    movwf CMCON
    movwf 0x62
    movwf OSCCON
    clrf TRISB
    movwf TRISA
    clrf LATA
    clrf LATB
return

INICIO
    rcall conf_puertos

OTRO
    movf PORTA, W
    movwf VAR
    movf  VAR, W
    movwf LATB
    BRA OTRO

end
