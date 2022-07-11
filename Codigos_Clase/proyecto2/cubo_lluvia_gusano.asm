; Proyecto final cubo de leds
;*******************************************************************************
    LIST P = 18F4550
    INCLUDE <P18F4550.INC>
    RADIX HEX
    
;*******************************************************************************
;            BITS DE CONFIGURACION
;*******************************************************************************
;********     Configuracion del Oscilador  *************************************
;  oscilador interno, RA6 como pin, USB usa oscilador EC
    CONFIG FOSC = INTOSCIO_EC
;*********   Bits de configuracion mas usados   ********************************
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG WDT = OFF
    CONFIG MCLRE = OFF
    CONFIG PBADEN = OFF
    CONFIG LVP = OFF
    CONFIG DEBUG = OFF
    CONFIG XINST = OFF
    
;********  Bits de proteccion   ************************************************
    CONFIG CP0 = OFF
    CONFIG CP1 = OFF
    CONFIG CPB = OFF
    

    CBLOCK	0X20
	CT0
	TEMP
	BANDERA
	ENDC

; Vector de Reset.
    ORG 0x0000
    GOTO INICIO
 ;Vector de interrupcion de baja prioridad
    ORG 0x0008
    GOTO ISR_T0     ; isr t0

 ; Subrutina que configura la base de tiempo del MCU
CONF_BASE_TIEMPO
     movlw B'01100010'  ; 62h
     movwf OSCCON   ;osiclador  4MHZ


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

    bcf     TRISC,0     ; Salida leds GL_2  
    bcf     TRISC,1     ; Salida leds GL_3 
    bcf     TRISC,2     ; Salida leds GL_4  
    bcf     TRISC,6     ; Salida leds GL_5  
    bcf     TRISC,7     ; Salida leds GL_6

    bcf     TRISD,0     ; salida leds GL_7
    bcf     TRISD,1     ; salida leds GL_8
    bcf     TRISD,2     ; salida leds GL_9
    bcf     TRISD,3     ; salida leds GL_10

    bcf     TRISE,0     ; salida leds GLE_0
    bcf     TRISE,1     ; salida leds GLE_1
    bcf     TRISE,1     ; salida leds GLE_2
    return

      #DEFINE GL_1 LATA,5  ; decoder 1  
      #DEFINE GL_2 LATC,0  ; decoder 1
      #DEFINE GL_3 LATC,1  ; decoder 1

      #DEFINE GL_4 LATC,2  ; decoder 2
      #DEFINE GL_5 LATC,6  ; decoder 2
      #DEFINE GL_6 LATC,7  ; decoder 2

      #DEFINE GL_7  LATD,0 ; decoder 3
      #DEFINE GL_8  LATD,1 ; decoder 3
      #DEFINE GL_9  LATD,2 ; decoder 3

      #DEFINE GL_10 LATD,3 ; directivy

      #DEFINE GLE_0 LATE,0 ; eneble decoder
      #DEFINE GLE_1 LATE,1;  eneble decoder
      #DEFINE GLE_2 LATE,1;  eneble decoder

  ;****************************** FIN GL y GLE **************************************************


CONFT0			; configuracion del tmr0
	MOVLW	47H ;01000111
	MOVWF	T0CON
	BCF		RCON,IPEN
	BSF		INTCON,TMR0IE
	BSF		INTCON,TMR0IP
	BSF		INTCON,PEIE
	MOVLW	.61			; dato sacado de la formula 
	MOVWF	TMR0L
	MOVLW	.40			; multiplicacion por 40 decimal apra acompletar 1 seg 
	MOVWF	CT0
	BCF		INTCON,TMR0IF ; limpiamos banderas
	RETURN

ISR_T0
		  BTFSS	INTCON,TMR0IF
		  BRA		FIN
		  DECFSZ	CT0,F
		  BRA		FIN2
		  BSF		BANDERA,0
FIN2	MOVLW	.40
		  MOVWF	CT0
		  MOVLW	.61
	    MOVWF	TMR0L
		  BCF		INTCON,TMR0IF
FIN		RETFIE

;************************************************************************************************************************
;**********************************************PARTE DE LEDS*************************************************************
;************************************************************************************************************************

; CONTROL DE PISOS ENCENDIDO.
CONTROL_PISO_1_ON
  movlw B'00000001' 
    movwf PORTA
    return
CONTROL_PISO_2_ON
  movlw B'00000010' 
    movwf PORTA
    return
CONTROL_PISO_3_ON
  movlw B'00000100' 
    movwf PORTA
    return
CONTROL_PISO_4_ON
  movlw B'00001000' 
    movwf PORTA
    return
CONTROL_PISO_5_ON
  movlw B'00010000' 
    movwf PORTA
    return
;; CONTROL DE PISOS ENCENDIDO.
;; CONTROL DE PISOS APAGADO.
CONTROL_PISO_OFF
  movlw B'00000000' 
    movwf PORTA
  return
;; CONTROL DE PISOS APAGADO.
;************************************************************************************************************************
;**********************************************PARTE DE LEDS*************************************************************
;************************************************************************************************************************



FIGURA_GUSANO
    rcall CONTROL_PISO_5_ON
    ; led 1
    bcf GL_1
    bcf GL_2
    bcf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 1
    
    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza 

    ; led 2
    bcf GL_1
    bcf GL_2
    bsf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 2

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza 

    ; led 3
    bcf GL_1
    bsf GL_2
    bcf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 3

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza 

    ; led 4
    bcf GL_1
    bsf GL_2
    bsf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 4

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza 

    ; led 5
    bsf GL_1
    bcf GL_2
    bcf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 5

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza 

    ; led 6
    bcf GL_1
    bcf GL_2
    bsf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 6

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza 

    ; led 7
    bsf GL_1
    bsf GL_2
    bcf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 7

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza

    ; led 8
    bsf GL_1
    bsf GL_2
    bsf GL_3

    bsf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; led 8

    ; limpieza 
    bcf GLE_0
    bcf GLE_1
    bcf GLE_2
    ; Fin limpieza
  rcall CONTROL_PISO_OFF



INICIO
      rcall   C_PORTS
      rcall CONF_BASE_TIEMPO
      rcall   CONFT0
      BSF		T0CON,TMR0ON
	    BSF		INTCON,GIE
	    CLRF	TEMP
AQUI	CLRF	TEMP
		  BTFSS	BANDERA,0
		  BRA		FIGURA_GUSANO
OTRO	BCF		BANDERA,0
      RCALL	FIGURA_GUSANO
		  ;MOVWF	LATD
		  INCF	TEMP,F
		  MOVLW	.4
		  SUBWF	TEMP,W
		  BZ		AQUI	
		  BRA		OTRO
ADIOS	RCALL	FIGURA_GUSANO
		  ;MOVWF	LATD
		  INCF	TEMP,F
		  MOVLW	.3
		  SUBWF	TEMP,W
		  BZ		AQUI	
		  BRA		ADIOS
  END