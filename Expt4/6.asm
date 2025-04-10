section .data
    prompt db 'Enter a number: ', 0
    promptLen equ $ - prompt
    evenMsg db 'The number is even', 0xa
    evenMsgLen equ $ - evenMsg
    oddMsg db 'The number is odd', 0xa
    oddMsgLen equ $ - oddMsg
    
section .bss
    num resb 2         

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, promptLen
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 2
    int 80h
    
    mov eax, [num]
    sub eax, '0'     
    
    mov eax, [num]
    sub eax, '0'     
    and eax, 1      
    jz even_number    

odd_number:
    mov eax, 4
    mov ebx, 1
    mov ecx, oddMsg
    mov edx, oddMsgLen
    int 80h
    jmp exit

even_number:
    mov eax, 4
    mov ebx, 1
    mov ecx, evenMsg
    mov edx, evenMsgLen
    int 80h

exit:
    mov eax, 1         
    mov ebx, 0         
    int 80h
