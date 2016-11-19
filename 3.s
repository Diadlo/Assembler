# Дано предложение. Определить, сколько раз два соседних слова
# начинаются на одну букву
# Строковые команды с префиксом повторения (пропустить прбелы/слово)

.data
length:
    .long 0
space:
    .string " "
zero:
    .string "0"


.bss
text:
    .space 100

.text
.globl _start

# int get_text(char* pointer) // return count
GET_TEXT:
    mov     %rsp, %rbp
    push    %rdi
    push    %rdx
    push    %rsi

    xor     %rax, %rax     # read
    xor     %rdi, %rdi     # stdin
    mov     8(%rbp), %rsi  # from
    mov     $100, %rdx     # count
    syscall

    lea     (%rsi, %rax), %rsi # rsi = end of input

    xor     %rdx, %rdx
    movb    (space), %dl
    mov     %rdx, (%rsi)  # set space in the end

    pop     %rsi
    pop     %rdx
    pop     %rdi
    ret 

EXIT:
    add     $8, %rsp     # Убираемя указатель
    mov     $60, %rax    # exit
    xor     %rdi, %rdi   # Код возврата 0
    syscall

_start:
    lea   text, %rdi
    push  %rdi
    call  GET_TEXT    # rax = text size

    mov   %rax, %r10  # r10 = rax = text length
    movw  space, %ax  # rax == ' '
    lea   text, %rdx  # rdx = text
    xor   $-1, %rdx

    xor   %r13, %r13  # r13 == count

START:
    movb  (%rdi), %bl   # bl = first char
    repne scasb 
    cmp   (%rdi), %bl   # new first char == prev first char
    jne NOT_EQ
    inc   %r13
    
NOT_EQ:
    lea   (%rdx, %rdi), %r11  # rcx = offset
    cmp   %r10, %r11  # offset < length
    jl    START

    lea   zero, %rax
    xor   %rbx, %rbx
    movb  (%rax), %bl
    add   %rbx, %r13

    sub   $1, %rsp
    mov   %r13, %rax
    movb  %al, (%rsp)

    sub   $1, %rsp
    movb  $10, (%rsp)

    mov   $1, %rax    # write
    mov   $1, %rdi    # файловый дескриптор (1 == stdout)
    mov   %rsp, %rsi  # buf = rsp
    mov   $2, %rdx    # count = 2
    syscall

    call EXIT
