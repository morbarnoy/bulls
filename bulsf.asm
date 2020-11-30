locals
dseg segment    
    counter dw ? 
    win dw 0
bull db,0
    lines dw 0 
      checkss dw 0 
   placedh db 0
   hit db,0 
  check2 db 0 
     enddx dw 0
     endcx dw 0  
     enddcx dw 0  
     fortest dw 0
    rows dw 0 
    sizebox dw 0 
    temc dw 0
    temd dw 0 
     temax dw 0
     tembx dw 0 
    endX dw ?
    endY dw ?
    halfbox dw ?
    color db ?
    placecx dw 0
    placedx dw 0
    sizeofpointer dw ?      
    direction db ?
    dig db 10 dup(?)
    colorss db 10 dup(?)
    guess db 10 dup(?)  
starta dw 0;amuda
   starts dw 0;shura     
   
dseg ends
cseg segment
   assume cs:cseg, ds:dseg
   ;+=================
   board proc  
    ; read from memory    
   ; calculate 
   mov ax,lines 
   mov bx, sizebox
   mul bx 
   mov endX,ax
   mov bx,starta
   add endX,bx ; lines 
   mov ax,rows
   mov bx, sizebox
   mul bx
   mov endY, ax; lines
   mov bx, starts
   add endy,bx
   mov bx,sizebox   
   ;==         
    mov ah,0ch
    mov al,7; color
    mov bh,0   
    mov cx,starta;amuda
    mov dx,starts;shura
horizontal :  
    shoov:  
    int 10h
    inc cx
    cmp cx ,endx;lines + distance 
    jc shoov
    add dx,sizebox;distance 
    mov cx, starta;starting point
    cmp dx,endy; lines +distance 
    jc  horizontal    
    ;================
  mov cx,starta;amuda
    mov dx,starts;shura
    mov enddx,0
    mov endcx,0
    verticale :    
    shoov1:
    int 10h
    inc dx
    cmp dx ,endy;lines + distances
    jc shoov1
    mov dx,starts
    add cx,sizebox;distances
    cmp cx,endx;distanceS+lines  
    jc  verticale   
    shoov2:
    int 10h
    inc dx
    cmp dx ,endy;lines + distances
    jc shoov2
    mov cx,starta
    shoov3:  
    int 10h
    inc cx
    cmp cx ,endx;lines + distance 
    jc shoov3
    ret 
    board endp
    ;===================
    colorin proc 
    mov ah,0ch
    mov al,color
    mov bh,0 
    
    mov enddx, dx
    add enddx,40
    mov endcx, cx
    add endcx ,40
    
    @@shdx:
    inc dx 
    int 10h
    cmp dx, enddx
    jnz @@shdx
    @@shcx:
    sub dx,40
    inc cx
    int 10h
    cmp cx,endcx
    jnz @@shdx    
    ret 
    colorin endp
   ;=============== 
   tests proc 
   push bx  dx ax
 ;bulls  
   mov dh, placedh
   ; fixes the messed up rows 
   normal:
   mov ah ,02h
   add dh, 2h
   cmp placedh, 6
   jz @@fix 
   cmp placedh, 9
   jz @@fix 
   cmp placedh, 12
   jz @@fix 
   
   
   jmp @@here
 @@fix:  
   add dh, 1  
  @@here:
   mov dl,17h
   mov bh,0 
   mov placedh,dh 
  int 10h 
  ; end of fixing the mess 
   
  mov si,0
  mov bull,0
  @@check1:
  mov bl, guess[si]; 
  cmp bl,dig[si]
  jz bull1
   
  done:
  cmp si,4
  jnz checkfix
  jmp @@exit
 
  bull1:
  inc bull
  jmp done
 
  checkfix:
  inc si 
  jmp @@check1
 
  @@exit:   
     mov dl,bull
     add dl,30h
     mov ah,2
     int 21h
     
  cmp bull,5; checks win  
  jz @@win
;;;;hits     
 mov si,0
 mov di,0
 mov hit,0
checkh:
mov bl, guess[si]
cmp bl,dig[di]
jz hits1 
doneh:; checks if its done 
cmp si,4
jnz fix1
cmp di,4
jnz fix2
jmp @@exit1
 
