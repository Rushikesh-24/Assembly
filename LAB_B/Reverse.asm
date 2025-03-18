section .data
    text db "HELLO, WORLD!", 10  
    textlen equ $ - text          

section .bss
    reversed resb textlen         

section .text
    global _start

_start:
    mov ecx, textlen
    mov esi, text
    mov edi, reversed

copy_loop:
    mov al, [esi]      
    mov [edi], al       
    inc esi
    inc edi
    loop copy_loop

    mov esi, reversed
    lea edi, [reversed + textlen - 2]   

reverse_loop:
    cmp esi, edi
    jge print_reversed

    mov al, [esi]       
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al

    inc esi
    dec edi
    jmp reverse_loop

print_reversed:
    mov eax, 4           
    mov ebx, 1          
    mov ecx, reversed    
    mov edx, textlen     
    int 80h

    mov eax, 1           
    xor ebx, ebx         
    int 80h
