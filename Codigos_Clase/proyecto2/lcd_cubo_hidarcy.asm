LIST	P=18F4550
	#INCLUDE	<P18F4550.INC>
	
	CONFIG	FOSC=INTOSCIO_EC
	CONFIG	BOR=OFF	
	CONFIG	CP0=OFF	
	CONFIG	CP1=OFF	
	CONFIG	CPB=OFF	
	CONFIG	DEBUG=OFF	
	CONFIG	LVP=OFF	
	CONFIG	MCLRE=OFF	 
	CONFIG	PBADEN=OFF
	CONFIG	PWRT=ON
	CONFIG	XINST=OFF	
	CONFIG	WDT=OFF	

    ORG		0X0000
	GOTO	INICIO

	ORG		0X0008
	GOTO	ISR_T0

    CBLOCK	0X20
	CT0
	TEMP
	BANDERA
    TEMP1
		TEMP2
		TEMP3
           LCD_AUX1
        LCD_AUX2
	ENDC
      
    #DEFINE	GL_1 LATA,5  ; decoder 1  
    #DEFINE	GL_2 LATA,6  ; decoder 1  
    #DEFINE GL_3 LATC,0  ; decoder 1
    #DEFINE GL_4 LATC,1  ; decoder 1
    #DEFINE GL_5 LATC,2  ; decoder 2
    #DEFINE GL_6 LATC,6  ; decoder 2
    #DEFINE GL_7 LATC,7  ; decoder 2
    #DEFINE GL_8  LATD,0 ; decoder 3
    #DEFINE GL_9  LATD,1 ; decoder 3
    #DEFINE GL_10  LATD,2 ; decoder 3
    #DEFINE GLE_0 LATE,0 ; eneble decoder
    #DEFINE GLE_1 LATE,1;  eneble decoder
    #DEFINE GLE_2 LATE,2;  eneble decoder

    #DEFINE PISO_5  LATA,4
    #DEFINE PISO_4  LATA,3
    #DEFINE PISO_3  LATA,2
    #DEFINE PISO_2  LATA,1
    #DEFINE PISO_1  LATA,0

    ;#DEFINE	RS	LATA,0
	#DEFINE	RS	LATD,3
	#DEFINE	E	LATB,7
; Subrutina que configura la base de tiempo del MCU
CONF_BASE_TIEMPO
     movlw B'01100010'  ; 62h
     movwf OSCCON   ;osiclador  4MHZ
    return

;nota port C 4 y 5 solo son inputs

; port A control de pisos   
; port B teclado matricial      
; port C control de leds  0, 1, 2, 3 , 6 y 7
; port E control de leds 0 y 1
; Port D control de LCD 

C_PORTS
    ; puertos Dig.
    movlw   0x0F
    movwf   ADCON1
    movlw   0x07
    movwf   CMCON       ; desc comparadores.
    ;FIN puertos Dig.

    ; config puertos 
    bcf    TRISA,0      ; control de pisos
    bcf    TRISA,1      ; control de pisos
    bcf    TRISA,2      ; control de pisos
    bcf    TRISA,3      ; control de pisos
    bcf    TRISA,4      ; control de pisos
   
    ;movlw    B'11111111' ; entrada
    ;movwf    TRISB       ; keypad.

  ;****************************** GL y GLE **************************************************
    bcf     TRISA,5     ; Salida leds GL_1  
    bcf     TRISA,6     ;Salida leds GL_2

    bcf     TRISC,0     ; Salida leds GL_2  
    bcf     TRISC,1     ; Salida leds GL_3 
    bcf     TRISC,2     ; Salida leds GL_4  
    bcf     TRISC,6     ; Salida leds GL_5  
    bcf     TRISC,7     ; Salida leds GL_6

    bcf     TRISD,0     ; salida leds GL_7
    bcf     TRISD,1     ; salida leds GL_8
    bcf     TRISD,2     ; salida leds GL_9
   ; bcf     TRISD,3     ; salida leds GL_10

    bcf     TRISE,0     ; salida leds GLE_0
    bcf     TRISE,1     ; salida leds GLE_1
    bcf     TRISE,2     ; salida leds GLE_2
   

     bcf    TRISD,3     ; LCD E RS 
     bcf    TRISB,7     ; LCD E E

    bcf     TRISD,4     ; LCD salidas 
    bcf     TRISD,5     ; LCD salidas 
    bcf     TRISD,6     ; LCD salidas 
    bcf     TRISD,7     ; LCD salidas 
 return
  ;****************************** FIN GL y GLE **************************************************

