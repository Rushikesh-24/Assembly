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
    length resb 2      
    breadth resb 2     
    result resb 2      

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, promptL
    mov edx, lenL
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, length
    mov edx, 2
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, promptB
    mov edx, lenB
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, breadth
    mov edx, 2
    int 80h       
    
    mov eax, 4
    mov ebx, 1
    mov ecx, areaMsg
    mov edx, areaLen
    int 80h
    
    mov al, [length]
    sub al, '0'
    mov bl, [breadth]
    sub bl, '0'
    mul bl             
    add al, '0'       
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4         
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, periMsg
    mov edx, periLen
    int 80h
    
    mov al, [length]
    sub al, '0'
    mov bl, [breadth]
    sub bl, '0'
    add al, bl         ; l + b
    mov bl, 2
    mul bl             ; multiply by 2
    add al, '0'       
    mov [result], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    mov eax, 4         
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

exit:
    mov eax, 1        
    mov ebx, 0       
    int 80h