; LCD a 4 bits con maestro udemy

	LIST	P=18F4550
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
	;#DEFINE	LCD	LATD
	#DEFINE	RS	LATA,0
	#DEFINE	RW	LATA,1
	#DEFINE	E	LATA,2

	CBLOCK	0X20
		TEMP1
		TEMP2
		TEMP3
        LCD_AUX1
        LCD_AUX2
	ENDC
	
	ORG	0X0000
	GOTO INICIO
	
	ORG	0X0018
	GOTO INICIO ; isr_proxima

C_PORTS
	MOVLW	0X0F
	MOVWF	ADCON1
	MOVLW	0X07
	MOVWF	CMCON
	MOVLW	0X62
	MOVWF	OSCCON
    ; configurar puertos para lcd de 4 bits
	CLRF	TRISD		; port d como salida
    bcf     TRISA,0     ; port C como salida
    bcf     TRISA,1     ; port C como salida
    bcf     TRISA,2     ; port C como salida
	RETURN

;TODO NOTA: portA0,1,2 son RS, RW, Enb en el codigo pic16f

CONFIG_LCD 
	BCF		RS			; 0 a comandos.
	BCF		RW			; 0 a comandos.
	BSF		E			; ponemos en 1 y al presentar el cambio a 0 se ejecuta su acción.
	movlw	.32			; cargamos con 32 ms para darle energy al lcd
	rcall	DELAY_MS	; retardo ms__
    rcall   CONFIG_LCD_4BITS

    ; modo de transferencia -> img_config_LCD
	movlw	b'00101000'	;  "COMANDO": "Modo de transferencia" -> bus de 4 bits, 2 filas lcd y 5x7
	;movwf	PORTD		; mandamos la data a port D para iniciar LCD
	;bcf		E			; Enb genera el cambio de 1 -> 0 y ejecuta el comando
	;movlw   .1			; tiempo del retardo 1ms
	;rcall	DELAY_MS	; llamamos al retardo 
	;bsf		E			; hacemos cambio de 0 -> 1 del eneble 
    rcall   LCD_COMANDO
	
    ; modo de control ON/OFF -> img_config_LCD
	movlw	b'00001111'	;  "COMANDO": "control ON/OFF" activando -> display, cursor y parpadeo
	;movwf	PORTD		; mandamos la data a port D para iniciar LCD
	;bcf		E			; Enb genera el cambio de 1 -> 0 y ejecuta el comando
	;movlw   .1			; tiempo del retardo 1ms
	;rcall	DELAY_MS	; llamamos al retardo 
	;bsf		E			; hacemos cambio de 0 -> 1 del eneble 
    rcall   LCD_COMANDO

	return

; LCD configuracion para 4 bits 
; sistema de configuracion de lcd 4 bits
;   AUX1 = 10100101 -> valor de modo de transferencia para 4 bits
;   Wt1 = 10100101
;   andlw   b'11110000'
;   Wt1= 1010 0000
;
; PORTD = YYYYXXXX
; W2 = YYYYXXXX
;   andlw b'00001111'
;   W2 = 0000xxxx
; PORTD = wt1 + wt2
;************ ************ ************ ************ ***********	************ ************ ************ 
CONFIG_LCD_4BITS
    bcf     PORTD,7     ; port D como 4bits
    bcf     PORTD,6     ; port D como 4bits
    bsf     PORTD,5     ; port D como 4bits
    bcf     PORTD,4     ; port D como 4bits
    bcf     E           ; E = 0
    movlw   .1          ; 
    rcall   DELAY_MS    ; retardo de 1ms
    bsf     E           ; E = 1
    return

LCD_MOSTRAR
	bsf		RS		; RS = 0
	rcall	LCD_ESCRIBIR
	return

LCD_ESCRIBIR        ; esta subrutina manda los 4 bits inferiores y despues los ultimos 4 bits y escribe de los dos modos: comando y caracter
    movwf   LCD_AUX1    
    bcf     RW      ; RW = 0 modo escritura
    movf    LCD_AUX1,W  ; captura los 8 bits 
    rcall   LCD_CM2     ; toma los 4 bits superiores y los envia
    swapf   LCD_AUX1,W  ; intercambio de 4 bits y lo guardo en W  
    rcall   LCD_CM2     ; toma los 4 bits superiores y los envia
    return

LCD_CM2
    andlw   b'11110000' ; colocamos a 0 los 4 bits inferiores
    movwf   LCD_AUX2
    movf    PORTD,W
    andlw   b'00001111'
    iorwf   LCD_AUX2,W  ; W <-- LCD_AUX2 + W 
    movwf   PORTD       ; mantenemos el valor del port D sin modificarlo
    bcf     E           ; E = 0
    movlw   .1  
    rcall   DELAY_MS    
    bsf     E           ; E =1
    return

LCD_COMANDO     ; subrutina que escribe en modo comando
    bcf     RS      ; RS = 0
    rcall   LCD_ESCRIBIR
    return


; FIN LCD configuracion para 4 bits 
;************ ************ ************ ************ ***********	************ ************ ************ 

; esta subrutina si funciona borrar
BORRAR          ; con esta subrutina borramos  8b
	;bcf		RS		; RS = 0
	movlw	b'00000001' ; "COMANDO": borrar pantalla
	;movwf	PORTD	; ingresar data al port D para borrar
	;bcf		E		; E = 0
	;movlw	.2
	;rcall	DELAY_MS
	;bsf		E		; E = 1
	rcall	LCD_COMANDO
	return

LCD_DIRE
	addlw	.128	;	W <== W+L(.128)
	rcall	LCD_COMANDO
	return

DP_I		; subrutina que desplaza a la izquierda
	movlw	b'00011100'
	rcall	LCD_COMANDO
	return


;************ ************ ************ ************ ***********	************ ************ ************ 
; INICIO retardo o hacer archivo de inclucion. 
DELAY_S 
        movwf TEMP3 
ATRAS   call DELAY_1S  
        decfsz TEMP3,1 
        goto ATRAS
        return
DELAY_1S 
        movlw .250
        call DELAY_MS
	    movlw .250
        call DELAY_MS
	    movlw .250
        call DELAY_MS
	    movlw .250
        call DELAY_MS
	    return
	 
DELAY_MS 
        movwf TEMP1 ;1us
ATRAS2    
        call DELAY_1MS  ;2us + 995us
        decfsz TEMP1,1 ;1us
        goto ATRAS2 ;2us
        return
DELAY_1MS 
        movlw .247 ;1 us
        movwf TEMP2  ;1us
ATRAS3    
        nop  ;1 us
        decfsz TEMP2,1  ;1 us
        goto ATRAS3  ;2us
        return	
; FIN retardo o hacer archivo de inclucion. 
;************	************ ************ ************ ***********	************ ************ ************ 

M1
	movlw	'H'
	rcall	LCD_MOSTRAR
	movlw	'O'
	rcall LCD_MOSTRAR
	movlw	'L'
	rcall	LCD_MOSTRAR
	movlw	'A'
	rcall	LCD_MOSTRAR
	return

INICIO
	rcall	C_PORTS
	rcall	CONFIG_LCD ; LCD_INT


REST	rcall M1
	    movlw	.1
	    rcall	DELAY_S
	    rcall	BORRAR
	    movlw	.1
	    rcall	DELAY_S
	    bra 	REST
	END