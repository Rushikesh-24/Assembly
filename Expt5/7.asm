section .data
    prompt1 db 'Enter first string: ', 0
    prompt2 db 'Enter second string: ', 0
    msg1 db 'First string: ', 0
    msg2 db 'Second string: ', 0
    str1 times 100 db 0
    str2 times 100 db 0
    %macro write 2
        mov eax, 4
        mov ebx, 1
        mov ecx, %1
        mov edx, %2
        int 80h
    %endmacro

    section .text
        global _start

    _start:
        write prompt1, 20

        mov eax, 3
        mov ebx, 0
        mov ecx, str1
        mov edx, 100
        int 80h

        write prompt2, 21

        mov eax, 3
        mov ebx, 0
        mov ecx, str2
        mov edx, 100
        int 80h

        write msg1, 14

        write str1, 100
        write msg2, 15
        write str2, 100

        mov eax, 1
        xor ebx, ebx
        int 80h