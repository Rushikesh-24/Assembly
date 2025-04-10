section .data
    msg1 db 'Original array: ', 0
    len1 equ $ - msg1
    msg2 db 'Sorted array: ', 0
    len2 equ $ - msg2
    newline db 0xa
    space db ' '
    array db 5, 2, 8, 1, 9    
    array_len equ $ - array

section .bss
    num resb 2
    temp_array resb array_len  ; Temporary array for merging

section .text
    global _start

_start:
    ; Print original array
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 80h
    
    call print_array
    
    ; Call merge sort
    mov eax, 0                ; left index
    mov ebx, array_len - 1    ; right index
    call merge_sort
    
    ; Print sorted array
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 80h
    
    call print_array
    
    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 80h

merge_sort:
    ; Parameters:
    ; eax = left index
    ; ebx = right index
    
    push ebp
    mov ebp, esp
    
    ; Check if left < right
    cmp eax, ebx
    jge merge_sort_end
    
    ; Calculate middle point
    mov ecx, eax
    add ecx, ebx
    shr ecx, 1            ; middle = (left + right) / 2
    
    ; Save registers
    push eax
    push ebx
    push ecx
    
    ; Sort left half
    ; eax is already left
    mov ebx, ecx         ; right = middle
    call merge_sort
    
    ; Restore registers
    pop ecx
    pop ebx
    pop eax
    
    ; Save registers again
    push eax
    push ebx
    push ecx
    
    ; Sort right half
    mov eax, ecx
    inc eax              ; left = middle + 1
    ; ebx is already right
    call merge_sort
    
    ; Restore registers
    pop ecx              ; middle
    pop ebx              ; right
    pop eax              ; left
    
    ; Merge the sorted halves
    push eax
    push ebx
    push ecx
    call merge
    
merge_sort_end:
    mov esp, ebp
    pop ebp
    ret

merge:
    ; Parameters on stack:
    ; [ebp+8]  = middle
    ; [ebp+12] = right
    ; [ebp+16] = left
    
    push ebp
    mov ebp, esp
    
    ; Initialize indices
    mov esi, [ebp+16]    ; i = left
    mov edi, [ebp+8]     ; middle
    inc edi              ; j = middle + 1
    mov ecx, [ebp+16]    ; k = left (position in temp array)
    
    ; Copy elements to temp array
copy_to_temp:
    mov al, [array + ecx]
    mov [temp_array + ecx], al
    inc ecx
    cmp ecx, [ebp+12]
    jle copy_to_temp
    
    mov ecx, [ebp+16]    ; Reset k to left
    
merge_loop:
    ; Check if we've exhausted left or right half
    cmp esi, [ebp+8]     ; if i > middle
    jg copy_remaining_right
    
    cmp edi, [ebp+12]    ; if j > right
    jg copy_remaining_left
    
    ; Compare elements
    mov al, [temp_array + esi]
    cmp al, [temp_array + edi]
    jle copy_from_left
    
copy_from_right:
    mov al, [temp_array + edi]
    mov [array + ecx], al
    inc edi
    inc ecx
    jmp merge_loop
    
copy_from_left:
    mov al, [temp_array + esi]
    mov [array + ecx], al
    inc esi
    inc ecx
    jmp merge_loop
    
copy_remaining_left:
    cmp esi, [ebp+8]
    jg merge_end
    mov al, [temp_array + esi]
    mov [array + ecx], al
    inc esi
    inc ecx
    jmp copy_remaining_left
    
copy_remaining_right:
    cmp edi, [ebp+12]
    jg merge_end
    mov al, [temp_array + edi]
    mov [array + ecx], al
    inc edi
    inc ecx
    jmp copy_remaining_right
    
merge_end:
    mov esp, ebp
    pop ebp
    ret

; Function to print array
print_array:
    mov ecx, 0            ; Array index

print_loop:
    ; Convert number to ASCII
    mov al, [array + ecx]
    add al, '0'
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