fix1:
 inc si 
 jmp checkh 
 
 fix2:
 mov si,0
 inc di
 jmp checkh 
 
 hits1:
 inc hit
 cmp hit,5 
 jnz doneh 
 mov fortest,1 
 jmp doneh
 
  
 @@exit1:
      mov ah ,02h
      mov bh,0
      mov dl,33h
      int 10h
      ; moves cursur to the right place 
      mov dl,hit
      add dl,30h
      mov ah,2
      int 21h
      jmp @@donee
      @@win:; detects winning 
      mov win,1
   
      @@donee:; so that is doesnt say win everytime   
      pop bx dx ax 
    
   ret 
   tests endp
   ;==========
   
   ;=========
   choose proc
   @@print1:
    inc counter 
    inc cx 
    mov ah,0ch
    mov al,6; color
    mov bh,0
    int 10h     
    cmp counter , 10
    jnz @@print1
    mov counter,0
    sub cx, 10
    
 mov temc,cx
mov temd,dx
   cmp cx,140 
   jc  one
   cmp cx ,180
   jc two 
   cmp cx,220 
   jc  three
   cmp cx, 260
   jc four 
   cmp cx,300 
   jc  five
   cmp cx,340
   jc six 
   cmp cx,380
   jc  seven
   cmp cx ,420
   jc eight
   cmp cx,460 
   jc  nine
   cmp cx,500
   jc ten   
 one :
mov si,0
mov bl,0
jmp @@print
two :
mov si,1
mov bl,1
jmp @@print
three :
mov si,2
mov bl,2
jmp @@print
four :
mov si,3
mov bl,3
jmp @@print
five :
mov si,4
mov bl,4
jmp @@print
six :
mov si,5
mov bl,5
jmp @@print
seven :
mov si,6
mov bl,6
jmp @@print
eight :
mov si,7
mov bl,7
jmp @@print 
nine :
mov si,8
mov bl,8
jmp @@print
ten :
mov si,9
mov bl,9
jmp @@print
@@print:
cmp  checkss,1; are we guessing or is this the set up part 
jz second
first:
mov dig[di],bl
jmp @@later
second:
mov guess[di],bl
@@later:
mov cx,placecx
mov dx,placedx
mov bl,colorss[si]
mov color,bl 
call colorin
mov cx,temc
mov dx,temd
ret 
choose endp
   ;==================  
    start:
     mov ax, dseg
            mov ds, ax
            mov al, 12h
            mov ah, 0h
            mov bh, 0
            int 10h
             mov al, 12h
             
          
    int 10h; make board
    ; to enter in the code 
     mov starta,100;amuda
    mov starts,420;shura
     mov lines, 10
    mov rows , 1 
    mov sizebox , 40; distance
    call board
    mov dx,starts
    mov cx,stARTA
    mov color,2
    mov si,0
    ; to color in the code in the box 
   coloring:  
    call colorin       
    mov bl,color
    mov colorss[si],bl
    add color, 3
    inc si
    cmp cx,endx
    jnz coloring
    
    mov starta,100;amuda
    mov starts,100;shura
    mov lines, 5
    mov rows , 1 
    mov sizebox , 40; distance
    call board
    mov ax,lines 
    mov bx, sizebox
   mul bx 
   add ax,100  
   mov enddcx,ax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
   ;keta code moving and choosing       
 mov cx,120; amuda 
 mov dx, 470 ; shura 
 mov placecx,100
 mov placedx,100
mov di,0   
    waiting1: 
    mov ah,7 
    int 21h
    mov direction, al 
    jmp clean1
    check1:    
    cmp direction,'d'    
    jz right1
    cmp  direction,'a'    
    jz left1
    cmp  direction,'s'    
    jz sselect1
        
right1:
cmp cx,470
jg print11
add cx,sizebox
jmp print11 
left1:
cmp cx,130
jl print11
sub cx,sizebox
jmp print11 
sselect1:
push cx  
mov checkss,0
call choose
add placecx,40
inc di

mov cx,enddcx  
cmp placecx,cx
pop cx
jnc donee

jmp waiting1  
 

