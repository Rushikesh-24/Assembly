section .data
    msg1 db 'Original array: ', 0
    len1 equ $ - msg1
    msg2 db 'Ascending order: ', 0
    len2 equ $ - msg2
    msg3 db 'Descending order: ', 0
    len3 equ $ - msg3
    newline db 0xa
    space db ' '
    array db 'a','b','b','a'    
    array_len equ $ - array

section .bss
    num resb 2        

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 80h
    
    call print_array
    
    call sort_ascending
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 80h
    
    call print_array
    
    mov esi, array
    mov edi, array_len
    call sort_descending
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 80h
    
    call print_array
    
    mov eax, 1
    mov ebx, 0
    int 80h

sort_ascending:
    mov ecx, array_len     
    dec ecx                ; Length - 1
    mov esi, 0            ; Current position

outer_loop_asc:
    mov ebx, esi          ; Index of minimum element
    mov edi, esi          ; Inner loop counter
    inc edi
    
inner_loop_asc:
    ; Compare current minimum with array[j]
    mov al, [array + ebx]
    cmp al, [array + edi]
    jle skip_update_min_asc
    mov ebx, edi          ; Update index of minimum

skip_update_min_asc:
    inc edi
    cmp edi, array_len
    jl inner_loop_asc
    
    ; Swap elements if needed
    cmp ebx, esi
    je no_swap_asc
    
    ; Perform swap
    mov al, [array + esi]
    mov dl, [array + ebx]
    mov [array + esi], dl
    mov [array + ebx], al
    
no_swap_asc:
    inc esi
    loop outer_loop_asc
    ret

; Function to sort array in descending order
sort_descending:
    mov ecx, array_len     ; Outer loop counter
    dec ecx                ; Length - 1
    mov esi, 0            ; Current position

outer_loop_desc:
    mov ebx, esi          ; Index of maximum element
    mov edi, esi          ; Inner loop counter
    inc edi
    
inner_loop_desc:
    ; Compare current maximum with array[j]
    mov al, [array + ebx]
    cmp al, [array + edi]
    jge skip_update_max_desc
    mov ebx, edi          ; Update index of maximum

skip_update_max_desc:
    inc edi
    cmp edi, array_len
    jl inner_loop_desc
    
    ; Swap elements if needed
    cmp ebx, esi
    je no_swap_desc
    
    ; Perform swap
    mov al, [array + esi]
    mov dl, [array + ebx]
    mov [array + esi], dl
    mov [array + ebx], al
    
no_swap_desc:
    inc esi
    loop outer_loop_desc
    ret

; Function to print array
print_array:
    mov ecx, 0            ; Array index

print_loop:
    ; Convert number to ASCII
    mov al, [array + ecx]
    ; add al, '0'
    mov [num], al
    
    ; Print number
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    
    ; Print space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    
    pop ecx
    inc ecx
    cmp ecx, array_len
    jl print_loop
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    ret 
