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
sTabuleiro	db "Tabuleiro: ", 0
posicoes	db "POSICOES: ", 0
barra 	 	db "| ", 0
espaco 	 	db " ", 0
tracos 	 	db "|---|---|---|", 0
tabuleiro	TIMES 10 dd 0  ; Declaração do vetor 
errou	 	db  " Voce digitou errado, tente novamente!", 0
deuCampeao	db  " O CAMPEAO FOI: ", 0


segment .bss
; Dados são inicializados, são colocados, no segment .bss
flag			resd 1 ; Variavel para controle de subprogramas.
posicao			resd 1 ; Variavel para escolha da posicao do jogador
jogadorJogando	resd 1 ; Variavel para controle dos Jogadores

segment .text
		global _asm_main	
_asm_main:
		enter 	0,0		;rotina de instalação
		pusha
		
; código é colocado no segmeto de texto

		cld ; Limpa algo o lixo do registrador apondador

;Para deixar o Tabuleiro Inicialmente zerado -------------------------------------
_inicia_tabuleiro:
		mov 	esi,	tabuleiro			; ESI aponta para vetor da matriz1.
		mov 	edx,	0					; contador do WHILE.
		mov		ebx,	0					; Indice do vetor.
		
		mov 	eax,	4					; Flag	=	4	=>	_intro
		mov 	[flag],	eax 				; Flag recebe 4.

		mov		eax,	1					; JogadorJogando	=>	1
		mov		[jogadorJogando],	eax		; JogadorJogando	=>	1
		
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

	mov 	eax,	[jogadorJogando]				; Flag	=	jogadorJogando	=>	_jogador1
	mov 	[flag],	eax 							; Flag recebe jogadorJogando.

	jmp		_apresentacaoPosicao

; Jogar -------------------------------------
_jogador1:
	call	print_nl
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
	call	print_nl
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
	
	mov		eax,	sTabuleiro
	call	print_string
	call	print_nl

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

	call	print_nl
	mov		eax,	posicoes
	call	print_string
	call	print_nl

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
	jge		_verificaFlag ; Se sim, encerrar SUBprograma

	jmp 	_whileApresentaPosicao 	; Volta para o sub programa _compara.

; ----------------Sub Programas para verificar se a posição está correta ------------------------
_verificarEntrada: 

	; Verificando ver jogo
	mov		eax,	-1
	cmp		eax,	[posicao]
	je		_terminou

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
	mov		[jogadorJogando], eax

	mov		eax, 6
	mov		[flag],	eax

	jmp		_verificaFlag

_aleteraJogador2:
	mov		eax,	1
	mov		[jogadorJogando], eax

	mov		eax, 6
	mov		[flag],	eax

	jmp		_verificaFlag
; ----------------Apresentação do Jogo-----------------------
; _verJogo:
; 	; mov		eax,	0
; 	; mov		[flag], eax

; 	jmp		_apresentaTabuleiro

_continuaJogo:
	call	print_nl
	call	print_nl
	mov		eax,	sTabuleiro
	call	print_string
	call	print_nl

	mov		eax,	4
	mov		[flag],	eax

	jmp		_apresentaTabuleiro


; ----------------verifica Fim De Jogo-----------------------
_verificaColuna1:

	; Inicializando Registradores para fazer a comparação
	mov		eax, 0
	mov		ebx, 0				;Número na Posição 0
	mov		ecx, 0
	mov		edx, 0
	mov		esi, tabuleiro

	; Função para verificar a Primeira Coluna (0 3 6)
	; Verificação de Todas as Posições tem peça
	cmp		eax, [esi+ebx]		; Vendo se na Posição 0 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		ecx, [esi+ebx]		; O ECX tem a peça Posição 0
	add		ebx, 12				; Deixando o EBX na posição certa

	cmp		eax, [esi+ebx]		;Vendo se na Posição 3 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		edx, [esi+ebx]		; O EDX tem a peça Posição 3
	add		ebx, 12	

	cmp		eax, [esi+ebx]		;Vendo se na Posição 6 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		eax, [esi+ebx]		; O ADX tem a peça Posição 6

	; Verificação se Todas as Posições tem a mesma Peça
	cmp		ecx, edx			;Vendo se a Posição 0 3 tem peças =
	jne		_verificaColuna2	;Peças !=

	cmp		ecx, eax			;Vendo se a Posição 0 6 tem peças =
	je		_campeao			;Peças = (Coluna toda igual, alguem ganhou)

