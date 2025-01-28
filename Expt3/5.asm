section .data
    prompt db 'Enter a number: ', 0
    promptLen equ $ - prompt
    msg db 'Next four numbers are:', 0xa
    msgLen equ $ - msg
    newline db 0xa
    
section .bss
    num resb 2         ; Buffer for input number
    result resb 2      ; Buffer for displaying numbers

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, promptLen
    int 80h
    
    ; Read input number
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 2
    int 80h
    
    ; Display message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msgLen
    int 80h
    
    ; Get input number in AL and convert from ASCII
    mov al, [num]
    sub al, '0'        ; Convert from ASCII to number
    
    ; Counter for 4 numbers
    mov cl, 4          ; We'll display 4 numbers

print_loop:
    inc al             ; Increment the number
    
    ; Convert to ASCII and store
    push ax            ; Save the current number
    add al, '0'        ; Convert to ASCII
    mov [result], al   ; Store for printing
    
    ; Print number
    push ecx           ; Save counter
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 1
    int 80h
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    pop ecx            ; Restore counter
    
    pop ax             ; Restore number
    
    ; Loop control
    dec cl             ; Decrement counter
    jnz print_loop     ; If counter not zero, continue loop

exit:
    mov eax, 1         ; sys_exit
    mov ebx, 0         ; Exit code 0
    int 80h