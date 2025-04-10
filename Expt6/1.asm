section .data
    prompt db 'Enter n: '
    prompt_len equ $ - prompt
    msg db 'Series: '
    msg_len equ $ - msg
    space db ' '
    newline db 10

section .bss
    n resb 2
    num1 resb 2
    num2 resb 2
    result resb 2

section .text
    global _start
    
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, n
    mov edx, 2
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 80h
    ; Compare if n is zero
    movzx ecx, byte [n]
    cmp ecx, '0'
    je exit_program
    movzx ecx, byte [n]
    sub ecx, '0'
    push ecx
    call fibonacci
exit_program:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    mov eax, 1
    xor ebx, ebx
    int 80h
fibonacci:
    push ebp
    mov ebp, esp
    
    mov byte [num1], '0'
    mov byte [num2], '1'
    mov ecx, [ebp + 8]
fib_loop:
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, num1
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    push num1
    push num2
    call add
    mov al, [num2]
    mov [num1], al
    mov al, [result]
    mov [num2], al   
    pop ecx
    dec ecx
    jnz fib_loop    
    mov esp, ebp
    pop ebp
    ret 4
add:
    push ebp
    mov ebp, esp   
    mov eax, [ebp + 12]
    movzx eax, byte [eax]
    sub al, '0'  
    mov ebx, [ebp + 8]
    movzx ebx, byte [ebx]
    sub bl, '0'    
    add eax, ebx
    add al, '0'
    mov [result], al    
    mov esp, ebp
    pop ebp
    ret 8
