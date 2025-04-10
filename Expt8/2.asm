section .data
    prompt_msg db "Enter the number of elements (1-9): ", 0
    prompt_len equ $ - prompt_msg

    input_msg db "Enter element ", 0
    input_len equ $ - input_msg

    pos_msg db "Number of positive elements: ", 0
    pos_len equ $ - pos_msg

    neg_msg db "Number of negative elements: ", 0
    neg_len equ $ - neg_msg

    zero_msg db "Number of zero elements: ", 0
    zero_len equ $ - zero_msg

    space db " ", 0
    colon db ": ", 0
    newline db 10, 0

section .bss
    array resd 10          ; Reserve space for up to 10 integers (4 bytes each)
    count resb 1           ; Number of elements in the array
    pos_count resb 1       ; Count of positive numbers
    neg_count resb 1       ; Count of negative numbers
    zero_count resb 1      ; Count of zeros
    buffer resb 16         ; Buffer for input
    num_buffer resb 16     ; Buffer for number conversion

section .text
    global _start

write_string:
    push eax
    push ebx
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    int 80h
    pop ebx
    pop eax
    ret

read_input:
    push ebx
    mov eax, 3             ; sys_read
    mov ebx, 0             ; stdin
    int 80h
    pop ebx
    ret

string_to_int:
    push ebx
    push ecx
    push edx
    push edi
    xor eax, eax           ; Clear result
    xor edi, edi           ; Clear negative flag
    mov ebx, 0             ; Clear index

    ; Check for negative sign
    cmp byte [ecx], '-'
    jne .convert_loop
    mov ebx, 1             ; Set negative flag
    inc ecx                ; Skip minus sign

.convert_loop:
    movzx edx, byte [ecx]
    cmp edx, 10            ; Newline
    je .done_convert
    cmp edx, 13            ; Carriage return
    je .done_convert
    cmp edx, 0             ; Null terminator
    je .done_convert
    sub edx, '0'           ; Convert to digit
    imul eax, eax, 10      ; Multiply by 10
    add eax, edx           ; Add new digit
    inc ecx
    jmp .convert_loop

.done_convert:
    test ebx, ebx
    jz .finish_convert
    neg eax                ; Make negative if needed

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

    mov ebx, 10
    mov ecx, num_buffer
    add ecx, 15            ; Start from end of buffer
    mov byte [ecx], 0      ; Null terminator

    test eax, eax
    jnz .convert_number
    dec ecx
    mov byte [ecx], '0'
    jmp .print_number

.convert_number:
    xor edx, edx
    div ebx
    add dl, '0'            ; Convert remainder to ASCII
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert_number

.print_number:
    mov edx, num_buffer + 15
    sub edx, ecx
    call write_string

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

_start:
    ; Display prompt for number of elements
    mov ecx, prompt_msg
    mov edx, prompt_len
    call write_string

    ; Read number of elements
    mov ecx, buffer
    mov edx, 2             ; Read character + newline
    call read_input

    ; Convert to integer and store in count
    movzx eax, byte [buffer]
    sub eax, '0'
    mov [count], al

    ; Initialize counters
    mov byte [pos_count], 0
    mov byte [neg_count], 0
    mov byte [zero_count], 0

    ; Input array elements
    xor esi, esi           ; Initialize counter

.input_loop:
    movzx eax, byte [count]
    cmp esi, eax
    jge .count_elements

    ; Print "Enter element X: "
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

    ; Read input number
    mov ecx, buffer
    mov edx, 8
    call read_input

    ; Convert string to integer
    mov ecx, buffer
    call string_to_int

    ; Store in array
    mov [array + esi*4], eax
    inc esi
    jmp .input_loop

.count_elements:
    xor esi, esi

.count_loop:
    movzx eax, byte [count]
    cmp esi, eax
    jge .display_results

    mov eax, [array + esi*4]
    test eax, eax
    jz .is_zero
    jg .is_positive

    inc byte [neg_count]
    jmp .next_count

.is_zero:
    inc byte [zero_count]
    jmp .next_count

.is_positive:
    inc byte [pos_count]

.next_count:
    inc esi
    jmp .count_loop

.display_results:
    ; Display number of positive elements
    mov ecx, pos_msg
    mov edx, pos_len
    call write_string
    movzx eax, byte [pos_count]
    mov ecx, eax
    call display_number
    mov ecx, newline
    mov edx, 1
    call write_string

    ; Display number of negative elements
    mov ecx, neg_msg
    mov edx, neg_len
    call write_string
    movzx eax, byte [neg_count]
    mov ecx, eax
    call display_number
    mov ecx, newline
    mov edx, 1
    call write_string

    ; Display number of zero elements
    mov ecx, zero_msg
    mov edx, zero_len
    call write_string
    movzx eax, byte [zero_count]
    mov ecx, eax
    call display_number
    mov ecx, newline
    mov edx, 1
    call write_string

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 80h
