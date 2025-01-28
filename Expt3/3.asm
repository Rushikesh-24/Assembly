section .data
    promptL db 'Enter length: ', 0
    lenL equ $ - promptL
    promptB db 'Enter breadth: ', 0
    lenB equ $ - promptB
    
    areaMsg db 'Area of rectangle: ', 0
    areaLen equ $ - areaMsg
    periMsg db 'Perimeter of rectangle: ', 0
    periLen equ $ - periMsg
    
    newline db 0xa

section .bss
    length resb 2      ; Buffer for length
    breadth resb 2     ; Buffer for breadth
    result resb 2      ; Buffer for results

section .text
    global _start

_start:
    ; Prompt for length
    mov eax, 4
    mov ebx, 1
    mov ecx, promptL
    mov edx, lenL
    int 80h
    
    ; Read length
    mov eax, 3
    mov ebx, 0
    mov ecx, length
    mov edx, 2
    int 80h
    
    ; Prompt for breadth
    mov eax, 4
    mov ebx, 1
    mov ecx, promptB
    mov edx, lenB
    int 80h
    
    ; Read breadth
    mov eax, 3
    mov ebx, 0
    mov ecx, breadth
    mov edx, 2
    int 80h

    ; Calculate Area (length * breadth)
    mov al, [length]
    sub al, '0'        ; Convert length to number
    mov bl, [breadth]
    sub bl, '0'        ; Convert breadth to number
    
    ; Display area message
    mov eax, 4
    mov ebx, 1
    mov ecx, areaMsg
    mov edx, areaLen
    int 80h
    
    ; Calculate and display area
    mov al, [length]
    sub al, '0'
    mov bl, [breadth]
    sub bl, '0'
    mul bl             ; Multiply length * breadth
    add al, '0'        ; Convert result to ASCII
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4         ; Print newline
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    ; Calculate Perimeter [2(l + b)]
    ; Display perimeter message
    mov eax, 4
    mov ebx, 1
    mov ecx, periMsg
    mov edx, periLen
    int 80h
    
    ; Calculate perimeter
    mov al, [length]
    sub al, '0'
    mov bl, [breadth]
    sub bl, '0'
    add al, bl         ; l + b
    mov bl, 2
    mul bl             ; multiply by 2
    add al, '0'        ; Convert to ASCII
    mov [result], al
    
    ; Display perimeter
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4         ; Print newline
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

exit:
    mov eax, 1         ; sys_exit
    mov ebx, 0         ; Exit code 0
    int 80h