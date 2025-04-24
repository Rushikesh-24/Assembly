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

%macro readstdin 2
    mov eax, 3
    mov ebx, 0
    mov ecx, %1
    mov edx, %2
    int 0x80
%endmacro

section .data
    index dd 0
    prompt_size db "Enter the number of elements: ", 0
    prompt_element db "Enter element ", 0
    colon db ": ", 0
    prompt_target db "Enter the target number to search: ", 0
    msg_found db "Element found at index: ", 0
    msg_not_found db "Element not found", 0
    msg_iteration db "Iteration ", 0
    msg_left db " Left: ", 0
    msg_right db ", Right: ", 0
    msg_mid db ", Mid: ", 0
    msg_value db ", Value: ", 0
    newline db 10, 0

section .bss
    array resd 100
    size resd 1
    target resd 1
    buffer resb 10
    iteration_count resd 1
    left resd 1
    right resd 1

section .text
    global _start

_start:
    print prompt_size, 30
    call readint
    mov [size], eax
    mov ecx, [size]
    mov edi, array

.input_loop:
    push ecx
    push edi
    print prompt_element, 14
    print colon, 2
    call readint
    pop edi
    mov [edi], eax
    add edi, 4
    pop ecx
    loop .input_loop

    print prompt_target, 34
    call readint
    mov [target], eax

    mov dword [left], 0
    mov eax, [size]
    dec eax
    mov [right], eax
    mov dword [iteration_count], 1

.search_loop:
    mov eax, [left]
    cmp eax, [right]
    jg .not_found

    mov edx, eax
    add edx, [right]
    shr edx, 1
    mov [index], edx

    print msg_iteration, 10
    mov eax, [iteration_count]
    call printint
    print msg_left, 8
    mov eax, [left]
    call printint
    print msg_right, 9
    mov eax, [right]
    call printint
    print msg_mid, 7
    mov eax, [index]
    call printint
    print msg_value, 9
    mov edx, [index]
    mov eax, [array + edx * 4]
    call printint
    print newline, 1

    mov edx, [index]
    mov esi, [array + edx * 4]
    cmp [target], esi
    je .found
    jl .search_left
    jg .search_right

.search_left:
    mov eax, [index]
    dec eax
    mov [right], eax
    inc dword [iteration_count]
    jmp .search_loop

.search_right:
    mov eax, [index]
    inc eax
    mov [left], eax
    inc dword [iteration_count]
    jmp .search_loop

.found:
    print msg_found, 24
    mov eax, [index]
    call printint
    print newline, 1
    jmp .exit

.not_found:
    print msg_not_found, 17
    print newline, 1

.exit:
    exit

readint:
    push ebx
    push ecx
    push edx
    push esi
    readstdin buffer, 10
    mov ecx, eax
    mov esi, buffer
    xor eax, eax

.convert_loop:
    movzx edx, byte [esi]
    inc esi
    cmp edx, 0
    je .done
    cmp edx, 10
    je .done
    cmp edx, '0'
    jl .invalid
    cmp edx, '9'
    jg .invalid
    sub edx, '0'
    imul eax, 10
    add eax, edx
    jmp .convert_loop

.done:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

.invalid:
    xor eax, eax
    jmp .done

printint:
    push eax
    push ecx
    push edx
    push edi
    mov ecx, 10
    mov edi, buffer + 9
    mov byte [edi], 0

.convert_loop:
    xor edx, edx
    div ecx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .convert_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, buffer + 9
    sub edx, edi
    int 0x80
    pop edi
    pop edx
    pop ecx
    pop eax
    ret