CONF_T0
    movlw B'00000111'
    movwf T0CON
    movlw   0xFF ; datos de la formula
    movwf   TMR0H
    movlw   0xB2    
    movwf   TMR0L
    BCF		INTCON,TMR0IF ; limpiamos banderas
	BSF		INTCON,TMR0IE   ; habilitamos la interrupcion por desbordamiento
    return

ISR_T0
	BTFSS	INTCON,TMR0IF   ;si la bandera de interrupcion del tmr0 se prende 
    bra     FIN
   	BCF		INTCON,TMR0IF
   ; btg     LATB,0      ; aqui seria la subrutina para port led
    bra    MAIN_ISR
    movlw   0xFF ; datos de la formula
    movwf   TMR0H
    movlw   0xB2    
    movwf   TMR0L
FIN    RETFIE


;************************************************************************************************************************
;**********************************************PARTE DE LEDS*************************************************************
;************************************************************************************************************************

FIGURA_LLUVIA
;1
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_5
    movlw   .1
    rcall   DELAY_MS
  bcf GL_1
  bcf GL_2
  bcf GL_3
  bcf GL_4
  bcf GL_5
  bcf GL_6
  bcf GL_7
  bcf GL_8
  bcf GL_9
  bcf GL_10

  bsf GLE_0
  bsf GLE_1
  bsf GLE_2
   movlw   .1
   rcall   DELAY_MS
  bcf  PISO_5
  
;2
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_4
    movlw   .1
   rcall   DELAY_MS
  bcf GL_1
  bcf GL_2
  bcf GL_3
  bcf GL_4
  bcf GL_5
  bcf GL_6
  bcf GL_7
  bcf GL_8
  bcf GL_9
  bcf GL_10

  bsf GLE_0
  bsf GLE_1
  bsf GLE_2

  bcf  PISO_4
  
  
;3
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_3
  
  bcf GL_1
  bcf GL_2
  bcf GL_3
  bcf GL_4
  bcf GL_5
  bcf GL_6
  bcf GL_7
  bcf GL_8
  bcf GL_9
  bcf GL_10

  bsf GLE_0
  bsf GLE_1
  bsf GLE_2
  movlw   .1
   rcall   DELAY_MS
  bcf  PISO_3
  

;4
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_2
    movlw   .1
   rcall   DELAY_MS
  bcf GL_1
  bcf GL_2
  bcf GL_3
  bcf GL_4
  bcf GL_5
  bcf GL_6
  bcf GL_7
  bcf GL_8
  bcf GL_9
  bcf GL_10

  bsf GLE_0
  bsf GLE_1
  bsf GLE_2
    movlw   .1
   rcall   DELAY_MS
  bcf  PISO_2

;5
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_1
    movlw   .1
   rcall   DELAY_MS
  bcf GL_1
  bcf GL_2
  bcf GL_3
  bcf GL_4
  bcf GL_5
  bcf GL_6
  bcf GL_7
  bcf GL_8
  bcf GL_9
  bcf GL_10

  bsf GLE_0
  bsf GLE_1
  bsf GLE_2
    movlw   .1
   rcall   DELAY_MS
  bcf  PISO_1
  
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


;************	************ ************ ************ ***********	************ ************ ************ 

MAIN_ISR
    movlw   .5
    movwf   CT0
    ;rcall   FIGURA_LLUVIA
    decfsz  CT0,F
    rcall FIGURA_LLUVIA; no es cero
    ; es cero
    RETURN


CONFIG_LCD 
	BCF		RS			; 0 a comandos.
	;BCF		RW			; 0 a comandos.
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
  ;  bcf     RW      ; RW = 0 modo escritura
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
;************ ************ ************ ************ ***********	************ ************ ************ 
M1
	movlw	'H'
	rcall	LCD_MOSTRAR
	movlw	'I'
	rcall LCD_MOSTRAR
	movlw	' '
	rcall	LCD_MOSTRAR
    movlw	'D'
	rcall	LCD_MOSTRAR
    movlw	'A'
	rcall	LCD_MOSTRAR
    movlw	'R'
	rcall	LCD_MOSTRAR
    movlw	'C'
	rcall	LCD_MOSTRAR
    movlw	'Y'
	rcall	LCD_MOSTRAR
	return
INICIO
    rcall   C_PORTS
    rcall   CONF_BASE_TIEMPO
	rcall	CONFIG_LCD ; LCD_INT
    rcall   CONF_T0
    BSF		T0CON,TMR0ON    ; habilitamos el tmr0
	BSF		INTCON,GIE      ; interrupciones globales
    REST	rcall M1
	    movlw	.1
	    rcall	DELAY_S
	    rcall	BORRAR
	    movlw	.1
	    rcall	DELAY_S
	    bra 	REST

    END