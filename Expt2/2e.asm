section .data
    msg1 db 'Number:', 0  
    msg1len equ $-msg1

section .bss
    num resb 5

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 5
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1len
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 5
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h
