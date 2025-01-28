section .data
    prompt db 'Enter number to serach ',0
    promptLen equ $-prompt
    foundMsg db 'Number found at position: ',0
    foundLen equ $-foundMsg
    notFoundMsg db 'Number not found in array',0
    notFoundLen equ $-notFoundMsg
    array db 5,2,8,1,9,3,7,4,6
    arrayLen equ $-array
    newLine db 0xA
    
section .bss
    searchNum resb 2
    position resb 2

section .text
    global _start

_start:
    mov eax,4
    mov ebx,1
    mov ecx,prompt
    mov edx,promptLen
    int 80h
    
    mov eax,3
    mov ebx,0
    mov ecx,searchNum
    mov edx,2
    int 80h
    
    mov al,[searchNum]
    sub al,'0'
    
    xor ecx,ecx
    
search_loop:
    cmp ecx,arrayLen
    jge not_found
    
    mov bl,[array + ecx]
    cmp bl,al
    je found
    
    inc ecx
    jmp search_loop
    
found:
    push ecx
    mov eax,4
    mov ebx,1
    mov ecx,foundMsg
    mov edx,foundLen
    int 80h
    pop ecx

    add ecx,1
    
    add ecx,'0'
    mov [position],ecx
    
    mov eax,4
    mov ebx,1
    mov ecx,position
    mov edx,1
    int 80h

    mov eax,4
    mov ebx,1
    mov ecx,newLine
    mov edx,1
    int 80h
    
    jmp exit

not_found:
    mov eax,4
    mov ebx,1
    mov ecx,notFoundMsg
    mov edx,notFoundLen
    int 80h
    
    mov eax,4
    mov ebx,1
    mov ecx,newLine
    mov edx,1
    int 80h

exit:
    mov eax,1
    mov ebx,0
    int 80h
    
