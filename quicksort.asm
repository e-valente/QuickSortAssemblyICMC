jmp main

; ------ Programa Principal -----------

msg1: string "Vetor sem ordenar: "
msg2: string "Vetor ordenado: "
msg3: string "Vetor invalido! (max 20 elementos)"
;msg1: string "Digite a primeira string: "
;msg2: string "Digite a segunda string: "
;msg3: string "Resultado: "
;str1: var #40
str2: var #40
vec1: var #40
vec2: var #40



main:

	;constroi vetor
	call SetVector

	
	
	

	
	;executa partition
	loadn r0, #vec1
	loadn r1, #0
	loadn r2, #4
	call QuickSort
	
	push r7          ;guarda endereco do vetor ordenado
	
	
	
	;imprime primeira msg
	loadn r1, #msg1
	loadn r0, #0
	call ImprimeString    ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa

	
	;imprime vetor
	loadn r0, #vec1
	loadn r1, #5
	loadn r2, #40
	call PrintVector  ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela
	
	
		
	;imprime segunda msg
	loadn r1, #msg2
	loadn r0, #120
	call ImprimeString    ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa
	
	
	;imprime vetor ordenado
	;imprime vetor
	pop r0             ;recebe da pilha o endereco do vetor ordenado (retornado pelo qsort())
	loadn r1, #5
	loadn r2, #160
	call PrintVector  ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela
	
	
	halt
	
	
;*********************************SET VECTOR***************************/
SetVector:

  push r0
  push r1

  loadn r0, #vec1
  loadn r1, #5   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #4   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #3   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #2   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  inc r0
  loadn r1, #1   ;carrega r1 com o valor #x
  storei r0, r1 ;armazina o conteudo de r1 na memoria apontada por r0
  
  
  
  pop r1
  pop r0
  
 
  
  rts
  
  
  
  
;****************************QUICKSORT*****************************************
QuickSort: ;r0->vector, r1->left, r2->right  retorna vetor ordenado em r7
;r3 = cuttof


  ;*****verifica se não ultrapassou os limites (20)
  push r1
  push r2
  ;obtem o tamanho do vetor
  sub r1, r2, r1
  inc r1
  loadn r2, #20
  cmp r1, r2
  ceg ImprimeVetorInvalido
  
  pop r2
  pop r1
  ;******fim da verificao da ultrapassagem dos limites
  
  

 ;****copia vetor*****************
  push r1
  push r2
  
  loadn r0, #vec1
  ;obtem o tamanho do vetor
  sub r1, r2, r1
  inc r1
  loadn r2, #vec2
  call Vectorcpy  ;copia o vetor-> r0->vector1, r1->length r2->vetor destino
  mov r3, r2
  
  pop r2
  pop r1
  ;pop r0
  ;*******fim da copia do vetor***
  
  mov r0, r3        ;r0 recebe endereco do novo vetor

  

QuickSort_in:
  loadn r4, #0
  
  cmp r2, r1
  jgr QuickSort_ExecLeftRight
  rts
  

QuickSort_ExecLeftRight:
  call Partition    ;r0->vector, r1->left, r2->right  
  mov r3, r7
  
  ;quicksort(vector, left, cuttof -1);
  push r2        ;usaremos r2 no quicksort
  mov r2, r3     ;r2 <- r3 (cuttof)
  dec r2         ;cuttof -1
  call QuickSort_in      ;r0->vector, r1->left, r2-> cuttof -1
  pop r2
  
  ;quicksort(vector, cuttof +1, right);
  push r1        ;usaremos r1 no quicksort
  mov r1, r3     ;r1 <- r3 (cuttof)
  inc r1         ;cuttof +1
  call QuickSort_in      ;r0->vector, r1->cuttof +1, r2-> right
  pop r1
 
 
QuickSort_out:

  mov r7, r0   ;retornamos o endereco do vetor ordenado em r7
     
 rts
 
 
  
  
  

Partition: ;r0->vector, r1->left, r2->right  
;r3->i
;r4->j
;r6->vect[left]
;r5->vect[j]
;r7->tmp

  push r3
  push r4
  push r5
  push r6

  ;r3 = i
  mov r3, r1   ;r3 = i, i = left
  

  ;j = left+1
  ;r4 = j
  mov r4, r1   ;r4 = j = left 
  inc r4       ;r4 = j++
  
LoopPartition:

  ;obtem v[left], que será armazenado 
  ;em r6
  add r7, r0, r1    ;r7 = &vect[left]
  loadi r6, r7      ;r6 = vect[left]
  
  ;obtem v[j], que será armazenado em
  ;r5
  add r7, r0, r4    ;r7 = &vect[j]
  loadi r5, r7      ;r5 = vect[j]
  
  ;if(vector[left] > vector[j]) 
  cmp r6, r5       
  jgr IncSwapPartition_in
  
IncSwapPartition_out:

  ;condicao pra iteracao do laco
  ;se j <= right => loop
  inc r4           ;j++
  cmp r4, r2
  jel LoopPartition
  
  ;executa o swap fora do laco
  ;swap(vector, left, i);
  push r2             ;preciso usar r2 na swap
  mov r2, r3          ;r2 = i
  call SwapVectorElement  ;r0->vec, r1->left, r2->i
  pop r2
  
  jmp Partition_final

  
IncSwapPartition_in:
  inc r3
  
  push r1
  push r2
  
  mov r1, r3
  mov r2, r4
  
  call SwapVectorElement 
  
  pop r2
  pop r1
  
  jmp IncSwapPartition_out
  
  
Partition_final:
  ;retorna i (em r7)
  mov r7, r3
  
  pop r6
  pop r5
  pop r4
  pop r3
  
  
  rts
  
  
;********************************PRINT VECTOR***************************/
PrintVector:   ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela

  loadn r4, #','  ;espaco que servira como separador entre os elementos
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
  
  
  
;**********************Copy Vector*************************
Vectorcpy:  ;copia o vetor-> r0->vector1, r1->length r2->vetor destino
;r4->indice
;r5 -> &vecx[i]
;r6->vec1[i]


 ;empilha os registradore
  push r4
  push r5
  
  loadn r4, #0  ;i = indice
  
  
Vectorcpy_Loop:  
 
  add r5, r0, r4     ;r5 = &vect1[i]
  loadi r6, r5       ;r6 = &vect1[i]
  add r5, r2, r4    ;r5 = &vect2[i]
  storei r5, r6      ;conteudo apontado por r5 = conteudo de r6
  inc r4
  cmp r4, r1
  jle Vectorcpy_Loop
  
Vectorcpy_End:


  ;desimpilha os registradores
  pop r5
  pop r4

  
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
  
;***************** Imprime Vetor invalido
ImprimeVetorInvalido:

  loadn r1, #msg3
  loadn r0, #0
  call ImprimeString  
  
  pop r2
  pop r1
  
  halt   ;encerrao execucao
  
  
	
	

  