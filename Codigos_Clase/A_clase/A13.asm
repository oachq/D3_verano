; ejemplo con el tmr1 y hacer igual que el ejmplo 12. "NO ES CONTADOR"

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

    CBLOCK	0X20
	    CT1
	    TEMP
	    BANDERA
	ENDC

	ORG		0X0000
	GOTO	INICIO

	ORG		0X0008
	GOTO	ISR_T1

CPORTS
	MOVLW	0x0F
	MOVWF	ADCON1
	MOVLW	0x07
	MOVWF	CMCON
	MOVLW	0x62
	MOVWF	OSCCON
	CLRF	TRISD
	CLRF	LATD
	RETURN

CONFT1			; configuracion del tmr1
	MOVLW	0xF8
	MOVWF	T1CON
    BCF		RCON,IPEN           ; descativa las prioridades
	BSF		INTCON,PEIE         ; 
	BSF		PIE1, TMR1IE        ;   
    BSF     IPR1, TMR1IP        ; prioridad 1
    movlw   0xDC    
    movwf   TMR1L
    movlw   0x0B
    movwf   TMR1H
    MOVLW   .2 ; 2 decimal
    movwf   CT1
	BCF		PIR1,TMR1IF ; limpiamos banderas
	RETURN

; NOTA el timer va a contar 0.5 segundos

ISR_T1
        BTFSS   PIR1, TMR1IF
        bra     FIN
        DECFSZ  CT1, F
        bra     FIN2
        INCF    TEMP, F
        movf    TEMP,w
        MOVWF   LATD
        movlw   .2      ;repite 2 veces para 
        movwf   CT1     ; 1 segundo 
FIN2    movlw   0xDC
        movwf   TMR1L
        movlw   0x0B
        movwf   TMR1H
        BCF     PIR1, TMR1IF
FIN     RETFIE

INICIO
    rcall   CPORTS
    rcall   CONFT1
    clrf    TEMP
    bsf     T1CON, TMR1ON
    bsf     INTCON, GIE
    bra     $
    END

