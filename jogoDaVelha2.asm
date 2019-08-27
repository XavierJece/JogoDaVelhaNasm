; file: jogoDaVelha2.asm
; Arquivo jogoDaVelha2 e pode ser usado para iniciar todos os programas de montagem
; Este programa demosntra como funciona adição e impressão
;-----------------
; * nasm -f win32 jogoDaVelha2.asm              ou 
; nasm -g -f elf jogoDaVelha2.asm
; - arquivo jogoDaVelha2.obj é criado (montado)

; * nasm -f win32 asm_io.asm               nada 
; - arquivo asm_io.obj é criado (montado)

; * gcc -c -o driver.obj driver.c          ou
; gcc -o v jogoDaVelha2.o driver.c asm_io.o
; - driver.c é compilado e arquivo driver.obj é criado

; * gcc -o jogoDaVelha2 driver.obj jogoDaVelha2.obj asm_io.obj   nada
; - os arquivos objeto sao ligados /"linkados" e executável jogoDaVelha2.exe 

; * ./jogoDaVelha2.exe
; - arquivo.exe gerado e executado

%include "asm_io.inc"
segment  .data
; aqui os dados inicializados são colocados no segment .data
intro		db " Esse é um jogo da memoria feito em Nasm, para testar o conhecimento", 0
jogador1   	db "Jogador 1 Digite posicao que deseja jogar: ", 0       ; don't forget nul terminator
jogador2   	db "Jogador 2 Digite posicao que deseja jogar: ", 0       ; don't forget nul terminator
posicoes	db "POSICOES: ", 0
barra 	 	db "| ", 0
espaco 	 	db " ", 0
tracos 	 	db "|---|---|---|", 0
tabuleiro	TIMES 10 dd 0  ; Declaração do vetor 
errou	 	db  " Voce digitou errado, tente novamente!", 0

segment .bss
; Dados são inicializados, são colocados, no segment .bss
flag	resd 1 ; Variavel para controle de subprogramas.
posicao	resd 1 ; Variavel para escolha da posicao do jogador

segment .text
		global _asm_main	
_asm_main:
		enter 	0,0		;rotina de instalação
		pusha
		
; código é colocado no segmeto de texto

		cld ; Limpa algo o lixo do registrador apondador

;Para deixar o Tabuleiro Inicialmente zerado -------------------------------------
_inicia_tabuleiro:
		mov 	esi, tabuleiro  ; ESI aponta para vetor da matriz1.
		mov 	edx, 0 ; contador do WHILE.
		mov		ebx, 0 ; Indice do vetor.
		
		mov 	eax, 4 ; Flag	=	4	=>	_intro
		mov 	[flag], eax ; Flag recebe 4.
		
_whileMatrixOne: 	; Loop para receber os valores da  primeira matriz.
		inc 	edx  ; Incrementa contador
		
		mov 	eax, 0 ; gravando 0(Zero) no registrador EAX.
		mov  	[esi+ebx], eax	; Move o valor gravado em EAX para o vetor na posicao onde o ESI aponta.
		
		add 	ebx, 4 ; Indice incrementa em 4(Bites[Por causa do tamanho do int]) pra ir para a proxima posicao do vetor. 
		
		cmp 	edx, 9
		jnge 	_whileMatrixOne ; Volta para a funcao _whileMatrixOne.
		
		call 	print_nl ; Pular linha.
		
		jmp 	_apresentaTabuleiro ; Pula para a funcao de apresentar a matriz.


;Apresentando a INTRO -------------------------------------
_intro:

	mov		eax, posicoes
	call	print_string
	call	print_nl

	mov 	eax, 1 ; Flag	=	1	=>	_jogador1
	mov 	[flag], eax ; Flag recebe 1.

	jmp		_apresentacaoPosicao

; Jogar -------------------------------------
_jogador1:
	mov		eax, jogador1	; Movendo Variavel para o regfistrador EAx
	call	print_string	; Apresentando para o usuário 
	
	call	read_int		; Lendo uma entrada
	dec		eax				; Subtraindo 1 da posição digitada
	mov		[posicao], eax	; Movendo a entrada para uma variavel

	; call	print_int

	mov 	eax, 1 ; Flag	=	1	=>	_jogador1
	mov 	[flag], eax ; Flag recebe 1.

	jmp		_verificarEntrada	;Pular Para o subPrograma que verifica se a enrtada está correta


_jogador2:
	mov		eax, jogador2	; Movendo Variavel para o regfistrador EAx
	call	print_string	; Apresentando para o usuário 
	
	call	read_int		; Lendo uma entrada
	dec		eax				; Subtraindo 1 da posição digitada
	mov		[posicao], eax	; Movendo a entrada para uma variavel
	
	; call	print_int	
	
	mov 	eax, 2 ; Flag	=	2	=>	_jogador2
	mov 	[flag], eax ; Flag recebe 2.
	
	jmp		_verificarEntrada	;Pular Para o subPrograma que verifica se a enrtada está correta


; ----------------- Fim ------------------------------		
_terminou:	; Funcao para ser chamada no fim da apresentacao do resultado para finalizar o programa.
	call 	print_nl

; Não modifique o código antes ou após este comentário
	popa
	mov 	eax, 0 ;return back to C
	leave
	ret 

;----------------Sub Programas-----------------------


; ----------------Sub Programas Apresentação tabuleiro------------------------

_apresentaTabuleiro: ; Sub programa de apresentacao das matrizes.
		
	mov 	ecx, 0 ; ECX contador para o loop.
	mov		ebx, 0 ; EBX sera usado como indice.
	mov 	edx, 0 ; EDX sera usado para controlar quando pular linha para a apresentacao da matriz.
	
	mov 	eax, tracos 
	call 	print_string 		  		; Imprime tracos.	
	call 	print_nl

