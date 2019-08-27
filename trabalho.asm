; file: trabalho.asm
; Este arquivo é um modelo que pode ser usado para iniciar todos os programas de montagem
; Este numero demostra como funciona um programa que faz adições
; -------
; Como compilar
; * nasm -f win32 trabalho.asm
; - arquivo trabalho.obj é criado (montado)

; * nasm -f win32 asm_io.asm
; - arquivo asm_io.obj é criado (montado)

; * gcc -c -o driver.obj driver.c
; - driver.c é compilado e arquivo driver.obj é criado

; * gcc -o trabalho driver.obj trabalho.obj asm_io.obj
; - os arquivos objeto são ligados / “linkados” e o executável trabalho.exe é criado

; ./trabalho.exe
; - arquivo .exe gerado é executado

%include "asm_io.inc"
segment .data
; Aqui os dados inicializados são colocados, no segment .data
matriz1  TIMES 10 dd 0  ; Declaração do vetor 
matriz2  TIMES 10 dd 0
matriz3  TIMES 10 dd 0
saidaMatrizA db "Digite os indices da Matriz A:", 0
saidaMatrizB db "Digite os indices da Matriz B:", 0
elemento 		 db "Digite o elemento na posicao ", 0
dponto		 db ": ", 0
barra 	 	 db " | ", 0
tracos 	 	 db " -------------------", 0
escolhas 	 db " Digite  1- Adicao   2- Subtracao  ", 0
errou	 	 db  " Voce digitou errado, tente novamente!", 0

segment .bss
; Dados são inicializados, são colocados, no segment .bss
flag	resd 1 ; Variavel para controle de qual vetor o ESI deve apontar atraves de subprogramas.


segment .text
		global _asm_main	
_asm_main:
		enter 	0,0		;rotina de instalação
		pusha
		
; código é colocado no segmeto de texto

		cld ; Limpa algo o lixo do registrador apondador

;Recebendo Matriz 1 -------------------------------------		
_matriz1:
		mov 	esi, matriz1  ; ESI aponta para vetor da matriz1.
		mov 	edx, 0 ; contador do WHILE.
		mov		ebx, 0 ; Indice do vetor.
		
		mov 	eax, 1 ; Eax recebe 1 para passar para a flag, pois a variavel recebe indices somente de um registrador.
		mov 	[flag], eax ; Flag recebe 1.
		
		mov 	eax, saidaMatrizA ; Move a variavel para EAX para posteriormente ser apresentada.
		call 	print_string ; Printa o conteudo de EAX.
		call 	print_nl ; Pular linha.
		call 	print_nl
		
_whileMatrixOne: 	; Loop para receber os valores da  primeira matriz.
		inc 	edx  ; Incrementa contador
		
		mov 	eax, elemento ; imprime mensagem pedindo o elemento.
		call 	print_string
		
		mov 	eax, edx   ; imprime qual a posicao.
		call  	print_int 
		
		mov 	eax, dponto ; imprime dois ponto.
		call 	print_string
		
		call 	read_int ; Leitura do valor gravado no registrador EAX.
		mov  	[esi+ebx], eax	; Move o valor gravado em EAX para o vetor na posicao onde o ESI aponta.
		
		add 	ebx, 4 ; Indice incrementa em 4 pra ir para a proxima posicao do vetor. 
		
		cmp 	edx, 9
		jnge 	_whileMatrixOne ; Volta para a funcao _whileMatrixOne.
		
		call 	print_nl ; Pular linha.
		
		jmp 	_apresentaMatriz ; Pula para a funcao de apresentar a matriz.
		
;Recebendo Matriz 2 -------------------------------------
_matriz2:		
		call  	print_nl
		mov 	esi, matriz2 ; Aponta esi para o vetor matriz2.
		
		mov 	edx, 0 
		mov		ebx, 0
		
		mov 	eax, 2 ; Move o numero 2 para o registrador EAX.
		mov 	[flag], eax ; Move o numero de EAX para a variavel flag.
		
		mov 	eax, saidaMatrizB
		call 	print_string
		call 	print_nl
		call 	print_nl