_verificaColuna2:

	; Inicializando Registradores para fazer a comparação
	mov		eax, 0
	mov		ebx, 4				;Número na Posição 1
	mov		ecx, 0
	mov		edx, 0
	mov		esi, tabuleiro

	; Função para verificar a Primeira Coluna (1 4 7)
	; Verificação de Todas as Posições tem peça
	cmp		eax, [esi+ebx]		; Vendo se na Posição 1 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		ecx, [esi+ebx]		; O ECX tem a peça Posição 1
	add		ebx, 12				; Deixando o EBX na posição certa

	cmp		eax, [esi+ebx]		;Vendo se na Posição 4 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		edx, [esi+ebx]		; O EDX tem a peça Posição 43
	add		ebx, 12	

	cmp		eax, [esi+ebx]		;Vendo se na Posição 7 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		eax, [esi+ebx]		; O ADX tem a peça Posição 7

	; Verificação se Todas as Posições tem a mesma Peça
	cmp		ecx, edx			;Vendo se a Posição 1 4 tem peças =
	jne		_verificaColuna3	;Peças !=

	cmp		ecx, eax			;Vendo se a Posição 1 7 tem peças =
	je		_campeao			;Peças = (Coluna toda igual, alguem ganhou)

_verificaColuna3:
	; Inicializando Registradores para fazer a comparação
	mov		eax, 0
	mov		ebx, 8				;Número na Posição 2
	mov		ecx, 0
	mov		edx, 0
	mov		esi, tabuleiro

	; Função para verificar a Primeira Coluna (2 5 8)
	; Verificação de Todas as Posições tem peça
	cmp		eax, [esi+ebx]		; Vendo se na Posição 2 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		ecx, [esi+ebx]		; O ECX tem a peça Posição 2
	add		ebx, 12				; Deixando o EBX na posição certa

	cmp		eax, [esi+ebx]		;Vendo se na Posição 5 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		edx, [esi+ebx]		; O EDX tem a peça Posição 5
	add		ebx, 12	

	cmp		eax, [esi+ebx]		;Vendo se na Posição 8 não tem peça
	je		_continuaJogo		; Posição Vazia
	mov		eax, [esi+ebx]		; O ADX tem a peça Posição 8

	; Verificação se Todas as Posições tem a mesma Peça
	cmp		ecx, edx			;Vendo se a Posição 2 5 tem peças =
	jne		_continuaJogo	;Peças !=

	cmp		ecx, eax			;Vendo se a Posição 2 8 tem peças =
	je		_campeao			;Peças = (Coluna toda igual, alguem ganhou)

; _verificaLinha1:
; _verificaLinha2:
; _verificaLinha3:

_campeao:

	call	print_nl
	mov		eax,	deuCampeao
	call	print_string
	
	mov		eax,	ecx
	call	print_int
	call	print_nl
	call	print_nl

	mov		eax,	0
	mov		[flag],	eax

	jmp		_apresentaTabuleiro
; ----------------------------------------------------

_verificaFlag: ; Função para saber para onde tenho que ir

	; Flag	=	0	=>	_terminou
	; Flag	=	1	=>	_jogador1 
	; Flag	=	2	=>	_jogador2
	; Flag	=	3	=>	_inicia_tabuleiro
	; Flag	=	4	=>	_intro
	; Flag	=	5	=>	_verJogo
	; Flag	=	5	=>	_verificaColuna1
	
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

	; mov		eax, 5
	; cmp		[flag], eax
	; je		_verJogo
	
	mov		eax, 6
	cmp		[flag], eax
	je		_verificaColuna1
