;**************************************************************************************
;Xxxxxxxxxxxxxxxxxxxxxxxxxxx--==XX|Lola a Invasora|XX==--xxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;XxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;XxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;Xxxxxxxxxxxxxxxxxxxxxxxxxxxx  | IST ACom -- GRUPO: 9 |  xxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;XxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
; Gonçalo Evaristo Nº87532  ------  Diogo Cadete Nº102477  -----  João Maia Nº103845  *
;XxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;XxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;Comandos:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX*
;Xxxxx| GamePlay:  E (Iniciar/Recomeçar o jogo), F (Voltar ao menu) e B (Pausa)|xxxxxX*
;Xxxxx| Movimento: 0 (Andar esquerda) e 2 (Andar para a direita)|xxxxxxxxxxxxxxxxxxxxX*
;Xxxxx| Extras:    OS botões C (Incrementar) e D (Decrementar) funcionam como contador*
; *************************************************************************************

; **************
; * Constantes *
; **************

DISPLAYS                EQU 0A000H      ; Endereço dos displays de 7 segmentos (periférico POUT-1).
TEC_LIN				    EQU 0C000H	    ; Endereço das linhas do teclado (periférico POUT-2).
TEC_COL				    EQU 0E000H	    ; Endereço das colunas do teclado (periférico PIN).
LINHA_TECLADO_1			EQU 1		    ; Linha a testar (1ª linha, 0001b).
LINHA_TECLADO_2			EQU 2		    ; Linha a testar (1ª linha, 0010b).
LINHA_TECLADO_3			EQU 4		    ; Linha a testar (1ª linha, 0100b).
LINHA_TECLADO_4			EQU 8		    ; Linha a testar (1ª linha, 1000b).
MASCARA			     	EQU 0FH		    ; Para isolar os 4 bits de menor peso, ao ler as colunas do teclado.
TECLA_ESQUERDA			EQU 1		    ; Tecla na primeira coluna do teclado (tecla 0).
TECLA_DISPARO           EQU 2           ; Tecla na segunda coluna do teclado (tecla 1)
TECLA_DIREITA			EQU 4		    ; Tecla na terceira coluna do teclado (tecla 2).
AUMENTAR_CONTADOR       EQU 1
PIN                     EQU 0E000H


DEFINE_LINHA    		EQU 600AH       ; Endereço do comando para definir a linha.
DEFINE_COLUNA   		EQU 600CH       ; Endereço do comando para definir a coluna.
ESCREVE_8_PIXELS	    EQU 601CH		; endereço do comando para escrever 8 pixels
DEFINE_PIXEL    		EQU 6012H       ; Endereço do comando para escrever um pixel.
APAGA_AVISO     		EQU 6040H       ; Endereço do comando para apagar o aviso de nenhum cenário selecionado.
APAGA_ECRÃ	 		    EQU 6002H       ; Endereço do comando para apagar todos os pixels já desenhados.
SELECIONA_CENARIO_FUNDO EQU 6042H       ; Endereço do comando para selecionar uma imagem de fundo.
TOCA_SOM				EQU 605AH      	; Endereço do comando para tocar um som.
PAUSA_SOM               EQU 605EH
CONTINUA_SOM            EQU 6060H
APAGA_ESPEC             EQU 6000H
SELECIONA_ECRA          EQU 6004H
MOSTRA_ECRA             EQU 6006H
PARA_SOM                EQU 6066H

LINHA        		    EQU  27         ; Linha da posição do boneco (no fundo do ecrã).
COLUNA			        EQU  32         ; Coluna da posição do boneco (a meio do ecrã).

MIN_COLUNA		        EQU  0		    ; Número da coluna mais à esquerda que o objeto pode ocupar.
MAX_COLUNA		        EQU  63         ; Número da coluna mais à direita que o objeto pode ocupar.
ATRASO			        EQU	400H		; Atraso para limitar a velocidade de movimento do boneco.

N_LINHAS			EQU  31		; número de linhas do écrã
BARRA			    EQU  0FFH		; valor do byte usado para representar a barra


UM                      EQU 1           ; Tamanho 1
DOIS                    EQU 2           ; Tamanho 2
TRES                    EQU 3           ; Tamanho 3
QUATRO                  EQU 4           ; Tamanho 4
CINCO                   EQU 5           ; Tamanho 5
QUINZE                  EQU 15

VERMELHO		        EQU	0FF00H		; Cor do pixel: vermelho em ARGB 
ROXO                    EQU 0FA0FH      ; Cor do pixel: roxo em ARGB 
BRANCO                  EQU 0FFFFH      ; Cor do pixel: branco em ARGB 
VERDE                   EQU 0F392H      ; Cor do pixel: verde em ARGB 
AMARELO                 EQU 0FFF0H      ; Cor do pixel: amarelo em ARGB 
PRETO                   EQU 0F000H      ; Cor do pixel: preto em ARGB 
VERDE_ESCURO            EQU 0F796H
VERDE_INTERMEDIO             EQU 0F7B0H
VERDE_CLARO             EQU 0F9E0H
LARANJA1                EQU 0EE85H
LARANJA2                EQU 09F70H



SECCAO1                 EQU 8
SECCAO2                 EQU 16
SECCAO3                 EQU 24
SECCAO4                 EQU 32
SECCAO5                 EQU 40
SECCAO6                 EQU 48
SECCAO7                 EQU 56



; *********
; * Stack *
; *********

PLACE       1000H       ; Reservar espaço para a Stack a começar no endereço 1000H
pilha:
	STACK 400H			; Espaço reservado para a pilha.
						; (200H bytes, pois são 100H words).
SP_inicial:				; Este é o endereço (1200H) com que o SP deve ser. 
						; Inicializado. O 1.º end. de retorno será.
						; Armazenado em 11FEH (1200H-2).	
                        
; Tabela das rotinas de interrupção
tab:
	WORD rot_int_0			; rotina de atendimento da interrupção 0
    WORD rot_int_1
    WORD rot_int_2

linha_popup_1:
	WORD        0				; linha em que a barra está
    
linha_popup_2:
	WORD        0				; linha em que a barra está
    
linha_popup_3:
	WORD        0				; linha em que a barra está
    
linha_popup_4:
	WORD        0				; linha em que a barra está
    
coluna_popup_1:
    WORD        0 
    
coluna_popup_2:
    WORD        0 
    
coluna_popup_3:
    WORD        0 
    
coluna_popup_4:
    WORD        0 
    
linha_tinta:
    WORD        26
    
coluna_tinta:
    WORD        65

escolhe_anima_1:
    WORD        0
    
escolhe_anima_2:
    WORD        0

escolhe_anima_3:
    WORD        0
    
escolhe_anima_4:
    WORD        0

score:
    WORD        0

detetou_colisao:
    WORD        0
        
; ***************
; * A Lula Lola *
; ***************

camada_5:		; Tabela que define a camada 5 da LOLA
	WORD		CINCO
	WORD		0, ROXO, ROXO, ROXO, 0

camada_4:		; Tabela que define a camada 4 da LOLA
	WORD		CINCO
	WORD		BRANCO, PRETO, ROXO, PRETO, BRANCO
    
camada_3:		; Tabela que define a camada 3 da LOLA
	WORD		CINCO
	WORD		ROXO, ROXO, ROXO, ROXO, ROXO
    
camada_2:		; Tabela que define a camada 2 da LOLA
	WORD		CINCO
	WORD		0, ROXO, 0, ROXO, 0

camada_1:		; Tabela que define a camada 1 da LOLA
	WORD		CINCO
	WORD		ROXO, 0, ROXO, 0, ROXO
    
lola_verde_5:
    WORD    CINCO
    WORD    0, VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_INTERMEDIO, 0
    
    
lola_verde_4:
    WORD    CINCO
    WORD    VERDE_CLARO, VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_ESCURO, VERDE_CLARO
    
lola_verde_3:
    WORD    CINCO
    WORD    VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_INTERMEDIO
    
lola_verde_2:
    WORD    CINCO
    WORD    0, VERDE_INTERMEDIO, 0, VERDE_INTERMEDIO, 0
    
lola_verde_1:
    WORD    CINCO
    WORD    VERDE_INTERMEDIO, 0, VERDE_INTERMEDIO, 0, VERDE_INTERMEDIO
    

; *********************
; * O Gracioso Pixel: *
; *********************
    
pixel_preto:		; Tabela que define um pixel preto utilizado nas animações.
	WORD		UM
	WORD		PRETO



;****************
;*   EXPLOSÃO   *
;****************
explosaolinha1:
    WORD       CINCO
    WORD       0, LARANJA1, VERMELHO, LARANJA1
explosaolinha2:
    WORD       CINCO
    WORD       LARANJA1, LARANJA2, AMARELO, LARANJA2, LARANJA1
explosaolinha3:
    WORD       CINCO
    WORD       VERMELHO, AMARELO, BRANCO, AMARELO, VERMELHO
explosaolinha4:
    WORD       CINCO
    WORD       LARANJA1, LARANJA2, AMARELO, LARANJA2, LARANJA1
explosaolinha5:
    WORD       CINCO
    WORD       0, LARANJA1, VERMELHO, LARANJA1    




; *******************
; * Lula Assassína: *
; *******************

assassino_primeira_posicao:		; Tabela que define um pixel preto utilizado nas animações.
	WORD		UM
	WORD		AMARELO
    
    
assassino_segunda_posicao_1:
    WORD        DOIS
    WORD        VERMELHO, VERMELHO
    
assassino_segunda_posicao_2:
    WORD        DOIS
    WORD        AMARELO, AMARELO

assassino_terceira_posicao_1:
    WORD		TRES
	WORD		VERMELHO, AMARELO, VERMELHO
    
assassino_terceira_posicao_2:
    WORD		TRES
	WORD		AMARELO, AMARELO, AMARELO
    
assassino_terceira_posicao_3:
    WORD		TRES
	WORD		BRANCO, AMARELO, BRANCO
    
assassino_quarta_posicao_1:
    WORD        QUATRO
    WORD        VERMELHO, AMARELO, AMARELO, VERMELHO
    
assassino_quarta_posicao_2:
    WORD        QUATRO
    WORD        AMARELO, AMARELO, AMARELO, AMARELO
    
assassino_quarta_posicao_3:
    WORD        QUATRO
    WORD        0, AMARELO, AMARELO, 0
    
assassino_quarta_posicao_4:
    WORD        QUATRO
    WORD        BRANCO, 0, 0, BRANCO
    

assassino_quinta_posicao_1:	; Tabela que define a Lula assassina
	WORD		CINCO
	WORD		0, AMARELO, AMARELO, AMARELO, 0
    
assassino_quinta_posicao_2:	; Tabela que define a Lula assassina
	WORD		CINCO
	WORD		PRETO, VERMELHO, AMARELO, VERMELHO, PRETO
    
assassino_quinta_posicao_3:	; Tabela que define a Lula assassina
	WORD		CINCO
	WORD		AMARELO, AMARELO, AMARELO, AMARELO, AMARELO

assassino_quinta_posicao_4:	; Tabela que define a Lula assassina
	WORD		CINCO
	WORD		0, AMARELO, 0, AMARELO, 0
    
assassino_quinta_posicao_5:	; Tabela que define a Lula assassina
	WORD		CINCO
	WORD		BRANCO, 0, AMARELO, 0, BRANCO
    
; *********************
; * A impiedosa alga: *
; *********************
    
alga_primeira_posicao:
    WORD    UM
    WORD    VERDE_ESCURO

alga_segunda_posicao_1:
    WORD    DOIS
    WORD    0, VERDE_ESCURO
    
alga_segunda_posicao_2:
    WORD    DOIS
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO
    
alga_terceira_posicao_1:
    WORD    TRES
    WORD    0, VERDE_ESCURO, 0

alga_terceira_posicao_2:
    WORD    TRES
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_ESCURO

alga_terceira_posicao_3:
    WORD    TRES
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_CLARO
    
alga_quarta_posicao_1:
    WORD    QUATRO
    WORD    0, VERDE_ESCURO, VERDE_ESCURO, 0
    
alga_quarta_posicao_2:
    WORD    QUATRO
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_ESCURO
    
alga_quarta_posicao_3:
    WORD    QUATRO
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_CLARO, VERDE_ESCURO
    
alga_quarta_posicao_4:
    WORD    QUATRO
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_ESCURO, 0


alga_quinta_posicao_1:
    WORD    CINCO
    WORD    0, 0, VERDE_ESCURO, VERDE_ESCURO, 0

alga_quinta_posicao_2:
    WORD    CINCO
    WORD    0, VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_ESCURO

alga_quinta_posicao_3:
    WORD    CINCO
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_INTERMEDIO, VERDE_CLARO, VERDE_ESCURO
    
alga_quinta_posicao_4:
    WORD    CINCO
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_CLARO, VERDE_CLARO, VERDE_ESCURO

alga_quinta_posicao_5:
    WORD    CINCO
    WORD    VERDE_ESCURO, VERDE_INTERMEDIO, VERDE_ESCURO, VERDE_ESCURO, 0
    
;-------------;
; O Leal BOSS ;
;-------------;

BOSS_15:
    WORD QUINZE
    WORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

BOSS_14:
    WORD QUINZE
    WORD 0, 0, 0, 0, 0, PRETO, PRETO, PRETO, PRETO, PRETO, 0, 0, 0, 0, 0
    
BOSS_13:
    WORD QUINZE
    WORD 0, 0, 0,0, PRETO, PRETO, VERMELHO, VERMELHO, VERMELHO, PRETO, PRETO,0, 0, 0, 0
    
BOSS_12:
    WORD QUINZE
    WORD 0, 0, 0, PRETO, PRETO, VERMELHO, VERMELHO, VERMELHO,VERMELHO,AMARELO, PRETO, PRETO, 0, 0, 0
    
BOSS_11:
    WORD QUINZE
    WORD 0, 0, PRETO, PRETO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, AMARELO, PRETO, PRETO, 0, 0
    
