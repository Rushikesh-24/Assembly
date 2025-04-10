section .bss
    num_digits resb 1
    number1 resb 10
    number2 resb 10
    result resb 11
section .data
    prompt1 db "Enter the number of digits: ", 0
    prompt2 db "Enter the first number: ", 0
    prompt3 db "Enter the second number: ", 0
    newline db 10, 0
section .text
    global _start
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, 28
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, num_digits
    mov edx, 2
    int 80h
    sub byte [num_digits], '0'
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 24
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, number1
    mov edx, 10
    int 80h
    mov byte [ecx + eax - 1], 0
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, 25
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, number2
    mov edx, 10
    int 80h
    mov byte [ecx + eax - 1], 0
    xor eax, eax
    xor ebx, ebx
    mov ecx, num_digits
    mov esi, number1
convert1:
    mov bl, [esi]
    cmp bl, 0
    je end_convert1
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    loop convert1
end_convert1:
    mov ebx, eax
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
    add eax, ebx
    mov esi, result + 10
    mov byte [esi], 0
    dec esi
convert_result:
    xor edx, edx
    mov ecx, 10
    div ecx
    add dl, '0'
    mov [esi], dl
    dec esi
    test eax, eax
    jnz convert_result
    inc esi
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, result + 10
    sub edx, esi
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    mov eax, 1
    xor ebx, ebx
    int 80h
