section .data
    sentence TIMES 9 db '*'
    len equ $-sentence

section .text
    global _start
_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, sentence
    mov edx, len
    int 80h      

    mov eax, 1
    mov ebx, 0
    int 80h