BOSS_10:
    WORD    QUINZE
    WORD    0, 0, PRETO, AMARELO, AMARELO, PRETO, BRANCO, BRANCO, BRANCO, PRETO, AMARELO, AMARELO, PRETO, 0, 0
    
BOSS_9:
    WORD    QUINZE
    WORD    0, 0, PRETO, PRETO, PRETO, PRETO, BRANCO, VERMELHO, BRANCO, PRETO, PRETO, PRETO, PRETO, 0, 0
    
BOSS_8:
    WORD    QUINZE
    WORD    PRETO, PRETO, PRETO, AMARELO, AMARELO, PRETO, BRANCO, BRANCO, BRANCO, PRETO, VERMELHO, VERMELHO, PRETO, PRETO, PRETO
    
BOSS_7:
    WORD    QUINZE
    WORD    PRETO, AMARELO, PRETO, PRETO, VERMELHO, VERMELHO, AMARELO, AMARELO, VERMELHO, VERMELHO, VERMELHO, PRETO, PRETO, AMARELO, PRETO

BOSS_6:
    WORD    QUINZE
    WORD    PRETO,  VERMELHO, AMARELO, PRETO, PRETO, VERMELHO, AMARELO, AMARELO, VERMELHO, VERMELHO, PRETO, PRETO, AMARELO, VERMELHO, PRETO

BOSS_5:
    WORD    QUINZE
    WORD    PRETO, VERMELHO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, VERMELHO, PRETO

BOSS_4:
    WORD    QUINZE
    WORD    PRETO, AMARELO, PRETO, AMARELO, PRETO, VERMELHO, PRETO, VERMELHO, PRETO, AMARELO, PRETO, VERMELHO, PRETO, AMARELO, PRETO 
    
BOSS_3:
    WORD    QUINZE
    WORD    PRETO, PRETO, PRETO, VERMELHO, PRETO, AMARELO, PRETO, VERMELHO, PRETO, AMARELO, PRETO, AMARELO, PRETO, PRETO, PRETO

BOSS_2:
    WORD QUINZE
    WORD 0, 0, PRETO, AMARELO, PRETO, VERMELHO, PRETO, VERMELHO, PRETO, VERMELHO, PRETO, AMARELO, PRETO, 0, 0    

BOSS_1:
    WORD  QUINZE
    WORD  0, 0, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, 0, 0

;*************
;----FLAG----*
;*************

desenhamos_boss:
    WORD 0 
    
;***********************
;----PIXEL VERMELHO----*
;***********************    
    
pixel_vermelho:
    WORD UM
    WORD VERMELHO
    
    

; **********
; * Código *
; **********

PLACE   0                               ; O código tem de começar em 0000H.
MOV R8, 0
MOV [TOCA_SOM], R8
inicio:
	MOV  SP, SP_inicial		            ; Inicializa SP para a palavra a seguir.
                                        ; À última da pilha.
                            
	MOV  BTE, tab			; inicializa BTE (registo de Base da Tabela de Exceções)
                            
    MOV  [APAGA_AVISO], R1         	    ; Apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante).
    MOV  [APAGA_ECRÃ], R1	            ; Apaga todos os pixels já desenhados (o valor de R1 não é relevante).

    
init:
	MOV	R1, 0			                ; Cenário de fundo número 0.
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; Seleciona o cenário de fundo.
	MOV	R7, 1			                ; Valor a somar à coluna do boneco, para o movimentar.
    MOV R10, COLUNA                     ; 
    MOV  R11, DISPLAYS                  ; Endereço do periférico dos displays.
    MOV R9, 0100H                       ;
    MOV R5, 0105H
    MOV [R11], R9
    

menu:                                            ; Código a ser executado no menu de espera inicial
    
    DI
    MOV  [APAGA_ECRÃ], R1	            ; Apaga todos os pixels já desenhados (o valor de R1 não é relevante).
    i_espera_tecla_4:                            ; Testemos a linha 4 do teclado:
        MOV  R6, LINHA_TECLADO_4	             ; linha a testar no teclado
        CALL	teclado			                 ; leitura às teclas
        CMP R0, 4                                ; Verifica se foi premida a tecla "E" para o jogo começar
        JZ ini
        JMP menu
        ini:
            MOV R1, 1                            ; Prepara-se para mudar o fundo
            MOV R8, 1
            MOV [CONTINUA_SOM], R8
            CALL animacao                        ; Chama a função que tem a animação de mudança e de cenário
            EI0					; permite interrupções 0
            EI1
            EI2
	        EI					; permite interrupções (geral)
            JMP jogo                             ; Salta para o código do jogo como se fosse um campeão
    
    
    i_espera_nao_tecla:			                 ; neste ciclo espera-se até NÃO haver nenhuma tecla premida
        MOV  R6, LINHA_TECLADO_4	             ; linha a testar no teclado
        CALL	teclado			                 ; leitura às teclas
        CMP	R0, 0
        JZ	i_espera_tecla_4	                 ; Se nenhuma tecla estiver a ser carregada, salta para a próxima linha do teclado
        JMP i_espera_nao_tecla                   ; espera, enquanto houver tecla uma tecla carregada
    

    
menu_intermedio1:                                ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu                                     ; Salta para a etiqueta menu, quando queremos fazer pausa
    
menu_inter1:                                     ; Serve como salto intermédio porque o salto direto não é possível
    MOV R1, 0
    MOV [linha_popup_1], R1                      ; Serve para resetar as posições das lulas assassinas/ algas   
    MOV [linha_popup_2], R1                      ; Serve para resetar as posições das lulas assassinas/ algas
    MOV [linha_popup_3], R1                      ; Serve para resetar as posições das lulas assassinas/ algas
    MOV [linha_popup_4], R1                      ; Serve para resetar as posições das lulas assassinas/ algas
    MOV R1, 26                                   ; Mandamos para R1 o valor da linha inicial do míssil
    MOV [linha_tinta], R1                        ; Resetamos a linha do míssil
    MOV R1, 65                                   ; Mandamos para R1 o valor da coluna inicial do míssil
    MOV [coluna_tinta], R1                       ; Resetamos a coluna do míssil   
    MOV R9,0                                     ; Mandamos para R9 o valor inicial do score
    MOV [score],R9                               ; Resetamos o score
    DI                                           ; Paramos as interrupções
    JMP init                                     ; Salta para a etiqueta init para voltar a inicializar as variáveis e regressarmos ao menu

jogo:                                            ; O começo do jogo!


JMP Desenha                     ; Para fazer o "skip" dos saltos intermédios

menu_intermedio2:               ; Serve como salto intermédio porque o salto direto não é possível 
    JMP menu_intermedio1        ; Salta para a etiqueta menu_intermedio1, para o próximo salto intermédio, associado à pausa
    
menu_inter2:                    ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu_inter1             ; Salta para a etiqueta menu_inter1, para irmos para o salto intermedio, associado ao menu


; *************************
; * Desenhos da Lola:     *
; *************************

Desenha:                        ; Função que desenha a Lola Toda
    posicao_boneco_5:
         MOV  R1, LINHA			; Linha do boneco.
         MOV  R2, R10		    ; Coluna do boneco.
         MOV  R4, camada_5		; Endereço da tabela que define o boneco.

    mostra_boneco_5:
        CALL	desenha_boneco	; Desenha o boneco a partir da tabela.

    posicao_boneco_4:
         MOV  R1, LINHA+1		; Linha do boneco.
         MOV  R2, R10		    ; Coluna do boneco.
         MOV  R4, camada_4		; Endereço da tabela que define o boneco.

    mostra_boneco_4:
        CALL	desenha_boneco	; Desenha o boneco a partir da tabela.
        
    posicao_boneco_3:
         MOV  R1, LINHA+2		; Linha do boneco.
         MOV  R2, R10		    ; Coluna do boneco.
         MOV  R4, camada_3		; Endereço da tabela que define o boneco.

    mostra_boneco_3:
        CALL	desenha_boneco	; Desenha o boneco a partir da tabela.

    posicao_boneco_2:
         MOV  R1, LINHA+3		; Linha do boneco.
         MOV  R2, R10		    ; Coluna do boneco.
         MOV  R4, camada_2		; Endereço da tabela que define o boneco.

    mostra_boneco_2:
        CALL	desenha_boneco	; Desenha o boneco a partir da tabela.
        
    posicao_boneco_1:
         MOV  R1, LINHA+4		; Linha do boneco.
         MOV  R2, R10		    ; Coluna do boneco.
         MOV  R4, camada_1		; Endereço da tabela que define o boneco.

    mostra_boneco_1:
        CALL	desenha_boneco	; Desenha o boneco a partir da tabela.    






espera_tecla_4:
    MOV  R6, LINHA_TECLADO_4	; linha a testar no teclado
	CALL	teclado			    ; leitura às teclas
    MOV R8, 8                   ; Passamos 8 para o R8 para guardar o valor equivalente à tecla F    
    CMP	R0, 0                   ; Verifica se alguma tecla foi premida
    JZ	espera_tecla_3          ; Verifica se foi premida a tecla "C"
    CMP R0, AUMENTAR_CONTADOR
    JZ aumenta
    CMP R0, R8               ; Compara R0 com 8 para saber se estamos a pressionar a tecla F
    JZ acaba1               ; Salta para o acaba1
    JMP espera_nao_tecla
    aumenta:
        CALL conversao_aumenta
        MOV R9, R5        ; Coloca o novo valor para ser escrito na tela
        MOV [R11], R9      ; Escreve o valor dado acima no display
        JMP espera_nao_tecla
    
menu_inter3:                    ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu_inter2             ; Salta para a etiqueta menu_inter1, para irmos para o salto intermedio, associado ao menu         
    
espera_nao_tecla:			    ; neste ciclo espera-se até NÃO haver nenhuma tecla premida
	MOV  R6, LINHA_TECLADO_4	; linha a testar no teclado
	CALL	teclado			    ; leitura às teclas
	CMP	R0, 0                   ; Confere se há alguma tecla a ser carregada
	JZ	espera_tecla_3	        ; espera, enquanto houver tecla uma tecla carregada
    JMP espera_nao_tecla
    

acaba1:
            MOV[APAGA_ECRÃ],R1      ; apaga o ecrã
            DI
            MOV R9,0100H
            MOV [R11], R9
            MOV R1, 2               ; Passamos para R1 o valor do cenário de fundo que queremos
            CALL animacao           ; Fazemos a animação
            MOV R8,500
            JMP cont_acaba1   

menu_intermedio3:               ; Serve como salto intermédio porque o salto direto não é possível 
    JMP menu_intermedio2        ; Salta para a etiqueta menu_intermedio1, para o próximo salto intermédio, associado à pausa

            
cont_acaba1:  
            MOV  [SELECIONA_CENARIO_FUNDO], R1	; Seleciona o cenário de fundo
            SUB R8,1
            CMP R8, 0               ; Caso o temporizador seja igual a 0 queremos ir para o menu
            JNZ continuar1          ; Enquanto o temporizador não é zero mantemos o ciclo
            JMP menu_inter2         ; Quando chegar a 0 vamos para o menu, saltando para os saltos intermédios
continuar1:  JMP cont_acaba1        ; Repetimos o ciclo



    

espera_tecla_3:
    MOV  R6, LINHA_TECLADO_3	; Linha a testar no teclado.
    MOV R8, 8                   ; Passamos 8 para o R8 para guardar o valor equivalente à tecla B  
	CALL	teclado			    ; Leitura às teclas.
    CMP	R0, 0                   ; Verifica se alguma tecla foi premida
    JZ	espera_tecla_2
    CMP R0, R8                  ; Compara R0 com 8 para saber se estamos a pressionar a tecla B
    JZ acaba2                   ; Caso R0 seja a tecla que queremos saltamos para o acaba2
    JMP espera_tecla_2
    
    acaba2:
            DI
            MOV R8, 1
            MOV [PAUSA_SOM], R8
            MOV[APAGA_ECRÃ],R1  ;apaga o ecrã
cont_acaba2:  
            MOV R1, 3                           ; Serve para guardar o número do cenário de fundo que vamos querer
            MOV  [SELECIONA_CENARIO_FUNDO], R1	; Seleciona o cenário de fundo.
            JZ menu_intermedio2                 ; Caso sejam, saltamos para um salto intermédio
            JMP cont_acaba2                     ; Repetimos o ciclo
    
espera_tecla_2:
    MOV  R6, LINHA_TECLADO_2	; Linha a testar no teclado.
	CALL	teclado			    ; Leitura às teclas.
    CMP	R0, 0                   ; Verifica se alguma tecla foi premida
    JZ	espera_tecla_1
    
espera_tecla_1:				         ; Neste ciclo espera-se até uma tecla ser premida.
	MOV     R6, LINHA_TECLADO_1	     ; Linha a testar no teclado.
    CALL	teclado			         ; Leitura às teclas. 
    CMP	    R0, 0                    ; Verifica se alguma tecla foi premida
	JZ	    espera_tecla_4		     ; Espera, enquanto não houver tecla.
    CMP     R0, TECLA_DISPARO
    JZ      anima_tinta_teclado
	CMP	    R0, TECLA_ESQUERDA       ; Ver se a tecla premida corresponde à tecla esquerda
	JNZ	    testa_direita
	MOV	    R7, -1			         ; Vai deslocar para a esquerda.
    MOV R8, 2 
	MOV [TOCA_SOM], R8
    CMP     R0,2
	JMP	    ve_limites
  
