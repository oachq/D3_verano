cblock
TEMP1
TEMP2
TEMP3
endc
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