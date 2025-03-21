section .bss
    num resb 2
    result resw 1
section .data
    msg db 'The factorial is: ', 0
    prompt db 'Enter a number: ', 0
    newline db 0xA, 0
section .text
    global _start
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 15
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 2
    int 0x80
    movzx ecx, byte [num]
    sub ecx, '0'
    call calculate_factorial
    call print_result
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    call exit_program
calculate_factorial:
    ; Initialize result to 1
    mov ax, 1
factorial_loop:
    cmp ecx, 1
    jle end_factorial
    mul cx
    dec ecx
    jmp factorial_loop
end_factorial:
    mov [result], ax
    ret
print_result:
    ; Output the result message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 17
    int 0x80
    ; Convert result to string and output
    mov eax, [result]
    add eax, '0'
    mov [result], ax
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 2
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    ret
exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    ret