anima_tinta_teclado:
    MOV R1, [linha_tinta]            ; Passamos para R1 a linha em que o míssil está
    MOV R2, 26                       ; Passamos para R2  o valor da linha inicial do míssil
    CMP R1, R2                       ; Comparamos os valores
    JNZ espera_tecla_4               ; Caso os valores não sejam iguais, significa que o míssil ainda não resetou, voltamos para o espera_tecla_4

        CALL conversao_diminui       ; Sempre que disparamos retiramos 5 à energia
        MOV [R11], R5                ; Atualizamos o valor do display      
        CMP R5,0                     ; Se o valor passar para 0 acabamos o jogo
        JZ theend_1                  ; Saltamos para o ciclo de finalizar o jogo
        JMP cont_anima_tec           ; Caso contrario continuamos com o anima_teclado   

        theend_1:
          DI                          ; Paramos as interrupções     
          MOV R8, 8                   ; Passamos para R8 o valor 8 para servir como tecla F
          MOV [APAGA_ECRÃ],R1         ; apaga o ecrã
          MOV R9,0100H                ; Passamos para R9 o valor 0100H para resetarmos a energia
          MOV [R11], R9               ; Resetamos o display das energias
          MOV R1, 4                   ; Passamos para R1 o valor do cenário que vamos escolher

          temp_theend_1:
                  MOV  [SELECIONA_CENARIO_FUNDO], R1
                  MOV  R6, LINHA_TECLADO_4                      ; linha a testar no teclado
                  CALL    teclado                               ; leitura às teclas
                  MOV R9,0                                      ; Mandamos para R9 o valor para resetar a flag
                  MOV[desenhamos_boss], R9                      ; Resetamos a flag
                  CMP R0,R8                                     ; Vemos se as teclas são iguais
                  JZ menu_inter3                                ; Quando chegar a 0 vamos para o menu, saltando para os saltos intermédios
                  JMP temp_theend_1


       cont_anima_tec:

        MOV R4, pixel_preto
        MOV R2, R10
        ADD R2, 2
        MOV [coluna_tinta], R2

        MOV R8, 3
        MOV [TOCA_SOM], R8

        CALL desenha_boneco

        SUB R1, 1
        CALL desenha_boneco

        MOV [linha_tinta], R1
        JMP espera_tecla_4
    
testa_direita:
	CMP	R0, TECLA_DIREITA
	JNZ	espera_tecla_1		; Tecla que não interessa.
	MOV	R7, +1			    ; Vai deslocar para a direita.
    MOV R8, 2 
	MOV [TOCA_SOM], R8		; Comando para tocar o som.
	
ve_limites:
	MOV	R6, [R4]			; Obtém a largura do boneco.
	CALL	testa_limites	; Vê se chegou aos limites do ecrã e se sim força R7 a 0.
	CMP	R7, 0
	JZ	espera_tecla_1		; Se não é para movimentar o objeto, vai ler o teclado de novo.

    
    JMP posicao_apaga_5
    
menu_intermedio4:               ; Serve como salto intermédio porque o salto direto não é possível 
    JMP menu_intermedio3        ; Salta para a etiqueta menu_intermedio1, para o próximo salto intermédio, associado à pausa 
    
menu_inter4:                    ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu_inter3             ; Salta para a etiqueta menu_inter1, para irmos para o salto intermedio, associado ao menu

; ***************
; * Apagadores: *
; ***************


posicao_apaga_5:
    MOV  R1, LINHA			    ; Linha da Lola a apagar.
    MOV  R2, R10		        ; Coluna da Lola.
    MOV  R4, camada_5		    ; Endereço da tabela que define a Lola.

move_boneco_5:
	CALL	apaga_boneco		; Apaga a Lola na sua posição corrente #RIPLola.
    
posicao_apaga_4:
    MOV  R1, LINHA+1			; Linha da Lola a apagar.
    MOV  R2, R10		        ; Coluna da Lola.
    MOV  R4, camada_4		    ; Endereço da tabela que define a Lola.

move_boneco_4:
	CALL	apaga_boneco		; Apaga a Lola na sua posição corrente #RIPLola.
    
posicao_apaga_3:
    MOV  R1, LINHA+2			; Linha da Lola a apagar.
    MOV  R2, R10		        ; Coluna da Lola.
    MOV  R4, camada_3		    ; Endereço da tabela que define a Lola.

move_boneco_3:
	CALL	apaga_boneco		; Apaga a Lola na sua posição corrente #RIPLola.
    
posicao_apaga_2:
    MOV  R1, LINHA+3			; Linha da Lola a apagar.
    MOV  R2, R10		        ; Coluna da Lola.
    MOV  R4, camada_2		    ; Endereço da tabela que define a Lola.

move_boneco_2:
	CALL	apaga_boneco		; Apaga a Lola na sua posição corrente #RIPLola.
    
posicao_apaga_1:
    MOV  R1, LINHA+4			; Linha da Lola a apagar.
    MOV  R2, R10		        ; Coluna da Lola.
    MOV  R4, camada_1		    ; Endereço da tabela que define a Lola.

move_boneco_1:
	CALL	apaga_boneco		; Apaga a Lola na sua posição corrente #RIPLola.
    
	
coluna_seguinte:
	ADD	R10, R7			        ; Para desenhar objeto na coluna seguinte (direita ou esquerda).
	JMP	Desenha		            ; Vai desenhar a Lola de novo.

JMP desenha_boneco

menu_intermedio5:               ; Serve como salto intermédio porque o salto direto não é possível 
    JMP menu_intermedio4        ; Salta para a etiqueta menu_intermedio1, para o próximo salto intermédio, associado à pausa 
menu_inter5:                    ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu_inter4             ; Salta para a etiqueta menu_inter1, para irmos para o salto intermedio, associado ao menu

; *******************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas    *
;			       com a forma e cor definidas na tabela indicada.  *
; Argumentos:   R1 - linha.                                         *
;               R2 - coluna.                                        *
;               R4 - tabela que define o boneco.                    *
; *******************************************************************
desenha_boneco:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R8
	MOV	R8, [R4]			; Obtém a largura do boneco.
	ADD	R4, 2			    ; Endereço da cor do 1º pixel (2 porque a largura é uma word).
desenha_pixels:       		; Desenha os pixels do boneco a partir da tabela.
	MOV	R3, [R4]			; Obtém a cor do próximo pixel do boneco.
	CALL	escreve_pixel	; Escreve cada pixel do boneco.
	ADD	R4, 2			    ; Endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word).
     ADD  R2, 1             ; Próxima coluna.
     SUB  R8, 1			    ; Menos uma coluna para tratar.
     JNZ  desenha_pixels    ; Continua até percorrer toda a largura do objeto.
	POP	R8
	POP	R4
	POP	R3
	POP	R2
	RET
 
; ***************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas    *
;			     com a forma definida na tabela indicada.       *
; Argumentos:   R1 - linha.                                     *
;               R2 - coluna.                                    *
;               R4 - tabela que define o boneco.                *
; ***************************************************************
apaga_boneco:
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R8
	MOV	R8, [R4]			; Obtém a largura do boneco.
	ADD	R4, 2			    ; Endereço da cor do 1º pixel (2 porque a largura é uma word).
apaga_pixels:       		; Desenha os pixels do boneco a partir da tabela.
	MOV	R3, 0			    ; Cor para apagar o próximo pixel do boneco.
	CALL	escreve_pixel	; Escreve cada pixel do boneco.
	ADD	R4, 2			    ; Endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word).
     ADD  R2, 1             ; Próxima coluna.
     SUB  R8, 1			    ; Menos uma coluna para tratar.
     JNZ  apaga_pixels      ; Continua até percorrer toda a largura do objeto.
	POP	R8
	POP	R4
	POP	R3
	POP	R2
	RET

; ***************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas. *
; Argumentos:   R1 - linha.                                     *
;               R2 - coluna.                                    *
;               R3 - cor do pixel (em formato ARGB de 16 bits). *
; ***************************************************************


escreve_pixel:
	MOV  [DEFINE_LINHA], R1		; Seleciona a linha.
	MOV  [DEFINE_COLUNA], R2	; Seleciona a coluna.
	MOV  [DEFINE_PIXEL], R3		; Altera a cor do pixel na linha e coluna já selecionadas.
	RET

; *******************************************************
; ATRASO - Executa um ciclo para implementar um atraso. *
; Argumentos:   R11 - valor que define o atraso.        *
; *******************************************************
atraso:
	PUSH	R4
    MOV R4, 0100H
ciclo_atraso:
	SUB	R4, 1
	JNZ	ciclo_atraso
	POP	R4
	RET
    
JMP testa_limites

menu_intermedio6:               ; Serve como salto intermédio porque o salto direto não é possível 
    JMP menu_intermedio5        ; Salta para a etiqueta menu_intermedio1, para o próximo salto intermédio, associado à pausa 
menu_inter6:                    ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu_inter5             ; Salta para a etiqueta menu_inter1, para irmos para o salto intermedio, associado ao menu

; ********************************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso      *
;			      impede o movimento (força R7 a 0).                             *
; Argumentos:	R2 - coluna em que o objeto está.                                *
;			    R6 - largura do boneco.                                          *
;			    R7 - sentido de movimento do boneco (valor a somar à coluna.     *
;				em cada movimento: +1 para a direita, -1 para a esquerda).       *
; Retornos: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário. *	
; ********************************************************************************
testa_limites:
	PUSH	R6
	PUSH	R8
testa_limite_esquerdo:		    ; Vê se a Lola chegou ao limite esquerdo.
	MOV	R8, MIN_COLUNA
	CMP	R2, R8
	JGT	testa_limite_direito
	CMP	R7, 0			        ; Passa a deslocar-se para a direita.
	JGE	sai_testa_limites
	JMP	impede_movimento	    ; Entre limites. Mantém o valor do R7.
testa_limite_direito:		    ; Vê se a Lola chegou ao limite direito.
	ADD	R6, R2			        ; Posição a seguir ao extremo direito da Lola.
	MOV	R8, MAX_COLUNA
	CMP	R6, R8
	JLE	sai_testa_limites	    ; Entre limites. Mantém o valor do R7.
	CMP	R7, 0			        ; Passa a deslocar-se para a direita.
	JGT	impede_movimento
	JMP	sai_testa_limites
impede_movimento:
	MOV	R7, 0			        ; Impede o movimento, forçando R7 a 0.
sai_testa_limites:	
	POP	R8
	POP	R6
	RET




; *************************************************************************************
; TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido. *
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8).                        *
; Retornos: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8).            *
; *************************************************************************************
teclado:
    
    PUSH    R1
	PUSH	R2
	PUSH	R3
    PUSH    R4
    PUSH    R6
    PUSH    R7
    PUSH    R8
    PUSH    R9
    PUSH    R10
	MOV     R9, 0
    MOV     R4, 0
    MOV     R2, TEC_LIN   ; Endereço do periférico das linhas.
	MOV     R3, TEC_COL   ; Endereço do periférico das colunas.
	MOV     R1, MASCARA   ; Para isolar os 4 bits de menor peso, ao ler as colunas do teclado.
	MOVB    [R2], R6      ; Escrever no periférico de saída (linhas).
	MOVB    R0, [R3]      ; Ler do periférico de entrada (colunas).
	AND     R0, R1        ; Elimina bits para além dos bits 0-3.
    MOV     R1, R0        ; Guardamos o valor de R0 para a posterioridade
    
    cicloos_1:            ; Conta o número de Shifts que se tem de fazer para a coluna chegar a 0
        SHR R0, 1           
        JZ cicloos_2
        ADD R9, 1
        JMP cicloos_1
        
    cicloos_2:            ; Conta o número de Shifts que se tem de fazer para a linha passar a 0
        SHR R6, 1
        JZ continuacao
        ADD R4, 1
        JMP cicloos_2
    
    continuacao:          ; Para obter o número da tecla carregada
        SHL R4, 2         ; Multiplicar a linha por 4
        ADD R9, R4        ; Adicionar o número das colunas
        MOV R0, R1        ; Retomar o valor de R0 ao seu proprietário original
        MOV R8, R9
        MOV R4, 0
        

    
	POP R10
    POP R9
    POP R8
    POP R7
    POP R6
	POP R4
    POP	R3
	POP	R2
    POP R1
	RET
    
JMP animacao

; *************************************************************************************
; Animacao - Faz uma animação que tapa todos os pixeis do ecrã                        *
; Argumentos - R1--> indica em que cenário é que vamos aplicar a animação             *
; *************************************************************************************

menu_intermedio7:               ; Serve como salto intermédio porque o salto direto não é possível 
    JMP menu_intermedio6        ; Salta para a etiqueta menu_intermedio1, para o próximo salto intermédio, associado à pausa 
menu_inter7:                    ; Serve como salto intermédio porque o salto direto não é possível
    JMP menu_inter6             ; Salta para a etiqueta menu_inter1, para irmos para o salto intermedio, associado ao menu

animacao:
    DI
    PUSH    R3
    PUSH    R8
    PUSH    R9
    PUSH    R10
    PUSH    R1
    

    
    MOV R8, 32                     ; Limite máximo de pixeis por linha
    MOV R3, 64                     ; Limite máximo de pixeis por coluna
    
    ; CRIAR OS PIXEIS:
    
    MOV R10, 0                      ; Vai começar na Coluna 0
    ciclar:
        MOV R9, 0                   ; Vai começar na Linha 0
        ciclar_1:
            MOV  R1, R9			    ; Linha em que vai desenhar o pixel.
            MOV  R2, R10		    ; Coluna em que vai desenhar o pixel.
            MOV  R4, pixel_preto	; Endereço da tabela que define o pixel.
            CALL	desenha_boneco	; Desenha o pixel a partir da tabela.
            ADD R9, 1               ; Segue para a linha seguinte
            CMP R9, R8              ; Verifica se chegou ao fim da Linha
            JNZ ciclar_1      
        ADD R10, 1                  ; Segue para a coluna seguinte
        CMP R10, R3                 ; Verifica se chegou à ultima coluna
        JNZ ciclar
        
    POP R1                              ; Vai buscar o valor do cenário previamente guardado em R1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; Seleciona o cenário de fundo.
    PUSH R1
    ; APAGAR OS PIXEIS:

    MOV R9, 0                           ; Vai começar na LINHA 0
    ciclar_apagar:
        MOV R10, 0                      ; Vai começar na Coluna 0
        ciclar_apagar_1:
            MOV  R1, R9			        ; Linha à qual vai apagar o Pixel.
            MOV  R2, R10		        ; Coluna à qual vai apagar o Pixel.
            MOV  R4, pixel_preto		; Endereço da tabela que define o Pixel.
            CALL	apaga_boneco		; Apaga o Pixel na sua posição corrente.
            ADD R10, 1                  ; Segue para a Coluna seguinte
            CMP R10, R3                 ; Verifica se chegou ao fim da Coluna
            JNZ ciclar_apagar_1
        ADD R9, 1                       ; Segue para a Linha seguinte
        CMP R9, R8                      ; Verifica se chegou ao fim da Linha
        JNZ ciclar_apagar
    
    POP   R1
    POP   R10
    POP   R9
    POP   R8
    POP   R3
	RET 
    