donee:; 
mov check2,1
jmp clean1 

    
print11:; makes the cursour 
    inc counter 
    inc cx 
    mov ah,0ch
    mov al,6; color
    mov bh,0
    int 10h     
    cmp counter , 10
    jnz print11
    mov counter,0
    sub cx, 10
    jmp waiting1 

    clean1:; deletes the cursour 
    inc counter
    inc cx    
    mov ah,0ch
    mov al,0; color
    mov bh,0
    int 10h
    cmp counter , 10
    jnz clean1
    mov counter,0
    sub cx,10 
  cmp check2,0  
  jnz after
  jmp check1
  
after:; after i made the secret code 
mov color,0 ; cleans the secret code 
mov cx,100
mov dx,100
repeat1:
call colorin
cmp cx,310
jc repeat1  
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov ah,2
mov bh,0 
mov dl ,15h 
mov dh ,0h 
int 10h
 mov dl,'b'     
     int 21h
     mov dl,'u'     
     int 21h
     mov dl,'l'     
     int 21h
     mov dl,'l'     
     int 21h
     mov dl,'s'     
     int 21h
    
     
mov ah,2
mov bh,0 
mov dl ,33h 
mov dh ,0h 
int 10h
mov dl,'c'     
     int 21h
     mov dl,'o'     
     int 21h
     mov dl,'w'     
     int 21h
      mov dl,'s'     
     int 21h
   
    mov starta,200;amuda
    mov starts,10;shura     ;sets up
    mov lines, 5
    mov rows , 10 
    mov sizebox , 40; distance 
    call board
  mov starta,100;amuda
    mov starts,420;shura
     mov lines, 10
    mov rows , 1   
;===========================
; keta code for moving while guessing 
;==========================
 mov ax,lines 
   mov bx, sizebox
   mul bx   
   mov enddcx,ax
   
 mov cx,120; amuda 
 mov dx, 470 ; shura 
 mov placecx,200
mov placedx,10
mov di,0

   
    waiting: 
    mov ah,7 
    int 21h
    mov direction, al 
    jmp clean
    check:    
    cmp direction,'d'    
    jz right
    cmp  direction,'a'    
    jz left
    cmp  direction,'s'    
    jz sselect
    
right:
cmp cx,470
jg print1
add cx,sizebox
jmp print1 
left:
cmp cx,130
jl print1
sub cx,sizebox
jmp print1 
sselect:
mov checkss,1
call choose
add placecx,40
inc di
push cx
mov cx,enddcx  
cmp placecx,cx
pop cx
jnc testing
jmp waiting 

print1:; makes the cursour 
    inc counter 
    inc cx 
    mov ah,0ch
    mov al,6; color
    mov bh,0
    int 10h     
    cmp counter , 10
    jnz print1
    mov counter,0
    sub cx, 10
    jmp waiting 
    
    clean:; deletes the cursour 
    inc counter
    inc cx    
    mov ah,0ch
    mov al,0; color
    mov bh,0
    int 10h
    cmp counter , 10
    jnz clean
    mov counter,0
    sub cx,10   
    jmp check     
 
testing:; checks how much you were right - bulls and hits
call tests

cmp fortest,1
jz yesssss
boop:
cmp win,1
jz winner
mov di,0
add placedx,40
mov placecx,200
cmp placedx,400
jg loose 
jmp waiting 
loose:
 int 10h
 mov dl,'l'
     mov ah,2
     int 21h
     mov dl,'o'
     mov ah,2
     int 21h
     mov dl,'o'
     mov ah,2
     int 21h 
      int 10h
      mov dl,'o'
     mov ah,2
     int 21h
     mov dl,'s'
     mov ah,2
     int 21h
     mov dl,'e'
     mov ah,2
     int 21h 
     jmp exit 
     yesssss:
 int 10h
 mov dl,'b'
     mov ah,2
     int 21h
     mov dl,'o'
     mov ah,2
     int 21h
     mov dl,'b'
     mov ah,2
     int 21h
  jmp boop 
winner:      
     int 10h
     mov dl,'w'
     mov ah,2
     int 21h
     mov dl,'i'
     mov ah,2
     int 21h
     mov dl,'n'
     mov ah,2
     int 21h 
     jmp exit 
  
exit :
 mov ah, 4ch
 int 21h
cseg ends 
end start
