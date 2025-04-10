section .data
    prompt1 db 'Enter the first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter the second number: ', 0
    len2 equ $ - prompt2
    prompt3 db 'Entered Number: ', 0
    len3 equ $ - prompt3
    newline db 0xa

%macro display 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

section .bss
    num1 resb 2
    num2 resb 2

section .text
    global _start

_start:
    display prompt1, len1
    
    mov eax, 3        
    mov ebx, 0         
    mov ecx, num1     
    mov edx, 2         
    int 80h

    display prompt2, len2
    
    mov eax, 3        
    mov ebx, 0         
    mov ecx, num2     
    mov edx, 2         
    int 80h

    display prompt3, len3
    display num1, 2
    display prompt3, len3
    display num2, 2

    mov eax, 1         
    mov ebx, 0         
    int 80h