menu_inter8:
    JMP menu_inter7
    
; ****************************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0                       *
;  Faz os bonecis descer uma linha. A animação dos bonecos é causada pela    *
;			invocação periódica desta rotina                                 *
; ****************************************************************************    

rot_int_0:
    PUSH R1
    PUSH R2
    PUSH R6
    PUSH R9
	CALL escolhe_anima                     ; Escolhe qual dos bonecos vai animar e qual das colunas
    CALL deteta_colisao_alga               ; Chama função que deteta colisão com a alga
    CALL deteta_colisao_assassino          ; Chama função que deteta colisão com o assassino
    MOV R9, [detetou_colisao]              ; Passamos para R9 o valor da flag de detetou_colisao 
    CMP R9, 1                              ; Vemos se o valor da flag está a 1 para ver se alguma colisão já foi detetada
    JNZ acaba_rot_int_0                    ; Caso o valor não seja zero vamos acabar a interrupção 
    
    MOV [APAGA_ECRÃ], R1                   ; Caso tenha sido detetada uma colisão apagamos o ecrã
    MOV R1, 7                              ; Passamos para R7 o valor do cenario de fundo que queremos
    MOV [SELECIONA_CENARIO_FUNDO], R1      ; Mudamos o cenário
    MOV R8, 1                               
    MOV [PAUSA_SOM], R8
    MOV R8, 6
    MOV [TOCA_SOM], R8
    
espera_tecla_final: 
    MOV R6, LINHA_TECLADO_4                ; Vamos ver a linha 4 do teclado
    CALL teclado                           ; Chamamos a função do teclado
    MOV R2, 4                              ; Passamos para R2 o valor da tecla E, que tem o valor 4
    CMP R0, R2                             ; Vemos se estamos a pressionar a tecla E, que tem o valor 4                             
    JZ retoma_jogo                         ; Caso tenhamos pressionado a tecla E vamos para retoma_jogo 
    MOV R2, 8                              ; Passamos para R2 o valor da tecla F, que tem o valor 8                           
    CMP R0, R2                             ; Vemos se estamos a pressionar a tecla F
    JZ reinicia_jogo                       ; Caso tenhamos pressionado a tecla F vamos para reinicia_jogo 
    JMP espera_tecla_final                 ; Caso não tenhamos pressionado tecla nenhuma, ficamos à espera da tecla
retoma_jogo:
    MOV R9,0                               ; Passamos para R9 o valor 0 para resetarmos a flag
    MOV [detetou_colisao], R9              ; Resetamos a flag 
    JMP menu_intermedio7                   ; Vamos para os menus intermedios para fazer a pausa 
reinicia_jogo:
    
    MOV R9,0                               ; Passamos para R9 o valor 0 para resetarmos a flag
    MOV [detetou_colisao], R9              ; Resetamos a flag   
    JMP menu_inter8                        ; Vamos para os menus inter para reiniciar
    
acaba_rot_int_0:
    POP R9
    POP R6
    POP R2
    POP R1
	RFE					; Return From Exception (diferente do RET)
    

; ****************************************************************************
; ROT_INT_1 - 	  Rotina de atendimento da interrupção 1                     *
;	               Faz a animação do míssil fazendo a                        *
;			        invocação periódica desta rotina                         *
; ****************************************************************************  

rot_int_1:
    PUSH R7
    PUSH R8
    PUSH R9
    CALL anima_tinta                ; Chama a função para animar o míssil
    MOV R7, 5                       ; Passamos para 7 o valor 5
    MOV R9, [score]                 ; Passamos o valor do score para R9
    CMP R9, R7                      ; Comparamos os dois valores para ver se passamos à fase do boss
    JZ apaga_todos                  ; Vamos para a parte do código que vai apagar os assassinos e as algas    
            
    MOV R7, 12                      ; Passamos para 7 o valor 5      
    MOV R9, [score]                 ; Passamos o valor do score para R9
    CMP R9, R7                      ; Comparamos os dois valores para ver se acabamos o jogo
    JZ acabajogo
    JMP sai_rot_int_1               ; Caso ainda não tenhamos chegado ao valor do score para acabar o jogo, saímos da rotina
    acabajogo:
        MOV [APAGA_ECRÃ], R1        ; Apagamos o ecrã
        DI                          ; Paramos as interrupções
        MOV R9,0100H                ; Passamos 0100H para R9 para resetarmos o display da energia
        MOV [R11], R9               ; Resetamos o display das energias
        MOV R1, 5                   ; Passamos para R1 o valor do cenário de fundo que queremos
        CALL fim_jogo
        CALL animacao               ; Fazemos a animação
        MOV R8,50                   ; Criamos o nosso temporizador para o cenário de fundo
                       
    cont_acaba_rot1:  
                MOV  [SELECIONA_CENARIO_FUNDO], R1	         ; Seleciona o cenário de fundo
                SUB R8,1                                     ; Decrementamos o valor do temporizador
                CMP R8, 0                                    ; Caso o temporizador seja igual a 0 queremos ir para o menu
                JNZ cont_acaba_rot1                          ; Enquanto o temporizador não é zero mantemos o ciclo
                
    cont_acaba_rot2:      
                MOV R1,6                                     ; Passamos para R1 o valor do cenário de fundo que queremos                               
                CALL animacao                                ; Chamamos a animação
                MOV R8,50                                    ; Criamos o nosso segundo temporizador
      cont_acaba_rot2_1:            
                MOV  [SELECIONA_CENARIO_FUNDO], R1	         ; Seleciona o cenário de fundo
                SUB R8,1                                     ; Decrementamos o valor do temporizador
                CMP R8, 0                                    ; Caso o temporizador seja igual a 0 queremos ir para o menu
                JNZ cont_acaba_rot2_1                        ; Enquanto o temporizador não é zero mantemos o ciclo
                MOV R1, 0                                    ; Passamos para R1 o valor 0 para resetar a flag
                MOV [desenhamos_boss],R1                     ; Resetamos a flag
                JMP menu_inter8                              ; Quando chegar a 0 vamos para o menu, saltando para os saltos intermédios

    apaga_todos:                
        MOV R9, [desenhamos_boss]                            ; Passamos para R9 o valor da flag
        CMP R9, 0                                            ; Comparamos com 0 para sabermos se já estamos a desenhar o boss ou não
        JNZ sai_rot_int_1                                    ; Se já estivermos a desenhar o boss, saímos da rotina
        MOV R9, 6                                            ; Caso estejamos a desenhar o Boss pela primeira vez, passamos o valor de R9 para 6
        MOV [score], R9                                      ; Atualizamos o valor do score para não haver conflitos
        CALL apagar_todos_popups                             ; Apagamos todos os assassinos e algas
        CALL desenha_boss                                    ; Desenhamos o Boss
        
    sai_rot_int_1:
        POP R9
        POP R8
        POP R7
        RFE



; ****************************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2                       *
;			        Decresce a energia fazendo                               *
;			     invocação periódica desta rotina                            *
; ****************************************************************************  

    
rot_int_2:
    CMP R5,0                                    ; Vemos o valor de R5, se estiver a 0 vamos acabar o jogo
    JZ continua                                 ; Saltamos para a etiqueta continua, para podermos acabar o jogo por falta de energia
    CALL conversao_diminui                      ; Diminuimos a energia sempre que a interrupção estiver ativa e não tivermos chegado ao valor 0
    MOV [R11], R5                               ; Atualizamos o display das energias
    CMP R5,0                                    ; Vemos se assim que retirarmos 5 à energia se fica 0
    JZ continua                                 ; Se ficar a 0 vamos terminar o jogo
    JMP retorno                                 ; Caso contrário vamos para o retorno
continua:
    theend:
      CALL morte_energia
      DI                                        ; Desativamos as interrupções
      MOV R8,8                                  ; Passamos para R8 o valor 8 para servir como tecla F
      MOV [APAGA_ECRÃ],R1                        ; apaga o ecrã
      MOV R9,0100H                              ; Passamos o valor 0100H para resetar o display
      MOV [R11], R9                             ; Resetamos o display   
      MOV R1,4                                  ; Passamos para R1 o valor do cenário que vamos escolher

      temp_theend:
                  MOV   [SELECIONA_CENARIO_FUNDO], R1
                  MOV   R6, LINHA_TECLADO_4	            ; linha a testar no teclado
	              CALL	teclado			                ; leitura às teclas
                  MOV   R9, 0
                  MOV   [desenhamos_boss], R9           ; Faz reset no score
                  CMP   R0,R8                           ; Vemos se as teclas são iguais
                  JZ    menu_inter8                     ; Quando chegar a 0 vamos para o menu, saltando para os saltos intermédios
                  JMP   temp_theend
 retorno:
    RFE

    morte_energia:
      MOV R8, 1
      MOV [PARA_SOM], R8
      MOV R8, 6
      MOV [TOCA_SOM], R8 
      RET 
    
    fim_jogo:
        MOV R8, 8
        MOV [PARA_SOM], R8
        MOV R8, 5
        MOV [TOCA_SOM], R8
        RET

; *****************************************************************************
; deteta_colisao_assassino - Detetar colisões entre a Lola e Lulas Assassinas *
;	Define os parametros R1, R2 e R3 para a função deteta_colisao_assassino_1 *
; com a linha, coluna e animação de cada pop-up                               *
; *****************************************************************************  
 deteta_colisao_assassino:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R8

    MOV R1, [linha_popup_1]             ; Coloca em R1 a linha do pop-up1
    MOV R2, [coluna_popup_1]            ; Coloca em R2 a coluna do pop-up1
    MOV R3, [escolhe_anima_1]           ; Coloca em R3 a animação do pop-up1
    CALL deteta_colisao_assassino_1     ; Chama a função já com os argumentos de R1, R2 e R3 pre-carregados
    MOV [linha_popup_1], R8             ; Se houve colisão, atualiza a linha

    MOV R1, [linha_popup_2]             ; Coloca em R1 a linha do pop-up2
    MOV R2, [coluna_popup_2]            ; Coloca em R2 a coluna do pop-up2
    MOV R3, [escolhe_anima_2]           ; Coloca em R3 a animação do pop-up3
    CALL deteta_colisao_assassino_1     ; Chama a função já com os argumentos de R1, R2 e R3 pre-carregados
    MOV [linha_popup_2], R8             ; Se houve colisão, atualiza a linha

    MOV R1, [linha_popup_3]             ; Coloca em R1 a linha do pop-up3
    MOV R2, [coluna_popup_3]            ; Coloca em R2 a coluna do pop-up3
    MOV R3, [escolhe_anima_3]           ; Coloca em R3 a animação do pop-up3
    CALL deteta_colisao_assassino_1     ; Chama a função já com os argumentos de R1, R2 e R3 pre-carregados
    MOV [linha_popup_3], R8             ; Se houve colisão, atualiza a linha


    MOV R1, [linha_popup_4]             ; Coloca em R1 a linha do pop-up4
    MOV R2, [coluna_popup_4]            ; Coloca em R2 a coluna do pop-up4
    MOV R3, [escolhe_anima_4]           ; Coloca em R3 a animação do pop-up3
    CALL deteta_colisao_assassino_1     ; Chama a função já com os argumentos de R1, R2 e R3 pre-carregados
    MOV [linha_popup_4], R8             ; Se houve colisão, atualiza a linha

    POP R8
    POP R3
    POP R2
    POP R1
    RET

; ****************************************************************************
;  deteta_colisao_assassino_1 - Continuação da deteta_colisao_assassino      *
; mas mais especifica, para cada um dos quatro pop-ups                       *
;  Devolve R8, com um possível novo valor para a linha do pop-up, caso este  *
; tenha colidido com a Lola                                                  *
; **************************************************************************** 
deteta_colisao_assassino_1:

    PUSH R4
    PUSH R7
    PUSH R9
    
    MOV R8, R1
    CMP R3, 2                       ; Vê se é uma alga, nesse caso acaba
    JLT deteta_colisao_assassino_acaba


    ADD R1, 4                       
    MOV R3, LINHA
    CMP R1, R3                      ; Testa se a alga está na linha da Lola, em caso contrário acaba
    JLT deteta_colisao_assassino_acaba


    SUB R1, 4                       
    MOV R4, R10
    ADD R4, 4
    CMP R4, R2                      ; Testa se a Lola está a colidar do lado esquerdo
    JLT deteta_colisao_assassino_acaba


    ADD R2, 4                       
    MOV R4, R10
    CMP R4, R2                      ; Testa se a Lola está a colidir do lado direito
    JGT deteta_colisao_assassino_acaba

    SUB R2, 4                       ; Apaga o assassino que colidiu
    MOV R4, alga_quinta_posicao_5

    SUB R1, 1
    CALL apaga_boneco

    ADD R1, 1
    CALL apaga_boneco

    ADD R1, 1
    CALL apaga_boneco

    ADD R1, 1
    CALL apaga_boneco

    ADD R1, 1
    CALL apaga_boneco

    MOV R8, 1                       ; Para dar Reset na linha da Lula assassina
    MOV [detetou_colisao], R8

    deteta_colisao_assassino_acaba:
        POP R9
        POP R7
        POP R4
        RET

