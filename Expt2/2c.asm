section .data
    str1 db 'This is ', 0
    str2 db 'a Test', 0
    str1len equ $-str1
    str2len equ $-str2
    n1 equ 4
    n2 equ 1
section .text
	global _start
_start:
	mov eax, n1
	mov ebx, n2
    mov ecx, str1
    mov edx, str1len

    int 80h
    mov ecx, str2
    mov edx, str2len
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h