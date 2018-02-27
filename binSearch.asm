;;;  Melanie Bancilhon
;;; Final spring 2017: binSearch.asm
;;; Recursive binary search program
;;; To assemble, link and run:
;;; 	nasm -f elf binSearchMain.asm
;;; 	nasm -f elf binSearch.asm
;;; 	nasm -f 231Lib.asm
;;; 	ld -melf_i386 -o binSearchMain binSearchMain.o binSearch.o 231Lib.o

        		global binSearch
	
                      section .data
key                     dd      0
mid                     dd      0

        		section .text

	            extern  _printInt
	            extern  _println

binSearch:		mov	ebp,esp

			mov	edi,dword[ebp+4] ;edi<--right
                        mov     ecx,dword[ebp+8] ;ecx<--left
			mov     ebx,dword[ebp+12]
			mov	dword[key],ebx ;dword[key]<--key
			mov	esi,dword[ebp+16] ;esi<--A
;;; if left>right
;;; return -1
			cmp	ecx,edi 
			jg	notFound
;;; calculate mid
;;; mid= (left+right)/2
			mov     edx,0
			mov     eax,ecx
			add     eax,edi
			mov     bx,2
			div     bx
			mov     dword[mid],eax

;;; multiply mid by 4
;;; find A[mid] index
			mov     ebx,4
			mul     ebx	       ;eax<--dword[mid]*4
			add     esi,eax	       ;esi<--esi+eax
			mov     edx,dword[esi] ;edx<-- A[mid]
;;; restore A pointer back to 0
			sub     esi,eax
	
;;; if key<A[mid]
;;;   binSearch(key,A,left,mid-1)
			cmp	dword[key],edx
			jl	keyLess
;;; if key>A[mid]
;;;   binSearch(key,A,mid+1,right)
			cmp     dword[key],edx
			jg      keyGreater
;;; else
;;; A[mid]==key
			mov	eax,dword[mid]

			ret
keyLess:
			dec	dword[mid] ;mid<--mid-1
			mov	edi,dword[mid] ;right<--mid
	
			push    esi
			push    dword[key]
			push    ecx
			push    edi

			call    binSearch
	
			pop     edi
			pop     ecx
			pop     ebx
			mov     dword[key],ebx
			pop     esi
	
			ret
keyGreater:
			inc     dword[mid] ;mid<--mid+1
			mov     ecx,dword[mid] ;left<--mid

			push    esi
			push    dword[key]
			push    ecx
			push    edi

			call    binSearch

			pop     edi
			pop     ecx
			pop     ebx
			mov     dword[key],ebx
			pop     esi

			ret

notFound:		mov	eax,-1 ;eax<-- -1
			ret