; ***********************************************************************
; ANIMA_TINTA - Desenha e faz subir o missil.                           *
;			 Se chegar ao topo é eliminado e cria outro no fundo        *
;                                                                       *
; ***********************************************************************
anima_tinta:   
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4   
    PUSH R7
    
    MOV R7, 1
    MOV R4, pixel_preto
    MOV R2, [coluna_tinta]
    MOV R1, [linha_tinta]
    
    MOV R3, 26              
    CMP R1, R3                      ; Verifica se o missil já foi lançado ou se está à espera do input do utilizador
    JZ anima_tinta_acaba    
    
    MOV R3, 17
    CMP R1, R3                      ; Verifica se a ponta do missil está a tocar no limite e não é para subir mais
    JGT anima_tinta_2
    
    MOV R3, 15  
    CMP R1, R3                      ; Verifica se o missil chegou à linha limite
    JZ reinicia_tinta
    
    JMP anima_tinta_3
    
    anima_tinta_2:                  ; Neste caso, vai apaga o pixel de baixo e adicionar um acima
        ADD R1, 1
        CALL apaga_boneco

        SUB R1, 2
        CALL desenha_boneco
        
        MOV R2, [score]
        CMP R2, 5                   ; Verifica contra o quê que se está a disparar (pop-ups ou lulas). Se o score for superior a 5, é o BOSS.
        JGT tiro_boss_2
        
        CALL detetar_colisao        ; Se forem pop-ups vai chamar a função detetar_colisao
        JMP anima_tinta_2_acaba
        
        tiro_boss_2:
            MOV R8, 9
            MOV [TOCA_SOM], R8    
            CALL boss_missil        ; Se for o boss chama a função boss_missil
        
        anima_tinta_2_acaba:
            MOV R1, [linha_tinta]       
            SUB R1, 1               ; Faz com que o missil suba
            JMP anima_tinta_acaba
        
        
        
    anima_tinta_3:
        ADD R1, 1                   ; Apaga o pixel de baixo do missil
        CALL apaga_boneco
        SUB R1, 2
        
        MOV R2, [score]
        CMP R2, 5                   ; Verifica contra o quê que se está a disparar (pop-ups ou lulas). Se o score for superior a 5, é o BOSS.
        JGT tiro_boss_3
        
        CALL detetar_colisao        ; Se forem pop-ups vai chamar a função detetar_colisao
        JMP anima_tinta_3_acaba     
        
        tiro_boss_3:
            CALL boss_missil        ; Se for o boss chama a função boss_missil
        
        anima_tinta_3_acaba:
            MOV R1, [linha_tinta]
            SUB R1, 1
            JMP anima_tinta_acaba
    
    reinicia_tinta:
        MOV R1, 26                  ; Para dar reset, coloca o míssil de volta na linha 26
        
    anima_tinta_acaba:
        MOV [linha_tinta], R1       ; Atualiza o valor da linha do missil
        POP  R7
        POP  R4
        POP  R3
        POP  R2
        POP  R1
        RET
   
; ***************************************************************************************************
; ANIMA_POPUP - Desenha e faz descer os pop-ups que podem ser "Lulas assassinas" ou "Algas da Vida".*
;			 Se chegar ao fundo, passam para o topo.                                                *
; ***************************************************************************************************
anima_popup:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    
    MOV  R4, [escolhe_anima_1]  ; Animação do Pop-Up
    MOV  R2, [coluna_popup_1]   ; coluna em que o PopUp está
    MOV  R1, [linha_popup_1]    ; linha em que o PopUp está
    CMP R4, 2                   ; Vê se é uma alga ou assassino (Algas Têm valores 0 e 1, assassinos têm valores entre 2 e 7)
    JLT salto_anima_alga_1      ; Se for alga
    JMP salto_anima_assassino_1 ; Se for assassino
    
    
    anima_popup_2:                  ; Agora para o segundo Pop-Up
        MOV R4, [escolhe_anima_2]   ; Animação do Pop-Up
        MOV  R2, [coluna_popup_2]   ; coluna em que o PopUp está
        MOV  R1, [linha_popup_2]    ; linha em que o PopUp está
        CMP R4, 2                   ; Vê se é uma alga ou assassino
        JLT salto_anima_alga_2      ; Se for alga
        JMP salto_anima_assassino_2 ; Se for assassino
    
    anima_popup_3:                  ; Agora para o terceiro Pop-Up
        MOV R4, [escolhe_anima_3]   ; Animação do Pop-Up
        MOV  R2, [coluna_popup_3]   ; coluna em que o PopUp está
        MOV  R1, [linha_popup_3]    ; linha em que o PopUp está
        CMP R4, 2                   ; Vê se é uma alga ou assassino
        JLT salto_anima_alga_3      ; Se for alga
        JMP salto_anima_assassino_3 ; Se for assassino

    anima_popup_4:                  ; Agora para o quarto Pop-Up
        MOV  R4, [escolhe_anima_4]  ; Animação do Pop-Up
        MOV  R2, [coluna_popup_4]   ; coluna em que o PopUp está
        MOV  R1, [linha_popup_4]    ; linha em que o PopUp está
        CMP R4, 2                   ; Vê se é uma alga ou assassino
        JLT salto_anima_alga_4      ; Se for alga
        JMP salto_anima_assassino_4 ; Se for assassino

    anima_popup_acaba:              ; Fim das animações
        POP  R4
        POP  R3
        POP  R2
        POP  R1
        RET 
   
; ***************************************************************************************************
; ----- Saltos que distinguem as algas dos assassinos e os diferentes Pop-Ups (1, 2, 3 ou 4) -------*
; ***************************************************************************************************   
   salto_anima_alga_1:
    CALL anima_alga                 ; Chama a função anima_alga com os dados pré carregados em R1 e R2
    MOV [linha_popup_1], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_2               ; Volta à função anima_popup
    
salto_anima_assassino_1:
    CALL anima_assassino            ; Chama a função anima_assassino com os dados pré carregados em R1 e R2
    MOV [linha_popup_1], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_2               ; Volta à função anima_popup
   
salto_anima_alga_2:

    CALL anima_alga                 ; Chama a função anima_alga com os dados pré carregados em R1 e  R2
    MOV [linha_popup_2], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_3               ; Volta à função anima_popup
    
salto_anima_assassino_2:
    CALL anima_assassino            ; Chama a função anima_assassino com os dados pré carregados em R1 e R2
    MOV [linha_popup_2], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_3               ; Volta à função anima_popup
    
salto_anima_alga_3:                 
    CALL anima_alga                 ; Chama a função anima_alga com os dados pré carregados em R1 e  R2
    MOV [linha_popup_3], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_4               ; Volta à função anima_popup
    
salto_anima_assassino_3:
    CALL anima_assassino            ; Chama a função anima_assassino com os dados pré carregados em R1 e R2
    MOV [linha_popup_3], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_4               ; Volta à função anima_popup
    
salto_anima_alga_4:
    CALL anima_alga                 ; Chama a função anima_alga com os dados pré carregados em R1 e  R2
    MOV [linha_popup_4], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_acaba           ; Volta à função anima_popup
    
salto_anima_assassino_4:
    CALL anima_assassino            ; Chama a função anima_assassino com os dados pré carregados em R1 e R2
    MOV [linha_popup_4], R1         ; Atualiza o valor da linha, com o valor que ficou guardado em R1
    JMP anima_popup_acaba           ; Volta à função anima_popup
   

; ******************************************************************************************************************
; ANIMA_ASSASSINO - Função responsável por distribuir os assassinos de acordo com as diferentes fases da animação  *
; ******************************************************************************************************************
anima_assassino:
        CMP R1, 3                           ; Verifica se é a primeira animação
        JLT salto_primeiro_assassino_1

        CMP R1, 6                           ; Verifica se é a segunda animação
        JLT salto_segundo_assassino_1

        MOV R3, 9
        CMP R1, R3                          ; Verifica se é a terceira animação
        JLT salto_terceiro_assassino_1

        MOV R3, 12
        CMP R1, R3                          ; Verifica se é a quarta animação
        JLT salto_quarto_assassino_1

        MOV R3, N_LINHAS
        ADD R3, 2
        CMP R1, R3                          ; Verifica se é a quinta e última animação
        JLT salto_quinto_assassino_1

        MOV R1, 0                           ; No caso de não ser nenhuma das anteriores, coloca o assassino de volta na linha 0
        anima_assassino_acaba:
            RET
; ********************************************************************************************************
; ANIMA_ALGA - Função responsável por distribuir as algas de acordo com as diferentes fases da animação  *
; ******************************************************************************************************** 
anima_alga:
        CMP     R1, 3                       ; Verifica se é a primeira animação
        JLT     salto_primeira_alga_1

        CMP     R1, 6
        JLT     salto_segunda_alga_1        ; Verifica se é a segunda animação

        MOV     R3, 9
        CMP     R1, R3
        JLT     salto_terceira_alga_1       ; Verifica se é a terceira animação

        MOV     R3, 12
        CMP     R1, R3                      ; Verifica se é a quarta animação
        JLT     salto_quarta_alga_1          

        MOV     R3, N_LINHAS
        ADD     R3, 2
        CMP     R1, R3                      ; Verifica se é a quinta e última animação
        JLT     salto_quinta_alga_1

        MOV R1, 0                           ; No caso de não ser nenhuma das anteriores, coloca a alga de volta na linha 0
        
        anima_alga_1_acaba:
            RET
            
            
; ***************************************************************************************************
; ------ Saltos dos assassinos que que chamam as funções que distinguem as diferentes fases  -------*
; ***************************************************************************************************  

        
salto_primeiro_assassino_1:
    CALL primeiro_assassino
    JMP anima_assassino_acaba
    
salto_segundo_assassino_1:
    CALL segundo_assassino
    JMP anima_assassino_acaba
    
salto_terceiro_assassino_1:
    CALL terceiro_assassino
    JMP anima_assassino_acaba
    
salto_quarto_assassino_1:
    CALL quarto_assassino
    JMP anima_assassino_acaba
    
salto_quinto_assassino_1:
    CALL quinto_assassino
    JMP anima_assassino_acaba
    
; ***************************************************************************************************
; --------- Saltos das algas que que chamam as funções que distinguem as diferentes fases  ---------*
; ***************************************************************************************************  
    
salto_primeira_alga_1:
    CALL primeira_alga
    JMP anima_alga_1_acaba

salto_segunda_alga_1:
    CALL segunda_alga
    JMP anima_alga_1_acaba

salto_terceira_alga_1:
    CALL terceira_alga
    JMP anima_alga_1_acaba

salto_quarta_alga_1:
    CALL    quarta_alga
    JMP anima_alga_1_acaba

salto_quinta_alga_1:
    CALL    quinta_alga
    JMP anima_alga_1_acaba
    
; ************************************************************************************
; --------As funções abaixo executam todas as animações possíveis dos Pop-Ups------- *
; ************************************************************************************

         ;-----------------------------------------------------------------;
         ;--FUNÇÕES RESPONSÁVEIS PELO MOVIMENTO E ANIMAÇÃO DOS ASSASSINOS--;
         ;-----------------------------------------------------------------;

primeiro_assassino:                              ; Se o programa se encontra aqui, é porque está a desenhar um assassino na primeira fase   
    CMP     R1, 0
    JZ      primeiro_assassino_primeiro          ; Verifica se é o primeiro pixel deste pop-up que será desenhado
    JMP     primeiro_assassino_segundo           ; Verifica se já há algum pixel desenhado deste Pop-up
        
    primeiro_assassino_primeiro:
        MOV     R4, assassino_primeira_posicao   ; Endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                   ; Desenha o boneco a partir da tabela.
        JMP     primeiro_assassino_acaba         ; Termina a função
            
    primeiro_assassino_segundo:
        SUB     R1, 1                            ; Volta para a linha anterior
        MOV     R4, assassino_primeira_posicao   ; Define o endereço da tabela que define o assassino a ser apagado.
        CALL    apaga_boneco                     ; Apaga o pixel anterior
        ADD     R1, 1                            ; Passa para a linha seguinte
        CALL    desenha_boneco                   ; Desenha o pixel na nova posição
        
    primeiro_assassino_acaba:
        ADD     R1, 1                            ; Anda para a linha seguinte 
        RET 
          
segundo_assassino:                            ; Se o programa se encontra aqui, é porque está a desenhar um assassino na segunda fase
    SUB     R1, 1
    MOV     R4, assassino_segunda_posicao_1   ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    apaga_boneco                      ; Apaga os pixeis que estavam na linha anterior
        
    ADD     R1, 1                             ; Passa para a linha seguinte
    CALL    desenha_boneco                    ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                             ; Passa para a linha seguinte
    MOV     R4, assassino_segunda_posicao_2   ; Endereço da tabela que define o boneco.
    CALL    desenha_boneco                    ; Desenha o boneco a partir da tabela.
    RET
    
terceiro_assassino:                          ; Se o programa se encontra aqui, é porque está a desenhar um assassino na terceira fase  
    SUB     R1, 1                            ; Passa para a linha anterior
    MOV     R4, assassino_terceira_posicao_1 ; Define R4 com o endereço da tabela que define o assassino a ser apagado/desenhado.
    CALL    apaga_boneco                     ; Apaga os pixeis que estavam na linha anterior
        
    ADD     R1, 1                            ; Passa para a linha seguinte   
    CALL    desenha_boneco                   ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                            ; Passa para a linha seguinte
    MOV     R4, assassino_terceira_posicao_2 ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                   ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                            ; Passa para a linha seguinte
    MOV     R4, assassino_terceira_posicao_3 ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                   ; Desenha o boneco a partir da tabela.
    
    SUB     R1, 1                            ; Define a linha seguinte
    RET

quarto_assassino:                           ; Se o programa se encontra aqui, é porque está a desenhar um assassino na quarta fase  
    SUB     R1, 1                           ; Volta para a linha anterior          
    MOV     R4, assassino_quarta_posicao_1  ; Define R4 com o endereço da tabela que define o assassino a ser apagado/desenhado.
    CALL    apaga_boneco                    ; Apaga os pixeis que estavam na linha anterior
        
    ADD     R1, 1                           ; Passa para a linha seguinte
    CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                           ; Passa para a linha seguinte
    MOV     R4, assassino_quarta_posicao_2  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                           ; Passa para a linha seguinte
    MOV     R4, assassino_quarta_posicao_3  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                           ; Passa para a linha seguinte
    MOV     R4, assassino_quarta_posicao_4  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela.
        
    SUB     R1, 2                           ; Define a linha seguinte
    RET
        

