section .data
    msg db "Enter no of elements: "
    msglen equ $-msg
    msg2 db "Enter the elements : "
    msg2len equ $-msg2
    msg3 db "The sorted array is: "
    msg3len equ $-msg3
    msg4 db "Pass "
    msg4len equ $-msg4
    msg5 db ": "
    msg5len equ $-msg5
    newline db 10
    space db ' '
 
%macro write 2
    mov eax,4
    mov ebx,1
    mov ecx,%1
    mov edx,%2
    int 80h
%endmacro
    
%macro read 2
    mov eax,3
    mov ebx,0
    mov ecx,%1
    mov edx,%2
    int 80h
    mov eax,3
    mov ebx,0
    mov ecx,trash
    mov edx,1
    int 80h
%endmacro
    
input:
    write msg, msglen
    read num, 1
    mov al, [num]
    sub al, '0'
    mov [size], al
    
    write msg2, msg2len
    mov byte[i], 0
loop1:
    movzx esi, byte[i]
    movzx eax, byte[size]
    cmp esi, eax
    jge end1
    lea esi, [arr + esi]
    read esi, 1
    inc byte[i]
    jmp loop1    
end1:
    ret
 
display:
    mov byte[i], 0
loop2:
    movzx esi, byte[i]
    movzx eax, byte[size]
    cmp esi, eax
    jge end2
    lea esi, [arr + esi]
    write esi, 1
    write space, 1
    inc byte[i]
    jmp loop2    
end2:
    write newline, 1    
    ret
insertion_sort:
    mov byte[j], '1'
    mov eax, 1
loop3:
    movzx ebx, byte[size]
    cmp al, bl
    jge end3
    
    pushad
    write msg4, msg4len
    mov dl, [j]
    mov [temp], dl
    write temp, 1
    write msg5, msg5len
    call display
    popad
    
    mov dl, [arr + eax]
    mov ecx, eax
    dec ecx
loop4:
    cmp cl, 0
    jl update
    mov dh, [arr + ecx]
    cmp dh, dl
    jle update
    mov [arr + ecx + 1], dh
    dec ecx
    jmp loop4
update:
    mov [arr + ecx + 1], dl
    inc eax
    inc byte[j]
    jmp loop3
end3:
    write msg4, msg4len
    mov dl, [j]
    mov [temp], dl
    write temp, 1
    write msg5, msg5len
    call display
    ret
 
section .bss
    arr resb 10
    i resb 1
    j resb 1
    temp resb 1
    trash resb 1
    num resb 1
    size resb 1
 
section .text
global _start
_start:
    call input
    write newline, 1
    call insertion_sort
    write newline, 1
    write msg3, msg3len
    call display
    mov eax, 1
    mov ebx, 0
    int 80h
