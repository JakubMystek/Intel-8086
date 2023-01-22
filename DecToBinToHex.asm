Program segment
	       assume cs:Program, ds:dane, ss:stosik

	start: mov    ax,dane
	       mov    ds,ax
	       mov    ax,stosik
	       mov    ss,ax
	       mov    sp,offset szczyt

	       JMP    qwe                         	

	blad:  mov    ah,9                        	
	       mov    dx,offset error1
	       int    21h
	       mov    suma,0
	       JMP    qwe

	qwe:   mov    ah,9                        	
	       mov    dx,offset tekst2
	       int    21h

	       mov    dx,offset maks               	
	       mov    ah,0ah
	       int    21h

	       mov    di,10
	       xor    ch,ch
	       mov    cl,len
	       mov    si,k
	lap:   cmp    si,cx
	       je     save
	       mov    ax,suma
	       mul    di
	       jc     blad
	       mov    suma,ax
	       mov    bl,znaki[si]
	       sub    bl,30h
	       xor    bh,bh
	       cmp    bx,di
	       jnc    blad
	       add    suma,bx
	       jc     blad
	       inc    si
	       JMP    lap

	save:  xor    bh,bh                       	
	       
	       mov    ah,9                        	
	       mov    dx,offset tekst4
	       int    21h
	       mov    ah,2
	       mov    bx,suma
	       mov    cx,16
	b:	   mov    dl,'0'
	       rcl    bx,1
	       jnc    o
	       inc    dl
	o:     int    21h
	       loop   b

	       mov    ah,9                        	
	       mov    dx,offset tekst5
	       int    21h
	       mov    ah,2
	       mov    bx,suma
	       mov    cx,4
	h:     mov    si,000Fh
	       rol    bx,4
	       and    si,bx
	       mov    dl,hex[si]
		   int    21h
	       loop   h

    koniec:mov    ah,4ch                      	
	       mov    al,0
	       int    21h

Program ends

dane segment

	tekst2  db 10,13,'Podaj liczbe dziesietnie: ','$'
	tekst4  db 10,13,'Binarnie: ','$'
	tekst5  db 10,13,'Heksadecymalnie: ','$'
	error1   db 10,13,'Blad liczby, sprobuj ponownie! ','$'
	
	maks   db 5
	len   db 
	znaki db 6 dup(0)

	suma  dw 0
	k     dw 0

	hex   db '0123456789ABCDEF'

dane ends

stosik segment
	       dw     100h dup(0)
	       szczyt Label word
stosik          ends

end start