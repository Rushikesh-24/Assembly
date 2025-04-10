section .data
    msg1 db "Enter first number: ", 0
    msg2 db "Enter second number: ", 0
    newline db 10, 0  
    resultAdd db "Sum: ", 0
    resultSub db "Difference: ", 0
    resultMul db "Product: ", 0
    resultQuo db "Quotient: ", 0
    resultRem db "Remainder: ", 0
    resultExp db "Exponent: ", 0
section .bss
    number1 resb 1
    number2 resb 1
    output resb 1 
section .text
    global _start
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 20
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, number1
    mov edx, 2
    int 80h
    mov al, [number1]
    sub al, '0'
    mov [number1], al
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 21
    int 80h
    mov eax, 3
    mov ebx, 0
    mov ecx, number2
    mov edx, 2
    int 80h
    mov al, [number2]
    sub al, '0'
    mov [number2], al
    push number1
    push number2
    call add_nums
    mov eax, 4
    mov ebx, 1
    mov ecx, resultAdd
    mov edx, 5
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    push number1
    push number2
    call sub_nums
    mov eax, 4
    mov ebx, 1
    mov ecx, resultSub
    mov edx, 11
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    push number1
    push number2
    call mul_nums
    mov eax, 4
    mov ebx, 1
    mov ecx, resultMul
    mov edx, 9
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    push number1
    push number2
    call div_nums
    mov eax, 4
    mov ebx, 1
    mov ecx, resultQuo
    mov edx, 10
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    push number1
    push number2
    call rem_nums
    mov eax, 4
    mov ebx, 1
    mov ecx, resultRem
    mov edx, 10
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    push number1
    push number2
    call exp_nums
    mov eax, 4
    mov ebx, 1
    mov ecx, resultExp
    mov edx, 10
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, output
    mov edx, 1
    int 80h
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    mov eax, 1
    mov ebx, 0
    int 80h
add_nums:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    mov al, [eax]
    mov ebx, [ebp + 8]
    add al, [ebx]
    add al, '0'
    mov [output], al
    mov esp, ebp
    pop ebp
    ret 8
sub_nums:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    mov al, [eax]
    mov ebx, [ebp + 8]
    sub al, [ebx]
    add al, '0'
    mov [output], al
    mov esp, ebp
    pop ebp
    ret 
mul_nums:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    mov al, [eax]
    mov ebx, [ebp + 8]
    mov bl, [ebx]
    mul bl
    add al, '0'
    mov [output], al
    mov esp, ebp
    pop ebp
    ret 
div_nums:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    mov al, [eax]
    mov ah, 0
    mov ebx, [ebp + 8]
    mov bl, [ebx]
    div bl
    add al, '0'
    mov [output], al
    mov esp, ebp
    pop ebp
    ret 
rem_nums:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]
    mov al, [eax]
    mov ah, 0
    mov ebx, [ebp + 8]
    mov bl, [ebx]
    div bl
    mov al, ah
    add al, '0'
    mov [output], al
    mov esp, ebp
    pop ebp
    ret
exp_nums:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 12]    
    mov al, [eax]
    mov ebx, [ebp + 8]    
    mov bl, [ebx]
    mov cl, 1            
    cmp bl, 0
    je exp_done           
    mov dl, al       
    dec bl           
exp_loop:
    cmp bl, 0
    je exp_done
    mul dl               ; multiply result by base
    mov cl, al           ; save result
    mov al, dl           ; restore base
    dec bl
    jmp exp_loop
exp_done:
    mov al, cl
    add al, '0'
    mov [output], al
    mov esp, ebp
    pop ebp
    ret 