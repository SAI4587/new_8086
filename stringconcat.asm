data segment
msg1 db 13,10,"Enter a string : $"
msg2 db 13,10,"Entered string : $"
msg3 db 13,10,"Enter string to concat : $"
msg4 db 13,10,"result is : $"
msg5 db 13,10,"Enter a substring : $"
msg6 db 13,10,"Enter a newstr : $"
str1 db 20 dup("$")
str2 db 20 dup("$")
str3 db 20 dup("$")
newstr db 20 dup("$")
substr1 db 20 dup("$")
data ends
code segment
assume cs:code,ds:data

start:
        mov ax,data
        mov ds,ax

        lea dx,msg1
        mov ah,09h
        int 21h
        lea si,str1
        call input

        lea dx,msg3
        mov ah,09h
        int 21h
        lea si,str2
        call input
       
        lea dx,msg4
        mov ah,09h
        int 21h
        call concat

        lea dx,msg4
        mov ah,09h
        int 21h
        call reverse

        lea dx,msg5
        mov ah,09h
        int 21h
        lea si,substr1
        call input

        lea dx,msg6
        mov ah,09h
        int 21h
        lea si,newstr
        call input

        lea dx,msg4
        mov ah,09h
        int 21h
        call replace

        mov ah,4Ch
        int 21h

input proc 
loop1:  mov ah,01h
       int 21h
       cmp al,13
       je endinput
       mov [si],al
       inc si 
       jmp loop1
endinput: mov al,'$'
          mov [si],al
          ret
input endp 

output proc 
      mov ah,09h
      int 21h
      ret 
output endp

concat proc 
      lea si,str1 
      lea di,str2 
      mov cl,0
      mov al,'$' 

loop2: cmp al,[si] 
       je addspace
       inc si
       jmp loop2
addspace: mov [si],cl
          inc si
          jmp loop3 
    
loop3: cmp [di],al
       je endconcat
       mov bl,[di]
       mov [si],bl
       inc si
       inc di 
       jmp loop3
endconcat: mov [si],al
           lea dx,str1 
           call output
           ret
concat endp

reverse proc
     lea si,str1
     lea di,str3
     mov al,'$'
     mov cl,0h
toendloop: cmp al,[si]
        je skipdollar
        inc si
        inc cl
        jmp toendloop
skipdollar: dec si
            jmp movestr
movestr:cmp cl,0h 
        je exitrev
        mov bl,[si]
        mov [di],bl
        inc di
        dec si
        dec cl
        jmp movestr
exitrev: mov [di],al
         lea dx,str3 
         call output
         ret
reverse endp

replace proc
        lea si,str1
        lea di,substr1
        mov al,'$'
checkfirst: cmp [si],al
            je exitreplace
            mov bl,[si]
            cmp bl,[di]
            je savestart
            inc si 
            jmp checkfirst 
savestart: mov cx,si
           jmp checkother
checkother: cmp [si],al
            je exitreplace
            inc si 
            inc di 
            cmp [di],al
            je setback
            mov bl,[si]
            cmp bl,[di]
            jne resetpointer
            jmp checkother 
resetpointer: lea di,substr1
              jmp checkfirst
setback:mov si,cx
        lea di,newstr 
        jmp found
found: 
       mov bl,[di] 
       mov [si],bl 
       inc si 
       inc di 
       cmp al, [di]
       je exitreplace 
       jmp found
exitreplace: lea dx,str1 
             mov ah,09h
             int 21h 
             ret 
replace endp 
         
code ends
end start