_whileMatrixTwo: 	; Loop para receber os valores da segunda matriz.
		inc 	edx
		
		mov 	eax, elemento
		call 	print_string
		
		mov 	eax, edx
		call  	print_int 
		
		mov 	eax, dponto
		call 	print_string
		
		call 	read_int 
		mov  	[esi+ebx], eax	
		add 	ebx, 4
		
		cmp		edx, 9
		jnge 	_whileMatrixTwo
		
		call 	print_nl
	
		jmp 	_apresentaMatriz

; ---------------SWITCH--------------------------------		
_escolha: ; Funcao para escolher qual operacao fazer (adicao ou subtracao).
		
		mov 	eax, 3
		mov 	[flag], eax ; Movendo o numero 3 para a flag.
		
		call 	print_nl
		mov 	eax, escolhas
		call 	print_string
		
		call 	read_int ; Recebe o digito do usuario
		
		mov 	ebx, 0
		mov 	ecx, 9 	 ; Move 9  para o ECX que sera usado para o loop de apresentação do resultado.     
		
		cmp		eax, 1 	 ; Comparacao para saber se o que foi digitado foi o numero 1.
		je 		_adicao	 ; Caso sim, ir para a funcao de adicao.
		
		cmp 	eax,2 	 ; Comparacao para saber se o que foi digitado foi o numero 2.
		je		_subtracao ; Caso sim, ir para a funcao de subtracao.
		
		mov 	eax, errou ; Se o usuario digitou algum outro numero, o sistema mostrada uma mensagem de erro.
		call 	print_string
		jmp 	_escolha ; E voltara para a funcao de escolha oara que o usuario digite novamente.

; ----------------- Fim ------------------------------		
_terminou:	; Funcao para ser chamada no fim da apresentacao do resultado para finalizar o programa.
		call 	print_nl
		
		
		
		
; Não modifique o código antes ou após este comentário
		popa
		mov 	eax, 0 ;return back to C
		leave
		ret 

;----------------Sub Programas-----------------------

; ------------ _MOVS ---------------------------------
_mov1:	; Esses sub programa (_mov1, _mov2, _mov3), servem para apontar o ESI para o vetor desejado.
		mov 	esi, matriz1
		jmp 	_continuacao
		
_mov2:		
		mov 	esi, matriz2
		jmp 	_continuacao
		
_mov3:		
		mov 	esi, matriz3
		jmp 	_continuacao

; ----------------------------------------------------

_apresentaMatriz: ; Sub programa de apresentacao das matrizes.
		
		mov 	ecx, 0 ; ECX contador para o loop.
		mov		ebx, 0 ; EBX sera usado como indice.
		mov 	edx, 0 ; EDX sera usado para controlar quando pular linha para a apresentacao da matriz.
		
		call 	print_nl
		mov		eax, tracos ; Imprime tracos.
		call 	print_string
		call 	print_nl
		
		mov 	eax, 1 ; Comparacao da flag para saber qual vetor o ESI deve apontar usando os sub programas _MOVS.
		cmp 	[flag], eax
		je 		_mov1  ; Se flag igual a 1, ir para _mov1.
		
		mov 	eax, 2
		cmp 	[flag], eax
		je 		_mov2  ; Se flag igual a 2, ir para _mov2.

		mov 	eax, 3
		cmp 	[flag], eax
		je 		_mov3  ; Se flag igual a 3, ir para _mov3.
		
_continuacao: ; Sub programa para continuacao da apresentacao.
		
		inc 	ecx 
		inc 	edx
		
		mov 	eax, barra 
		call 	print_string ; Imprime barra.
		
		mov		eax, [esi+ebx]  ; Move o valor do vetor que o ESI esta apontando para o registrador EAX.
		call 	print_int  ; Imprime o valor.
		
		mov 	eax, barra ; Imprime barra.
		call 	print_string
		
		add 	ebx, 4  ; Adiciona 4 para o ebx, posteriormente fazendo que o ESI aponte para a proxima posicao do vetor.
		
		cmp		edx, 3 	   ; Compara se EDX e igual a 3.
		jge		_pulaLinha ; Se sim, ir para o sub programa _pulaLinha.
		
