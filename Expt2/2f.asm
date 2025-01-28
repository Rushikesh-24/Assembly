section .data   
    endl db 0xA  ;newline character
section .bss
    name resb 20        
section .text
    global _start
_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 5
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, 5
    int 80h

	mov eax, 4
    mov ebx, 1
    mov ecx, endl
    mov edx, 1
    int 80h

mov eax, 1
mov ebx, 0
int 80h