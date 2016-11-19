.data
NO:
	.string	"Not found"
  .set NO_LEN, . - NO
YES:
	.string	"Found"
  .set YES_LEN, . - YES
SIZE: 
    .long 4
ARRAY: 
    .long 1, 2, 3, 1

.text
.globl _start
_start:
    movl    SIZE, %eax
    movl    ARRAY, %ebx
    leal    ARRAY, %ecx
    
.START:
    addl    $4, %ecx     # Двигаем указатель
    dec     %eax         # Уменьшаем количество оставшихся элементов

    cmpl    $0, %eax     # Проверка на конец массива
    je      .NOT_FOUND

    cmpl    %ebx, (%ecx) # Проверка на совпадение текущего и искомого
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

.EXIT:
    mov     $60, %rax   # exit
    xor     %rdi, %rdi  # Код возврата
    syscall
