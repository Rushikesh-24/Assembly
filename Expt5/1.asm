section .data
    prompt1 db 'Enter a number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Entered Number : ', 0
    len2 equ $ - prompt2
    newline db 0xa

%macro display 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

section .bss
    num resb 2

section .text
    global _start

_start:
    display prompt1,len1
    
    mov eax, 3        
    mov ebx, 0         
    mov ecx, num     
    mov edx, 2         
    int 80h

    display prompt2,len2
    display num, 2

    mov eax, 1         
    mov ebx, 0         
    int 80h
