section .data
    msg db 'Odd numbers from 0 to 9:', 0xa
    msgLen equ $ - msg
    newline db 0xa
    
section .bss
    num resb 2         ; Buffer for number to print

section .text
    global _start

_start:
    ; Print message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msgLen
    int 80h
    
    ; Initialize counter
    mov cl, 0          ; CL will be our counter

print_loop:
    ; Check if number is odd
    mov al, cl         ; Move current number to AL
    push cx            ; Save our counter
    mov ah, 0          ; Clear AH before division
    mov bl, 2          ; Divisor (2)
    div bl             ; Divide AL by 2
    pop cx             ; Restore our counter
    cmp ah, 0          ; Check remainder
    je skip_print      ; If remainder is 0 (even), skip printing
    
    ; Convert number to ASCII and print
    mov al, cl         ; Get original number back
    add al, '0'        ; Convert to ASCII
    mov [num], al      ; Store in memory
    
    ; Print number
    push cx            ; Save counter
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    pop cx             ; Restore counter

skip_print:
    ; Increment counter and check if we're done
    inc cl
    cmp cl, 10         ; Compare with 10
    jl print_loop      ; If less than 10, continue loop

exit:
    mov eax, 1         ; sys_exit
    mov ebx, 0         ; Exit code 0
    int 80h