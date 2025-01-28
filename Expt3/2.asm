section .data
    prompt1 db 'Enter first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second number: ', 0
    len2 equ $ - prompt2
    
    addMsg db 'Addition: ', 0
    addLen equ $ - addMsg
    subMsg db 'Subtraction: ', 0
    subLen equ $ - subMsg
    mulMsg db 'Multiplication: ', 0
    mulLen equ $ - mulMsg
    divMsg db 'Division - Quotient: ', 0
    divLen equ $ - divMsg
    remMsg db 'Division - Remainder: ', 0
    remLen equ $ - remMsg
    
    newline db 0xa

section .bss
    num1 resb 2         ; First number
    num2 resb 2         ; Second number
    result resb 2       ; Result buffer

section .text
    global _start

_start:
    ; Get first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, len1
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2
    int 80h
    
    ; Get second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 80h
    
    ; Convert ASCII to numbers
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    
    ; Addition
    mov eax, 4
    mov ebx, 1
    mov ecx, addMsg
    mov edx, addLen
    int 80h
    
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    add al, bl
    add al, '0'
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Subtraction
    mov eax, 4
    mov ebx, 1
    mov ecx, subMsg
    mov edx, subLen
    int 80h
    
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    sub al, bl
    add al, '0'
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Multiplication
    mov eax, 4
    mov ebx, 1
    mov ecx, mulMsg
    mov edx, mulLen
    int 80h
    
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    mul bl              ; Multiply AL by BL
    add al, '0'
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Division (Quotient)
    mov eax, 4
    mov ebx, 1
    mov ecx, divMsg
    mov edx, divLen
    int 80h
    
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    mov ah, 0           ; Clear AH for division
    div bl              ; Divide AL by BL, quotient in AL, remainder in AH
    add al, '0'
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Division (Remainder)
    mov eax, 4
    mov ebx, 1
    mov ecx, remMsg
    mov edx, remLen
    int 80h
    
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    mov ah, 0
    div bl              ; AH now contains remainder
    mov al, ah          ; Move remainder to AL
    add al, '0'
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 80h