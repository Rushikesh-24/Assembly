section .data
    prompt db 'Enter a number: ', 0
    len equ $ - prompt
    greaterMsg db 'Number is greater than 5', 0
    greaterLen equ $ - greaterMsg
    equalMsg db 'Number is equal to 5', 0
    equalLen equ $ - equalMsg
    lessMsg db 'Number is less than 5', 0
    lessLen equ $ - lessMsg
    newline db 0xa

section .bss
    num resb 2

section .text
    global _start

_start:
    mov eax, 4         
    mov ebx, 1        
    mov ecx, prompt  
    mov edx, len      
    int 80h
    
    mov eax, 3        
    mov ebx, 0         
    mov ecx, num     
    mov edx, 2         
    int 80h
    
    mov al, [num]
    sub al, '0'
    
    cmp al, 5
    je equal_to_5
    jl less_than_5

greater_than_5:
    mov eax, 4
    mov ebx, 1
    mov ecx, greaterMsg
    mov edx, greaterLen
    int 80h
    jmp exit

equal_to_5:
    mov eax, 4
    mov ebx, 1
    mov ecx, equalMsg
    mov edx, equalLen
    int 80h
    jmp exit

less_than_5:
    mov eax, 4
    mov ebx, 1
    mov ecx, lessMsg
    mov edx, lessLen
    int 80h

exit:
    mov eax, 1         
    mov ebx, 0         
    int 80h