quinto_assassino:                               ; Se o programa se encontra aqui, é porque está a desenhar um assassino na quinta fase 
        MOV     R3, N_LINHAS
    
        SUB     R1, 1                           ; Volta para a linha anterior  
        MOV     R4, assassino_quinta_posicao_1  ; Define R4 com o endereço da tabela que define o assassino a ser apagado/desenhado.
        CALL    apaga_boneco                    ; Apaga os pixeis que estavam na linha anterior
        
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinto_assassino_acaba_1        ; Se já não estiver no ecrã salta
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
            
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinto_assassino_acaba_2        ; Se já não estiver no ecrã salta
        MOV     R4, assassino_quinta_posicao_2  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
        
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinto_assassino_acaba_3        ; Se já não estiver no ecrã salta
        MOV     R4, assassino_quinta_posicao_3  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.

        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinto_assassino_acaba_4        ; Se já não estiver no ecrã salta
        MOV     R4, assassino_quinta_posicao_4  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
        
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinto_assassino_acaba          ; Se já não estiver no ecrã salta
        MOV     R4, assassino_quinta_posicao_5  ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
        JMP     quinto_assassino_acaba          ; Passar os saltos abaixo
        
        
    quinto_assassino_acaba_1:
        ADD     R1, 4                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
    
    quinto_assassino_acaba_2:   
        ADD     R1, 3                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
        
    quinto_assassino_acaba_3:
        ADD     R1, 2                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
        
    quinto_assassino_acaba_4:
        ADD     R1, 1                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
        

    quinto_assassino_acaba: 
        SUB     R1, 3                           ; Coloca o valor correto das linhas em R1
        RET
    
;----------------------------------------------------------;
;--FUNÇÕES RESPONSÁVEIS PELO MOVIMENTO E ANIMAÇÃO DA ALGA--;
;----------------------------------------------------------;

primeira_alga:                                  ; Se o programa se encontra aqui, é porque está a desenhar uma alga na primeira fase   
    CMP     R1, 0
    JZ      primeira_alga_primeiro              ; Verifica se é o primeiro pixel deste pop-up que será desenhado
    JMP     primeira_alga_segundo               ; Verifica se já há algum pixel desenhado deste Pop-up
        
    primeira_alga_primeiro:
        MOV     R4, alga_primeira_posicao       ; Endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela.
        JMP     primeiro_alga_acaba             ; Termina a função
            
    primeira_alga_segundo:
        SUB     R1, 1                           ; Volta para a linha anterior
        MOV     R4, alga_primeira_posicao       ; Define o endereço da tabela que define o assassino a ser apagado.
        CALL    apaga_boneco                    ; Apaga o pixel anterior
        ADD     R1, 1                           ; Passa para a linha seguinte
        CALL    desenha_boneco                  ; Desenha o pixel na nova posição
        
    primeiro_alga_acaba:
        ADD     R1, 1                           ; Anda para a linha seguinte 
        RET 
               
segunda_alga:                                   ; Se o programa se encontra aqui, é porque está a desenhar uma alga na segunda fase
    SUB     R1, 1
    MOV     R4, alga_segunda_posicao_1          ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    apaga_boneco                        ; Apaga os pixeis que estavam na linha anterior
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    MOV     R4, alga_segunda_posicao_2          ; Endereço da tabela que define o boneco.
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
    RET
    
terceira_alga:                                  ; Se o programa se encontra aqui, é porque está a desenhar uma alga na terceira fase  
    SUB     R1, 1                               ; Passa para a linha anterior
    MOV     R4, alga_terceira_posicao_1         ; Define R4 com o endereço da tabela que define o assassino a ser apagado/desenhado.
    CALL    apaga_boneco                        ; Apaga os pixeis que estavam na linha anterior
        
    ADD     R1, 1                               ; Passa para a linha seguinte   
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    MOV     R4, alga_terceira_posicao_2         ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    MOV     R4, alga_terceira_posicao_3         ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
    
    SUB     R1, 1                               ; Define a linha seguinte
    RET

quarta_alga:                                    ; Se o programa se encontra aqui, é porque está a desenhar uma alga na quarta fase  
    SUB     R1, 1                               ; Volta para a linha anterior          
    MOV     R4, alga_quarta_posicao_1           ; Define R4 com o endereço da tabela que define o assassino a ser apagado/desenhado.
    CALL    apaga_boneco                        ; Apaga os pixeis que estavam na linha anterior
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    MOV     R4, alga_quarta_posicao_2           ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
        
    ADD     R1, 1                               ; Passa para a linha seguinte
    MOV     R4, alga_quarta_posicao_3           ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
            
    ADD     R1, 1                               ; Passa para a linha seguinte
    MOV     R4, alga_quarta_posicao_4            ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
    CALL    desenha_boneco                      ; Desenha o boneco a partir da tabela.
        
    SUB     R1, 2                               ; Define a linha seguinte
    RET
        
quinta_alga:                                    ; Se o programa se encontra aqui, é porque está a desenhar uma alga na quinta fase 
        MOV     R3, N_LINHAS
    
        SUB     R1, 1                           ; Volta para a linha anterior  
        MOV     R4, alga_quinta_posicao_1       ; Define R4 com o endereço da tabela que define o assassino a ser apagado/desenhado.
        CALL    apaga_boneco                    ; Apaga os pixeis que estavam na linha anterior
        
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinta_alga_acaba_1             ; Se já não estiver no ecrã salta
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
            
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinta_alga_acaba_2             ; Se já não estiver no ecrã salta
        MOV     R4, alga_quinta_posicao_2       ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
        
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinta_alga_acaba_3             ; Se já não estiver no ecrã salta
        MOV     R4, alga_quinta_posicao_3       ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.

        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinta_alga_acaba_4             ; Se já não estiver no ecrã salta
        MOV     R4, alga_quinta_posicao_4       ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
        
        ADD     R1, 1                           ; Passa para a linha seguinte
        CMP     R1, R3                          ; Verifica se o Pop-Up já chegou ao final do ecrã
        JGT     quinta_alga_acaba               ; Se já não estiver no ecrã salta
        MOV     R4, alga_quinta_posicao_5       ; Define R4 com o endereço da tabela que define o assassino a ser desenhado.
        CALL    desenha_boneco                  ; Desenha o boneco a partir da tabela, se este ainda estiver no ecrã.
        JMP     quinta_alga_acaba               ; Passar os saltos abaixo
        
        
    quinta_alga_acaba_1:
        ADD     R1, 4                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
    
    quinta_alga_acaba_2:   
        ADD     R1, 3                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
        
    quinta_alga_acaba_3:
        ADD     R1, 2                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
        
    quinta_alga_acaba_4:
        ADD     R1, 1                           ; Se não foram desenhadas tantas linhas, coloca R1, com o valor correto da linha
        JMP     quinto_assassino_acaba          ; Termina a função
        

    quinta_alga_acaba: 
        SUB     R1, 3                           ; Coloca o valor correto das linhas em R1
        RET


; *********************************************************************************************************
;              ESCOLHE_ANIMA - Responsável por escolher as colunas, e animações de cada Pop-up            *
; De seguida chama a função anima_popup para animar os Pop-ups, caso o jogo não esteja no "nível" do BOSS *
; *********************************************************************************************************
escolhe_anima:
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R8
    
    MOV R4, [linha_popup_1]                 
    CMP R4, 0                               ; Verifica se o Pop-Up 1 está a meio de uma animação ou a recomeçar a mesma
    JNZ escolhe_anima_coluna_2              ; Em caso de estar a meio de uma animação passa para o pop-up2
    CALL escolhe_zero_sete                  ; Escolhe uma nova animação aleatória para o pop-up 1
    MOV [escolhe_anima_1], R8               ; Guarda esta nova animação selecionada em memória
    
    escolhe_anima_coluna_1_repete:          ; Repete esta função até a coluna do pop-up 1 até esta não estar em conflito com a coluna de outros pop-up
        CALL escolhe_coluna                 ; Devolve R8, com um número possível de colunas
        MOV [coluna_popup_1], R8            ; Coloca este valor na coluna do pop-up 1
    
        MOV R4, [coluna_popup_2]            
        CMP R8, R4                          ; Compara com a coluna do Pop-Up 2
        JZ escolhe_anima_coluna_1_repete    ; Em caso de colisão repete
            
        MOV R4, [coluna_popup_3]
        CMP R8, R4                          ; Compara com a coluna do Pop-Up 3
        JZ escolhe_anima_coluna_1_repete    ; Em caso de colisão repete
            
        MOV R4,[coluna_popup_4]
        CMP R8, R4                          ; Compara com a coluna do Pop-Up 4
        JZ escolhe_anima_coluna_1_repete    ; Em caso de colisão repete
    
    escolhe_anima_coluna_2:                 ; Passamos agora para o Pop-Up 2
        MOV R4, [linha_popup_2]
        CMP R4, 0                           ; Verifica se o Pop-Up 2 está a meio de uma animação ou a recomeçar a mesma
        JNZ escolhe_anima_coluna_3          ; Em caso de estar a meio de uma animação passa para o pop-up3
    
        CALL escolhe_zero_sete              ; Escolhe uma nova animação aleatória para o pop-up 2
        MOV [escolhe_anima_2], R8           ; Guarda esta nova animação selecionada em memória
    
        escolhe_anima_coluna_2_repete:      ; Repete esta função até a coluna do pop-up 2 até esta não estar em conflito com a coluna de outros pop-up
            CALL escolhe_coluna             ; Devolve R8, com um número possível de colunas
            MOV [coluna_popup_2], R8        ; Coloca este valor na coluna do pop-up 2
        
            MOV R4, [coluna_popup_1]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 1
            JZ escolhe_anima_coluna_2_repete; Em caso de colisão repete
            
            MOV R4, [coluna_popup_3]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 3
            JZ escolhe_anima_coluna_2_repete; Em caso de colisão repete
            
            MOV R4,[coluna_popup_4]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 2
            JZ escolhe_anima_coluna_2_repete; Em caso de colisão repete
    
    escolhe_anima_coluna_3:                 ; Passamos agora para o Pop-Up 3
        MOV R4, [linha_popup_3]
        CMP R4, 0                           ; Verifica se o Pop-Up 3 está a meio de uma animação ou a recomeçar a mesma
        JNZ escolhe_anima_coluna_4          ; Em caso de estar a meio de uma animação passa para o pop-up4
    
        CALL escolhe_zero_sete              ; Escolhe uma nova animação aleatória para o pop-up 3
        MOV [escolhe_anima_3], R8           ; Guarda esta nova animação selecionada em memória
    
        escolhe_anima_coluna_3_repete:      ; Repete esta função até a coluna do pop-up 3 até esta não estar em conflito com a coluna de outros pop-up
            CALL escolhe_coluna             ; Devolve R8, com um número possível de colunas
            MOV [coluna_popup_3], R8        ; Coloca este valor na coluna do pop-up 3

            MOV R4, [coluna_popup_1]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 1
            JZ escolhe_anima_coluna_3_repete; Em caso de colisão repete
            
            MOV R4, [coluna_popup_2]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 2
            JZ escolhe_anima_coluna_3_repete; Em caso de colisão repete
            
            MOV R4,[coluna_popup_4] 
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 4
            JZ escolhe_anima_coluna_3_repete; Em caso de colisão repete
    
    escolhe_anima_coluna_4:                 ; Passamos agora para o Pop-Up 4
        MOV R4, [linha_popup_4]
        CMP R4, 0                           ; Verifica se o Pop-Up 4 está a meio de uma animação ou a recomeçar a mesma
        JNZ escolhe_anima_acaba             ; Em caso de estar a meio de uma animação, termina a função
        
        
        CALL escolhe_zero_sete              ; Escolhe uma nova animação aleatória para o pop-up 4
        MOV [escolhe_anima_4], R8           ; Guarda esta nova animação selecionada em memória
    
    
        escolhe_anima_coluna_4_repete:      ; Repete esta função até a coluna do pop-up 4 até esta não estar em conflito com a coluna de outros pop-up
        
            CALL escolhe_coluna             ; Devolve R8, com um número possível de colunas
            MOV [coluna_popup_4], R8        ; Coloca o valor de R8 na coluna do pop-up 4
        
            MOV R4, [coluna_popup_1]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 1
            JZ escolhe_anima_coluna_4_repete; Em caso de colisão repete
            MOV R4, [coluna_popup_2]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 2
            JZ escolhe_anima_coluna_4_repete; Em caso de colisão repete
            MOV R4,[coluna_popup_3]
            CMP R8, R4                      ; Compara com a coluna do Pop-Up 3
            JZ escolhe_anima_coluna_4_repete; Em caso de colisão repete

    escolhe_anima_acaba:
        MOV     R8, 5
        MOV     R4, [score]
        CMP     R4, R8                      ; Verifica se está no nivel principal ou no BOSS (score inferior a 6)
        JLT     anima_pop                   ; Se está no nível principal salta para a chamada da função da animação dos pop-ups
        JMP     sai_rot_escolhe             ; Se está no BOSS, termina a função
        
        anima_pop:
            CALL    anima_popup             ; Função responsável pelas animações
            
        sai_rot_escolhe:
            POP     R8
            POP     R4
            POP     R2
            POP     R1
            RET

; *****************************************************************************
;      ESCOLHE_ZERO_SETE - Devolve R8 com um número aleatório entre 0 e 7     *
; *****************************************************************************
escolhe_zero_sete:
    PUSH    R1

    MOV     R1, PIN      ; R1 recebe o endereço do periférico do PIN     
    MOVB    R8, [R1]     ; lê o periférico
    SHR     R8, 5        ; Fica com os últimos digitos do periférico que é um número entre o e 7
    
    POP     R1
    RET

; ********************************************************************************
; ESCOLHE_COLUNA - Devolve R8 com um número possível e aleatório para as colunas *
; ********************************************************************************
escolhe_coluna:
    PUSH R1
    
    CALL escolhe_zero_sete      ; Escolhe um número entre 0 e 7
    MOV R1, 8                   
    MUL R8, R1                  ; Multiplica-o por 8, dando assim o número de 8 colunas diferentes entrecaladas por 8 pixeis

    POP R1
    RET
    
