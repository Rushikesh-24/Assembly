section .data
    prompt_msg db "Enter the number of elements (1-9): ", 0
    prompt_len equ $ - prompt_msg

    input_msg db "Enter element ", 0
    input_len equ $ - input_msg

    even_msg db "Number of even elements: ", 0
    even_len equ $ - even_msg

    odd_msg db "Number of odd elements: ", 0
    odd_len equ $ - odd_msg

    colon db ": ", 0
    newline db 10, 0

section .bss
    array resd 10         ; Reserve space for up to 10 integers (4 bytes each)
    count resb 1          ; Number of elements in the array
    even_count resb 1     ; Count of even numbers
    odd_count resb 1      ; Count of odd numbers
    buffer resb 16        ; Buffer for input
    num_buffer resb 16    ; Buffer for number conversion

section .text
    global _start

write_string:
    push eax
    push ebx
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    int 80h
    pop ebx
    pop eax
    ret

read_input:
    push ebx
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    int 80h
    pop ebx
    ret

string_to_int:
    push ebx
    push ecx
    push edx
    push edi
    xor eax, eax
    xor edi, edi          ; Clear result and negative flag
    mov ebx, 0            ; Clear index

    ; Check for negative sign
    cmp byte [ecx], '-'
    jne .convert_loop
    mov ebx, 1            ; Set negative flag
    inc ecx               ; Skip minus sign

.convert_loop:
    movzx edx, byte [ecx]
    cmp edx, 10           ; Newline
    je .done_convert
    cmp edx, 13           ; Carriage return
    je .done_convert
    cmp edx, 0            ; Null terminator
    je .done_convert
    sub edx, '0'          ; Convert to digit
    imul eax, eax, 10     ; Multiply by 10
    add eax, edx          ; Add new digit
    inc ecx
    jmp .convert_loop

.done_convert:
    test ebx, ebx
    jz .finish_convert
    neg eax               ; Make negative if needed

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
    add ecx, 15           ; Start from end of buffer
    mov byte [ecx], 0     ; Null terminator

    test eax, eax
    jnz .convert_number
    dec ecx
    mov byte [ecx], '0'
    jmp .print_number

.convert_number:
    xor edx, edx
    div ebx
    add dl, '0'           ; Convert remainder to ASCII
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
    ; Display prompt for number of elements
    mov ecx, prompt_msg
    mov edx, prompt_len
    call write_string

    ; Read number of elements
    mov ecx, buffer
    mov edx, 2            ; Read character + newline
    call read_input

    ; Convert to integer and store in count
    movzx eax, byte [buffer]
    sub eax, '0'
    mov [count], al

    ; Initialize counters
    mov byte [even_count], 0
    mov byte [odd_count], 0

    ; Input array elements
    xor esi, esi          ; Initialize counter

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

    ; Print colon and space
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
    test eax, 1           ; Check if odd (last bit is 1)
    jz .is_even

    ; Is odd
    inc byte [odd_count]
    jmp .next_count

.is_even:
    inc byte [even_count]

.next_count:
    inc esi
    jmp .count_loop

.display_results:
    ; Display number of even elements
    mov ecx, even_msg
    mov edx, even_len
    call write_string

    movzx eax, byte [even_count]
    mov ecx, eax
    call display_number

    ; Print newline
    mov ecx, newline
    mov edx, 1
    call write_string

    ; Display number of odd elements
    mov ecx, odd_msg
    mov edx, odd_len
    call write_string

    movzx eax, byte [odd_count]
    mov ecx, eax
    call display_number

    ; Print newline
    mov ecx, newline
    mov edx, 1
    call write_string

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 80h
