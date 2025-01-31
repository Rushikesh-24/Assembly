section .data
    ; Rectangle prompts
    promptL db 'Enter rectangle length: ', 0
    lenL equ $ - promptL
    promptW db 'Enter rectangle breadth: ', 0
    lenW equ $ - promptW
    rectAreaMsg db 'Area of rectangle: ', 0
    rectAreaLen equ $ - rectAreaMsg
    rectPeriMsg db 'Perimeter of rectangle: ', 0
    rectPeriLen equ $ - rectPeriMsg
    
    ; Triangle prompts
    promptBase db 'Enter triangle base: ', 0
    lenBase equ $ - promptBase
    promptHeight db 'Enter triangle height: ', 0
    lenHeight equ $ - promptHeight
    promptA db 'Enter triangle side a: ', 0
    lenA equ $ - promptA
    promptC db 'Enter triangle side c: ', 0
    lenC equ $ - promptC
    triAreaMsg db 'Area of triangle: ', 0
    triAreaLen equ $ - triAreaMsg
    triPeriMsg db 'Perimeter of triangle: ', 0
    triPeriLen equ $ - triPeriMsg
    
    newline db 0xa
    separator db '----------------------', 0xa
    sepLen equ $ - separator

section .bss
    length resb 2
    breadth resb 2
    base resb 2
    height resb 2
    sideA resb 2
    sideC resb 2
    result resb 2

section .text
    global _start
_start:
    ; Rectangle Calculations
    ; Get length
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
    
    ; Get breadth
    mov eax, 4
    mov ebx, 1
    mov ecx, promptW
    mov edx, lenW
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, breadth
    mov edx, 2
    int 80h
    
    ; Calculate and display rectangle area
    mov eax, 4
    mov ebx, 1
    mov ecx, rectAreaMsg
    mov edx, rectAreaLen
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
    
    ; Calculate and display rectangle perimeter
    mov eax, 4
    mov ebx, 1
    mov ecx, rectPeriMsg
    mov edx, rectPeriLen
    int 80h
    
    mov al, [length]
    sub al, '0'
    mov bl, [breadth]
    sub bl, '0'
    add al, bl
    mov bl, 2
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
    
    ; Separator between rectangle and triangle
    mov eax, 4
    mov ebx, 1
    mov ecx, separator
    mov edx, sepLen
    int 80h
    
    ; Triangle Calculations
    ; Get base
    mov eax, 4
    mov ebx, 1
    mov ecx, promptBase
    mov edx, lenBase
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, base
    mov edx, 2
    int 80h
    
    ; Get height
    mov eax, 4
    mov ebx, 1
    mov ecx, promptHeight
    mov edx, lenHeight
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, height
    mov edx, 2
    int 80h
    
    ; Get side A for perimeter
    mov eax, 4
    mov ebx, 1
    mov ecx, promptA
    mov edx, lenA
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, sideA
    mov edx, 2
    int 80h
    
    ; Get side C for perimeter
    mov eax, 4
    mov ebx, 1
    mov ecx, promptC
    mov edx, lenC
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, sideC
    mov edx, 2
    int 80h
    
    ; Calculate and display triangle perimeter
    mov eax, 4
    mov ebx, 1
    mov ecx, triPeriMsg
    mov edx, triPeriLen
    int 80h
    
    mov al, [base]
    sub al, '0'
    mov bl, [sideA]
    sub bl, '0'
    add al, bl
    mov bl, [sideC]
    sub bl, '0'
    add al, bl
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
    
    ; Calculate and display triangle area (base * height / 2)
    mov eax, 4
    mov ebx, 1
    mov ecx, triAreaMsg
    mov edx, triAreaLen
    int 80h
    
    mov al, [base]
    sub al, '0'
    mov bl, [height]
    sub bl, '0'
    mul bl          ; base * height
    mov bl, 2
    div bl          ; divide by 2
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