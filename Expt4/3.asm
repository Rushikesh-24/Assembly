section .data
    prompt1 db 'Enter first number: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second number: ', 0
    len2 equ $ - prompt2
    prompt3 db 'Enter third number: ', 0
    len3 equ $ - prompt3
    smallerMsg db 'Smaller number is: ', 0
    smallerLen equ $ - smallerMsg
    equalMsg db 'All numbers are equal', 0
    equalLen equ $ - equalMsg
    newline db 0xa

section .bss
    num1 resb 2        
    num2 resb 2        
    num3 resb 2        
    smaller resb 2      

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
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt3
    mov edx, len3
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num3
    mov edx, 2
    int 80h
    
    mov eax, [num1]
    sub eax, '0'
    
    mov ebx, [num2]
    sub ebx, '0'
    
    cmp al, bl
    je check_num3_equal
    jle num1_smaller
    mov al, bl
    
num1_smaller:
    mov bl, [num3]
    sub bl, '0'
    
    cmp al, bl
    jle num3_smaller
    mov al, bl
    
num3_smaller:
    add al, '0'
    mov [smaller], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, smallerMsg
    mov edx, smallerLen
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, smaller
    mov edx, 1
    int 80h
    
    jmp print_newline

check_num3_equal:
    mov bl, [num3]
    sub bl, '0'
    cmp al, bl
    je all_equal
    jmp num1_smaller

all_equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, equalMsg
    mov edx, equalLen
    int 80h

print_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h

exit:
    mov eax, 1         
    mov ebx, 0         
    int 80h