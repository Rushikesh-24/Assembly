section .data
    prompt1 db 'Enter the first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter the second number: ', 0
    len2 equ $ - prompt2
    addprint db 'Sum: ', 0
    addleng equ $ - addprint
    subprint db 'Difference: ', 0
    subleng equ $ - subprint
    mulprint db 'Product: ', 0
    mulleng equ $ - mulprint
    divprint db 'Quotient: ', 0
    divleng equ $ - divprint
    divreminder db 'Remainder: ', 0
    divreminderleng equ $ - divreminder
    newline db 10, 0
    newlinelen equ $ - newline

%macro display 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro input 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 80h
%endmacro

%macro Addition 3
    mov al, [%1]
    sub al, '0'
    mov bl, [%2]
    sub bl, '0'
    add al, bl
    add al, '0'
    mov [%3], al
%endmacro

%macro Subtraction 0
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    sub al, bl
    add al, '0'
    mov [result], al
%endmacro

%macro Multiplication 0
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    mul bl
    add al, '0'
    mov [result], al
%endmacro

%macro Division 0
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    mov ah, 0
    div bl
    add al, '0'
    mov [result], al
    add ah, '0'
    mov [result2], ah
%endmacro

section .bss
    num1 resb 2
    num2 resb 2
    result resb 2
    result2 resb 2

section .text
    global _start

_start:
    display prompt1, len1
    input num1, 2

    display prompt2, len2
    input num2, 2

    ; Addition operation
    Addition num1, num2, result
    display addprint, addleng
    display result, 1
    display newline, newlinelen
    
    ; Subtraction operation
    Subtraction
    display subprint, subleng
    display result, 1
    display newline, newlinelen

    ; Multiplication operation
    Multiplication
    display mulprint, mulleng
    display result, 1
    display newline, newlinelen

    ; Division operation
    Division
    display divprint, divleng
    display result, 1
    display newline, newlinelen
    
    display divreminder, divreminderleng
    display result2, 1
    display newline, newlinelen

    mov eax, 1
    mov ebx, 0
    int 80h