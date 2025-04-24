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
array resd 10       
count resb 1     
buffer resb 16     
num_buffer resb 16  

section .text
global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2       
    int 80h

    movzx eax, byte [buffer]
    sub eax, '0'
    mov [count], al

    xor esi, esi   

input_loop:
    movzx eax, byte [count]
    cmp esi, eax
    jge display_elements

    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg
    mov edx, input_len
    int 80h

    mov eax, esi
    inc eax
    add eax, '0'
    mov [buffer], al
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h

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

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 8
    int 80h

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
    mov [array + esi*4], eax
    inc esi
    jmp input_loop

display_elements:
    mov eax, 4
    mov ebx, 1
    mov ecx, display_msg
    mov edx, display_len
    int 80h

    xor esi, esi

display_loop:

    movzx eax, byte [count]
    cmp esi, eax
    jge exit_program

    mov eax, [array + esi*4]

    mov ebx, 10
    mov ecx, num_buffer
    add ecx, 15  
    mov byte [ecx], 0 

    test eax, eax
    jnz convert_number
    dec ecx
    mov byte [ecx], '0'
    jmp print_number

convert_number:
to_string_loop:
    xor edx, edx
    div ebx
    add dl, '0'     
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz to_string_loop

print_number:
    mov edx, num_buffer
    add edx, 15
    sub edx, ecx

    mov eax, 4
    mov ebx, 1
    mov ecx, ecx
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h

    inc esi
    jmp display_loop

exit_program:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    mov eax, 1
    xor ebx, ebx
    int 80h
