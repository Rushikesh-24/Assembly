section .data
    prompt1 db 'Enter first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second number: ', 0
    len2 equ $ - prompt2
    sumMsg db 'Sum is: ', 0
    sumLen equ $ - sumMsg
    newline db 0xa
    
section .bss
    num1 resb 2    
    num2 resb 2    
    sum resb 2    

section .text
    global _start

_start:
    mov eax, 4     
    mov ebx, 1     
    mov ecx, prompt1
    mov edx, len1
    int 80h
    
    mov eax, 3     
    mov ebx, 0      
    mov ecx, num1
    mov edx, 2    
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 80h
    
    mov al, [num1]      
    sub al, '0'        
    mov bl, [num2]     
    sub bl, '0'        
    
    add al, bl        
    add al, '0'       
    mov [sum], al     
    
    mov eax, 4
    mov ebx, 1
    mov ecx, sumMsg
    mov edx, sumLen
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    mov eax, 1     
    mov ebx, 0      
    int 80h