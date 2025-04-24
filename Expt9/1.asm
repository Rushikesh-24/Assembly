%macro print 2
    push eax
    push ebx
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80
    pop ebx
    pop eax
%endmacro

%macro exit 0
    mov eax, 1
    xor ebx, ebx
    int 0x80
%endmacro

%macro read_stdin 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    prompt_size db "Enter the number of elements: ", 0
    prompt_element db "Enter element: ", 0
    prompt_target db "Enter the target number to search: ", 0
    msg_found db "Element found at index: ", 0
    msg_not_found db "Element not found", 0
    msg_iteration db "Iteration ", 0
    msg_checking db ", Checking index: ", 0
    msg_value db ", Value: ", 0
    newline db 10, 0

section .bss
    array resd 100
    size resd 1
    target resd 1
    buffer resb 10
    current resd 1

section .text
    global _start

_start:
    print prompt_size, 30
    call read_int
    mov [size], eax

    xor ebx, ebx
input_loop:
    cmp ebx, [size]
    jge input_done
    print prompt_element, 15
    call read_int
    mov [array + ebx*4], eax
    inc ebx
    jmp input_loop
input_done:

    print prompt_target, 34
    call read_int
    mov [target], eax

    xor ebx, ebx
search_loop:
    cmp ebx, [size]
    jge not_found

    print msg_iteration, 10
    mov eax, ebx
    inc eax
    call print_int
    ; Print iteration info
    print msg_iteration, 10
    mov eax, ebx
    inc eax
    call print_int
    print msg_checking, 18
    mov eax, ebx
    call print_int
    print msg_value, 9
    mov eax, [array + ebx*4]
    mov [current], eax
    call print_int
    print newline, 1

    ; Compare current element with target
    mov eax, [current]
    cmp eax, [target]
    je found
    inc ebx
    jmp search_loop

found:
    print msg_found, 24
    mov eax, ebx
    call print_int
    print newline, 1
    jmp exit_program

not_found:
    print msg_not_found, 17
    print newline, 1

exit_program:
    exit

read_int:
    push ebx
    push ecx
    push edx
    push esi
    read_stdin buffer, 10
    dec eax
    mov ecx, eax
    mov esi, buffer
    xor eax, eax
convert_loop:
    test ecx, ecx
    jz convert_done
    movzx edx, byte [esi]
    inc esi
    cmp dl, 10
    je convert_done
    sub dl, '0'
    cmp dl, 9
    ja convert_done
    imul eax, 10
    add eax, edx
    dec ecx
    jmp convert_loop
convert_done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

print_int:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    test eax, eax
    jnz non_zero
    mov byte [buffer], '0'
    mov byte [buffer+1], 0
    print buffer, 1
    jmp print_int_done
non_zero:
    mov ecx, 10
    mov edi, buffer
    add edi, 9
    mov byte [edi], 0
    mov esi, edi
digit_loop:
    dec edi
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    test eax, eax
    jnz digit_loop
    mov ecx, edi
    mov edx, esi
    sub edx, edi
    mov eax, 4
    mov ebx, 1
    int 0x80
print_int_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
