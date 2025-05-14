section .data
    prompt1 db 'Enter the first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter the second number: ', 0
    len2 equ $ - prompt2
    prompt3 db 'Entered Number: ', 0
    len3 equ $ - prompt3
    newline db 0xa

section .bss
    num1 resb 2
    num2 resb 2

section .text
    global _start

_start:
    ; Display prompt1 and input num1
    mov ecx, prompt1
    mov edx, len1
    call display
    mov ecx, num1
    mov edx, 2
    call input

    ; Display prompt2 and input num2
    mov ecx, prompt2
    mov edx, len2
    call display
    mov ecx, num2
    mov edx, 2
    call input

    ; Display prompt3 and num1
    mov ecx, prompt3
    mov edx, len3
    call display
    mov ecx, num1
    mov edx, 2
    call display

    ; Display prompt3 and num2
    mov ecx, prompt3
    mov edx, len3
    call display
    mov ecx, num2
    mov edx, 2
    call display

    ; Exit
    mov eax, 1
    mov ebx, 0
    int 80h

;----------------------------------------
; display: prints [ecx] of length [edx]
;----------------------------------------
display:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret

;----------------------------------------
; input: reads [edx] bytes into [ecx]
;----------------------------------------
input:
    mov eax, 3
    mov ebx, 0
    int 80h
    ret
