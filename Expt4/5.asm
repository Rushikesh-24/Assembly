section .data
    prompt1 db 'Enter first string: ', 0
    len1 equ $ - prompt1
    prompt2 db 'Enter second string: ', 0
    len2 equ $ - prompt2
    equalMsg db 'Strings are equal', 0
    equalLen equ $ - equalMsg
    notEqualMsg db 'Strings are not equal', 0
    notEqualLen equ $ - notEqualMsg
    newline db 0xa

section .bss
    str1 resb 100    
    str2 resb 100    

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
    mov ecx, str1
    mov edx, 100    
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len2
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, str2
    mov edx, 100
    int 80h
    
    mov esi, str1
    mov edi, str2
    mov ecx, 100
    repe cmpsb
    jne not_equal
    
    mov eax, 4
    mov ebx, 1
    mov ecx, equalMsg
    mov edx, equalLen
    int 80h
    jmp done
    
not_equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, notEqualMsg
    mov edx, notEqualLen
    int 80h
    
done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    mov eax, 1     
    mov ebx, 0      
    int 80h