; ***************************************************************************************************************
;                                                   DETETAR_COLISAO                                             *
;                           Verifica se ocorreu uma colisão entre o missil e algum pop-up                       *
;                   Em caso afirmativo chama funções para apagar o pop-up, o missil e aumentar o score          *
; *************************************************************************************************************** 
detetar_colisao:
    PUSH R3
    PUSH R6
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R9
    
    MOV R3, [linha_tinta]
    MOV R6, [linha_popup_1]
    ADD R6, 5  
    CMP R3, R6
    JLT detetar_colisao_1


    detetar_colisao_inter_2:
        MOV R3, [linha_tinta]
        MOV R6, [linha_popup_2]
        ADD R6, 5
        CMP R3, R6
        JLT detetar_colisao_2
        
    detetar_colisao_inter_3:
        MOV R3, [linha_tinta]
        MOV R6, [linha_popup_3]
        ADD R6, 5
        CMP R3, R6
        JLT detetar_colisao_3
        
    detetar_colisao_inter_4:
        MOV R3, [linha_tinta]
        MOV R6, [linha_popup_4]
        ADD R6, 5
        CMP R3, R6
        JLT detetar_colisao_4
        JMP fim_detetar_colisao
    
    
    
    detetar_colisao_1:
    
        MOV R3, [coluna_tinta]
   
        MOV R6, [coluna_popup_1]
        CMP R3, R6
        JLT detetar_colisao_inter_2
    
    
        ADD R6, 4
        CMP R3, R6
        JGT detetar_colisao_inter_2
        
        MOV R1, [linha_popup_1]
        SUB R1, 1
        MOV R2, [coluna_popup_1]
        MOV R9, [escolhe_anima_1]
        
        CALL apagar_boneco_quinta_posicao
        MOV R3, 0
        MOV [linha_popup_1], R3
        CALL apaga_missil
        MOV R3, 27
        MOV [linha_tinta], R3
        JMP fim_detetar_colisao
        
    
    detetar_colisao_2:
    
        MOV R3, [coluna_tinta]
   
        MOV R6, [coluna_popup_2]
        CMP R3, R6
        JLT detetar_colisao_inter_3
    
    
        ADD R6, 4
        CMP R3, R6
        JGT detetar_colisao_inter_3
        
        MOV R1, [linha_popup_2]
        SUB R1, 1
        MOV R2, [coluna_popup_2]
        MOV R9, [escolhe_anima_2]
        

        CALL apagar_boneco_quinta_posicao

        MOV R3, 0
        MOV [linha_popup_2], R3
        CALL apaga_missil
        MOV R3, 27
        MOV [linha_tinta], R3
        JMP fim_detetar_colisao
        

    detetar_colisao_3:
    
        MOV R3, [coluna_tinta]
   
        MOV R6, [coluna_popup_3]
        CMP R3, R6
        JLT detetar_colisao_inter_4
    
    
        ADD R6, 4
        CMP R3, R6
        JGT detetar_colisao_inter_4
        
        MOV R1, [linha_popup_3]
        SUB R1, 1
        MOV R2, [coluna_popup_3]
        MOV R9, [escolhe_anima_3]
        

        CALL apagar_boneco_quinta_posicao

        MOV R3, 0
        MOV [linha_popup_3], R3
        CALL apaga_missil
        MOV R3, 27
        MOV [linha_tinta], R3
        JMP fim_detetar_colisao
        
        
        
    detetar_colisao_4:
    
        MOV R3, [coluna_tinta]
   
        MOV R6, [coluna_popup_4]
        CMP R3, R6
        JLT fim_detetar_colisao
    
    
        ADD R6, 4
        CMP R3, R6
        JGT fim_detetar_colisao
        
        MOV R1, [linha_popup_4]
        SUB R1, 1
        MOV R2, [coluna_popup_4]
        MOV R9, [escolhe_anima_4]

        CALL apagar_boneco_quinta_posicao

        MOV R3, 0
        MOV [linha_popup_4], R3
        CALL apaga_missil
        MOV R3, 27
        MOV [linha_tinta], R3
        MOV [linha_tinta], R3

        
    
    
    fim_detetar_colisao:
    POP R9
    POP R4
    POP R2
    POP R1
    POP R6
    POP R3
    RET

; ***************************************************************************************************************
;                                              APAGA_BONECO_QUINTA_POSICAO                                      *
;                           Recebe R1 com a linha, R2 com a coluna e R9 com a animação                          *
; Apaga o pop-up que se encontra na posição (R1, R2), e se este for um assassino aumenta o um contador "score"  *
; *************************************************************************************************************** 
    
    
apagar_boneco_quinta_posicao:
    PUSH    R4
    PUSH    R7
    
    CMP     R9, 2                   ; Verifica se é uma alga ou um assassino
    JLT     continua_fzr_explosao   
    MOV     R4, [score]
    ADD     R4, 1                   ; Caso seja assassino aumenta o score
    MOV     [score], R4
    MOV     R7, 5
    ciclo_aumenta_energia_1:              ; Para aumentar a energia em 10, é feito um ciclo que aumenta a energia 10 vezes
        CMP     R7,0
        JZ      atualiza_contador_1
        CALL    conversao_aumenta   
        SUB     R7,1
        JMP     ciclo_aumenta_energia_1
        
        atualiza_contador_1:
        MOV     [R11], R5               ; Depois atualiza o valor no display
        
    
 
    continua_fzr_explosao:          ; Cria um efeito visual que simula uma explosão
        MOV     R4, explosaolinha1  ; Coloca em R4 a camada a ser desenhada
        CALL    desenha_boneco      ; Desenha a explosão a partir da tabela

        ADD     R1, 1               ; Avança para a linha seguinte
        MOV     R4, explosaolinha2  ; Coloca em R4 a camada a ser desenhada
        CALL    desenha_boneco      ; Desenha a explosão a partir da tabela

        ADD     R1, 1               ; Avança para a linha seguinte
        MOV     R4, explosaolinha3  ; Coloca em R4 a camada a ser desenhada
        CALL    desenha_boneco      ; Desenha a explosão a partir da tabela

        ADD     R1, 1               ; Avança para a linha seguinte
        MOV     R4, explosaolinha4  ; Coloca em R4 a camada a ser desenhada
        CALL    desenha_boneco      ; Desenha a explosão a partir da tabela

        ADD     R1, 1               ; Avança para a linha seguinte
        MOV     R4, explosaolinha5  ; Coloca em R4 a camada a ser desenhada
        CALL    desenha_boneco      ; Desenha a explosão a partir da tabela

        MOV     R8, 4               ; Seleciona o som de destruição
        MOV     [TOCA_SOM], R8      ; Reproduz o som selecionado

        CALL    temporizador        ; Chama a função "Temporizador" para retardar o resto da função
        
    cont_apaga_explosao:
        SUB     R1, 4              ; Recua para a linha inicial
        CALL    apaga_boneco       ; Apaga a linha em questão

        ADD     R1, 1              ; Avança para a linha seguinte
        CALL    apaga_boneco       ; Apaga a linha em questão

        ADD     R1, 1              ; Avança para a linha seguinte
        CALL    apaga_boneco       ; Apaga a linha em questão

        ADD     R1, 1              ; Avança para a linha seguinte
        CALL    apaga_boneco       ; Apaga a linha em questão

        ADD     R1, 1              ; Avança para a linha seguinte
        CALL    apaga_boneco       ; Apaga a linha em questão

        POP     R7
        POP     R4
        RET    
    
    
; ********************************************************************************
;          APAGA_MISSIL - Apaga o missil na posição em que se encontra           *
; ********************************************************************************

apaga_missil:
    MOV     R1, [linha_tinta]   ; Coloca em R1 a linha em que o missil se encontra
    MOV     R2, [coluna_tinta]  ; Coloca em R2 a coluna em que o missil se encontra    
    MOV     R4, pixel_preto     ; Coloca em R4 a camada a apagar
    CALL    apaga_boneco        ; Apaga o pixel selecionado pelos registos (R1, R2)
    
    ADD     R1, 1               ; Passa para a linha seguinte
    CALL    apaga_boneco        ; Apaga o pixel selecionado pelos registos (R1, R2)
    
    MOV     R1, 26              ; Coloca o missil de volta na linha inicial
    MOV     [linha_tinta], R1   ; Passa este valor para memória
    RET
    
; ********************************************************************************
;               APAGA_BONECOS - Apaga todos so Pop-Up na posição                 *
;        Esta função fornece os argumentos (R1, R2) à função apagar_bonecos      *
;                 No final reseta a posição dos quatro Pop-Ups                   *
; ******************************************************************************** 


apagar_todos_popups:
    PUSH R1
    PUSH R2
    
    MOV     R1, [linha_popup_1]     ; Passa a R1 a linha do Pop-Up a eliminar
    MOV     R2, [coluna_popup_1]    ; Passa a R2 a coluna do Pop-Up a eliminar
    CALL    apagar_bonecos          ; Chama a função que apagará o Pop-Up completo com os argumentos dados (R1, R2)
    
    
    MOV     R1, [linha_popup_2]     ; Passa a R1 a linha do Pop-Up a eliminar
    MOV     R2, [coluna_popup_2]    ; Passa a R2 a coluna do Pop-Up a eliminar
    CALL    apagar_bonecos          ; Chama a função que apagará o Pop-Up completo com os argumentos dados (R1, R2)
    
    MOV     R1, [linha_popup_3]     ; Passa a R1 a linha do Pop-Up a eliminar
    MOV     R2, [coluna_popup_3]    ; Passa a R2 a coluna do Pop-Up a eliminar
    CALL    apagar_bonecos          ; Chama a função que apagará o Pop-Up completo com os argumentos dados (R1, R2)
    
    MOV     R1, [linha_popup_4]     ; Passa a R1 a linha do Pop-Up a eliminar
    MOV     R2, [coluna_popup_4]    ; Passa a R2 a coluna do Pop-Up a eliminar
    CALL    apagar_bonecos          ; Chama a função que apagará o Pop-Up completo com os argumentos dados (R1, R2)
    
    MOV     R1, 0
    MOV     [linha_popup_1], R1     ; Coloca o Pop-Up 1 na posição inicial (linha 0)
    MOV     [linha_popup_2], R1     ; Coloca o Pop-Up 2 na posição inicial (linha 0)
    MOV     [linha_popup_3], R1     ; Coloca o Pop-Up 3 na posição inicial (linha 0)
    MOV     [linha_popup_4], R1     ; Coloca o Pop-Up 4 na posição inicial (linha 0)
    
    POP     R2
    POP     R1
    RET
    
; ********************************************************************************
;               APAGA_BONECOS - Apaga o Pop-Up na posição (R1, R2)               *
;             Recebe como argumentos R1 com a linha e R2 com a coluna            *
; ********************************************************************************    
    
    
apagar_bonecos:
    PUSH R4
    
    MOV     R4, assassino_quinta_posicao_5  ; Coloca em R4 uma camada com 5 pixeis
    CALL    apaga_boneco                    ; Apaga os pixeis na posição dada -> (R1, R2)
    ADD     R1, 1                           ; Passa para a linha seguinte
    CALL    apaga_boneco                    ; Apaga os pixeis na posição dada -> (R1, R2)        
    ADD     R1, 1                           ; Passa para a linha seguinte
    CALL    apaga_boneco                    ; Apaga os pixeis na posição dada -> (R1, R2)
    ADD     R1, 1                           ; Passa para a linha seguinte
    CALL    apaga_boneco                    ; Apaga os pixeis na posição dada -> (R1, R2)
    ADD     R1, 1                           ; Passa para a linha seguinte
    CALL    apaga_boneco
    
    POP     R4
    RET

; ********************************************************************************
;                                DETETA_COLISAO_ALGA                             *
;                       Verifica se a Lola colidiu com alguma Alga               *
;  Esta passa os argumentos R1 com a Linha, R2 com a Coluna e R3 com a Animação  *
;                       Para a função auxiliar deteta_colisao_alga_1             *
; ********************************************************************************    

deteta_colisao_alga:
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R8
        
    MOV     R1, [linha_popup_1]     ; Passa para R1 a linha do Pop-Up a testar
    MOV     R2, [coluna_popup_1]    ; Passa a R2 a coluna do Pop-Up a testar
    MOV     R3, [escolhe_anima_1]   ; Passa a R3 a animação do Pop-Up a testar
    CALL    deteta_colisao_alga_1   ; Chama a função que fará os testes com os argumentos dados
    MOV     [linha_popup_1], R8     ; Atualiza a linha do Pop-Up caso necessário
    
    MOV     R1, [linha_popup_2]     ; Passa para R1 a linha do Pop-Up a testar
    MOV     R2, [coluna_popup_2]    ; Passa a R2 a coluna do Pop-Up a testar
    MOV     R3, [escolhe_anima_2]   ; Passa a R3 a animação do Pop-Up a testar
    CALL    deteta_colisao_alga_1   ; Chama a função que fará os testes com os argumentos dados
    MOV     [linha_popup_2], R8     ; Atualiza a linha do Pop-Up caso necessário
    
    MOV     R1, [linha_popup_3]     ; Passa para R1 a linha do Pop-Up a testar
    MOV     R2, [coluna_popup_3]    ; Passa a R2 a coluna do Pop-Up a testar
    MOV     R3, [escolhe_anima_3]   ; Passa a R3 a animação do Pop-Up a testar
    CALL    deteta_colisao_alga_1   ; Chama a função que fará os testes com os argumentos dados
    MOV     [linha_popup_3], R8     ; Atualiza a linha do Pop-Up caso necessário
    
    
    MOV     R1, [linha_popup_4]     ; Passa para R1 a linha do Pop-Up a testar
    MOV     R2, [coluna_popup_4]    ; Passa a R2 a coluna do Pop-Up a testar
    MOV     R3, [escolhe_anima_4]   ; Passa a R3 a animação do Pop-Up a testar
    CALL    deteta_colisao_alga_1   ; Chama a função que fará os testes com os argumentos dados
    MOV     [linha_popup_4], R8     ; Atualiza a linha do Pop-Up caso necessário
    
    POP     R8
    POP     R3
    POP     R2
    POP     R1
    RET

