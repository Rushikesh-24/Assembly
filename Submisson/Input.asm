section .data
    prompt db 'Enter a string: ', 0
    len_prompt equ $ - prompt
    output db 'Entered String: ', 0
    len_output equ $ - output

section .bss
    input_str resb 100

section .text
    global _start

_start:
    ; Display prompt and input string
    mov ecx, prompt
    mov edx, len_prompt
    call display
    mov ecx, input_str
    mov edx, 100
    call input
    call strip_newline

    ; Display output and input string
    mov ecx, output
    mov edx, len_output
    call display
    mov ecx, input_str
    mov edx, 100
    call display

    ; Exit
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
; strip_newline: replaces newline with 0
; expects ecx = buffer, edx = buffer size
;----------------------------------------
strip_newline:
    push ecx
    push edx
    mov esi, ecx
    mov ecx, edx
find_nl:
    lodsb
    cmp al, 0xa
    jne not_nl
    mov byte [esi-1], 0
    jmp done_nl
not_nl:
    loop find_nl
done_nl:
    pop edx
    pop ecx
    ret
