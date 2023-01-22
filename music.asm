;podzielniki czestotliwosci
TC equ 34546; 1.19MHz/33Hz
TD equ 30811; 1.19MHz/37Hz
TE equ 27805; 1.19MHz/41Hz
TF equ 25909; 1.19MHz/44Hz
TG equ 23265; 1.19MHz/49Hz
TA equ 20727; 1.19MHz/55Hz
TH equ 18387; 1.19MHz/62Hz
TP equ 1;pauza
;Q koniec melodii

Przerwanie21 equ 21H
Przerwanie15 equ 15H

kod segment
assume cs:kod,ss:stosik,ds:dane;

;procedury
				
nuta proc
mov cx,7
mov dx,65535
mov ah,86h			
int Przerwanie15	
ret
nuta endp;

polnuta proc
mov cx,3
mov dx,65535
mov ah,86h
int Przerwanie15
ret
polnuta endp;

cwiercnuta proc
mov cx,1
mov dx,65535 
mov ah,86h
int Przerwanie15
ret
cwiercnuta endp

osemka proc
mov cx,0
mov dx,32000;
mov ah,86h
int Przerwanie15
ret
osemka endp;

sound proc
mov ax,ton	
mov dx,42h	
out dx,al
mov al,ah
out dx,al	

;Wlaczenie glosnika
	mov dx,61h			
	in al,dx;			
	or al,00000011B		
	out dx,al		
	ret	
	endp

;Wylaczenie glosnika
	nosound proc
	mov dx,61h
	in al,dx
	and al,11111100B
	out dx,al
	ret
	endp;

;Odtwarzanie
	play proc
	call sound
	cmp czas,1
	je cala
	cmp czas,2
	je pol
	cmp czas,4
	je cwierc
	cmp czas,8
	je osem
	jmp endplay

cala: 	call nuta
	jmp endplay

pol: 	call polnuta
	jmp endplay

cwierc: call cwiercnuta
	jmp endplay

osem: 	call osemka
	jmp endplay

endplay:call nosound
	ret
	endp


;Program
start: 		mov ax,dane 
		mov ds,ax 
		mov ax,stosik 
		mov ss,ax 
		mov sp,offset szczyt

			
		mov ah,62h
		int Przerwanie21
		mov es,bx
		mov si,80h
		xor ch,ch
		mov cl,es:[si]
		cmp cl,0
		je Domyslna
			
		dec cl
		inc si
		lea di,nazwaPliku
		push cx

zapisz:		inc si
		mov al,es:[si]
		mov ds:[di],al
		inc di
		loop zapisz
		pop cx	
		cmp cl,9
		jge Domyslna
		mov al,9		
		sub al,cl		
		mov cl,al		
		xor ch,ch		
		xor al,al	
uzupelnij:	mov ds:[di],al	
		inc di
		loop uzupelnij
				
	
Domyslna:	lea dx,nazwaPliku  
		mov ah,3Dh 		
		xor al,al		
		int Przerwanie21
		mov bx,ax		
	
		jnc plikOk 	
		lea dx,blad
		mov ah,09H
		int Przerwanie21
		jmp exit
	
						
plikOk:		xor cx,cx	
		xor	dx,dx
		mov ah,42h		
		mov al,2h	
		int Przerwanie21	
		mov	dlugosc,ax		
	
		xor cx,cx   		
		xor dx,dx        
		mov ah,42h			
		xor al,al			
		int Przerwanie21

		mov cx,dlugosc		
		lea dx,dzwiek		
		mov ah,3FH			
		int Przerwanie21
	
		mov ah,3eh  		
		int Przerwanie21
					
		lea dx,odtwarzam 	
		mov ah,09H
		int Przerwanie21	
				
			
		mov di,0 	
			
melodia:	lea bx,dzwiek		
		mov dl,ds:[bx+di]
		inc di		
		cmp dl,'Q'	
		jne do
		jmp exit
		
do:		cmp dl,'C'
		jne re
		mov ton,TC
		jmp graj
re:		cmp dl,'D'
		jne mi
		mov ton,TD
		jmp graj
mi:		cmp dl,'E'
		jne fa
		mov ton,TE
		jmp graj
fa:		cmp dl,'F'
		jne sol
		mov ton,TF
		jmp graj
sol:		cmp dl,'G'
		jne la
		mov ton,TG
		jmp graj
la:		cmp dl,'A'
		jne zi
		mov ton,TA
		jmp graj
zi:		cmp dl,'H'
		jne pauza
		mov ton,TH
		jmp graj

pauza:		mov ton,1 

			
graj:		mov cl,ds:[bx+di]	
		inc di 				
		sub cl,30h 			
		shr ton,cl			
								
			
		mov cl,ds:[bx+di]	
		inc di 			
		sub cl,30h			
		mov czas,cl			
		call play		
		jmp melodia 	

exit:		mov ax,4c00h
		int Przerwanie21

kod ends;


dane segment

dzwiek db 3000 dup('$')

ton dw 0
czas db 0
dlugosc dw 0

odtwarzam db 'Odtwarzanie pliku: '
nazwaPliku db 'nuty3.txt'
db 5 dup('$')
blad db 'Brak pliku$'


dane ends


stosik segment stack
dw 100h dup(0) 
szczyt label word 
stosik ends 
end start