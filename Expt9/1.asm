section .data
    prompt_msg db "Enter the number of elements (1-9): ", 0
    prompt_len equ $ - prompt_msg
    
    input_msg db "Enter element ", 0
    input_len equ $ - input_msg
    
    display_msg db "Array elements: ", 0
    display_len equ $ - display_msg
    
    search_msg db "Enter number to search: ", 0
    search_len equ $ - search_msg
    
    found_msg db "Element found at position: ", 0
    found_len equ $ - found_msg
    
    not_found_msg db "Element not found in the array", 10, 0
    not_found_len equ $ - not_found_msg
    
    space db " "
    newline db 10

section .bss
    array resd 10       ; Reserve space for up to 10 integers (4 bytes each)
    count resb 1        ; Number of elements in the array
    target resd 1       ; Target value to search for
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
    mov edx, 2          ; Read character + newline
    int 80h
    
    ; Convert to integer and store in count
    movzx eax, byte [buffer]
    sub eax, '0'
    mov [count], al
    
    ; Input array elements
    xor esi, esi        ; Initialize counter
    
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
    lea eax, [esi + 1]  ; 1-based index
    add al, '0'
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
    mov edx, 16
    int 80h
    
    ; Clear registers for conversion
    xor eax, eax        ; Will hold final number
    xor ebx, ebx        ; Digit counter
    
str_to_int:
    mov cl, [buffer + ebx]
    
    ; Check for end of input
    cmp cl, 10          ; newline
    je end_conversion
    cmp cl, 0           ; null terminator
    je end_conversion
    
    ; Validate digit
    cmp cl, '0'
    jl end_conversion
    cmp cl, '9'
    jg end_conversion
    
    ; Digit is valid, convert to number
    sub cl, '0'
    
    ; Multiply current result by 10
    imul eax, 10
    
    ; Add new digit
    add al, cl
    
    ; Move to next character
    inc ebx
    jmp str_to_int
    
end_conversion:
    ; Store value in array
    mov [array + esi*4], eax
    
    ; Move to next array element
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
    xor esi, esi        ; Array index
    
display_loop:
    ; Check if we've reached the end
    movzx ecx, byte [count]
    cmp esi, ecx
    jge prompt_search
    
    ; Get current element
    mov eax, [array + esi*4]
    
    ; Int to string conversion
    mov ebx, 10         ; Divisor
    mov ecx, num_buffer
    add ecx, 15         ; Start at end of buffer
    mov byte [ecx], 0   ; Null terminator
    
    ; Handle zero as special case
    test eax, eax
    jnz int_to_str_loop
    
    dec ecx
    mov byte [ecx], '0'
    jmp print_num
    
int_to_str_loop:
    xor edx, edx        ; Clear for division
    div ebx             ; eax / 10
    
    add dl, '0'         ; Convert remainder to ASCII
    dec ecx
    mov [ecx], dl
    
    test eax, eax       ; Check if quotient is 0
    jnz int_to_str_loop
    
print_num:
    ; Calculate string length
    mov edx, num_buffer
    add edx, 15
    sub edx, ecx
    
    ; Print the number
    push esi            ; Save array index
    mov eax, 4
    mov ebx, 1
    int 80h
    pop esi             ; Restore array index
    
    ; Print space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    
    ; Next element
    inc esi
    jmp display_loop
    
prompt_search:
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Prompt for search value
    mov eax, 4
    mov ebx, 1
    mov ecx, search_msg
    mov edx, search_len
    int 80h
    
    ; Read search value
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 16
    int 80h
    
    ; Clear registers for conversion
    xor eax, eax        ; Will hold final number
    xor ebx, ebx        ; Digit counter
    
search_to_int:
    mov cl, [buffer + ebx]
    
    ; Check for end of input
    cmp cl, 10          ; newline
    je end_search_conv
    cmp cl, 0           ; null terminator
    je end_search_conv
    
    ; Validate digit
    cmp cl, '0'
    jl end_search_conv
    cmp cl, '9'
    jg end_search_conv
    
    ; Digit is valid, convert to number
    sub cl, '0'
    
    ; Multiply current result by 10
    imul eax, 10
    
    ; Add new digit
    add al, cl
    
    ; Move to next character
    inc ebx
    jmp search_to_int
    
end_search_conv:
    ; Store search target
    mov [target], eax
    
    ; Begin linear search
    xor esi, esi        ; Array index (0-based)
    
search_loop:
    ; Check if we've reached the end
    movzx ecx, byte [count]
    cmp esi, ecx
    jge not_found
    
    ; Compare current element with target
    mov eax, [array + esi*4]
    cmp eax, [target]
    je found
    
    ; Move to next element
    inc esi
    jmp search_loop
    
found:
    ; Print found message
    mov eax, 4
    mov ebx, 1
    mov ecx, found_msg
    mov edx, found_len
    int 80h
    
    ; Convert position to 1-based for display
    lea eax, [esi + 1]  ; 1-based position
    
    ; Int to string conversion
    mov ebx, 10         ; Divisor
    mov ecx, num_buffer
    add ecx, 15         ; Start at end of buffer
    mov byte [ecx], 0   ; Null terminator
    
    ; Handle zero as special case
    test eax, eax
    jnz found_to_str_loop
    
    dec ecx
    mov byte [ecx], '0'
    jmp print_found_pos
    
found_to_str_loop:
    xor edx, edx        ; Clear for division
    div ebx             ; eax / 10
    
    add dl, '0'         ; Convert remainder to ASCII
    dec ecx
    mov [ecx], dl
    
    test eax, eax       ; Check if quotient is 0
    jnz found_to_str_loop
    
print_found_pos:
    ; Calculate string length
    mov edx, num_buffer
    add edx, 15
    sub edx, ecx
    
    ; Print the position
    mov eax, 4
    mov ebx, 1
    int 80h
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    jmp exit_program
    
not_found:
    ; Print not found message
    mov eax, 4
    mov ebx, 1
    mov ecx, not_found_msg
    mov edx, not_found_len
    int 80h
    
exit_program:
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 80h