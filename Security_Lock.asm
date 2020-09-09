      .DATA
DATA1 DD 111111H,222222H,333333H,444444H,555555H,666666H,777777H,888888H,999999H,111222H
DATA4 DD 111333H,111444H,111555H,111666H,111777H,111888H,111999H,222111H,222333H,222444H                                   
DATA2 DB  7,?,7 DUP (?)       
DATA3 DB 'ENTER YOUR ID: ','$'           
DATA6 DW 1111H,2222H,3333H,4444H,5555H,6666H,7777H,8888H,9999H,1112H
DATA7 DW 1113H,1114H,1115H,1116H,1117H,1118H,1119H,2221H,2223H,2224H
DATA8 DW 1111H,2222H,3333H,4444H,5555H,6666H,7777H,8888H,9999H,1112H
DATA9 DW 1113H,1114H,1115H,1116H,1117H,1118H,1119H,2221H,2223H,2224H 
DATAA DB 'Your ID is wrong, Please try again!!','$' 
DATAB DB 'ENTER YOUR PASSWORD: ','$'   
DATAC DB 5,?,5 DUP (?)         
DATAD DB 'WELCOME(ALLOWED)','$' 
DATAE DB 'WRONG PASSWORD,TRY AGAIN','$'     
DATAF DB 00H
DATAG DB '---------------------------------------------------------------','$'
;-----------------
               .CODE
MAIN             PROC FAR      
                 MOV AX,DATA             ;move offset of data segment to AX
                 MOV DS,AX               ;Mov AX to DS
                 MOV ES,AX               ;Make DS and ES OVERLAPPED
                 MOV  DH,00H             ;Initialize DH With zeros                
                 MOV  BP,OFFSET DATAF    ;Mov Offset dataf to BP to use it in setting cursor
START:           CALL SETCURSOR          ;Call SETCURSOR procedure 
                 CALL ID                 ;Call ID, requests the ID               
                 CALL PASS               ;Call PASS , requests the password
                 MOV  SI,OFFSET DATA2+2  ;Initialize SI to point to the ID data in memory
                 CALL PUTIDINAX          ;Call PUTIDINAX, puts ID which comes from memory in AX 
                 CALL CHECKID            ;Call CHECKID , checks ID if it is right or wrong
                 CALL SETCURSOR          
                 CALL GETPASS            ;Call GETPASS , takes password from user
                 MOV  SI,OFFSET DATAC+2  ;Initialize, SI to point to datac in memory
                 CALL PUTIDINAX          ;Call PUTIDINAX, puts password which comes from memory in AX 
                 CALL CHECKPASS          ;Call CHECKPASS, checks password if it is right or wrong
                 CALL SETCURSOR          
                 CALL ENTER              ;Call ENTER, if password is right ... ALLAWED
WRONGID:         CALL SETCURSOR          
                 CALL WRONG_ID
WRONGPASS:       CALL SETCURSOR
                 CALL WRONG_PW
MAIN             ENDP        
;----------------    
ID               PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATA3
                 INT 21H
                 RET
ID               ENDP
;--------------
PASS             PROC
                 MOV AH,0AH
                 MOV DX,OFFSET DATA2
                 INT 21H 
                 RET
PASS             ENDP             
;---------------    
PUTIDINAX        PROC                  
                 MOV CX,04H
AGAIN2:          CMP [SI],39H          
                 SUB [SI],30H                
                 INC SI 
                 DEC CX   
                 JNZ AGAIN2       
                 SUB SI,4
                 MOV AH,[SI]
                 MOV AL,[SI+2]
                 MOV BH,[SI+1]
                 MOV BL,[SI+3]
                 SHL AX,4
                 OR  AX,BX  
                 RET
PUTIDINAX        ENDP
;--------------         
CHECKID          PROC
                 MOV CX,21           
                 LEA DI,DATA6         ; DI = OFFSET DATA6
                 CLD                  ; DF = 0 (AUTO INCREAMENT)
                 REPNE SCASW          ; Check if the ID exists or not
                 CMP CX,0000H         ; Check if the ID exists or not
                 JZ WRONGID           ; If not exists jump to WRONGID
                 RET          
CHECKID          ENDP
;--------------
WRONG_ID         PROC 
                 MOV AH,09H
                 MOV DX,OFFSET DATAA
                 INT 21H     
                 CALL LINE
                 JMP START
                 RET
WRONG_ID         ENDP
;-------------
GETPASS          PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAB
                 INT 21H   
                 MOV AH,0AH
                 MOV DX,OFFSET DATAC
                 INT 21H
                 RET             
GETPASS          ENDP
;-------------
CHECKPASS        PROC   
                 MOV BX,AX
                 ADD DI,38            ; If exist, jump to the password which equivalent to thad ID
                 CMP BX,[DI]          ; Check if the password correct or not
                 JNZ WRONGPASS 
                 RET
CHECKPASS        ENDP      
;------------          
WRONG_PW         PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAE
                 INT 21H   
                 CALL LINE
                 JMP START
WRONG_PW         ENDP    
;-------------
ENTER            PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAD
                 INT 21H 
                 CALL LINE 
                 JMP START
                 RET
ENTER            ENDP 

;------------  
SETCURSOR        PROC 
                 MOV AH,02H
                 MOV BH,00
                 MOV DL,00
                 MOV DH,DS:[BP]   ;coloumn   ;row
                 INT 10H
                 ADD DS:[BP],1
                 RET
SETCURSOR        ENDP      
;---------------- 
lINE             PROC  
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAG
                 INT 21H
                 RET
lINE             ENDP
;--------------  
                 END MAIN