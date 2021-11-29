
    .text
    .global main
do_add:
    pushq %rbp
    movq %rsp, %rbp
    xorq %rax, %rax
    addq %rdi, %rax
    addq %rsi, %rax
    leave
    ret

main:
    pushq %rbp
    movq %rsp, %rbp
    
    leaq hello, %rdi
    callq printf

    movq $1, %rdi
    movq $2, %rsi
    callq do_add

    movq %rax, %rsi
    leaq printadd, %rdi
    callq printf

    xorq %rax, %rax
    leave
    ret

    .data
hello:
    .string "Hello world from x86!\n\0"
printadd:
    .string "a + b = %d\n\0"
