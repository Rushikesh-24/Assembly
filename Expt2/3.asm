section .data
    name db 'John Doe,',0
    namelen equ $-name

section .text
    global _start
    
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, namelen
    int 80h

    mov dword [name], dword 'Jack' ; replace word by using dword 4 bytes

    ; Print modified string
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, namelen
    int 80h

    ; Exit call
    mov eax, 1
    mov ebx, 0
    int 80h