_whileApresentaTabuleiro: 	; Loop para receber os valores da  primeira matriz.
		
	inc 	ecx 
	inc 	edx
	
	mov 	eax, barra 
	call 	print_string ; Imprime barra.
	
	mov		eax, [esi+ebx]  ; Move o valor do vetor que o ESI esta apontando para o registrador EAX.
	call 	print_int  ; Imprime o valor.
	
	mov 	eax, espaco ; Imprime espaco.
	call 	print_string
	
	add 	ebx, 4  ; Adiciona 4 para o ebx, posteriormente fazendo que o ESI aponte para a proxima posicao do vetor.	

	cmp		edx, 3 	   ; Compara se EDX e igual a 3.
	jge		_pulaLinha ; Se sim, ir para o sub programa _pulaLinha.

	jmp 	_whileApresentaTabuleiro 

_pulaLinha: ; Sub programa para pular linha na apresentacao da matriz

	mov 	eax, barra 
	call 	print_string ; Imprime barra.

	mov 	edx, 0 				  ;Zerando o EDX novamente para continuar sendo contado ate 3.
	call 	print_nl
	
	mov 	eax, tracos 
	call 	print_string 		  		; Imprime tracos.	
	call 	print_nl 			  		; pula linha.
	
	cmp		ecx, 9 	   ; Compara se ECX e igual a 9.
	jge		_verificaFlag ; Se sim, encerrar programa

	jmp 	_whileApresentaTabuleiro 	; Volta para o sub programa _compara.

; ----------------Sub Programas Apresentação Posição------------------------

_apresentacaoPosicao: ; Sub programa de apresentacao das matrizes.
		
	mov 	ecx, 0 ; ECX contador para o loop.
	mov 	edx, 0 ; EDX sera usado para controlar quando pular linha para a apresentacao da matriz.

	mov 	eax, tracos 
	call 	print_string 		  		; Imprime tracos.	
	call 	print_nl

_whileApresentaPosicao: 	; Loop para receber os valores da  primeira matriz.
		
	inc 	ecx 
	inc 	edx
	
	mov 	eax, barra 
	call 	print_string ; Imprime barra.
	
	mov		eax, ecx  ; Move o valor do vetor que o ecx esta apontando para o registrador EAX.
	call 	print_int  ; Imprime o valor.
	
	mov 	eax, espaco ; Imprime espaco.
	call 	print_string

	cmp		edx, 3 	   ; Compara se EDX e igual a 3.
	jge		_pulaLinhaP ; Se sim, ir para o sub programa _pulaLinha.

	jmp 	_whileApresentaPosicao

_pulaLinhaP: ; Sub programa para pular linha na apresentacao da matriz

	mov 	eax, barra 
	call 	print_string ; Imprime barra.

	mov 	edx, 0 				  ;Zerando o EDX novamente para continuar sendo contado ate 3.
	call 	print_nl
	
	mov 	eax, tracos 
	call 	print_string 		  		; Imprime tracos.	
	call 	print_nl 			  		; pula linha.
	
	cmp		ecx, 9 	   ; Compara se EDX e igual a 3.
	jge		_verificaFlag ; Se sim, encerrar programa

	jmp 	_whileApresentaPosicao 	; Volta para o sub programa _compara.

; ----------------Sub Programas para verificar se a posição está correta ------------------------
_verificarEntrada: 

	; Verificando ver jogo
	mov		eax,	9
	cmp		eax,	[posicao]
	je		_verJogo

	; Verificando se a posição é menor a Zero
	mov		eax,	0
	cmp		[posicao],	eax
	jl		_apresentarError

	; Verificando se a posição é mais ou igual a NOVE
	mov		eax,	9
	cmp		[posicao],	eax
	jge		_apresentarError
	
	; Verificando se a posição já está sendo usada
	mov 	esi, tabuleiro          ;Copia a tabuleiro um para o Registrador apontador ESI.
	
	mov		eax,	[posicao]    
	mov		ebx,	4
	mul		ebx
	mov		ebx,	eax

	mov 	ecx,	1
	mov		eax,	[esi+ebx]
	call	print_int
	cmp 	eax,	ecx
	jge		_apresentarError
	jmp		_addPeca

_apresentarError:
	mov		eax, errou
	call	print_string
	call	print_nl

	jmp		_verificaFlag
	
_addPeca:

	mov		eax,	[flag]
	mov		[esi+ebx],	eax

	cmp		eax, 1
	je		_aleteraJogador1

	cmp		eax, 2
	je		_aleteraJogador2
	
_aleteraJogador1:
	mov		eax,	2
	mov		[flag], eax

	jmp		_verificaFlag

_aleteraJogador2:
	mov		eax,	1
	mov		[flag], eax

	jmp		_verificaFlag

_verJogo:
	; mov		eax,	0
	; mov		[flag], eax

	jmp		_apresentaTabuleiro

; ----------------------------------------------------

_verificaFlag: ; Função para saber para onde tenho que ir

	; Flag	=	0	=>	_terminou
	; Flag	=	1	=>	_jogador1 
	; Flag	=	2	=>	_jogador2
	; Flag	=	3	=>	_inicia_tabuleiro
	; Flag	=	4	=>	_intro
	; Flag	=	5	=>	_verJogo
	
	mov		eax, 0
	cmp		[flag], eax
	je		_terminou
	
	mov		eax, 1
	cmp		[flag], eax
	je		_jogador1

	mov		eax, 2
	cmp		[flag], eax
	je		_jogador2

	mov		eax, 3
	cmp		[flag], eax
	je		_inicia_tabuleiro

	mov		eax, 4
	cmp		[flag], eax
	je		_intro

	mov		eax, 5
	cmp		[flag], eax
	je		_verJogo
