section .data
    prompt1 db 'Enter first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second number: ', 0
    len2 equ $ - prompt2
    largerMsg db 'Larger number is: ', 0
    largerLen equ $ - largerMsg
    newline db 0xa

section .bss
    num1 resb 2        
    num2 resb 2        
    larger resb 2      

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
    
    mov eax, [num1]    
    sub eax, '0'       
    
    mov ebx, [num2]    
    sub ebx, '0'        
    
    cmp eax, ebx
    jge first
    mov eax, ebx
    
first:
    add eax, '0'       
    mov [larger], eax     
    
    mov eax, 4
    mov ebx, 1
    mov ecx, largerMsg
    mov edx, largerLen
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, larger
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
