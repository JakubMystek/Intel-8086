_code segment
assume cs:_code, ds:_data, ss:_stack

start: mov ax,_data
mov ds,ax
mov ax,_stack
mov ss,ax
mov sp,offset top

; your code goes	
mov ax,0b800h
mov es,ax
mov di,0
mov al,65d
mov ah,32d
mov bx,1
mov cx,39
petla: push bx
push cx
push cx
call spacje
call znaki
pop cx
inc cx
call spacje
pop cx
pop bx
inc al
inc bx
inc bx
dec cx
cmp al,80d
jnz petla
jmp koniec

spacje: mov es:[di],ah
inc di
inc di
loop spacje
ret

znaki: mov es:[di],al
inc di
inc di
dec bx
jnz znaki
ret

koniec:
mov ah,4ch
mov al,0
int 21h
_code ends

_data segment
; your data goes here

_data ends

_stack segment stack
dw 100h dup(0)
top Label word
_stack ends

end start