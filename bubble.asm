jmp main



; ------ Programa Principal -----------

msg1: string "Vetor sem ordenar: "
msg2: string "Vetor ordenado: "
;msg1: string "Digite a primeira string: "
;msg2: string "Digite a segunda string: "
;msg3: string "Resultado: "
str1: var #40
str2: var #40
vec1: var #8

main:

	;constroi vetor
	call SetVector

	;imprime primeira msg
	loadn r1, #msg1
	loadn r0, #0
	call ImprimeString    ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa
	
	;imprime vetor
	loadn r0, #vec1
	loadn r1, #8
	loadn r2, #40
	call PrintVector  ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela
	
	
	;troca posicao
	;r0->vector, r1->pos1, r2->pos2
	;loadn r0, #vec1
	;loadn r1, #0
	;loadn r2, #6
	;call SwapVectorElement
	
	;imprime primeira msg
	loadn r1, #msg2
	loadn r0, #120
	call ImprimeString    ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa
	
	
	;ordena com bubblesort
	loadn r0, #vec1
	loadn r1, #8
	call Bubble_Sort
	
	;imprime vetor trocado
	;imprime vetor
	loadn r0, #vec1
	loadn r1, #8
	loadn r2, #160
	call PrintVector  ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela
	
	
	halt
	
	
;*********************************SET VECTOR***************************/
SetVector:

  push r0
  push r1

  loadn r0, #vec1
  loadn r1, #7   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #5   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #9   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #2   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #9   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #1   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #3   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #4   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  
  pop r1
  pop r0
  
 
  
  rts
  
  
;****************************BUBBLE_SORT*****************************************
Bubble_Sort:  ;r0->vector, r1->size_vector
  
  push r2
  push r3
  push r4
  push r5
  push r6
  
  loadn r6, #0  ;contador do laco externo
 
  
Bubble_Sort_Out_Loop: ;loop externo

 mov r5, r1    ;contador do laco interno
 dec r5         ;r5 = length -1
  
Bubble_Sort_In_Loop:


  ;obtem vec[j]
  add r2, r0, r5    ; r2 = posicao de memoria de vec[j]
  loadi r4, r2      ; r4 = vec[j]   
  
  ;obtem vec[j-1]
  dec r2
  loadi r3, r2      ;r3 = vec[j-1]
 
  push r1           ;empilha r1 e r2, pois
  push r2           ;deverao ser setados caso haja swap()
  
  mov r1, r5       ;r1 = posicao j
  mov r2, r1
  dec r2           ;r1 = posicao j-1
  ;compara vec[j-1] > vec[j]
  cmp r3, r4
  ;troca se r3 > r4 (vec[j-1] > vec[j])
  cgr SwapVectorElement  ;r0->vector, r1->pos1, r2->pos2
  
  pop r2          ;recupera os valores de r2 e r1, pois
  pop r1	  ;swap() já pode ter usado esses registradores
  
  

  ;verifica condicao para loop interno
  dec r5          ;decrementa contador do loop interno
  inc r6          ;incrementa contador externo só pra ser comparado
  cmp r5, r6      ;comparacao do loop interno se j > i + 1
  dec r6          ;recupera o valor atual do contador do loop externo
  jeg Bubble_Sort_In_Loop ;se contador interno é valido (j > i + 1), continua
  
  ;verifica condicao para loop externo
  inc r6          ;incrementa o contador do loop externo
  cmp r6, r1      ;compara contador do loop externo com o tamano do vetor
  jle Bubble_Sort_Out_Loop ;se i <= tamanho_vetor continua o loop externo
 
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  
  rts
  
  
;********************************PRINT VECTOR***************************/
PrintVector:   ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela

  loadn r4, #' '  ;espaco que servira como separador entre os elementos
  loadn r5, #0    ;r5 -> contador: conta os elementos que estao sendo impressos
  loadn r6, #48   ;correcao para imprimir o numero como caracter, pois 0 = 48

PrintVector_Loop:
  loadi r3, r0    ;carrega conteudo de r0 em r3 (r0 é ponteiro pro vetor)
  add r3, r3, r6  ;soma 48 pra imprimir como caractere
  outchar r3, r2  ;imprime o caractere
  inc r2          ;incrementa posicao da tela
  outchar r4, r2  ;imprime espaco
  inc r0	  ;incrementa posicao do vetor
  inc r2          ;incrementa posicao da tela
  inc r5          ;incrementa contador dos elementos impressos
  cmp r5, r1      ;compara se nao chegou ao fim do vetor
  jne PrintVector_Loop ;se nao chegou ao fim continua imprimindo
  
  rts

  
;****************************SWAP(vec, i, j)***************************/  
SwapVectorElement: ;r0->vector, r1->pos1, r2->pos2
  push r0
  push r1
  push r2
  push r3
  push r4 
  push r5
  push r6
  
  mov r3, r0  ;bk do ponteiro para vetor
  
  ;grava primeiro elemento vec[i]
  add r3, r0, r1  ;ajusta a posicao (r0 + r1)
  loadi r4, r3   ;r4 = vec[i]
  
  ;grava segundo elemento vec[j]
  add r5, r0, r2  ;r5 tem a posicao do elemento vec[j]
  loadi r6, r5    ;r6 = vec[j]
  
  storei r3, r6
  storei r5, r4
  
  pop r6
  pop r5
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
  
  rts
  
  
;************************IMPRIME STRING*********************************

ImprimeString:  ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa

  push r0 ;backup nos registradores
  push r1
  push r2
  push r3
  push r4
  
  loadn r2, #'\0'  ;usado na comparacao
  
  
ImprimeString_Loop:

  loadi r3, r1      ; r3 <= conteudo da primeira posicao do vetor
  cmp r3, r2 ;compara conteudo de r3 e r2
  jeq ImprimeString_Sai  ;igual \0 => sai da rotina
  outchar r3, r0	;imprime r3 na posicao r0
  inc r0		;incrementa a posicao da tela de 1
  inc r1		;incrementa a posicao da string de 1
  
  jmp ImprimeString_Loop
  
  
ImprimeString_Sai:


  mov r6, r0 ;grava a ultima posicao da tela em r6
  
  pop r4
  pop r3
  pop r2
  pop r1
  pop r0
  
  rts
  
  
  