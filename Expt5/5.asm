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
    call write_prompt
    call read_input
    call write_msg
    
    movzx ecx, byte [n]
    sub ecx, '0'
    cmp ecx, 0
    je exit_newline
    push ecx
    call fibonacci
    
    call write_newline
    call exit_program

exit_newline:
    call write_newline
    call exit_program

write_prompt:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 80h
    ret

read_input:
    mov eax, 3
    mov ebx, 0
    mov ecx, n
    mov edx, 2
    int 80h
    ret

write_msg:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 80h
    ret

write_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    ret

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
    call add_nums

    mov al, [num2]
    mov [num1], al
    mov al, [result]
    mov [num2], al
    
    pop ecx
    dec ecx
    jz end_fib_loop
    jmp fib_loop

end_fib_loop:
    mov esp, ebp
    pop ebp
    ret 4

add_nums:
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

exit_program:
    mov eax, 1
    mov ebx, 0
    int 80h