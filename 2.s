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

# long get_size();
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

# void get_array(char* pointer, int count)
GET_ARRAY:
    mov     %rsp, %rbp
    mov     8(%rbp), %rdx
    mov     16(%rbp), %rsi
    push    %rax
    mov     $0, %rax   # read
    mov     $0, %rdi   # stdin
    syscall
    pop     %rax
    ret 

# void check_array(char* pointer, int size)
CHECK_ARRAY:
    mov     %rsp, %rbp
    mov     8(%rbp), %rax
    mov     16(%rbp), %rbx
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

    lea     (, %eax, 4), %rbx  # pointer = rbx = eax * 4
    sub     %rbx, %rsp         # Выделяем память на стеке
    pushq   %rsp

    lea     (, %rax, 2), %rbx  # Сколько байт считывать | count = rbx = rax * 2
    pushq   %rbx
    call    GET_ARRAY

    add     $8, %rsp     # Убираем count, оставляем указатель
    pushq   %rax
    call    CHECK_ARRAY

    add     $8, %rsp     # Убираемя указатель
    mov     $60, %rax    # exit
    xor     %rdi, %rdi   # Код возврата 0
    syscall
