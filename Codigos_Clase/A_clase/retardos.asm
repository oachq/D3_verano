; retardo
; son variables para los retardos.
CUENTA
CUENTA2
CUENTA3

RETARDO
        movlw   p
        movwf   CUENTA3
OTRO3   movlw   m
        movwf   CUENTA2
OTRO2   movlw   n  ; n es un valor que varia de 0 a 255
        movwf   CUENTA    ;1(n-1)+2 
OTRO    DECFSZ  CUENTA,F  ;2(n-1)
        DECFSZ  CUENTA2,F
        bra     OTRO2
        DECFSZ  CUENTA3,F
        bra     OTRO3
        return

