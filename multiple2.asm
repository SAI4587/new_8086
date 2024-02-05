data segment
msg1 db 13,10,"enter number  : $"
msg2 db 13,10,"result is : $"
num db ?
result dw ?
data ends
code segment
assume cs:code, ds:data

start:
       mov ax,data
       mov ds,ax
       mov cl,04h

       mov ah,09h
       lea dx,msg1
       int 21h 
       call input

       call check

       
       mov ah,4ch
       int 21h

input proc
      mov ah,01h
      int 21h

      sub al,30h
      cmp al,09h
      jle skip1
      sub al,07h
      skip1: rol al,cl
             mov num,al

      mov ah,01h
      int 21h
      sub al,30h
      cmp al,09h
      jle skip2
      sub al,07h
      skip2: add al,num
             mov num,al
     ret
input endp

output proc
     mov ah,09h
     lea dx,msg2
     int 21h 

     mov ax,result
     and ah,0f0h
     rol ah,cl
     add ah,30h
     cmp ah,39h
     jle skip7
     add ah,07h
     skip7 : mov dl,ah
             mov ah,02h
             int 21h

     mov ax,result
     and ah,0fh
     add ah,30h
     cmp ah,39h
     jle skip8
     add ah,07h
     skip8 : mov dl,ah
             mov ah,02h
             int 21h
;;;;;;;;;;;;;;;;;;;;;;;;
     mov ax,result
     and al,0f0h
     rol al,cl
     add al,30h
     cmp al,39h
     jle skip5
     add al,07h
     skip5 : mov dl,al
             mov ah,02h
             int 21h

     mov ax,result
     and al,0fh
     add al,30h
     cmp al,39h
     jle skip6
     add al,07h
     skip6 : mov dl,al
             mov ah,02h
             int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ret
output endp

check proc
     mov bl,01h
     mov cl,num

loop1 : mov al,bl
        jmp subloop

subloop : 
    sub al, cl
    jnc notdivisible
    jmp nextnum

notdivisible:
    cmp al, 0   ; Check if subtraction result is zero
    jnz nextnum ; If not zero, it's not divisible
    jmp print    ; If zero, it's divisible

print : 
    mov result, bx
    call output
    jmp nextnum

nextnum : 
    inc bl 
    cmp bl, 14h
    je exit
    jmp loop1


exit : 
      ret
check endp

code ends
end start