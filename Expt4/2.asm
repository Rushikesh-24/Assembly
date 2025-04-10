section .data
    prompt1 db 'Enter first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second number: ', 0
    len2 equ $ - prompt2
    prompt3 db 'Enter third number: ', 0
    len3 equ $ - prompt3
    largerMsg db 'Larger number is: ', 0
    largerLen equ $ - largerMsg
    equalMsg db 'Numbers are equal', 0
    equalLen equ $ - equalMsg
    newline db 10

section .bss
    num1 resb 2
    num2 resb 2
    num3 resb 2
    larger resb 2

section .text
    global _start

_start:
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
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, len3
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num3
    mov edx, 2
    int 80h

    mov al, [num1]
    sub al, '0'
    
    mov bl, [num2]
    sub bl, '0'
    
    cmp al, bl
    jge check_num3
    mov al, bl
    
check_num3:
    mov bl, [num3]
    sub bl, '0'
    
    cmp al, bl
    jg set_larger
    mov al, bl
    
set_larger:
    add al, '0'
    mov [larger], al

    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    cmp al, bl
    jne print_larger
    mov bl, [num3]
    sub bl, '0'
    cmp al, bl
    jne exit

    mov eax, 4
    mov ebx, 1
    mov ecx, equalMsg
    mov edx, equalLen
    int 80h
    jmp exit

print_larger:
    mov eax, 4
    mov ebx, 1
    mov ecx, largerMsg
    mov edx, largerLen
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, larger
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

exit:
    mov eax, 1
    mov ebx, 0
    int 80h