_compara: ; Sub programa para comparar os proximos passos do sistema.
		
		cmp		ecx,8  ; Compara ECX com 8.
		jng 	_continuacao ; Se nao for maior, volte para o sub programa _continuacao.
		
		mov 	eax, 1 
		cmp  	[flag], eax ; Comparar a flag com o 1.
		je		_maer dizetriz2   ; Se for igual, qur que o sistema apresentou a primeira matriz e agora deve ir para a funcao _matriz2.
		
		mov 	eax, 2
		cmp 	[flag], eax ; Comparar a flag com o 2.
		je 		_escolha   ; Se for igual, quer dizer que o sistema apresentou a segunda matriz e agora deve ir para a funcao _escolha.
		
		mov 	eax, 3 
		cmp 	[flag], eax ; Comparar a flag com o 3. 
		je 		_terminou   ; se for igual, quer dizer que o sistema apresentou todas as matrizes e deve finalizar.
		
_pulaLinha: ; Sub programa para pular linha na apresentacao da matriz

		mov 	edx, 0 				  ;Zerando o EDX novamente para continuar sendo contado ate 3.
		call 	print_nl
		
		mov 	eax, tracos 
		call 	print_string 		  ; Imprime tracos.	
		call 	print_nl 			  ; pula linha.
		jmp 	_compara 			  ; Volta para o sub programa _compara.
		
;Inicio do SubPrograma de Para Fazer a Adição entre Matriz A e Matriz B
_adicao:
		mov 	edx, 0                ;Zerar o registrador EDX que recebe o solução da soma.
		
		mov 	esi, matriz1          ;Copia a matriz 1 um para o Registrador apontador ESI.
		mov 	eax, [esi+ebx]        ;Copia o elemento que está na nesima posição da matriz para EAX.
		add 	edx, eax              ;Soma o valor de EAX com o valor de EDX.
		
		mov 	esi, matriz2          ;Copia a matriz 2 um para o Registrador apontador ESI.
		mov		eax, [esi+ebx]        ;Copia o elemento que está na nesima posição da matriz para EAX.
		add		edx, eax              ;Soma o valor de EAX com o valor de EDX.
		
		mov 	esi, matriz3          ;Copia a matriz 3 (Matriz de resultado) um para o Registrador apontador ESI.
		mov 	[esi+ebx], edx        ;Move o valor do resultado da soma para o idice corespondente.
		
		add 	ebx, 4                ;Incremento para ir para a proxima posição (4 bytes é o também de um int).
		dec 	ecx                   ;Decrementando o contador.
		cmp		ecx,0                 ;Comparando se o contador chegou no limite.
		je		_apresentaMatriz      ;Caso for IGUAL vai para o subPrograma que Apresenta a Matriz.
		jmp 	_adicao               ;Ainda tem soma para realizar. Retorma no inicio do SubPrograma de Adição.
		

;Inicio do SubPrograma de Para Fazer a Subtração entre Matriz A e Matriz B		
_subtracao:		
		mov 	edx, 0                ;Zerar o registrador EDX que recebe o solução da subtração.
		
		mov 	esi, matriz1          ;Copia a matriz 1 um para o Registrador apontador ESI.
		mov 	eax, [esi+ebx]        ;Copia o elemento que está na nesima posição da matriz para EAX.
		mov 	edx, eax              ;Copia o valor de EAX para EDX.
		
		mov 	esi, matriz2          ;Copia a matriz 2 um para o Registrador apontador ESI.
		mov		eax, [esi+ebx]        ;Copia o elemento que está na nesima posição da matriz para EAX.
		sub		edx, eax              ;Subtrai o valor de EAX com o valor de EDX.
		
		mov 	esi, matriz3          ;Copia a matriz 3 um para o Registrador apontador ESI.
		mov 	[esi+ebx], edx        ;Move o valor do resultado da soma para o idice corespondente.
		
		add 	ebx, 4                ;Incremento para ir para a proxima posição (4 bytes é o também de um int).
		dec 	ecx                   ;Decrementando o contador.
		cmp		ecx,0                 ;Comparando se o contador chegou no limite.
		je		_apresentaMatriz      ;Caso for IGUAL vai para o subPrograma que Apresenta a Matriz.
		jmp 	_subtracao            ;Ainda tem subração para realizar. Retorma no inicio do SubPrograma de Subtração.