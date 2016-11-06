.data
NO:
	.string	"Not found"
    .set NO_LEN, . - NO
YES:
	.string	"Found"
    .set YES_LEN, . - YES 
ZERO:
    .ascii "0"
.text
.globl _start

GET_SIZE:
    mov     $0, %rax   # read
    mov     $0, %rdi   # stdin
    sub     $8, %rsp   # Выделили место для чтения
    mov     %rsp, %rsi # Указатель, куда читать
    mov     $2, %rdx   # Сколько байт читать (число + \n)
    syscall
    pop     %rax       # rax = read()
    xor     %ah, %ah   # Обнуляем символ конца строки
    subw    ZERO, %ax  # Преобразуем символ в число
    ret

GET_ARRAY:
    push    %rax
    mov     $0, %rax   # read
    mov     $0, %rdi   # stdin
    syscall
    pop     %rax
    ret

CHECK_ARRAY:
    xor     %rcx, %rcx
    movb    (%rbx), %cl
.START:
    add     $2, %rbx     # Двигаем указатель на 2 (символ + пробел)
    dec     %rax         # Уменьшаем количество оставшихся элементов

    cmp     $0, %rax     # Проверка на конец массива
    je      .NOT_FOUND

    cmpb    %cl, (%rbx)  # Проверка на совпадение текущего и искомого
    je      .FOUND

    jmp     .START

.FOUND:
    mov     $YES, %rsi
    mov     $YES_LEN, %rdx
    jmp     .PRINT

.NOT_FOUND:
    mov     $NO, %rsi
    mov     $NO_LEN, %rdx

.PRINT:
    mov     $1, %rax    # write
    mov     $1, %rdi    # файловый дескриптор (1 == stdout)
    syscall
    ret

_start:
    call    GET_SIZE           # rax = GET_SIZE

    lea     (, %eax, 4), %rbx  # rbx = eax * 4
    sub     %rbx, %rsp
    mov     %rsp, %rsi         # Указатель, куда считываять
    lea     (, %rax, 2), %rdx  # Сколько байт считывать
    call    GET_ARRAY

    mov     %rsp, %rbx         # Указатель на массив
    call    CHECK_ARRAY

    mov     $60, %rax    # exit
    xor     %rdi, %rdi   # Код возврата 0
    syscall
