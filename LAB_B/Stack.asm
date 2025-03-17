section .data
    prompt_msg db 'Stack Operations (1:push, 2:pop, 3:display, 0:exit):', 0
    prompt_len equ $-prompt_msg
    
    push_prompt db 'Enter number to push (0-9):', 0
    push_prompt_len equ $-push_prompt
    
    push_msg db 'Pushed: ', 0
    push_len equ $-push_msg
    
    pop_msg db 'Popped: ', 0
    pop_len equ $-pop_msg
    
    stack_msg db 'Stack (top to bottom): ', 0
    stack_len equ $-stack_msg
    
    empty_msg db 'Stack is empty', 0
    empty_len equ $-empty_msg
    
    error_msg db 'Stack underflow!', 0
    error_len equ $-error_msg
    
    newline db 0xa
    newline_len equ $-newline
    
    space db ' '
    space_len equ $-space

section .bss
    choice resb 2
    num resb 2
    buffer resb 10
    stack_data resb 100
    stack_size equ 100

section .text
    global _start

_start:
    mov edi, stack_data
    xor esi, esi

do_while_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, prompt_len
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 80h
    
    movzx eax, byte [choice]
    sub eax, '0'
    
    cmp eax, 0
    je exit_program
    
    cmp eax, 1
    je push_operation
    
    cmp eax, 2
    je pop_operation
    
    cmp eax, 3
    je display_stack_operation
    
    jmp do_while_loop

push_operation:
    mov eax, 4
    mov ebx, 1
    mov ecx, push_prompt
    mov edx, push_prompt_len
    int 80h
    
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 2
    int 80h
    
    movzx eax, byte [num]
    sub eax, '0'
    
    cmp esi, stack_size
    jae do_while_loop
    
    mov byte [edi + esi], al
    inc esi
    
    mov eax, 4
    mov ebx, 1
    mov ecx, push_msg
    mov edx, push_len
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, num
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    call display_stack
    
    jmp do_while_loop

pop_operation:
    cmp esi, 0
    je stack_underflow
    
    dec esi
    movzx eax, byte [edi + esi]
    
    add eax, '0'
    mov byte [buffer], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, pop_msg
    mov edx, pop_len
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    call display_stack
    
    jmp do_while_loop

stack_underflow:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, error_len
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    jmp do_while_loop

display_stack_operation:
    call display_stack
    jmp do_while_loop

display_stack:
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, 4
    mov ebx, 1
    mov ecx, stack_msg
    mov edx, stack_len
    int 80h
    
    cmp esi, 0
    je empty_stack
    
    mov ecx, esi
    dec ecx
    
display_loop:
    movzx eax, byte [edi + ecx]
    add eax, '0'
    mov byte [buffer], al
    
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h
    pop ecx
    
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, space_len
    int 80h
    pop ecx
    
    dec ecx
    jge display_loop
    
display_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    ret

empty_stack:
    mov eax, 4
    mov ebx, 1
    mov ecx, empty_msg
    mov edx, empty_len
    int 80h
    
    jmp display_newline

exit_program:
    mov eax, 1
    mov ebx, 0
    int 80h
