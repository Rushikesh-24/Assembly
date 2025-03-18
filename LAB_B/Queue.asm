section .data
    texttext db 'Queue {1=enqueue, 2=dequeue, 3=display, 0=exit}:', 0
    text_len equ $-texttext
    enqueue_text db 'Enter number to enqueue:', 0
    enqueue_text_len equ $-enqueue_text
 
    queuetext db 'Queue: ', 0
    queue_len equ $-queuetext
    emptytext db 'Queue is empty', 0
    empty_len equ $-emptytext
    errortext db 'Queue is empty!', 0
    error_len equ $-errortext
    fulltext db 'Queue is full!', 0
    full_len equ $-fulltext
    newline db 0xa
    newline_len equ $-newline
    space db ' '
    space_len equ $-space

section .bss
    choice resb 2
    num resb 2
    buffer resb 10
    queue_data resb 100
    queue_size equ 100
    front resd 1    ; Queue front index
    rear resd 1     ; Queue rear index
    count resd 1    ; Number of elements in the queue

section .text
    global _start

_start:
    ; Initialize queue variables
    mov dword [front], 0
    mov dword [rear], 0
    mov dword [count], 0

main_loop:
    ; Display menu
    mov eax, 4
    mov ebx, 1
    mov ecx, texttext
    mov edx, text_len
    int 80h
    
    ; Read choice
    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 80h
    
    ; Convert ASCII to number
    movzx eax, byte [choice]
    sub eax, '0'
    
    ; Process choice
    cmp eax, 0
    je exit_program
    
    cmp eax, 1
    je enqueue
    
    cmp eax, 2
    je dequeue
    
    cmp eax, 3
    je display
    
    jmp main_loop

enqueue:
    ; Display prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, enqueue_text
    mov edx, enqueue_text_len
    int 80h
    
    ; Read number
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 2
    int 80h
    
    ; Check if queue is full
    mov eax, [count]
    cmp eax, queue_size
    jae queue_full
    
    ; Get number to enqueue
    movzx eax, byte [num]
    sub eax, '0'
    
    ; Store in queue
    mov ebx, [rear]
    mov byte [queue_data + ebx], al
    
    ; Update rear
    inc ebx
    cmp ebx, queue_size
    jl rear_ok
    mov ebx, 0    ; Wrap around
rear_ok:
    mov [rear], ebx
    
    ; Increment count
    inc dword [count]
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    ; Display updated queue
    call display_queue
    
    jmp main_loop

queue_full:
    ; Display error message
    mov eax, 4
    mov ebx, 1
    mov ecx, fulltext
    mov edx, full_len
    int 80h
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    jmp main_loop

dequeue:
    ; Check if queue is empty
    mov eax, [count]
    cmp eax, 0
    je queue_empty
    
    ; Get element from front
    mov ebx, [front]
    movzx eax, byte [queue_data + ebx]
    add eax, '0'
    mov [buffer], al
    
    ; Display dequeued element
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h
    
    ; Update front
    mov ebx, [front]
    inc ebx
    cmp ebx, queue_size
    jl front_ok
    mov ebx, 0    ; Wrap around
front_ok:
    mov [front], ebx
    
    ; Decrement count
    dec dword [count]
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    ; Display updated queue
    call display_queue
    
    jmp main_loop

queue_empty:
    ; Display error message
    mov eax, 4
    mov ebx, 1
    mov ecx, errortext
    mov edx, error_len
    int 80h
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    jmp main_loop

display:
    call display_queue
    jmp main_loop

display_queue:
    ; Save registers
    pusha
    
    ; Display queue text
    mov eax, 4
    mov ebx, 1
    mov ecx, queuetext
    mov edx, queue_len
    int 80h
    
    ; Check if queue is empty
    mov eax, [count]
    cmp eax, 0
    je display_empty
    
    ; Setup for display
    mov ecx, [count]    ; Counter
    mov edx, [front]    ; Current position
    
display_loop:
    ; Display current element
    movzx eax, byte [queue_data + edx]
    add eax, '0'
    mov [buffer], al
    
    push ecx
    push edx
    
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, space_len
    int 80h
    
    pop edx
    pop ecx
    
    ; Move to next element
    inc edx
    cmp edx, queue_size
    jl position_ok
    mov edx, 0    ; Wrap around
position_ok:
    
    ; Continue loop until all elements displayed
    dec ecx
    jnz display_loop
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    ; Restore registers
    popa
    ret

display_empty:
    ; Display empty message
    mov eax, 4
    mov ebx, 1
    mov ecx, emptytext
    mov edx, empty_len
    int 80h
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 80h
    
    popa
    ret

exit_program:
    mov eax, 1
    mov ebx, 0
    int 80h
