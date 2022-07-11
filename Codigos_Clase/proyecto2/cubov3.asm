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
    bcf     TRISE,1     ; salida leds GLE_2
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
  
  bcf  PISO_5
  
;2
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_4
  
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

  bcf  PISO_3
  

;4
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_2
  
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
  
  bcf  PISO_2

;5
  ; prendemos leds 1, 9, 17 y 25
  bsf  PISO_1
  
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

INICIO
    rcall   C_PORTS
    rcall   CONF_BASE_TIEMPO
    rcall   CONF_T0
	BSF		T0CON,TMR0ON    ; habilitamos el tmr0
	BSF		INTCON,GIE      ; interrupciones globales
    bra     $  

    END