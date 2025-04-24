section .data
    prompt_msg db "Enter the number of elements (1-9): "
    prompt_len equ $ - prompt_msg
    input_msg db "Enter element "
    input_len equ $ - input_msg
    sum_msg db "Sum of all elements: "
    sum_len equ $ - sum_msg
    colon db ": "
    newline db 10

section .bss
    array resd 10
    count resb 1
    sum resd 1
    buffer resb 16
    num_buffer resb 16

section .text
    global _start

write_string:
    push eax
    push ebx
    mov eax, 4
    mov ebx, 1
    int 80h
    pop ebx
    pop eax
    ret

read_input:
    push ebx
    mov eax, 3
    mov ebx, 0
    int 80h
    pop ebx
    ret

string_to_int:
    push ebx
    push ecx
    push edx
    push edi
    xor eax, eax
    xor edi, edi
    mov ebx, 0
    cmp byte [ecx], '-'
    jne .convert_loop
    mov ebx, 1
    inc ecx
.convert_loop:
    movzx edx, byte [ecx]
    cmp edx, 10
    je .done_convert
    cmp edx, 13
    je .done_convert
    cmp edx, 0
    je .done_convert
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc ecx
    jmp .convert_loop
.done_convert:
    test ebx, ebx
    jz .finish_convert
    neg eax
.finish_convert:
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret

display_number:
    push eax
    push ebx
    push ecx
    push edx
    test eax, eax
    jns .positive
    push eax
    mov ecx, buffer
    mov byte [ecx], '-'
    mov edx, 1
    call write_string
    pop eax
    neg eax
.positive:
    mov ebx, 10
    mov ecx, num_buffer
    add ecx, 15
    mov byte [ecx], 0
    test eax, eax
    jnz .convert_number
    dec ecx
    mov byte [ecx], '0'
    jmp .print_number
.convert_number:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert_number
.print_number:
    mov edx, num_buffer
    add edx, 15
    sub edx, ecx
    call write_string
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

_start:
    mov ecx, prompt_msg
    mov edx, prompt_len
    call write_string
    mov ecx, buffer
    mov edx, 2
    call read_input
    movzx eax, byte [buffer]
    sub eax, '0'
    mov [count], al
    mov dword [sum], 0
    xor esi, esi
.input_loop:
    movzx eax, byte [count]
    cmp esi, eax
    jge .calculate_sum
    mov ecx, input_msg
    mov edx, input_len
    call write_string
    mov eax, esi
    inc eax
    add eax, '0'
    mov [buffer], al
    mov ecx, buffer
    mov edx, 1
    call write_string
    mov ecx, colon
    mov edx, 2
    call write_string
    mov ecx, buffer
    mov edx, 8
    call read_input
    mov ecx, buffer
    call string_to_int
    mov [array + esi*4], eax
    inc esi
    jmp .input_loop
.calculate_sum:
    xor esi, esi
.sum_loop:
    movzx eax, byte [count]
    cmp esi, eax
    jge .display_results
    mov eax, [array + esi*4]
    add [sum], eax
    inc esi
    jmp .sum_loop
.display_results:
    mov ecx, sum_msg
    mov edx, sum_len
    call write_string
    mov eax, [sum]
    mov ecx, eax
    call display_number
    mov ecx, newline
    mov edx, 1
    call write_string
    mov eax, 1
    xor ebx, ebx
    int 80h
