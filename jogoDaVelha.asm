; file: jogoDaVelha.asm
; Arquivo jogoDaVelha e pode ser usado para iniciar todos os programas de montagem
; Este programa demosntra como funciona adição e impressão
;-----------------
; * nasm -f win32 jogoDaVelha.asm              ou 
; nasm -g -f elf jogoDaVelha.asm
; - arquivo jogoDaVelha.obj é criado (montado)

; * nasm -f win32 asm_io.asm               nada 
; - arquivo asm_io.obj é criado (montado)

; * gcc -c -o driver.obj driver.c          ou
; gcc -o v jogoDaVelha.o driver.c asm_io.o
; - driver.c é compilado e arquivo driver.obj é criado

; * gcc -o v driver.obj jogoDaVelha.obj asm_io.obj   nada
; - os arquivos objeto sao ligados /"linkados" e executável jogoDaVelha.exe 

; * ./v.exe
; - arquivo.exe gerado e executado

%include "asm_io.inc"
segment  .data
; aqui os dados inicializados são colocados no segment .data
jogador1   	db "Jogador 0: ", 0       ; don't forget nul terminator
jogador2   	db "Jogador X: ", 0       ; don't forget nul terminator
xiz 		db "X", 0
bolinha		db "O", 0
nada		db "_", 0
linha1    	db "   |   |   ", 0
linha2    	db "   |   |   ", 0
linha3    	db "   |   |   ", 0
linha     	db "-----------", 0
jogadas   	db   0, 0, 0, 0, 0, 0, 0, 0, 0  ; vetor de 9 posições
linhaS		db "Identificação das posições: ",0 
linhaV		db "Tabuleiro para jogar: ",0 
linha4    	db " 1 | 2 | 3 ", 0
linha5    	db " 4 | 5 | 6 ", 0
linha6    	db " 7 | 8 | 9 ", 0

segment .bss
; Dados não inicializados, são colocados o segment .bss
input1  resd 1
segment .text
		global _asm_main
_asm_main:
		enter 0,0	;rotina de instalação
		pusha
	
; código é colocado na segmento de texto

mostra_posicoes:
		call 	print_nl
		mov 	eax, linhaS		
		call 	print_string
		call 	print_nl
		
		call 	print_nl
		mov 	eax, linha4		
		call 	print_string
		call 	print_nl

		mov 	eax, linha
		call 	print_string
		call 	print_nl

		mov 	eax, linha5
		call 	print_string
		call 	print_nl
		
		mov 	eax, linha
		call 	print_string
		call 	print_nl

		mov 	eax, linha6
		call 	print_string
		call 	print_nl
		call 	print_nl
		
mostra_tabuleiro:		
		mov 	eax, linhaV		
		call 	print_string
		call 	print_nl

		mov 	eax, linha1		
		call 	print_string
		call 	print_nl

		mov 	eax, linha
		call 	print_string
		call 	print_nl

		mov 	eax, linha2
		call 	print_string
		call 	print_nl
		
		mov 	eax, linha
		call 	print_string
		call 	print_nl

		mov 	eax, linha3
		call 	print_string
		call 	print_nl
		call 	print_nl
		
		mov 	eax, 0  ; O registrador eax = 0
		mov   	ebx, 9	;índice do vetor (9 posições), ebx é o registrador que conta as jogadas
		
inicio_loop: ; início do laço para pedir próxima jogada
		mov  	eax, ebx 
		cdq
		mov  	ecx, 2 ;
        idiv 	ecx   ; edx = eax/ecx
		cmp		edx, 0  ; joga o resto da divisão de eax por dois no edx, compara edx com zero para saber será o próximo jogador (MOD/2)
		je     jogadaJO
jogadaJX:
		mov 	eax, jogador2
		call	print_string
		call    read_int      ; lê um inteiro (posição escolhida)
		
		add		eax, -1 
		mov		ecx, 2
		mov		[jogadas + eax], ecx ;coloca o número 2 (X) na posição do vetor escolhida pelo jogador
		mov 	edx, 0 ; para o edx começar em 0
		call 	print_nl
		jmp		exibe_jogadas
        call	print_nl
jogadaJO:
		mov 	eax, jogador1
		call	print_string
		call 	read_int  ; lê um inteiro (posição escolhida) 
		
		add		eax, -1 
		mov		ecx, 1
		mov		[jogadas + eax], ecx ;coloca o número 1 (0) na posição do vetor escolhida pelo jogador
		mov 	edx, 0  ; para o edx começar em 0
	    call 	print_nl
exibe_jogadas:		
		mov 	al, [jogadas + edx] ; jogadas + posição do edx (0,X, nada)
		cmp 	al, 0
		jg 		maiorquezero ;pula
		mov 	eax, nada
		call 	print_string		
		jmp 	fim_ej
maiorquezero: ; 1 ou 2 (0 ou X)
		cmp 	al, 1
		jg 		maiorqueum ;pula
		mov 	eax, bolinha
		call 	print_string
		jmp 	fim_ej
maiorqueum:		; 2 (X)
		mov 	eax, xiz
		call 	print_string	
fim_ej:							;término do loop para exibição da jogada 
		cmp		edx, 2
		je		pula_linha
		cmp		edx, 5
		je		pula_linha
		jmp 	prox_jogada
pula_linha:
		call	print_nl
prox_jogada:	; parte final do laço para pedir próxima jogada	
		inc 	edx
		cmp 	edx, 9         ; compara edx com 9
		jne		exibe_jogadas  ; enquanto não for igual a 9, volta para exibe_jogadas (monta tabuleiro)							   

; verifica se ainda deve ser feita nova jogada
		add     ebx, -1
		cmp     ebx, 0   ; quando o ebx for zero, o jogo acaba
		call 	print_nl
		call 	print_nl
		jne	    inicio_loop ;pula
		jmp		fim		
fim:
			
; Não modifique o código antes ou após este comentário
		popa
		mov   eax, 0
		leave
		ret
		