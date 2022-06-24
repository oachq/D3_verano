; LCD a 8 bits con maestro udemy

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
	CLRF	TRISD		; port d como salida
	CLRF	TRISA		; port c como salida	
	RETURN

;TODO NOTA: portA0,1,2 son RS, RW, Enb en el codigo pic16f

CONFIG_LCD 
	BCF		RS			; 0 a comandos.
	BCF		RW			; 0 a comandos.
	BSF		E			; ponemos en 1 y al presentar el cambio a 0 se ejecuta su acción.
	movlw	.32			; cargamos con 32 ms para darle energy al lcd
	rcall	DELAY_MS	; retardo ms__

	; modo de control ON/OFF -> img_config_LCD
	movlw	b'00001111'	;  "COMANDO": "control ON/OFF" activando -> display, cursor y parpadeo
	movwf	PORTD		; mandamos la data a port D para iniciar LCD
	bcf		E			; Enb genera el cambio de 1 -> 0 y ejecuta el comando
	movlw   .1			; tiempo del retardo 1ms
	rcall	DELAY_MS	; llamamos al retardo 
	bsf		E			; hacemos cambio de 0 -> 1 del eneble 

	; modo de transferencia -> img_config_LCD
	movlw	b'00111000'	;  "COMANDO": "Modo de transferencia" -> bus de 4 bits, 2 filas lcd y 5x7
	movwf	PORTD		; mandamos la data a port D para iniciar LCD
	bcf		E			; Enb genera el cambio de 1 -> 0 y ejecuta el comando
	movlw   .1			; tiempo del retardo 1ms
	rcall	DELAY_MS	; llamamos al retardo 
	bsf		E			; hacemos cambio de 0 -> 1 del eneble 

	return


ESCRIBRE
	movwf	PORTD	; mover el caracter al portD
	bsf		RS		; RS =1
	bcf		E		; E= 0, ejecuta una escritura.
	movlw	.1
	rcall	DELAY_MS
	bsf		E		; E= 1
	return

BORRAR
	bcf		RS		; RS = 0
	movlw	b'00000001' ; "COMANDO": borrar pantalla
	movwf	PORTD	; ingresar data al port D para borrar
	bcf		E		; E = 0
	movlw	.2
	rcall	DELAY_MS
	bsf		E		; E = 1
	return
;************ ************ ************ ************ ***********	************ ************ ************ 
; INICIO retardo o hacer archivo de inclucion. 

DELAY_S movwf TEMP3 
ATRAS call DELAY_1S  
    decfsz TEMP3,1 
    goto ATRAS
    return
DELAY_1S movlw .250
         call DELAY_MS
	 movlw .250
         call DELAY_MS
	 movlw .250
         call DELAY_MS
	 movlw .250
         call DELAY_MS
	 return
	 
DELAY_MS movwf TEMP1 ;1us
ATRAS2    call DELAY_1MS  ;2us + 995us
    decfsz TEMP1,1 ;1us
    goto ATRAS2 ;2us
    return
DELAY_1MS movlw .247 ;1 us
        movwf TEMP2  ;1us
ATRAS3    nop  ;1 us
    decfsz TEMP2,1  ;1 us
    goto ATRAS3  ;2us
    return	
; FIN retardo o hacer archivo de inclucion. 
;************	************ ************ ************ ***********	************ ************ ************ 

M1
	movlw	'H'
	rcall	ESCRIBRE
	movlw	'O'
	rcall ESCRIBRE
	movlw	'L'
	rcall	ESCRIBRE
	movlw	'A'
	rcall	ESCRIBRE
	return

INICIO
	rcall	C_PORTS
	rcall	CONFIG_LCD ; LCD_INT
	;movlw	b'01001000'
REST	rcall M1
	movlw	.1
	rcall	DELAY_S
	rcall	BORRAR
	movlw	.1
	rcall	DELAY_S
	;rcall M1
	bra 	REST
	END