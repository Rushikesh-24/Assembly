section .data
    prompt db 'Enter number to search ',0
    promptLen equ $-prompt
    foundMsg db 'Number found at position: ',0
    foundLen equ $-foundMsg
    notFoundMsg db 'Number not found in array',0
    notFoundLen equ $-notFoundMsg
    array db 1,2,3,4,5
    arrayLen equ $-array
    newLine db 0xA

section .bss
    searchNum resb 2
    position resb 2

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, promptLen
    int 80h
    
    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, searchNum
    mov edx, 2
    int 80h
    
    ; Convert ASCII to number
    mov al, [searchNum]
    sub al, '0'
    
    ; Initialize binary search
    mov ecx, 0          ; left = 0
    mov edx, arrayLen   ; right = arrayLen - 1
    dec edx
    
binary_search:
    cmp ecx, edx
    jg not_found        ; if left > right, element not found
    
    ; Calculate mid = (left + right) / 2
    mov ebx, ecx        ; ebx = left
    add ebx, edx        ; ebx = left + right
    shr ebx, 1          ; ebx = (left + right) / 2
    
    ; Compare array[mid] with search number
    mov dl, [array + ebx]
    cmp dl, al
    push ebx
    je found            ; if equal, element found
    jl greater          ; if array[mid] < search_num
    
    mov edx, ebx        ; right = mid - 1
    dec edx
    jmp binary_search
    
greater:
    mov ecx, ebx        ; left = mid + 1
    inc ecx
    jmp binary_search
    
found:
    mov eax, 4
    mov ebx, 1
    mov ecx, foundMsg
    mov edx, foundLen
    int 80h
    
    pop ebx
    add ebx, '1'      
    mov [position], ebx
    
    mov eax, 4
    mov ebx, 1
    mov ecx, position
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newLine
    mov edx, 1
    int 80h
    
    jmp exit
    
not_found:
    mov eax, 4
    mov ebx, 1
    mov ecx, notFoundMsg
    mov edx, notFoundLen
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, newLine
    mov edx, 1
    int 80h
    
exit:
    mov eax, 1
    mov ebx, 0
    int 80h