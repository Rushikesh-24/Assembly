section .data
    msg db 'Odd numbers from 0 to 9:', 0xa
    msgLen equ $ - msg
    newline db 0xa
    
section .bss
    num resb 2        

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msgLen
    int 80h
    
    mov cl, 0          ; CL will be our counter

print_loop:
    mov al, cl        
    push cx            
    mov ah, 0          
    mov bl, 2          ; Divisor (2)
    div bl             ; Divide AL by 2
    pop cx             ; Restore our counter
    cmp ah, 0          ; Check remainder
    je skip_print      ; If remainder is 0 (even), skip printing
    
    mov al, cl        
    add al, '0'        
    mov [num], al      
    
    push cx            ; Save counter
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    pop cx            

skip_print:
    inc cl
    cmp cl, 10         
    jl print_loop      

exit:
    mov eax, 1         
    mov ebx, 0        
    int 80h