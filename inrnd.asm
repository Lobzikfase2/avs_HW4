extern printf
extern rand

extern FEATURE
extern CARTOON
extern DOCUMENTARY

global RandomType
RandomType:
section .data
    .iT     dq       3
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    
    call    rand        
    xor     rdx, rdx   
    idiv    qword[.iT]      
    mov     rax, rdx
    inc     rax         

leave
ret

global RandomString
RandomString:
section .data
    .iS          dq 98999      
    .rndNumFmt   db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    
    call    rand      
    xor     rdx, rdx    
    idiv    qword[.iS]       
    mov     rax, rdx
    add     rax, 1000

leave
ret

global RandomYear
RandomYear:
section .data
    .iY          dq 126  
    .rndNumFmt   db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    
    call    rand      
    xor     rdx, rdx    
    idiv    qword[.iY]       
    mov     rax, rdx
    add     rax, 1895

leave
ret

global RandomDuration
RandomDuration:
section .data
    .iD          dq 150
    .rndNumFmt   db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    
    call    rand       
    xor     rdx, rdx    
    idiv    qword[.iD]     
    mov     rax, rdx
    add     rax, 60

leave
ret


global InRndFeature
InRndFeature:
section .bss
    .pfeature  resq 1   
section .text
push rbp
mov rbp, rsp

    mov     [.pfeature], rdi
    call    RandomString
    mov     rbx, [.pfeature]
    mov     [rbx], eax
    call    RandomYear
    mov     rbx, [.pfeature]
    mov     [rbx+4], eax
    call    RandomString
    mov     rbx, [.pfeature]
    mov     [rbx+8], eax

leave
ret


global InRndCartoon
InRndCartoon:
section .bss
    .pcartoon  resq 1   
section .text
push rbp
mov rbp, rsp

    mov     [.pcartoon], rdi
    call    RandomString
    mov     rbx, [.pcartoon]
    mov     [rbx], eax
    call    RandomYear
    mov     rbx, [.pcartoon]
    mov     [rbx+4], eax
    call    RandomType
    mov     rbx, [.pcartoon]
    mov     [rbx+8], eax

leave
ret


global InRndDocumentary
InRndDocumentary:
section .bss
    .pdocument  resq 1   
section .text
push rbp
mov rbp, rsp

    mov     [.pdocument], rdi
    call    RandomString
    mov     rbx, [.pdocument]
    mov     [rbx], eax
    call    RandomYear
    mov     rbx, [.pdocument]
    mov     [rbx+4], eax
    call    RandomDuration
    mov     rbx, [.pdocument]
    mov     [rbx+8], eax

leave
ret

global InRndFilm
InRndFilm:
section .data
    .rndNumFmt  db "Random number = %d",10,0
section .bss
    .pfilm      resq    1  
    .key        resd    1   
section .text
push rbp
mov rbp, rsp

    mov [.pfilm], rdi

    xor     rax, rax    
    call    RandomType   
    mov     rdi, [.pfilm]
    mov     [rdi], eax     
    cmp eax, [FEATURE]
    je .featureInrnd
    cmp eax, [CARTOON]
    je .cartoonInRnd
    cmp eax, [DOCUMENTARY]
    je .documentInRnd
    xor eax, eax        
    jmp     .return
.featureInrnd:
    add     rdi, 4
    call    InRndFeature
    mov     eax, 1      
    jmp     .return
.cartoonInRnd:
    add     rdi, 4
    call    InRndCartoon
    mov     eax, 1    
    jmp     .return
.documentInRnd:
    add     rdi, 4
    call    InRndDocumentary
    mov     eax, 1     
    jmp     .return
.return:
leave
ret

global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   
    .plen   resq    1   
    .psize  resd    1   
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi  
    mov [.plen], rsi    
    mov [.psize], edx   

    xor ebx, ebx     
.loop:
    cmp ebx, edx
    jge     .return

    push rdi
    push rbx
    push rdx

    call    InRndFilm   
    cmp rax, 0          
    jle  .return        

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 16           

    jmp .loop
.return:
    mov rax, [.plen]    
    mov [rax], ebx     
    
leave
ret
