section .bss
    num_digits resb 1      ; Reserve 1 byte for number of digits
    number1 resb 10        ; Reserve 10 bytes for first number input
    number2 resb 10        ; Reserve 10 bytes for second number input
    result resb 11         ; Reserve 11 bytes for result (max 10 digits + null)

section .data
    prompt1 db "Enter the number of digits: ", 0
    prompt2 db "Enter the first number: ", 0
    prompt3 db "Enter the second number: ", 0
    newline db 10, 0

section .text
    global _start

_start:
    ; Print prompt1
    mov eax, 4            ; sys_write
    mov ebx, 1            ; stdout
    mov ecx, prompt1      ; message
    mov edx, 28           ; message length
    int 80h

    ; Read number of digits
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    mov ecx, num_digits   ; buffer
    mov edx, 2            ; read 2 bytes (digit + newline)
    int 80h

    ; Convert ASCII digit to integer
    sub byte [num_digits], '0'

    ; Print prompt2
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 24
    int 80h

    ; Read first number
    mov eax, 3
    mov ebx, 0
    mov ecx, number1
    mov edx, 10           ; read up to 10 bytes
    int 80h

    ; Null-terminate first number string
    mov byte [ecx + eax - 1], 0

    ; Print prompt3
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, 25
    int 80h

    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, number2
    mov edx, 10
    int 80h

    ; Null-terminate second number string
    mov byte [ecx + eax - 1], 0

    ; Convert first number string to integer (EAX)
    xor eax, eax          ; clear eax (accumulator)
    xor ebx, ebx
    mov ecx, num_digits   ; number of digits
    mov esi, number1      ; pointer to first number string
convert1:
    mov bl, [esi]         ; get next character
    cmp bl, 0             ; end of string?
    je end_convert1
    sub bl, '0'           ; convert ASCII to integer
    imul eax, eax, 10     ; multiply accumulator by 10
    add eax, ebx          ; add digit
    inc esi               ; next character
    loop convert1
end_convert1:
    mov ebx, eax          ; store first number in ebx

    ; Convert second number string to integer (EAX)
    xor eax, eax
    xor edx, edx
    mov ecx, num_digits
    mov esi, number2
convert2:
    mov dl, [esi]
    cmp dl, 0
    je end_convert2
    sub dl, '0'
    imul eax, eax, 10
    add eax, edx
    inc esi
    loop convert2
end_convert2:

    ; Add the two numbers (EAX = number2, EBX = number1)
    add eax, ebx

    ; Convert result integer to string (stored backwards)
    mov esi, result + 10  ; point to end of result buffer
    mov byte [esi], 0     ; null-terminate
    dec esi
convert_result:
    xor edx, edx
    mov ecx, 10
    div ecx               ; divide eax by 10, remainder in edx
    add dl, '0'           ; convert to ASCII
    mov [esi], dl         ; store digit
    dec esi
    test eax, eax         ; more digits?
    jnz convert_result
    inc esi               ; point to first digit

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, result + 10
    sub edx, esi          ; length of result string
    int 80h

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
