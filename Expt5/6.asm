section .bss
    input resb 50

section .data
    prompt db 'Enter your name: ', 0
    prompt_len equ $ - prompt
    newline db 10, 0

section .text
    global _start

%macro PRINT 0
    push ecx
    push edx

    mov eax, 4
    mov ebx, 1
    mov ecx, input
    mov edx, 50
    int 80h

    pop edx
    pop ecx
%endmacro

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 50
    int 80h

    mov ecx, 7

print_loop:
    PRINT
    dec ecx
    jnz print_loop

    mov eax, 1
    xor ebx, ebx
    int 80h
