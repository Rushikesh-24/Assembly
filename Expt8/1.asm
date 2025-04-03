section .data
prompt_msg db "Enter the number of elements (1-9): "
prompt_len equ $ - prompt_msg

input_msg db "Enter element "
input_len equ $ - input_msg

display_msg db "Array elements: "
display_len equ $ - display_msg

space db " "
newline db 10

section .bss
array resd 10       ; Reserve space for up to 10 integers (4 bytes each)
count resb 1        ; Number of elements in the array
buffer resb 16      ; Buffer for input
num_buffer resb 16  ; Buffer for number conversion

section .text
global _start

_start:
    ; Display prompt for number of elements
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 80h

    ; Read number of elements
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2       ; Read character + newline
    int 80h

    ; Convert to integer and store in count
    movzx eax, byte [buffer]
    sub eax, '0'
    mov [count], al

    ; Input array elements
    xor esi, esi     ; Initialize counter

input_loop:
    ; Check if we've reached the end
    movzx eax, byte [count]
    cmp esi, eax
    jge display_elements

    ; Print "Enter element X: "
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_len
    int 80h

    ; Display element number (1-based)
    mov eax, esi
    inc eax
    add eax, '0'
    mov [buffer], al
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h

    ; Print colon
    mov byte [buffer], ':'
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h

    ; Print space
    mov byte [buffer], ' '
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h

    ; Read input number
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 8
    int 80h

    ; Simple string to int conversion
    xor eax, eax
    xor ecx, ecx

convert_loop:
    movzx edx, byte [buffer + ecx]
    cmp edx, 10      ; Newline
    je done_convert
    cmp edx, 13      ; Carriage return
    je done_convert
    sub edx, '0'     ; Convert to digit
    imul eax, eax, 10 ; Multiply by 10
    add eax, edx     ; Add new digit
    inc ecx
    jmp convert_loop

done_convert:
    ; Store in array
    mov [array + esi*4], eax
    inc esi
    jmp input_loop

display_elements:
    ; Display header
    mov eax, 4
    mov ebx, 1
    mov ecx, display_msg
    mov edx, display_len
    int 80h

    ; Display array elements
    xor esi, esi

display_loop:
    ; Check if we've displayed all elements
    movzx eax, byte [count]
    cmp esi, eax
    jge exit_program

    ; Get current element
    mov eax, [array + esi*4]

    ; Convert int to string
    mov ebx, 10
    mov ecx, num_buffer
    add ecx, 15      ; Start from end of buffer
    mov byte [ecx], 0 ; Null terminator

    ; Special case for zero
    test eax, eax
    jnz convert_number
    dec ecx
    mov byte [ecx], '0'
    jmp print_number

convert_number:
to_string_loop:
    xor edx, edx
    div ebx
    add dl, '0'      ; Convert remainder to ASCII
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz to_string_loop

print_number:
    ; Calculate string length
    mov edx, num_buffer
    add edx, 15
    sub edx, ecx

    ; Print number
    mov eax, 4
    mov ebx, 1
    mov ecx, ecx
    int 80h

    ; Print space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h

    inc esi
    jmp display_loop

exit_program:
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 80h
