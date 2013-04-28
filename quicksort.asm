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
	call SetVector  ;cria o vetor e retorna em r7 seu tamanho
	push r7         ;guardamos na pilha seu tamanho
	
	;executa quicksort
	loadn r0, #vec1
	loadn r1, #0
	pop r2       	 ;r2 agora tem o tamanho do vetor
	push r2     	 ;empilha o tamanho do vetor pra ser usado no futuro      
	dec r2           ;decrementamos de 1, pois o quicksort conta o elemento de indice zero
	;loadn r2, #21   ;descomente essa instrucao pra rotina gerar um erro (max elem permitidos)
	call QuickSort    ;r0->vector, r1->left, r2->right  retorna vetor ordenado em r7
	
	push r7          ;guarda endereco do vetor ordenado
	
	
	
	;imprime primeira msg (vetor desordenado)
	loadn r1, #msg1
	loadn r0, #0          ;r0 recebe posicao da tela
	call ImprimeString    ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa

	
	;imprime vetor (desordenado)
	loadn r0, #vec1
	pop r6              ;desimpilha o endereco do vetor ordenado (nao nos interessa)
	pop r1              ;desimpilha o tamanho do vetor
	push r1             ;empilha o tamanho do vetor 
	push r6             ;empilha a posicao do vetor ordenado
	loadn r2, #40         ;posica da tela
	call PrintVector  ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela
	
		
	;imprime segunda msg (vetor ordenado)
	loadn r1, #msg2
	loadn r0, #240        ;posicao da tela
	call ImprimeString    ;r1->posicao inicial da string, r0-> posicao inicial da tela, devolve r6 com ultima posicao impressa
	
	
	;imprime vetor ordenado
	;imprime vetor
	pop r0             ;recebe da pilha o endereco do vetor ordenado (retornado pelo qsort())
	pop r1		   ;recebe da pilha o tamanho do vetor
	push r1		   ;guardamos seu tamanho pra uso futuro
	push r0		   ;guardamos o endereco do vetor ordenado para uso futuro
	loadn r2, #280
	call PrintVector  ;r0-> vetor, r1->tamanho ;r2->posicao inicial da tela
	
	pop r1             ;como temos 2 palavras na pilha, desimpilhamos pra ficar
	pop r1             ;tudo ok!
	
	halt		   ;(encerra execucao do programa)
	

;*********************************SET VECTOR ***************************/
SetVector:   ;cria o vetor e retorna em r7 seu tamanho

  loadn r7, #0         ;contador do nro de elementos
  
  static vec1 + #0, #5   ;armazena 5 na posicao 0 (zero) do vetor
  inc r7                 ;incrementa contador de elementos
  static vec1 + #1, #4   ;armazena 4 na posicao 1 (zero) do vetor and so forth
  inc r7
  static vec1 + #2, #5
  inc r7
  static vec1 + #3, #9
  inc r7
  static vec1 + #4, #1
  inc r7
  static vec1 + #5, #8
  inc r7
  static vec1 + #6, #3
  inc r7
  static vec1 + #7, #7
  inc r7
  static vec1 + #8, #2
  inc r7
  static vec1 + #9, #3
  inc r7
  static vec1 + #10, #1
  inc r7
  static vec1 + #11, #6
  inc r7
  
  rts
    
;****************************QUICKSORT*****************************************
QuickSort: ;r0->vector, r1->left, r2->right  retorna vetor ordenado em r7
;r3 = cuttof


  ;*****verifica se não ultrapassou os limites (20)
  push r1               ;empilhamos left
  push r2               ;empilhamos right
  ;obtem o tamanho do vetor
  sub r1, r2, r1        ;tamanho = right = left
  inc r1                ;tamanho-- (quicksort conta o elemento de indice zero) 
  loadn r2, #20         ;r2 será usada pra verificao do tamanho max do vetor
  cmp r1, r2
  ceg ImprimeVetorInvalido  ;se ultrapassar o tamanho max, imprime msg e encerra execucao
  
  pop r2                 ;desimpilhamos right
  pop r1                 ;desimpilhamos left
  ;******fim da verificao da ultrapassagem dos limites
  
  

 ;****copia vetor*****************
  push r1                ;empilhamos left
  push r2                ;empilhamos right
  
  loadn r0, #vec1        ;r0 será a posicao do vetor de origem
  ;obtem o tamanho do vetor
  sub r1, r2, r1         ;r1 terá o tamanho do vetor
  inc r1
  loadn r2, #vec2         ;r2 posicao do vetor destino
  call Vectorcpy  ;copia o vetor-> r0->vector1, r1->length r2->vetor destino
  
  mov r3, r2              ;r2 recebe uma copia (bk) do tamanho do vetor
  
  pop r2                  ;desimpilhamos right (pra ser usado no quicksort)              
  pop r1                  ;desimpilhamos left  (pra ser usado no quicksort) 
  ;pop r0
  ;*******fim da copia do vetor***
  
  mov r0, r3                   ;r0 recebe endereco do novo vetor

  

QuickSort_in:                  ;rotina que será recursiva
  loadn r4, #0
  
  cmp r2, r1                  ;compara se right > left
  jgr QuickSort_ExecLeftRight ;caso seja, executa o quicksort_in dos 2 "lados" do vetor
  rts                          ; da rotina QuickSort_in
  

QuickSort_ExecLeftRight:
  call Partition    ;r0->vector, r1->left, r2->right; retorna cuttof em r7
  mov r3, r7        ;r3 tem o cuttof retornado pela partition
  
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
 
 
  
  
  

Partition: ;r0->vector, r1->left, r2->right; retorna cuttof em r7
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
  loadn r7, #' '  ;espaco pra tirar a virgula da ultima posicao do vetor

PrintVector_Loop:
  loadi r3, r0    ;carrega conteudo de r0 em r3 (r0 é ponteiro pro vetor)
  add r3, r3, r6  ;soma 48 pra imprimir como caractere
  outchar r3, r2  ;imprime o caractere
  inc r2          ;incrementa posicao da tela
  outchar r4, r2  ;imprime virgula
  inc r0	  ;incrementa posicao do vetor
  inc r2          ;incrementa posicao da tela
  inc r5          ;incrementa contador dos elementos impressos
  cmp r5, r1      ;compara se nao chegou ao fim do vetor
  jne PrintVector_Loop ;se nao chegou ao fim continua imprimindo
  
  dec r2          ;decrementa posicao da tela
  outchar r7, r2  ;imprime imprime espaco depois da ultima posicao
  
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
  
  
	
	

  