section .data
    prompt db 'Enter a number: ', 0
    promptLen equ $ - prompt
    msg db 'Next four numbers are:', 0xa
    msgLen equ $ - msg
    newline db 0xa
    
section .bss
    num resb 2         
    result resb 2     

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, promptLen
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 2
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msgLen
    int 80h
    
    mov eax, [num]
    sub eax, '0'     
    
    mov ecx, 4          

print_loop:
    inc eax             
    
    
    push eax            ; Save the current number
    add eax, '0'       
    mov [result], eax   
    
    push ecx           ; Save counter
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
    pop ecx           
    
    pop eax            
    
    dec ecx             ; Decrement counter
    jnz print_loop    

exit:
    mov eax, 1         
    mov ebx, 0         
    int 80h