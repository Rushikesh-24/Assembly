section .data
    prompt1 db 'Enter first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second number: ', 0
    len2 equ $ - prompt2
    sumMsg db 'Sum is: ', 0
    sumLen equ $ - sumMsg
    newline db 0xa
    
section .bss
    num1 resb 2     ; Buffer for first number
    num2 resb 2     ; Buffer for second number
    sum resb 2      ; Buffer for sum result

section .text
    global _start

_start:
    ; Display first prompt
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, prompt1
    mov edx, len1
    int 80h
    
    ; Read first number
    mov eax, 3      ; sys_read
    mov ebx, 0      ; stdin
    mov ecx, num1
    mov edx, 2      ; Read 2 bytes (1 digit + newline)
    int 80h
    
    ; Display second prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h
    
    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 80h
    
    ; Convert ASCII to numbers and add
    mov al, [num1]      ; Get first number
    sub al, '0'         ; Convert from ASCII
    mov bl, [num2]      ; Get second number
    sub bl, '0'         ; Convert from ASCII
    
    add al, bl          ; Add the numbers
    add al, '0'         ; Convert back to ASCII
    mov [sum], al       ; Store the result
    
    ; Display sum message
    mov eax, 4
    mov ebx, 1
    mov ecx, sumMsg
    mov edx, sumLen
    int 80h
    
    ; Display sum
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 1
    int 80h
    
    ; Display newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Exit program
    mov eax, 1      ; sys_exit
    mov ebx, 0      ; Exit code 0
    int 80h