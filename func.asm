extern FEATURE
extern CARTOON
extern DOCUMENTARY

global FILM_FUNC
FILM_FUNC:

section .text
push rbp
mov rbp, rsp
    
    
    
    mov rcx, 5 
    cmp dword [rdi], 10000          
    jae done
    dec rcx                  
    cmp dword [rdi], 1000          
    jae done
    dec rcx       
    cmp dword [rdi], 100          
    jae done
    dec rcx               
    cmp dword [rdi], 10         
    jae done
    dec rcx 
    jae done 
    
done:
section .bss
    .count     resb 8
    .res       resb 8
section .text
    mov [.count], rcx
    mov r10, [.count]
    
    finit
    ;add rdi, 4
    mov r11d, [rdi+4]
    mov [.res], r11d
    fld dword [.res]
    fidiv dword [.count]
    fst dword [.res]
    mov r10, [.res]
    


leave
ret

global ContainerFuncAverage
ContainerFuncAverage:
section .data
    .sum    dq  0.0
section .text
push rbp
mov rbp, rsp
    ;xor r12, r12 
    mov r12d, esi            ;r12d -> ebx
    xor r13d, r13d            ;r13d -> ecx
    movsd xmm1, [.sum]      
.loop:
    cmp r13d, r12d            
    jge .return            

    mov r11, rdi           
    call FILM_FUNC 
    cvtsi2sd  xmm0, r10         
    addsd xmm1, xmm0      
    inc r13                 
    add r11, 16            
    mov rdi, r11           
    jmp .loop
.return:
    movsd xmm0, xmm1
    
    ;finit
   ; movsd [.sum], xmm0
   ; fld dword [.sum]
   ; fidiv dword [ecx]
   ; fst dword [.sum]
  ;  movsd xmm0, [.sum]
    
    
leave
ret
