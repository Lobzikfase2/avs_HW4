extern printf
extern fscanf

extern FEATURE
extern CARTOON
extern DOCUMENTARY


global InFeature
InFeature:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE      resq    1   
    .pfeature  resq    1 
section .text
push rbp
mov rbp, rsp
    
    mov     [.pfeature], rdi          
    mov     [.FILE], rsi         
 
    mov     rdi, [.FILE]
    mov     rsi, .infmt        
    mov     rdx, [.pfeature]       
    mov     rcx, [.pfeature]
    add     rcx, 4              
    mov     r8,  [.pfeature]
    add     r8,  8              
    mov     r9,  [.pfeature]
    add     r9,  12 
    mov     rax, 0              
    call    fscanf

leave
ret


global InCartoon
InCartoon:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE      resq    1   
    .pcartoon  resq    1 
section .text
push rbp
mov rbp, rsp
    
    mov     [.pcartoon], rdi          
    mov     [.FILE], rsi         
 
    mov     rdi, [.FILE]
    mov     rsi, .infmt        
    mov     rdx, [.pcartoon]       
    mov     rcx, [.pcartoon]
    add     rcx, 4              
    mov     r8,  [.pcartoon]
    add     r8,  8              
    mov     r9,  [.pcartoon]
    add     r9,  12 
    mov     rax, 0              
    call    fscanf

leave
ret

global InDocumentary
InDocumentary:
section .data
    .infmt db "%d%d%d",0
section .bss
    .FILE      resq    1   
    .pdocument resq    1 
section .text
push rbp
mov rbp, rsp
    
    mov     [.pdocument], rdi          
    mov     [.FILE], rsi         
 
    mov     rdi, [.FILE]
    mov     rsi, .infmt        
    mov     rdx, [.pdocument]       
    mov     rcx, [.pdocument]
    add     rcx, 4              
    mov     r8,  [.pdocument]
    add     r8,  8              
    mov     r9,  [.pdocument]
    add     r9,  12 
    mov     rax, 0              
    call    fscanf

leave
ret


global InFilm
InFilm:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db      "Tag is: %d",10,0
section .bss
    .FILE        resq    1   
    .pfilm       resq    1   
    .filmTag     resd    1  
section .text
push rbp
mov rbp, rsp

    mov     [.pfilm], rdi          
    mov     [.FILE], rsi           

    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pfilm]     
    xor     rax, rax           
    call    fscanf

    mov rcx, [.pfilm]         
    mov eax, [rcx]              
    cmp eax, [FEATURE]
    je .featureIn
    cmp eax, [CARTOON]
    je .cartoonIn
    cmp eax, [DOCUMENTARY]
    je .documentIn
    xor eax, eax   
    jmp     .return
.featureIn:
    mov     rdi, [.pfilm]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InFeature
    mov     rax, 1
    jmp     .return
.cartoonIn:
    mov     rdi, [.pfilm]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InCartoon
    mov     rax, 1  
    jmp     .return
.documentIn:
    mov     rdi, [.pfilm]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InDocumentary
    mov     rax, 1  
    jmp     .return
.return:

leave
ret


global InContainer
InContainer:
section .bss
    .pcont  resq    1   
    .plen   resq    1   
    .FILE   resq    1   
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   
    mov [.plen], rsi    
    mov [.FILE], rdx   

    xor rbx, rbx      
    mov rsi, rdx      
.loop:
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0     
    call    InFilm    
    cmp rax, 0        
    jle  .return  

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