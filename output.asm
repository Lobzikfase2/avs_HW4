extern printf
extern fprintf

extern FILM_FUNC


extern FEATURE
extern CARTOON
extern DOCUMENTARY

extern  HAND_DRAWN
extern  PUPPET
extern  PLASTICINE
extern  hand_drawnstr
extern  puppetstr      
extern  plasticinestr  


global OutFeature
OutFeature:
section .data
    .outfmt db "It is Feature film: Title = %d, Year = %d, Director = %d, Function result = %f.", 10, 0 
section .bss
    .pfeature  resq  1
    .FILE      resq  1     
    .f         resq  1 
section .text
push rbp
mov rbp, rsp

    mov     [.pfeature], rdi         
    mov     [.FILE], rsi         

    call    FILM_FUNC
    cvtsi2sd  xmm0, r10 

    mov     rdi, [.FILE]
    mov     rsi, .outfmt    
    mov     rax, [.pfeature]       
    mov     edx, [rax]        
    mov     ecx, [rax+4]     
    mov     r8,  [rax+8]  
    mov     rax, 1
    call    fprintf

leave
ret


global OutCartoon
OutCartoon:
section .data
    .outfmt      db "It is Cartoon film: Title = %d, Year = %d, Function result = %f, ", 0 
    .outfmttype  db "Type = %s.", 10,0 
section .bss
    .pcartoon  resq  1
    .FILE      resq  1     
    .f         resq  1 
section .text
push rbp
mov rbp, rsp

    mov     [.pcartoon], rdi         
    mov     [.FILE], rsi         

    call    FILM_FUNC  
    cvtsi2sd  xmm0, r10

    mov     rdi, [.FILE]
    mov     rsi, .outfmt    
    mov     rax, [.pcartoon]       
    mov     edx, [rax]        
    mov     ecx, [rax+4]     
    mov     r8,  [rax+8]  
    mov     rax, 1 
    call    fprintf
    
    mov rdi, [.FILE]
    mov rsi, .outfmttype
    mov rax, [.pcartoon]
    mov edx, [rax+12]
    cmp edx, [HAND_DRAWN]
    je rHAND_DRAWN
    cmp edx, [PUPPET]
    je rPUPPET
    cmp edx, [PLASTICINE]
    je rPLASTICINE
    jmp end

    
    rHAND_DRAWN:
    mov edx, hand_drawnstr
    mov rax, 0
    call fprintf
    jmp end
    rPUPPET:
    mov edx, puppetstr 
    mov rax, 0
    call fprintf
    jmp end
    rPLASTICINE:
    mov edx, plasticinestr
    mov rax, 0
    call fprintf
    jmp end
   
end:  
leave
ret


global OutDocumentary
OutDocumentary:
section .data
    .outfmt db "It is Documentary film: Title = %d, Year = %d, Duration (m.) = %d, Function result = %f.", 10, 0 
section .bss
    .pdocument  resq  1
    .FILE       resq  1     
    .f          resq  1 
section .text
push rbp
mov rbp, rsp

    mov     [.pdocument], rdi         
    mov     [.FILE], rsi         

    call    FILM_FUNC
    cvtsi2sd  xmm0, r10     

    mov     rdi, [.FILE]
    mov     rsi, .outfmt       
    mov     rax, [.pdocument]       
    mov     edx, [rax]        
    mov     ecx, [rax+4]     
    mov     r8,  [rax+8]  
    mov     rax, 1
    call    fprintf

leave
ret



global OutFilm
OutFilm:
section .data
    .erFilm     db "Incorrect figure!",10,0
section .text
push rbp
mov rbp, rsp
    mov eax, [rdi]
    cmp eax, [FEATURE]
    je featureOut
    cmp eax, [CARTOON]
    je cartoonOut
    cmp eax, [DOCUMENTARY]
    je documentOut
    mov rdi, .erFilm
    mov rax, 0
    call fprintf
    jmp     return
featureOut:
    add     rdi, 4
    call    OutFeature
    jmp     return
cartoonOut:
    add     rdi, 4
    call    OutCartoon
    jmp     return
documentOut:
    add     rdi, 4
    call    OutDocumentary
    jmp     return
return:
leave
ret


global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1  
    .len    resd    1
    .FILE   resq    1   
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   
    mov [.len],   esi   
    mov [.FILE],  rdx   

    mov rbx, rsi            
    xor ecx, ecx           
    mov rsi, rdx            
.loop:
    cmp ecx, ebx           
    jge .return            

    push rbx
    push rcx

    mov     rdi, [.FILE]    
    mov     rsi, numFmt   
    mov     edx, ecx     
    xor     rax, rax,       
    call fprintf

    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutFilm    
    
    pop rcx
    pop rbx
    inc ecx               

    mov     rax, [.pcont]
    add     rax, 16        
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret