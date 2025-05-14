section .data
    prompt db 'Enter password: ', 0
    len_prompt equ $ - prompt
    correct_msg db 'Correct', 0xa, 0
    len_correct equ $ - correct_msg
    incorrect_msg db 'Incorrect', 0xa, 0
    len_incorrect equ $ - incorrect_msg
    password db '12'

section .bss
    user_input resb 2

section .text
    global _start

_start:
    ; Display prompt and input password
    mov ecx, prompt
    mov edx, len_prompt
    call display
    mov ecx, user_input
    mov edx, 2
    call input

    ; Validate password
    mov ecx, user_input
    mov edx, password
    mov ebx, 2
    call validate_password

    cmp eax, 1
    je show_correct

show_incorrect:
    mov ecx, incorrect_msg
    mov edx, len_incorrect
    call display
    jmp exit

show_correct:
    mov ecx, correct_msg
    mov edx, len_correct
    call display

exit:
    mov eax, 1
    mov ebx, 0
    int 80h

;----------------------------------------
; display: prints [ecx] of length [edx]
;----------------------------------------
display:
    mov eax, 4
    mov ebx, 1
    int 80h
    ret

;----------------------------------------
; input: reads [edx] bytes into [ecx]
;----------------------------------------
input:
    mov eax, 3
    mov ebx, 0
    int 80h
    ret

;----------------------------------------
; validate_password: 
;   ecx = user input
;   edx = password
;   ebx = length
;   returns eax = 1 if match, 0 otherwise
;----------------------------------------
validate_password:
    push esi
    push edi
    mov esi, ecx
    mov edi, edx
    mov ecx, ebx
    xor eax, eax
    repe cmpsb
    jne .not_equal
    mov eax, 1
.not_equal:
    pop edi
    pop esi
    ret
