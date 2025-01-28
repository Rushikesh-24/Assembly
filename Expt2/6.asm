section .data
    msg1 db 'Name and number:', 0  
    msg1len equ $-msg1
    endl db 0xA  ;newline character
section .bss
    name resb 20
    num resb 10    
section .text
    global _start
_start:
	mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1len
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 20
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 10
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, 1
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, msg1len
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 20
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 10
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, 1
    int 80h

mov eax, 1
mov ebx, 0
int 80h