; ********************************************************************************
;                                DETETA_COLISAO_ALGA_1                           *
;                       Função auxiliar da deteta_colisao_alga                   *
;    Recebe os argumentos R1 com a Linha, R2 com a Coluna e R3 com a Animação    *
; ********************************************************************************     
deteta_colisao_alga_1:
    PUSH    R4
    PUSH    R7
    MOV     R8, R1
    
    CMP     R3, 1                       ; Verifica se é uma alga
    JGT     deteta_colisao_alga_acaba
    
    
    ADD     R1, 4                       
    MOV     R3, LINHA
    CMP     R1, R3                      ; Testa se a alga está na linha de colisão com a Lola
    JLT     deteta_colisao_alga_acaba
    

    SUB     R1, 4                       ; Testa se a Lola está na coluda da esquerda
    MOV     R4, R10
    ADD     R4, 4
    CMP     R4, R2
    JLT     deteta_colisao_alga_acaba
    
    
    ADD     R2, 4                       ; Testa se a Lola está na coluda da direita
    MOV     R4, R10
    CMP     R4, R2
    JGT     deteta_colisao_alga_acaba
    
    SUB     R1, 1
    SUB     R2, 4                       ; Apaga a alga
    
    CALL    apagar_bonecos              ; Chama a função para apagar a folha
    CALL    mudar_cor_lola              ; Muda a cor da Lola

    MOV     R8, 0                       ; Para resetar a linha da folha eliminada
    MOV     R7,10

    ciclo_aumenta_energia:              ; Para aumentar a energia em 10, é feito um ciclo que aumenta a energia 10 vezes
        CMP     R7,0
        JZ      atualiza_contador
        CALL    conversao_aumenta
        SUB     R7,1
        JMP     ciclo_aumenta_energia
        
    atualiza_contador:
        MOV     [R11], R5               ; Depois atualiza o valor no display
        
    deteta_colisao_alga_acaba:
        POP     R7
        POP     R4
        RET

; ********************************************************************************
;                                DETETA_COLISAO_ALGA_1                           *
;                  Alterna a cor da Lola entre Verde e a cor original            *
;                               Não recebe argumentos                            *
; ********************************************************************************  

mudar_cor_lola:
    
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5
    PUSH R8

    MOV R8, 7                       ; Seleciona o som tocado quando a Lola apanha uma folha
    MOV [TOCA_SOM], R8              ; Reproduz o som selecionado
    MOV R5, 2                       ; Número de vezes que a Lola vai "piscar" verde

    mudar_cor_lola_repete:
        
        MOV     R1, LINHA           ; Passa para R1 a Linha em que a Lola se encontra
        MOV     R2, R10             ; Passa para R2 a Coluna em que a Lola se encontra

        MOV     R4, lola_verde_5    ; Passa para R4 a camada verde a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela

        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, lola_verde_4    ; Passa para R4 a camada verde a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela

        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, lola_verde_3    ; Passa para R4 a camada verde a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela

        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, lola_verde_2    ; Passa para R4 a camada verde a desenhar
        CALL    desenha_boneco

        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, lola_verde_1    ; Passa para R4 a camada verde a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela
        
        CALL    temporizador        ; Chama um temporizador para que a mudança seja notávelmente visivél


        MOV     R1, LINHA           ; Passa para R1 a Linha em que a Lola se encontra
        MOV     R2, R10             ; Passa para R2 a Coluna em que a Lola se encontra
        MOV     R4, camada_5        ; Passa para R4 a camada original a desenhar
        CALL    desenha_boneco
        
        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, camada_4        ; Passa para R4 a camada original a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela
                
        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, camada_3        ; Passa para R4 a camada original a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela
        
        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, camada_2        ; Passa para R4 a camada original a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela
    
        ADD     R1, 1               ; Passa para a linha seguinte
        MOV     R4, camada_1        ; Passa para R4 a camada original a desenhar
        CALL    desenha_boneco      ; Desenha o boneco a partir da tabela
        
        CALL    temporizador        ; Chama um temporizador para que a mudança seja notávelmente visivél

        SUB     R5, 1
        CMP     R5, 0
        JNZ     mudar_cor_lola_repete  ; Repete o ciclo até ter completado as voltas pedidas em R5
        
    POP     R8
    POP     R5
    POP     R4
    POP     R2
    POP     R1
    RET
; ********************************************************************************
;                                    TEMPORIZADOR                                *
;                 Responsável por criar um atraso ou tempo entre instruções      *
;                               Não recebe argumentos                            *
; ******************************************************************************** 
    
temporizador:
    PUSH R7
    
    MOV     R7, 0                   
    ciclo_temporizador:
        SUB     R7, 1               ; R7 estava a 0, por isso ao subtrir 1, irá tornar-se no maior número possível
        CMP     R7, 0               ; Comppara se o ciclo chegou ao fim
        JNZ     ciclo_temporizador
        
    ciclo_temporizador_2:   
        SUB     R7, 1               ; R7 estava a 0, por isso ao subtrir 1, irá tornar-se no maior número possível
        CMP     R7, 0               ; Comppara se o ciclo chegou ao fim
        JNZ     ciclo_temporizador_2    
    
    POP     R7
    RET

; ********************************************************************************
;                                 DESENHA BOSS                                   *
;                         Responsável por desenhar o boss                        *
;                               Não recebe argumentos                            *
; ********************************************************************************



desenha_boss:
    PUSH R1
    PUSH R2
    PUSH R4

    MOV R1,1
    MOV [desenhamos_boss], R1
    
    CALL animacao
    
    MOV R1, LINHA
    MOV R2, R10
    MOV R4, camada_5
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, camada_4
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, camada_3
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, camada_2
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, camada_1
    CALL desenha_boneco
    
    
    MOV R1, 2
    MOV R2, 24
    MOV R4, BOSS_15
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_14
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_13
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_12
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_11
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_10
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_9
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_8
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_7
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_6
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_5
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_4
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_3
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_2
    CALL desenha_boneco
    
    ADD R1, 1
    MOV R4, BOSS_1
    CALL desenha_boneco
    
    MOV R1, 6
    MOV R2, 0
    MOV R4, pixel_preto
    CALL desenha_boneco
    
    MOV R1, 13
    CALL desenha_boneco
    
    MOV R8, 1
    MOV [PARA_SOM], R8
    MOV R8, 8
    MOV [TOCA_SOM], R8
    
    DI
    EI
    EI1
    EI2

    POP R4
    POP R2
    POP R1
    RET
    
    

; ********************************************************************************
;                              DETETA COLISAO MISSIL                             *
;              Responsável por detetar a colisao entre missil e o boss           *
;                               Não recebe argumentos                            *
; ********************************************************************************    
    
boss_missil:
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    
    MOV R1, [linha_tinta]
    MOV R2, 16
    CMP R1, R2
    JGT acaba_boss_missil
    
    MOV R1, [coluna_tinta]
    MOV R2, 24
    CMP R1, R2
    JLT acaba_boss_missil
    
    MOV R3, 15
    ADD R2, R3
    CMP R1, R2
    JGT acaba_boss_missil
    
    MOV R1, [score]
    ADD R1, 1
    MOV [score], R1
    MOV R2, 0
    MOV R4, pixel_vermelho
    CALL desenha_boneco
    
    acaba_boss_missil:
        POP R4
        POP R3
        POP R2
        POP R1
        RET
    
; ********************************************************************************
;                              Conversao Aumenta                                 *
;          Responsável por converter hexadecimal em decimal e aumentar 1         *
;                               Não recebe argumentos                            *
; ******************************************************************************** 
    
    
conversao_aumenta:
          PUSH R1
          PUSH R2
          PUSH R3
          PUSH R4
          
          MOV R1, 0100H             ; Passamos para R1 o valor 100 para comparar com R5
          CMP R5, R1                ; Caso R5 esteja a valer 100, terminamos o código, pois 100 é o máximo
          JZ TERMINA                ; Saltamos para o termina caso a comparação se verifique
          
          MOV R1, 0099H             ; Passamos para R1 o valor 0099H para comparar com R5
          CMP R5, R1                ; Caso R5 esteja a valer 0099H, convertemos logo para 100 pois não vale a pena estar a passar pelo sistema de conversão
          JZ passa100               ; Salta para o passa100 caso a comparação se verifique
    
          ADD R5,1                  ; Adicionamos 1 ao R5
          MOV R4, R5                ; Passamos o valor para R4 para trabalharmos o valor de R5, sem criar conflitos com o valor atual
          MOV R2, 0010H             ; Paasamos 10 ao valor R2
          ADD R4,6                  ; Somamos 6 ao valor de R4, para ver se já chegamos ao valor A, pois A+6 igual a 10, 1A+6 = 20, etc
          MOD R4, R2                ; Fazemos o resto da divisão
          CMP R4,0                  ; Comparamos com 0
          JZ aumenta2               ; Caso seja 0, saltamos para o aumenta2
          JMP TERMINA               ; Caso não seja 0, significa quem ainda não chegamos ao Valor A
          
    aumenta2:
            ADD R5, 6               ; Somamos 6  a R5 para saltar os valores A,B,C,D,E,F, portanto do 9, passamos para 10 e etc
            JMP TERMINA             ; Acabamos a conversão
    passa100:
            MOV R5, 0100H           ; Passamos o valor para 100 
            JMP TERMINA             ; Acabamos a conversão
    

; ********************************************************************************
;                              Conversao Diminui                                 *
;      Responsável por converter hexadecimal em decimal e decrementar 5          *
;                               Não recebe argumentos                            *
; ******************************************************************************** 
          
conversao_diminui:
         PUSH R1
         PUSH R2
         PUSH R3
         PUSH R4
         
         MOV R1, 0100H              ; Passamos para R1 o valor 100 para comparar com R5
         CMP R5, R1                 ; Caso R5 esteja a valer 100 saltamos logo para 95, não vale a pena estar a passar pela conversão
         JZ passa95                 ; Faz o salto para a conversão de 100 -> 95
         SUB R5, 5                  ; Subtraímos 5 a R5
         MOV R1,0                   ; Passamos para R1 o valor 0 para comparar com R5
         CMP R5,R1                  ; Comparamos os valores
         JLE passa0                 ; Caso (R5-5)<R1, automaticamente passamos o valor para 0, fazendo o JLE    
         MOV R1, 0010H              ; Passamos para R1 o valor 0010H
         MOV R3, R5                 ; Guardamos o valor de R5 noutro registo para alterar o valor guardado em R5 sem haver conflitos
         MOD R3, R1                 ; Fazemos o resto da divisão
         CMP R3, 0                  ; Caso dê 0 nesta situação, significa que passamos de, por exemplo, 95->90, logo não precisamos de fazer mais nada
         JZ  TERMINA                ; Terminamos a conversão
         ADD R3, 1                  ; Caso contrário, somamos mais 1 para ver em que tipo de número estamos, tratando dos casos: 94-5 = 8F
         MOD R3, R1                 ; Fazemos o resto da divisão
         CMP R3,0                   ; Caao dê 0, significa que estavamos num caso do mesmo tipo do exemplo, sabemos assim que temos então que retirar 6, 8F-6 = 89
         JZ diminui1                ; Chamamos a função que faz esse decremento por 6
         MOV R3, R5                 ; Caso contrário, voltamos a atualizar o valor de R3, pois tinhamos trabalhado com ele anteriormente
         ADD R3, 2                  ; Somamos então mais 2 para tratar de casos: 93-5 = 8E
         MOD R3, R1                 ; Fazemos o resto da divisão, pois se estivermos num caso com E, ao somarmos 2, vamos ter um número múltiplo de 10 
         CMP R3,0                   ; Comparamos para ver se era este o caso
         JZ diminui1                ; Caso seja saltamos para o código que decrementa 6
         MOV R3, R5                 ; Caso contrário voltamos a atualizar o valor de R3, pois tinhamos trabalhado com ele anteriormente
         ADD R3, 3                  ; Somamos 3 para casos tipo: 92-5 = 8D, 8D+3 = 90 
         MOD R3, R1                 ; Fazemos o resto da divisão para verificar se estamos num caso D
         CMP R3,0                   ; A comparação verifica se de facto é um caso D ou não
         JZ diminui1                ; Caso seja, saltamos para a parte do código que decrementa 6
         MOV R3, R5                 ; Voltamos a atualizar o valor de R3, pois tinhamos trabalhado com ele anteriormente
         ADD R3, 4                  ; Somamos 4 para os casos tipo 91-5 = 8C, 8C+4 = 90
         MOD R3, R1                 ; Fazemos o resto da divisão para verificar se estamos num caso C
         CMP R3,0                   ; A comparação verifica se de facto é um caso C ou não
         JZ diminui1                ; Caso seja saltamos para o código que decrementa 6
         MOV R3, R5                 ; Voltamos a atualizar o valor de R3, pois tinhamos trabalhado com ele anteriormente    
         ADD R3, 5                  ; Somamos 5 para os casos tipo 90-5 = 8B, 8B+5 = 90
         MOD R3, R1                 ; Fazemos o resto da divisão para verificar se estamos num caso B
         CMP R3,0                   ; A comparação verifica se de facto é um caso B ou não
         JZ diminui1                ; Caso seja saltamos para o código que decrementa 6
        
        ; Não precisamos fazer para o caso A, pois a seguir a números como 90, 80, etc, vêem números como 89, 79 etc
        ; decrementando 5 = 84, 74, logo não precisam de qualquer tipo de conversão
        
         JMP TERMINA                ; Terminamos a conversão
    
    diminui1:
             SUB R5, 6              ; Decrementamos 6
             JMP TERMINA            ; Terminamos a conversão


    passa95:
        MOV R5, 0095H               ; Passamos o valor 95 para R5
        JMP TERMINA                 ; Terminamos a conversão
    
    passa0:
        MOV R5,0                    ; Passamos o valor 0 para R5
    
    TERMINA:                        ; Termina a conversão
        POP R4
        POP R3
        POP R2
        POP R1
        RET
        